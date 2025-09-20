local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.frames = JetBattlePets.frames or {}

-- TODO: check if non-virtual frames in XML are messing up WarbandWorldQuests

function InitJetBattlePetsFrames()
  if not JetBattlePets.settings.ENABLE_QUEST_LOG_TAB then
    return
  end

  AddQuestLogTab("BattlePets")

  --re-initialize QuestMapFrame with added tabs and panels
  QuestMapFrame.displayMode = nil
  QuestMapFrame_OnLoad(QuestMapFrame)
end
