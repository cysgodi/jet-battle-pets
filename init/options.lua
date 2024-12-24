local _, ketchum = ...

ketchum.options = {}

-- init dropdown to choose alert threshold rarity
local function InitAlertThresholdOption(category)
  local alertThresholdSetting = Settings.RegisterProxySetting(
    category,
    "KETCHUM_ALERT_THRESHOLD",
    Settings.VarType.Number,
    "Alert Rarity",
    ketchum.constants.RARITIES.SHINY,
    function() return ketchum.settings.ALERT_THRESHOLD end,
    function(value) ketchum.settings.ALERT_THRESHOLD = value end
  )

  local function GetOptions()
    local container = Settings.CreateControlTextContainer()

    for value, rarity in ipairs(ketchum.constants.RARITY_NAMES) do
      if value ~= ketchum.constants.RARITIES.COMMON then
        local prettyRarity = ketchum.text:FormatRarityName(rarity)
        local label = ketchum.text:SetColorByName(value, prettyRarity)

        container:Add(
          value,
          label
        )
      end
    end

    return container:GetData()
  end

  Settings.CreateDropdown(
    category,
    alertThresholdSetting,
    GetOptions,
    "Prints a message to the chat window and plays an audio alert when one or more enemy pets in a wild pet battle is at least as rare as the selected rarity."
  )
end

-- init checkbox to toggle encounter recording
local function InitRecordEncountersOption(category)
  local isRecordingSetting = Settings.RegisterProxySetting(
    category,
    "KETCHUM_IS_RECORDING",
    Settings.VarType.Boolean,
    "Record Encounters",
    Settings.Default.False,
    function() return ketchum.settings.ENABLE_DATA_COLLECTION end,
    function(value) ketchum.settings.ENABLE_DATA_COLLECTION = value end
  )

  Settings.CreateCheckbox(category, isRecordingSetting)
end

-- init addon options on load
function ketchum.options:InitializeOptions()
  local category = Settings.RegisterVerticalLayoutCategory("Ketchum")

  InitAlertThresholdOption(category)
  InitRecordEncountersOption(category)

  Settings.RegisterAddOnCategory(category)
end
