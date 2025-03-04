---@meta

---@class Dictionary<T>: { [string]: T }

---@class JetBattlePets
---@field atlas JetBattlePetsAtlasUtils
---@field battleUi JetBattlePetsBattleUtils
---@field color JetBattlePetsColorUtils
---@field constants JetBattlePetsConstants
---@field encounters JetBattlePetsEncountersUtils
---@field frames Dictionary<Frame|VariantModelsWindow>
---@field grid JetBattlePetsGridUtils
---@field journal JetBattlePetsJournalUtils
---@field pets JetBattlePetsPetUtils
---@field rematch JetBattlePetsRematch
---@field settings JetBattlePetsSettings
---@field text JetBattlePetsTextUtils
JetBattlePets = {}

-----------------------------------------------------
-------------------- Constants ----------------------
-----------------------------------------------------

---@class JetBattlePetsConstants
---@field ABILITIES Dictionary<number[]>
---@field ATLAS_NAMES AtlasNames
---@field COLORS Colors
---@field DIMENSIONS DimensionConstants
---@field SOUNDS SoundFileIDs
---@field TEXT_FORMAT TextFormatConstants
JetBattlePetsConstants = {
  RARITIES = {
    COMMON = 0,
    UNCOMMON = 1,
    RARE = 2,
    SHINY = 3
  },
  RARITY_NAMES = {
    [JetBattlePetsConstants.RARITIES.COMMON] = "COMMON",
    [JetBattlePetsConstants.RARITIES.UNCOMMON] = "UNCOMMON",
    [JetBattlePetsConstants.RARITIES.RARE] = "RARE",
    [JetBattlePetsConstants.RARITIES.SHINY] = "SHINY",
  },
  RARITY_RATIOS = {
    RARE = 3,
    SHINY = 8,
    UNCOMMON = 2
  }
}

-----------------------------------------------------
------------------- Grid Utils ----------------------
-----------------------------------------------------

---@class JetBattlePetsGridUtils
JetBattlePetsGridUtils = {}

---Determine what column a grid item is in
---@param index integer Position of the item in its array
---@param maxColumns integer Maximum number of columns per row
---@return integer
function JetBattlePetsGridUtils:GetColumn(
    index,
    maxColumns
)
  return 1
end

---Determine the total height of the grid
---@param itemHeight integer Height of a single item in the grid
---@param numItems integer Number of items in the grid
---@param maxColumns integer Maximum number of items per row
---@return integer
function JetBattlePetsGridUtils:GetHeight(
    itemHeight,
    numItems,
    maxColumns
)
  return 0
end

---Determine the total width of the grid
---@param itemWidth integer Width of a single item in the grid
---@param numItems integer Number of items in the grid
---@param maxColumns integer Maximum number of items per row
---@return integer
function JetBattlePetsGridUtils:GetWidth(
    itemWidth,
    numItems,
    maxColumns
)
  return 0
end

---Determine what row a grid item is in
---@param index integer Position of the item in its array
---@param maxColumns integer Maximum number of items per row
---@return number
function JetBattlePetsGridUtils:GetRow(
    index,
    maxColumns
)
  return 1
end

-----------------------------------------------------
----------------- Pet Journal Utils -----------------
-----------------------------------------------------

---@class JetBattlePetsJournalUtils
JetBattlePetsJournalUtils = {}

---Return all model encounter rates of a species as a table
---@param speciesID integer
---@return number[]
function JetBattlePetsJournalUtils:GetDisplayProbabilities(speciesID)
  return {}
end

---Return the probability of encountering a specific skin in a species
---@param speciesID integer
---@param displayID integer
---@return number
function JetBattlePetsJournalUtils:GetDisplayProbability(speciesID, displayID)
end

---Determine the index of a specific display ID of a specific species
---@param speciesID integer
---@param displayID integer
---@return integer
function JetBattlePetsJournalUtils:GetDisplayIndex(speciesID, displayID)
end

---Get text for the precent probability of encountering the pet model
---identified by a specific display index
---@param speciesID integer
---@param displayIndex SlotNumber
function JetBattlePetsJournalUtils:GetDisplayIndexProbabilityText(speciesID, displayIndex)
end

---Get text for the percent probability of encountering a specific model
---@param speciesID integer
---@param displayID integer
---@return string
function JetBattlePetsJournalUtils:GetDisplayProbabilityText(speciesID, displayID)
end

---Get the rarity of a variant model
---@param speciesID integer
---@param displayID integer
---@return Rarity
function JetBattlePetsJournalUtils:GetDisplayRarity(speciesID, displayID)
end

---Get the rarity of a variant model by the model display index
---@param speciesID integer
---@param slot integer
---@return Rarity
function JetBattlePetsJournalUtils:GetDisplayRarityByIndex(speciesID, slot)
end

---Get the rarity name of a variant model
---@param speciesID integer
---@param displayID integer
---@return RarityName
function JetBattlePetsJournalUtils:GetDisplayRarityName(speciesID, displayID)
end

---Get the encounter probability of the most common model of a species
---@param speciesID integer
---@return number
function JetBattlePetsJournalUtils:GetMaxDisplayProbability(speciesID)
end

---Get the number of pets of a given species model the player owns
---@param speciesID integer
---@param displayID integer
---@return number
function JetBattlePetsJournalUtils:GetNumOwned(speciesID, displayID)
end

-----------------------------------------------------
--------------------- Pet Utils ---------------------
-----------------------------------------------------

