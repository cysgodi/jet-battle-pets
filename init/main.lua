local f = CreateFrame("Frame", "KetchumFrame", UIParent)

function f:OnEvent(event, ...)
  self[event](self, event, ...)
end

function f:ADDON_LOADED(event, addonname)
  if(addonname == "Rematch") then
    
  end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)