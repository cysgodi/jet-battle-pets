local _, JetBattlePets = ...

--[[
  These are utility functions to use with basic grid layouts in frames. Grid columns and rows are 0-indexed, so watch out for off-by-one errors since LUA arrays are 1-indexed.
]]

JetBattlePets.grid = {}

-- determine what column a grid item is in based on its index and the
-- maximum number of columns in the grid
function JetBattlePets.grid:GetColumn(index, maxColumns)
  return (index + maxColumns - 1) % maxColumns
end

-- determine the total height of the grid
function JetBattlePets.grid:GetHeight(itemHeight, numItems, maxColumns)
  return itemHeight * math.floor((numItems + maxColumns - 1) / maxColumns)
end

-- determine the total width of the grid
function JetBattlePets.grid:GetWidth(itemWidth, numItems, maxColumns)
  return itemWidth * math.min(numItems, maxColumns)
end

-- determine what row a grid item is in based on its index and the
-- maximum number of columns in the grid
function JetBattlePets.grid:GetRow(index, maxColumns)
  return math.floor((index - 1) / maxColumns)
end
