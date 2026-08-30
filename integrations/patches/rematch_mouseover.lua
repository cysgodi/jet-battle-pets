--[[
  Patches rematch to use renamed mouseover functions in the 12.1 API.
]]

local rematch = Rematch
local C = rematch.constants

-- panels/loadoutPanel.lua
function rematch.loadoutPanel:Update()
  for i = 1, 3 do
    local petID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(i)

    self.Loadouts[i].petID =
        petID -- before possibly changing petID to a battle:1:x, save petIDs to loadout/pet button
    self.Loadouts[i].Pet.petID = petID
    if C_PetBattles.IsInBattle() then
      petID = "battle:1:" .. i -- if in a pet battle, use the battle petID to get health updates during battle
    end

    self:FillSpecial(self.Loadouts[i], self.Loadouts[i]:GetID())                    -- fills back and special badge/button at top of loadout
    self:FillLoadout(self.Loadouts[i], petID)                                       -- fills pet, including name and pet badges
    self.Loadouts[i].AbilityBar:FillAbilityBar(petID, ability1, ability2, ability3) -- fills abilities
    self:FillStatusBars(self.Loadouts[i], petID)                                    -- fills status bars
    self:FillModelScene(self.Loadouts[i], petID)                                    -- fills pet model

    -- hiding ability bar and showing requirements if slot is locked
    self.Loadouts[i].AbilityBar:SetShown(not locked)
    self.Loadouts[i].LockOverlay.RequirementsText:SetShown(locked)
    self.Loadouts[i].LockOverlay.RequirementsLink:SetShown(locked)

    -- showing overlay if either journal or just this slot is locked
    local isJournalLocked = rematch.utils:IsJournalLocked()
    self.Loadouts[i].LockOverlay:SetShown(isJournalLocked or locked)

    -- when slotting a pet, the loadouts are updated; if the mouse is over a loadout when that happens and the pet card
    -- is unlocked and visible, then we need to change pets the card is showing (using the OnEnter to let focus handle it)
    if self.Loadouts[i]:IsMouseOver() and rematch.petCard.petID ~= petID and not rematch.cardManager:IsCardLocked(rematch.petCard) then
      local focus = GetMouseFoci()[1]
      if focus and focus.petID then
        focus:GetScript("OnEnter")(focus)
      end
    end
  end
  self.AbilityFlyout:Hide()
  self:UpdateGlow()
end

-- panels/miniLoadoutPanel.lua
function rematch.miniLoadoutPanel:Update()
  for i = 1, 3 do
    local petID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(i)
    self.Loadouts[i].petID = petID
    if C_PetBattles.IsInBattle() then
      petID = "battle:1:" .. i -- if in a pet battle, use the battle petID to get health updates during battle
    end
    self.Loadouts[i]:FillPet(petID)
    self.Loadouts[i].AbilityBar:FillAbilityBar(petID, ability1, ability2, ability3)
    self:FillStatusBars(self.Loadouts[i], petID)

    rematch.loadoutPanel:FillSpecial(self.Loadouts[i], i)

    local showGlow = rematch.utils:IsPetOnCursor()
    if showGlow then
      self.Loadouts[i].Animation:Play()
    else
      self.Loadouts[i].Animation:Stop()
    end
    self.Loadouts[i].Glow:SetShown(showGlow)
    self.Loadouts[i].LockOverlay:SetShown(rematch.utils:IsJournalLocked() or rematch.loadouts:IsSlotLocked(i))

    -- when slotting a pet, the loadouts are updated; if the mouse is over a loadout when that happens and the pet card
    -- is unlocked and visible, then we need to change pets the card is showing (using the OnEnter to let focus handle it)
    if self.Loadouts[i]:IsMouseOver() and rematch.petCard.petID ~= petID and not rematch.cardManager:IsCardLocked(rematch.petCard) then
      local focus = GetMouseFoci()[1]
      if focus and focus.petID then
        focus:GetScript("OnEnter")(focus)
      end
    end
  end
  self.AbilityFlyout:Hide()
  self:UpdateGlow()
end

