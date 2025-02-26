local _, JetBattlePets = ...

JetBattlePets.battleUi = {
  alertsFired = false
}

---determine whether an alert should fire based on user preferences
---@param speciesID number
---@param displayID number
---@return boolean fireAlert Should an alert be fired?
---@return boolean isShiny Is the pet model actually shiny?
local function ShouldAlert(speciesID, displayID)
  local probability = JetBattlePets.journal:GetDisplayProbability(
    speciesID,
    displayID
  )

  local alertThreshold = JetBattlePets.settings.ALERT_THRESHOLD
  local rarityName = JetBattlePets.constants.RARITY_NAMES[alertThreshold]
  local isShiny = rarityName == JetBattlePets.constants.RARITY_NAMES.SHINY

  if not probability then
    return false, isShiny
  end

  local maxProbability = JetBattlePets.journal:GetMaxDisplayProbability(speciesID)

  local ratio = maxProbability / probability
  local alertRatio = JetBattlePets.constants.RARITY_RATIOS[rarityName]

  return ratio >= alertRatio, isShiny
end

-- cleanup after a pet battle is finished
function JetBattlePets.battleUi:AfterBattle()
  JetBattlePets.battleUi.alertsFired = false
end

-- save data about a specific encountered enemy pet to disk
function JetBattlePets.battleUi:RecordEncounterSlotData(slot, location)
  JetBattlePets.encounters:AddEncounter({
    speciesID = C_PetBattles.GetPetSpeciesID(
      Enum.BattlePetOwner.Enemy,
      slot
    ),
    displayID = C_PetBattles.GetDisplayID(
      Enum.BattlePetOwner.Enemy,
      slot
    ),
    position = slot,
    rarity = C_PetBattles.GetBreedQuality(
      Enum.BattlePetOwner.Enemy,
      slot
    ),
    HP = C_PetBattles.GetMaxHealth(
      Enum.BattlePetOwner.Enemy,
      slot
    ),
    power = C_PetBattles.GetPower(
      Enum.BattlePetOwner.Enemy,
      slot
    ),
    speed = C_PetBattles.GetSpeed(
      Enum.BattlePetOwner.Enemy,
      slot
    ),
    level = C_PetBattles.GetLevel(
      Enum.BattlePetOwner.Enemy,
      slot
    ),
    location = location,
  })
end

---Print an alert message that an enemy pet contains a problematic ability
---@param abilityName string
---@param petSlot SlotNumber
function JetBattlePets.battleUi:PrintThreatAlert(
    abilityName,
    petSlot
)
  local speciesID = C_PetBattles.GetPetSpeciesID(
    Enum.BattlePetOwner.Enemy,
    petSlot
  )

  local pet = JetBattlePets.pets.GetPet(speciesID)

  -- TODO: add an icon to this
  print('|cff333300WARNING: ' .. pet.name .. ' can use ' .. abilityName)
end

-- print an alert to the chat box that a shiny is in the battle
function JetBattlePets.battleUi:PrintShinyAlert(speciesID)
  local pet = JetBattlePets.pets.GetPet(speciesID)
  local shinyIcon = CreateAtlasMarkup("rare-elite-star")

  print('|c00ffff00' .. shinyIcon .. ' An unusual ' .. pet.name .. ' appears! ' .. shinyIcon .. '|r')
end

-- attach the shiny icon to appropriate battle pet UI frames
function JetBattlePets.battleUi:UpdateShinyFrames()
  JetBattlePets.battleUi:ResetShinyFrames()

  local numEnemies = C_PetBattles.GetNumPets(Enum.BattlePetOwner.Enemy)

  for i = 1, numEnemies do
    local speciesID = C_PetBattles.GetPetSpeciesID(Enum.BattlePetOwner.Enemy, i)

    local displayID = C_PetBattles.GetDisplayID(Enum.BattlePetOwner.Enemy, i)

    local shouldFireAlerts, isShiny = ShouldAlert(speciesID, displayID)

    if shouldFireAlerts then
      if not JetBattlePets.battleUi.alertsFired then
        PlaySoundFile("Interface\\AddOns\\Ketchum\\assets\\pla-shiny.mp3")
        JetBattlePets.battleUi:PrintShinyAlert(speciesID)
        JetBattlePets.battleUi.alertsFired = true
      end

      -- don't draw the shiny icon on frames unless the model is actually
      -- shiny
      if not isShiny then return end

      local activePetIndex = C_PetBattles.GetActivePet(Enum.BattlePetOwner.Enemy)

      if i == activePetIndex then
        JetBattlePets.battleUi:TagShinyActivePet()
      else
        JetBattlePets.battleUi:TagShinyBackPet(i)
      end
    end
  end
