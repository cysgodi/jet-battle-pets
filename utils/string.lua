local _, JetBattlePets = ...

JetBattlePets.text = {}

-- capitalize the first letter of a string
function JetBattlePets.text:Capitalize(text)
  return text:gsub("^%l", string.upper)
end

-- Given a text string, return a string literal where the first letter is
-- capitalized and the rest is lower case.
function JetBattlePets.text:FormatRarityName(rarity)
  return JetBattlePets.text:Capitalize(string.lower(rarity))
end

-- Given a number representing a percentage return a string literal in the
-- form `XX.YY%`.
function JetBattlePets.text:FormatProbability(probability)
  return string.format(
    JetBattlePets.constants.TEXT_FORMAT.PATTERNS.PROBABILITY,
    probability
  )
end

-- Given a number representing a probability as a percent, format it to
-- two decimal places of precision and color it by rarity.
function JetBattlePets.text:GetRarityText(probability, maxProbability)
  local ratio = maxProbability / probability
  local probabilityColor = JetBattlePets.constants.RARITIES.COMMON
  local probabilityText = JetBattlePets.text:FormatProbability(probability)

  if ratio >= JetBattlePets.constants.RARITY_RATIOS.SHINY then
    probabilityColor = JetBattlePets.constants.RARITIES.SHINY
  elseif ratio >= JetBattlePets.constants.RARITY_RATIOS.RARE then
    probabilityColor = JetBattlePets.constants.RARITIES.RARE
  elseif ratio >= JetBattlePets.constants.RARITY_RATIOS.UNCOMMON then
    probabilityColor = JetBattlePets.constants.RARITIES.UNCOMMON
  end

  return JetBattlePets.text:SetColorByName(
    probabilityColor,
    probabilityText
  )
end

-- Given the hex value of a color and some text, return a string literal
-- in the form `|c00XXYYZZProvidedTextr|`.
function JetBattlePets.text:SetColor(colorHexString, text)
  return string.format(
    "%s%s%s%s",
    JetBattlePets.constants.TEXT_FORMAT.COLOR_PREFIX,
    colorHexString,
    text,
    JetBattlePets.constants.TEXT_FORMAT.COLOR_TERMINATOR
  )
end

-- Set the color of the given text to the color with the given name.
-- Uses the default UI text color if the color name is invalid.
function JetBattlePets.text:SetColorByName(rarity, text)
  local rarityName = JetBattlePets.constants.RARITY_NAMES[rarity]
  local color = JetBattlePets.constants.TEXT_FORMAT.COLORS[rarityName]

  if color == nil then
    return text
  end

  return JetBattlePets.text:SetColor(color, text)
end
