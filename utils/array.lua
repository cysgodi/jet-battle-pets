local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.array = JetBattlePets.array or {}

function JetBattlePets.array:Concat(a, ...)
  local result = { unpack(a) }

  if ... == nil then
    return result
  elseif #{ ... } == 1 then
    local b = select(1, ...)

    for _, value in ipairs(b) do
      table.insert(result, value)
    end

    return result
  end

  local concatenatedArrays = self:Concat(...)

  return self:Concat(result, concatenatedArrays)
end

function JetBattlePets.array:Each(array, callback)
  if type(callback) ~= "function" then
    error("Invalid array callback")
    return
  end

  for index, value in pairs(array) do
    callback(value, index)
  end
end

function JetBattlePets.array:Slice(array, startIndex, endIndex)
  local result = {}
  startIndex = startIndex or 1
  endIndex = endIndex or #array

  for index = startIndex, endIndex do
    table.insert(result, array[index])
  end

  return result
end
