local _, JetBattlePets = ...

JetBattlePets = JetBattlePets -- global namespace

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
    "The API shows two or more models with different rarities. However, the model that's used is randomized whenever the pet is summoned."
  }
}

JetBattlePets.constants.GRAPHICS = {
  MODEL_OUTLINE_COMMON_ATLAS = C_Texture.GetAtlasInfo("bags-glow-white"),
  MODEL_OUTLINE_RARE_ATLAS = C_Texture.GetAtlasInfo("bags-glow-heirloom"),
  MODEL_OUTLINE_SHINY_ATLAS = C_Texture.GetAtlasInfo("bags-glow-artifact"),
  MODEL_OUTLINE_UNCOMMON_ATLAS = C_Texture.GetAtlasInfo("bags-glow-green"),
  MODEL_RARITY_ATLAS = C_Texture.GetAtlasInfo("groupfinder-eye-frame"),
  SHINY_ATLAS = C_Texture.GetAtlasInfo("rare-elite-star"),
  THREAT_ICON_ATLAS = C_Texture.GetAtlasInfo("Ping_Chat_Warning"),
}

JetBattlePets.constants.SOUNDS = {
  ALERT_THREAT = 233591
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

--------------------------------------------
----------- Categorize Abilities -----------
--------------------------------------------

-- IDs of abilities that have recoil damage
local RECOIL_ABILITIES = {
  263,  -- Crystal Overload
  621,  -- Stone Rush
  649,  -- BONESTORM
  1003, -- Gold Rush
  1761, -- BONESTORM!
  1762, -- BONESTORM!!
  1787, -- Feral Strike
  1912, -- Void Portal
}

-- IDs of self-destruct abilities
local SELF_DESTRUCT_ABILITIES = {
  282,  -- Explode
  663,  -- Corpse Explosion
  836,  -- Baneling Burst
  1025, -- Armageddon
  2099, -- Sting
  2209, -- Burst
  2429, -- Massive Explosion
}

-- IDs of abilities that create an environmental DoT
local ENVIRONMENTAL_DOT_ABILITIES = {
  172,  -- Scorched Earth
  2349, -- Toxic Fumes
}

-- IDs of abilities that negatively affect the user's team
local FRIENDLY_FIRE_ABILITIES = {
  519,  -- Apocalypse
  2366, -- MAYHEM
}

-- IDs of abilities that are a threat to a battle pet you might
-- want to capture
local CAPTURE_THREAT_ABILITIES = {
  unpack(RECOIL_ABILITIES),
  unpack(SELF_DESTRUCT_ABILITIES),
  unpack(ENVIRONMENTAL_DOT_ABILITIES),
  unpack(FRIENDLY_FIRE_ABILITIES),
}

-- specialized lists of ability IDs
JetBattlePets.constants.ABILITIES = {
  CAPTURE_THREATS = CAPTURE_THREAT_ABILITIES,
}
