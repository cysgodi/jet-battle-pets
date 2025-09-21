local _, _JetBattlePets = ...

---@class JetBattlePets
local JetBattlePets = _JetBattlePets

---@class QuestLogTabButtonFrame : Frame

---Add a page to the quest log
---@param name string
---@param pageMixin table Mixin for the page frame
---@param scrollFrameMixin table Mixin for the event scroll frame
local function AddQuestLogPage(name, pageMixin, scrollFrameMixin)
  local panelName = string.format("%sFrame", name)

  if QuestMapFrame[panelName] or not QuestLogDisplayMode[name] then
    return
  end

  local basePageFrame = CreateFrame(
    "Frame",
    panelName,
    QuestMapFrame,
    "QuestLogPanelTemplate"
  )
  ---@class QuestLogTabButtonFrame
  local pageFrame = Mixin(basePageFrame, pageMixin or {})
  pageFrame.displayMode = QuestLogDisplayMode[name]
  pageFrame:SetParentKey(panelName)
  pageFrame:Hide()
  pageFrame:SetScript("OnShow", pageFrame.OnShow)

  table.insert(QuestMapFrame.ContentFrames, pageFrame)

  local baseScrollFrame = CreateFrame(
    "EventScrollFrame",
    string.format("%sScrollFrame", name),
    pageFrame,
    "QuestLogPanelScrollFrameTemplate"
  )

  ---@class EventScrollFrame
  local scrollFrame = Mixin(baseScrollFrame, scrollFrameMixin or {})
  scrollFrame:SetParentKey("ScrollFrame")
  scrollFrame:Init()

  QuestMapFrame[panelName] = pageFrame

  return pageFrame
end

--Add a tab to the built-in Quest Log.
---@param name string
---@param tooltipText string The text to display in the tooltip
---@param tabMixin table A mixin for the tab frame
---@param pageMixin table A mixin for the page frame
---@param scrollFrameMixin table A mixin for the scroll frame
---@return Frame TabFrame The frame created for the new tab
function AddQuestLogTab(
    name,
    tooltipText,
    tabMixin,
    pageMixin,
    scrollFrameMixin
)
  local tabName = string.format("%sTab", name)
  if QuestMapFrame[tabName] then
    return QuestMapFrame[tabName]
  end

  local displayModeArray = tInvert(QuestLogDisplayMode)
  local tabIndex = #displayModeArray + 1

  QuestLogDisplayMode[name] = tabIndex


  local baseFrame = CreateFrame(
    "Frame",
    tabName,
    QuestMapFrame,
    "QuestLogTabButtonTemplate"
  )

  ---@class QuestLogTabButtonFrame
  local frame = Mixin(baseFrame, BattlePetsTabMixin, tabMixin or {})
  frame.displayMode = QuestLogDisplayMode[name]
  frame.tooltipText = tooltipText

  table.insert(QuestMapFrame.TabButtons, frame)
  frame:SetPoint(
    "TOP",
    QuestMapFrame.TabButtons[tabIndex - 1],
    "BOTTOM",
    0,
    -3
  )
  frame:SetParentKey(tabName)
  frame:Show()

  QuestMapFrame[tabName] = frame

  ReloadQuestLogTabs()
  ReloadQuestMapFrame()

  AddQuestLogPage(name, pageMixin, scrollFrameMixin)

  return frame
end

---Remove a tab with a given name from the built-in Quest Log.
---@param name string
function RemoveQuestLogTab(name)
  local tabName = string.format("%sTab", name)

  RemoveQuestLogPage(name)

  if not QuestMapFrame[tabName] then
    return
  end

  if QuestMapFrame.displayMode == QuestLogDisplayMode[name] then
    QuestMapFrame:SetDisplayMode(1)
  end

  local tabs = {}

  for _, tab in pairs(QuestMapFrame.TabButtons) do
    if tab.displayMode and tab.displayMode ~= QuestLogDisplayMode[name] then
      table.insert(tabs, tab)
    else
      tab:ClearAllPoints()
      tab:SetParent(nil)
      tab = nil
    end
  end

  QuestMapFrame.TabButtons = tabs
  QuestLogDisplayMode[name] = nil
  QuestMapFrame[tabName] = nil

  ReloadQuestLogTabs()
  ReloadQuestMapFrame()
