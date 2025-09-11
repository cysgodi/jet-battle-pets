local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.cache = {}
JetBattlePets.cache.pets = {}

PetCache = {}

local function petGetter(_, speciesID)
  if PetCache[speciesID] ~= nil then
    return PetCache[speciesID]
  end

  if C_AddOns.IsAddOnLoaded("Rematch") then
    PetCache[speciesID] = Rematch.petInfo:Fetch(speciesID)
  elseif type(speciesID) == "string" then
    PetCache[speciesID] = C_PetJournal.GetPetInfoTableByPetID(speciesID)
  else
    local name = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
    local _, petID = C_PetJournal.FindPetIDByName(name)

    PetCache[speciesID] = C_PetJournal.GetPetInfoTableByPetID(petID)
  end

  return PetCache[speciesID]
end

local function petSetter(_, speciesID, data)
  PetCache[speciesID] = data
end

setmetatable(JetBattlePets.cache.pets, {
  __index = petGetter,
  __newindex = petSetter
})
