local _, ketchum = ...

-- a window for displaying battle pet variant models
ketchum.frames.VariantModelsWindow = ketchum.frames.VariantModelsWindow or CreateFrame(
  "Frame",
  "VariantModels",
  UIParent,
  "PortraitFrameTemplate"
)

ketchum.frames.VariantModelsWindow:SetPoint("CENTER")
ketchum.frames.VariantModelsWindow:SetClampedToScreen(true)
ketchum.frames.VariantModelsWindow:SetMovable(true)
ketchum.frames.VariantModelsWindow:EnableMouse(true)
ketchum.frames.VariantModelsWindow:RegisterForDrag("LeftButton")

ketchum.frames.VariantModelsWindow:SetScript("OnMouseDown", function(self)
  self:StartMoving()
end)

ketchum.frames.VariantModelsWindow:SetScript("OnMouseUp", function(self)
  self:StopMovingOrSizing()
end)

ketchum.frames.VariantModelsWindow:Hide()

ButtonFrameTemplate_HidePortrait(ketchum.frames.VariantModelsWindow)

ketchum.frames.VariantModelsWindow.VariantModels = {}
ketchum.frames.VariantModelsWindow.initDone = true


-- hide any existing variant models
function ketchum.frames.VariantModelsWindow:ResetVariantModels()
  if not self.VariantModels then
    return
  end

  for _, frame in pairs(self.VariantModels) do
    if frame and frame:IsShown() then
      frame:Hide()
    end
  end
end

-- update the models that are shown in the window
function ketchum.frames.VariantModelsWindow:UpdateModels(petInfo)
  if self.displayedSpeciesID == petInfo.speciesID then
    return
  end

  self:ResetVariantModels()
  self.displayedSpeciesID = petInfo.speciesID

  self.SetTitle(self, petInfo.name)

  local numDisplays = C_PetJournal.GetNumDisplays(petInfo.speciesID)

  self:UpdateSize(petInfo.speciesID)

  for slot = 1, numDisplays do
    self:UpdateVariantModel(petInfo.speciesID, slot)
  end
end

-- update window size based on the species being displayed
function ketchum.frames.VariantModelsWindow:UpdateSize(speciesID)
  local gridDimensions = ketchum.constants.DIMENSIONS.VARIANT_MODEL_GRID
  local modelDimensions = ketchum.constants.DIMENSIONS.VARIANT_MODEL
  local windowDimensions = ketchum.constants.DIMENSIONS.VARIANT_MODEL_WINDOW

  local numDisplays = C_PetJournal.GetNumDisplays(speciesID)

  local gridHeight = ketchum.grid:GetHeight(
    modelDimensions.HEIGHT,
    numDisplays,
    gridDimensions.MAX_COLS
  )

  local gridWidth = ketchum.grid:GetWidth(
    modelDimensions.WIDTH,
    numDisplays,
    gridDimensions.MAX_COLS
  )

  local windowHeight = gridHeight
      + windowDimensions.MARGIN_TOP
      + windowDimensions.MARGIN_BOTTOM

  local windowWidth = gridWidth
      + windowDimensions.MARGIN_LEFT
      + windowDimensions.MARGIN_RIGHT

  self:SetSize(
    windowWidth,
    windowHeight
  )
end

function ketchum.frames.VariantModelsWindow:UpdateVariantModel(
    speciesID,
    modelSlot
)
  if not self.VariantModels[modelSlot] then
    self.VariantModels[modelSlot] = CreateFrame(
      "ModelScene",
      "VariantModel" .. modelSlot,
      self,
      "VariantModelTemplate"
    )
  end

  self.VariantModels[modelSlot]:ShowModel(speciesID, modelSlot)
end

-- a template for frames displaying battle pet variant models
VariantModelMixin = {}


-- set frame size and offset based on the display slot
function VariantModelMixin:SetDimensions(modelSlot)
  local modelDimensions = ketchum.constants.DIMENSIONS.VARIANT_MODEL
  local gridDimensions = ketchum.constants.DIMENSIONS.VARIANT_MODEL_GRID
  local windowDimensions = ketchum.constants.DIMENSIONS.VARIANT_MODEL_WINDOW

  self:SetSize(
    modelDimensions.WIDTH,
    modelDimensions.HEIGHT
  )

  local column = ketchum.grid:GetColumn(modelSlot, gridDimensions.MAX_COLS)
  local row = ketchum.grid:GetRow(modelSlot, gridDimensions.MAX_COLS)

  local xOffset = windowDimensions.MARGIN_LEFT + modelDimensions.WIDTH * column

  -- y offset has to be negative to downshift
  local yOffset = -1 * modelDimensions.HEIGHT
      * row
      - windowDimensions.MARGIN_TOP

  self:SetPoint("TOPLEFT", xOffset, yOffset)
end

-- set the 3D model displayed and animated by the frame
function VariantModelMixin:SetModel(speciesID, modelSlot)
  local modelSceneID = C_PetJournal.GetPetModelSceneInfoBySpeciesID(speciesID)

  self:TransitionToModelSceneID(
    modelSceneID,
    CAMERA_TRANSITION_TYPE_IMMEDIATE,
    CAMERA_MODIFICATION_TYPE_MAINTAIN,
    false
  )

  local actor = self:GetActorByTag("unwrapped")

  if actor then
    local displayID = C_PetJournal.GetDisplayIDByIndex(speciesID, modelSlot)

    actor:SetModelByCreatureDisplayID(displayID)
    actor:SetAnimation(0, -1)
  end
end

-- show the actual variant model
function VariantModelMixin:ShowModel(speciesID, modelSlot)
  self:SetDimensions(modelSlot)
  self:SetModel(speciesID, modelSlot)
  self:Show()
end
