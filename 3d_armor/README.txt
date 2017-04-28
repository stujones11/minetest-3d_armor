[mod] Visible Player Armor [3d_armor]
=====================================

Depends: default

Recommends: sfinv, unified_inventory or smart_inventory (use only one to avoid conflicts)

Supports: player_monoids and armor_monoid

Adds craftable armor that is visible to other players. Each armor item worn contributes to
a player's armor group level making them less vulnerable to weapons.

Armor takes damage when a player is hurt but also offers a percentage chance of healing.
Overall level is boosted by 10% when wearing a full matching set.

Fire protection added by TenPlus1 when using crystal armor if Ethereal mod active, level 1
protects against torches, level 2 for crystal spike, level 3 for fire, level 5 for lava.

Armor Configuration
-------------------

Override the following default settings by adding them to your minetest.conf file.

-- Set false to disable individual armor materials.
armor_material_wood = true
armor_material_cactus = true
armor_material_steel = true
armor_material_bronze = true
armor_material_diamond = true
armor_material_gold = true
armor_material_mithril = true
armor_material_crystal = true

-- Increase this if you get initialization glitches when a player first joins.
armor_init_delay = 1

-- Number of initialization attempts.
-- Use in conjunction with armor_init_delay if initialization problems persist.
armor_init_times = 1

-- Increase this if armor is not getting into bones due to server lag.
armor_bones_delay = 1

-- How often player armor items are updated.
armor_update_time = 1

-- Drop armor when a player dies.
-- Uses bones mod if present, otherwise items are dropped around the player.
armor_drop = true

-- Pulverise armor when a player dies, overrides armor_drop.
armor_destroy = false

-- You can use this to increase or decrease overall armor effectiveness,
-- eg: level_multiplier = 0.5 will reduce armor level by half.
armor_level_multiplier = 1

-- You can use this to increase or decrease overall armor healing,
-- eg: armor_heal_multiplier = 0 will disable healing altogether.
armor_heal_multiplier = 1

-- Enable water protection (periodically restores breath when activated)
armor_water_protect = true

-- Enable fire protection (defaults true if using ethereal mod)
armor_fire_protect = false

-- Enable punch damage effects.
armor_punch_damage = true

API
---

Armor Registration:

armor:register_armor(name, def)

Wrapper function for `minetest.register_tool`, while registering armor as
a tool item is still supported, this may be deprecated in future so new code
should use this method.

Additional fields supported by 3d_armor:

	texture = <filename>
	preview = <filename>
	armor_groups = <table>
	damage_groups = <table>
	reciprocate_damage = <bool>
	on_equip = <function>
	on_unequip = <function>
	on_destroy = <function>
	on_damage = <function>
	on_punched = <function>

armor:register_armor_group(group, base)

Example:

armor:register_armor_group("radiation", 100)

armor:register_armor("mod_name:speed_boots", {
	description = "Speed Boots",
	inventory_image = "mod_name_speed_boots_inv.png",
	texture = "mod_name_speed_boots.png",
	preview = "mod_name_speed_boots_preview.png",
	groups = {armor_feet=1, armor_use=500, physics_speed=1.2, flammable=1},
	armor_groups = {fleshy=10, radiation=10},
	damage_groups = {cracky=3, snappy=3, choppy=3, crumbly=3, level=1},
	reciprocate_damage = true,
	on_destroy = function(player, index, stack)
		local pos = player:getpos()
		if pos then
			minetest.sound_play({
				name = "mod_name_break_sound",
				pos = pos,
				gain = 0.5,
			})
		end
	end,
})

See armor.lua, technic_armor and shields mods for more examples.

Default groups:

Elements: armor_head, armor_torso, armor_legs, armor_feet
Attributes: armor_heal, armor_fire, armor_water
Physics: physics_jump, physics_speed, physics_gravity
Durability: armor_use, flammable

Notes:

Elements may be modified by dependent mods, eg shields adds armor_shield.
Attributes and physics values are 'stackable', durability is determined
by the level of armor_use, total uses == approx (65535/armor_use), non-fleshy
damage groups need to be defined in the tool/weapon used against the player.

Reciprocal tool damage will be done only by the first armor inventory item
 with `reciprocate_damage = true`

Armor Functions:

armor:set_player_armor(player)

Primarily an internal function but can be called externally to apply any
changes that might not otherwise get handled.

armor:punch(player, hitter, time_from_last_punch, tool_capabilities)

Used to apply damage to all equipped armor based on the damage groups of
each individual item.`hitter`, `time_from_last_punch` and `tool_capabilities`
are optional but should be valid if included.

armor:damage(player, index, stack, use)

Adds wear to a single armor itemstack, triggers `on_damage` callbacks and
updates the necessary inventories. Also handles item destruction callbacks
and so should NOT be called from `on_unequip` to avoid an infinite loop.

Item Callbacks:

on_equip = func(player, index, stack)
on_unequip = func(player, index, stack)
on_destroy = func(player, index, stack)
on_damage = func(player, index, stack)
on_punched = func(player, hitter, time_from_last_punch, tool_capabilities)

Notes:

`on_punched` is called every time a player is punched or takes damage, `hitter`,
`time_from_last_punch` and `tool_capabilities` can be `nil` and will be in the
case of fall damage, etc. When fire protection is enabled, hitter == "fire"
in the event of fire damage. Return `false` to override armor damage effects.
When armor is destroyed `stack` will contain a copy of the previous stack.

Global Callbacks:

armor:register_on_update(func(player))
armor:register_on_equip(func(player, index, stack))
armor:register_on_unequip(func(player, index, stack))
armor:register_on_destroy(func(player, index, stack))

Global Callback Example:

armor:register_on_update(function(player)
	print(player:get_player_name().." armor updated!")
end)

