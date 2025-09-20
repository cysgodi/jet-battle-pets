local _, JetBattlePets = ...

---@class EventsFrame : Frame
local EventsFrame = CreateFrame("Frame")

---Register a callback for a specific event
---@param event string
---@param callback function
function EventsFrame:OnEvent(event, callback)
  self[event] = self[event] or {}

  table.insert(self[event], callback)
end

---Execute all callbacks for a fired event
function EventsFrame:HandleEvent(event, ...)
  self[event] = self[event] or {}

  for _, callback in pairs(self[event]) do
    callback(event, ...)
  end
end

local function OnAddonLoaded(_, addonName)
  if addonName == "JetBattlePets" then
    JetBattlePets.options:ReleaseFeatures()
    JetBattlePets.options:InitializeOptions()
  end
end
EventsFrame:OnEvent("ADDON_LOADED", OnAddonLoaded)

local function OnModifierStateChanged(_, key, down)
  JetBattlePets.battleUi:OnModifierStateChanged(key, down)
end
EventsFrame:OnEvent("MODIFIER_STATE_CHANGED", OnModifierStateChanged)

local function OnPetBattleOpeningStart()
  JetBattlePets.battleUi:UpdateShinyFrames()
  JetBattlePets.battleUi:DisplayCaptureThreatWarnings()
  JetBattlePets.battleUi:RecordEncounterData()
  JetBattlePets.battleUi:SetUpPets()
end
EventsFrame:OnEvent("PET_BATTLE_OPENING_START", OnPetBattleOpeningStart)

local function OnPetBattleOver()
  JetBattlePets.battleUi:AfterBattle()
end
EventsFrame:OnEvent("PET_BATTLE_OVER", OnPetBattleOver)

local function OnPetBattlePetChanged(_, owner)
  if owner == Enum.BattlePetOwner.Enemy then
    JetBattlePets.battleUi:UpdateShinyFrames()
  end
end
EventsFrame:OnEvent("PET_BATTLE_PET_CHANGED", OnPetBattlePetChanged)

EventRegistry:RegisterCallback(
  "WorldMapOnShow",
  InitJetBattlePetsFrames
)

EventsFrame:RegisterEvent("ADDON_LOADED")
EventsFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
EventsFrame:RegisterEvent("PET_BATTLE_OPENING_START")
EventsFrame:RegisterEvent("PET_BATTLE_OVER")
EventsFrame:RegisterEvent("PET_BATTLE_PET_CHANGED")
EventsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventsFrame:RegisterEvent("QUEST_LOG_UPDATE")
EventsFrame:SetScript("OnEvent", EventsFrame.HandleEvent)

JetBattlePets.events = EventsFrame
