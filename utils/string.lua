local _, ketchum = ...

ketchum.text = {}

-- capitalize the first letter of a string
function ketchum.text:Capitalize(text)
  return text:gsub("^%l", string.upper)
end

-- Given a text string, return a string literal where the first letter is
-- capitalized and the rest is lower case.
function ketchum.text:FormatRarityName(rarity)
  return ketchum.text:Capitalize(string.lower(rarity))
end

-- Given a number representing a percentage return a string literal in the
-- form `XX.YY%`.
function ketchum.text:FormatProbability(probability)
  return string.format(
    ketchum.constants.TEXT_FORMAT.PATTERNS.PROBABILITY,
    probability
  )
end

-- Given a number representing a probability as a percent, format it to
-- two decimal places of precision and color it by rarity.
function ketchum.text:GetRarityText(probability, maxProbability)
  local ratio = maxProbability / probability
  local probabilityColor = ketchum.constants.RARITIES.COMMON
  local probabilityText = ketchum.text:FormatProbability(probability)

  if ratio >= ketchum.constants.RARITY_RATIOS.SHINY then
    probabilityColor = ketchum.constants.RARITIES.SHINY
  elseif ratio >= ketchum.constants.RARITY_RATIOS.RARE then
    probabilityColor = ketchum.constants.RARITIES.RARE
  elseif ratio >= ketchum.constants.RARITY_RATIOS.UNCOMMON then
    probabilityColor = ketchum.constants.RARITIES.UNCOMMON
  end

  return ketchum.text:SetColorByName(
    probabilityColor,
    probabilityText
  )
end

-- Given the hex value of a color and some text, return a string literal
-- in the form `|c00XXYYZZProvidedTextr|`.
function ketchum.text:SetColor(colorHexString, text)
  return string.format(
    "%s%s%s%s",
    ketchum.constants.TEXT_FORMAT.COLOR_PREFIX,
    colorHexString,
    text,
    ketchum.constants.TEXT_FORMAT.COLOR_TERMINATOR
  )
end

-- Set the color of the given text to the color with the given name.
-- Uses the default UI text color if the color name is invalid.
function ketchum.text:SetColorByName(rarity, text)
  local rarityName = ketchum.constants.RARITY_NAMES[rarity]
  local color = ketchum.constants.TEXT_FORMAT.COLORS[rarityName]

  if color == nil then
    return text
  end

  return ketchum.text:SetColor(color, text)
end
