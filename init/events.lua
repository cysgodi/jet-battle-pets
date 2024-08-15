local _, ketchum = ...


local events = CreateFrame("Frame")

function events:OnEvent(event, ...)
  self[event](self, event, ...)
end

function events:ADDON_LOADED(event, addonname)
  if(addonname == "Rematch") then
    ketchum.rematch:AddShinyBadge()
  end
end

events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", events.OnEvent)