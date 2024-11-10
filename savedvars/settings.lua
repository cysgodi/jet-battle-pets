local _, ketchum = ...

-- init addon settings to empty table
ketchum.settings = {}

-- init saved variables on first run
KetchumSettings = {}

-- default settings to apply on init
local DEFAULT_SETTINGS = {
  -- flag to turn encounter data collection on/off
  ENABLE_DATA_COLLECTION = false,
  -- ratios for determining rarity of a model relative to the most commonly
  -- encountered model of a species
  RARITY_RATIO = {
    RARE = 4,
    SHINY = 8,
    UNCOMMON = 2
  }
}

-- Fetch key from saved vars. Init the saved var to a default if it
-- doesn't exist yet.
local function getter(self, key)
  if KetchumSettings[key] == nil then
    if DEFAULT_SETTINGS[key] and type(DEFAULT_SETTINGS[key] == "table") then
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

setmetatable(ketchum.settings, {
  __index = getter,
  __newindex = setter
})
