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
