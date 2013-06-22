
uniskins = {
	skin = {},
	armor = {},
	wielditem = {},
	default_skin = "character.png",
	default_texture = nil
}

uniskins.update_player_visuals = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local texture = "uniskins_trans.png"
	if self.wielditem[name] then
		texture = texture.."^[combine:64x64:0,0="..self.wielditem[name]
	end
	if self.skin[name] then
		texture = texture.."^[combine:64x64:0,32="..self.skin[name]
	end
	if self.armor[name] then
		texture = texture.."^[combine:64x64:0,0="..self.armor[name]
	end
	player:set_properties({
		visual = "mesh",
		mesh = "uniskins_character.x",
		textures = {texture},
		visual_size = {x=1, y=1},
	})
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	uniskins.skin[name] = uniskins.default_skin
	if minetest.get_modpath("player_textures") then
		local filename = minetest.get_modpath("player_textures").."/textures/player_"..name
		local f = io.open(filename..".png")
		if f then
			f:close()
			uniskins.skin[name] = "player_"..name..".png"
		end
	end
	if minetest.get_modpath("skins") then
		local skin = skins.skins[name]
		if skin and skins.get_type(skin) == skins.type.MODEL then
			uniskins.skin[name] = skin..".png"
		end
	end
end)

