local _, JetBattlePets = ...

SLASH_JET_BATTLE_PETS1 = "/jet"

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
  record = ToggleDataCollection
}

SlashCmdList["JET_BATTLE_PETS"] = function(message)
  local arg1, arg2 = strsplit(" ", message)

  if SlashCommands[arg1] then
    SlashCommands[arg1](arg2)
  end
end