end

-- play an audio alert and display a warning message if an enemy pet
-- has an ability that could ruin the player's attempts to capture it
-- or one of its teammates
function JetBattlePets.battleUi:DisplayCaptureThreatWarnings()
  if not JetBattlePets.settings.ENABLE_CAPTURE_THREAT_WARNINGS then
    return
  end

  local numEnemies = C_PetBattles.GetNumPets(Enum.BattlePetOwner.Enemy)

  for teamSlot = 1, numEnemies do
    for abilitySlot = 1, 3 do
      local abilityID, abilityName = C_PetBattles.GetAbilityInfo(
        Enum.BattlePetOwner.Enemy,
        teamSlot,
        abilitySlot
      )

      if tContains(
            JetBattlePets.constants.ABILITIES.CAPTURE_THREATS,
            abilityID
          ) then
        JetBattlePets.battleUi:PrintThreatAlert(abilityName, teamSlot)
      end
    end
  end
end

-- save data about encountered pets to disk
function JetBattlePets.battleUi:RecordEncounterData()
  if
      not JetBattlePets.settings.ENABLE_DATA_COLLECTION
      or not C_PetBattles.IsWildBattle()
  then
    return
  end

  local enemyCount = C_PetBattles.GetNumPets(
    Enum.BattlePetOwner.Enemy
  )

  local mapID = C_Map.GetBestMapForUnit("player")
  local playerPosition = C_Map.GetPlayerMapPosition(mapID, "player")
  local areaIDs = nil

  if (playerPosition) then
    areaIDs = C_MapExplorationInfo.GetExploredAreaIDsAtPosition(
      mapID,
      playerPosition
    )
  end

  for i = 1, enemyCount do
    JetBattlePets.battleUi:RecordEncounterSlotData(i, {
      areaIDs = areaIDs,
      mapID = mapID,
      playerPosition = playerPosition and {
        x = playerPosition.x,
        y = playerPosition.y
      },
    })
  end
end

-- hide any shiny frames that are currently shown
function JetBattlePets.battleUi:ResetShinyFrames()
  if JetBattlePets.battleUi.ActiveShinyFrame then
    JetBattlePets.battleUi.ActiveShinyFrame:Hide()
    JetBattlePets.battleUi.ActiveShinyFrame = nil
  end

  if JetBattlePets.battleUi.Enemy1ShinyFrame then
    JetBattlePets.battleUi.Enemy1ShinyFrame:Hide()
    JetBattlePets.battleUi.Enemy1ShinyFrame = nil
  end

  if JetBattlePets.battleUi.Enemy2ShinyFrame then
    JetBattlePets.battleUi.Enemy2ShinyFrame:Hide()
    JetBattlePets.battleUi.Enemy2ShinyFrame = nil
  end
end

-- add a shiny icon to the active enemy pet that's shiny
function JetBattlePets.battleUi:TagShinyActivePet()
  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

  ---@class LocalFrame : Frame
  ---@field tex Texture
  local f = CreateFrame(
    "Frame",
    "ActiveEnemyShinyIcon",
    PetBattleFrame.ActiveEnemy
  )

  f:SetPoint("TOPLEFT", PetBattleFrame.ActiveEnemy.Icon, -8, 8)
  f:SetSize(24, 24)
  f.tex = f:CreateTexture()
  f.tex:SetAllPoints()
  f.tex:SetTexture(atlas.file)
  f.tex:SetTexCoord(JetBattlePets.atlas:GetTexCoords(atlas))

  JetBattlePets.battleUi.ActiveShinyFrame = f
end

-- add a shiny icon to back row pets that are shiny
function JetBattlePets.battleUi:TagShinyBackPet(slot)
  if (slot < 2 or slot > 3) then
    return
  end

  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

  ---@class LocalFrame : Frame
  local f = CreateFrame(
    "Frame",
    "Enemy" .. slot .. "ShinyIcon",
    PetBattleFrame.ActiveEnemy
  )

  f:SetPoint("TOPLEFT", PetBattleFrame['Enemy' .. slot].Icon, -4, 4)
  f:SetSize(14, 14)
  f.tex = f:CreateTexture()
  f.tex:SetAllPoints()
  f.tex:SetTexture(atlas.file)
  f.tex:SetTexCoord(
    atlas.leftTexCoord,
    atlas.rightTexCoord,
    atlas.topTexCoord,
    atlas.bottomTexCoord
  )

  JetBattlePets.battleUi['Enemy' .. slot .. 'ShinyFrame'] = f
end
