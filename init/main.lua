local _, ketchum = ...

ketchum.pets = {}

-- fetch info for a pet, using Rematch if possible
function ketchum.pets.GetPet(petID)
  if C_AddOns.IsAddOnLoaded("Rematch") then
    return Rematch.petInfo:Fetch(petID)
  end

  return C_PetJournal.GetPetInfoTableByPetID(petID)
end