
-- Override moreores weapons (make them more powerful)

minetest.register_tool(":moreores:sword_bronze", {
	description = "Bronze Sword",
	inventory_image = "moreores_tool_bronzesword.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			fleshy={times={[1]=1.00, [2]=0.80, [3]=0.40}, uses=25, maxlevel=2},
			snappy={times={[2]=0.70, [3]=0.25}, uses=100, maxlevel=1},
			choppy={times={[3]=0.65}, uses=50, maxlevel=0}
		}
	}
})

minetest.register_tool(":moreores:sword_mithril", {
	description = "Mithril Sword",
	inventory_image = "moreores_tool_mithrilsword.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			fleshy={times={[0]=0.65, [1]=0.50, [2]=0.40, [3]=0.30}, uses=50, maxlevel=3},			
			snappy={times={[2]=0.80, [3]=0.40}, uses=100, maxlevel=1},
			choppy={times={[3]=0.90}, uses=50, maxlevel=0}
		}
	}
})

-- Regisiter Head Armor

minetest.register_tool("more_armor:helmet_bronze", {
	description = "Bronze Helmet",
	inventory_image = "more_armor_inv_helmet_bronze.png",
	groups = {armor_head=4, armor_heal=15, armor_use=500},
	wear = 0,
})

minetest.register_tool("more_armor:helmet_mithril", {
	description = "Mithril Helmet",
	inventory_image = "more_armor_inv_helmet_mithril.png",
	groups = {armor_head=5, armor_heal=20, armor_use=100},
	wear = 0,
})

minetest.register_craft({
	output = "more_armor:helmet_bronze",
	recipe = {
		{"moreores:bronze_ingot", "moreores:bronze_ingot", "moreores:bronze_ingot"},
		{"moreores:bronze_ingot", "", "moreores:bronze_ingot"},
		{"", "", ""},
	},
})

minetest.register_craft({
	output = "more_armor:helmet_mithril",
	recipe = {
		{"moreores:mithril_ingot", "moreores:mithril_ingot", "moreores:mithril_ingot"},
		{"moreores:mithril_ingot", "", "moreores:mithril_ingot"},
		{"", "", ""},
	},
})

-- Regisiter Torso Armor

minetest.register_tool("more_armor:chestplate_bronze", {
	description = "Bronze Chestplate",
	inventory_image = "more_armor_inv_chestplate_bronze.png",
	groups = {armor_torso=4, armor_heal=20, armor_use=1000},
	wear = 0,
})

minetest.register_tool("more_armor:chestplate_mithril", {
	description = "Mithril Chestplate",
	inventory_image = "more_armor_inv_chestplate_mithril.png",
	groups = {armor_torso=5, armor_heal=25, armor_use=250},
	wear = 0,
})

minetest.register_craft({
	output = "more_armor:chestplate_bronze",
	recipe = {
		{"moreores:bronze_ingot", "", "moreores:bronze_ingot"},
		{"moreores:bronze_ingot", "moreores:bronze_ingot", "moreores:bronze_ingot"},
		{"moreores:bronze_ingot", "moreores:bronze_ingot", "moreores:bronze_ingot"},
	},
})

minetest.register_craft({
	output = "more_armor:chestplate_mithril",
	recipe = {
		{"moreores:mithril_ingot", "", "moreores:mithril_ingot"},
		{"moreores:mithril_ingot", "moreores:mithril_ingot", "moreores:mithril_ingot"},
		{"moreores:mithril_ingot", "moreores:mithril_ingot", "moreores:mithril_ingot"},
	},
})

-- Regisiter Leg Armor

minetest.register_tool("more_armor:leggings_bronze", {
	description = "Bronze Leggings",
	inventory_image = "more_armor_inv_leggings_bronze.png",
	groups = {armor_legs=4, armor_heal=15, armor_use=500},
	wear = 0,
})

minetest.register_tool("more_armor:leggings_mithril", {
	description = "Mithril Leggings",
	inventory_image = "more_armor_inv_leggings_mithril.png",
	groups = {armor_legs=5, armor_heal=20, armor_use=100},
	wear = 0,
})

minetest.register_craft({
	output = "more_armor:leggings_bronze",
	recipe = {
		{"moreores:bronze_ingot", "moreores:bronze_ingot", "moreores:bronze_ingot"},
		{"moreores:bronze_ingot", "", "moreores:bronze_ingot"},
		{"moreores:bronze_ingot", "", "moreores:bronze_ingot"},
	},
})

minetest.register_craft({
	output = "more_armor:leggings_mithril",
	recipe = {
		{"moreores:mithril_ingot", "moreores:mithril_ingot", "moreores:mithril_ingot"},
		{"moreores:mithril_ingot", "", "moreores:mithril_ingot"},
		{"moreores:mithril_ingot", "", "moreores:mithril_ingot"},
	},
})

-- Regisiter Shields

minetest.register_tool("more_armor:shield_bronze", {
	description = "Bronze Shield",
	inventory_image = "more_armor_inv_shield_bronze.png",
	groups = {armor_shield=4, armor_heal=20, armor_use=500},
	wear = 0,
})

minetest.register_tool("more_armor:shield_mithril", {
	description = "Mithril Shield",
	inventory_image = "more_armor_inv_shield_mithril.png",
	groups = {armor_shield=5, armor_heal=25, armor_use=100},
	wear = 0,
})

minetest.register_craft({
	output = "more_armor:shield_bronze",
	recipe = {
		{"moreores:bronze_ingot", "moreores:bronze_ingot", "moreores:bronze_ingot"},
		{"moreores:bronze_ingot", "moreores:bronze_ingot", "moreores:bronze_ingot"},
		{"", "moreores:bronze_ingot", ""},
	},
})

minetest.register_craft({
	output = "more_armor:shield_mithril",
	recipe = {
		{"moreores:mithril_ingot", "moreores:mithril_ingot", "moreores:mithril_ingot"},
		{"moreores:mithril_ingot", "moreores:mithril_ingot", "moreores:mithril_ingot"},
		{"", "moreores:mithril_ingot", ""},
	},
})

