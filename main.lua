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

local redStew = require("reimpl.redStew")
local adrenaline = require("reimpl.adrenaline")
local crownOfLight = require("reimpl.crownOfLight")
local heartBreak = require("reimpl.heartbreak")

StatAPI.GotMilk = false
function GetPlayerIndex(player) --gets the player index based on the collectible seed, so it's consistent across runs as well as other various things such as multiplayer
    return tostring(player:GetCollectibleRNG(1):GetSeed())
end

StatAPI.IsCrownActive = false

StatAPI.T= StatAPI.T or {}
function StatAPI.GetFlatDamage()
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
        if not StatAPI.T[utilFlatDamage] then
            StatAPI.T[utilFlatDamage]=0
        end
        local player = Game():GetPlayer(i)
        for _, collectible in pairs(StatAPI.ItemsWithDamage)do
            if player:HasCollectible(collectible.type) then
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
            if player:HasCollectible(collectible.type) then
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

--EffectiveDamage = Character base * sqrt(total damage ups*1.2+1)+flat damage ups

function StatAPI.Reset()
    if Game():GetFrameCount() == 1 then
        for i=0, Game():GetNumPlayers()-1 do
            local player = Game():GetPlayer(i)
            local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
            local utilDamage = "PlayerDamageMultiplier" .. GetPlayerIndex(player)
            local utilRedStew = "RedStewDamage"..GetPlayerIndex(player)
            local utilRoomDamage = "RoomDamage"..GetPlayerIndex(player)
            StatAPI.T[utilFlatDamage]=0
            StatAPI.T[utilDamage]=1
            StatAPI.T[utilRedStew]=nil
            StatAPI.T[utilRoomDamage]=0
        end
    end
end
function StatAPI.GetBaseDamage()
    --print("hi 2")
    for i=0, Game():GetNumPlayers()-1 do
        StatAPI.GetDamageMultiplier()
        StatAPI.GetFlatDamage()
        local player = Game():GetPlayer(i)
        local ReturnedCharacter
        local utilDamage = "PlayerDamageMultiplier" .. GetPlayerIndex(player)
        local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
        local utilRoomDamage = "PlayerRoomDamage" .. GetPlayerIndex(player)
        local utilTotalDamage = "PlayerTotalDamage" .. GetPlayerIndex(player)
        local utilRedStew = "RedStewDamage"..GetPlayerIndex(player)
        local HeartBreakDamage = "HeartBreakDamage" .. GetPlayerIndex(player)
        for j, character in pairs(StatAPI.CharacterMultipliers) do
            if player:GetPlayerType() == character.type then
                ReturnedCharacter = character
                break
            end
        end
        if not ReturnedCharacter then ReturnedCharacter = {DAMAGE_MULT=1,BASE=3.5}end
        if not ReturnedCharacter.TAGS then 
            StatAPI.T[utilTotalDamage]= (ReturnedCharacter.BASE or 3.5) * math.sqrt((((StatAPI.T[utilFlatDamage]or 0)+(StatAPI.T[utilRoomDamage] or 0)+(StatAPI.T[HeartBreakDamage] or 0)+(StatAPI.T[utilRedStew]or 0)*1.2*(StatAPI.T[utilDamage]or 1)+1)))
        end
    end
end

function StatAPI:EvaluateTotalDamage(player1,cache)
    --print("hi 3")
    for i=0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        --print("player index",i)
        --player:EvaluateItems()
        for _, func in pairs (StatAPI.ReimplFunctions) do
            func()
        end
        StatAPI.GetBaseDamage()
        local utilFlatDamage = "PlayerDamage" .. GetPlayerIndex(player)
        local utilDamage = "PlayerDamageMultiplier" .. GetPlayerIndex(player)
        local utilTotalDamage = "PlayerTotalDamage" .. GetPlayerIndex(player)
        --print("updating damage")
        player.Damage = StatAPI.T[utilTotalDamage]
    end
end
function StatAPI.AddItemWithMulti(type,multiplier)

    local item = {
        type = type,
        DAMAGE_MULTIPLIER = multiplier
    }
    table.insert(StatAPI.ItemsWithDamageMultiplier,item)
end
function StatAPI.AddFlatDamage(type,damage)
    local item = {
        type = type,
        DAMAGE = damage
    }
    table.insert(StatAPI.ItemsWithDamage,item)
