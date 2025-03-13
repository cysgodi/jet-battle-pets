local _, _JetBattlePets = ...

---@type JetBattlePets
JetBattlePets = _JetBattlePets

SLASH_JET_BATTLE_PETS1 = "/jet"

local function AnalyzeSpeciesRarity(speciesID)
  local commons = 0
  local count = 0
  local poors = 0
  local rares = 0
  local uncommons = 0

  print("Analyzing species " .. speciesID .. " in " .. #JetBattlePetsEncounters .. " encounters")

  for _, encounter in ipairs(JetBattlePetsEncounters) do
    if encounter.speciesID == tonumber(speciesID) then
      count = count + 1

      if encounter.rarity == Enum.BattlePetBreedQuality.Common then
        commons = commons + 1
      elseif encounter.rarity == Enum.BattlePetBreedQuality.Poor then
        poors = poors + 1
      elseif encounter.rarity == Enum.BattlePetBreedQuality.Rare then
        rares = rares + 1
      elseif encounter.rarity == Enum.BattlePetBreedQuality.Uncommon then
        uncommons = uncommons + 1
      end
    end
  end

  local poorPercent = string.format("(%.2f%%)", poors / count * 100)
  local commonsPercent = string.format("(%.2f%%)", commons / count * 100)
  local uncommonsPercent = string.format("(%.2f%%)", uncommons / count * 100)
  local raresPercent = string.format("(%.2f%%)", rares / count * 100)

  print("Poor:", poors, poorPercent)
  print("Common:", commons, commonsPercent)
  print("Uncommon:", uncommons, uncommonsPercent)
  print("Rare:", rares, raresPercent)
  print("Total:", count)
end

local function AnalyzeBattlePetData(analysisType, speciesID)
  if analysisType == 'rarity' then
    AnalyzeSpeciesRarity(speciesID)
    return
  end

  print("Invalid analysis type")
end

local function ToggleDataCollection(switch)
  if switch == "on" then
    print("Data collection enabled")
    JetBattlePets.settings.ENABLE_DATA_COLLECTION = true
  elseif switch == "off" then
    print("Data collection disabled")
    JetBattlePets.settings.ENABLE_DATA_COLLECTION = false
  end
end

local SlashCommands = {
  analyze = AnalyzeBattlePetData,
  record = ToggleDataCollection,
}

SlashCmdList["JET_BATTLE_PETS"] = function(message)
  local tokens = { strsplit(" ", message) }
  local command = tokens[1]
  local args = JetBattlePets.array:Slice(tokens, 2)

  if SlashCommands[command] then
    SlashCommands[command](unpack(args))
    return
  end

  print("JET Battle Pets: Command not recognized")
end
