local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.journal = JetBattlePets.journal or {}

function JetBattlePets.journal:GetDisplayProbabilities(speciesID)
  local probabilities = { 100 }

  local numDisplays = C_PetJournal.GetNumDisplays(speciesID)

  if not numDisplays or numDisplays == 0 then
    return probabilities
  end

  probabilities = {}

  for i = 1, numDisplays do
    local probability = C_PetJournal.GetDisplayProbabilityByIndex(
      speciesID,
      i
    ) or 100

    table.insert(probabilities, probability)
  end

  return probabilities
end

function JetBattlePets.journal:GetDisplayProbability(speciesID, displayID)
  local displayIdIndex = JetBattlePets.journal:GetDisplayIndex(
    speciesID,
    displayID
  )

  local probability

  if displayIdIndex then
    probability = C_PetJournal.GetDisplayProbabilityByIndex(
      speciesID,
      displayIdIndex
    )
  end

  return probability
end

function JetBattlePets.journal:GetDisplayIndex(speciesID, displayID)
  local numDisplays = C_PetJournal.GetNumDisplays(speciesID)

  if not numDisplays then
    return nil
  end

  local displayIdIndex

  for i = 1, numDisplays do
    local _displayID = C_PetJournal.GetDisplayIDByIndex(speciesID, i)

    if _displayID == displayID then
      displayIdIndex = i
    end
  end

  return displayIdIndex
end

function JetBattlePets.journal:GetDisplayIndexProbabilityText(speciesID, displayIndex)
  local probability = C_PetJournal.GetDisplayProbabilityByIndex(
    speciesID,
    displayIndex
  ) or 100

  local maxProbability = JetBattlePets.journal:GetMaxDisplayProbability(speciesID)

  return JetBattlePets.text:GetRarityText(
    probability,
    maxProbability
  )
end

function JetBattlePets.journal:GetDisplayProbabilityText(speciesID, displayID)
  local displayIndex = JetBattlePets.journal:GetDisplayIndex(speciesID, displayID)

  return JetBattlePets.journal:GetDisplayIndexProbabilityText(speciesID, displayIndex)
end

function JetBattlePets.journal:GetDisplayRarity(speciesID, displayID)
  local maxProbability = self:GetMaxDisplayProbability(speciesID)
  local displayProbability = self:GetDisplayProbability(
    speciesID,
    displayID
  )

  local ratio = maxProbability / displayProbability
  local RARITIES = JetBattlePets.constants.RARITIES
  local RARITY_RATIOS = JetBattlePets.constants.RARITY_RATIOS

  if ratio >= RARITY_RATIOS.SHINY then
    return RARITIES.SHINY
  elseif ratio >= RARITY_RATIOS.RARE then
    return RARITIES.RARE
  elseif ratio >= RARITY_RATIOS.UNCOMMON then
    return RARITIES.UNCOMMON
  end

  return RARITIES.COMMON
end

function JetBattlePets.journal:GetDisplayRarityByIndex(speciesID, slot)
  local displayID = C_PetJournal.GetDisplayIDByIndex(speciesID, slot)

  return self:GetDisplayRarity(speciesID, displayID)
end

function JetBattlePets.journal:GetDisplayRarityName(speciesID, displayID)
  local rarity = JetBattlePets.journal:GetDisplayRarity(speciesID, displayID)

  return JetBattlePets.constants.RARITY_NAMES[rarity]
end

function JetBattlePets.journal:GetMaxDisplayProbability(speciesID)
  local probabilities = JetBattlePets.journal:GetDisplayProbabilities(speciesID)

  return math.max(unpack(probabilities))
end

function JetBattlePets.journal:GetNumOwned(speciesID, displayID)
  local ownedCount = 0

  for index = 1, C_PetJournal.GetNumPets() do
    local petID, _speciesID = C_PetJournal.GetPetInfoByIndex(index)

    if _speciesID == speciesID then
      local petInfo = JetBattlePets.pets.GetPet(petID)

      if petInfo.displayID == displayID or C_PetJournal.PetUsesRandomDisplay(speciesID) then
        ownedCount = ownedCount + 1
      end
    end
  end

  return ownedCount
end
