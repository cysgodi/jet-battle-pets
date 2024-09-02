local _, ketchum = ...

--[[
  This file hooks into any events necessary for 3rd party integrations.
]]

function ketchum.events:PLAYER_ENTERING_WORLD()
  if not C_AddOns.IsAddOnLoaded("Ketchum") then
    return
  end

  if C_AddOns.IsAddOnLoaded("Rematch") then
    if ketchum.state.REMATCH_INIT_COMPLETE then
      return
    end

    ketchum.rematch:AddHasShinyBadge()
    ketchum.rematch:AddIsShinyBadge()
    ketchum.rematch:AddVariantStats()
    ketchum.rematch:AddModelRarity()
    ketchum.state.REMATCH_INIT_COMPLETE = true
  end
end

ketchum.events:RegisterEvent("PLAYER_ENTERING_WORLD")