-- support for i18n
armor_i18n = { }
local MP = minetest.get_modpath(minetest.get_current_modname())
armor_i18n.gettext, armor_i18n.ngettext = dofile(MP.."/intllib.lua")
-- escaping formspec
armor_i18n.fgettext = function(...) return minetest.formspec_escape(armor_i18n.gettext(...)) end
-- local functions
local S = armor_i18n.gettext
local F = armor_i18n.fgettext

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local worldpath = minetest.get_worldpath()
local last_punch_time = {}
local pending_players = {}
local timer = 0

dofile(modpath.."/api.lua")

-- Legacy Config Support

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
for name, _ in pairs(armor.config) do
	local global = "ARMOR_"..name:upper()
	if minetest.global_exists(global) then
		armor.config[name] = _G[global]
	end
end
if minetest.global_exists("ARMOR_MATERIALS") then
	armor.materials = table.copy(ARMOR_MATERIALS)
end
if minetest.global_exists("ARMOR_FIRE_NODES") then
	armor.fire_nodes = table.copy(ARMOR_FIRE_NODES)
end

-- Load Configuration

for name, config in pairs(armor.config) do
	local setting = minetest.settings:get("armor_"..name)
	if type(config) == "number" then
		setting = tonumber(setting)
	elseif type(config) == "boolean" then
		setting = minetest.settings:get_bool("armor_"..name)
	end
	if setting ~= nil then
		armor.config[name] = setting
	end
end
for material, _ in pairs(armor.materials) do
	local key = "material_"..material
	if armor.config[key] == false then
		armor.materials[material] = nil
	end
end

-- Mod Compatibility

if minetest.get_modpath("technic") then
	armor.formspec = armor.formspec..
		"label[5,2.5;"..F("Radiation")..":  armor_group_radiation]"
	armor:register_armor_group("radiation")
end
local skin_mods = {"skins", "u_skins", "simple_skins", "wardrobe"}
for _, mod in pairs(skin_mods) do
	local path = minetest.get_modpath(mod)
	if path then
		local dir_list = minetest.get_dir_list(path.."/textures")
		for _, fn in pairs(dir_list) do
			if fn:find("_preview.png$") then
				armor:add_preview(fn)
			end
		end
		armor.skin_mod = mod
	end
end
if not minetest.get_modpath("moreores") then
	armor.materials.mithril = nil
end
if not minetest.get_modpath("ethereal") then
	armor.materials.crystal = nil
end

dofile(modpath.."/armor.lua")

-- Armor Initialization

armor.formspec = armor.formspec..
	"label[5,1;"..F("Level")..": armor_level]"..
	"label[5,1.5;"..F("Heal")..":  armor_attr_heal]"
if armor.config.fire_protect then
	armor.formspec = armor.formspec.."label[5,2;"..F("Fire")..":  armor_fire]"
end
armor:register_on_destroy(function(player, index, stack)
	local name = player:get_player_name()
	local def = stack:get_definition()
	if name and def and def.description then
		minetest.chat_send_player(name, S("Your @1 got destroyed!", def.description))
	end
end)

local function init_player_armor(player)
	local name = player:get_player_name()
	local player_inv = player:get_inventory()
	local pos = player:getpos()
	if not name or not player_inv or not pos then
		return false
	end
	local armor_inv = minetest.create_detached_inventory(name.."_armor", {
		on_put = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, stack)
			armor:run_callbacks("on_equip", player, index, stack)
			armor:set_player_armor(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, nil)
			armor:run_callbacks("on_unequip", player, index, stack)
			armor:set_player_armor(player)
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			local plaver_inv = player:get_inventory()
			local stack = inv:get_stack(to_list, to_index)
			player_inv:set_stack(to_list, to_index, stack)
			player_inv:set_stack(from_list, from_index, nil)
			armor:set_player_armor(player)
		end,
		allow_put = function(inv, listname, index, stack, player)
			local def = stack:get_definition() or {}
			local allowed = 0
			for _, element in pairs(armor.elements) do
				if def.groups["armor_"..element] then
					allowed = 1
					for i = 1, 6 do
						local item = inv:get_stack("armor", i):get_name()
						if minetest.get_item_group(item, "armor_"..element) > 0 then
							return 0
						end
					end
				end
			end
			return allowed
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return count
		end,
	}, name)
	armor_inv:set_size("armor", 6)
	player_inv:set_size("armor", 6)
	for i=1, 6 do
		local stack = player_inv:get_stack("armor", i)
		armor_inv:set_stack("armor", i, stack)
		armor:run_callbacks("on_equip", player, i, stack)
	end
	armor.def[name] = {
		init_time = minetest.get_gametime(),
		level = 0,
		state = 0,
		count = 0,
		groups = {},
	}
	for _, phys in pairs(armor.physics) do
		armor.def[name][phys] = 1
	end
	for _, attr in pairs(armor.attributes) do
		armor.def[name][attr] = 0
	end
	for group, _ in pairs(armor.registered_groups) do
		armor.def[name].groups[group] = 0
	end
	local skin = armor:get_player_skin(name)
	armor.textures[name] = {
		skin = skin,
		armor = "3d_armor_trans.png",
		wielditem = "3d_armor_trans.png",
		preview = armor.default_skin.."_preview.png",
	}
	local texture_path = minetest.get_modpath("player_textures")
	if texture_path then
		local dir_list = minetest.get_dir_list(texture_path.."/textures")
		for _, fn in pairs(dir_list) do
			if fn == "player_"..name..".png" then
				armor.textures[name].skin = fn
				break
			end
		end
	end
	armor:set_player_armor(player)
	return true
end

-- Armor Player Model

