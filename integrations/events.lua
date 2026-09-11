local _, JetBattlePets = ...

--[[
  This file hooks into any events necessary for 3rd party integrations.
]]

function JetBattlePets.events:PLAYER_ENTERING_WORLD()
  if not C_AddOns.IsAddOnLoaded("JetBattlePets") then
    return
  end

  if C_AddOns.IsAddOnLoaded("Rematch") and not JetBattlePets.state.REMATCH_INIT_COMPLETE and Rematch then
    JetBattlePets.rematch:AddIsShinyBadge()
    JetBattlePets.rematch:AddVariantFilters()
    JetBattlePets.rematch:AddVariantStats()
    JetBattlePets.rematch:AddModelRarity()
    JetBattlePets.rematch:PatchRematchExpansions()
    JetBattlePets.state.REMATCH_INIT_COMPLETE = true
  end
end

JetBattlePets.events:RegisterEvent("PLAYER_ENTERING_WORLD")