end

---Remove a page with a given name from the build-in Quest Log.
---@param name string
function RemoveQuestLogPage(name)
  local pageName = string.format("%sFrame", name)

  if not QuestMapFrame[pageName] then
    return
  end

  local pages = {}

  for _, page in pairs(QuestMapFrame.ContentFrames) do
    if page.displayMode and page.displayMode ~= QuestLogDisplayMode[name] then
      table.insert(pages, page)
    else
      page:ClearAllPoints()
      page:SetParent(nil)
      page = nil
    end
  end

  QuestMapFrame.ContentFrames = pages
  QuestMapFrame[pageName] = nil
end

---Execute the OnLoad method for all items in the quest map frame's
---tab buttons list.
function ReloadQuestLogTabs()
  for _, tab in pairs(QuestMapFrame.TabButtons) do
    if tab["OnLoad"] then
      tab:OnLoad()
    end
  end
end

---Re-initialize the quest map frame.
function ReloadQuestMapFrame()
  QuestMapFrame.displayMode = nil
  QuestMapFrame_OnLoad(QuestMapFrame)
end

---Get the name of a source from provided source text.
---@param sourceText string
---@return string sourceName
local function GetSourceNameFromSourceText(sourceText)
  local lines = JetBattlePets.text:Split(sourceText, "\n")
  local sourceParts = JetBattlePets.text:Split(lines[1], ":")
  -- assign to local variable since gsub has multiple returns
  local source = string.gsub(sourceParts[1], "|", "@")

  return source
end

---Get the icon for a battle pet source from a pet's source text
---@param sourceName string
---@return string
local function GetSourceIconFromSourceName(sourceName)
  local atlasNames = JetBattlePets.constants.ATLAS_NAMES
  local atlas = atlasNames.SOURCE_PET_BATTLE

  if sourceName == "Drop" then
    atlas = atlasNames.SOURCE_DROP
  elseif sourceName == "Quest" then
    atlas = atlasNames.SOURCE_QUEST
  elseif sourceName == "Treasure" then
    atlas = atlasNames.SOURCE_TREASURE
  elseif sourceName == "Vendor" then
    atlas = atlasNames.SOURCE_VENDOR
  end

  return atlas
end

