local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

---Init addon settings to empty table
JetBattlePets.settings = {}

---Init saved variables on first run
JetBattlePetsSettings = {}

---@class JetBattlePetsSettings
---@field [string] any
---Default settings to apply on init
local DEFAULT_SETTINGS = {
  ALERT_THRESHOLD = JetBattlePets.constants.RARITIES.SHINY,

  -- flag to turn encounter data collection on/off
  ENABLE_DATA_COLLECTION = false,

  -- flag to enable/disable the variant model viewer feature
  SHOW_VARIANT_MODEL_VIEWER = false,

  -- flag to enable/disable warnings when a battle pet on the enemy team has
  -- an ability that might screw up a capture
  ENABLE_CAPTURE_THREAT_WARNINGS = false,
}

---Fetch key from saved vars. Init the saved var to a default if it
---doesn't exist yet
---@param self JetBattlePetsSettings
---@param key string
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
