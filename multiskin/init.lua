multiskin = {}

local default_skin = "character.png"
local player_model = "multiskin.b3d"
if minetest.get_modpath("3d_armor") then
	player_model = "3d_armor.b3d"
elseif minetest.get_modpath("wieldview") then
	player_model = "wieldview.b3d"
end

function multiskin:get_player_skin(name)
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

function multiskin:update_player_visuals(player, skin)
	if not player then
		return
	end
	local name = player:get_player_name()
	if multiskin[name] then
		multiskin[name].skin = skin or multiskin[name].skin
		default.player_set_textures(player, {
			multiskin[name].skin,
			multiskin[name].clothing,
			multiskin[name].wielditem,
			multiskin[name].armor,
		})
	end
end

minetest.register_on_joinplayer(function(player)
	default.player_set_model(player, player_model)
	local name = player:get_player_name()
	local skin = multiskin:get_player_skin(name) or default_skin
	multiskin[name] = {
		skin = skin,
		wielditem = "multiskin_trans.png",
		clothing = "multiskin_trans.png",
		armor = "multiskin_trans.png",
	}
	minetest.after(0, function(player)
		multiskin:update_player_visuals(player)
	end, player)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	for field, _ in pairs(fields) do
		if string.find(field, "skins_set") then
			minetest.after(0, function(player)
				local skin = multiskin:get_player_skin(name)
				if skin then
					multiskin[name].skin = skin
					multiskin:update_player_visuals(player)
				end
			end, player)
		end
	end
end)

default.player_register_model(player_model, {
	animation_speed = 30,
	textures = {
		default_skin,
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

