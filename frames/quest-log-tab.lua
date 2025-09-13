local _, JetBattlePets = ...

BattlePetsTabMixin = CreateFromMixins(QuestLogTabButtonMixin)

function BattlePetsTabMixin:OnLoad()
  -- add the tab button to the Quest Map frame
  self:SetPoint("TOP", QuestMapFrame.TabButtons[#QuestMapFrame.TabButtons - 1], "BOTTOM", 0, -3)
  self:SetChecked(false)
end

---Show/hide "selected" texture based on whether tab is active
function BattlePetsTabMixin:SetChecked(checked)
  self.Icon:SetAtlas(JetBattlePets.constants.ATLAS_NAMES.QUEST_LOG_TAB_ICON)
  self.Icon:SetSize(29, 29)

  if checked then
    self.Icon:SetAlpha(1)
  else
    self.Icon:SetAlpha(0.4)
  end

  self.SelectedTexture:SetShown(checked)
end

---Select tab on mouse up after click
function BattlePetsTabMixin:OnMouseUp(button, cursorInsideFrame)
  QuestLogTabButtonMixin.OnMouseUp(self, button, cursorInsideFrame)

  if (button == "LeftButton" and cursorInsideFrame) then
    QuestMapFrame:SetDisplayMode(self.displayMode)
  end
end

BattlePetsMixin = {}

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

JetBattlePetsQuestLogEntryMixin = {}

function JetBattlePetsQuestLogEntryMixin:OnShow()
end
