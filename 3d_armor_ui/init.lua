-- support for i18n
local S = armor_i18n.gettext
local F = armor_i18n.fgettext

if not minetest.global_exists("unified_inventory") then
	minetest.log("warning", S("3d_armor_ui: Mod loaded but unused."))
	return
end

if unified_inventory.sfinv_compat_layer then
	return
end

armor:register_on_update(function(player)
	local name = player:get_player_name()
	if unified_inventory.current_page[name] == "armor" then
		unified_inventory.set_inventory_formspec(player, "armor")
	end
end)

unified_inventory.register_button("armor", {
	type = "image",
	image = "inventory_plus_armor.png",
	tooltip = S("3d Armor")
})

unified_inventory.register_page("armor", {
	get_formspec = function(player, perplayer_formspec)
		local fy = perplayer_formspec.formspec_y
		local name = player:get_player_name()
		if armor.def[name].init_time == 0 then
			return {formspec="label[0,0;"..F("Armor not initialized!").."]"}
		end
		local formspec = "background[0.06,"..fy..";7.92,7.52;3d_armor_ui_form.png]"..
			"label[0,0;"..F("Armor").."]"..
			"list[detached:"..name.."_armor;armor;0,"..fy..";2,3;]"..
			"image[2.5,"..(fy - 0.25)..";2,4;"..armor.textures[name].preview.."]"..
			"label[5.0,"..(fy + 0.0)..";"..F("Level")..": "..armor.def[name].level.."]"..
			"label[5.0,"..(fy + 0.5)..";"..F("Heal")..":  "..armor.def[name].heal.."]"..
			"listring[current_player;main]"..
			"listring[detached:"..name.."_armor;armor]"
		if armor.config.fire_protect then
			formspec = formspec.."label[5.0,"..(fy + 1.0)..";"..
				F("Fire")..":  "..armor.def[name].fire.."]"
		end
		if minetest.global_exists("technic") then
			formspec = formspec.."label[5.0,"..(fy + 1.5)..";"..
				F("Radiation")..":  "..armor.def[name].groups["radiation"].."]"
		end
		return {formspec=formspec}
	end,
})
