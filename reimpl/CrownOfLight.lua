
function StatAPI.CrownOfLight() --pain in the ass, unimplemented for now, I'll get it in soon-ish
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) then
            StatAPI.CheckCrown()
            if StatAPI.IsCrownActive and not StatAPI.HasBeenHit then
                local utilDamage = "PlayerDamage" .. GetPlayerIndex(player)
                StatAPI.T[utilDamage] = StatAPI.T[utilDamage]*2
            end
        end
    end
end
function StatAPI.CheckCrown()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) then
            if player:GetMaxHearts()-player:GetHearts()==0 then
                StatAPI.IsCrownActive = true
            else
                StatAPI.IsCrownActive = false
            end
        end
    end
end

---@param player EntityPlayer
function StatAPI:ResetCrown(player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) then
        StatAPI.HasBeenHit = true
        StatAPI.IsCrownActive = false
    end
end
StatAPI:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, StatAPI.ResetCrown,EntityType.ENTITY_PLAYER)