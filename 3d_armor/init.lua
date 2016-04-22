ARMOR_MOD_NAME = minetest.get_current_modname()
ARMOR_INIT_DELAY = 1
ARMOR_INIT_TIMES = 1
ARMOR_BONES_DELAY = 1
ARMOR_UPDATE_TIME = 1
ARMOR_DROP = minetest.get_modpath("bones") ~= nil
ARMOR_DESTROY = false
ARMOR_LEVEL_MULTIPLIER = 1
ARMOR_HEAL_MULTIPLIER = 1
ARMOR_MATERIALS = {
	wood = "group:wood",
	cactus = "default:cactus",
	steel = "default:steel_ingot",
	bronze = "default:bronze_ingot",
	diamond = "default:diamond",
	gold = "default:gold_ingot",
	mithril = "moreores:mithril_ingot",
	crystal = "ethereal:crystal_ingot",
}
ARMOR_FIRE_PROTECT = minetest.get_modpath("ethereal") ~= nil
ARMOR_FIRE_NODES = {
	{"default:lava_source",     5, 4},
	{"default:lava_flowing",    5, 4},
	{"fire:basic_flame",        3, 4},
	{"fire:permanent_flame",    3, 4},
	{"ethereal:crystal_spike",  2, 1},
	{"ethereal:fire_flower",    2, 1},
	{"default:torch",           1, 1},
}

local modpath = minetest.get_modpath(ARMOR_MOD_NAME)
local worldpath = minetest.get_worldpath()
local input = io.open(modpath.."/armor.conf", "r")
if input then
	dofile(modpath.."/armor.conf")
	input:close()
	input = nil
end
input = io.open(worldpath.."/armor.conf", "r")
if input then
	dofile(worldpath.."/armor.conf")
	input:close()
	input = nil
end
if not minetest.get_modpath("moreores") then
	ARMOR_MATERIALS.mithril = nil
end
if not minetest.get_modpath("ethereal") then
	ARMOR_MATERIALS.crystal = nil
end

dofile(minetest.get_modpath(ARMOR_MOD_NAME).."/api.lua")
dofile(minetest.get_modpath(ARMOR_MOD_NAME).."/register.lua")
dofile(minetest.get_modpath(ARMOR_MOD_NAME).."/armor.lua")

if minetest.get_modpath("inventory_plus") then
	armor.inv_mod = "inventory_plus"
	armor.formspec = "size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"button[6,0;2,0.5;main;Back]"..
		"label[3,1;Level: armor_level]"..
		"label[3,1.5;Heal:  armor_heal]"..
		"label[3,2;Fire:  armor_fire]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		default.get_hotbar_bg(0,4.25)
	if minetest.get_modpath("crafting") then
		inventory_plus.get_formspec = function(player, page)
		end
	end
elseif minetest.get_modpath("unified_inventory") then
	armor.inv_mod = "unified_inventory"
	unified_inventory.register_button("armor", {
		type = "image",
		image = "inventory_plus_armor.png",
	})
	unified_inventory.register_page("armor", {
		get_formspec = function(player, perplayer_formspec)
			local fy = perplayer_formspec.formspec_y
			local name = player:get_player_name()
			local formspec = "background[0.06,"..fy..
				";7.92,7.52;3d_armor_ui_form.png]"..
				"label[0,0;Armor]"..
				"list[detached:"..name.."_armor;armor;0,"..fy..";2,3;]"..
				"label[5.0,"..(fy + 0.0)..";Level: "..armor.def[name].level.."]"..
				"label[5.0,"..(fy + 0.5)..";Heal:  "..armor.def[name].heal.."]"..
				"label[5.0,"..(fy + 1.0)..";Fire:  "..armor.def[name].fire.."]"..
				"listring[current_player;main]"..
				"listring[detached:"..name.."_armor;armor]"
			return {formspec=formspec}
		end,
	})
elseif minetest.get_modpath("inventory_enhanced") then
	armor.inv_mod = "inventory_enhanced"
end