default.player_register_model("3d_armor_character.b3d", {
	animation_speed = 30,
	textures = {
		armor.default_skin..".png",
		"3d_armor_trans.png",
		"3d_armor_trans.png",
	},
	animations = {
		stand = {x=0, y=79},
		lay = {x=162, y=166},
		walk = {x=168, y=187},
		mine = {x=189, y=198},
		walk_mine = {x=200, y=219},
		sit = {x=81, y=160},
	},
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = armor:get_valid_player(player, "[on_player_receive_fields]")
	if not name then
		return
	end
	for field, _ in pairs(fields) do
		if string.find(field, "skins_set") then
			minetest.after(0, function(player)
				local skin = armor:get_player_skin(name)
				armor.textures[name].skin = skin
				armor:set_player_armor(player)
			end, player)
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	default.player_set_model(player, "3d_armor_character.b3d")
	minetest.after(0, function(player)
		if init_player_armor(player) == false then
			pending_players[player] = 0
		end
	end, player)
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if name then
		armor.def[name] = nil
		armor.textures[name] = nil
	end
	pending_players[player] = nil
end)

if armor.config.drop == true or armor.config.destroy == true then
	minetest.register_on_dieplayer(function(player)
		local name, player_inv = armor:get_valid_player(player, "[on_dieplayer]")
		if not name then
			return
		end
		local drop = {}
		for i=1, player_inv:get_size("armor") do
			local stack = player_inv:get_stack("armor", i)
			if stack:get_count() > 0 then
				table.insert(drop, stack)
				armor:set_inventory_stack(player, i, nil)
				armor:run_callbacks("on_unequip", player, i, stack)
			end
		end
		armor:set_player_armor(player)
		local pos = player:getpos()
		if pos and armor.config.destroy == false then
			minetest.after(armor.config.bones_delay, function()
				local meta = nil
				local maxp = vector.add(pos, 8)
				local minp = vector.subtract(pos, 8)
				local bones = minetest.find_nodes_in_area(minp, maxp, {"bones:bones"})
				for _, p in pairs(bones) do
					local m = minetest.get_meta(p)
					if m:get_string("owner") == name then
						meta = m
						break
					end
				end
				if meta then
					local inv = meta:get_inventory()
					for _,stack in ipairs(drop) do
						if inv:room_for_item("main", stack) then
							inv:add_item("main", stack)
						else
							armor.drop_armor(pos, stack)
						end
					end
				else
					for _,stack in ipairs(drop) do
						armor.drop_armor(pos, stack)
					end
				end
			end)
		end
	end)
end

if armor.config.punch_damage == true then
	minetest.register_on_punchplayer(function(player, hitter,
			time_from_last_punch, tool_capabilities)
		local name = player:get_player_name()
		if name then
			armor:punch(player, hitter, time_from_last_punch, tool_capabilities)
			last_punch_time[name] = minetest.get_gametime()
		end
	end)
end

minetest.register_on_player_hpchange(function(player, hp_change)
	if player and hp_change < 0 then
		local name = player:get_player_name()
		if name then
			local heal = armor.def[name].heal
			heal = heal * armor.config.heal_multiplier
			if heal >= math.random(100) then
				hp_change = 0
			end
			-- check if armor damage was handled by fire or on_punchplayer
			local time = last_punch_time[name] or 0
			if time == 0 or time + 1 < minetest.get_gametime() then
				armor:punch(player)
			end
		end
	end
	return hp_change
end, true)

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > armor.config.init_delay then
		for player, count in pairs(pending_players) do
			local remove = init_player_armor(player) == true
			pending_players[player] = count + 1
			if remove == false and count > armor.config.init_times then
				minetest.log("warning", S("3d_armor: Failed to initialize player"))
				remove = true
			end
			if remove == true then
				pending_players[player] = nil
			end
		end
		timer = 0
	end
end)

-- Fire Protection and water breating, added by TenPlus1

if armor.config.fire_protect == true then
	-- override hot nodes so they do not hurt player anywhere but mod
	for _, row in pairs(armor.fire_nodes) do
		if minetest.registered_nodes[row[1]] then
			minetest.override_item(row[1], {damage_per_second = 0})
		end
	end
else
	print (S("[3d_armor] Fire Nodes disabled"))
end

if armor.config.water_protect == true or armor.config.fire_protect == true then
	minetest.register_globalstep(function(dtime)
		armor.timer = armor.timer + dtime
		if armor.timer < armor.config.update_time then
			return
		end
		for _,player in pairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			local pos = player:getpos()
			local hp = player:get_hp()
			if not name or not pos or not hp then
				return
			end
			-- water breathing
			if armor.config.water_protect == true then
				if armor.def[name].water > 0 and
						player:get_breath() < 10 then
					player:set_breath(10)
				end
			end
			-- fire protection
			if armor.config.fire_protect == true then
				local fire_damage = true
				pos.y = pos.y + 1.4 -- head level
				local node_head = minetest.get_node(pos).name
				pos.y = pos.y - 1.2 -- feet level
				local node_feet = minetest.get_node(pos).name
				-- is player inside a hot node?
				for _, row in pairs(armor.fire_nodes) do
					-- check fire protection, if not enough then get hurt
					if row[1] == node_head or row[1] == node_feet then
						if fire_damage == true then
							armor:punch(player, "fire")
							last_punch_time[name] = minetest.get_gametime()
							fire_damage = false
						end
						if hp > 0 and armor.def[name].fire < row[2] then
							hp = hp - row[3] * armor.config.update_time
							player:set_hp(hp)
							break
						end
					end
				end
			end
		end
		armor.timer = 0
	end)
end
