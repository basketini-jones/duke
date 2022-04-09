local key = "FLY_ETERNAL"
local subType = HeartSubType.HEART_ETERNAL
local attackFlySubType = DukeHelpers.GetAttackFlySubTypeBySubType(subType)

local function MC_FAMILIAR_UPDATE(_, f)
	if f.SubType == subType then
		if f.FrameCount == 6 then
			DukeHelpers.ForEachEntityInRoom(function(entity)
				for i=1, 4 do
					DukeHelpers.AddHeartFly(f.SpawnerEntity, DukeHelpers.Flies.FLY_RED)
					DukeHelpers.RemoveHeartFly(entity)
					DukeHelpers.RemoveHeartFly(f)
				end
			end, EntityType.ENTITY_FAMILIAR, DukeHelpers.FLY_VARIANT, subType,
			function(entity)
				return entity.SpawnerEntity.InitSeed == f.SpawnerEntity.InitSeed and entity.InitSeed ~= f.InitSeed
			end)
		end
		f.CollisionDamage = f.CollisionDamage * 1.5
	end
end

return {
    key = key,
    spritesheet = "gfx/familiars/eternal_heart_fly.png",
    canAttack = false,
    subType = subType,
    fliesCount = 1,
	poofColor = Color(0.62, 0.62, 0.62, 1, 0.78, 0.78, 0.78),
	sacAltarQuality = 6,
    sfx = SoundEffect.SOUND_SUPERHOLY,
    callbacks = {
        {
            ModCallbacks.MC_FAMILIAR_UPDATE,
            MC_FAMILIAR_UPDATE,
            DukeHelpers.FLY_VARIANT
        }
    }
}
