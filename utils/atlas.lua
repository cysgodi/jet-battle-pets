local _, ketchum = ...

ketchum.atlas = {}

-- get tex coords from a provided atlas
function ketchum.atlas:GetTexCoords(atlas)
  return atlas.leftTexCoord,
      atlas.rightTexCoord,
      atlas.topTexCoord,
      atlas.bottomTexCoord
end
