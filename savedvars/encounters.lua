local _, JetBattlePets = ...

-- init saved variables on first run
JetBattlePetsEncounters = {}

JetBattlePets.encounters = {}

function JetBattlePets.encounters:AddEncounter(encounter)
  table.insert(JetBattlePetsEncounters, encounter)
end
