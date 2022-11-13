function StatAPI.HeartBreak()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_HEARTBREAK) then
            local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
            StatAPI.T[utilFlatDamage]=(StatAPI.T[utilFlatDamage])+(0.25*player:GetBrokenHearts())
        end
    end
end