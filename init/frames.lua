local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.frames = JetBattlePets.frames or {}

function InitJetBattlePetsFrames()
  if not JetBattlePets.settings.ENABLE_QUEST_LOG_TAB then
    RemoveQuestLogTab("BattlePets")
  else
    AddQuestLogTab(
      "BattlePets",
      "Battle Pets",
      BattlePetsTabMixin,
      BattlePetsMixin,
      BattlePetScrollFrameMixin
    )
  end
end
