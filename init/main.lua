local _, JetBattlePets = ...

JetBattlePets.pets = {}

-- fetch info for a pet, using Rematch if possible
function JetBattlePets.pets.GetPet(petID)
  if C_AddOns.IsAddOnLoaded("Rematch") then
    return Rematch.petInfo:Fetch(petID)
  end

  return C_PetJournal.GetPetInfoTableByPetID(petID)
end
