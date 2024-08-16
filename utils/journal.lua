local _, ketchum = ...

ketchum.journal = {}

-- determine the index of a specific display ID of a specific species
function ketchum.journal:GetDisplayIndex(speciesID, displayID)
  local numDisplays = C_PetJournal.GetNumDisplays(speciesID)

  local displayIdIndex

  for i = 1, numDisplays do
    local _displayID = C_PetJournal.GetDisplayIDByIndex(speciesID, i)

    if _displayID == displayID then
      displayIdIndex = i
    end
  end

  return displayIdIndex
end