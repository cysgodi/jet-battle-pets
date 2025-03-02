local _, JetBattlePets = ...

---@class JetBattlePets
JetBattlePets = JetBattlePets -- global namespace

---@type table<string, table<string, any>>
JetBattlePets.constants = {}

---Dimensions of common UI elements
---@type table<string, table<string, number>>
JetBattlePets.constants.DIMENSIONS = {
  TITLE_BAR_BUTTON = {
    SIZE = 24
  },
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

---@enum Rarity
---@enum (key) RarityName
JetBattlePets.constants.RARITIES = {
  COMMON = 0,
  UNCOMMON = 1,
  RARE = 2,
  SHINY = 3
}

---@type table<RarityName, Rarity>
JetBattlePets.constants.RARITY_NAMES = tInvert(JetBattlePets.constants.RARITIES)

---Ratios for determining rarity of a model relative to the most commonly
---encountered model of a species
---@enum RarityRatio
JetBattlePets.constants.RARITY_RATIOS = {
  RARE = 3,
  SHINY = 8,
  UNCOMMON = 2
}

---Names of atlases used for various UI elements
---@type table<string, string>
local ATLAS_NAMES = {
  OWNED_VARIANT_OUTLINE = "transmog-wardrobe-border-collected",
  UNOWNED_VARIANT_OUTLINE = "transmog-wardrobe-border-unusable",
}

---Atlas info used for various UI elements
---@type table<string, AtlasInfo>
local ATLASES = {
  MODEL_RARITY_ICON = C_Texture.GetAtlasInfo("groupfinder-eye-frame"),
  SHINY_ICON = C_Texture.GetAtlasInfo("rare-elite-star"),
  THREAT_ICON = C_Texture.GetAtlasInfo("Ping_Chat_Warning"),
}

---Constants related to various UI elements
---@type table<string, AtlasInfo|string>
JetBattlePets.constants.GRAPHICS = {
  ATLAS_NAMES = ATLAS_NAMES,
  ATLASES = ATLASES,
}

---IDs of sound files
---@type table<string, number>
JetBattlePets.constants.SOUNDS = {
  ALERT_THREAT = 233591
}

---String literals to define color hex values
---@type table<string, string>
local TEXT_COLORS = {
  COMMON = "ffffff",
  RARE = "2090fd",
  SHINY = "ffd200",
  UNCOMMON = "20ff20"
}

---Icons that can be used in/as strings
---@type table<string, string>
local TEXT_ICONS = {
  SHINY = CreateAtlasMarkup("rare-elite-star")
}

---String literal patterns to use in the `format` function
---@type table<string, string>
local TEXT_FORMAT_PATTERNS = {
  PROBABILITY = "%.2f%%"
}

---Constants related to text formatting
---@type table<string, string|table<string, any>>
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

---IDs of abilities that have recoil damage
---@type number[]
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

---IDs of self-destruct abilities
---@type number[]
local SELF_DESTRUCT_ABILITIES = {
  282,  -- Explode
  663,  -- Corpse Explosion
  836,  -- Baneling Burst
  1025, -- Armageddon
  2099, -- Sting
  2209, -- Burst
  2429, -- Massive Explosion
}

---IDs of abilities that create an environmental DoT
---@type number[]
local ENVIRONMENTAL_DOT_ABILITIES = {
  172,  -- Scorched Earth
  2349, -- Toxic Fumes
}

---IDs of abilities that negatively affect the user's team
---@type number[]
local FRIENDLY_FIRE_ABILITIES = {
  519,  -- Apocalypse
  2366, -- MAYHEM
}

---IDs of abilities that are a threat to a battle pet you might
---want to capture
---@type number[]
local CAPTURE_THREAT_ABILITIES = {
  unpack(RECOIL_ABILITIES),
  unpack(SELF_DESTRUCT_ABILITIES),
  unpack(ENVIRONMENTAL_DOT_ABILITIES),
  unpack(FRIENDLY_FIRE_ABILITIES),
}

---Specialized lists of ability IDs
---@type table<string, number[]>
JetBattlePets.constants.ABILITIES = {
  CAPTURE_THREATS = CAPTURE_THREAT_ABILITIES,
}

---Throw an error if an attempt is made to modify a constant
local function setter()
  error("Attempt to modify read-only table 'constants'", 2)
end

setmetatable(JetBattlePets.constants, {
  __index = JetBattlePets.constants,
  __newindex = setter
})