-- panels/queuePanel.lua
function rematch.queuePanel.List.GlowFrame:OnUpdate(elapsed)
  local focus = GetMouseFoci()[1]
  if not focus then
    return -- while scrolling, focus becomes nil at times
  end
  if focus:GetObjectType() == "Texture" then
    focus = focus:GetParent() -- for script-enabled textures, get the parent listbutton
  end

  local cursorX, cursorY = GetCursorPosition()
  local scale = focus:GetEffectiveScale()
  local centerX, centerY = focus:GetCenter()

  local isMouseOver = InputUtil.IsMouseOver(self) -- is mouse over GlowFrame

  self.GlowLine.direction = nil                   -- potentially one of C.DRAG_DIRECTION_PREV/NEXT/END

  if InputUtil.IsMouseOver(self) then
    if focus and focus.petID then
      if (cursorY / scale) > centerY then -- if cursor is in top half of button, anchor to top
        self.GlowLine:SetPoint("CENTER", focus, "TOP")
        self.GlowLine.direction = C.DRAG_DIRECTION_PREV
      else -- otherwise anchor to bottom of button
        self.GlowLine:SetPoint("CENTER", focus, "BOTTOM")
        self.GlowLine.direction = C.DRAG_DIRECTION_NEXT
      end
      self.GlowLine:Show()
    elseif focus == rematch.queuePanel.List.CaptureButton then -- cursor is over capture area, anchor to top
      self.GlowLine:SetPoint("CENTER", focus, "TOP")
      self.GlowLine:Show()
    end
  else
    self.GlowLine:Hide()
  end
end

-- cards/notes.lua
function rematch.notes.Content.ScrollFrame.EditBox:OnEditFocusLost()
  if (InputUtil.IsMouseOver(rematch.notes.Content.Bottom) or InputUtil.IsMouseOver(rematch.notes.Content.ScrollFrame.ResizeGrip)) and not self.loseFocus then
    self:SetFocus(true)
  else
    self.loseFocus = nil
    rematch.notes.Content.ScrollFrame:SetPoint("BOTTOMRIGHT", -26, 8)
    rematch.notes.Content.Bottom:Hide()
  end
end

-- menus/menus.lua

-- registered menu tables indexed by menuNames
local allMenus = {}
-- ordered list of parent menu frames, where index is the menuLevel
local menuFrames = {}
-- pool of menu buttons to reuse; ordered list
local buttonPool = {}
-- indexed by menuName, functions to run when menu is opened or closed (passed self--the menu frame, and subject)
local menuFuncs = {}

-- returns a menuFrame for the given level, creating one if necessary
local function getMenuFrame(level)
  if not menuFrames[level] then
    menuFrames[level] = CreateFrame("Frame", nil, UIParent, "RematchMenuFrameTemplate")
    menuFrames[level].menuLevel = level
    menuFrames[level].buttons = {} -- ordered list of buttons being used in the menu
    if level == 1 then
      local closeButton = CreateFrame("Button", nil, menuFrames[level])
      closeButton:SetScript("OnKeyDown", rematch.menus.CloseButtonOnKeyDown)
    end
  end
  menuFrames[level]:Hide() -- in case any submenus open for this menu, close them
  return menuFrames[level]
end

local function getMenuButton(parent)
  -- find an available button that was already made in the pool
  for _, button in ipairs(buttonPool) do
    if not button.isUsed then
      button.isUsed = true
      button:SetParent(parent)
      button:Show()
      return button
    end
  end
  -- no existing buttons free, create a new one
  local button = CreateFrame("Button", nil, parent, "RematchMenuButtonTemplate")
  button.isUsed = true
  button.Arrow:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0) -- rotate the subMenu arrow
  tinsert(buttonPool, button)
  return button
end

-- any attribute can be a literal or a function--using expression here to mean either--and if it's a
-- function then it should run the function and return the results. info and subject are only
-- used for function evaluates; for literals this function just returns the first parameter back
-- (there's a rematch.utils:Evaluate() also--but this menu one can remain since it's so common)
local function evaluate(expression, info, subject)
  if type(expression) == "function" then
    return expression(info, subject)
  else
    return expression
  end
