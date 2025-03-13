local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

---Init saved variables on first run
JetBattlePetsEncounters = {}

JetBattlePets.encounters = JetBattlePetsEncounters or {}

function JetBattlePets.encounters:AddEncounter(encounter)
  table.insert(JetBattlePetsEncounters, encounter)
end
