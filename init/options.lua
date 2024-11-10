local _, ketchum = ...

ketchum.options = {}

-- init addon options on load
function ketchum.options:InitializeOptions()
  local category, layout = Settings.RegisterVerticalLayoutCategory("Ketchum")

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
  Settings.RegisterAddOnCategory(category)
end
