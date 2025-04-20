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

  local name = C_PetJournal.GetPetInfoBySpeciesID(petOrSpeciesID)
  local _, petID = C_PetJournal.FindPetIDByName(name)

  return C_PetJournal.GetPetInfoTableByPetID(petID)
end
