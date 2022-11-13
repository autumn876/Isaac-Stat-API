--(damage ups from other items*0.9)-0.4
function StatAPI.OddMushThin()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN) then
            local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
            StatAPI.T[utilFlatDamage]=(StatAPI.T[utilFlatDamage]*0.9)-0.4
        end
    end
end