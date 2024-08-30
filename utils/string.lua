local _, ketchum = ...

ketchum.text = {}

-- Given the hex value of a color and some text, return a string literal
-- in the form `|c00XXYYZZProvidedTextr|`.
function ketchum.text:SetColor(colorHexString, text)
  return format(
    "%s%s%s%s",
    ketchum.constants.TEXT_FORMAT.COOLOR_PREFIX,
    colorHexString,
    text,
    ketchum.constants.TEXT_FORMAT.COLOR_TERMINATOR
  )
end

-- Set the color of the given text to the color with the given name.
-- Uses the default UI text color if the color name is invalid.
function ketchum:SetColorByName(colorName, text)
  local color = ketchum.constants.TEXT_FORMAT.COLORS[colorName]

  if color == nil then
    return text
  end

  return ketchum.text:SetColor(color, text)
end