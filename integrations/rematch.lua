local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.rematch = JetBattlePets.rematch or {}

-- get model rarity text to display on a pet card
local function DisplayModelRarity(_, petInfo)
  if not petInfo or not petInfo.speciesID or not petInfo.displayID then
    return ""
  end

  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)
  local probability = numDisplays and numDisplays > 1 and
      JetBattlePets.journal:GetDisplayProbability(
        petInfo.speciesID,
        petInfo.displayID
      ) or 100
  local maxProbability = JetBattlePets.journal:GetMaxDisplayProbability(
    petInfo.speciesID
  )

  return JetBattlePets.text:GetRarityText(
    probability,
    maxProbability
  )
end

-- get variant stat text to display on a pet card
local function DisplayVariantCount(_, petInfo)
  if not petInfo or not petInfo.speciesID then
    return ""
  end

  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)

  if numDisplays < 1 then
    numDisplays = 1
  end

  local variantCountString = tostring(numDisplays)

  if C_PetJournal.PetUsesRandomDisplay(petInfo.speciesID)
  then
    local randomIcon = CreateAtlasMarkup("lootroll-icon-need")

    variantCountString = string.format("%d %s", numDisplays, randomIcon)
  end

  return variantCountString
end

-- create a frame to display all variant models of a pet species
local function DisplayVariantModels(_, petInfo)
  local VariantModels = JetBattlePets.frames.VariantModelsWindow
  VariantModels:SetModels(petInfo.speciesID)
end

-- get text to display on the tooltip for pet card variant stats
local function DisplayVariantCountTooltip(self, petInfo)
  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)
  local variantCount = numDisplays > 0 and numDisplays or 1
  local variantText = variantCount > 1 and "Variants" or "Variant"

  local baseText = "How many unique models does this pet species have?\n\n"
      .. string.format("%d %s: ", variantCount, variantText)
  if numDisplays <= 1 then
    return baseText .. JetBattlePets.text:GetRarityText(100, 100)
  end

  local tooltipBody = baseText

  if C_PetJournal.PetUsesRandomDisplay(petInfo.speciesID)
  then
    local randomIcon = CreateAtlasMarkup("lootroll-icon-need")
    local randomDisclaimer = "When this pet is summoned, its model is randomly chosen from all possible species models."

    local randomText = string.format("\n\n%s %s\n\n", randomIcon, randomDisclaimer)

    tooltipBody = tooltipBody .. randomText
  end

  for slot = 1, numDisplays do
    if slot ~= 1 then
      tooltipBody = tooltipBody .. " / "
    end

    tooltipBody = tooltipBody .. JetBattlePets.journal:GetDisplayIndexProbabilityText(
      petInfo.speciesID,
      slot
    )
  end

  tooltipBody = tooltipBody .. "\n\n"

  return tooltipBody
end

-- should variant stats be shown for a pet?
local function ShouldShowVariants(_, petInfo)
  if not petInfo
      or not petInfo.speciesID
  then
    return false
  end

  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)

  return numDisplays and numDisplays >= 0
end

-- does a species of pet have a shiny variant?
local function HasShiny(petInfo)
  if not petInfo.speciesID
  then
    return false
  end

  local numVariants = C_PetJournal.GetNumDisplays(petInfo.speciesID)

  if (numVariants <= 1) then
    return false
  end

  local maxProbability = JetBattlePets.journal:GetMaxDisplayProbability(petInfo.speciesID)

  for i = 1, numVariants do
    local probability = C_PetJournal.GetDisplayProbabilityByIndex(petInfo.speciesID, i)

    local ratio = maxProbability / probability

    if (ratio >= JetBattlePets.constants.RARITY_RATIOS.SHINY) then
      return true
    end
  end

  return false
end

