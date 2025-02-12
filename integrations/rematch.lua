local _, ketchum = ...

ketchum.rematch = {}

-- get model rarity text to display on a pet card
local function DisplayModelRarity(_, petInfo)
  if not petInfo or not petInfo.speciesID or not petInfo.displayID then
    return ""
  end

  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)
  local probability = numDisplays and numDisplays > 1 and
      ketchum.journal:GetDisplayProbability(
        petInfo.speciesID,
        petInfo.displayID
      ) or 100
  local maxProbability = ketchum.journal:GetMaxDisplayProbability(
    petInfo.speciesID
  )

  return ketchum.text:GetRarityText(
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

  if C_PetJournal.PetUsesRandomDisplay(petInfo.speciesID)
  then
    local randomIcon = CreateAtlasMarkup("lootroll-icon-need")

    numDisplays = string.format("%d %s", numDisplays, randomIcon)
  end

  return numDisplays
end

-- create a frame to display all variant models of a pet species
local function DisplayVariantModels(_, petInfo)
  if not ketchum.settings.SHOW_VARIANT_MODEL_VIEWER then
    return
  end

  local VariantModels = ketchum.frames.VariantModelsWindow

  if VariantModels:IsShown()
      and VariantModels.displayedSpeciesID == petInfo.speciesID
  then
    VariantModels:Hide()
    return
  end

  VariantModels:UpdateModels(petInfo)
  VariantModels:Show()
end

-- get text to display on the tooltip for pet card variant stats
local function DisplayVariantCountTooltip(self, petInfo)
  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)
  local variantCount = numDisplays > 0 and numDisplays or 1
  local variantText = variantCount > 1 and "Variants" or "Variant"

  local baseText = "How many unique models does this pet species have?\n\n"
      .. string.format("%d %s: ", variantCount, variantText)
  if numDisplays <= 1 then
    return baseText .. ketchum.text:GetRarityText(100, 100)
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

    local probability = C_PetJournal.GetDisplayProbabilityByIndex(
      petInfo.speciesID,
      slot
    ) or 100

    local maxProbability = ketchum.journal:GetMaxDisplayProbability(petInfo.speciesID)

    local probabilityText = ketchum.text:GetRarityText(
      probability,
      maxProbability
    )

    tooltipBody = tooltipBody .. probabilityText
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
      or ketchum.journal:IsIgnored(petInfo.speciesID)
  then
    return false
  end

  local numVariants = C_PetJournal.GetNumDisplays(petInfo.speciesID)

  if (numVariants <= 1) then
    return false
  end

  local maxProbability = ketchum.journal:GetMaxDisplayProbability(petInfo.speciesID)

  for i = 1, numVariants do
    local probability = C_PetJournal.GetDisplayProbabilityByIndex(petInfo.speciesID, i)

    local ratio = maxProbability / probability

    if (ratio >= ketchum.constants.RARITY_RATIOS.SHINY) then
      return true
    end
  end

  return false
end

-- does a species of pet have a shiny variant, and is it unowned?
local function HasShinyAndNoneOwned(petInfo)
  return (not petInfo.count or petInfo.count == 0) and HasShiny(petInfo)
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

  local displayIdIndex = ketchum.journal:GetDisplayIndex(
    petInfo.speciesID,
    petInfo.displayID
  )

  if not displayIdIndex then
    return false
  end

  local maxProbability = ketchum.journal:GetMaxDisplayProbability(petInfo.speciesID)

  local probability = C_PetJournal.GetDisplayProbabilityByIndex(petInfo.speciesID, displayIdIndex)

  local ratio = maxProbability / probability

  return ratio >= ketchum.constants.RARITY_RATIOS.SHINY
end

-- does the pet with the provided ID have a shiny variant?
local function JournalEntryHasShiny(_, petID)
  local petInfo = Rematch.petInfo:Fetch(petID)

  return HasShinyAndNoneOwned(petInfo)
end

-- is the pet with the provided ID a shiny?
local function JournalEntryIsShiny(_, petID)
  local petInfo = Rematch.petInfo:Fetch(petID)

  return IsShiny(petInfo)
end

-- register a badge to Rematch that displays on shiny pets
function ketchum.rematch:AddIsShinyBadge()
  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

  Rematch.badges:RegisterBadge(
    "pets",
    "IsShiny",
    atlas.file,
    { ketchum.atlas:GetTexCoords(atlas) },
    JournalEntryIsShiny
  )

  if (Rematch.frame:IsVisible()) then
    Rematch.frame:Update()
  end
end

-- add model rarity to Rematch pet cards
function ketchum.rematch:AddModelRarity()
  local atlas = ketchum.constants.GRAPHICS.MODEL_RARITY_ATLAS

  table.insert(Rematch.petCardStats, {
    icon = atlas.file,
    iconCoords = { ketchum.atlas:GetTexCoords(atlas) },
    tooltipTitle = "Model Rarity",
    tooltipBody = "How rare is this specific model?",
    show = true,
    value = DisplayModelRarity
  })
end

-- add variant stats to Rematch pet cards
function ketchum.rematch:AddVariantStats()
  local atlas = ketchum.constants.GRAPHICS.SHINY_ATLAS

  table.insert(Rematch.petCardStats, {
    click = DisplayVariantModels,
    icon = atlas.file,
    iconCoords = { ketchum.atlas:GetTexCoords(atlas) },
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

-- add rematch filters for pet variants
function ketchum.rematch:AddVariantFilters()
  Rematch.menus:AddToMenu("PetOther", { spacer = true, text = "" })

  AddIsShinyFilter()
  AddHasShinyFilter()
  AddHasRandomModelFilter()
end
