local _, ketchum = ...

ketchum.rematch = {}

-- get variant stat text to display on a pet card
local function DisplayVariantStats(_, petInfo)
  if not petInfo or not petInfo.speciesID then
    return ""
  end

  return C_PetJournal.GetNumDisplays(petInfo.speciesID)
end

-- should variant stats be shown for a pet?
local function ShouldShowVariants(_, petInfo)
  if not petInfo or not petInfo.speciesID then
    return false
  end

  return C_PetJournal.GetNumDisplays(petInfo.speciesID) > 0
end

-- does the species with the provided ID have a shiny variant?
local function hasShiny(_, petID)
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
local function isShiny(_, petID)
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

  return probability <= 10
end

function ketchum.rematch:AddHasShinyBadge()
  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

  Rematch.badges:RegisterBadge(
    "pets",
    "hasShiny",
    atlas.file,
    { 0.936, 0.998, 0.502, 0.564 },
    hasShiny
  )
end

-- register a badge to Rematch that displays on shiny pets
function ketchum.rematch:AddIsShinyBadge() 
  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

  Rematch.badges:RegisterBadge(
      "pets", 
      "isShiny", 
      atlas.file,
      { 0.936, 0.998, 0.502, 0.564 },
      isShiny
  )

  if( Rematch.frame:IsVisible()) then
    Rematch.frame:Update()
  end
end

-- add variant stats to Rematch pet cards
function ketchum.rematch:AddVariantStats()
  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

  tinsert(Rematch.petCardStats, {
    icon = atlas.file,
    iconCoords = { 0.936, 0.998, 0.502, 0.564 },
    tooltipTitle = "Variants",
    tooltipBody = "How many unique models does this pet species have?",
    show = ShouldShowVariants,
    value = DisplayVariantStats
  })
end