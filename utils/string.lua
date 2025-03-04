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
