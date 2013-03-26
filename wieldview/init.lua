local time = 0
local update_time = tonumber(minetest.setting_get("wieldview_update_time"))
if update_time == nil then
	update_time = 2
	minetest.setting_set("wieldview_update_time", tostring(update_time))
end

wieldview = {
	default_character_skin = "character.png",
	wielded_items = {},
}

wieldview.get_player_skin = function(self, name)
	local mod_path = minetest.get_modpath("skins")	
	if mod_path then
		local skin = skins.skins[name]
		if skin then
			if skins.get_type(skin) == skins.type.MODEL then
				return skin..".png"
			end
		end
	end
	return self.default_character_skin
end

wieldview.get_wielded_item_texture = function(self, player)
	if not player then
		return nil
	end
	local stack = player:get_wielded_item()
	local item = stack:get_name()
	if not item then
		return nil
	end
	if not minetest.registered_items[item] then
		return nil
	end
	local texture = minetest.registered_items[item].inventory_image
	if texture == "" then
		if not minetest.registered_items[item].tiles then
			return nil	
		end
		texture = minetest.registered_items[item].tiles[1]
	end
	return texture
end

wieldview.update_player_visuals = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local texture = "wieldview_character_bg.png^[combine:64x64:0,32="..self:get_player_skin(name)
	local player_inv = player:get_inventory()
	local wielded_item_texture = self:get_wielded_item_texture(player)
	if wielded_item_texture then
		texture = texture.."^[combine:64x64:0,0="..wielded_item_texture
	end
	local mod_path = minetest.get_modpath("3d_armor")	
	if mod_path then
		texture = texture..armor_api:get_player_armor(player)
	end
	player:set_properties({
		visual = "mesh",
		textures = {texture},
		visual_size = {x=1, y=1},
	})
end

wieldview.update_wielded_item = function(self, player)
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
		self:update_player_visuals(player)
	end
	self.wielded_items[name] = item
end

minetest.register_on_joinplayer(function(player)
	local texture = wieldview:get_player_skin(name)
	player:set_properties({
		visual = "mesh",
		mesh = "wieldview_character.x",
		textures = {texture},
		visual_size = {x=1, y=1},
	})
	minetest.after(1, function(player)
		wieldview:update_player_visuals(player)
	end, player)
end)

minetest.register_globalstep(function(dtime)
	time = time + dtime
	if time > update_time then
		local mod_path = minetest.get_modpath("3d_armor")
		for _,player in ipairs(minetest.get_connected_players()) do
			wieldview:update_wielded_item(player)
			if mod_path then
				armor_api:update_armor(player)
			end
		end
		time = 0
	end
end)

