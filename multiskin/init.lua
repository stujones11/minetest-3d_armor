multiskin = {
	layers = {},
	default_skin = "multiskin.png",
	player_model = "multiskin.b3d",
}

local skin_format = minetest.setting_get("multiskin_format")
if not skin_format then
	skin_format = "1.7"
	minetest.setting_set("multiskin_format", skin_format)
end
if minetest.get_modpath("3d_armor") then
	multiskin.player_model = "3d_armor.b3d"
elseif minetest.get_modpath("wieldview") then
	multiskin.player_model = "wieldview.b3d"
end
if skin_format == "1.8" then
	multiskin.default_skin = multiskin.default_skin:gsub(".png", "_18.png")
	multiskin.player_model = multiskin.player_model:gsub(".b3d", "_18.b3d")
end
print("[Multiskin] Using skin format "..skin_format)

function multiskin:get_player_skin(name)
	if name then
		if minetest.get_modpath("player_textures") then
			local path = minetest.get_modpath("player_textures").."/textures/"
			local skin = "player_"..name..".png"
			local f = io.open(path..skin)
			if f then
				f:close()
				return skin
			end
		elseif minetest.get_modpath("skins") then
			if skins.skins[name] and skins.get_type(skin) == skins.type.MODEL then
				return skins.skins[name]..".png"
			end
		elseif minetest.get_modpath("simple_skins") then
			if skins.skins[name] then
				return skins.skins[name]..".png"
			end
		elseif minetest.get_modpath("u_skins") then
			if u_skins.u_skins[name] and u_skins.get_type(skin) == u_skins.type.MODEL then
				return u_skins.u_skins[name]..".png"
			end
		elseif minetest.get_modpath("wardrobe") then
			if wardrobe.playerSkins then
				return wardrobe.playerSkins[name]
			end
		end
	end
	return multiskin.default_skin
end

function multiskin:init_layers(name)
	if name then
		multiskin.layers[name] = {
			skin = multiskin:get_player_skin(name),
			wielditem = "multiskin_trans.png",
			clothing = "multiskin_trans.png",
			armor = "multiskin_trans.png",
		}
	end
end

function multiskin:set_player_textures(player, textures)
	local name = player:get_player_name()
	if name then
		if not multiskin.layers[name] then
			multiskin:init_layers(name)
		end
		for _, layer in pairs({"skin", "clothing", "wielditem", "armor"}) do
			multiskin.layers[name][layer] = textures[layer] or multiskin.layers[name][layer]
		end
	end
	multiskin:update_player_visuals(player)
end

function multiskin:update_player_visuals(player)
	if not player then
		return
	end
	local name = player:get_player_name()
	if multiskin.layers[name] then
		local skin = multiskin.layers[name].skin
		local clothing = multiskin.layers[name].clothing
		local wielditem = multiskin.layers[name].wielditem
		local armor = multiskin.layers[name].armor
		if skin_format == "1.8" then
			if clothing == "multiskin_trans.png" then
				clothing = skin
			else
				clothing = skin.."^"..clothing
			end
		end
		default.player_set_textures(player, {skin, clothing, wielditem, armor})
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	default.player_set_model(player, multiskin.player_model)
	multiskin:init_layers(name)
	minetest.after(0, function(player)
		multiskin:update_player_visuals(player)
	end, player)
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if name then
		multiskin.layers[name] = nil
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	for field, _ in pairs(fields) do
		if string.find(field, "skins_set") then
			minetest.after(0, function(player)
				local skin = multiskin:get_player_skin(name)
				if skin then
					multiskin:set_player_textures(player, {skin=skin})
				end
			end, player)
		end
	end
end)

default.player_register_model(multiskin.player_model, {
	animation_speed = 30,
	textures = {
		multiskin.default_skin,
		"multiskin_trans.png",
		"multiskin_trans.png",
		"multiskin_trans.png",
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

