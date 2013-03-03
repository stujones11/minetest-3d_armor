
armor_api = {
	default_character_skin = "3d_armor_character.png",
	player_hp = {},
	wielded_items = {},
}

armor_api.get_player_skin = function(self, name)
	local mod_path = minetest.get_modpath("skins")	
	if mod_path then
		local skin = skins.skins[name]
		if skin then
			if skin ~= skins.default() and skins.get_type(skin) == skins.type.MODEL then
				return skin..".png"
			end
		end
	end
	return self.default_character_skin
end

armor_api.get_wielded_item_texture = function(self, player)
	if not player then
		return nil
	end
	local stack = player:get_wielded_item()
	local item = stack:get_name()
	if not item then
		return nil
	end
	local texture = minetest.registered_items[item].inventory_image
	if texture == "" then
		if minetest.registered_items[item].tiles[1] then
			texture = minetest.registered_items[item].tiles[1]
		end
	end
	return texture
end

armor_api.set_player_armor = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local texture = "3d_armor_character_bg.png^[combine:64x64:0,32="..self:get_player_skin(name)
	local player_inv = player:get_inventory()
	local wielded_item_texture = self:get_wielded_item_texture(player)
	if wielded_item_texture then
		texture = texture.."^[combine:64x64:0,0="..wielded_item_texture
	end
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
	local armor_groups = {level=1, fleshy=3, snappy=1, choppy=1}
	armor_groups.level = level
	armor_groups.fleshy = fleshy
	player:set_armor_groups(armor_groups)
	player:set_properties({
		visual = "mesh",
		textures = {texture},
		visual_size = {x=1, y=1},
	})
end

armor_api.update_wielded_item = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local stack = player:get_wielded_item()
	local item = stack:get_name()
	if not item then
		return
	end
	if self.wielded_items[name] then
		if self.wielded_items[name] == item then
			return
		end	
		self:set_player_armor(player)
	end
	self.wielded_items[name] = item
end

armor_api.update_armor = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local hp = player:get_hp()
	if hp == nil or hp == self.player_hp[name] then
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
			local use = stack:get_definition().groups["armor_use"] or 0
			local heal = stack:get_definition().groups["armor_heal"] or 0
			stack:add_wear(use)
			armor_inv:set_stack("armor_"..v, 1, stack)
			player_inv:set_stack("armor_"..v, 1, stack)		
			if stack:get_count() == 0 then
				self:set_player_armor(player)
			end
			heal_max = heal_max + heal
		end
		if heal_max > math.random(100) then
			player:set_hp(self.player_hp[name])
			return
		end		
	end
	self.player_hp[name] = hp
end

