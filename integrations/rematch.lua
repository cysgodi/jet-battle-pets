local _, ketchum = ...

ketchum.rematch = {}

-- is the pet with the provided ID a shiny?
local function isShiny(_, petID)
  local petInfo = Rematch.petInfo:Fetch(petID)

  if(not petInfo.speciesID or not petInfo.displayID) then
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

-- register a badge to Rematch that displays on shiny pets
function ketchum.rematch:AddShinyBadge() 
  Rematch.badges:RegisterBadge(
      "pets", 
      "shiny", 
      "Interface\\Icons\\racial_dwarf_findtreasure",
      { 0.075, 0.925, 0.075, 0.925 },
      isShiny
  )

  if( Rematch.frame:IsVisible()) then
    Rematch.frame:Update()
  end
end