BattlePetsTabMixin = {}

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
  local mapID = self:GetParent():GetCurrentMapID()

  if self.mapID == mapID then return end

  local map = JetBattlePets.cache.maps[mapID]
  local pets = JetBattlePets.pets.GetPets(map.petIDs)

  local PetsBySource = {}

  JetBattlePets.array:Each(pets, function(pet)
    local source = GetSourceNameFromSourceText(pet.sourceText)
    PetsBySource[source] = PetsBySource[source] or {}
    table.insert(PetsBySource[source], pet)
  end)

  local logRows = {}

  for source, sourcePets in pairs(PetsBySource) do
    table.insert(logRows,
      {
        isCollapsed = false,
        isHeader = true,
        text = string.format("%s (%d)", source, #sourcePets)
      }
    )

    JetBattlePets.array:Each(sourcePets, function(pet)
      table.insert(logRows, pet)
    end)
  end

  self.ScrollFrame:Update(logRows)
end

---Create a pool of quest log entry template frames given a frame to
---use as the parent.
---@param parent Frame
---@return FramePool
local function InitQuestLogEntryFramePool(parent)
  return CreateFramePool(
    "Button",
    parent,
    "QuestLogEntryTemplate",
    function(framePool, frame)
      Pool_HideAndClearAnchors(framePool, frame)
      frame.info = nil
    end
  )
end

---@class BattlePetScrollFrameMixin : EventScrollFrame
---@field TitleText FontString
---@field EmptyText FontString
---@field HeaderPool FramePool
---@field PetPool FramePool
BattlePetScrollFrameMixin = {}

function BattlePetScrollFrameMixin:Init()
  ScrollFrame_OnLoad(self)

  local onCreateFn = nil
  local useHighlightManager = true
  self.Contents:Init(onCreateFn, useHighlightManager)

  self.HeaderPool = CreateFramePool(
    "Button",
    self.Contents,
    "QuestLogHeaderTemplate"
  )

  self.PetPool = InitQuestLogEntryFramePool(self.Contents)

  self.Contents.topPadding = 16
  self.TitleText:SetText("Battle Pets")
  self.EmptyText:SetText("No Battle Pets")
end

function BattlePetScrollFrameMixin:AddHeaderButton(header, frameIndex)
  local button = self.HeaderPool:Acquire()
  button:UpdateCollapsedState(nil, header)
  button.questLogIndex = frameIndex
  QuestMapFrame:SetFrameLayoutIndex(button)
  button:SetText(header.text)

  return button
end

function BattlePetScrollFrameMixin:AddPetButton(pet, frameIndex)
  local source = GetSourceNameFromSourceText(pet.sourceText)
  local button = self.PetPool:Acquire();

  button.info = pet
  button.speciesID = pet.speciesID
  button.source = source
  button.frameIndex = frameIndex

  QuestMapFrame:SetFrameLayoutIndex(button)

  local atlas = GetSourceIconFromSourceName(button.source)

  if atlas == JetBattlePets.constants.ATLAS_NAMES.SOURCE_VENDOR then
    button.TaskIcon:SetPoint("CENTER", button.TaskIconBackground, "CENTER", -1, 0)
    button.TaskIcon:SetSize(14, 14)
  end

  button.TaskIconBackground:Hide()
  button.TaskIcon:SetAtlas(atlas)
  button.TaskIconBackground:Show()
  button.TaskIcon:Show()
  button.Text:SetText(pet.name)
  button:SetPoint("LEFT", 20, 0)
  button:Show()
end

function BattlePetScrollFrameMixin:Update(rows)
  self.HeaderPool:ReleaseAll()
  self.PetPool:ReleaseAll()

  JetBattlePets.array:Each(rows, function(row, index)
    local button

    if row.isHeader then
      button = self:AddHeaderButton(row, index)
    else
      button = self:AddPetButton(row, index)
    end

    if button then
      button:Show()
    end
  end)

  self.Contents:Layout()
end

QuestLogEntryMixin = {}

function QuestLogEntryMixin:OnClick()
  if C_AddOns.IsAddOnLoaded("Rematch") then
    Rematch.cardManager:OnClick(
      Rematch.petCard,
      self,
      self.speciesID
    )
  end
end

function QuestLogEntryMixin:OnEnter()
  self.HighlightTexture:Show()
  self.TaskIconBackground:SetAtlas(JetBattlePets.constants.ATLAS_NAMES.QUEST_LOG_TASK_ICON_HIGHLIGHT)

  if C_AddOns.IsAddOnLoaded("Rematch") then
    self.RematchAnchor = self.RematchAnchor or CreateFrame(
      "Frame",
      "RematchAnchor",
      self
    )

    self.RematchAnchor:SetPoint(
      "TOPLEFT",
      self,
      "TOPRIGHT",
      -24,
      36
    )
    self.RematchAnchor:SetSize(1, 1)

    Rematch.cardManager:OnEnter(
      Rematch.petCard,
      self.RematchAnchor,
      self.speciesID
    )
  else
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -162, 0)
    GameTooltip:SetText(self.info.name)
  end
end

function QuestLogEntryMixin:OnLeave()
  self.HighlightTexture:Hide()
  self.TaskIconBackground:SetAtlas(JetBattlePets.constants.ATLAS_NAMES.QUEST_LOG_TASK_ICON)

  if C_AddOns.IsAddOnLoaded("Rematch") then
    Rematch.cardManager:OnLeave(Rematch.petCard)
  end
end

function QuestLogEntryMixin:OnLoad()
  self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  self.HighlightTexture:Hide()
end
