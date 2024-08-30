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