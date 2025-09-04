local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

---@class VariantModelsWindow : Frame A window for displaying battle pet variant models
---@field VariantModels VariantModelMixin[]
JetBattlePets.frames.VariantModelsWindow = JetBattlePets.frames.VariantModelsWindow or CreateFrame(
  "Frame",
  "VariantModels",
  UIParent,
  "PortraitFrameTemplate"
)

JetBattlePets.frames.VariantModelsWindow:SetPoint("CENTER")
JetBattlePets.frames.VariantModelsWindow:SetClampedToScreen(true)
JetBattlePets.frames.VariantModelsWindow:SetMovable(true)

JetBattlePets.frames.VariantModelsWindow.DragHandle = JetBattlePets.frames.VariantModelsWindow.DragHandle or CreateFrame(
  "Frame",
  "VariantModelsDragHandle",
  JetBattlePets.frames.VariantModelsWindow
)
JetBattlePets.frames.VariantModelsWindow.DragHandle:SetPoint("TOPLEFT")

JetBattlePets.frames.VariantModelsWindow.DragHandle:EnableMouse(true)
JetBattlePets.frames.VariantModelsWindow.DragHandle:RegisterForDrag("LeftButton")

JetBattlePets.frames.VariantModelsWindow.DragHandle:SetScript("OnMouseDown", function(self)
  local parent = self:GetParent() --[[@as Frame]]

  if not parent then
    return
  end

  parent:StartMoving()
end)

JetBattlePets.frames.VariantModelsWindow.DragHandle:SetScript("OnMouseUp", function(self)
  local parent = self:GetParent() --[[@as Frame]]

  if not parent then
    return
  end

  parent:StopMovingOrSizing()
end)

_G["JetBattlePetsVariantModelsWindowFrame"] = JetBattlePets.frames.VariantModelsWindow
tinsert(UISpecialFrames, "JetBattlePetsVariantModelsWindowFrame")

JetBattlePets.frames.VariantModelsWindow:Hide()

ButtonFrameTemplate_HidePortrait(JetBattlePets.frames.VariantModelsWindow)

JetBattlePets.frames.VariantModelsWindow.VariantModels = {}
JetBattlePets.frames.VariantModelsWindow.initDone = true


-- hide any existing variant models
function JetBattlePets.frames.VariantModelsWindow:ResetVariantModels()
  if not self.VariantModels then
    return
  end

  for _, frame in pairs(self.VariantModels) do
    if frame and frame:IsShown() then
      frame:Hide()
    end
  end
end

function JetBattlePets.frames.VariantModelsWindow:ResetDisclaimer()
  if not self.Disclaimer then
    return
  end

  self.Disclaimer:Hide()
end

local function GetWindowSize(speciesID)
  local gridDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_GRID
  local modelFrameDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_FRAME
  local windowDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_WINDOW

  local disclaimerHeight = 0
  local numModels = C_PetJournal.GetNumDisplays(speciesID)

  if C_PetJournal.PetUsesRandomDisplay(speciesID) then
    disclaimerHeight = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_WINDOW.DISCLAIMER_HEIGHT
  end

  local gridHeight = JetBattlePets.grid:GetHeight(
    modelFrameDimensions.HEIGHT,
    numModels,
    gridDimensions.MAX_COLS
  )

  local gridWidth = JetBattlePets.grid:GetWidth(
    modelFrameDimensions.WIDTH,
    numModels,
    gridDimensions.MAX_COLS
  )

  local windowHeight = gridHeight
      + windowDimensions.MARGIN_TOP
      + windowDimensions.MARGIN_BOTTOM
      + disclaimerHeight

  local windowWidth = gridWidth
      + windowDimensions.MARGIN_LEFT
      + windowDimensions.MARGIN_RIGHT

  return windowWidth, windowHeight
end

