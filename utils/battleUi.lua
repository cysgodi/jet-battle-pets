local _, ketchum = ...

ketchum.battleUi = {
  alertsFired = false
}

function ketchum.battleUi:AfterBattle() 
  ketchum.battleUi.alertsFired = false
end

-- print an alert to the chat box that a shiny is in the battle
function ketchum.battleUi:PrintShinyAlert(speciesID)
  local pet = ketchum.pets.GetPet(speciesID)  
  local shinyIcon = CreateAtlasMarkup("rare-elite-star") 
      
  print('|c00ffff00'..shinyIcon..' A shiny '..pet.name..' appears! '..shinyIcon..'|r')
end

-- attach the shiny icon to appropriate battle pet UI frames
function ketchum.battleUi:UpdateShinyFrames()
  ketchum.battleUi:ResetShinyFrames()

  local numEnemies = C_PetBattles.GetNumPets(Enum.BattlePetOwner.Enemy)

  for i = 1, numEnemies do
    local speciesID = C_PetBattles.GetPetSpeciesID(Enum.BattlePetOwner.Enemy, i)

    local displayID = C_PetBattles.GetDisplayID(Enum.BattlePetOwner.Enemy, i)

    local displayIdIndex = ketchum.journal:GetDisplayIndex(speciesID, displayID)

    local probability = ketchum.journal:GetDisplayProbability(
      speciesID,
      displayID
    )

    if probability <= 10 then
      if not ketchum.battleUi.alertsFired then
        PlaySoundFile("Interface\\AddOns\\Ketchum\\assets\\pla-shiny.mp3")
        ketchum.battleUi:PrintShinyAlert(speciesID)
        ketchum.battleUi.alertsFired = true
      end

      local activePetIndex = C_PetBattles.GetActivePet(Enum.BattlePetOwner.Enemy)

      if i == activePetIndex then
        ketchum.battleUi:TagShinyActivePet()
      else
        ketchum.battleUi:TagShinyBackPet(i)
      end
    end
  end
end

-- hide any shiny frames that are currently shown
function ketchum.battleUi:ResetShinyFrames()
  if ketchum.battleUi.ActiveShinyFrame then
    ketchum.battleUi.ActiveShinyFrame:Hide()
    ketchum.battleUi.ActiveShinyFrame = nil
  end

  if ketchum.battleUi.Enemy1ShinyFrame then
    ketchum.battleUi.Enemy1ShinyFrame:Hide()
    ketchum.battleUi.Enemy1ShinyFrame = nil
  end

  if ketchum.battleUi.Enemy2ShinyFrame then
    ketchum.battleUi.Enemy2ShinyFrame:Hide()
    ketchum.battleUi.Enemy2ShinyFrame = nil
  end
end

-- add a shiny icon to the active enemy pet that's shiny
function ketchum.battleUi:TagShinyActivePet()
  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

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
  f.tex:SetTexCoord(
    atlas.leftTexCoord,
    atlas.rightTexCoord,
    atlas.topTexCoord,
    atlas.bottomTexCoord
  )

  ketchum.battleUi.ActiveShinyFrame = f
end

-- add a shiny icon to back row pets that are shiny
function ketchum.battleUi:TagShinyBackPet(slot)
  if(slot < 2 or slot > 3) then
    return
  end

  local atlas = C_Texture.GetAtlasInfo("rare-elite-star")

  local f = CreateFrame(
    "Frame",
    "Enemy"..slot.."ShinyIcon",
    PetBattleFrame.ActiveEnemy
  )

  f:SetPoint("TOPLEFT", PetBattleFrame['Enemy'..slot].Icon, -4, 4)
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

  ketchum.battleUi['Enemy'..slot..'ShinyFrame'] = f
end