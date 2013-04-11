local time = 0
local update_time = tonumber(minetest.setting_get("wieldview_update_time"))
if not update_time then
	update_time = 2
	minetest.setting_set("wieldview_update_time", tostring(update_time))
end

wieldview = {
	wielded_items = {},
}

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
		uniskins:update_player_visuals(player)
	end
	self.wielded_items[name] = item
end

minetest.register_on_joinplayer(function(player)
	local texture = uniskins:get_player_skin(name)
	player:set_properties({
		visual = "mesh",
		mesh = "wieldview_character.x",
		textures = {texture},
		visual_size = {x=1, y=1},
	})
	minetest.after(0, function(player)
		uniskins:update_player_visuals(player)
	end, player)
end)

minetest.register_globalstep(function(dtime)
	time = time + dtime
	if time > update_time then
		for _,player in ipairs(minetest.get_connected_players()) do
			wieldview:update_wielded_item(player)
		end
		time = 0
	end
end)

