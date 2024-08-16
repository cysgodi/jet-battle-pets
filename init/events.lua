local _, ketchum = ...

local events = CreateFrame("Frame")

function events:OnEvent(event, ...)
  self[event](self, event, ...)
end

function events:ADDON_LOADED(event, addonname)
  if addonname == "Rematch" then
    ketchum.rematch:AddShinyBadge()
  end
end

function events:PET_BATTLE_OPENING_DONE()
    local numEnemies = C_PetBattles.GetNumPets(Enum.BattlePetOwner.Enemy)

    for i = 1, numEnemies do
      local speciesID = C_PetBattles.GetPetSpeciesID(Enum.BattlePetOwner.Enemy, i)

      local displayID = C_PetBattles.GetDisplayID(Enum.BattlePetOwner.Enemy, i)

      local displayIdIndex = ketchum.journal:GetDisplayIndex(speciesID, displayID)

      local probability

      if displayIdIndex then
        probability = C_PetJournal.GetDisplayProbabilityByIndex(speciesID, displayIdIndex)
      end

      local pet = ketchum.pets.GetPet(speciesID)

      print(pet.name, probability)

      if probability <= 10 then
        PlaySoundFile("Interface\\AddOns\\Ketchum\\pla-shiny.mp3")
      end
    end
end

events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PET_BATTLE_OPENING_DONE")
events:SetScript("OnEvent", events.OnEvent)