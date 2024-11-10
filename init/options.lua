local _, ketchum = ...

ketchum.options = {}

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

  InitRecordEncountersOption(category)

  Settings.RegisterAddOnCategory(category)
end
