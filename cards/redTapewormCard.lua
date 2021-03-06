local Names = {
    en_us = "Red Tapeworm Card",
    spa = "Tarjeta de Tenia Roja"
}
local Name = Names.en_us
local Tag = "redTapewormCard"
local Id = Isaac.GetCardIdByName(Name)
local Descriptions = {
    en_us = "Fires 10 consecutive Rotten Gullet shots of a random type, firing rings of eight tears that have a 50% chance of spawning Heart Spiders on collision",
    spa = "Red go grrrr"
}
local WikiDescription = DukeHelpers.GenerateEncyclopediaPage({
    {
        "Effects",
        "On use, fires 10 consecutive Rotten Gullet shots of a random type, firing rings of eight tears that have a 50% chance of spawning Heart Spiders on collision."
    }
})

local function MC_USE_CARD(_, card, player, flags)
    if DukeHelpers.Cards.redTapewormCard.IsUnlocked() then
        DukeHelpers.GetDukeData(player)[Tag] = 1
    end
end

local function MC_POST_PEFFECT_UPDATE(_, player)
    if DukeHelpers.GetDukeData(player)[Tag] then
        DukeHelpers.Stagger(Tag, player, 15, 10, function()
            DukeHelpers.Items.rottenGullet.helpers.fireRottenGulletShot(player,
                DukeHelpers.GetWeightedSpider(player:GetCardRNG(Id)).key, player:GetCardRNG(Id))
            player:AnimateCard(Id)
        end)
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
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
        {
            ModCallbacks.MC_POST_PEFFECT_UPDATE,
            MC_POST_PEFFECT_UPDATE
        }
    },
    unlock = DukeHelpers.GetUnlock(DukeHelpers.Unlocks.GREEDIER, Tag, DukeHelpers.HUSK_NAME)
}
