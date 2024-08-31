local _, ketchum = ...

Ketchum = ketchum -- global namespace

ketchum.constants = {}

-- encounter rate ceilings (inclusive) for model rarities
ketchum.constants.DEFAULT_THRESHOLDS = {
  RARE = 40,
  SHINY = 10,
  UNCOMMON = 70
}

-- default settings to apply on init
ketchum.constants.DEFAULT_SETTINGS = {
  RareThreshold = ketchum.constants.DEFAULT_THRESHOLDS.RARE,
  ShinyThreshold = ketchum.constants.DEFAULT_THRESHOLDS.SHINY,
  UncommonThreshold = ketchum.constants.DEFAULT_THRESHOLDS.UNCOMMON
}

-- valid color names to use in utility functions
ketchum.constants.COLOR_NAMES = {
  COMMON = "COMMON",
  RARE = "RARE",
  SHINY = "SHINY",
  UNCOMMON = "UNCOMMON"
}

ketchum.constants.GRAPHICS = {
  MODEL_RARITY_ATLAS = C_Texture.GetAtlasInfo("groupfinder-eye-frame"),
  SHINY_ATLAS = C_Texture.GetAtlasInfo("rare-elite-star")
}

-- string literals to define color hex values
local TEXT_COLORS = {
  COMMON = "ffffff",
  RARE = "0000ff",
  SHINY = "ffff00",
  UNCOMMON = "00ff00"
}

-- icons that can be used in/as strings
local TEXT_ICONS = {
  SHINY = CreateAtlasMarkup("rare-elite-star")
}

-- string literal patterns to use in the `format` function
local TEXT_FORMAT_PATTERNS = {
  PROBABILITY = "%.2f%%"
}

-- constants related to text formatting
ketchum.constants.TEXT_FORMAT = {
  COLOR_PREFIX = "|c00",
  COLOR_TERMINATOR = "|r",
  COLORS = TEXT_COLORS,
  ICONS = TEXT_ICONS,
  PATTERNS = TEXT_FORMAT_PATTERNS
}