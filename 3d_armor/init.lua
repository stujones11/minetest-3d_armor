ARMOR_MOD_NAME = minetest.get_current_modname()
ARMOR_INIT_DELAY = 1
ARMOR_INIT_TIMES = 1
ARMOR_BONES_DELAY = 1
ARMOR_UPDATE_TIME = 1
ARMOR_DROP = minetest.get_modpath("bones") ~= nil
ARMOR_DESTROY = false
ARMOR_LEVEL_MULTIPLIER = 1
ARMOR_HEAL_MULTIPLIER = 1
ARMOR_RADIATION_MULTIPLIER = 1
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

-- Boilerplate to support localized strings if intllib mod is installed.
local S = function(s) return s end
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
end

local modpath = minetest.get_modpath(ARMOR_MOD_NAME)
local worldpath = minetest.get_worldpath()
local input = io.open(modpath.."/armor.conf", "r")
if input then
	dofile(modpath.."/armor.conf")
	input:close()
end
input = io.open(worldpath.."/armor.conf", "r")
if input then
	dofile(worldpath.."/armor.conf")
	input:close()
end
if not minetest.get_modpath("moreores") then
	ARMOR_MATERIALS.mithril = nil
end
if not minetest.get_modpath("ethereal") then
	ARMOR_MATERIALS.crystal = nil
end

dofile(minetest.get_modpath(ARMOR_MOD_NAME).."/api.lua")
dofile(minetest.get_modpath(ARMOR_MOD_NAME).."/armor.lua")

local function get_init_def()
	local def = {
		state = 0,
		count = 0,
		level = 0,
		groups = {},
	}
	for _, phys in pairs(armor.physics) do
		def[phys] = 1
	end
	for _, attr in pairs(armor.attributes) do
		def[attr] = 0
	end
	for _, group in pairs(armor.groups) do
		def.groups[group] = 0
	end
	return def
end

if minetest.get_modpath("inventory_plus") then
	armor.inv_mod = "inventory_plus"
	armor.formspec = "size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"button[6,0;2,0.5;main;Back]"..
		"label[3,1.0;Level: armor_level]"..
		"label[3,1.5;Heal:  armor_heal]"..
		"label[3,2.0;Fire:  armor_fire]"..
		"label[3,2.5;Radiation:  armor_radiation]"..
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
			armor.def[name] = armor.def[name] or get_init_def()
			local formspec = "background[0.06,"..fy..
				";7.92,7.52;3d_armor_ui_form.png]"..
				"label[0,0;Armor]"..
				"list[detached:"..name.."_armor;armor;0,"..fy..";2,3;]"..
				"label[3.0,"..(fy + 0.0)..";Level: "..armor.def[name].level.."]"..
				"label[3.0,"..(fy + 0.5)..";Heal:  "..armor.def[name].heal.."]"..
				"label[3.0,"..(fy + 1.0)..";Fire:  "..armor.def[name].fire.."]"..
				"label[3.0,"..(fy + 1.5)..";Radiation:  "..armor.def[name].radiation.."]"..
				"listring[current_player;main]"..
				"listring[detached:"..name.."_armor;armor]"
			return {formspec=formspec}
		end,
	})
elseif minetest.get_modpath("inventory_enhanced") then
	armor.inv_mod = "inventory_enhanced"
end

