local _, _JetBattlePets = ...

---@type JetBattlePets
local JetBattlePets = _JetBattlePets

JetBattlePets.atlas = JetBattlePets.atlas or {}

-- get tex coords from a provided atlas
function JetBattlePets.atlas:GetTexCoords(atlas)
  return atlas.leftTexCoord,
      atlas.rightTexCoord,
      atlas.topTexCoord,
      atlas.bottomTexCoord
end
