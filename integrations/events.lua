local _, ketchum = ...

--[[
  This file hooks into any events necessary for 3rd party integrations.
]]

function ketchum.events:PLAYER_ENTERING_WORLD()
  if not C_AddOns.IsAddOnLoaded("Ketchum") then
    return
  end

  if C_AddOns.IsAddOnLoaded("Rematch") then
    ketchum.rematch:AddHasShinyBadge()
    ketchum.rematch:AddIsShinyBadge()
    ketchum.rematch:AddVariantStats()
  end
end

ketchum.events:RegisterEvent("PLAYER_ENTERING_WORLD")