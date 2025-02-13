local _, JetBattlePets = ...

-- init addon settings to empty table
JetBattlePets.settings = {}

-- init saved variables on first run
JetBattlePetsSettings = {}

-- default settings to apply on init
local DEFAULT_SETTINGS = {
  ALERT_THRESHOLD = JetBattlePets.constants.RARITIES.SHINY,

  -- flag to turn encounter data collection on/off
  ENABLE_DATA_COLLECTION = false,

  -- flag to enable/disable the variant model viewer feature
  SHOW_VARIANT_MODEL_VIEWER = false,
}

-- Fetch key from saved vars. Init the saved var to a default if it
-- doesn't exist yet.
local function getter(self, key)
  if JetBattlePetsSettings[key] == nil then
    if DEFAULT_SETTINGS[key] and type(DEFAULT_SETTINGS[key]) == "table" then
      JetBattlePetsSettings[key] = CopyTable(DEFAULT_SETTINGS[key])
    else
      JetBattlePetsSettings[key] = DEFAULT_SETTINGS[key]
    end
  end

  return JetBattlePetsSettings[key]
end

-- Set a saved var.
local function setter(self, key, value)
  JetBattlePetsSettings[key] = value
end

setmetatable(JetBattlePets.settings, {
  __index = getter,
  __newindex = setter
})
