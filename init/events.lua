local _, JetBattlePets = ...

JetBattlePets.events = CreateFrame("Frame")

function JetBattlePets.events:OnEvent(event, ...)
  self[event](self, event, ...)
end

function JetBattlePets.events:ADDON_LOADED(_, addonName)
  if addonName == "JetBattlePets" then
    JetBattlePets.options:InitializeOptions()
  end
end

function JetBattlePets.events:PET_BATTLE_OPENING_START()
  JetBattlePets.battleUi:UpdateShinyFrames()
  JetBattlePets.battleUi:DisplayCaptureThreatWarnings()
  JetBattlePets.battleUi:RecordEncounterData()
end

function JetBattlePets.events:PET_BATTLE_OVER()
  JetBattlePets.battleUi:AfterBattle()
end

function JetBattlePets.events:PET_BATTLE_PET_CHANGED(_, owner)
  if owner == Enum.BattlePetOwner.Enemy then
    JetBattlePets.battleUi:UpdateShinyFrames()
  end
end

JetBattlePets.events:RegisterEvent("ADDON_LOADED")
JetBattlePets.events:RegisterEvent("PET_BATTLE_OPENING_START")
JetBattlePets.events:RegisterEvent("PET_BATTLE_OVER")
JetBattlePets.events:RegisterEvent("PET_BATTLE_PET_CHANGED")
JetBattlePets.events:SetScript("OnEvent", JetBattlePets.events.OnEvent)