end

--[[ public functions ]]

-- adds the given menu to the menus table; openFunc and closeFunc are functions to run when the menu opens and closes
function rematch.menus:Register(menuName, menuTable, openFunc, closeFunc)
  assert(menuName, "menuName is nil")
  assert(type(menuTable) == "table", "menuTable for " .. menuName .. " is not an ordered table.")
  allMenus[menuName] = CopyTable(menuTable) -- make a copy instead of referencing original
  if openFunc or closeFunc then
    menuFuncs[menuName] = { openFunc, closeFunc }
  end
end

-- for use by outside addons, to add menuItem to the menu named menuName, optionally after the afterText
-- if afterText is nil (or it's not found) it will be added to the top of the menu
-- example: rematch.menus:AddToMenu("TeamMenu",{text=L["Print TeamID"], function=function(self,teamID) print(teamID) end})
function rematch.menus:AddToMenu(menuName, menuItem, afterText)
  assert(menuName and allMenus[menuName], "Menu definition doesn't exist for " .. (menuName or "nil"))
  assert(type(menuItem) == "table" and menuItem.text, "Invalid menuItem in AddToMenu")
  local def = allMenus[menuName]
  local index = 1
  if def[index].title then
    index = 2
  end
  if afterText then
    for i = 1, #def do
      if def[i].text == afterText then
        index = i + 1
      end
    end
  end
  tinsert(def, index, menuItem)
end

-- returns the menuTable for the given menuName
function rematch.menus:GetDefinition(menuName)
  assert(menuName and allMenus[menuName], "Menu definition doesn't exist for " .. (menuName or "nil"))
  return allMenus[menuName]
end

-- either hides an already-opened menu of the given menuName, or opens one parented to the given parent (with optional anchors)
function rematch.menus:Toggle(menuName, parent, subject, ...)
  rematch.dragFrame:Hide()
  for _, menuFrame in pairs(menuFrames) do
    if menuFrame:IsVisible() and menuFrame.menuName == menuName then
      menuFrame:Hide()
      return
    end
  end
  rematch.menus:Show(menuName, parent, subject, ...)
end

-- returns true if a menu frame is open
function rematch.menus:IsMenuOpen(menuName)
  for _, menuFrame in pairs(menuFrames) do
    if menuFrame.menuName == menuName and menuFrame:IsVisible() then
      return true
    end
  end
  return false
end

-- shows the menu for menuName anchored to the given parent (if ... is defined, it's anchorPoint,relativeTo,relativePoint,xoff,yoff)
-- but can be null to allow rematch to position it). subject is an optional parameter to give the menu some context (petID, etc)
function rematch.menus:Show(menuName, parent, subject, ...)
  assert(menuName, "menuName is 'nil'")
  assert(allMenus[menuName], "menu '" .. menuName .. "' is undefined")
  assert(type(parent) == "table" and parent.GetObjectType, "parent for menu " .. menuName ..
    " is not a frame or button")
  rematch.dragFrame:Hide()
  rematch.cardManager:HideCard(rematch.notes)

  -- get the menuFrame, grabbing a deeper level if parent's parent is already a menuFrame
  local parentFrame = parent:GetParent()
  local level = (parentFrame and parentFrame.isRematchMenu) and parentFrame.menuLevel + 1 or 1
  local menuFrame = getMenuFrame(level)
  menuFrame.relativeTo = parent                          -- use this to reference what the topmost menu is attached to
  menuFrame:SetParent(level == 1 and UIParent or parent) -- level 1 frame needs UIParent (otherwise menus parented to scrollframes get clipped)
  menuFrame:SetFrameStrata("FULLSCREEN_DIALOG")
  menuFrame.menuName = menuName
  menuFrame.subject = subject
  menuFrame.reverseMenuAnchor = false

  -- fill menu's content
  local frameWidth = rematch.menus:Fill(menuFrame, subject)

  -- position and show the frame
  local uiScale = UIParent:GetEffectiveScale()
  menuFrame:ClearAllPoints()
  if select(1, ...) == "cursor" then -- if choosing to anchor it to cursor
    local x, y = GetCursorPosition()
    local uiScale = menuFrame:GetEffectiveScale()
    menuFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / uiScale - 4, y / uiScale + 4)
  elseif select(1, ...) then -- otherwise if anchor defined, use it
    menuFrame:SetPoint(...)
  else                       -- if anchor not defined, anchor to right of parent if room permits
    local yoff = (allMenus[menuName][1] and allMenus[menuName][1].title) and 30 or 0
    -- if we already reversed direction (going left) or new menu will exceed right edge of screen
    if (parent.reverseMenuAnchor or (parent:GetParent() and parent:GetParent().reverseMenuAnchor)) or (parent:GetRight() + frameWidth) * parent:GetEffectiveScale() > UIParent:GetRight() * UIParent:GetEffectiveScale() then
      -- then open to the left
      menuFrame:SetPoint("TOPRIGHT", parent, "TOPLEFT", 1, yoff)
      menuFrame.reverseMenuAnchor = true
    else -- normal anchor will open menu/submenu to the right
      menuFrame:SetPoint("TOPLEFT", parent, "TOPRIGHT", -1, yoff)
      menuFrame.reverseMenuAnchor = false
    end
  end
  menuFrame:Show()

  if menuFuncs[menuName] and menuFuncs[menuName][1] then
    menuFuncs[menuName][1](parent, subject)
  end
