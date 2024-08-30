local _, ketchum = ...

Ketchum = ketchum -- global namespace

-- encounter rate ceiling (inclusive) for a model to be considered uncommon
ketchum.DEFAULT_UNCOMMON_THRESHOLD = 70

-- encounter rate ceiling (inclusive) for a model to be considered rare
ketchum.DEFAULT_RARE_THRESHOLD = 40

-- encounter rate ceiling (inclusive) for a model to be considered shiny
ketchum.DEFAULT_SHINY_THRESHOLD = 10

ketchum.DEFAULT_SETTINGS = {
  RareThreshold = ketchum.DEFAULT_RARE_THRESHOLD,
  ShinyThreshold = ketchum.DEFAULT_SHINY_THRESHOLD,
  UncommonThreshold = ketchum.DEFAULT_UNCOMMON_THRESHOLD
}