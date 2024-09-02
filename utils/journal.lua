local _, ketchum = ...

ketchum.journal = {}

-- return the probability of encountering a specific skin in a species
function ketchum.journal:GetDisplayProbability(speciesID, displayID)
  local displayIdIndex = ketchum.journal:GetDisplayIndex(
    speciesID, 
    displayID
  )

  local probability

  if displayIdIndex then
    probability = C_PetJournal.GetDisplayProbabilityByIndex(
      speciesID, 
      displayIdIndex
    )
  end

  return probability
end

-- determine the index of a specific display ID of a specific species
function ketchum.journal:GetDisplayIndex(speciesID, displayID)
  local numDisplays = C_PetJournal.GetNumDisplays(speciesID)

  if not numDisplays then
    return nil
  end

  local displayIdIndex

  for i = 1, numDisplays do
    local _displayID = C_PetJournal.GetDisplayIDByIndex(speciesID, i)

    if _displayID == displayID then
      displayIdIndex = i
    end
  end

  return displayIdIndex
end