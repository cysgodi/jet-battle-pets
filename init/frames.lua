local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.frames = JetBattlePets.frames or {}

function InitJetBattlePetsFrames()
  AddQuestLogTab("BattlePets")

  --re-initialize QuestMapFrame with added tabs and panels
  QuestMapFrame.displayMode = nil
  QuestMapFrame_OnLoad(QuestMapFrame)
end
