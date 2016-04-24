minetest.register_on_player_hpchange(function(player, hp_change)
	local name, player_inv, armor_inv = armor:get_valid_player(player, "[on_hpchange]")
	if name and hp_change < 0 then
		-- used for insta kill tools/commands like /kill (doesnt damage armor)
		if hp_change < -100 then
			return hp_change
		end
		local heal_max = 0
		local state = 0
		local items = 0
		for i=1, 6 do
			local stack = player_inv:get_stack("armor", i)
			if stack:get_count() > 0 then
				local def = stack:get_definition() or {}
				local use = def.groups["armor_use"] or 0
				local heal = def.groups["armor_heal"] or 0
				local item = stack:get_name()
				stack:add_wear(use)
				armor_inv:set_stack("armor", i, stack)
				player_inv:set_stack("armor", i, stack)
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
						minetest.chat_send_player(name, "Your "..desc.." got destroyed!")
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
	for _, func in pairs(armor.registered_callbacks.on_update) do
		func(player)
	end
	return hp_change
end, true)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local player_inv = player:get_inventory()
	local armor_inv = minetest.create_detached_inventory(name.."_armor", {
		on_put = function(inv, listname, index, stack, player)
			local def = stack:get_definition() or {}
			if type(def.on_equip) == "function" then
				def.on_equip(player, stack)
			end
			for _, func in pairs(armor.registered_callbacks.on_equip) do
				func(player, stack)
			end
			player:get_inventory():set_stack(listname, index, stack)
			armor:set_player_armor(player)
			armor:update_inventory(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			local def = stack:get_definition() or {}
			if type(def.on_unequip) == "function" then
				def.on_equip(player, stack)
			end
			for _, func in pairs(armor.registered_callbacks.on_unequip) do
				func(player, stack)
			end
			player:get_inventory():set_stack(listname, index, nil)
			armor:set_player_armor(player)
			armor:update_inventory(player)
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			local plaver_inv = player:get_inventory()
			local stack = inv:get_stack(to_list, to_index)
			player_inv:set_stack(to_list, to_index, stack)
			player_inv:set_stack(from_list, from_index, nil)
			armor:set_player_armor(player)
			armor:update_inventory(player)
		end,
		allow_put = function(inv, listname, index, stack)
			return 1
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
	for i=1, 6 do
		local stack = player_inv:get_stack("armor", i)
		armor_inv:set_stack("armor", i, stack)
	end	
	armor.def[name] = {
		state = 0,
		count = 0,
		level = 0,
		heal = 0,
		jump = 1,
		speed = 1,
		gravity = 1,
		fire = 0,
		water = 0,
	}

	-- Legacy preview support, may be removed from future versions
	armor.textures[name] = {preview="3d_armor_trans.png"}

	for i=1, ARMOR_INIT_TIMES do
		minetest.after(ARMOR_INIT_DELAY * i, function(player)
			armor:set_player_armor(player)
			if not armor.inv_mod then
				armor:update_inventory(player)
			end
		end, player)
	end
end)

if ARMOR_DROP == true or ARMOR_DESTROY == true then
	armor.drop_armor = function(pos, stack)
		local obj = minetest.add_item(pos, stack)
		if obj then
			obj:setvelocity({x=math.random(-1, 1), y=5, z=math.random(-1, 1)})
		end
	end
	minetest.register_on_dieplayer(function(player)
		local name, player_inv, armor_inv, pos = armor:get_valid_player(player, "[on_dieplayer]")
		if not name then
			return
		end
		local drop = {}
		for i=1, player_inv:get_size("armor") do
			local stack = armor_inv:get_stack("armor", i)
			if stack:get_count() > 0 then
				table.insert(drop, stack)
				armor_inv:set_stack("armor", i, nil)
				player_inv:set_stack("armor", i, nil)
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
								armor.drop_armor(pos, stack)
							end
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
	description = "Kills player instantly",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if player then
			player:set_hp(-1001)
		end
	end,
})