function JetBattlePets.frames.VariantModelsWindow:UpdateDisclaimer()
  self:ResetDisclaimer()

  if not self.CurrentSpeciesID or not C_PetJournal.PetUsesRandomDisplay(self.CurrentSpeciesID) then
    return
  end

  local disclaimerHeight = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_WINDOW.DISCLAIMER_HEIGHT
  local marginBottom = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_WINDOW.MARGIN_BOTTOM

  self.Disclaimer = self.Disclaimer or CreateFrame(
    "Frame",
    "VariantModelsDisclaimer",
    self
  )

  local windowWidth = GetWindowSize(self.CurrentSpeciesID)

  self.Disclaimer:SetSize(windowWidth - 8, disclaimerHeight)
  self.Disclaimer:SetPoint("BOTTOMLEFT", 8, marginBottom / 2)

  local randomIcon = CreateAtlasMarkup("lootroll-icon-need")

  local ownedIcon = CreateAtlasMarkup(JetBattlePets.constants.ATLAS_NAMES.CAGED_ICON)

  local numOwned = JetBattlePets.journal:GetNumOwned(self.CurrentSpeciesID, 0)

  local disclaimerText = "This model is randomized on summon"

  self.Disclaimer.OwnedTextIcon = self.Disclaimer.OwnedTextIcon or
      self.Disclaimer:CreateFontString("OwnedTextIcon", "ARTWORK", "GameFontNormal")
  self.Disclaimer.OwnedTextIcon:SetText(ownedIcon)
  self.Disclaimer.OwnedTextIcon:SetTextScale(2)
  self.Disclaimer.OwnedTextIcon:SetPoint("TOPLEFT", 8, 0)

  self.Disclaimer.OwnedText = self.Disclaimer.OwnedText or
      self.Disclaimer:CreateFontString("OwnedText", "ARTWORK", "GameFontNormal")
  self.Disclaimer.OwnedText:SetText(tostring(numOwned) .. "x Owned")
  self.Disclaimer.OwnedText:SetPoint("LEFT", self.Disclaimer.OwnedTextIcon, "RIGHT", 8, 0)

  self.Disclaimer.TextIcon = self.Disclaimer.TextIcon or
      self.Disclaimer:CreateFontString("TextIcon", "ARTWORK", "GameFontNormal")
  self.Disclaimer.TextIcon:SetText(randomIcon)
  self.Disclaimer.TextIcon:SetTextScale(1.5)
  self.Disclaimer.TextIcon:SetPoint("BOTTOMLEFT", 8, 0)

  self.Disclaimer.Text = self.Disclaimer.Text or
      self.Disclaimer:CreateFontString("DisclaimerText", "ARTWORK", "GameFontNormal")
  self.Disclaimer.Text:SetText(disclaimerText)
  self.Disclaimer.Text:SetJustifyH("LEFT")
  self.Disclaimer.Text:SetTextScale(0.75)
  self.Disclaimer.Text:SetPoint("LEFT", self.Disclaimer.TextIcon, "RIGHT", 8, 0)

  self.Disclaimer:Show()
end

---Set the species whose models are displayed by the window.
---@param speciesID integer
function JetBattlePets.frames.VariantModelsWindow:SetModels(speciesID)
  if not JetBattlePets.settings.SHOW_VARIANT_MODEL_VIEWER then
    return
  end

  if self.CurrentSpeciesID == speciesID then
    if self:IsShown() then
      self:Hide()
    else
      self:Show()
    end

    return
  end

  self.CurrentSpeciesID = speciesID
  self:UpdateDisclaimer()
  self:UpdateModels()
  self:Show()
end

---Update the models that are shown in the window
function JetBattlePets.frames.VariantModelsWindow:UpdateModels()
  local petInfo = JetBattlePets.pets.GetPet(self.CurrentSpeciesID)

  self:ResetVariantModels()
  self.CurrentSpeciesID = petInfo.speciesID

  self.SetTitle(self, petInfo.name)

  local numDisplays = C_PetJournal.GetNumDisplays(self.CurrentSpeciesID)

  self:UpdateSize()

  for slot = 1, numDisplays do
    self:UpdateVariantModel(slot)
  end
end

-- update window size based on the species being displayed
function JetBattlePets.frames.VariantModelsWindow:UpdateSize()
  local titleBarButtonSize = JetBattlePets.constants.DIMENSIONS.TITLE_BAR_BUTTON.SIZE

  local windowWidth, windowHeight = GetWindowSize(self.CurrentSpeciesID)

  self.DragHandle:SetSize(
    windowWidth - titleBarButtonSize,
    titleBarButtonSize
  )

  self:SetSize(
    windowWidth,
    windowHeight
  )
