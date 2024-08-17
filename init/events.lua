local _, ketchum = ...

local events = CreateFrame("Frame")

function events:OnEvent(event, ...)
  self[event](self, event, ...)
end

function events:ADDON_LOADED(event, addonname)
  if addonname == "Rematch" then
    ketchum.rematch:AddHasShinyBadge()
    ketchum.rematch:AddIsShinyBadge()
  end
end

function events:PET_BATTLE_OPENING_START()
    local numEnemies = C_PetBattles.GetNumPets(Enum.BattlePetOwner.Enemy)

    for i = 1, numEnemies do
      local speciesID = C_PetBattles.GetPetSpeciesID(Enum.BattlePetOwner.Enemy, i)

      local displayID = C_PetBattles.GetDisplayID(Enum.BattlePetOwner.Enemy, i)

      local displayIdIndex = ketchum.journal:GetDisplayIndex(speciesID, displayID)

      local probability

      if displayIdIndex then
        probability = C_PetJournal.GetDisplayProbabilityByIndex(speciesID, displayIdIndex)
      end

      local shinyIcon = CreateAtlasMarkup("rare-elite-star")
        

      if probability <= 10 then
        PlaySoundFile("Interface\\AddOns\\Ketchum\\assets\\pla-shiny.mp3")
        local pet = ketchum.pets.GetPet(speciesID)
        print('|c00ffff00'..shinyIcon..' A shiny '..pet.name..' appears! '..shinyIcon..'|r')
        
        if i == 1 then
          ketchum.battleUi:TagShinyActivePet()
        end
      end
    end
end

events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PET_BATTLE_OPENING_START")
events:SetScript("OnEvent", events.OnEvent)