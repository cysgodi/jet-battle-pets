local _, JetBattlePets = ...

JetBattlePets.frames.BattlePetsTab = JetBattlePets.frames.BattlePetsTab or CreateFrame(
  "Frame",
  "BattlePetsTab",
  QuestMapFrame,
  "BattlePetsTabTemplate"
)

JetBattlePets.frames.BattlePetsMapFrame = JetBattlePets.frames.BattlePetsMapFrame or CreateFrame(
  "Frame",
  "BattlePetsFrame",
  QuestMapFrame,
  "BattlePetsFrameTemplate"
)

table.insert(QuestMapFrame.ContentFrames, JetBattlePets.frames.BattlePetsMapFrame)
