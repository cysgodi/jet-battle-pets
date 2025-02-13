local _, JetBattlePets = ...

JetBattlePets.journal = {}

-- return all model encounter rates of a species as a table
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

-- return the probability of encountering a specific skin in a species
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

-- determine the index of a specific display ID of a specific species
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

-- get the rarity of a variant model
function JetBattlePets.journal:GetDisplayRarity(speciesID, displayID)
  local maxProbability = self:GetMaxDisplayProbability(speciesID)
  local displayProbability = self:GetDisplayProbability(
    speciesID,
    displayID
  )

  local ratio = maxProbability / displayProbability
  local RARITIES = JetBattlePets.constants.RARITIES
  local RARITY_NAMES = JetBattlePets.constants.RARITY_NAMES
  local RARITY_RATIOS = JetBattlePets.constants.RARITY_RATIOS
  local rarityIndex = RARITIES.COMMON

  if ratio >= RARITY_RATIOS.SHINY then
    rarityIndex = RARITIES.SHINY
  elseif ratio >= RARITY_RATIOS.RARE then
    rarityIndex = RARITIES.RARE
  elseif ratio >= RARITY_RATIOS.UNCOMMON then
    rarityIndex = RARITIES.UNCOMMON
  end

  return RARITY_NAMES[rarityIndex]
end

-- get the rarity of a variant model by the model display index
function JetBattlePets.journal:GetDisplayRarityByIndex(speciesID, slot)
  local displayID = C_PetJournal.GetDisplayIDByIndex(speciesID, slot)

  return self:GetDisplayRarity(speciesID, displayID)
end

-- get the encounter probability of the most common model of a species
function JetBattlePets.journal:GetMaxDisplayProbability(speciesID)
  local probabilities = JetBattlePets.journal:GetDisplayProbabilities(speciesID)

  return math.max(unpack(probabilities))
end

-- is the species with the given ID on the ignore list?
function JetBattlePets.journal:IsIgnored(speciesID)
  return not not JetBattlePets.constants.IGNORED_SPECIES[speciesID]
end
