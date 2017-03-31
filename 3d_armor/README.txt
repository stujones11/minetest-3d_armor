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

-- You can use this to increase or decrease overall armor radiation protection,
-- eg: armor_radiation_multiplier = 0 will completely disable radiation protection.
armor_radiation_multiplier = 1

-- Enable water protection (periodically restores breath when activated)
armor_water_protect = true

-- Enable fire protection (defaults true if using ethereal mod)
armor_fire_protect = false

API
---

Armor Registration:

armor:register_armor(name, def)
armor:register_armor_group(group, base)

Example:

armor:register_armor_group("radiation", 100)

armor:register_armor("mod_name:speed_boots", {
	description = "Speed Boots",
	inventory_image = "mod_name_speed_boots_inv.png",
	texture = "mod_name_speed_boots.png",
	preview = "mod_name_speed_boots_preview.png",
	armor_groups = {fleshy=10, radiation=10},
	groups = {armor_feet=1, physics_speed=0.5, armor_use=2000},
	on_destroy = function(player, item_name)
		minetest.sound_play("mod_name_break_sound", {
			to_player = player:get_player_name(),
		})
	end,
})

See armor.lua, technic_armor and shields mods for more examples.

Default groups:

Elements: armor_head, armor_torso, armor_legs, armor_feet
attributes: armor_heal, armor_fire, armor_water
Physics: physics_jump, physics_speed, physics_gravity
Durability: armor_use

Notes:

Elements may be modified by dependent mods, eg shields adds armor_shield.
Attributes and physics values are 'stackable', durability is determined
by the level of armor_use, total uses == approx (65535/armor_use), non-fleshy
damage groups need to be defined in the tool/weapon used against the player

Item Callbacks:

on_equip = func(player, stack)
on_unequip = func(player, stack)
on_destroy = func(player, stack)

Global Callbacks:

armor:register_on_update(func(player))
armor:register_on_equip(ifunc(player, stack))
armor:register_on_unequip(func(player, stack))
armor:register_on_destroy(func(player, stack))

Global Callback Example:

armor:register_on_update(function(player)
	print(player:get_player_name().." armor updated!")
end)

