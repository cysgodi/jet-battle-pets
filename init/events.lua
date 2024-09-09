local _, ketchum = ...

ketchum.events = CreateFrame("Frame")

function ketchum.events:OnEvent(event, ...)
  self[event](self, event, ...)
end


function ketchum.events:PET_BATTLE_OPENING_START()
  ketchum.battleUi:UpdateShinyFrames()
  ketchum.battleUi:RecordEncounterData()
end

function ketchum.events:PET_BATTLE_OVER()
  ketchum.battleUi:AfterBattle()
end

function ketchum.events:PET_BATTLE_PET_CHANGED(_, owner)
  if owner == Enum.BattlePetOwner.Enemy then
    ketchum.battleUi:UpdateShinyFrames()
  end
end

ketchum.events:RegisterEvent("PET_BATTLE_OPENING_START")
ketchum.events:RegisterEvent("PET_BATTLE_OVER")
ketchum.events:RegisterEvent("PET_BATTLE_PET_CHANGED")
ketchum.events:SetScript("OnEvent", ketchum.events.OnEvent)