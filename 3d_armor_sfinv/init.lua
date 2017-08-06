-- support for i18n
local S = armor_i18n.gettext

if not minetest.global_exists("sfinv") then
	minetest.log("warning", S("3d_armor_sfinv: Mod loaded but unused."))
	return
end

sfinv.register_page("3d_armor:armor", {
	title = S("Armor"),
	get = function(self, player, context)
		local name = player:get_player_name()
		local formspec = armor:get_armor_formspec(name, true)
		return sfinv.make_formspec(player, context, formspec, false)
	end
})
armor:register_on_update(function(player)
	if sfinv.enabled then
		sfinv.set_player_inventory_formspec(player)
	end
end)
