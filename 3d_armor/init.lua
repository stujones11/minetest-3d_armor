dofile(minetest.get_modpath(minetest.get_current_modname()).."/armor_api.lua")

local time = 0
local update_time = tonumber(minetest.setting_get("3d_armor_update_time"))
if not update_time then
	update_time = 1
	minetest.setting_set("3d_armor_update_time", tostring(update_time))
end

-- Regisiter Head Armor

minetest.register_tool("3d_armor:helmet_wood", {
	description = "Wood Helmet",
	inventory_image = "3d_armor_inv_helmet_wood.png",
	groups = {armor_head=5, armor_heal=0, armor_use=1000},
	wear = 0,
})

minetest.register_tool("3d_armor:helmet_steel", {
	description = "Steel Helmet",
	inventory_image = "3d_armor_inv_helmet_steel.png",
	groups = {armor_head=10, armor_heal=5, armor_use=250},
	wear = 0,
})

minetest.register_tool("3d_armor:helmet_bronze", {
	description = "Bronze Helmet",
	inventory_image = "3d_armor_inv_helmet_bronze.png",
	groups = {armor_head=15, armor_heal=10, armor_use=100},
	wear = 0,
})

-- Regisiter Torso Armor

minetest.register_tool("3d_armor:chestplate_wood", {
	description = "Wood Chestplate",
	inventory_image = "3d_armor_inv_chestplate_wood.png",
	groups = {armor_torso=10, armor_heal=0, armor_use=1000},
	wear = 0,
})

minetest.register_tool("3d_armor:chestplate_steel", {
	description = "Steel Chestplate",
	inventory_image = "3d_armor_inv_chestplate_steel.png",
	groups = {armor_torso=15, armor_heal=5, armor_use=250},
	wear = 0,
})

minetest.register_tool("3d_armor:chestplate_bronze", {
	description = "Bronze Chestplate",
	inventory_image = "3d_armor_inv_chestplate_bronze.png",
	groups = {armor_torso=25, armor_heal=10, armor_use=100},
	wear = 0,
})

-- Regisiter Leg Armor

minetest.register_tool("3d_armor:leggings_wood", {
	description = "Wood Leggings",
	inventory_image = "3d_armor_inv_leggings_wood.png",
	groups = {armor_legs=5, armor_heal=0, armor_use=1000},
	wear = 0,
})

minetest.register_tool("3d_armor:leggings_steel", {
	description = "Steel Leggings",
	inventory_image = "3d_armor_inv_leggings_steel.png",
	groups = {armor_legs=10, armor_heal=5, armor_use=250},
	wear = 0,
})

minetest.register_tool("3d_armor:leggings_bronze", {
	description = "Bronze Leggings",
	inventory_image = "3d_armor_inv_leggings_bronze.png",
	groups = {armor_legs=15, armor_heal=10, armor_use=100},
	wear = 0,
})

-- Regisiter Shields

minetest.register_tool("3d_armor:shield_wood", {
	description = "Wooden Shield",
	inventory_image = "3d_armor_inv_shield_wood.png",
	groups = {armor_shield=10, armor_heal=0, armor_use=1000},
	wear = 0,
})

minetest.register_tool("3d_armor:shield_enhanced_wood", {
	description = "Enhanced Wooden Shield",
	inventory_image = "3d_armor_inv_shield_enhanced_wood.png",
	groups = {armor_shield=15, armor_heal=5, armor_use=500},
	wear = 0,
})

minetest.register_tool("3d_armor:shield_steel", {
	description = "Steel Shield",
	inventory_image = "3d_armor_inv_shield_steel.png",
	groups = {armor_shield=20, armor_heal=5, armor_use=250},
	wear = 0,
})

minetest.register_tool("3d_armor:shield_bronze", {
	description = "Bronze Shield",
	inventory_image = "3d_armor_inv_shield_bronze.png",
	groups = {armor_shield=25, armor_heal=10, armor_use=100},
	wear = 0,
})

-- Register Craft Recipies

local craft_ingreds = {
	wood = "default:wood",
	steel = "default:steel_ingot",
	bronze = "default:bronze_ingot",
}	

for k, v in pairs(craft_ingreds) do
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
		output = "3d_armor:shield_"..k,
		recipe = {
			{v, v, v},
			{v, v, v},
			{"", v, ""},
		},
	})
end

minetest.register_craft({
	output = "3d_armor:shield_enhanced_wood",
	recipe = {
		{"default:steel_ingot"},
		{"3d_armor:shield_wood"},
		{"default:steel_ingot"},
	},
})

-- Register Callbacks

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if fields.outfit then
		inventory_plus.set_inventory_formspec(player, "size[8,7.5]"
		.."button[0,0;2,0.5;main;Back]"
		.."list[current_player;main;0,3.5;8,4;]"
		.."list[detached:"..name.."_outfit;armor_head;3,0;1,1;]"
		.."list[detached:"..name.."_outfit;armor_torso;3,1;1,1;]"
		.."list[detached:"..name.."_outfit;armor_legs;3,2;1,1;]"
		.."list[detached:"..name.."_outfit;armor_shield;4,1;1,1;]")
		return
	end
	for field, _ in pairs(fields) do
		if string.sub(field,0,string.len("skins_set_")) == "skins_set_" then
			minetest.after(0, function(player)
				armor_api:set_player_armor(player)
			end, player)
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	inventory_plus.register_button(player,"outfit", "Outfit")
	local player_inv = player:get_inventory()
	local name = player:get_player_name()
	local armor_inv = minetest.create_detached_inventory(name.."_outfit",{
		on_put = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, stack)
			armor_api:set_player_armor(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, nil)
			armor_api:set_player_armor(player)
		end,
		allow_put = function(inv, listname, index, stack, player)
			if inv:is_empty(listname) then
				return 1
			end
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return 0
		end,
	})
	for _,v in ipairs({"head", "torso", "legs", "shield"}) do
		local armor = "armor_"..v
		player_inv:set_size(armor, 1)
		armor_inv:set_size(armor, 1)
		armor_inv:set_stack(armor, 1, player_inv:get_stack(armor, 1))
	end
	armor_api.player_hp[name] = 0
	minetest.after(0, function(player)
		armor_api:set_player_armor(player)
	end, player)	
end)

minetest.register_globalstep(function(dtime)
	time = time + dtime
	if time > update_time then
		for _,player in ipairs(minetest.get_connected_players()) do
			armor_api:update_armor(player)
		end
		time = 0
	end
end)