end

function rematch.menus:Fill(menuFrame, subject)
  local menu = allMenus[menuFrame.menuName]
  local maxWidth, height = 0, C.MENU_FRAME_PADDING
  menuFrame.Title:Hide()
  wipe(menuFrame.buttons)
  for index, info in ipairs(menu) do
    local width = 0
    -- if any item has a minWidth, then the menu buttons will use this width at least
    if type(info.minWidth) == "number" then
      maxWidth = max(maxWidth, info.minWidth)
    end
    if evaluate(info.hidden, info, subject) then
      -- hidden (do nothing)
    elseif info.title then
      -- title
      assert(index == 1, "Menu title must be first menu entry in " .. menuFrame.menuName)
      menuFrame.Title:Show()
      menuFrame.Title.Text:SetText(evaluate(info.title, info, subject))
      height = height + C.MENU_TITLE_HEIGHT
      maxWidth = max(maxWidth, menuFrame.Title.Text:GetStringWidth())
    elseif info.spacer then
      -- spacer
      height = height + (evaluate(info.height, info, subject) or C.MENU_SPACER_HEIGHT)
    else -- all other options involve a button
      local button = getMenuButton(menuFrame)
      button.info = info
      tinsert(menuFrame.buttons, button)
      button:SetPoint("TOPLEFT", C.MENU_FRAME_PADDING, -height)
      local leftOff, rightOff = 0, 0
      -- indent
      if evaluate(info.indent, info, subject) then
        leftOff = C.MENU_INDENT_SIZE
        width = C.MENU_INDENT_SIZE
      end
      -- check/radio
      local isRadio = evaluate(info.radio, info, subject)
      if evaluate(info.check, info, subject) or isRadio then
        button.Check:SetPoint("LEFT", leftOff - 2, isRadio and -1 or 0)
        button.Check:Show()
        button.isChecked = evaluate(info.isChecked, info, subject)
        rematch.menus:ButtonSetChecked(button, button.isChecked, isRadio)
        leftOff = leftOff + 20
        width = width + 20
      else
        button.Check:Hide()
      end
      -- icon
      local icon = evaluate(info.icon, info, subject)
      if icon then
        button.Icon:SetPoint("LEFT", leftOff, 0)
        button.Icon.leftOff = leftOff
        button.Icon:SetTexture(icon)
        local texCoords = evaluate(info.iconCoords, info, subject)
        if texCoords then
          button.Icon:SetTexCoord(unpack(texCoords))
        else
          button.Icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
        end
        button.Icon:Show()
        leftOff = leftOff + 20
        width = width + 20
      else
        button.Icon:Hide()
      end
      -- submenu
      local subMenu = evaluate(info.subMenu, info, subject)
      if subMenu then
        button.Arrow:Show()
        rightOff = rightOff + 12
        width = width + 12
      else
        button.Arrow:Hide()
      end
      -- deleteButton
      local showDeleteButton = evaluate(info.deleteButton, info, subject)
      local showEditButton = evaluate(info.editButton, info, subject)
      if showDeleteButton or showEditButton then
        width = width + 2 -- padding for either
      end
      if showDeleteButton then
        width = width + 16
      end
      if showEditButton then
        width = width + 16
      end
      -- if evaluate(info.deleteButton,info,subject) then
      --     width = width + 18
      --     -- editButton (and only if deleteButton enabled too)
      --     if evaluate(info.editButton,info,subject) then
      --         width = width + 16
      --     end
      -- end

      -- text
      button.Text:SetText(evaluate(info.text, info, subject))
      button.Text:SetPoint("LEFT", leftOff, 0)
      button.Text.leftOff = leftOff
      width = width + button.Text:GetStringWidth()
      -- highlight
      if evaluate(info.highlight, info, subject) then
        button.Text:SetTextColor(1, 0.82, 0)
      else
        button.Text:SetTextColor(1, 1, 1)
      end
      -- disabled (after text/highlight because this may change text color)
      rematch.menus:ButtonSetDisabled(button, evaluate(info.isDisabled, info, menuFrame.subject))

      height = height + C.MENU_BUTTON_HEIGHT
      maxWidth = max(maxWidth, width)
    end
  end
  for _, button in ipairs(menuFrame.buttons) do
    button:SetWidth(maxWidth)
  end
  -- size the frame based on the added content
  local frameWidth = maxWidth + C.MENU_FRAME_PADDING * 2
  menuFrame:SetSize(frameWidth, height + C.MENU_FRAME_PADDING)

  return frameWidth
