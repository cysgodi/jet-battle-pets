local _, ketchum = ...

local events = CreateFrame("Frame")

function events:OnEvent(event, ...)
  self[event](self, event, ...)
end

function events:ADDON_LOADED(event, addonname)
  if addonname == "Rematch" then
    ketchum.rematch:AddHasShinyBadge()
    ketchum.rematch:AddIsShinyBadge()
  end
end

function events:PET_BATTLE_OPENING_START()
  ketchum.battleUi:UpdateShinyFrames()
end

function events:PET_BATTLE_OVER()
  ketchum.battleUi:AfterBattle()
end

function events:PET_BATTLE_PET_CHANGED(_, owner)
  if owner == Enum.BattlePetOwner.Enemy then
    ketchum.battleUi:UpdateShinyFrames()
  end
end

events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PET_BATTLE_OPENING_START")
events:RegisterEvent("PET_BATTLE_OVER")
events:RegisterEvent("PET_BATTLE_PET_CHANGED")
events:SetScript("OnEvent", events.OnEvent)