end

function JetBattlePets.frames.VariantModelsWindow:UpdateVariantModel(
    modelSlot
)
  if not self.VariantModels[modelSlot] then
    self.VariantModels[modelSlot] = CreateFrame(
      "Frame",
      "VariantModel" .. modelSlot,
      self,
      "VariantModelTemplate"
    ) --[[@as VariantModelMixin]]
  end

  self.VariantModels[modelSlot].CurrentSpeciesID = self.CurrentSpeciesID
  self.VariantModels[modelSlot]:ShowModel(modelSlot)
end

---@class VariantModelBackground : Frame
---@field BackgroundTexture TextureBase

---@class VariantModelBorder : Frame
---@field BorderTexture TextureBase

---@class VariantModelText : Frame
---@field OwnedTextIcon FontString
---@field OwnedText FontString
---@field RarityText FontString

---@class VariantModelMixin : ModelScene A template for frames displaying battle pet variant models
---@field Background VariantModelBackground
---@field Border VariantModelBorder
---@field CurrentSpeciesID integer
---@field VariantModel ModelScene
---@field VariantModelText VariantModelText
VariantModelMixin = {}


-- set frame size and offset based on the display slot
function VariantModelMixin:SetDimensions(modelSlot)
  local modelDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL
  local modelFrameDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_FRAME
  local gridDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_GRID
  local windowDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_WINDOW

  local column = JetBattlePets.grid:GetColumn(modelSlot, gridDimensions.MAX_COLS)
  local row = JetBattlePets.grid:GetRow(modelSlot, gridDimensions.MAX_COLS)

  local xOffset = windowDimensions.MARGIN_LEFT
      + modelFrameDimensions.WIDTH * column
      + windowDimensions.TEMPLATE_HORIZONTAL_OFFSET

  -- y offset has to be negative to downshift
  local yOffset = -1 * modelFrameDimensions.HEIGHT * row
      - windowDimensions.MARGIN_TOP

  self:SetSize(
    modelFrameDimensions.WIDTH,
    modelFrameDimensions.HEIGHT
  )
  self:SetPoint("TOPLEFT", xOffset, yOffset)

  self.Border:SetFrameLevel(6)
  self.Border:SetPoint("TOP")
  self.Border:SetSize(
    modelDimensions.HEIGHT,
    modelDimensions.WIDTH
  )

  self.VariantModel:SetFrameLevel(5)
  self.VariantModel:SetPoint("TOP")
  self.VariantModel:SetSize(
    modelDimensions.WIDTH,
    modelDimensions.HEIGHT
  )

  self.Background:SetFrameLevel(4)
  self.Background:SetPoint("TOP")
  self.Background:SetSize(
    modelDimensions.HEIGHT,
    modelDimensions.WIDTH
  )

  self.VariantModelText:SetPoint("BOTTOM", 0, 16)
  self.VariantModelText:SetSize(
    modelDimensions.WIDTH - 8,
    24
  )
end

-- get the atlas for the background texture of a model
local function GetVariantBorderAtlasName(speciesID, displayID)
  local ATLAS_NAMES = JetBattlePets.constants.ATLAS_NAMES
  local numOwned = JetBattlePets.journal:GetNumOwned(speciesID, displayID)

  if numOwned > 0 then
    return ATLAS_NAMES.VARIANT_OUTLINE_OWNED
  end

  return ATLAS_NAMES.VARIANT_OUTLINE_UNOWNED
end

---Add the appropriate background to the frame
---@param displayID integer
function VariantModelMixin:SetBackground(displayID)
  local rarityName = JetBattlePets.journal:GetDisplayRarityName(
    self.CurrentSpeciesID,
    displayID
  )

  local rarityColor = JetBattlePets.color:GetRarityColor(rarityName)
  local r, g, b = rarityColor:GetRGBA()

  self.Background.BackgroundTexture = self.Background.BackgroundTexture or self.Background:CreateTexture(
    "BackgroundTexture",
    "BACKGROUND"
  )
  self.Background.BackgroundTexture:SetColorTexture(r, g, b, 0.25)
  self.Background.BackgroundTexture:SetPoint("TOPLEFT", 2, -2)
  self.Background.BackgroundTexture:SetPoint("BOTTOMRIGHT", -2, 2)
