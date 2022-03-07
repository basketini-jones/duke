dukeMod = RegisterMod("Duke", 1)

DukeHelpers = {
	DUKE_ID = Isaac.GetPlayerTypeByName("Duke"),
	rng = RNG(),
	sfx = SFXManager(),
	PRICE_OFFSET = -50,
	floorDevilDealChance = nil
}

-- Sets the RNG seed for the run
dukeMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	local seeds = Game():GetSeeds()
	DukeHelpers.rng:SetSeed(seeds:GetStartSeed(), 35)
end)

-- Resets the floor devil deal randomness on new floor
dukeMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	DukeHelpers.floorDevilDealChance = nil
end)

-- Helpers
include("helpers/utils")
include("helpers/flies")

-- Initialize player and flies
include("flies")
include("duke")

DukeHelpers.Items = {
	dukesGullet = include("items/dukesGullet"),
	othersGullet = include("items/othersGullet")
}

-- Initialize prices
DukeHelpers.Prices = {
	PRICE_ONE_HEART = {
		price = DukeHelpers.PRICE_OFFSET + PickupPrice.PRICE_ONE_HEART
	},
	PRICE_TWO_HEARTS = {
		price = DukeHelpers.PRICE_OFFSET + PickupPrice.PRICE_TWO_HEARTS
	},
	PRICE_THREE_SOULHEARTS = {
		price = DukeHelpers.PRICE_OFFSET + PickupPrice.PRICE_THREE_SOULHEARTS
	},
	PRICE_ONE_HEART_AND_TWO_SOULHEARTS = {
		price = DukeHelpers.PRICE_OFFSET + PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
	},
}

for _, item in pairs(DukeHelpers.Items) do
    if item.callbacks then
        for _, callback in pairs(item.callbacks) do
            dukeMod:AddCallback(table.unpack(callback))
        end
    end

	-- helper.AddExternalItemDescriptionItem(item)

	-- if Encyclopedia and item.WikiDescription then
	-- 	Encyclopedia.AddItem({
	-- 		Class = "Loot Deck",
	-- 		ID = item.Id,
	-- 		WikiDesc = item.WikiDescription,
	-- 		ModName = "Loot Deck"
	-- 	})
	-- end

	-- if AnimatedItemsAPI then
	-- 	AnimatedItemsAPI:SetAnimationForCollectible(item.Id, "items/collectibles/animated/".. item.Tag .. "Animated.anm2")
	-- end
end
