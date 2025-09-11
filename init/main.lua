local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.pets = JetBattlePets.pets or {}

-- fetch info for a pet, using Rematch if possible
function JetBattlePets.pets.GetPet(petOrSpeciesID)
  return JetBattlePets.cache.pets[petOrSpeciesID]
end

function JetBattlePets.pets.GetPets(petOrSpeciesIDs)
  local pets = {}

  JetBattlePets.array:Each(petOrSpeciesIDs, function(petOrSpeciesID)
    table.insert(pets, JetBattlePets.pets.GetPet(petOrSpeciesID))
  end)

  return pets
end
