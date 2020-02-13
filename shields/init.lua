-- support for i18n
local S = armor_i18n.gettext

local disable_sounds = minetest.settings:get_bool("shields_disable_sounds")
local use_frame = minetest.get_modpath("frame")
local function play_sound_effect(player, name)
	if not disable_sounds and player then
		local pos = player:get_pos()
		if pos then
			minetest.sound_play(name, {
				pos = pos,
				max_hear_distance = 10,
				gain = 0.5,
			})
		end
	end
end

if minetest.global_exists("armor") and armor.elements then
	table.insert(armor.elements, "shield")
	local mult = armor.config.level_multiplier or 1
	armor.config.level_multiplier = mult * 0.9
end

-- Regisiter Shields

armor:register_armor("shields:shield_admin", {
	description = S("Admin Shield"),
	inventory_image = "shields_inv_shield_admin.png",
	groups = {armor_shield=1000, armor_heal=100, armor_use=0, not_in_creative_inventory=1},
})

minetest.register_alias("adminshield", "shields:shield_admin")

if armor.materials.wood then
	armor:register_armor("shields:shield_wood", {
		description = S("Wooden Shield"),
		inventory_image = "shields_inv_shield_wood.png",
		groups = {armor_shield=1, armor_heal=0, armor_use=2000, flammable=1},
		armor_groups = {fleshy=5},
		damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
		reciprocate_damage = true,
		on_damage = function(player, index, stack)
			play_sound_effect(player, "default_wood_footstep")
		end,
		on_destroy = function(player, index, stack)
			play_sound_effect(player, "default_wood_footstep")
		end,
	})
	armor:register_armor("shields:shield_enhanced_wood", {
		description = S("Enhanced Wood Shield"),
		inventory_image = "shields_inv_shield_enhanced_wood.png",
		groups = {armor_shield=1, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=8},
		damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=2},
		reciprocate_damage = true,
		on_damage = function(player, index, stack)
			play_sound_effect(player, "default_dig_metal")
		end,
		on_destroy = function(player, index, stack)
			play_sound_effect(player, "default_dug_metal")
		end,
	})
	minetest.register_craft({
		output = "shields:shield_enhanced_wood",
		recipe = {
			{"default:steel_ingot"},
			{"shields:shield_wood"},
			{"default:steel_ingot"},
		},
	})
end

if armor.materials.cactus then
	armor:register_armor("shields:shield_cactus", {
		description = S("Cactus Shield"),
		inventory_image = "shields_inv_shield_cactus.png",
		groups = {armor_shield=1, armor_heal=0, armor_use=1000},
		armor_groups = {fleshy=5},
		damage_groups = {cracky=3, snappy=3, choppy=2, crumbly=2, level=1},
		reciprocate_damage = true,
		on_damage = function(player, index, stack)
			play_sound_effect(player, "default_wood_footstep")
		end,
		on_destroy = function(player, index, stack)
			play_sound_effect(player, "default_wood_footstep")
		end,
	})
	armor:register_armor("shields:shield_enhanced_cactus", {
		description = S("Enhanced Cactus Shield"),
		inventory_image = "shields_inv_shield_enhanced_cactus.png",
		groups = {armor_shield=1, armor_heal=0, armor_use=1000},
		armor_groups = {fleshy=8},
		damage_groups = {cracky=3, snappy=3, choppy=2, crumbly=2, level=2},
		reciprocate_damage = true,
		on_damage = function(player, index, stack)
			play_sound_effect(player, "default_dig_metal")
		end,
		on_destroy = function(player, index, stack)
			play_sound_effect(player, "default_dug_metal")
		end,
	})
	minetest.register_craft({
		output = "shields:shield_enhanced_cactus",
		recipe = {
			{"default:steel_ingot"},
			{"shields:shield_cactus"},
			{"default:steel_ingot"},
		},
	})
end

if armor.materials.steel then
	armor:register_armor("shields:shield_steel", {
		description = S("Steel Shield"),
		inventory_image = "shields_inv_shield_steel.png",
		groups = {armor_shield=1, armor_heal=0, armor_use=800,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
		reciprocate_damage = true,
		on_damage = function(player, index, stack)
			play_sound_effect(player, "default_dig_metal")
		end,
		on_destroy = function(player, index, stack)
			play_sound_effect(player, "default_dug_metal")
		end,
	})
end

if armor.materials.bronze then
	armor:register_armor("shields:shield_bronze", {
		description = S("Bronze Shield"),
		inventory_image = "shields_inv_shield_bronze.png",
		groups = {armor_shield=1, armor_heal=6, armor_use=400,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
		reciprocate_damage = true,
		on_damage = function(player, index, stack)
			play_sound_effect(player, "default_dig_metal")
		end,
		on_destroy = function(player, index, stack)
			play_sound_effect(player, "default_dug_metal")
		end,
	})
end

if armor.materials.diamond then
	armor:register_armor("shields:shield_diamond", {
		description = S("Diamond Shield"),
		inventory_image = "shields_inv_shield_diamond.png",
		groups = {armor_shield=1, armor_heal=12, armor_use=200},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
		reciprocate_damage = true,
		on_damage = function(player, index, stack)
			play_sound_effect(player, "default_glass_footstep")
		end,
		on_destroy = function(player, index, stack)
			play_sound_effect(player, "default_break_glass")
		end,
	})
end

if armor.materials.gold then
	armor:register_armor("shields:shield_gold", {
		description = S("Gold Shield"),
		inventory_image = "shields_inv_shield_gold.png",
		groups = {armor_shield=1, armor_heal=6, armor_use=300,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
		reciprocate_damage = true,
		on_damage = function(player, index, stack)
			play_sound_effect(player, "default_dig_metal")
		end,
		on_destroy = function(player, index, stack)
			play_sound_effect(player, "default_dug_metal")
		end,
	})
end

if armor.materials.mithril then
	armor:register_armor("shields:shield_mithril", {
		description = S("Mithril Shield"),
		inventory_image = "shields_inv_shield_mithril.png",
		groups = {armor_shield=1, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, level=3},
		reciprocate_damage = true,
		on_damage = function(player, index, stack)
			play_sound_effect(player, "default_glass_footstep")
		end,
		on_destroy = function(player, index, stack)
			play_sound_effect(player, "default_break_glass")
		end,
	})
end

if armor.materials.crystal then
	armor:register_armor("shields:shield_crystal", {
		description = S("Crystal Shield"),
		inventory_image = "shields_inv_shield_crystal.png",
		groups = {armor_shield=1, armor_heal=12, armor_use=100, armor_fire=1},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, level=3},
		reciprocate_damage = true,
		on_damage = function(player, index, stack)
			play_sound_effect(player, "default_glass_footstep")
		end,
		on_destroy = function(player, index, stack)
			play_sound_effect(player, "default_break_glass")
		end,
	})
end

for k, v in pairs(armor.materials) do
	minetest.register_craft({
		output = "shields:shield_"..k,
		recipe = {
			{v, v, v},
			{v, v, v},
			{"", v, ""},
		},
	})
end

-- Add compatibility with frame
if use_frame then
	frame.register("shields:shield_admin")
	if armor.materials.wood then
		frame.register("shields:shield_enhanced_wood")
	end
	if armor.materials.cactus then
		frame.register("shields:shield_enhanced_cactus")
	end
	for k, v in pairs(armor.materials) do
		frame.register("shields:shield_"..k)
	end
end
