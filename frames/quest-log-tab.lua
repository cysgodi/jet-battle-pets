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
  <Frame inherits="<your-optional-template"
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

function BattlePetsMixin:OnLoad()
  self.TitleText:SetText("Battle Pets")
end

---Initialize pets list when tab is shown
function BattlePetsMixin:OnShow()
  local mapId = self:GetParent():GetParent():GetMapID();
  local map = JetBattlePets.cache.maps[mapId]

  local pets = JetBattlePets.pets.GetPets(map.petIDs)
  JetBattlePets.array:Each(pets, function(pet)
    local sourceLines = JetBattlePets.text:Split(pet.sourceText, "\n")

    self.Pets[pet.speciesID] = self.Pet[pet.speciesID] or
        JetBattlePets.text:Print(sourceLines)
  end)
end