end

-- hides any open menus
function rematch.menus:Hide()
  if #menuFrames > 0 then
    for _, menuFrame in pairs(menuFrames) do
      menuFrame:Hide()
    end
  end
end

-- goes through all visible menus and updates enable/disable, highlight and check states
function rematch.menus:RefreshMenus()
  for _, menuFrame in ipairs(menuFrames) do
    if menuFrame:IsVisible() then
      for _, button in ipairs(menuFrame.buttons) do
        if button:IsVisible() then
          local info = button.info
          -- update check/radio
          local isRadio = evaluate(info.radio, info, subject)
          if info.check or isRadio then
            button.isChecked = evaluate(info.isChecked, info, menuFrame.subject)
            rematch.menus:ButtonSetChecked(button, button.isChecked, isRadio)
          end
          -- update highlight
          if evaluate(info.highlight, info, menuFrame.subject) then
            button.Text:SetTextColor(1, 0.82, 0)
          else
            button.Text:SetTextColor(1, 1, 1)
          end
          -- update disabled state
          rematch.menus:ButtonSetDisabled(button, evaluate(info.isDisabled, info, menuFrame.subject))
        end
      end
    end
  end
end

function RematchMenuFrameMixin:OnHide()
  self:Hide()   -- if hiding due to parent hiding, hide this too
  self:ClearAllPoints()
  -- release all menu buttons back to the pool
  for _, button in ipairs(self.buttons) do
    button.isUsed = false
    button:ClearAllPoints()
    button:Hide()
  end
  rematch.utils:SetUIJustChanged()
  wipe(self.buttons)
  if menuFuncs[self.menuName] and menuFuncs[self.menuName][2] then
    menuFuncs[self.menuName][2](self:GetParent(), self.subject)
  end
end

