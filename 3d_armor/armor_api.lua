
armor_api = {
	player_hp = {},
}

armor_api.get_player_armor = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local texture = ""
	local player_inv = player:get_inventory()
	local armor = {head, torso, legs, shield}
	for _,v in ipairs({"head", "torso", "legs"}) do
		local stack = player_inv:get_stack("armor_"..v, 1)
		armor[v] = stack:get_definition().groups["armor_"..v] or 0
		if armor[v] > 0 then
			item = stack:get_name()
			texture = texture.."^[combine:64x64:0,32="..item:gsub("%:", "_")..".png"
		end
	end
	local stack = player_inv:get_stack("armor_shield", 1)
	armor["shield"] = stack:get_definition().groups["armor_shield"] or 0
	if armor["shield"] > 0 then
		item = stack:get_name()
		texture = texture.."^[combine:64x64:16,0="..minetest.registered_items[item].inventory_image
	end
	local armor_level = math.floor(
		(.2*armor["head"]) + 
		(.3*armor["torso"]) +
		(.2*armor["legs"]) +
		(.3*armor["shield"])
	)
	local level = (armor_level / 2) + 0.5
	local fleshy = 3 - (armor_level / 2)
	if fleshy < 0 then
		fleshy = 0
	end
	local armor_groups = {level=1, fleshy=3, snappy=1, choppy=1}
	armor_groups.level = level
	armor_groups.fleshy = fleshy
	player:set_armor_groups(armor_groups)
	return texture
end

armor_api.update_armor = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local hp = player:get_hp()
	if hp == nil or hp == 0 or hp == self.player_hp[name] then
		return
	end
	if self.player_hp[name] > hp then
		local player_inv = player:get_inventory()
		local armor_inv = minetest.get_inventory({type="detached", name=name.."_outfit"})
		if armor_inv == nil then
			return
		end
		local heal_max = 0
		for _,v in ipairs({"head", "torso", "legs", "shield"}) do
			local stack = armor_inv:get_stack("armor_"..v, 1)
			if stack:get_count() > 0 then
				local use = stack:get_definition().groups["armor_use"] or 0
				local heal = stack:get_definition().groups["armor_heal"] or 0
				local item = stack:get_name()
				stack:add_wear(use)
				armor_inv:set_stack("armor_"..v, 1, stack)
				player_inv:set_stack("armor_"..v, 1, stack)
				if stack:get_count() == 0 then
					local desc = minetest.registered_items[item].description
					if desc then
						minetest.chat_send_player(name, "Your "..desc.." got destroyed!")
					end				
					wieldview:update_player_visuals(player)
				end
				heal_max = heal_max + heal
			end
		end
		if heal_max > math.random(100) then
			player:set_hp(self.player_hp[name])
			return
		end		
	end
	self.player_hp[name] = hp
end

