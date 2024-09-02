local _, ketchum = ...

ketchum.rematch = {}

-- get model rarity text to display on a pet card
local function DisplayModelRarity(_, petInfo)
  if not petInfo or not petInfo.speciesID or not petInfo.displayID then
    return ""
  end

  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)

  return ketchum.text:GetRarityText(
    numDisplays and numDisplays > 1 and
      ketchum.journal:GetDisplayProbability(
        petInfo.speciesID, 
        petInfo.displayID
      ) or
      100
  )
end

-- get variant stat text to display on a pet card
local function DisplayVariantCount(_, petInfo)
  if not petInfo or not petInfo.speciesID then
    return ""
  end

  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)

  if numDisplays < 1 then
    return 1
  end

  return numDisplays
end

-- get text to display on the tooltip for pet card variant stats
local function DisplayVariantCountTooltip(_, petInfo)
  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)
  local variantCount = numDisplays > 0 and numDisplays or 1
  local colorText = variantCount > 1 and "Colors" or "Color"

  local baseText = "How many unique models does this pet species have?\n\n"
    ..format("%d %s: ", variantCount, colorText)
  if numDisplays <= 1 then
    return baseText..ketchum.text:GetRarityText(100)
  end

  local tooltipBody = baseText

  for slot = 1, numDisplays do
    if slot ~= 1 then
      tooltipBody = tooltipBody.." / "
    end

    local probability = C_PetJournal.GetDisplayProbabilityByIndex(
      petInfo.speciesID, 
      slot
    ) or 100

    local probabilityText = ketchum.text:GetRarityText(probability)

    tooltipBody = tooltipBody..probabilityText
  end

  return tooltipBody
end

-- should variant stats be shown for a pet?
local function ShouldShowVariants(_, petInfo)
  if not petInfo or not petInfo.speciesID then
    return false
  end

  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)

  return  numDisplays and numDisplays >= 0
end

-- does the species with the provided ID have a shiny variant?
local function HasShiny(_, petID)
  local petInfo = Rematch.petInfo:Fetch(petID)

  if(
    not petInfo.speciesID
    or not petInfo.isWild
    or (petInfo.count and petInfo.count > 0)
  ) then
    return false
  end

  local numVariants = C_PetJournal.GetNumDisplays(petInfo.speciesID)

  if(numVariants <= 1) then
    return false
  end

  for i = 1, numVariants do
    local probability = C_PetJournal.GetDisplayProbabilityByIndex(petInfo.speciesID, i)

    if(probability <= ketchum.DEFAULT_SHINY_THRESHOLD) then
      return true
    end
  end

  return false
end

-- is the pet with the provided ID a shiny?
local function IsShiny(_, petID)
  local petInfo = Rematch.petInfo:Fetch(petID)

  if(
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

  local probability = C_PetJournal.GetDisplayProbabilityByIndex(petInfo.speciesID, displayIdIndex)

  return probability <= ketchum.settings.THRESHOLDS.SHINY
end

function ketchum.rematch:AddHasShinyBadge()
  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

  Rematch.badges:RegisterBadge(
    "pets",
    "HasShiny",
    atlas.file,
    ketchum.atlas:GetTexCoords(atlas),
    HasShiny
  )
end

-- register a badge to Rematch that displays on shiny pets
function ketchum.rematch:AddIsShinyBadge() 
  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

  Rematch.badges:RegisterBadge(
      "pets", 
      "IsShiny", 
      atlas.file,
      ketchum.atlas:GetTexCoords(atlas),
      IsShiny
  )

  if( Rematch.frame:IsVisible()) then
    Rematch.frame:Update()
  end
end

-- add variant stats to Rematch pet cards
function ketchum.rematch:AddVariantStats()
  local atlas = ketchum.constants.GRAPHICS.SHINY_ATLAS

  tinsert(Rematch.petCardStats, {
    icon = atlas.file,
    iconCoords = ketchum.atlas:GetTexCoords(atlas),
    tooltipTitle = "Variants",
    tooltipBody = DisplayVariantCountTooltip,
    show = ShouldShowVariants,
    value = DisplayVariantCount
  })
end

-- add model rarity to Rematch pet cards
function ketchum.rematch:AddModelRarity()
  local atlas = ketchum.constants.GRAPHICS.MODEL_RARITY_ATLAS

  tinsert(Rematch.petCardStats, {
    icon = atlas.file,
    iconCoords = ketchum.atlas:GetTexCoords(atlas),
    tooltipTitle = "Model Rarity",
    tooltipBody = "How rare is this specific model?",
    show = true,
    value = DisplayModelRarity
  })
end