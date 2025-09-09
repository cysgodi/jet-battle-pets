local _, JetBattlePets = ...

JetBattlePets.questLogTab = JetBattlePets.questLogTab or {}

function JetBattlePets.questLogTab:Init()
  JetBattlePets.frames.QuestLogTab = JetBattlePets.frames.QuestLogTab or CreateFrame(
    "Frame",
    "JetBattlePetsQuestLogTab",
    QuestMapFrame,
    "JetBattlePetsQuestTabButtonTemplate"
  )

  JetBattlePets.frames.QuestLogPage = JetBattlePets.frames.QuestLogPage or CreateFrame(
    "Frame",
    "JetBattlePetsQuestLogPage",
    QuestMapFrame,
    "JetBattlePetsQuestLogPageTemplate"
  )

  table.insert(QuestMapFrame.ContentFrames, JetBattlePets.frames.QuestLogPage)
end

JetBattlePetsQuestTabButtonMixin = CreateFromMixins(QuestLogTabButtonMixin)

function JetBattlePetsQuestTabButtonMixin:OnLoad()
  local IconTexture = self:CreateTexture()
  IconTexture:SetAtlas(JetBattlePets.constants.ATLAS_NAMES.QUEST_LOG_TAB_ICON)
  IconTexture:SetPoint("CENTER", self.Icon, 0, 0)
  IconTexture:SetSize(24, 24)

  self.Icon:SetTexture(IconTexture)
  self.Icon:SetSize(24, 24)

  self:SetPoint("TOP", QuestMapFrame.TabButtons[#QuestMapFrame.TabButtons - 1], "BOTTOM", 0, -3)
  self:SetChecked(false)
end

function JetBattlePetsQuestTabButtonMixin:SetChecked(checked)
  self.SelectedTexture:SetShown(checked)
end

function JetBattlePetsQuestTabButtonMixin:OnMouseUp(button, upInside)
  QuestLogTabButtonMixin.OnMouseUp(self, button, upInside)

  if (button == "LeftButton" and upInside) then
    QuestMapFrame:SetDisplayMode(self.displayMode)
  end
end

JetBattlePetsQuestLogPageMixin = {}

function JetBattlePetsQuestLogPageMixin:OnShow()
  local mapId = self:GetParent():GetParent():GetMapID();
  print(mapId)
end
