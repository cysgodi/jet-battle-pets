local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

--[[
  These are utility functions to use with basic grid layouts in frames. Grid columns and rows are 0-indexed, so watch out for off-by-one errors since LUA arrays are 1-indexed.
]]

JetBattlePets.grid = JetBattlePets.grid or {}

function JetBattlePets.grid:GetColumn(index, maxColumns)
  return (index + maxColumns - 1) % maxColumns
end

function JetBattlePets.grid:GetHeight(itemHeight, numItems, maxColumns)
  return itemHeight * math.floor((numItems + maxColumns - 1) / maxColumns)
      - JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_WINDOW.TITLE_BAR_HEIGHT
end

function JetBattlePets.grid:GetWidth(itemWidth, numItems, maxColumns)
  return itemWidth * math.min(numItems, maxColumns)
end

function JetBattlePets.grid:GetRow(index, maxColumns)
  return math.floor((index - 1) / maxColumns)
end
