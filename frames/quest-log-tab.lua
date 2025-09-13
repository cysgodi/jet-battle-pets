local _, JetBattlePets = ...

BattlePetsTabMixin = CreateFromMixins(QuestLogTabButtonMixin)

--[[
Add a tab to the built-in Quest Log . The below XML frames need to
exist for this to work properly:

**Tab Frame**

```xml
  <Frame inherits="QuestLogTabButtonTemplate"
    parent="QuestMapFrame"
    parentKey="<name>Tab"
    mixin="<your-optional-mixin>"
  >
    <KeyValues>
      <KeyValue key="displayMode"
        value="QuestLogDisplayMode.<name>"
        type="global"
      />

      <KeyValue key="tooltipText"
        value="<your-tooltip-text>"
        type="string"
      />
    </KeyValues>
  </Frame>
```

**Tab Contents Frame**

```xml
  <Frame inherits="<your-optional-template>"
    mixin="<your-optional-mixin>"
    parent="QuestMapFrame"
    parentArray="ContentFrames"
    parentKey="<your-frame-name>"
  >
    <KeyValues>
      <KeyValue key="displayMode"
        value="QuestLogDisplayMode.<name>"
        type="global"
      />
    </KeyValues>

    <Anchors>
      <Anchor
        point="TOPLEFT"
        relativeKey="$parent.ContentsAnchor"
        y="-29"
      />

      <Anchor
        point="BOTTOMRIGHT"
        relativeKey="$parent.ContentsAnchor"
        x="-22"
      />
    </Anchors>

    <Layers>
      <Layer level="BACKGROUND">
        <Texture setAllPoints="true">
          <Color r="1" g="1" b="0" />
        </Texture>
      </Layer>
    </Layers>
  </Frame>
```
]]
---@param name string
function AddQuestLogTab(name)
  local displayModeArray = tInvert(QuestLogDisplayMode)
  local tabIndex = #displayModeArray + 1
  local tabName = string.format("%sTab", name)

  QuestLogDisplayMode[tabName] = tabIndex

  QuestMapFrame[name .. "Tab"]:SetPoint(
    "TOP",
    QuestMapFrame.TabButtons[tabIndex - 1],
    "BOTTOM",
    0,
    -3
  )
end

local function BattlePets_AddButton(pet, frameIndex)
  local button = BattlePetScrollFrame.entryFramePool:Acquire();

  button.info = pet
  button.speciesID = pet.speciesID
  button.frameIndex = frameIndex

  QuestMapFrame:SetFrameLayoutIndex(button)

  button.Text:SetText(pet.name)
  button:SetPoint("LEFT", 20, 0)
  button:Show()
end

function BattlePetEntry_OnEnter(self)
  self.HighlightTexture:Show()
end

function BattlePetEntry_OnLeave(self)
  self.HighlightTexture:Hide()
end

---Override the default `SetChecked` method because we're using a
---single atlas with different alpha levels for active vs inactive
---states.
function BattlePetsTabMixin:SetChecked(checked)
  self.Icon:SetAtlas(JetBattlePets.constants.ATLAS_NAMES.QUEST_LOG_TAB_ICON)
  self.Icon:SetSize(26, 26)

  if checked then
    self.Icon:SetAlpha(1)
  else
    self.Icon:SetAlpha(0.6)
  end

  self.SelectedTexture:SetShown(checked)
end

BattlePetsMixin = {}

---Initialize pets list when tab is shown
function BattlePetsMixin:OnShow()
  self.pets = self.pets or {}

  local mapId = self:GetParent():GetCurrentMapID()
  local map = JetBattlePets.cache.maps[mapId]

  local pets = JetBattlePets.pets.GetPets(map.petIDs)

  JetBattlePets.array:Each(pets, function(pet, index)
    BattlePets_AddButton(pet, index)
  end)

  self.ScrollFrame.Contents:Layout()
end

BattlePetScrollFrameMixin = {}

function BattlePetScrollFrameMixin:OnLoad()
  ScrollFrame_OnLoad(self)

  local onCreateFn = nil
  local useHighlightManager = true
  BattlePetScrollFrame.Contents:Init(onCreateFn, useHighlightManager)

  local contentsFrame = self.Contents

  self.entryFramePool = CreateFramePool(
    "BUTTON",
    contentsFrame,
    "QuestLogEntryTemplate",
    function(framePool, frame)
      Pool_HideAndClearAnchors(framePool, frame)
      frame.info = nil
    end
  )

  self.TitleText:SetText("Battle Pets")
  self.EmptyText:SetText("No Battle Pets")
end

QuestLogEntryMixin = {}

function QuestLogEntryMixin:OnLoad()
  self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  self.HighlightTexture:Hide()
end
