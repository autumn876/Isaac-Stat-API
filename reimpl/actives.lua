function StatAPI:Active(item,_,player)
    local utilRoomDamage = "PlayerRoomDamage" .. GetPlayerIndex(player)
    for i, collectible in pairs(StatAPI.RoomActives) do
        if item == collectible then
            StatAPI.T[utilRoomDamage] = StatAPI.T[utilRoomDamage] + collectible.DAMAGE
        end
    end
end

function StatAPI.ResetBetweenRooms()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        local utilRoomDamage = "PlayerRoomDamage" .. GetPlayerIndex(player)
        StatAPI.T[utilRoomDamage] = 0
        StatAPI.HasBeenHit = false
    end
end

StatAPI:AddCallback(ModCallbacks.MC_USE_ITEM, StatAPI.Active)
StatAPI:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, StatAPI.ResetBetweenRooms)