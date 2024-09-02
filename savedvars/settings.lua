local _, ketchum = ...

-- init saved variables on first run
KetchumSettings = {}

-- default settings to apply on init
local DEFAULT_SETTINGS = {
  -- encounter rate ceilings (inclusive) for model rarities
  THRESHOLDS = {
    RARE = 40,
    SHINY = 10,
    UNCOMMON = 70
  }
}

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

local function setter(self, key, value)
  KetchumSettings[key] = value
end

ketchum.settings = setmetatable({}, {
  __index = getter,
  __newIndex = setter
})