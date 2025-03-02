local _, JetBattlePets = ...

--[[
  These are utility functions to use to deal with colors.
]]

JetBattlePets.color = {}

---Get the Color that represents a given rarity
---@param rarityName string
---@return Color
function JetBattlePets.color:GetRarityColor(rarityName)
  local rarityColor = JetBattlePets.constants.TEXT_FORMAT.COLORS[rarityName]

  return CreateColorFromHexString('ff' .. rarityColor)
end
