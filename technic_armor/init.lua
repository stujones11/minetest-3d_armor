-- support for i18n
local S = armor_i18n.gettext
local F = armor_i18n.fgettext

if not minetest.get_modpath("technic_worldgen") then
	minetest.log("warning", S("technic_armor: Mod loaded but unused."))
	return
end

local stats = {
	lead = { name=S("Lead"), material="technic:lead_ingot", armor=1.6, heal=0, use=500, radiation=80*1.1 },
	brass = { name=S("Brass"), material="technic:brass_ingot", armor=1.8, heal=0, use=650, radiation=43 },
	cast = { name=S("Cast Iron"), material="technic:cast_iron_ingot", armor=2.5, heal=8, use=200, radiation=40 },
	carbon = { name=S("Carbon Steel"), material="technic:carbon_steel_ingot", armor=2.7, heal=10, use=100, radiation=40 },
	stainless = { name=S("Stainless Steel"), material="technic:stainless_steel_ingot", armor=2.7, heal=10, use=75, radiation=40 },
}
if minetest.get_modpath("moreores") then
	stats.tin = { name=S("Tin"), material="moreores:tin_ingot", armor=1.6, heal=0, use=750, radiation=37 }
	stats.silver = { name=S("Silver"), material="moreores:silver_ingot", armor=1.8, heal=6, use=650, radiation=53 }
end

local parts = {
	helmet = { place="head", name=S("Helmet"), level=5, radlevel = 0.10, craft={{1,1,1},{1,0,1}} },
	chestplate = { place="torso", name=S("Chestplate"), level=8, radlevel = 0.35, craft={{1,0,1},{1,1,1},{1,1,1}} },
	leggings = { place="legs", name=S("Leggings"), level=7, radlevel = 0.15, craft={{1,1,1},{1,0,1},{1,0,1}} },
	boots = { place="feet", name=S("Boots"), level=4, radlevel = 0.10, craft={{1,0,1},{1,0,1}} },
}
if minetest.get_modpath("shields") then
	parts.shield = { place="shield", name=S("Shield"), level=5, radlevel=0.00, craft={{1,1,1},{1,1,1},{0,1,0}} }
end

-- Makes a craft recipe based on a template
-- template is a recipe-like table but indices are used instead of actual item names:
-- 0 means nothing, everything else is treated as an index in the materials table
local function make_recipe(template, materials)
	local recipe = {}
	for j, trow in ipairs(template) do
		local rrow = {}
		for i, tcell in ipairs(trow) do
			if tcell == 0 then
				rrow[i] = ""
			else
				rrow[i] = materials[tcell]
			end
		end
		recipe[j] = rrow
	end
	return recipe
end

for key, armor in pairs(stats) do
	for partkey, part in pairs(parts) do
		local partname = "technic_armor:"..partkey.."_"..key
		minetest.register_tool(partname, {
			-- Translators: @1 stands for material and @2 for part of the armor, so that you could use a conjunction if in your language part name comes first then material (e.g. in french 'Silver Boots' is translated in 'Bottes en argent' by using '@2 en @1' as translated string)
			description = S("@1 @2", armor.name, part.name),
			inventory_image = "technic_armor_inv_"..partkey.."_"..key..".png",
			groups = {["armor_"..part.place]=math.floor(part.level*armor.armor), armor_heal=armor.heal, armor_use=armor.use, armor_radiation=math.floor(part.radlevel*armor.radiation)},
			wear = 0,
		})
		minetest.register_craft({
			output = partname,
			recipe = make_recipe(part.craft, {armor.material}),
		})
	end
end
