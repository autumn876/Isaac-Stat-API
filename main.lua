--[[Damage = ((
    (
        (
            (
                (
                3.5*math.sqrt(
                                (
                                    (
                                        (
                                            mmush
                                            +(brimstone+ brimstone)
                                            +hemolachria
                                            +cricket's head
                                            +book of belial
                                            +blood of the martyr
                                            this might be any flat damage ups

                                        )
                                    *ThinOddmushMult
                                    + ThinOddMushDown --negative damage
                                    + (razor * perroom)
                                    + (black feather * evil items)
                                    + nail
                                    + purity
                                    )
                                    *1.2
                                    +1

                                )  
                                +(lusty blood * enemies killed)
                            )
                            + polyphemus

                )
                *dark judas
                *polyphemus
                +esau
                +eden
            )
            *mega mush
            + (berserk+moms knife)
            +berserk
            +huge growth
            +potato peeler
            +bozo
            +curved horn
            +void stat boosts

        )
        * sacred heart
        *(brimstone + brimstone)
        * crown of light
        +sacred heart
    )
    *fakered heart,  hallowed ground, and the like (only as one mult)
    +adrenaline
    +bloody lust

)
*(ludo and azazel)
*(brimstone synergies)
+ ipecac
)
* book of belial, crickets head or magic mush--groups of damage multipliers
*eves mascara
*soy/almond milk
*20/20
*star of bethleheem
*sucubuus
*deadeye
*d8
*modded multipliers]]
local itemconfig = Isaac.GetItemConfig()
local amountOfCollectibles = itemconfig:GetCollectibles().Size-1
StatAPI = RegisterMod("Stat API",1)

StatAPI.GotMilk = false
local function GetPlayerIndex(player)
    return tostring(player:GetCollectibleRNG(1):GetSeed())
end


StatAPI.T={}
function StatAPI.GetFlatDamage()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
        if not StatAPI.T[utilFlatDamage] then
            StatAPI.T[utilFlatDamage]=0
        end
        local player = Game():GetPlayer(i)
        for _, collectible in pairs(StatAPI.ItemsWithDamage)do
            if player:HasCollectible(CollectibleType.collectible) then
                StatAPI.T[utilFlatDamage]= (StatAPI.T[utilFlatDamage]or 0)+collectible.DAMAGE
            end
        end
    end
end
function StatAPI.GetDamageMultiplier()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        local utilDamage = "PlayerDamageMultiplier" .. GetPlayerIndex(player)
        if not StatAPI.T[utilDamage] then
            StatAPI.T[utilDamage]=1
        end
        local player = Game():GetPlayer(i)
        for _, collectible in pairs(StatAPI.ItemsWithDamageMultiplier)do
            if player:HasCollectible(CollectibleType.collectible) then
                if not collectible.TAGS then 
                    StatAPI.T[utilDamage]= (StatAPI.T[utilDamage]or 1)*collectible.DAMAGE_MULTIPLIER
                else 
                if collectible.TAGS == "MILK" then
                    if StatAPI.GotMilk then
                        StatAPI.T[utilDamage]= (StatAPI.T[utilDamage]or 1)*0.2
                    end
                    StatAPI.GotMilk=true
                end
                
                end
            end
        end
    end
end

function StatAPI.Reset()
    if Game():GetFrameCount() == 1 then
        for i=0, Game():GetNumPlayers()-1 do
            local player = Game():GetPlayer(i)
            local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
            local utilDamage = "PlayerDamageMultiplier" .. GetPlayerIndex(player)
            StatAPI.T[utilFlatDamage]=0
            StatAPI.T[utilDamage]=1
        end
    end
end
function StatAPI.GetBaseDamage()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        local ReturnedCharacter
        local utilDamage = "PlayerDamageMultiplier" .. GetPlayerIndex(player)
        local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
        local utilTotalDamage = "PlayerTotalDamage" .. GetPlayerIndex(player)
        for _, character in(StatAPI.CharacterMultipliers) do
            if player:GetPlayerType() == PlayerType.character then
                ReturnedCharacter = character
                break
            end
        end
        if not ReturnedCharacter then ReturnedCharacter = {DAMAGE_MULT=1,BASE=3.5}end
        if not ReturnedCharacter.TAGS then 
            StatAPI.T[utilTotalDamage]= (StatAPI.T[utilFlatDamage]+(ReturnedCharacter.BASE or 3.5))*((ReturnedCharacter.DAMAGE_MULT or 1)*(StatAPI.T[utilDamage]or 1))
        end
    end
end

function StatAPI:EvaluateTotalDamage(player1,cache)
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        player:EvaluateItems()
        local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
        local utilDamage = "PlayerDamageMultiplier" .. GetPlayerIndex(player)
        local utilTotalDamage = "PlayerTotalDamage" .. GetPlayerIndex(player)
        player.Damage = StatAPI.T[utilTotalDamage]
    end

end

