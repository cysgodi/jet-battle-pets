local _, JetBattlePets = ...

-- a window for displaying battle pet variant models
JetBattlePets.frames.VariantModelsWindow = JetBattlePets.frames.VariantModelsWindow or CreateFrame(
  "Frame",
  "VariantModels",
  UIParent,
  "PortraitFrameTemplate"
)

JetBattlePets.frames.VariantModelsWindow:SetPoint("CENTER")
JetBattlePets.frames.VariantModelsWindow:SetClampedToScreen(true)
JetBattlePets.frames.VariantModelsWindow:SetMovable(true)
JetBattlePets.frames.VariantModelsWindow:EnableMouse(true)
JetBattlePets.frames.VariantModelsWindow:RegisterForDrag("LeftButton")

JetBattlePets.frames.VariantModelsWindow:SetScript("OnMouseDown", function(self)
  self:StartMoving()
end)

JetBattlePets.frames.VariantModelsWindow:SetScript("OnMouseUp", function(self)
  self:StopMovingOrSizing()
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

-- update the models that are shown in the window
function JetBattlePets.frames.VariantModelsWindow:UpdateModels(petInfo)
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
function JetBattlePets.frames.VariantModelsWindow:UpdateSize(speciesID)
  local gridDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_GRID
  local modelDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL
  local windowDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_WINDOW

  local numDisplays = C_PetJournal.GetNumDisplays(speciesID)

  local gridHeight = JetBattlePets.grid:GetHeight(
    modelDimensions.HEIGHT,
    numDisplays,
    gridDimensions.MAX_COLS
  )

  local gridWidth = JetBattlePets.grid:GetWidth(
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

function JetBattlePets.frames.VariantModelsWindow:UpdateVariantModel(
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
  local modelDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL
  local gridDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_GRID
  local windowDimensions = JetBattlePets.constants.DIMENSIONS.VARIANT_MODEL_WINDOW

  self:SetSize(
    modelDimensions.WIDTH,
    modelDimensions.HEIGHT
  )

  self.Border:SetSize(
    modelDimensions.WIDTH,
    modelDimensions.HEIGHT
  )
  self.Border:SetPoint("TOPLEFT")
  self.Border:SetTexCoord(0, 0.171875, 0, 0.171875)
  self.Border:SetAllPoints()

  local column = JetBattlePets.grid:GetColumn(modelSlot, gridDimensions.MAX_COLS)
  local row = JetBattlePets.grid:GetRow(modelSlot, gridDimensions.MAX_COLS)

  local xOffset = windowDimensions.MARGIN_LEFT + modelDimensions.WIDTH * column

  -- y offset has to be negative to downshift
  local yOffset = -1 * modelDimensions.HEIGHT
      * row
      - windowDimensions.MARGIN_TOP

  self:SetPoint("TOPLEFT", xOffset, yOffset)
end

-- get the atlas for the background texture of a model
local function GetBorderColor(speciesID, modelSlot)
  local modelRarity = JetBattlePets.journal:GetDisplayRarityByIndex(
    speciesID,
    modelSlot
  )

  if modelRarity == 'SHINY' then
    return 0, 1, 1
  elseif modelRarity == 'RARE' then
    return 0.25, 0.25, 1
  elseif modelRarity == 'UNCOMMON' then
    return 0, 1, 0
  end

  return 1, 1, 1
end

-- set the 3D model displayed and animated by the frame
function VariantModelMixin:SetModel(speciesID, modelSlot)
  local modelSceneID = C_PetJournal.GetPetModelSceneInfoBySpeciesID(speciesID)

  self.Border:SetVertexColor(GetBorderColor(speciesID, modelSlot))

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
