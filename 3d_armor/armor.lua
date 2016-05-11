if ARMOR_MATERIALS.wood then
	minetest.register_tool("3d_armor:helmet_wood", {
		description = "Wood Helmet",
		inventory_image = "3d_armor_inv_helmet_wood.png",
		groups = {armor_head=1, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=5, cracky=5, snappy=3, choppy=2, crumbly=4}
	})
	minetest.register_tool("3d_armor:chestplate_wood", {
		description = "Wood Chestplate",
		inventory_image = "3d_armor_inv_chestplate_wood.png",
		groups = {armor_torso=1, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=10, cracky=10, snappy=8, choppy=3, crumbly=4}
	})
	minetest.register_tool("3d_armor:leggings_wood", {
		description = "Wood Leggings",
		inventory_image = "3d_armor_inv_leggings_wood.png",
		groups = {armor_legs=1, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=5, cracky=5, snappy=3, choppy=2, crumbly=4}
	})
	minetest.register_tool("3d_armor:boots_wood", {
		description = "Wood Boots",
		inventory_image = "3d_armor_inv_boots_wood.png",
		groups = {armor_feet=1, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=5, cracky=5, snappy=3, choppy=2, crumbly=4}
	})
end

if ARMOR_MATERIALS.cactus then
	minetest.register_tool("3d_armor:helmet_cactus", {
		description = "Cactuc Helmet",
		inventory_image = "3d_armor_inv_helmet_cactus.png",
		groups = {armor_head=1, armor_heal=0, armor_use=1000},
		armor_groups = {fleshy=5, cracky=4, snappy=2, choppy=2, crumbly=3}
	})
	minetest.register_tool("3d_armor:chestplate_cactus", {
		description = "Cactus Chestplate",
		inventory_image = "3d_armor_inv_chestplate_cactus.png",
		groups = {armor_torso=1, armor_heal=0, armor_use=1000},
		armor_groups = {fleshy=10, cracky=8, snappy=3, choppy=3, crumbly=4}
	})
	minetest.register_tool("3d_armor:leggings_cactus", {
		description = "Cactus Leggings",
		inventory_image = "3d_armor_inv_leggings_cactus.png",
		groups = {armor_legs=1, armor_heal=0, armor_use=1000},
		armor_groups = {fleshy=5, cracky=4, snappy=2, choppy=2, crumbly=3}
	})
	minetest.register_tool("3d_armor:boots_cactus", {
		description = "Cactus Boots",
		inventory_image = "3d_armor_inv_boots_cactus.png",
		groups = {armor_feet=1, armor_heal=0, armor_use=2000},
		armor_groups = {fleshy=5, cracky=4, snappy=2, choppy=2, crumbly=3}
	})
end

if ARMOR_MATERIALS.steel then
	minetest.register_tool("3d_armor:helmet_steel", {
		description = "Steel Helmet",
		inventory_image = "3d_armor_inv_helmet_steel.png",
		groups = {armor_head=1, armor_heal=0, armor_use=500},
		armor_groups = {fleshy=10, cracky=10, snappy=8, choppy=8, crumbly=10}
	})
	minetest.register_tool("3d_armor:chestplate_steel", {
		description = "Steel Chestplate",
		inventory_image = "3d_armor_inv_chestplate_steel.png",
		groups = {armor_torso=1, armor_heal=0, armor_use=500},
		armor_groups = {fleshy=15, cracky=10, snappy=10, choppy=10, crumbly=15}
	})
	minetest.register_tool("3d_armor:leggings_steel", {
		description = "Steel Leggings",
		inventory_image = "3d_armor_inv_leggings_steel.png",
		groups = {armor_legs=1, armor_heal=0, armor_use=500},
		armor_groups = {fleshy=15, cracky=10, snappy=10, choppy=10, crumbly=15}
	})
	minetest.register_tool("3d_armor:boots_steel", {
		description = "Steel Boots",
		inventory_image = "3d_armor_inv_boots_steel.png",
		groups = {armor_feet=1, armor_heal=0, armor_use=500},
		armor_groups = {fleshy=10, cracky=10, snappy=8, choppy=8, crumbly=10}
	})
end

if ARMOR_MATERIALS.bronze then
	minetest.register_tool("3d_armor:helmet_bronze", {
		description = "Bronze Helmet",
		inventory_image = "3d_armor_inv_helmet_bronze.png",
		groups = {armor_head=1, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=10, cracky=8, snappy=8, choppy=10, crumbly=10}
	})
	minetest.register_tool("3d_armor:chestplate_bronze", {
		description = "Bronze Chestplate",
		inventory_image = "3d_armor_inv_chestplate_bronze.png",
		groups = {armor_torso=1, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=15, cracky=10, snappy=10, choppy=15, crumbly=15}
	})
	minetest.register_tool("3d_armor:leggings_bronze", {
		description = "Bronze Leggings",
		inventory_image = "3d_armor_inv_leggings_bronze.png",
		groups = {armor_legs=1, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=15, cracky=10, snappy=10, choppy=15, crumbly=15}
	})
	minetest.register_tool("3d_armor:boots_bronze", {
		description = "Bronze Boots",
		inventory_image = "3d_armor_inv_boots_bronze.png",
		groups = {armor_feet=1, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=10, cracky=8, snappy=8, choppy=10, crumbly=10}
	})
end

