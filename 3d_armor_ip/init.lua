local armor_formpage = "image[2.5,0;2,4;armor_preview]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	default.get_hotbar_bg(0, 4.7)..
	"label[5,1;Level: armor_level]"..
	"label[5,1.5;Heal:  armor_heal]"..
	"list[current_player;main;0,4.7;8,1;]"..
	"list[current_player;main;0,5.85;8,3;8]"
if armor.config.fire_protect then
	armor_formpage = armor_formpage.."label[5,2;Fire:  armor_fire]"
end
if minetest.global_exists("technic") then
	armor_formpage = armor_formpage.."label[5,2.5;Radiation:  armor_radiation]"
end
armor.formspec = "size[8,8.5]button[6,0;2,0.5;main;Back]"..armor_formpage

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
	inventory_plus.register_button(player,"armor", "Armor")
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
