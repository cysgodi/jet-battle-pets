local _, JetBattlePets = ...

--add enum value for Battle Pets quest log tab
local displayModeArray = tInvert(QuestLogDisplayMode)
local tabIndex = #displayModeArray + 1
QuestLogDisplayMode["BattlePets"] = tabIndex

JetBattlePets.frames.BattlePetsTab = JetBattlePets.frames.BattlePetsTab or CreateFrame(
  "Frame",
  "BattlePetsTab",
  QuestMapFrame,
  "BattlePetsTabTemplate"
)

--anchor the new tab to the bottom of the previous tab
JetBattlePets.frames.BattlePetsTab:SetPoint(
  "TOP",
  QuestMapFrame.TabButtons[tabIndex - 1],
  "BOTTOM",
  0,
  -3
)

JetBattlePets.frames.BattlePetsMapFrame = JetBattlePets.frames.BattlePetsMapFrame or CreateFrame(
  "Frame",
  "BattlePetsFrame",
  QuestMapFrame,
  "BattlePetsFrameTemplate"
)

table.insert(QuestMapFrame.ContentFrames, JetBattlePets.frames.BattlePetsMapFrame)

--re-initialize QuestMapFrame with added tabs and panels
QuestMapFrame.displayMode = nil
QuestMapFrame_OnLoad(QuestMapFrame)
