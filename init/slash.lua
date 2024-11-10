local _, ketchum = ...

SLASH_KETCHUM1 = "/ketchum"

local function ToggleDataCollection(switch)
  if switch == "on" then
    print("Data collection enabled")
    ketchum.settings.ENABLE_DATA_COLLECTION = true
  elseif switch == "off" then
    print("Data collection disabled")
    ketchum.settings.ENABLE_DATA_COLLECTION = false
  end
end

local SlashCommands = {
  record = ToggleDataCollection
}

SlashCmdList["KETCHUM"] = function(message)
  local arg1, arg2, arg3 = strsplit(" ", message)

  if SlashCommands[arg1] then
    SlashCommands[arg1](arg2, arg3)
  end
end