function RematchMenuFrameMixin:OnUpdate(elapsed)
  local focus = GetMouseFoci()[1]
  -- testing if over a menu by getting the menuName beneath the mouse and confirming it's a registered menu
  local menuName = focus and (focus.menuName or (focus and focus:GetParent() and focus:GetParent().menuName))
  if menuName and allMenus[menuName] or ((menuFrames[1] and menuFrames[1].relativeTo and InputUtil.IsMouseOver(menuFrames[1].relativeTo)) or InputUtil.IsMouseOver(rematch.menus.sideButtons)) then
    self.timer = 0 -- reset timer if over a menu
  else             -- add to elapsed timer to hide if not over a menu
    self.timer = self.timer + elapsed
    if self.timer > C.MENU_OPEN_TIMER then
      self.timer = 0
      self:Hide()
    end
  end
end

function RematchMenuButtonMixin:OnEnter()
  self.Highlight:Show()
  local parent = self:GetParent()
  local parentLevel = parent.menuLevel
  local subMenuLevel = parentLevel and parentLevel + 1
  -- close any submenus deeper than the button being entered
  if subMenuLevel and menuFrames[subMenuLevel] and menuFrames[subMenuLevel]:IsVisible() then
    menuFrames[subMenuLevel]:Hide()
  end
  local info = self.info
  local subject = parent.subject
  if info then
    -- if this button has a submenu, open it with current button as parent
    if info.subMenu and allMenus[info.subMenu] then
      if info.subMenuFunc and type(info.subMenuFunc) == "function" then
        info.subMenuFunc(self, subject)
      end
      rematch.menus:Show(info.subMenu, self, subject)
    end
    -- if this button has a tooltip, show it
    local tooltipTitle = evaluate(info.tooltipTitle, info, subject)
    local tooltipBody = evaluate(info.tooltipBody, info, subject)
    -- if button is disabled and there's a disabledTooltip set, replace tooltipBody with disabledTooltip
    if evaluate(info.isDisabled, info, subject) then
      local disabledTooltip = evaluate(info.disabledTooltip, info, subject)
      if disabledTooltip then
        tooltipBody = C.HEX_RED .. disabledTooltip
      end
    end
    if tooltipTitle or tooltipBody then
      rematch.tooltip:ShowSimpleTooltip(self, tooltipTitle, tooltipBody, nil, nil, nil, nil, nil, info.isHelp)
    end
    -- show sidebuttons on this button if deleteButton or editButton enabled
    local showDeleteButton = evaluate(info.deleteButton, info, subject)
    local showEditButton = evaluate(info.editButton, info, subject)
    if showDeleteButton or showEditButton then
      rematch.menus.sideButtons.subject = subject
      rematch.menus.sideButtons:SetParent(self)
      rematch.menus.sideButtons:SetPoint("RIGHT")
      rematch.menus.sideButtons:SetWidth((showEditButton and 16 or 0) + (showDeleteButton and 16 or 0))
      rematch.menus.sideButtons.DeleteButton:SetShown(showDeleteButton)
      rematch.menus.sideButtons.EditButton:SetShown(showEditButton)
      rematch.menus.sideButtons:Show()
      rematch.menus.sideButtons.DeleteButton.tooltipBody = evaluate(info.deleteTooltip, info, subject)
      rematch.menus.sideButtons.EditButton.tooltipBody = evaluate(info.editTooltip, info, subject)
    end
  end
end

function RematchMenuButtonMixin:OnLeave()
  self.Highlight:Hide()
  if self.info and self.info.subMenu then
    for _, menuFrame in ipairs(menuFrames) do
      if menuFrame.menuName == self.info.subMenu and not InputUtil.IsMouseOver(menuFrame) then
        menuFrame:Hide()
      end
    end
  end
  rematch.tooltip:Hide()
  if not InputUtil.IsMouseOver(rematch.menus.sideButtons) then
    rematch.menus.sideButtons:Hide()
  end
end

function RematchMenuSideButtonMixin:OnLeave()
  local parent = self:GetParent()
  if not InputUtil.IsMouseOver(parent) or not parent:GetParent():IsVisible() then
    parent:Hide()
    parent:GetParent().Highlight:Hide()
  end
end

