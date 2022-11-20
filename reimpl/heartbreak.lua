local heartbreak = {}
function heartbreak.HeartBreak()
    
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_HEARTBREAK) then
            local HeartBreakDamage = "HeartBreakDamage" .. GetPlayerIndex(player)
            print(StatAPI.T[HeartBreakDamage])
            StatAPI.T[HeartBreakDamage]=(0.25*player:GetBrokenHearts())
            print(StatAPI.T[HeartBreakDamage])
        end
    end
end
return heartbreak