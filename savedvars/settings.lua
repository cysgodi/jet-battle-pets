local _, JetBattlePets = ...

-- init addon settings to empty table
JetBattlePets.settings = {}

-- init saved variables on first run
KetchumSettings = {}

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
  if KetchumSettings[key] == nil then
    if DEFAULT_SETTINGS[key] and type(DEFAULT_SETTINGS[key]) == "table" then
      KetchumSettings[key] = CopyTable(DEFAULT_SETTINGS[key])
    else
      KetchumSettings[key] = DEFAULT_SETTINGS[key]
    end
  end

  return KetchumSettings[key]
end

-- Set a saved var.
local function setter(self, key, value)
  KetchumSettings[key] = value
end

setmetatable(JetBattlePets.settings, {
  __index = getter,
  __newindex = setter
})
