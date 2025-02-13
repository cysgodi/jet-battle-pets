local _, JetBattlePets = ...

Ketchum = JetBattlePets -- global namespace

JetBattlePets.constants = {}

-- dimensions of common UI elements
JetBattlePets.constants.DIMENSIONS = {
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
JetBattlePets.constants.RARITY_NAMES = {
  "COMMON",
  "UNCOMMON",
  "RARE",
  "SHINY"
}

-- an enum representation of valid rarities
JetBattlePets.constants.RARITIES = EnumUtil.MakeEnum(
  unpack(JetBattlePets.constants.RARITY_NAMES)
)

-- ratios for determining rarity of a model relative to the most commonly
-- encountered model of a species
JetBattlePets.constants.RARITY_RATIOS = {
  RARE = 3,
  SHINY = 8,
  UNCOMMON = 2
}

-- IDs of species that will always show 1 model
JetBattlePets.constants.IGNORED_SPECIES = {
  [2622] = {
    reason =
    "The API shows two models at 75/25% rarity. However, the model that's used is randomized whenever the pet is summoned."
  }
}

JetBattlePets.constants.GRAPHICS = {
  MODEL_OUTLINE_COMMON_ATLAS = C_Texture.GetAtlasInfo("bags-glow-white"),
  MODEL_OUTLINE_RARE_ATLAS = C_Texture.GetAtlasInfo("bags-glow-heirloom"),
  MODEL_OUTLINE_SHINY_ATLAS = C_Texture.GetAtlasInfo("bags-glow-artifact"),
  MODEL_OUTLINE_UNCOMMON_ATLAS = C_Texture.GetAtlasInfo("bags-glow-green"),
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
JetBattlePets.constants.TEXT_FORMAT = {
  COLOR_PREFIX = "|c00",
  COLOR_TERMINATOR = "|r",
  COLORS = TEXT_COLORS,
  ICONS = TEXT_ICONS,
  PATTERNS = TEXT_FORMAT_PATTERNS
}
