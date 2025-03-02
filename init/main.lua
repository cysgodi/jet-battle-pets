local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.pets = JetBattlePets.pets or {}

-- fetch info for a pet, using Rematch if possible
function JetBattlePets.pets.GetPet(petID)
  if C_AddOns.IsAddOnLoaded("Rematch") then
    return Rematch.petInfo:Fetch(petID)
  end

  return C_PetJournal.GetPetInfoTableByPetID(petID)
end
