local _, _JetBattlePets = ...

---@type JetBattlePets
JetBattlePets = _JetBattlePets

-----------------------------------------------------
------------------- Dimensions ----------------------
-----------------------------------------------------

---@class TitleBarButtonDimensions Dimensions of buttons in the variant model viewer title bar
local TITLE_BAR_BUTTON_DIMENSIONS = {
  SIZE = 24 -- Button height and width (buttons are square)
}

---@class VariantModelDimensions Dimensions of models displayed in the variant model viewer
local VARIANT_MODEL_DIMENSIONS = {
  HEIGHT = 142,
  WIDTH = 142,
}

---@class VariantModelFrameDimensions
local VARIANT_MODEL_FRAME_DIMENSIONS = {
  HEIGHT = 188,
  WIDTH = 168,
}

---@class VariantModelGridDimensions Dimensions of the grid that variant models are displayed in
local VARIANT_MODEL_GRID_DIMENSIONS = {
  MAX_COLS = 3,
}

---@class VariantModelWindowDimensions Dimensions of the window that variant models are displayed in
local VARIANT_MODEL_WINDOW_DIMENSIONS = {
  DISCLAIMER_HEIGHT = 48,
  MARGIN_BOTTOM = 32,
  MARGIN_LEFT = 16,
  MARGIN_RIGHT = 16,
  MARGIN_TOP = 48,
  -- the window inside of frames created with "PortraitFrameTemplate"
  -- is offset 3 points to the right of the actual left edge of the frame
  TEMPLATE_HORIZONTAL_OFFSET = 3,
  -- the title bar is part of the frame containing the grid, so we need
  -- to subtract its height from the total window height
  TITLE_BAR_HEIGHT = 24
}

---@class DimensionConstants Dimensions of common UI elements
local DIMENSION_CONSTANTS = {
  TITLE_BAR_BUTTON = TITLE_BAR_BUTTON_DIMENSIONS,
  VARIANT_MODEL = VARIANT_MODEL_DIMENSIONS,
  VARIANT_MODEL_FRAME = VARIANT_MODEL_FRAME_DIMENSIONS,
  VARIANT_MODEL_GRID = VARIANT_MODEL_GRID_DIMENSIONS,
  VARIANT_MODEL_WINDOW = VARIANT_MODEL_WINDOW_DIMENSIONS,
}

-----------------------------------------------------
---------------------- Rarity -----------------------
-----------------------------------------------------

---@enum Rarity
local RARITIES = {
  COMMON = 0,
  UNCOMMON = 1,
  RARE = 2,
  SHINY = 3
}

---@enum RarityName
local RARITY_NAMES = {
  [RARITIES.COMMON] = "COMMON",
  [RARITIES.UNCOMMON] = "UNCOMMON",
  [RARITIES.RARE] = "RARE",
  [RARITIES.SHINY] = "SHINY",
}

---Ratios for determining rarity of a model relative to the most commonly
---encountered model of a species
---@enum RarityRatio
local RARITY_RATIOS = {
  RARE = 3,
  SHINY = 8,
  UNCOMMON = 2
}

-----------------------------------------------------
------------------- WoW Assets ----------------------
-----------------------------------------------------

---@class AtlasNames Names of atlases used for various UI elements
local ATLAS_NAMES = {
  CAGED_ICON = "legionmission-icon-currency",
  MODEL_RARITY_ICON = "groupfinder-eye-frame",
  QUEST_LOG_TAB_ICON = "WildBattlePetCapturable",
  QUEST_LOG_TAB_SELECTED_ICON = "WildBattlePet",
  SHINY_ICON = "rare-elite-star",
  SOURCE_DROP = "DungeonSkull",
  SOURCE_PET_BATTLE = "WildBattlePetCapturable",
  SOURCE_QUEST = "SmallQuestBang",
  SOURCE_VENDOR = "Crosshair_buy_32",
  THREAT_ICON = "Ping_Chat_Warning",
  VARIANT_OUTLINE_OWNED = "transmog-wardrobe-border-collected",
  VARIANT_OUTLINE_UNOWNED = "transmog-wardrobe-border-unusable",
}

---@class SoundFileIDs IDs of sound files
local SOUNDS = {
  ALERT_THREAT = 233591
}

-----------------------------------------------------
----------------------- Text ------------------------
-----------------------------------------------------

---@class TextIcons
local TEXT_ICONS = {
  SHINY = CreateAtlasMarkup("rare-elite-star")
}

---@class TextFormatPatterns
local TEXT_FORMAT_PATTERNS = {
  PROBABILITY = "%.2f%%"
}

---@class TextFormatConstants
local TEXT_FORMAT_CONSTANTS = {
  COLOR_PREFIX = "|c00",
  COLOR_TERMINATOR = "|r",
  ICONS = TEXT_ICONS,
  PATTERNS = TEXT_FORMAT_PATTERNS
}

-----------------------------------------------------
---------------------- Colors -----------------------
-----------------------------------------------------

---@class RarityColors
local RARITY_COLORS = {
  COMMON = "ffffff",
  RARE = "2090fd",
  SHINY = "ffd200",
  UNCOMMON = "20ff20"
}

---@class Colors
local COLORS = {
  RARITY = RARITY_COLORS
}

-----------------------------------------------------
-------------------- Abilities ----------------------
-----------------------------------------------------

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
local CAPTURE_THREAT_ABILITIES = JetBattlePets.array:Concat(
  RECOIL_ABILITIES,
  SELF_DESTRUCT_ABILITIES,
  ENVIRONMENTAL_DOT_ABILITIES,
  FRIENDLY_FIRE_ABILITIES
)

---@class AbilityConstants Specialized lists of ability IDs
local ABILITY_CONSTANTS = {
  CAPTURE_THREATS = CAPTURE_THREAT_ABILITIES,
}

---@class BattleUiFrames Frames used in the pet battle UI
local BATTLE_UI_FRAMES = {
  ACTIVE_ALLY = "ActiveAlly",
  ACTIVE_ENEMY = "ActiveEnemy",
  ALLY_2 = "Ally2",
  ALLY_3 = "Ally3",
  ENEMY_2 = "Enemy2",
  ENEMY_3 = "Enemy3",
}

---@class FrameConstants Constant reference to UI frames
local FRAMES = {
  BATTLE_UI = BATTLE_UI_FRAMES
}

---@class JetBattlePetsConstants
JetBattlePets.constants = JetBattlePets.constants or {
  ABILITIES = ABILITY_CONSTANTS,
  ATLAS_NAMES = ATLAS_NAMES,
  COLORS = COLORS,
  DIMENSIONS = DIMENSION_CONSTANTS,
  FRAMES = FRAMES,
  RARITIES = RARITIES,
  RARITY_NAMES = RARITY_NAMES,
  RARITY_RATIOS = RARITY_RATIOS,
  SOUNDS = SOUNDS,
  TEXT_FORMAT = TEXT_FORMAT_CONSTANTS
}

---Throw an error if an attempt is made to modify a constant
local function setter()
  error("Attempt to modify read-only table 'constants'", 2)
end

setmetatable(JetBattlePets.constants, {
  __index = JetBattlePets.constants,
  __newindex = setter
})
