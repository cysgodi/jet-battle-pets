local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.pets = JetBattlePets.pets or {}

-- fetch info for a pet, using Rematch if possible
function JetBattlePets.pets.GetPet(petOrSpeciesID)
  if C_AddOns.IsAddOnLoaded("Rematch") then
    return Rematch.petInfo:Fetch(petOrSpeciesID)
  end

  if type(petOrSpeciesID) == "string" then
    return C_PetJournal.GetPetInfoTableByPetID(petOrSpeciesID)
  end

  return C_PetJournal.GetPetInfoTableBySpeciesID(petOrSpeciesID)
end
