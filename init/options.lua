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

------ DEVELOPER FEATURE FLAGS ------

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

----- init developer settings section
local function InitDeveloperSettingsSection(category, layout)
  layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(
    "Developer",
    "These are features that are only useful for the developer. You probably don't want to change them unless you need to collect logs."
  ))

  InitRecordEncountersOption(category)
end

------ EXPERIMENTAL FEATURE FLAGS ------

-- init checkbox to toggle variant model viewer
local function InitVariantModelViewerOption(category)
  local setting = Settings.RegisterProxySetting(
    category,
    "SHOW_VARIANT_MODEL_VIEWER",
    Settings.VarType.Boolean,
    "Variant Model Viewer",
    Settings.Default.False,
    function() return ketchum.settings.SHOW_VARIANT_MODEL_VIEWER end,
    function(value) ketchum.settings.SHOW_VARIANT_MODEL_VIEWER = value end
  )

  Settings.CreateCheckbox(category, setting,
    "Enable the variant model viewer, which lets you look at all variants of a battle pet side-by-side.")
end

-- init experimental settings section
local function InitExperimentalSettingsSection(category, layout)
  layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(
    "Experimental",
    "These are features that are in development. They may make the addon unstable."
  ))

  InitVariantModelViewerOption(category)
end

-- init addon options on load
function ketchum.options:InitializeOptions()
  local category, layout = Settings.RegisterVerticalLayoutCategory("Ketchum")

  InitAlertThresholdOption(category)
  InitExperimentalSettingsSection(category, layout)
  InitDeveloperSettingsSection(category, layout)

  Settings.RegisterAddOnCategory(category)
end