minetest.register_on_player_hpchange(function(player, hp_change)
	local name, inv = armor:get_valid_player(player, "[on_hpchange]")
	if name and hp_change < 0 then
		-- used for insta kill tools/commands like /kill (doesnt damage armor)
		if hp_change < -100 then
			return hp_change
		end
		local heal_max = 0
		local state = 0
		local items = 0
		for i=1, 6 do
			local stack = inv:get_stack("armor", i)
			if stack:get_count() > 0 then
				local def = stack:get_definition() or {}
				local use = def.groups["armor_use"] or 0
				local heal = def.groups["armor_heal"] or 0
				local item = stack:get_name()
				stack:add_wear(use)
				armor:set_inventory_stack(player, i, stack)
				state = state + stack:get_wear()
				items = items + 1
				if stack:get_count() == 0 then
					if type(def.on_destroy) == "function" then
						def.on_destroy(player, item)
					end
					for _, func in pairs(armor.registered_callbacks.on_destroy) do
						func(player, item)
					end
					local desc = minetest.registered_items[item].description
					if desc then
						local msg = S("Your").." "..desc.." "..S("got destroyed").."!"
						minetest.chat_send_player(name, msg)
					end
					armor:set_player_armor(player)
					armor:update_inventory(player)
				end
				heal_max = heal_max + heal
			end
		end
		armor.def[name].state = state
		armor.def[name].count = items
		heal_max = heal_max * ARMOR_HEAL_MULTIPLIER
		if heal_max > math.random(100) then
			hp_change = 0
		end
	end
	armor:update_armor(player)
	return hp_change
end, true)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local player_inv = player:get_inventory()
	local armor_inv = minetest.create_detached_inventory(name.."_armor", {
		on_put = function(inv, listname, index, stack, player)
			local inv = player:get_inventory()
			if inv then
				local def = stack:get_definition() or {}
				if type(def.on_equip) == "function" then
					def.on_equip(player, stack)
				end
				for _, func in pairs(armor.registered_callbacks.on_equip) do
					func(player, stack)
				end
				inv:set_stack(listname, index, stack)
				armor:set_player_armor(player)
				armor:update_inventory(player)
			end
		end,
		on_take = function(inv, listname, index, stack, player)
			local inv = player:get_inventory()
			if inv then
				local def = stack:get_definition() or {}
				if type(def.on_unequip) == "function" then
					def.on_unequip(player, stack)
				end
				for _, func in pairs(armor.registered_callbacks.on_unequip) do
					func(player, stack)
				end
				inv:set_stack(listname, index, nil)
				armor:set_player_armor(player)
				armor:update_inventory(player)
			end
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			local inv = player:get_inventory()
			if inv then
				local stack = inv:get_stack(to_list, to_index)
				inv:set_stack(to_list, to_index, stack)
				inv:set_stack(from_list, from_index, nil)
				armor:set_player_armor(player)
				armor:update_inventory(player)
			end
		end,
		allow_put = function(inv, listname, index, stack)
			local elements = {}
			local groups = stack:get_definition().groups or {}
			for i = 1, 6 do
				for _, element in pairs(armor.elements) do
					local def = inv:get_stack("armor", i):get_definition() or {}
					if def.groups["armor_"..element] then
						elements[i] = element
					end
				end
			end
			for _, element in pairs(elements) do
				if groups["armor_"..element] then
					return 0
				end
			end
			for _, element in pairs(armor.elements) do
				if groups["armor_"..element] then
					return 1
				end
			end
			return 0
		end,
		allow_take = function(inv, listname, index, stack)
			return stack:get_count()
		end,
		allow_move = function(inv)
			return 1
		end,
	})
	if armor.inv_mod == "inventory_plus" then
		inventory_plus.register_button(player,"armor", "Armor")
	end
	armor_inv:set_size("armor", 6)
	player_inv:set_size("armor", 6)
	for i = 1, 6 do
		local stack = player_inv:get_stack("armor", i)
		armor_inv:set_stack("armor", i, stack)
	end	
	armor.def[name] = get_init_def()

	-- Legacy preview support, may be removed from future versions
	armor.textures[name] = {
		skin = multiskin:get_player_skin(name),
		preview = "3d_armor_trans.png",
	}

	for i=1, ARMOR_INIT_TIMES do
		minetest.after(ARMOR_INIT_DELAY * i, function(player)
			armor:set_player_armor(player)
			if not armor.inv_mod then
				armor:update_inventory(player)
			end
		end, player)
	end
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if name then
		armor.def[name] = nil
		armor.textures[name] = nil
	end