if ARMOR_MATERIALS.diamond then
	minetest.register_tool("3d_armor:helmet_diamond", {
		description = "Diamond Helmet",
		inventory_image = "3d_armor_inv_helmet_diamond.png",
		groups = {armor_head=1, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15}
	})
	minetest.register_tool("3d_armor:chestplate_diamond", {
		description = "Diamond Chestplate",
		inventory_image = "3d_armor_inv_chestplate_diamond.png",
		groups = {armor_torso=1, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20}
	})
	minetest.register_tool("3d_armor:leggings_diamond", {
		description = "Diamond Leggings",
		inventory_image = "3d_armor_inv_leggings_diamond.png",
		groups = {armor_legs=1, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20}
	})
	minetest.register_tool("3d_armor:boots_diamond", {
		description = "Diamond Boots",
		inventory_image = "3d_armor_inv_boots_diamond.png",
		groups = {armor_feet=1, armor_heal=12, armor_use=100},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15}
	})
end

if ARMOR_MATERIALS.gold then
	minetest.register_tool("3d_armor:helmet_gold", {
		description = "Gold Helmet",
		inventory_image = "3d_armor_inv_helmet_gold.png",
		groups = {armor_head=1, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=10, cracky=10, snappy=8, choppy=8, crumbly=8}
	})
	minetest.register_tool("3d_armor:chestplate_gold", {
		description = "Gold Chestplate",
		inventory_image = "3d_armor_inv_chestplate_gold.png",
		groups = {armor_torso=1, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=15, cracky=15, snappy=10, choppy=10, crumbly=10}
	})
	minetest.register_tool("3d_armor:leggings_gold", {
		description = "Gold Leggings",
		inventory_image = "3d_armor_inv_leggings_gold.png",
		groups = {armor_legs=1, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=15, cracky=15, snappy=10, choppy=10, crumbly=10}
	})
	minetest.register_tool("3d_armor:boots_gold", {
		description = "Gold Boots",
		inventory_image = "3d_armor_inv_boots_gold.png",
		groups = {armor_feet=1, armor_heal=6, armor_use=250},
		armor_groups = {fleshy=10, cracky=10, snappy=8, choppy=8, crumbly=8}
	})
end

if ARMOR_MATERIALS.mithril then
	minetest.register_tool("3d_armor:helmet_mithril", {
		description = "Mithril Helmet",
		inventory_image = "3d_armor_inv_helmet_mithril.png",
		groups = {armor_head=1, armor_heal=12, armor_use=50},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15}
	})
	minetest.register_tool("3d_armor:chestplate_mithril", {
		description = "Mithril Chestplate",
		inventory_image = "3d_armor_inv_chestplate_mithril.png",
		groups = {armor_torso=1, armor_heal=12, armor_use=50},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20}
	})
	minetest.register_tool("3d_armor:leggings_mithril", {
		description = "Mithril Leggings",
		inventory_image = "3d_armor_inv_leggings_mithril.png",
		groups = {armor_legs=1, armor_heal=12, armor_use=50},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20}
	})
	minetest.register_tool("3d_armor:boots_mithril", {
		description = "Mithril Boots",
		inventory_image = "3d_armor_inv_boots_mithril.png",
		groups = {armor_feet=1, armor_heal=12, armor_use=50},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15}
	})
end

if ARMOR_MATERIALS.crystal then
	minetest.register_tool("3d_armor:helmet_crystal", {
		description = "Crystal Helmet",
		inventory_image = "3d_armor_inv_helmet_crystal.png",
		groups = {armor_head=1, armor_heal=12, armor_use=50, armor_fire=1},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15}
	})
	minetest.register_tool("3d_armor:chestplate_crystal", {
		description = "Crystal Chestplate",
		inventory_image = "3d_armor_inv_chestplate_crystal.png",
		groups = {armor_torso=1, armor_heal=12, armor_use=50, armor_fire=1},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20}
	})
	minetest.register_tool("3d_armor:leggings_crystal", {
		description = "Crystal Leggings",
		inventory_image = "3d_armor_inv_leggings_crystal.png",
		groups = {armor_legs=1, armor_heal=12, armor_use=50, armor_fire=1},
		armor_groups = {fleshy=20, cracky=15, snappy=20, choppy=20, crumbly=20}
	})
	minetest.register_tool("3d_armor:boots_crystal", {
		description = "Crystal Boots",
		inventory_image = "3d_armor_inv_boots_crystal.png",
		groups = {armor_feet=1, armor_heal=12, armor_use=50, physics_speed=1, physics_jump=0.5, armor_fire=1},
		armor_groups = {fleshy=15, cracky=10, snappy=15, choppy=15, crumbly=15}
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
	description = "Admin Helmet",
	inventory_image = "3d_armor_inv_helmet_admin.png",
	groups = {armor_head=1000, armor_heal=1000, armor_use=0, armor_water=1, not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

minetest.register_tool("3d_armor:chestplate_admin", {
	description = "Admin Chestplate",
	inventory_image = "3d_armor_inv_chestplate_admin.png",
	groups = {armor_torso=1000, armor_heal=1000, armor_use=0, not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

minetest.register_tool("3d_armor:leggings_admin", {
	description = "Admin Leggings",
	inventory_image = "3d_armor_inv_leggings_admin.png",
	groups = {armor_legs=1000, armor_heal=1000, armor_use=0, not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

minetest.register_tool("3d_armor:boots_admin", {
	description = "Admin Boots",
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