StatAPI.ItemsWithDamage = { --oh god here it comes
    COLLECTIBLE_ABADDON = {DAMAGE=1.5},
    COLLECTIBLE_BLOOD_CLOT={DAMAGE=1,TAGS={"ONE_EYE"}},
    COLLECTIBLE_BLOOD_OF_THE_MARTYR={DAMAGE=1},
    COLLECTIBLE_CAPRICORN={DAMAGE=0.5},
    COLLECTIBLE_CAT_O_NINE_TAILS={DAMAGE=1},
    COLLECTIBLE_CEREMONIAL_ROBES={DAMAGE=1},
    COLLECTIBLE_CHAMPION_BELT={DAMAGE=1},
    COLLECTIBLE_CHARM_VAMPIRE={DAMAGE=0.3},
    COLLECTIBLE_CHEMICAL_PEEL={DAMAGE=2,TAGS={"ONE_EYE"}},
    COLLECTIBLE_DARK_MATTER={DAMAGE=1},
    COLLECTIBLE_DEATHS_TOUCH={DAMAGE=1.5},
    COLLECTIBLE_GODHEAD={DAMAGE=0.5}, -- a little trolling
    COLLECTIBLE_GROWTH_HORMONES={DAMAGE=1},
    COLLECTIBLE_GUILLOTINE={DAMAGE=1},
    COLLECTIBLE_IRON_BAR={DAMAGE=0.3},
    COLLECTIBLE_JESUS_JUICE={DAMAGE=0.5},
    COLLECTIBLE_MEAT={DAMAGE=0.3},
    COLLECTIBLE_MY_REFLECTION={DAMAGE=1.5}, --why did they buff this
    COLLECTIBLE_ODD_MUSHROOM_LARGE={DAMAGE=0.3},
    COLLECTIBLE_PENTAGRAM={DAMAGE=1},
    COLLECTIBLE_SMB_SUPER_FAN={DAMAGE=0.3},
    COLLECTIBLE_STEVEN={DAMAGE=1},
    COLLECTIBLE_STIGMATA={DAMAGE=0.3},
    COLLECTIBLE_SYNTHOIL={DAMAGE=1},
    COLLECTIBLE_HALO={DAMAGE=0.3},
    COLLECTIBLE_MARK={DAMAGE=1},
    COLLECTIBLE_NEGATIVE={DAMAGE=1},
    COLECTIBLE_PACT={DAMAGE=0.5},
    COLLECTIBLE_SMALL_ROCK={DAMAGE=1},
    COLLECTIBLE_8_INCH_NAILS={DAMAGE=1.5},
    COLLECTIBLE_DOG_TOOTH={DAMAGE=0.3},
    COLLECTIBLE_SULFURIC_ACID={DAMAGE=0.3},
    COLLECTIBLE_DOGMA={DAMAGE=2,TAGS={"QUEST"}},
    COLLECTIBLE_EYE_OF_THE_OCCULT={DAMAGE=1},
    COLLECTIBLE_GLASS_EYE={DAMAGE=0.75},
    COLLECTIBLE_MOMS_RING={DAMAGE=1},
    COLLECTIBLE_SAUSAGE={DAMAGE=0.5},
    COLLECTIBLE_STAPLER={DAMAGE=1,TAGS={"ONE_EYE"}},
    COLLECTIBLE_TERRA={DAMAGE=1},
}
StatAPI.ItemsWithDamageMultiplier={
    COLLECTIBLE_MAGIC_MUSHROOM={DAMAGE_MULTIPLIER=1.5},
    COLLECTIBLE_EVES_MASCARA={DAMAGE_MULTIPLIER=2},
    COLLECTIBLE_20_20={DAMAGE_MULTIPLIER=0.},
    COLLECTIBLE_CRICKETS_HEAD={DAMAGE_MULTIPLIER=1.5},
    COLLECTIBLE_POLYPHEMUS={DAMAGE_MULTIPLIER=2},
    COLLECTIBLE_SACRED_HEART={DAMAGE_MULTIPLIER=2.3},
    COLLECTIBLE_SOY_MILK={DAMAGE_MULTIPLIER=0.2,TAGS={"MILK"}},
    COLLECTIBLE_HAEMOLACRIA={DAMAGE_MULTIPLIER=1.5},
    COLLECTIBLE_ALMOND_MILK={DAMAGE_MULTIPLIER=0.3,TAGS={"MILK"}},
    COLLECTIBLE_STYE={DAMAGE_MULTIPLIER=1.28,TAGS={"ONE_EYE"}},
}
StatAPI.CharacterMultipliers={
    PLAYER_EVE = {DAMAGE_MULT=0.75, TAGS="SPECIAL"},
    PLAYER_CAIN = {DAMAGE_MULT=1.2},
    PLAYER_JUDAS = {DAMAGE_MULT=1.35},
    PLAYER_BLACKJUDAS = {DAMAGE_MULT=2},
    PLAYER_BLUEBABY = {DAMAGE_MULT=1.05},
    PLAYER_AZAZEL={DAMAGE_MULT=1.5},
    PLAYER_EDEN={TAGS="SPECIAL"},
    PLAYER_LAZARUS2={DAMAGE_MULT=1.4},
    PLAYER_KEEPER={DAMAGE_MULT=1.2},
    PLAYER_THEFORGOTTEN={DAMAGE_MULT=1.5},
    PLAYER_JACOB={BASE=2.75},
    PLAYER_ESAU={BASE=3.75},
    PLAYER_MAGDALENE_B={DAMAGE_MULT=0.75},
    PLAYER_EVE_B={DAMAGE_MULT=1.2},
    PLAYER_AZAZEL_B={DAMAGE_MULT=1.5},
    PLAYER_EDEN_B={TAGS="SPECIAL"},
    PLAYER_LAZARUS2_B={DAMAGE_MULT=1.5},
    PLAYER_THELOST_B={DAMAGE_MULT=1.3},
    PLAYER_THEFORGOTTEN_B={DAMAGE_MULT=1.5},
}
StatAPI:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,StatAPI.EvaluateTotalDamage,CacheFlag.CACHE_ALL)