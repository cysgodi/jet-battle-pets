local _, JetBattlePets = ...

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
  local titleBarButtonSize = JetBattlePets.constants.DIMENSIONS.TITLE_BAR_BUTTON.SIZE

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
    speciesID,
    modelSlot
)
  if not self.VariantModels[modelSlot] then
    self.VariantModels[modelSlot] = CreateFrame(
      "ModelScene",
      "VariantModel" .. modelSlot,
      self,
      "VariantModelTemplate"
    ) --[[@as VariantModelMixin]]
  end

  self.VariantModels[modelSlot]:ShowModel(speciesID, modelSlot)
end

---@class VariantModelMixin : ModelScene A template for frames displaying battle pet variant models
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
local function GetVariantBorderAtlasName(speciesID, displayID)
  local modelRarity = JetBattlePets.journal:GetDisplayRarity(
    speciesID,
    displayID
  )

  for index = 1, C_PetJournal.GetNumPets() do
    local petID, _speciesID = C_PetJournal.GetPetInfoByIndex(index)

    if _speciesID == speciesID then
      local petInfo = JetBattlePets.pets.GetPet(petID)
      if petInfo.displayID == displayID then
        if modelRarity == "SHINY" then
          return JetBattlePets.constants.GRAPHICS.OWNED_SHINY_VARIANT_OUTLINE_ATLAS_NAME
        end

        return JetBattlePets.constants.GRAPHICS.OWNED_VARIANT_OUTLINE_ATLAS_NAME
      end
    end
  end

  if modelRarity == "SHINY" then
    return JetBattlePets.constants.GRAPHICS.UNOWNED_SHINY_VARIANT_OUTLINE_ATLAS_NAME
  end

  return JetBattlePets.constants.GRAPHICS.UNOWNED_VARIANT_OUTLINE_ATLAS_NAME
end

-- set the 3D model displayed and animated by the frame
function VariantModelMixin:SetModel(speciesID, modelSlot)
  local displayID = C_PetJournal.GetDisplayIDByIndex(speciesID, modelSlot)
  local modelSceneID = C_PetJournal.GetPetModelSceneInfoBySpeciesID(speciesID)

  self.BorderTexture = self.BorderTexture or self:CreateTexture()
  local atlasName = GetVariantBorderAtlasName(speciesID, displayID)
  self.BorderTexture:SetAtlas(atlasName)
  self.BorderTexture:SetAllPoints()

  self.Border:SetTexture(self.BorderTexture)

  self:TransitionToModelSceneID(
    modelSceneID,
    CAMERA_TRANSITION_TYPE_IMMEDIATE,
    CAMERA_MODIFICATION_TYPE_MAINTAIN,
    false
  )

  local actor = self:GetActorByTag("unwrapped")

  if actor then
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
