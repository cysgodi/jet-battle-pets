local _, ketchum = ...

ketchum.rematch = {}

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
  local commonTextColor = "|c00ffffff"
  local uncommonTextColor = "|c0000ff00"
  local rareTextColor = "|c000000ff"
  local shinyTextColor = "|c00ffff00"
  local endTextColor = "|r"
  local shinyIcon = CreateAtlasMarkup("rare-elite-star") 

  if numDisplays <= 1 then
    return baseText..commonTextColor.."100%"..endTextColor
  end

  local tooltipBody = baseText

  for slot = 1, numDisplays do
    if slot ~= 1 then
      tooltipBody = tooltipBody.." / "
    end

    local probability = C_PetJournal.GetDisplayProbabilityByIndex(
      petInfo.speciesID, 
      slot
    )

    local probabilityText = 
      probability > 70 and commonTextColor
        ..format("%.2f%%", probability)
        ..endTextColor 
      or probability > 40 and uncommonTextColor
        ..format("%.2f%%", probability)
        ..endTextColor 
      or probability > 10 and rareTextColor
        ..format("%.2f%%", probability)
        ..endTextColor 
      or shinyTextColor..shinyIcon.." "
        ..format("%.2f%%", probability)
        ..endTextColor 

    tooltipBody = tooltipBody..probabilityText
  end

  return tooltipBody
end



-- should variant stats be shown for a pet?
local function ShouldShowVariants(_, petInfo)
  if not petInfo or not petInfo.speciesID then
    return false
  end

  return  C_PetJournal.GetNumDisplays(petInfo.speciesID) >= 0
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
    tooltipBody = DisplayVariantCountTooltip,
    show = ShouldShowVariants,
    value = DisplayVariantCount
  })
end