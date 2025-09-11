local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.text = JetBattlePets.text or {}

function JetBattlePets.text:Capitalize(text)
  return text:gsub("^%l", string.upper)
end

function JetBattlePets.text:FormatRarityName(rarity)
  return JetBattlePets.text:Capitalize(string.lower(rarity))
end

function JetBattlePets.text:FormatProbability(probability)
  return string.format(
    JetBattlePets.constants.TEXT_FORMAT.PATTERNS.PROBABILITY,
    probability
  )
end

function JetBattlePets.text:GetRarityText(probability, maxProbability)
  local ratio = maxProbability / probability
  local rarity = JetBattlePets.constants.RARITIES.COMMON
  local probabilityText = JetBattlePets.text:FormatProbability(probability)

  if ratio >= JetBattlePets.constants.RARITY_RATIOS.SHINY then
    rarity = JetBattlePets.constants.RARITIES.SHINY
  elseif ratio >= JetBattlePets.constants.RARITY_RATIOS.RARE then
    rarity = JetBattlePets.constants.RARITIES.RARE
  elseif ratio >= JetBattlePets.constants.RARITY_RATIOS.UNCOMMON then
    rarity = JetBattlePets.constants.RARITIES.UNCOMMON
  end

  return JetBattlePets.text:SetColorByName(
    rarity,
    probabilityText
  )
end

function JetBattlePets.text:Print(value)
  print(JetBattlePets.text:ToString(value))
end

function JetBattlePets.text:RepeatCharacter(character, times)
  local string = ""

  for _ = 1, times do
    string = string .. character
  end

  return string
end

function JetBattlePets.text:SetColor(colorHexString, text)
  return string.format(
    "%s%s%s%s",
    JetBattlePets.constants.TEXT_FORMAT.COLOR_PREFIX,
    colorHexString,
    text,
    JetBattlePets.constants.TEXT_FORMAT.COLOR_TERMINATOR
  )
end

function JetBattlePets.text:SetColorByName(rarity, text)
  local rarityName = JetBattlePets.constants.RARITY_NAMES[rarity]
  local color = JetBattlePets.constants.COLORS.RARITY[rarityName]

  if color == nil then
    return text
  end

  return JetBattlePets.text:SetColor(color, text)
end

function JetBattlePets.text:TableToString(table, indent)
  local spaces = JetBattlePets.text:RepeatCharacter(" ", indent)
  local subSpaces = JetBattlePets.text:RepeatCharacter(" ", indent + 2)
  local tableString = "[\n"

  for key, value in pairs(table) do
    local keyString = subSpaces .. key
    local valueString = JetBattlePets.text:ToString(value, indent + 2)
    tableString = tableString .. keyString .. " = " .. valueString
  end

  tableString = tableString .. spaces .. "]"

  return tableString
end

function JetBattlePets.text:ToString(value, indent)
  indent = indent or 0
  local valueString = value

  if type(value) == "function"
      or type(value) == "nil"
      or type(value) == "thread"
      or type(value) == "userdata"
  then
    valueString = JetBattlePets.text:Capitalize(type(value))
  elseif type(value) == "table" then
    valueString = JetBattlePets.text:TableToString(value, indent)
  elseif type(value) == "boolean" then
    valueString = value and "true" or "false"
  end

  return valueString .. "\n"
end