end)

if ARMOR_DROP == true or ARMOR_DESTROY == true then
	minetest.register_on_dieplayer(function(player)
		local name, inv, pos = armor:get_valid_player(player, "[on_dieplayer]")
		if not name then
			return
		end
		local drop = {}
		for i=1, inv:get_size("armor") do
			local stack = inv:get_stack("armor", i)
			if stack:get_count() > 0 then
				table.insert(drop, stack)
				armor:set_inventory_stack(player, i, nil)
			end
		end
		armor:set_player_armor(player)
		if armor.inv_mod == "unified_inventory" then
			unified_inventory.set_inventory_formspec(player, "craft")
		elseif armor.inv_mod == "inventory_plus" then
			local formspec = inventory_plus.get_formspec(player,"main")
			inventory_plus.set_inventory_formspec(player, formspec)
		else
			armor:update_inventory(player)
		end
		if ARMOR_DESTROY == false then
			minetest.after(ARMOR_BONES_DELAY, function()
				local node = minetest.get_node(vector.round(pos))
				if node then
					if node.name == "bones:bones" then
						local meta = minetest.get_meta(vector.round(pos))
						local owner = meta:get_string("owner")
						local inv = meta:get_inventory()
						for _,stack in ipairs(drop) do
							if name == owner and inv:room_for_item("main", stack) then
								inv:add_item("main", stack)
							else
								armor:drop_armor(pos, stack)
							end
						end
					end
				else
					for _,stack in ipairs(drop) do
						armor:drop_armor(pos, stack)
					end
				end
			end)
		end
	end)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = armor:get_valid_player(player, "[on_player_receive_fields]")
	if not name or armor.inv_mod == "inventory_enhanced" then
		return
	end
	if armor.inv_mod == "inventory_plus" and fields.armor then
		local formspec = armor:get_armor_formspec(name)
		inventory_plus.set_inventory_formspec(player, formspec..
			"listring[current_player;main]"..
			"listring[detached:"..name.."_armor;armor]")
		return
	end
end)

-- Fire Protection and water breating, added by TenPlus1

if ARMOR_FIRE_PROTECT == true then
	-- override hot nodes so they do not hurt player anywhere but mod
	for _, row in pairs(ARMOR_FIRE_NODES) do
		if minetest.registered_nodes[row[1]] then
			minetest.override_item(row[1], {damage_per_second = 0})
		end
	end
else
	print ("[3d_armor] Fire Nodes disabled")
end

minetest.register_globalstep(function(dtime)
	armor.timer = armor.timer + dtime
	if armor.timer < ARMOR_UPDATE_TIME then
		return
	end
	for _,player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local pos = player:getpos()
		local hp = player:get_hp()
		-- water breathing
		if name and armor.def[name].water > 0 then
			if player:get_breath() < 10 then
				player:set_breath(10)
			end
		end
		-- fire protection
		if ARMOR_FIRE_PROTECT == true
		and name and pos and hp then
			pos.y = pos.y + 1.4 -- head level
			local node_head = minetest.get_node(pos).name
			pos.y = pos.y - 1.2 -- feet level
			local node_feet = minetest.get_node(pos).name
			-- is player inside a hot node?
			for _, row in pairs(ARMOR_FIRE_NODES) do
				-- check fire protection, if not enough then get hurt
				if row[1] == node_head or row[1] == node_feet then
					if hp > 0 and armor.def[name].fire < row[2] then
						hp = hp - row[3] * ARMOR_UPDATE_TIME
						player:set_hp(hp)
						break
					end
				end
			end
		end
	end
	armor.timer = 0
end)

-- kill player when command issued
minetest.register_chatcommand("kill", {
	params = "<name>",
	description = S("Kills player instantly"),
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if player then
			player:set_hp(-1001)
		end
	end,
})