end
function StatAPI.AddCharacterMultiplier(type,multiplier,base)
    local item = {
        type = type,
        DAMAGE_MULT = multiplier,
        BASE = base
    }
    table.insert(StatAPI.CharacterMultipliers,item)
end
function StatAPI.AddReimplFunction(func)
    table.insert(StatAPI.ReimplFunctions,func)
end
function StatAPI.AddRoomDamage(type,damage)
    local item = {
        type = type,
        DAMAGE = damage
    }
    table.insert(StatAPI.RoomDamage,item)
end

StatAPI.ItemsWithDamage = { --oh god here it comes
    COLLECTIBLE_ABADDON = {DAMAGE=1.5,type=CollectibleType.COLLECTIBLE_ABADDON},
    COLLECTIBLE_BLOOD_CLOT={DAMAGE=1,type=CollectibleType.COLLECTIBLE_BLOOD_CLOT,TAGS={"ONE_EYE"}},
    COLLECTIBLE_BLOOD_OF_THE_MARTYR={DAMAGE=1,type=CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR},
    COLLECTIBLE_CAPRICORN={DAMAGE=0.5,type=CollectibleType.COLLECTIBLE_CAPRICORN},
    COLLECTIBLE_CAT_O_NINE_TAILS={DAMAGE=1,type=CollectibleType.COLLECTIBLE_CAT_O_NINE_TAILS},
    COLLECTIBLE_CEREMONIAL_ROBES={DAMAGE=1,type=CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES},
    COLLECTIBLE_CHAMPION_BELT={DAMAGE=1,type=CollectibleType.COLLECTIBLE_CHAMPION_BELT},
    COLLECTIBLE_CHARM_VAMPIRE={DAMAGE=0.3,type=CollectibleType.COLLECTIBLE_CHARM_VAMPIRE},
    COLLECTIBLE_CHEMICAL_PEEL={DAMAGE=2,TAGS={"ONE_EYE"},type=CollectibleType.COLLECTIBLE_CHEMICAL_PEEL},
    COLLECTIBLE_CRICKETS_HEAD={DAMAGE=0.5,type=CollectibleType.COLLECTIBLE_CRICKETS_HEAD},
    COLLECTIBLE_DARK_MATTER={DAMAGE=1,type=CollectibleType.COLLECTIBLE_DARK_MATTER},
    COLLECTIBLE_DEATHS_TOUCH={DAMAGE=1.5,type=CollectibleType.COLLECTIBLE_DEATHS_TOUCH},
    COLLECTIBLE_GODHEAD={DAMAGE=0.5,type=CollectibleType.COLLECTIBLE_GODHEAD}, -- a little trolling
    COLLECTIBLE_GROWTH_HORMONES={DAMAGE=1,type=CollectibleType.COLLECTIBLE_GROWTH_HORMONES},
    COLLECTIBLE_GUILLOTINE={DAMAGE=1,type=CollectibleType.COLLECTIBLE_GUILLOTINE},
    COLLECTIBLE_IRON_BAR={DAMAGE=0.3,type=CollectibleType.COLLECTIBLE_IRON_BAR},
    COLLECTIBLE_JESUS_JUICE={DAMAGE=0.5,type=CollectibleType.COLLECTIBLE_JESUS_JUICE},
    COLLECTIBLE_MEAT={DAMAGE=0.3,type=CollectibleType.COLLECTIBLE_MEAT},
    COLLECTIBLE_MY_REFLECTION={DAMAGE=1.5,type=CollectibleType.COLLECTIBLE_MY_REFLECTION}, --why did they buff this
    COLLECTIBLE_ODD_MUSHROOM_LARGE={DAMAGE=0.3,type=CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE},
    COLLECTIBLE_PENTAGRAM={DAMAGE=1,type=CollectibleType.COLLECTIBLE_PENTAGRAM},
    COLLECTIBLE_SMB_SUPER_FAN={DAMAGE=0.3,type=CollectibleType.COLLECTIBLE_SMB_SUPER_FAN},
    COLLECTIBLE_STEVEN={DAMAGE=1,type=CollectibleType.COLLECTIBLE_STEVEN},
    COLLECTIBLE_STIGMATA={DAMAGE=0.3,type=CollectibleType.COLLECTIBLE_STIGMATA},
    COLLECTIBLE_SYNTHOIL={DAMAGE=1,type=CollectibleType.COLLECTIBLE_SYNTHOIL},
    COLLECTIBLE_HALO={DAMAGE=0.3,type=CollectibleType.COLLECTIBLE_HALO},
    COLLECTIBLE_MARK={DAMAGE=1,type=CollectibleType.COLLECTIBLE_MARK},
    COLLECTIBLE_NEGATIVE={DAMAGE=1,type=CollectibleType.COLLECTIBLE_NEGATIVE},
    COLECTIBLE_PACT={DAMAGE=0.5,type=CollectibleType.COLLECTIBLE_PACT},
    COLLECTIBLE_SMALL_ROCK={DAMAGE=1,type=CollectibleType.COLLECTIBLE_SMALL_ROCK},
    COLLECTIBLE_8_INCH_NAILS={DAMAGE=1.5,type=CollectibleType.COLLECTIBLE_8_INCH_NAILS},
    COLLECTIBLE_DOG_TOOTH={DAMAGE=0.3,type=CollectibleType.COLLECTIBLE_DOG_TOOTH},
    COLLECTIBLE_SULFURIC_ACID={DAMAGE=0.3,type=CollectibleType.COLLECTIBLE_SULFURIC_ACID},
    COLLECTIBLE_DOGMA={DAMAGE=2,TAGS={"QUEST"},type=CollectibleType.COLLECTIBLE_DOGMA},
    COLLECTIBLE_EYE_OF_THE_OCCULT={DAMAGE=1,type=CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT},
    COLLECTIBLE_GLASS_EYE={DAMAGE=0.75,type=CollectibleType.COLLECTIBLE_GLASS_EYE},
    COLLECTIBLE_MOMS_RING={DAMAGE=1,type=CollectibleType.COLLECTIBLE_MOMS_RING},
    COLLECTIBLE_SAUSAGE={DAMAGE=0.5,type=CollectibleType.COLLECTIBLE_SAUSAGE},
    COLLECTIBLE_STAPLER={DAMAGE=1,TAGS={"ONE_EYE"},type=CollectibleType.COLLECTIBLE_STAPLER},
    COLLECTIBLE_TERRA={DAMAGE=1,type=CollectibleType.COLLECTIBLE_TERRA},
    COLLECTIBLE_IPECAC={DAMAGE=40,type=CollectibleType.COLLECTIBLE_IPECAC},
}
StatAPI.ItemsWithDamageMultiplier={
    COLLECTIBLE_MAGIC_MUSHROOM={DAMAGE_MULTIPLIER=1.5,type=CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM},
    COLLECTIBLE_EVES_MASCARA={DAMAGE_MULTIPLIER=2,type=CollectibleType.COLLECTIBLE_EVES_MASCARA},
    COLLECTIBLE_20_20={DAMAGE_MULTIPLIER=0.8,type=CollectibleType.COLLECTIBLE_20_20},
    COLLECTIBLE_CRICKETS_HEAD={DAMAGE_MULTIPLIER=1.5,type=CollectibleType.COLLECTIBLE_CRICKETS_HEAD},
    COLLECTIBLE_POLYPHEMUS={DAMAGE_MULTIPLIER=2,type=CollectibleType.COLLECTIBLE_POLYPHEMUS},
    COLLECTIBLE_SACRED_HEART={DAMAGE_MULTIPLIER=2.3,type=CollectibleType.COLLECTIBLE_SACRED_HEART},
    COLLECTIBLE_SOY_MILK={DAMAGE_MULTIPLIER=0.2,TAGS={"MILK"},type=CollectibleType.COLLECTIBLE_SOY_MILK},
    COLLECTIBLE_HAEMOLACRIA={DAMAGE_MULTIPLIER=1.5,type=CollectibleType.COLLECTIBLE_HAEMOLACRIA},
    COLLECTIBLE_ALMOND_MILK={DAMAGE_MULTIPLIER=0.3,TAGS={"MILK"},type=CollectibleType.COLLECTIBLE_ALMOND_MILK},
    COLLECTIBLE_STYE={DAMAGE_MULTIPLIER=1.28,TAGS={"ONE_EYE"},type=CollectibleType.COLLECTIBLE_STYE},
}
StatAPI.CharacterMultipliers={
    PLAYER_EVE = {DAMAGE_MULT=0.75, TAGS="SPECIAL",type=PlayerType.PLAYER_EVE},
    PLAYER_CAIN = {DAMAGE_MULT=1.2,type=PlayerType.PLAYER_CAIN},
    PLAYER_JUDAS = {DAMAGE_MULT=1.35,type=PlayerType.PLAYER_JUDAS},
    PLAYER_BLACKJUDAS = {DAMAGE_MULT=2,type=PlayerType.PLAYER_BLACKJUDAS},
    PLAYER_BLUEBABY = {DAMAGE_MULT=1.05,type=PlayerType.PLAYER_BLUEBABY},
    PLAYER_AZAZEL={DAMAGE_MULT=1.5,type=PlayerType.PLAYER_AZAZEL},
    PLAYER_EDEN={TAGS="SPECIAL",type=PlayerType.PLAYER_EDEN},
    PLAYER_LAZARUS2={DAMAGE_MULT=1.4,type=PlayerType.PLAYER_LAZARUS2},
    PLAYER_KEEPER={DAMAGE_MULT=1.2,type=PlayerType.PLAYER_KEEPER},
    PLAYER_THEFORGOTTEN={DAMAGE_MULT=1.5,type=PlayerType.PLAYER_THEFORGOTTEN},
    PLAYER_JACOB={BASE=2.75,type=PlayerType.PLAYER_JACOB},
    PLAYER_ESAU={BASE=3.75,type=PlayerType.PLAYER_ESAU},
    PLAYER_MAGDALENE_B={DAMAGE_MULT=0.75,type=PlayerType.PLAYER_MAGDALENE_B},
    PLAYER_EVE_B={DAMAGE_MULT=1.2,type=PlayerType.PLAYER_EVE_B},
    PLAYER_AZAZEL_B={DAMAGE_MULT=1.5,type=PlayerType.PLAYER_AZAZEL_B},
    PLAYER_EDEN_B={TAGS="SPECIAL",type=PlayerType.PLAYER_EDEN_B},
    PLAYER_LAZARUS2_B={DAMAGE_MULT=1.5,type=PlayerType.PLAYER_LAZARUS2_B},
    PLAYER_THELOST_B={DAMAGE_MULT=1.3,type=PlayerType.PLAYER_THELOST_B},
    PLAYER_THEFORGOTTEN_B={DAMAGE_MULT=1.5,type=PlayerType.PLAYER_THEFORGOTTEN_B},
}
StatAPI.ReimplScripts = {
    "stat-api.reimpl.oddmushthin",
    "stat-api.reimpl.heartbreak",
    "stat-api.reimpl.adrenaline",
    --"stat-api.reimpl.CrownOfLight",
    "stat-api.reimpl.redStew"
}
StatAPI.ReimplFunctions={
    redStew.RedStew,
    adrenaline.Adrenaline,
    heartBreak.HeartBreak,
}
StatAPI.RoomActives={
    COLLECTIBLE_RAZOR_BLADE={DAMAGE=1.2,type=CollectibleType.COLLECTIBLE_RAZOR_BLADE},
    COLLECTIBLE_BOOK_OF_BELIAL={DAMAGE=2,type=CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL},
    COLLECTIBLE_THE_NAIL={DAMAGE=2,type=CollectibleType.COLLECTIBLE_THE_NAIL},
    COLLECTIBLE_GOLDEN_RAZOR={DAMAGE=1.5,type=CollectibleType.COLLECTIBLE_GOLDEN_RAZOR},

}
for _, script in pairs(StatAPI.ReimplScripts) do
    include(script)
end
local function Evaluate()
 for i=0, Game():GetNumPlayers()-1 do
    local player = Game():GetPlayer(i)
    --print("hi")
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
    print("evaluated items")
 end
end
function StatAPI:Active(item,_,player)
    local utilRoomDamage = "PlayerRoomDamage" .. GetPlayerIndex(player)
    for i, collectible in pairs(StatAPI.RoomActives) do
        print(collectible)
        print(item)
        if item == collectible.type then
            StatAPI.T[utilRoomDamage] = (StatAPI.T[utilRoomDamage] or 0) + collectible.DAMAGE
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
StatAPI:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,StatAPI.EvaluateTotalDamage)
--StatAPI:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Evaluate)
StatAPI:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, StatAPI.Reset)
StatAPI:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, redStew.RedStewIncrease)