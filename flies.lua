-- List of flies
local flies = {
	include("flies/red"),
	include("flies/soul"),
	include("flies/eternal"),
	include("flies/black"),
	include("flies/golden"),
	include("flies/bone"),
	include("flies/rotten"),
	include("flies/broken"),
	-- Make sure any fly types that are used by other heart types are registered first
	include("flies/halfRed"),
	include("flies/doubleRed"),
	include("flies/halfSoul"),
	include("flies/scared")
}

-- Handles fly orbiting
dukeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, f)
	local data = f:GetData()
	local sprite = f:GetSprite()
	if f.FrameCount == 6 then
		sprite:ReplaceSpritesheet(0, DukeHelpers.GetFlySpritesheet(f.SubType))
		sprite:LoadGraphics()
		sprite:Play("Idle", true)
	end
	if data.layer == DukeHelpers.INNER then
		f.OrbitDistance = Vector(20, 20)
		f.OrbitSpeed = 0.045
	elseif data.layer == DukeHelpers.MIDDLE then
		f.OrbitDistance = Vector(40, 36)
		f.OrbitSpeed = 0.02
		f.CollisionDamage = 3
	elseif data.layer == DukeHelpers.OUTER then
		f.OrbitDistance = Vector(60, 56)
		f.OrbitSpeed = 0.01
		f.CollisionDamage = 2
	end
	f.Velocity = f:GetOrbitPosition(f.Player.Position + f.Player.Velocity) - f.Position
end, DukeHelpers.FLY_VARIANT)

-- Turns heart flies into attack flies when hit
dukeMod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, f, e)
	if e.Type == EntityType.ENTITY_PROJECTILE and not e:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
        e:Die()
		if DukeHelpers.CanBecomeAttackFly(f) then
			local fly = DukeHelpers.SpawnAttackFly(f)
			fly:GetData().attacker = e.SpawnerEntity
			DukeHelpers.RemoveHeartFly(f)
		end
    end
end, DukeHelpers.FLY_VARIANT)

-- Handles attacking an enemy when attack fly
dukeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, f)
	if f:GetData().attacker then
		if not f:GetData().attacker:IsDead() then
			f.Target = f:GetData().attacker
		else
			f.Target = nil
			f:GetData().attacker = nil
		end
	end
end, FamiliarVariant.BLUE_FLY)

-- Registers the flies
for _, fly in pairs(flies) do
	local newFly = {
        key = fly.key,
        spritesheet = fly.spritesheet,
        canAttack = fly.canAttack,
        pickupSubType = fly.subType,
        heartFlySubType = fly.subType,
        attackFlySubType = DukeHelpers.GetAttackFlySubTypeBySubType(fly.subType),
    	fliesCount = fly.fliesCount
    }

	if fly.useFly then
		local existingFly = DukeHelpers.Flies[fly.useFly]
		newFly.spritesheet = existingFly.spritesheet
		newFly.canAttack = existingFly.canAttack
		newFly.heartFlySubType = existingFly.heartFlySubType
		newFly.attackFlySubType = existingFly.attackFlySubType
	end

    if fly.callbacks then
        for _, callback in pairs(fly.callbacks) do
            dukeMod:AddCallback(table.unpack(callback))
        end
    end

    DukeHelpers.Flies[fly.key] = newFly
end