-- is the given pet shiny?
local function IsShiny(petInfo)
  if (
        not petInfo.speciesID
        or not petInfo.displayID
        or not petInfo.count
        or not petInfo.isWild
      ) then
    return false
  end

  local displayIdIndex = JetBattlePets.journal:GetDisplayIndex(
    petInfo.speciesID,
    petInfo.displayID
  )

  if not displayIdIndex then
    return false
  end

  local maxProbability = JetBattlePets.journal:GetMaxDisplayProbability(petInfo.speciesID)

  local probability = C_PetJournal.GetDisplayProbabilityByIndex(petInfo.speciesID, displayIdIndex)

  local ratio = maxProbability / probability

  return ratio >= JetBattlePets.constants.RARITY_RATIOS.SHINY
end

-- is the pet with the provided ID a shiny?
local function JournalEntryIsShiny(_, petID)
  local petInfo = Rematch.petInfo:Fetch(petID)

  return IsShiny(petInfo)
end

function JetBattlePets.rematch:AddIsShinyBadge()
  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

  Rematch.badges:RegisterBadge(
    "pets",
    "IsShiny",
    atlas.file,
    { JetBattlePets.atlas:GetTexCoords(atlas) },
    JournalEntryIsShiny
  )

  if (Rematch.frame:IsVisible()) then
    Rematch.frame:Update()
  end
end

function JetBattlePets.rematch:AddModelRarity()
  local atlasName = JetBattlePets.constants.ATLAS_NAMES.MODEL_RARITY_ICON
  local atlas = C_Texture.GetAtlasInfo(atlasName)

  table.insert(Rematch.petCardStats, {
    icon = atlas.file,
    iconCoords = { JetBattlePets.atlas:GetTexCoords(atlas) },
    tooltipTitle = "Model Rarity",
    tooltipBody = "How rare is this specific model?",
    show = true,
    value = DisplayModelRarity
  })
end

function JetBattlePets.rematch:AddVariantStats()
  local atlasName = JetBattlePets.constants.ATLAS_NAMES.SHINY_ICON
  local atlas = C_Texture.GetAtlasInfo(atlasName)

  table.insert(Rematch.petCardStats, {
    click = DisplayVariantModels,
    icon = atlas.file,
    iconCoords = { JetBattlePets.atlas:GetTexCoords(atlas) },
    tooltipTitle = "Variants",
    tooltipBody = DisplayVariantCountTooltip,
    show = ShouldShowVariants,
    value = DisplayVariantCount
  })
end

-- add filter to find species that use a random model
local function AddHasRandomModelFilter()
  Rematch.menus:AddToMenu("PetOther", {
    check = true,
    func = Rematch.petFilterMenu.ToggleChecked,
    group = "Other",
    isChecked = Rematch.petFilterMenu.GetChecked,
    key = "HasRandomModel",
    text = "Uses Random Model"
  })

  function Rematch.filters.otherFuncs:HasRandomModel(petInfo)
    return petInfo.speciesID and C_PetJournal.PetUsesRandomDisplay(petInfo.speciesID)
  end
end

-- add filter to find species that have a shiny variant
local function AddHasShinyFilter()
  Rematch.menus:AddToMenu("PetOther", {
    check = true,
    func = Rematch.petFilterMenu.ToggleChecked,
    group = "Other",
    isChecked = Rematch.petFilterMenu.GetChecked,
    key = "HasShiny",
    radioGroup = "Has Shiny",
    text = "Has Shiny"
  })

  function Rematch.filters.otherFuncs:HasShiny(petInfo)
    return HasShiny(petInfo)
  end
end

-- add filter to find shiny models
local function AddIsShinyFilter()
  Rematch.menus:AddToMenu("PetOther", {
    check = true,
    func = Rematch.petFilterMenu.ToggleChecked,
    group = "Other",
    isChecked = Rematch.petFilterMenu.GetChecked,
    key = "IsShiny",
    radioGroup = "Is Shiny",
    text = "Is Shiny",
  })

  function Rematch.filters.otherFuncs:IsShiny(petInfo)
    return IsShiny(petInfo)
  end
end

function JetBattlePets.rematch:AddVariantFilters()
  Rematch.menus:AddToMenu("PetOther", { spacer = true, text = "" })

  AddIsShinyFilter()
  AddHasShinyFilter()
  AddHasRandomModelFilter()
end
