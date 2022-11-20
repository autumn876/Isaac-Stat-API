local adrenal = {}
function adrenal.Adrenaline()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_ADRENALINE) then
            local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
            StatAPI.T[utilFlatDamage]=(StatAPI.T[utilFlatDamage])+((2*(player:GetMaxHearts()-player:GetHearts()))^1.6)*0.1
        end
    end
end
return adrenal