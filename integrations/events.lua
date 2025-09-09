local _, JetBattlePets = ...

--[[
  This file hooks into any events necessary for 3rd party integrations.
]]

local function OnPlayerEnteringWorld()
  if not C_AddOns.IsAddOnLoaded("JetBattlePets") then
    return
  end

  if C_AddOns.IsAddOnLoaded("Rematch") then
    if JetBattlePets.state.REMATCH_INIT_COMPLETE then
      return
    end

    JetBattlePets.rematch:AddIsShinyBadge()
    JetBattlePets.rematch:AddVariantFilters()
    JetBattlePets.rematch:AddVariantStats()
    JetBattlePets.rematch:AddModelRarity()
    JetBattlePets.state.REMATCH_INIT_COMPLETE = true
  end
end

JetBattlePets.events:RegisterEvent("PLAYER_ENTERING_WORLD")
JetBattlePets.events:OnEvent("PLAYER_ENTERING_WORLD", OnPlayerEnteringWorld)
