-- support for i18n
local S = armor_i18n.gettext
local F = armor_i18n.fgettext

if not minetest.global_exists("inventory_plus") then
	minetest.log("warning", S("3d_armor_ip: Mod loaded but unused."))
	return
end

armor.formspec = "size[8,8.5]button[6,0;2,0.5;main;"..F("Back").."]"..armor.formspec
armor:register_on_update(function(player)
	local name = player:get_player_name()
	local formspec = armor:get_armor_formspec(name, true)
	local page = player:get_inventory_formspec()
	if page:find("detached:"..name.."_armor") then
		inventory_plus.set_inventory_formspec(player, formspec)
	end
end)

if minetest.get_modpath("crafting") then
	inventory_plus.get_formspec = function(player, page)
	end
end

minetest.register_on_joinplayer(function(player)
	inventory_plus.register_button(player,"armor", S("Armor"))
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.armor then
		local name = armor:get_valid_player(player, "[on_player_receive_fields]")
		if not name then
			return
		end
		local formspec = armor:get_armor_formspec(name, true)
		inventory_plus.set_inventory_formspec(player, formspec)
	end
end)
