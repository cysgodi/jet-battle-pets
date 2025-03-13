local _, JetBattlePets = ...

---@class EventsFrame : Frame
local EventsFrame = CreateFrame("Frame")


function EventsFrame:OnEvent(event, ...)
  self[event](self, event, ...)
end

function EventsFrame:ADDON_LOADED(_, addonName)
  if addonName == "JetBattlePets" then
    JetBattlePets.options:InitializeOptions()
  end
end

function EventsFrame:MODIFIER_STATE_CHANGED(_, key, down)
  if not MouseIsOver(PetBattleFrame.ActiveEnemy.Icon) then
    return
  end

  if key ~= "LCTRL" and key ~= "RCTRL" then
    return
  end

  if down == 1 then
    SetCursor("INSPECT_CURSOR")
  else
    ResetCursor()
  end
end

function EventsFrame:PET_BATTLE_OPENING_START()
  JetBattlePets.battleUi:UpdateShinyFrames()
  JetBattlePets.battleUi:DisplayCaptureThreatWarnings()
  JetBattlePets.battleUi:RecordEncounterData()
  JetBattlePets.battleUi:SetUpPets()
end

function EventsFrame:PET_BATTLE_OVER()
  JetBattlePets.battleUi:AfterBattle()
end

function EventsFrame:PET_BATTLE_PET_CHANGED(_, owner)
  if owner == Enum.BattlePetOwner.Enemy then
    JetBattlePets.battleUi:UpdateShinyFrames()
  end
end

EventsFrame:RegisterEvent("ADDON_LOADED")
EventsFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
EventsFrame:RegisterEvent("PET_BATTLE_OPENING_START")
EventsFrame:RegisterEvent("PET_BATTLE_OVER")
EventsFrame:RegisterEvent("PET_BATTLE_PET_CHANGED")
EventsFrame:SetScript("OnEvent", EventsFrame.OnEvent)

JetBattlePets.events = EventsFrame
