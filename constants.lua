local _, ketchum = ...

Ketchum = ketchum -- global namespace

ketchum.constants = {}

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
