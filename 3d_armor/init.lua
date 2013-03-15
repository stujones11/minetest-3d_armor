
local time = 0
local update_time = tonumber(minetest.setting_get("3d_armor_update_time"))
if update_time == nil then
	update_time = 2
	minetest.setting_set("3d_armor_update_time", tostring(update_time))
end

dofile(minetest.get_modpath(minetest.get_current_modname()).."/armor_api.lua")

minetest.register_tool("3d_armor:helmet_steel", {
	description = "Steel Helmet",
	inventory_image = "3d_armor_inv_helmet_steel.png",
	groups = {armor_head=3, armor_heal=15, armor_use=1000},
	wear = 0,
})

minetest.register_tool("3d_armor:chestplate_steel", {
	description = "Steel Chestplate",
	inventory_image = "3d_armor_inv_chestplate_steel.png",
	groups = {armor_torso=3, armor_heal=20, armor_use=2500},
	wear = 0,
})

minetest.register_tool("3d_armor:leggings_steel", {
	description = "Steel Leggings",
	inventory_image = "3d_armor_inv_leggings_steel.png",
	groups = {armor_legs=3, armor_heal=15, armor_use=1500},
	wear = 0,
})

minetest.register_tool("3d_armor:shield_steel", {
	description = "Steel Shield",
	inventory_image = "3d_armor_inv_shield_steel.png",
	groups = {armor_shield=3, armor_heal=20, armor_use=1500},
	wear = 0,
})

minetest.register_tool("3d_armor:shield_wood", {
	description = "Wooden Shield",
	inventory_image = "3d_armor_inv_shield_wood.png",
	groups = {armor_shield=2, armor_heal=10, armor_use=10000},
	wear = 0,
})

minetest.register_tool("3d_armor:shield_enhanced_wood", {
	description = "Enhanced Wooden Shield",
	inventory_image = "3d_armor_inv_shield_enhanced_wood.png",
	groups = {armor_shield=2, armor_heal=15, armor_use=3000},
	wear = 0,
})

minetest.register_craft({
	output = "3d_armor:helmet_steel",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"", "", ""},
	},
})

minetest.register_craft({
	output = "3d_armor:chestplate_steel",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
	},
})

minetest.register_craft({
	output = "3d_armor:leggings_steel",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
	},
})

minetest.register_craft({
	output = "3d_armor:shield_steel",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"", "default:steel_ingot", ""},
	},
})

minetest.register_craft({
	output = "3d_armor:shield_wood",
	recipe = {
		{"default:wood", "default:wood", "default:wood"},
		{"default:wood", "default:wood", "default:wood"},
		{"", "default:wood", ""},
	},
})

minetest.register_craft({
	output = "3d_armor:shield_enhanced_wood",
	recipe = {
		{"default:steel_ingot", "default:wood", "default:steel_ingot"},
		{"default:wood", "default:steel_ingot", "default:wood"},
		{"", "default:wood", ""},
	},
})

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
			minetest.after(1, function(player)
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
	})
	for _,v in ipairs({"head", "torso", "legs", "shield"}) do
		local armor = "armor_"..v
		player_inv:set_size(armor, 1)
		armor_inv:set_size(armor, 1)
		armor_inv:set_stack(armor, 1, player_inv:get_stack(armor, 1))
	end
	armor_api.player_hp[name] = 0
	local texture = armor_api:get_player_skin(name)
	player:set_properties({
		visual = "mesh",
		mesh = "3d_armor_character.x",
		textures = {texture},
		visual_size = {x=1, y=1},
	})
	minetest.after(1, function(player)
		armor_api:set_player_armor(player)
	end, player)
end)

minetest.register_globalstep(function(dtime)
	time = time + dtime
	if time > update_time then
		for _,player in ipairs(minetest.get_connected_players()) do
			armor_api:update_wielded_item(player)
			armor_api:update_armor(player)
		end
		time = 0
	end
end)