---@class JetBattlePetsPetUtils
JetBattlePetsPetUtils = {}

---Fetch info for a pet, using Rematch if possible
---@param petID PetID
---@return RematchPetInfo
function JetBattlePetsPetUtils.GetPet(petID)
end

-----------------------------------------------------
-------------------- Color Utils --------------------
-----------------------------------------------------

---@class JetBattlePetsColorUtils
JetBattlePetsColorUtils = {}

---Get the Color that represents a given rarity
---@param rarityName string
---@return Color
function JetBattlePetsColorUtils:GetRarityColor(rarityName)
end

-----------------------------------------------------
------------------- Battle Utils --------------------
-----------------------------------------------------

---@class PetBattleLocation
---@field areaIDs? number
---@field mapID? number
---@field playerPosition? Vector
PetBattleLocation = {}

---@class JetBattlePetsBattleUtils
---@field alertsFired boolean
JetBattlePetsBattleUtils = {}

---Cleanup after a pet battle is finished
function JetBattlePetsBattleUtils:AfterBattle()
end

---Save data about a specific encountered enemy pet to disk
---@param slot integer
---@param location PetBattleLocation
function JetBattlePetsBattleUtils:RecordEncounterSlotData(slot, location)
end

---Print an alert message that an enemy pet contains a problematic ability
---@param abilityName string
---@param petSlot SlotNumber
function JetBattlePetsBattleUtils:PrintThreatAlert(
    abilityName,
    petSlot
)
end

---Print an alert to the chat box that a shiny is in the battle
---@param speciesID integer
function JetBattlePetsBattleUtils:PrintShinyAlert(speciesID)
end

---Attach the shiny icon to appropriate battle pet UI frames
function JetBattlePetsBattleUtils:UpdateShinyFrames()
end

---Play an audio alert and display a warning message if an enemy pet
---has an ability that could ruin the player's attempts to capture it
---or one of its teammates
function JetBattlePetsBattleUtils:DisplayCaptureThreatWarnings()
end

---Save data about encountered pets to disk
function JetBattlePetsBattleUtils:RecordEncounterData()
end

---Hide any shiny frames that are currently shown
function JetBattlePetsBattleUtils:ResetShinyFrames()
end

---Add a shiny icon to an active enemy pet that's shiny
function JetBattlePetsBattleUtils:TagShinyActivePet()
end

---Add a shiny icon to back row pets that are shiny
---@param slot integer
function JetBattlePetsBattleUtils:TagShinyBackPet(slot)
end

-----------------------------------------------------
----------------- Encounters Utils ------------------
-----------------------------------------------------

---@class JetBattlePetsEncounter
---@field speciesID integer
---@field displayID integer
---@field position integer
---@field rarity BattlePetBreedQuality
---@field HP integer
---@field power integer
---@field speed integer
---@field level integer
---@field location PetBattleLocation
JetBattlePetsEncounter = {}

---@class JetBattlePetsEncountersUtils
JetBattlePetsEncountersUtils = {}

---Record an encounter to saved variables
---@param encounter JetBattlePetsEncounter
function JetBattlePetsEncountersUtils:AddEncounter(encounter)
end

-----------------------------------------------------
------------------- Atlas Utils ---------------------
-----------------------------------------------------

---@class JetBattlePetsAtlasUtils
JetBattlePetsAtlasUtils = {}

---Get tex coords from a provided atlas
---@param atlas AtlasInfo
---@return number, number, number, number
function JetBattlePetsAtlasUtils:GetTexCoords(atlas)
end

-----------------------------------------------------
-------------------- Text Utils ---------------------
-----------------------------------------------------

---@class JetBattlePetsTextUtils
JetBattlePetsTextUtils = {}

---Capitalize the first letter of a string
---@param text string
---@return string
function JetBattlePetsTextUtils:Capitalize(text)
end

---Given a text string, return a string literal where the first letter is
---capitalized and the rest is lower case
---@param rarity RarityName
---@return string
function JetBattlePetsTextUtils:FormatRarityName(rarity)
end

---Given a number representing a percentage return a string literal in the
---form `XX.YY%`
---@param probability number
---@return string
function JetBattlePetsTextUtils:FormatProbability(probability)
end

---Given a number representing a probability as a percent, format it to
---two decimal places of precision and color it by rarity
---@param probability number
---@param maxProbability number
---@return string
function JetBattlePetsTextUtils:GetRarityText(probability, maxProbability)
end

---Given the hex value of a color and some text, return a string literal
---in the form `|c00XXYYZZProvidedTextr|`
---@param colorHexString string
---@param text string
---@return string
function JetBattlePetsTextUtils:SetColor(colorHexString, text)
end

---Set the color of the given text to the color with the given name
---
---Uses the default UI text color if the color name is invalid
---@param rarity Rarity
---@param text string
---@return string
function JetBattlePetsTextUtils:SetColorByName(rarity, text)
end

-----------------------------------------------------
---------------- Rematch Integration ----------------
-----------------------------------------------------

---@class JetBattlePetsRematch
JetBattlePetsRematch = {}

---Register a badge to Rematch that displays on shiny pets
function JetBattlePetsRematch:AddIsShinyBadge()
end

---Add model rarity to Rematch pet cards
function JetBattlePetsRematch:AddModelRarity()
end

---Add variant stats to Rematch pet cards
function JetBattlePetsRematch:AddVariantStats()
end

---Add rematch filters for pet variants
function JetBattlePetsRematch:AddVariantFilters()
end
