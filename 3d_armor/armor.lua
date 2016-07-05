-- Boilerplate to support localized strings if intllib mod is installed.
local S = function(s) return s end
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
end

if ARMOR_MATERIALS.wood then
	minetest.register_tool("3d_armor:helmet_wood", {
		description = S("Wood Helmet"),
		inventory_image = "3d_armor_inv_helmet_wood.png",
		groups = {armor_head=5, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=5, cracky=5, snappy=3, choppy=2, crumbly=4},
	})
	minetest.register_tool("3d_armor:chestplate_wood", {
		description = S("Wood Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_wood.png",
		groups = {armor_torso=10, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=10, cracky=10, snappy=8, choppy=3, crumbly=4},
	})
	minetest.register_tool("3d_armor:leggings_wood", {
		description = S("Wood Leggings"),
		inventory_image = "3d_armor_inv_leggings_wood.png",
		groups = {armor_legs=5, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=5, cracky=5, snappy=3, choppy=2, crumbly=4},
	})
	minetest.register_tool("3d_armor:boots_wood", {
		description = S("Wood Boots"),
		inventory_image = "3d_armor_inv_boots_wood.png",
		groups = {armor_feet=5, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=5, cracky=5, snappy=3, choppy=2, crumbly=4},
	})
end

if ARMOR_MATERIALS.cactus then
	minetest.register_tool("3d_armor:helmet_cactus", {
		description = S("Cactus Helmet"),
		inventory_image = "3d_armor_inv_helmet_cactus.png",
		groups = {armor_head=5, armor_heal=0, armor_use=1000},
		armor_groups = {fleshy=5, cracky=4, snappy=2, choppy=2, crumbly=3},
	})
	minetest.register_tool("3d_armor:chestplate_cactus", {
		description = S("Cactus Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_cactus.png",
		groups = {armor_torso=10, armor_heal=0, armor_use=1000},
		armor_groups = {fleshy=10, cracky=8, snappy=3, choppy=3, crumbly=4},
	})
	minetest.register_tool("3d_armor:leggings_cactus", {
		description = S("Cactus Leggings"),
		inventory_image = "3d_armor_inv_leggings_cactus.png",
		groups = {armor_legs=5, armor_heal=0, armor_use=1000},
		armor_groups = {fleshy=5, cracky=4, snappy=2, choppy=2, crumbly=3},
	})
	minetest.register_tool("3d_armor:boots_cactus", {
		description = S("Cactus Boots"),
		inventory_image = "3d_armor_inv_boots_cactus.png",
		groups = {armor_feet=5, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=5, cracky=4, snappy=2, choppy=2, crumbly=3},
	})
end

if ARMOR_MATERIALS.steel then
	minetest.register_tool("3d_armor:helmet_steel", {
		description = S("Steel Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png",
		groups = {armor_head=10, armor_heal=0, armor_use=500},
		armor_groups = {fleshy=10, cracky=10, snappy=8, choppy=8, crumbly=10},
	})
	minetest.register_tool("3d_armor:chestplate_steel", {
		description = S("Steel Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png",
		groups = {armor_torso=15, armor_heal=0, armor_use=500},
		armor_groups = {fleshy=15, cracky=10, snappy=10, choppy=10, crumbly=15},
	})
	minetest.register_tool("3d_armor:leggings_steel", {
		description = S("Steel Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png",
		groups = {armor_legs=15, armor_heal=0, armor_use=500},
		armor_groups = {fleshy=15, cracky=10, snappy=10, choppy=10, crumbly=15},
	})
	minetest.register_tool("3d_armor:boots_steel", {
		description = S("Steel Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png",
		groups = {armor_feet=10, armor_heal=0, armor_use=500},
		armor_groups = {fleshy=10, cracky=10, snappy=8, choppy=8, crumbly=10},
	})
end

if ARMOR_MATERIALS.bronze then
	minetest.register_tool("3d_armor:helmet_bronze", {
		description = S("Bronze Helmet"),
		inventory_image = "3d_armor_inv_helmet_bronze.png",
		groups = {armor_head=10, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=10, cracky=8, snappy=8, choppy=10, crumbly=10},
	})
	minetest.register_tool("3d_armor:chestplate_bronze", {
		description = S("Bronze Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_bronze.png",
		groups = {armor_torso=15, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=15, cracky=10, snappy=10, choppy=15, crumbly=15},
	})
	minetest.register_tool("3d_armor:leggings_bronze", {
		description = S("Bronze Leggings"),
		inventory_image = "3d_armor_inv_leggings_bronze.png",
		groups = {armor_legs=15, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=15, cracky=10, snappy=10, choppy=15, crumbly=15},
	})
	minetest.register_tool("3d_armor:boots_bronze", {
		description = S("Bronze Boots"),
		inventory_image = "3d_armor_inv_boots_bronze.png",
		groups = {armor_feet=10, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=10, cracky=8, snappy=8, choppy=10, crumbly=10},
	})
end

if ARMOR_MATERIALS.gold then
	minetest.register_tool("3d_armor:helmet_gold", {
		description = S("Gold Helmet"),
		inventory_image = "3d_armor_inv_helmet_gold.png",
		groups = {armor_head=10, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=10, cracky=10, snappy=8, choppy=8, crumbly=8},
	})
	minetest.register_tool("3d_armor:chestplate_gold", {
		description = S("Gold Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_gold.png",
		groups = {armor_torso=15, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=15, cracky=15, snappy=10, choppy=10, crumbly=10},
	})
	minetest.register_tool("3d_armor:leggings_gold", {
		description = S("Gold Leggings"),
		inventory_image = "3d_armor_inv_leggings_gold.png",
		groups = {armor_legs=15, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=15, cracky=15, snappy=10, choppy=10, crumbly=10},
	})
	minetest.register_tool("3d_armor:boots_gold", {
		description = S("Gold Boots"),
		inventory_image = "3d_armor_inv_boots_gold.png",
		groups = {armor_feet=10, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=10, cracky=10, snappy=8, choppy=8, crumbly=8},
	})
end

if ARMOR_MATERIALS.diamond then
	minetest.register_tool("3d_armor:helmet_diamond", {
		description = S("Diamond Helmet"),
		inventory_image = "3d_armor_inv_helmet_diamond.png",
		groups = {armor_head=15, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15},
	})
	minetest.register_tool("3d_armor:chestplate_diamond", {
		description = S("Diamond Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_diamond.png",
		groups = {armor_torso=20, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20},
	})
	minetest.register_tool("3d_armor:leggings_diamond", {
		description = S("Diamond Leggings"),
		inventory_image = "3d_armor_inv_leggings_diamond.png",
		groups = {armor_legs=20, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20},
	})
	minetest.register_tool("3d_armor:boots_diamond", {
		description = S("Diamond Boots"),
		inventory_image = "3d_armor_inv_boots_diamond.png",
		groups = {armor_feet=15, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15},
	})
end

if ARMOR_MATERIALS.mithril then
	minetest.register_tool("3d_armor:helmet_mithril", {
		description = S("Mithril Helmet"),
		inventory_image = "3d_armor_inv_helmet_mithril.png",
		groups = {armor_head=15, armor_heal=12, armor_use=50},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15},
	})
	minetest.register_tool("3d_armor:chestplate_mithril", {
		description = S("Mithril Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_mithril.png",
		groups = {armor_torso=20, armor_heal=12, armor_use=50},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20},
	})
	minetest.register_tool("3d_armor:leggings_mithril", {
		description = S("Mithril Leggings"),
		inventory_image = "3d_armor_inv_leggings_mithril.png",
		groups = {armor_legs=20, armor_heal=12, armor_use=50},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20},
	})
	minetest.register_tool("3d_armor:boots_mithril", {
		description = S("Mithril Boots"),
		inventory_image = "3d_armor_inv_boots_mithril.png",
		groups = {armor_feet=15, armor_heal=12, armor_use=50},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15},
	})
end

if ARMOR_MATERIALS.crystal then
	minetest.register_tool("3d_armor:helmet_crystal", {
		description = S("Crystal Helmet"),
		inventory_image = "3d_armor_inv_helmet_crystal.png",
		groups = {armor_head=15, armor_heal=12, armor_use=50, armor_fire=1},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15},
	})
	minetest.register_tool("3d_armor:chestplate_crystal", {
		description = S("Crystal Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_crystal.png",
		groups = {armor_torso=20, armor_heal=12, armor_use=50, armor_fire=1},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20},
	})
	minetest.register_tool("3d_armor:leggings_crystal", {
		description = S("Crystal Leggings"),
		inventory_image = "3d_armor_inv_leggings_crystal.png",
		groups = {armor_legs=20, armor_heal=12, armor_use=50, armor_fire=1},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20},
	})
	minetest.register_tool("3d_armor:boots_crystal", {
		description = S("Crystal Boots"),
		inventory_image = "3d_armor_inv_boots_crystal.png",
		groups = {armor_feet=15, armor_heal=12, armor_use=50, physics_speed=1, physics_jump=0.5, armor_fire=1},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15},
	})
end

for k, v in pairs(ARMOR_MATERIALS) do
	minetest.register_craft({
		output = "3d_armor:helmet_"..k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{"", "", ""},
		},
	})
	minetest.register_craft({
		output = "3d_armor:chestplate_"..k,
		recipe = {
			{v, "", v},
			{v, v, v},
			{v, v, v},
		},
	})
	minetest.register_craft({
		output = "3d_armor:leggings_"..k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{v, "", v},
		},
	})
	minetest.register_craft({
		output = "3d_armor:boots_"..k,
		recipe = {
			{v, "", v},
			{v, "", v},
		},
	})
end

-- Admin Armor

minetest.register_tool("3d_armor:helmet_admin", {
	description = S("Admin Helmet"),
	inventory_image = "3d_armor_inv_helmet_admin.png",
	groups = {armor_head=1000, armor_heal=1000, armor_use=0, armor_water=1, not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

minetest.register_tool("3d_armor:chestplate_admin", {
	description = S("Admin Chestplate"),
	inventory_image = "3d_armor_inv_chestplate_admin.png",
	groups = {armor_torso=1000, armor_heal=1000, armor_use=0, not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

minetest.register_tool("3d_armor:leggings_admin", {
	description = S("Admin Leggings"),
	inventory_image = "3d_armor_inv_leggings_admin.png",
	groups = {armor_legs=1000, armor_heal=1000, armor_use=0, not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

minetest.register_tool("3d_armor:boots_admin", {
	description = S("Admin Boots"),
	inventory_image = "3d_armor_inv_boots_admin.png",
	groups = {armor_feet=1000, armor_heal=1000, armor_use=0, not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

minetest.register_alias("adminboots","3d_armor:boots_admin")
minetest.register_alias("adminhelmet","3d_armor:helmet_admin")
minetest.register_alias("adminchestplate","3d_armor:chestplate_admin")
minetest.register_alias("adminleggings","3d_armor:leggings_admin")

