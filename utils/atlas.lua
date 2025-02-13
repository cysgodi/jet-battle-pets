local _, JetBattlePets = ...

JetBattlePets.atlas = {}

-- get tex coords from a provided atlas
function JetBattlePets.atlas:GetTexCoords(atlas)
  return atlas.leftTexCoord,
      atlas.rightTexCoord,
      atlas.topTexCoord,
      atlas.bottomTexCoord
end
