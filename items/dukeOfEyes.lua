local Names = {
    en_us = "Duke of Eyes",
    spa = "Duque no Eyeballos"
}
local Name = Names.en_us
local Tag = "dukeOfEyes"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "Poops and shits everywhere",
    spa = "Caca y mierda por todos lados"
}
local WikiDescription = DukeHelpers.GenerateEncyclopediaPage("Poops and shits everywhere.")

local function GetSpriteSheetDirection(tear)
    local spriteSheetDirection
    local sprite = tear:GetSprite()
    if math.abs(tear.Velocity.X) > math.abs(tear.Velocity.Y) then
        spriteSheetDirection = "side"
        if tear.Velocity.X < 0 then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
    elseif math.abs(tear.Velocity.Y) > math.abs(tear.Velocity.X) then
        if tear.Velocity.Y < 0 then
            spriteSheetDirection = "back"
        else
            spriteSheetDirection = "front"
        end
    end
    return spriteSheetDirection
end

local function MC_POST_FIRE_TEAR(_, tear)
    local player = tear:GetLastParent():ToPlayer()

    if player:HasCollectible(Id) then
        if DukeHelpers.PercentageChance(player.Luck * 5 + 5, 50) then
            tear:GetData()[Tag] = true

            local sprite = tear:GetSprite()
            local spriteSheetDirection = GetSpriteSheetDirection(tear)

            if not tear:HasTearFlags(DukeHelpers.ConvertBitSet64ToBitSet128(77)) then
                local animationToPlay = sprite:GetAnimation()

                sprite:Load("gfx/tears/dukeOfEyesTear.anm2", true)
                sprite:Play(animationToPlay, true)
            end
        end
    end
end

local function MC_PRE_TEAR_COLLISION(_, tear, collider)
    local player = tear:GetLastParent():ToPlayer()

    if DukeHelpers.IsActualEnemy(collider) and tear:GetData()[Tag] then
        local amount = DukeHelpers.PercentageChance(50) and 1 or 2
        if DukeHelpers.PercentageChance(50) then
            DukeHelpers.SpawnAttackFlyBySubType(DukeHelpers.GetWeightedFly(DukeHelpers.rng).heartFlySubType, player.Position, player)
        else
            DukeHelpers.SpawnSpidersFromPickupSubType(DukeHelpers.GetWeightedSpider(DukeHelpers.rng).pickupSubType,
                player.Position, player, amount, true)
        end
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
    Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_PRE_TEAR_COLLISION,
            MC_PRE_TEAR_COLLISION
        },
        {
            ModCallbacks.MC_POST_FIRE_TEAR,
            MC_POST_FIRE_TEAR
        }
    }
}