-- process/dragFrame.lua
function rematch.dragFrame:GLOBAL_MOUSE_UP()
  local focus = GetMouseFoci()[1]
  if focus then
    -- if mouse is over teamsPanel(GlowFrame) then any team/group combination safe to handle
    if InputUtil.IsMouseOver(self.GlowFrame) and rematch.teamsPanel:IsVisible() and (focus.groupID or focus.teamID or focus == rematch.teamsPanel.List.CaptureButton) then
      self:HandleReceiveDrag(focus)
    end
    -- but if mouse is over teamTabs it can only be a team on the cursor
    if InputUtil.IsMouseOver(rematch.teamTabs) and rematch.teamTabs:IsVisible() and focus.groupID and self:GetCursorInfo() == C.CURSOR_TYPE_TEAM then
      self:HandleReceiveDrag(focus)
    end
  end
  rematch.events:Unregister(self, "GLOBAL_MOUSE_UP")
end

function rematch.dragFrame.GlowFrame:OnUpdate(elapsed)
  local cursorType, cursorID = rematch.dragFrame:GetCursorInfo()
  local focus = GetMouseFoci()[1]

  if not focus then
    return -- while scrolling, focus becomes nil at times
  end

  local cursorX, cursorY = GetCursorPosition()
  local scale = focus:GetEffectiveScale()
  local centerX, centerY = focus:GetCenter()

  local showGlowLine = false
  local showGlowArea = false
  local isMouseOver = InputUtil.IsMouseOver(self) -- is mouse over GlowFrame

  self.GlowLine.direction = nil                   -- potentially one of C.DRAG_DIRECTION_PREV/NEXT/END

  -- if group on cursor, and mouse is over a group, put GlowLine above/below group
  if cursorType == C.CURSOR_TYPE_GROUP and isMouseOver then
    if focus and focus.groupID then
      -- if group combine key modifier is down, then showGlowArea and not line
      if rematch.dragFrame:IsCombineGroupKeyUsed() then
        self.GlowArea:SetPoint("TOPLEFT", focus, "TOPLEFT")
        self.GlowArea:SetPoint("BOTTOMRIGHT", focus, "BOTTOMRIGHT")
        showGlowArea = true
      else -- combine key is not down, so we're reording groups
        -- if cursor is in top half of button, anchor to top
        if (cursorY / scale) > centerY then
          self.GlowLine:SetPoint("CENTER", focus, "TOP")
          self.GlowLine.direction = C.DRAG_DIRECTION_PREV
        else
          self.GlowLine:SetPoint("CENTER", focus, "BOTTOM")
          self.GlowLine.direction = C.DRAG_DIRECTION_NEXT
        end
        showGlowLine = true
      end
    elseif focus == rematch.teamsPanel.List.CaptureButton then -- if over capturebutton, then move glow to last button
      if not rematch.dragFrame:IsCombineGroupKeyUsed() then    -- make sure combine key not down over capture button
        local lastListButton = rematch.teamsPanel.List:GetLastListButton()
        if lastListButton and lastListButton.groupID then
          self.GlowLine:SetPoint("CENTER", lastListButton, "BOTTOM")
        else -- no last button, put glow at top of frame
          self.GlowLine:SetPoint("CENTER", self, "TOP")
        end
        self.GlowLine.direction = C.DRAG_DIRECTION_END
        showGlowLine = true
      end
    end
  elseif cursorType == C.CURSOR_TYPE_TEAM and isMouseOver then
    if focus and focus.teamID then
      -- if cursor is in top half of button, anchor to top
      if (cursorY / scale) > centerY then
        self.GlowLine:SetPoint("CENTER", focus, "TOP")
        self.GlowLine.direction = C.DRAG_DIRECTION_PREV
      else
        self.GlowLine:SetPoint("CENTER", focus, "BOTTOM")
        self.GlowLine.direction = C.DRAG_DIRECTION_NEXT
      end
      showGlowLine = true
    elseif focus and focus.groupID then
      self.GlowArea:SetPoint("TOPLEFT", focus, "TOPLEFT")
      self.GlowArea:SetPoint("BOTTOMRIGHT", focus, "BOTTOMRIGHT")
      showGlowArea = true
    end
  end

  self.GlowLine:SetShown(showGlowLine)
  self.GlowArea:SetShown(showGlowArea)
end
