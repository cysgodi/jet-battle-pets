local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.cache.maps = {}
MapCache = {}

local function mapGetter(_, mapID)
  if MapCache[mapID] ~= nil then
    return MapCache[mapID]
  end

  local petIdSet = {}
  local map = C_Map.GetMapInfo(mapID)
  local originalFilter = C_PetJournal.GetSearchFilter()
  C_PetJournal.SetSearchFilter(map.name)

  local numPets = C_PetJournal.GetNumPets()

  for index = 1, numPets do
    local _, speciesID = C_PetJournal.GetPetInfoByIndex(index)
    petIdSet[speciesID] = true
  end

  local petIdArray = {}

  for petId in pairs(petIdSet) do
    table.insert(petIdArray, petId)
  end

  map.petIDs = petIdArray
  MapCache[mapID] = map

  C_PetJournal.SetSearchFilter(originalFilter)

  return MapCache[mapID]
end

local function mapSetter(_, mapID, data)
  MapCache[mapID] = data
end

setmetatable(JetBattlePets.cache.maps, {
  __index = mapGetter,
  __newindex = mapSetter
})
