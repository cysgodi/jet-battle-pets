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

  self:UpdateModels(speciesID)
  self:Show()
end

---Update the models that are shown in the window
---@param speciesID integer
function JetBattlePets.frames.VariantModelsWindow:UpdateModels(speciesID)
  if self.CurrentSpeciesID == speciesID then
    return
  end

  local petInfo = JetBattlePets.pets.GetPet(speciesID)

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
  local gridDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_GRID
  local modelFrameDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_FRAME
  local windowDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_WINDOW
  local titleBarButtonSize = JetBattlePets.constants.DIMENSIONS.TITLE_BAR_BUTTON.SIZE

  local numDisplays = C_PetJournal.GetNumDisplays(self.CurrentSpeciesID)

  local gridHeight = JetBattlePets.grid:GetHeight(
    modelFrameDimensions.HEIGHT,
    numDisplays,
    gridDimensions.MAX_COLS
  )

  local gridWidth = JetBattlePets.grid:GetWidth(
    modelFrameDimensions.WIDTH,
    numDisplays,
    gridDimensions.MAX_COLS
  )

  local windowHeight = gridHeight
      + windowDimensions.MARGIN_TOP
      + windowDimensions.MARGIN_BOTTOM

  local windowWidth = gridWidth
      + windowDimensions.MARGIN_LEFT
      + windowDimensions.MARGIN_RIGHT


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

---@class VariantModelBorder: Frame
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

  self.Background:SetFrameLevel(4)
  self.Background:SetPoint("TOP")
  self.Background:SetSize(
    modelDimensions.HEIGHT,
    modelDimensions.WIDTH
  )

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

  self.VariantModelText:SetPoint("BOTTOM")
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

  self.VariantModel:TransitionToModelSceneID(
    modelSceneID,
    CAMERA_TRANSITION_TYPE_IMMEDIATE,
    CAMERA_MODIFICATION_TYPE_MAINTAIN,
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
  self.VariantModelText.OwnedTextIcon:SetText(ownedIcon)
  self.VariantModelText.OwnedTextIcon:SetTextScale(2)
  self.VariantModelText.OwnedTextIcon:SetPoint("LEFT")

  self.VariantModelText.OwnedText = self.VariantModelText.OwnedText or
      self.VariantModelText:CreateFontString("OwnedText")
  self.VariantModelText.OwnedText:SetText(tostring(numOwned))
  self.VariantModelText.OwnedText:SetPoint("LEFT", self.VariantModelText.OwnedTextIcon, "RIGHT")

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
