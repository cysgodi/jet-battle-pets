local _, ketchum = ...

Ketchum = ketchum -- global namespace

ketchum.constants = {}

-- dimensions of common UI elements
ketchum.constants.DIMENSIONS = {
  VARIANT_MODEL = {
    HEIGHT = 172,
    WIDTH = 168
  },
  VARIANT_MODEL_GRID = {
    MAX_COLS = 3,
  },
  VARIANT_MODEL_WINDOW = {
    MARGIN_BOTTOM = 32,
    MARGIN_LEFT = 16,
    MARGIN_RIGHT = 16,
    MARGIN_TOP = 32,
  }
}

-- valid rarity names to use in utility functions
ketchum.constants.RARITY_NAMES = {
  "COMMON",
  "UNCOMMON",
  "RARE",
  "SHINY"
}

-- an enum representation of valid rarities
ketchum.constants.RARITIES = EnumUtil.MakeEnum(
  unpack(ketchum.constants.RARITY_NAMES)
)

-- ratios for determining rarity of a model relative to the most commonly
-- encountered model of a species
ketchum.constants.RARITY_RATIOS = {
  RARE = 3,
  SHINY = 8,
  UNCOMMON = 2
}

-- IDs of species that will always show 1 model
ketchum.constants.IGNORED_SPECIES = {
  [2622] = {
    reason =
    "The API shows two models at 75/25% rarity. However, the model that's used is randomized whenever the pet is summoned."
  }
}

ketchum.constants.GRAPHICS = {
  MODEL_RARITY_ATLAS = C_Texture.GetAtlasInfo("groupfinder-eye-frame"),
  SHINY_ATLAS = C_Texture.GetAtlasInfo("rare-elite-star")
}

-- string literals to define color hex values
local TEXT_COLORS = {
  COMMON = "ffffff",
  RARE = "88bbff",
  SHINY = "ffd200",
  UNCOMMON = "20ff20"
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
