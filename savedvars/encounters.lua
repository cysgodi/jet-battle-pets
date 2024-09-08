local _, ketchum = ...

-- init saved variables on first run
KetchumEncounters = {}

ketchum.encounters = {}

function ketchum.encounters:AddEncounter(encounter)
  table.insert(KetchumEncounters, encounter)
end