local Names = {
    en_us = "Lil Duke",
    spa = "Duque Pequeño"
}
local Name = Names.en_us
local Tag = "lilDuke"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "Poops and shits everywhere",
    spa = "Caca y mierda por todos lados"
}
local WikiDescription = DukeHelpers.GenerateEncyclopediaPage("Poops and shits everywhere.")

local function MC_EVALUATE_CACHE(_, player, flag)
    if flag == CacheFlag.CACHE_FAMILIARS then
        local familiarAmount = player:GetCollectibleNum(Id) + player:GetEffects():GetCollectibleEffectNum(Id)
        local itemConfig = Isaac.GetItemConfig():GetCollectible(Id)

        local rng = RNG()
        rng:SetSeed(Random(), 1)

        player:CheckFamiliar(DukeHelpers.EntityVariants.lilDuke.Id, familiarAmount, rng, itemConfig)
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
            ModCallbacks.MC_EVALUATE_CACHE,
            MC_EVALUATE_CACHE
        }
    },
    unlock = DukeHelpers.GetUnlock(DukeHelpers.Unlocks.BOSS_RUSH, Tag, DukeHelpers.DUKE_ID)
}
