local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

--[[
  These are utility functions to use to deal with colors.
]]

JetBattlePets.color = JetBattlePets.color or {}

function JetBattlePets.color:GetRarityColor(rarityName)
  local rarityColor = JetBattlePets.constants.COLORS.RARITY[rarityName]

  return CreateColorFromHexString('ff' .. rarityColor)
end
