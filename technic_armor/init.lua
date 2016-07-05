-- Boilerplate to support localized strings if intllib mod is installed.
local S = function(s) return s end
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
end

local parts = {
	helmet = {place="head", name=S("Helmet"), level=5, radlevel=0.10},
	chestplate = {place="torso", name=S("Chestplate"), level=8, radlevel=0.35},
	leggings = {place="legs", name=S("Leggings"), level=7, radlevel=0.15},
	boots = {place="feet", name=S("Boots"), level=4, radlevel=0.10},
}
local stats = {
	brass = {name=S("Brass"), armor=1.8, heal=0, use=650, radiation=43},
	cast = {name=S("Cast Iron"), armor=2.5, heal=8, use=200, radiation=40},
	carbon = {name=S("Carbon Steel"), armor=2.7, heal=10, use=100, radiation=40},
	stainless = {name=S("Stainless Steel"), armor=2.7, heal=10, use=75, radiation=40},
	lead = {name=S("Lead"), armor=1.6, heal=0, use=500, radiation=88},
}
local mats = {
	brass="technic:brass_ingot",
	cast="technic:cast_iron_ingot",
	carbon="technic:carbon_steel_ingot",
	stainless="technic:stainless_steel_ingot",
	lead="technic:lead_ingot"
}
if minetest.get_modpath("moreores") then
	stats.tin = {name="Tin", armor=1.6, heal=0, use=750, radiation=37}
	stats.silver = {name="Silver", armor=1.8, heal=6, use=650, radiation=53}
	mats.tin = "moreores:tin_ingot"
	mats.silver = "moreores:silver_ingot"
end

if minetest.get_modpath("shields") then
	parts.shield = {place="shield", name=S("Shield"), level=5, radlevel=0.10}
end

for i, j in pairs(parts) do
	for k, v in pairs(stats) do
		local level = math.floor(j.level * v.armor)
		local armor_groups = {}
		local groups = {
			armor_heal = v.heal,
			armor_use = v.use,
			armor_radiation = 1,
		}
		groups["armor_"..j.place] = level
		for _, group in pairs(armor.groups) do
			armor_groups[group] = level
		end
		minetest.register_tool("technic_armor:"..i.."_"..k, {
			description = v.name.." "..j.name,
			inventory_image = "technic_armor_inv_"..i.."_"..k..".png",
			groups = groups,
			armor_groups = armor_groups,
		})
	end
end

for k, v in pairs(mats) do
	minetest.register_craft({
		output = "technic_armor:helmet_"..k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{"", "", ""},
		},
	})
	minetest.register_craft({
		output = "technic_armor:chestplate_"..k,
		recipe = {
			{v, "", v},
			{v, v, v},
			{v, v, v},
		},
	})
	minetest.register_craft({
		output = "technic_armor:leggings_"..k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{v, "", v},
		},
	})
	minetest.register_craft({
		output = "technic_armor:boots_"..k,
		recipe = {
			{v, "", v},
			{v, "", v},
		},
	})
	if minetest.get_modpath("shields") then
		minetest.register_craft({
			output = "technic_armor:shield_"..k,
			recipe = {
				{v, v, v},
				{v, v, v},
				{"", v, ""},
			},
		})
	end
end

