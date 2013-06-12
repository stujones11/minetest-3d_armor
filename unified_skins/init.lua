
uniskins = {
	skins = {},
	default_character_skin = "character.png",
}

uniskins.get_player_skin = function(self, name)
	if minetest.get_modpath("skins") then
		local skin = skins.skins[name]
		if skin then
			if skins.get_type(skin) == skins.type.MODEL then
				return skin..".png"
			end
		end
	end
	if self.skins[name] then
		return self.skins[name]
	end
	return self.default_character_skin
end

uniskins.update_player_visuals = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local texture = self:get_player_skin(name)
	local has_wieldview = minetest.get_modpath("wieldview")
	if has_wieldview then
		texture = "wieldview_character_bg.png^[map:0,0.5,1,1="..texture
		local wielded_item_texture = wieldview:get_wielded_item_texture(player)
		if wielded_item_texture then
			texture = texture.."^[map:0,0,0.25,0.25="..wielded_item_texture
		end
	end
	if minetest.get_modpath("3d_armor") then
		local textures = armor_api:get_armor_textures(player)
		for _,v in ipairs({"head", "torso", "legs"}) do
			if textures[v] then
				texture = texture.."^"
				if has_wieldview then
					texture = texture.."[map:0,0.5,1,1="
				end
				texture = texture..textures[v]
			end
		end
		if has_wieldview and textures["shield"] then
			texture = texture.."^[map:0.25,0,0.5,0.25="..textures["shield"]
		end
	end
	player:set_properties({
		visual = "mesh",
		textures = {texture},
		visual_size = {x=1, y=1},
	})
end

minetest.register_on_joinplayer(function(player)
	if not minetest.get_modpath("player_textures") then
		return
	end
	local name = player:get_player_name()
	local filename = minetest.get_modpath("player_textures").."/textures/player_"..name
	local f = io.open(filename..".png")
	if f then
		f:close()
		uniskins.skins[name] = "player_"..player:get_player_name()..".png"
	end
end)

