-- support for i18n
local S = armor_i18n.gettext

if not minetest.get_modpath("technic") then
	minetest.log("warning", S("hazmat_suit: Mod loaded but unused."))
	return
end

minetest.register_craftitem("hazmat_suit:helmet_hazmat", {
		description = S("Hazmat Helmet"),
		inventory_image = "hazmat_suit_inv_helmet_hazmat.png",
		stack_max = 1,
})

minetest.register_craftitem("hazmat_suit:chestplate_hazmat", {
		description = S("Hazmat Chestplate"),
		inventory_image = "hazmat_suit_inv_chestplate_hazmat.png",
		stack_max = 1,
})

minetest.register_craftitem("hazmat_suit:sleeve_hazmat", {
		description = S("Hazmat Sleeve"),
		inventory_image = "hazmat_suit_inv_sleeve_hazmat.png",
		stack_max = 1,
})

minetest.register_craftitem("hazmat_suit:leggings_hazmat", {
		description = S("Hazmat Leggins"),
		inventory_image = "hazmat_suit_inv_leggings_hazmat.png",
		stack_max = 1,
})

minetest.register_craftitem("hazmat_suit:boots_hazmat", {
		description = S("Hazmat Boots"),
		inventory_image = "hazmat_suit_inv_boots_hazmat.png",
		stack_max = 1,
})

armor:register_armor("hazmat_suit:suit_hazmat", {
	description = S("Hazmat Suit"),
	inventory_image = "hazmat_suit_inv_suit_hazmat.png",
	groups = {armor_head=1, armor_torso=1, armor_legs=1, armor_feet=1,
		armor_heal=20, armor_fire=4, armor_water=1, armor_use=1000,
		physics_jump=-0.1, physics_speed=-0.2, physics_gravity=0.1},
	armor_groups = {fleshy=35, radiation=50},
	damage_groups = {cracky=3, snappy=3, choppy=2, crumbly=2, level=1},
})

minetest.register_craft({
	output = "hazmat_suit:helmet_hazmat",
	recipe = {
		{"", "technic:stainless_steel_ingot", ""},
		{"technic:stainless_steel_ingot", "default:glass", "technic:stainless_steel_ingot"},
		{"technic:rubber", "technic:rubber", "technic:rubber"},
	},
})

minetest.register_craft({
	output = "hazmat_suit:chestplate_hazmat",
	recipe = {
		{"technic:lead_ingot", "dye:yellow", "technic:lead_ingot"},
		{"technic:stainless_steel_ingot", "technic:lead_ingot", "technic:stainless_steel_ingot"},
		{"technic:lead_ingot", "technic:stainless_steel_ingot", "technic:lead_ingot"},
	},
})

minetest.register_craft({
	output = "hazmat_suit:sleeve_hazmat",
	recipe = {
		{"technic:rubber", "dye:yellow"},
		{"", "technic:stainless_steel_ingot"},
		{"", "technic:rubber"},
	},
})

minetest.register_craft({
	output = "hazmat_suit:leggings_hazmat",
	recipe = {
		{"technic:rubber", "technic:lead_ingot", "technic:rubber"},
		{"technic:stainless_steel_ingot", "technic:rubber", "technic:stainless_steel_ingot"},
		{"technic:lead_ingot", "", "technic:lead_ingot"},
	},
})

minetest.register_craft({
	output = "hazmat_suit:boots_hazmat",
	recipe = {
		{"", "", ""},
		{"technic:rubber", "", "technic:rubber"},
		{"technic:stainless_steel_ingot", "", "technic:stainless_steel_ingot"},
	},
})

minetest.register_craft({
	output = "hazmat_suit:suit_hazmat",
	type = "shapeless",
	recipe = {
		"hazmat_suit:helmet_hazmat",
		"hazmat_suit:chestplate_hazmat",
		"hazmat_suit:leggings_hazmat",
		"hazmat_suit:boots_hazmat",
		"hazmat_suit:sleeve_hazmat",
		"hazmat_suit:sleeve_hazmat",
	},
})
