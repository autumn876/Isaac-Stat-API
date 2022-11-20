
StatAPI.StewCounter=0
local stew = {}
function stew.RedStew()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        local RedStewDamage = "RedStewDamage" .. GetPlayerIndex(player)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_RED_STEW) then
            if not StatAPI.T[RedStewDamage] then
                StatAPI.T[RedStewDamage] = 21.6
            end
            if StatAPI.T[RedStewDamage]>0 then
                StatAPI.T[RedStewDamage] = StatAPI.T[RedStewDamage] -0.005
            else StatAPI.T[RedStewDamage]=0 end
        end
    end
end
function stew:RedStewIncrease(entity)
    if entity:IsEnemy() then 
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        local RedStewDamage = "RedStewDamage" .. GetPlayerIndex(player)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_RED_STEW) then
            StatAPI.T[RedStewDamage] = StatAPI.T[RedStewDamage] + 0.5
        end
    end
end
end


return stew