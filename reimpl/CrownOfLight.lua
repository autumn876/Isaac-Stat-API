
function StatAPI.CrownOfLight()
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

---@param collider EntityNPC
---@param player EntityPlayer
function StatAPI:ResetCrown(player,collider)
    if collider:IsEnemy() then
        if not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then --might have to tweak later
            StatAPI.HasBeenHit = true
            StatAPI.IsCrownActive = false
        end
    end
end
StatAPI:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, StatAPI.ResetCrown)