end

---Add the appropriate border to the frame
---@param displayID integer
function VariantModelMixin:SetBorder(displayID)
  local atlasName = GetVariantBorderAtlasName(self.CurrentSpeciesID, displayID)

  self.Border.BorderTexture = self.Border.BorderTexture or self:CreateTexture()
  self.Border.BorderTexture:SetAtlas(atlasName)
  self.Border.BorderTexture:SetPoint("TOPLEFT", -12, 4)
  self.Border.BorderTexture:SetPoint("BOTTOMRIGHT", 12, -12)
end

---Set the 3D model displayed and animated by the frame
---@param displayID integer
function VariantModelMixin:SetModel(displayID)
  local modelSceneID = C_PetJournal.GetPetModelSceneInfoBySpeciesID(self.CurrentSpeciesID)

  self.VariantModel = self.VariantModel or CreateFrame(
    "ModelScene",
    "VariantModel",
    self,
    "VariantModelSceneTemplate"
  ) --[[@as ModelScene]]

  self.VariantModel:ClearScene()
  self.VariantModel:TransitionToModelSceneID(
    modelSceneID,
    CAMERA_TRANSITION_TYPE_IMMEDIATE,
    CAMERA_MODIFICATION_TYPE_DISCARD,
    false
  )

  local actor = self.VariantModel:GetActorByTag("unwrapped")

  if actor then
    actor:SetModelByCreatureDisplayID(displayID)
    actor:SetAnimation(0, -1)
  end
end

---Set variant model text components
---@param displayID integer
function VariantModelMixin:SetVariantModelText(displayID)
  local usesRandomModel = C_PetJournal.PetUsesRandomDisplay(self.CurrentSpeciesID)

  local numOwned = JetBattlePets.journal:GetNumOwned(
    self.CurrentSpeciesID,
    displayID
  )
  local ownedIcon = CreateAtlasMarkup(JetBattlePets.constants.ATLAS_NAMES.CAGED_ICON)

  local rarityText = JetBattlePets.journal:GetDisplayProbabilityText(
    self.CurrentSpeciesID,
    displayID
  )

  self.VariantModelText.OwnedTextIcon = self.VariantModelText.OwnedTextIcon or
      self.VariantModelText:CreateFontString("OwnedTextIcon")
  self.VariantModelText.OwnedTextIcon:Hide()

  if not usesRandomModel then
    self.VariantModelText.OwnedTextIcon:SetText(ownedIcon)
    self.VariantModelText.OwnedTextIcon:SetTextScale(2)
    self.VariantModelText.OwnedTextIcon:SetPoint("LEFT")
    self.VariantModelText.OwnedTextIcon:Show()
  end

  self.VariantModelText.OwnedText = self.VariantModelText.OwnedText or
      self.VariantModelText:CreateFontString("OwnedText")
  self.VariantModelText.OwnedText:Hide()

  if not usesRandomModel then
    self.VariantModelText.OwnedText:SetText(tostring(numOwned))
    self.VariantModelText.OwnedText:SetPoint("LEFT", self.VariantModelText.OwnedTextIcon, "RIGHT")
    self.VariantModelText.OwnedText:Show()
  end

  self.VariantModelText.RarityText = self.VariantModelText.RarityText or
      self.VariantModelText:CreateFontString("RarityText")
  self.VariantModelText.RarityText:SetText(rarityText)
  self.VariantModelText.RarityText:SetPoint("RIGHT")
end

---Show the actual variant model
---@param modelSlot integer
function VariantModelMixin:ShowModel(modelSlot)
  local displayID = C_PetJournal.GetDisplayIDByIndex(
    self.CurrentSpeciesID,
    modelSlot
  )

  self:SetBorder(displayID)
  self:SetBackground(displayID)
  self:SetModel(displayID)
  self:SetVariantModelText(displayID)
  self:SetDimensions(modelSlot)
  self:Show()
end
