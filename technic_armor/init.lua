local shields = minetest.get_modpath("shields") and true

local stats = {
	lead = { name="Lead", armor=2, heal=0, use=100 },
	brass = { name="Brass", armor=1.8, heal=0, use=650 },
	cast = { name="Cast Iron", armor=2.5, heal=8, use=200 },
	carbon = { name="Carbon Steel", armor=2.7, heal=10, use=100 },
	stainless = { name="Stainless Steel", armor=2.7, heal=10, use=75 },
}
local mats = {
	lead="technic:lead_ingot",
	brass="technic:brass_ingot",
	cast="technic:cast_iron_ingot",
	carbon="technic:carbon_steel_ingot",
	stainless="technic:stainless_steel_ingot",
}
if minetest.get_modpath("moreores") then
	stats.tin = { name="Tin", armor=1.6, heal=0, use=750 }
	stats.silver = { name="Silver", armor=1.8, heal=6, use=650 }
	mats.tin = "moreores:tin_ingot"
	mats.silver = "moreores:silver_ingot"
end

for k, v in pairs(stats) do
	local mat = mats[k]
	local rad_resist = technic.get_node_radiation_resistance(mat)

	minetest.register_tool("technic_armor:helmet_"..k, {
		description = v.name.." Helmet",
		inventory_image = "technic_armor_inv_helmet_"..k..".png",
		groups = {armor_head=math.floor(5*v.armor), armor_heal=v.heal, armor_use=v.use},
		wear = 0,
		radiation_resistance = rad_resist*5/9
	})
	minetest.register_tool("technic_armor:chestplate_"..k, {
		description = v.name.." Chestplate",
		inventory_image = "technic_armor_inv_chestplate_"..k..".png",
		groups = {armor_torso=math.floor(8*v.armor), armor_heal=v.heal, armor_use=v.use},
		wear = 0,
		radiation_resistance = rad_resist*8/9
	})
	minetest.register_tool("technic_armor:leggings_"..k, {
		description = v.name.." Leggings",
		inventory_image = "technic_armor_inv_leggings_"..k..".png",
		groups = {armor_legs=math.floor(7*v.armor), armor_heal=v.heal, armor_use=v.use},
		wear = 0,
		radiation_resistance = rad_resist*7/9
	})
	minetest.register_tool("technic_armor:boots_"..k, {
		description = v.name.." Boots",
		inventory_image = "technic_armor_inv_boots_"..k..".png",
		groups = {armor_feet=math.floor(4*v.armor), armor_heal=v.heal, armor_use=v.use},
		wear = 0,
		radiation_resistance = rad_resist*4/9
	})


	v = mat

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

	if shields then
		local v = stats[k]
		minetest.register_tool("technic_armor:shield_"..k, {
			description = v.name.." Shield",
			inventory_image = "technic_armor_inv_shield_"..k..".png",
			groups = {armor_shield=math.floor(5*v.armor), armor_heal=v.heal, armor_use=v.use},
			wear = 0,
			radiation_resistance = rad_resist*6/9
		})

		local m = mats[k]
		minetest.register_craft({
			output = "technic_armor:shield_"..k,
			recipe = {
				{m, m, m},
				{m, m, m},
				{"", m, ""},
			},
		})
	end
end

local rad_dmg_change = technic.register_on_radiation_damage
if not rad_dmg_change then
	-- maybe damage disabled
	return
end

local function get_radiation_protection(player)
	local _,player_inv = armor:get_valid_player(player, "[get_radiation_resistance]")
	if not player_inv then
		return
	end
	local radiation_resistance = 0
	local done_elements = {}
	for i = 1,6 do
		local def = player_inv:get_stack("armor", i):get_definition()
		local resist = def.radiation_resistance
		if resist then
			for _,v in pairs(armor.elements) do
				if not done_elements[v]
				and def.groups["armor_"..v] then
					done_elements[v] = true
					radiation_resistance = radiation_resistance + resist
					break
				end
			end
		end
	end
	if radiation_resistance == 0 then
		return
	end
	return radiation_resistance
end

rad_dmg_change(function(dmg, player, pos, node, strength)
	local resist = get_radiation_protection(player)
	if not resist then
		-- armor doesn't protect
		return
	end
	return math.floor(dmg-math.sqrt(resist)*0.1+0.5) -- needs to be changed I think
end)
