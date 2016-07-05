[mod] Visible Player Armor [3d_armor]
=====================================

Depends: default

Recommends: inventory_plus or unified_inventory (use only one)

Adds craftable armor that is visible to other players. Each armor item
contributes to the player's armor level making them less vulnerable to weapons.
Overall level is boosted by 10% when wearing a full matching set made from the
same base material.

Armor takes damage when a player is hurt but can offer a stackable chance of
restoring the lost health points.

Fire protection added by TenPlus1 when using  if Ethereal mod active,
level 1 crystal armor protects against torches, level 2 for crystal spike,
level 3 for fire, level 5 for lava.

Configuration
-------------

Armor can be configured by adding a file called armor.conf in the 3d_armor mod
and/or world directory. see armor.conf.example for all available options.

Note: worldpath config settings override settings made in the mod's directory.

Crafting
--------

Helmets:

+---+---+---+
| X | X | X |
+---+---+---+
| X |   | X |
+---+---+---+
|   |   |   |
+---+---+---+

[3d_armor:helmet_wood] X = [default:wood]
[3d_armor:helmet_cactus] X = [default:cactus]
[3d_armor:helmet_steel] X = [default:steel_ingot]
[3d_armor:helmet_bronze] X = [default:bronze_ingot]
[3d_armor:helmet_diamond] X = [default:diamond]
[3d_armor:helmet_gold] X = [default:gold_ingot]
[3d_armor:helmet_mithril] X = [moreores:mithril_ingot] *
[3d_armor:helmet_crystal] X = [ethereal:crystal_ingot] **

Chestplates:

+---+---+---+
| X |   | X |
+---+---+---+
| X | X | X |
+---+---+---+
| X | X | X |
+---+---+---+

[3d_armor:chestplate_wood] X = [default:wood]
[3d_armor:chestplate_cactus] X = [default:cactus]
[3d_armor:chestplate_steel] X = [default:steel_ingot]
[3d_armor:chestplate_bronze] X = [default:bronze_ingot]
[3d_armor:chestplate_diamond] X = [default:diamond]
[3d_armor:chestplate_gold] X = [default:gold_ingot]
[3d_armor:chestplate_mithril] X = [moreores:mithril_ingot] *
[3d_armor:chestplate_crystal] X = [ethereal:crystal_ingot] **

Leggings:

+---+---+---+
| X | X | X |
+---+---+---+
| X |   | X |
+---+---+---+
| X |   | X |
+---+---+---+

[3d_armor:leggings_wood] X = [default:wood]
[3d_armor:leggings_cactus] X = [default:cactus]
[3d_armor:leggings_steel] X = [default:steel_ingot]
[3d_armor:leggings_bronze] X = [default:bronze_ingot]
[3d_armor:leggings_diamond] X = [default:diamond]
[3d_armor:leggings_gold] X = [default:gold_ingot]
[3d_armor:leggings_mithril] X = [moreores:mithril_ingot] *
[3d_armor:leggings_crystal] X = [ethereal:crystal_ingot] **

Boots:

+---+---+---+
| X |   | X |
+---+---+---+
| X |   | X |
+---+---+---+

[3d_armor:boots_wood] X = [default:wood]
[3d_armor:boots_cactus] X = [default:cactus]
[3d_armor:boots_steel] X = [default:steel_ingot]
[3d_armor:boots_bronze] X = [default:bronze_ingot
[3d_armor:boots_diamond] X = [default:diamond]
[3d_armor:boots_gold] X = [default:gold_ingot]
[3d_armor:boots_mithril] X = [moreores:mithril_ingot] *
[3d_armor:boots_crystal] X = [ethereal:crystal_ingot] **

 * Requires moreores mod by Calinou
** Requires ethereal mod by Chinchow & TenPlus1

API
---

Armor Registration: See armor.lua, technic and shields mod for example usage.

minetest.register_tool("your_mod_name:speed_boots", {
	description = "Speed Boots",
	inventory_image = "your_mod_name_speed_boots_inv.png",
	texture = "your_mod_name_speed_boots.png",
	groups = {armor_feet=10, physics_speed=0.5, armor_use=2000},
	armor_groups = {fleshy=10, cracky=10, snappy=10, choppy=10, crumbly=10}
	on_destroy = function(player, item_name)
		minetest.sound_play("your_mod_name_break_sound", {
			to_player = player:get_player_name(),
		})
	end,
})

Default groups: Can be modified by dependent mods, eg. shields

	elements: armor_head, armor_torso, armor_legs, armor_feet
	attributes: armor_heal, armor_fire, armor_water
	physics: physics_jump, physics_speed, physics_gravity
	armor_groups: fleshy, cracky, snappy, choppy, crumbly
	durability: armor_use

Note: attributes and physics values are 'stackable', durability is determined
by the level of armor_use, total uses == approx (65535/armor_use), non-fleshy
damage groups need to be defined in the tool/weapon used against the player.

Item Callbacks:

on_equip = func(player, stack)
on_unequip = func(player, stack)
on_destroy = func(player, item_name)

Global callbacks:

armor:register_on_update(func(player))
armor:register_on_equip(func(player, stack))
armor:register_on_unequip(func(player, stack))
armor:register_on_destroy(func(player, item_name))

Depreciated functions: May be removed from future versions

armor:update_armor(player)
armor:update_player_visuals(player)

