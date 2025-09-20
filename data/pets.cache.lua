local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.cache = {}
JetBattlePets.cache.pets = {}

PetCache = {}

local function getter(_, petOrSpeciesID)
  if PetCache[petOrSpeciesID] ~= nil then
    return PetCache[petOrSpeciesID]
  end

  if type(petOrSpeciesID) == "string" then
    local info = C_PetJournal.GetPetInfoTableByPetID(petOrSpeciesID)

    PetCache[info.speciesID] = info
  else
    local name,
    icon,
    petType,
    creatureID,
    sourceText,
    description,
    isWild,
    canBattle,
    tradable,
    unique,
    obtainable,
    displayID =
        C_PetJournal.GetPetInfoBySpeciesID(petOrSpeciesID)

    PetCache[petOrSpeciesID] = {
      canBattle = canBattle,
      creatureID = creatureID,
      description = description,
      displayID = displayID,
      icon = icon,
      isWild = isWild,
      name = name,
      obtainable = obtainable,
      petType = petType,
      speciesID = petOrSpeciesID,
      sourceText = sourceText,
      tradable = tradable,
      unique = unique,
    }
  end

  return PetCache[petOrSpeciesID]
end

local function setter(_, speciesID, data)
  PetCache[speciesID] = data
end

setmetatable(JetBattlePets.cache.pets, {
  __index = getter,
  __newindex = setter
})
