local _, JetBattlePets = ...

BattlePetsTabMixin = CreateFromMixins(QuestLogTabButtonMixin)

---Override the default `SetChecked` method because we're using a
---single atlas with different alpha levels for active vs inactive
---states.
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
