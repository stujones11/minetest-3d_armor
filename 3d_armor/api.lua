local skin_previews = {}
local use_player_monoids = minetest.global_exists("player_monoids")
local use_armor_monoid = minetest.global_exists("armor_monoid")

armor = {
	timer = 0,
	elements = {"head", "torso", "legs", "feet"},
	physics = {"jump", "speed", "gravity"},
	formspec = "size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		default.get_hotbar_bg(0,4.25)..
		"image[2,0.5;2,4;armor_preview]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"list[current_player;craft;4,0.5;3,3;]"..
		"list[current_player;craftpreview;7,1.5;1,1;]"..
		"listring[current_player;main]"..
		"listring[current_player;craft]",
	def = {},
	textures = {},
	default_skin = "character",
	materials = {
		wood = "group:wood",
		cactus = "default:cactus",
		steel = "default:steel_ingot",
		bronze = "default:bronze_ingot",
		diamond = "default:diamond",
		gold = "default:gold_ingot",
		mithril = "moreores:mithril_ingot",
		crystal = "ethereal:crystal_ingot",
	},
	fire_nodes = {
		{"default:lava_source",     5, 8},
		{"default:lava_flowing",    5, 8},
		{"fire:basic_flame",        3, 4},
		{"fire:permanent_flame",    3, 4},
		{"ethereal:crystal_spike",  2, 1},
		{"ethereal:fire_flower",    2, 1},
		{"default:torch",           1, 1},
		{"default:torch_ceiling",   1, 1},
		{"default:torch_wall",      1, 1},
	},
	registered_callbacks = {
		on_update = {},
		on_equip = {},
		on_unequip = {},
		on_destroy = {},
	},
	version = "0.4.8",
}

armor.config = {
	init_delay = 1,
	init_times = 1,
	bones_delay = 1,
	update_time = 1,
	drop = minetest.get_modpath("bones") ~= nil,
	destroy = false,
	level_multiplier = 1,
	heal_multiplier = 1,
	radiation_multiplier = 1,
	material_wood = true,
	material_cactus = true,
	material_steel = true,
	material_bronze = true,
	material_diamond = true,
	material_gold = true,
	material_mithril = true,
	material_crystal = true,
	fire_protect = minetest.get_modpath("ethereal") ~= nil
}

-- Armor callbacks

armor.register_on_update = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_update, func)
	end
end

armor.register_on_equip = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_equip, func)
	end
end

armor.register_on_unequip = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_unequip, func)
	end
end

armor.register_on_destroy = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_destroy, func)
	end
end

armor.run_callbacks = function(self, callback, player, stack)
	if stack then
		local def = stack:get_definition() or {}
		if type(def[callback]) == "function" then
			def[callback](player, stack)
		end
	end
	local callbacks = self.registered_callbacks[callback]
	if callbacks then
		for _, func in pairs(callbacks) do
			func(player, stack)
		end
	end
end

armor.update_player_visuals = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	if self.textures[name] then
		default.player_set_textures(player, {
			self.textures[name].skin,
			self.textures[name].armor,
			self.textures[name].wielditem,
		})
	end
end

armor.set_player_armor = function(self, player)
	local name, player_inv = armor:get_valid_player(player, "[set_player_armor]")
	if not name then
		return
	end
	local armor_texture = "3d_armor_trans.png"
	local armor_level = 0
	local armor_heal = 0
	local armor_fire = 0
	local armor_water = 0
	local armor_radiation = 0
	local state = 0
	local items = 0
	local elements = {}
	local textures = {}
	local physics_o = {speed=1,gravity=1,jump=1}
	local material = {type=nil, count=1}
	local preview = armor:get_preview(name)
	for _,v in ipairs(self.elements) do
		elements[v] = false
	end
	for i=1, 6 do
		local stack = player_inv:get_stack("armor", i)
		local item = stack:get_name()
		if stack:get_count() == 1 then
			local def = stack:get_definition()
			for k, v in pairs(elements) do
				if v == false then
					local level = def.groups["armor_"..k]
					if level then
						local texture = def.texture or item:gsub("%:", "_")
						table.insert(textures, texture..".png")
						preview = preview.."^"..texture.."_preview.png"
						armor_level = armor_level + level
						state = state + stack:get_wear()
						items = items + 1
						armor_heal = armor_heal + (def.groups["armor_heal"] or 0)
						armor_fire = armor_fire + (def.groups["armor_fire"] or 0)
						armor_water = armor_water + (def.groups["armor_water"] or 0)
						armor_radiation = armor_radiation + (def.groups["armor_radiation"] or 0)
						for kk,vv in ipairs(self.physics) do
							local o_value = def.groups["physics_"..vv]
							if o_value then
								physics_o[vv] = physics_o[vv] + o_value
							end
						end
						local mat = string.match(item, "%:.+_(.+)$")
						if material.type then
							if material.type == mat then
								material.count = material.count + 1
							end
						else
							material.type = mat
						end
						elements[k] = true
					end
				end
			end
		end
	end
	if minetest.get_modpath("shields") then
		armor_level = armor_level * 0.9
	end
	if material.type and material.count == #self.elements then
		armor_level = armor_level * 1.1
	end
	armor_level = armor_level * self.config.level_multiplier
	armor_heal = armor_heal * self.config.heal_multiplier
	armor_radiation = armor_radiation * self.config.radiation_multiplier
	if #textures > 0 then
		armor_texture = table.concat(textures, "^")
	end
	local armor_groups = {fleshy=100}
	if armor_level > 0 then
		armor_groups.level = math.floor(armor_level / 20)
		armor_groups.fleshy = 100 - armor_level
		armor_groups.radiation = 100 - armor_radiation
	end
	if use_armor_monoid then
		armor_monoid.monoid:add_change(player, {
			fleshy = armor_groups.fleshy / 100
		}, "3d_armor:armor")
	else
		player:set_armor_groups(armor_groups)
	end
	if use_player_monoids then
		player_monoids.speed:add_change(player, physics_o.speed,
			"3d_armor:physics")
		player_monoids.jump:add_change(player, physics_o.jump,
			"3d_armor:physics")
		player_monoids.gravity:add_change(player, physics_o.gravity,
			"3d_armor:physics")
	else
		player:set_physics_override(physics_o)
	end
	self.textures[name].armor = armor_texture
	self.textures[name].preview = preview
	self.def[name].state = state
	self.def[name].count = items
	self.def[name].level = armor_level
	self.def[name].heal = armor_heal
	self.def[name].jump = physics_o.jump
	self.def[name].speed = physics_o.speed
	self.def[name].gravity = physics_o.gravity
	self.def[name].fire = armor_fire
	self.def[name].water = armor_water
	self.def[name].radiation = armor_radiation
	self:update_player_visuals(player)
	self:run_callbacks("on_update", player)
end

armor.get_player_skin = function(self, name)
	local skin = nil
	if self.skin_mod == "skins" or self.skin_mod == "simple_skins" then
		skin = skins.skins[name]
	elseif self.skin_mod == "u_skins" then
		skin = u_skins.u_skins[name]
	elseif self.skin_mod == "wardrobe" then
		skin = string.gsub(wardrobe.playerSkins[name], "%.png$","")
	end
	return skin or armor.default_skin
end

armor.add_preview = function(self, preview)
	skin_previews[preview] = true
end

armor.get_preview = function(self, name)
	local preview = armor:get_player_skin(name).."_preview.png"
	if skin_previews[preview] then
		return preview
	end
	return "character_preview.png"
end

armor.get_armor_formspec = function(self, name, listring)
	if not armor.textures[name] then
		minetest.log("error", "3d_armor: Player texture["..name.."] is nil [get_armor_formspec]")
		return ""
	end
	if not armor.def[name] then
		minetest.log("error", "3d_armor: Armor def["..name.."] is nil [get_armor_formspec]")
		return ""
	end
	local formspec = armor.formspec.."list[detached:"..name.."_armor;armor;0,0.5;2,3;]"
	if listring == true then
		formspec = formspec.."listring[current_player;main]"..
			"listring[detached:"..name.."_armor;armor]"
	end
	formspec = formspec:gsub("armor_preview", armor.textures[name].preview)
	formspec = formspec:gsub("armor_level", armor.def[name].level)
	formspec = formspec:gsub("armor_heal", armor.def[name].heal)
	formspec = formspec:gsub("armor_fire", armor.def[name].fire)
	formspec = formspec:gsub("armor_radiation", armor.def[name].radiation)
	return formspec
end

armor.update_inventory = function(self, player)
	local name = armor:get_valid_player(player, "[set_player_armor]")
	if not name or self.inv_mod == "inventory_enhanced" then
		return
	end
	if self.inv_mod == "smart_inventory" then
		local state = smart_inventory.get_page_state("player", name)
		if state then
			state:get("update_hook"):submit()
		end
	elseif self.inv_mod == "sfinv" then
		if sfinv.set_page then
			sfinv.set_page(player, "3d_armor:armor")
		else
			-- Backwards compat
			sfinv.set_player_inventory_formspec(player, {
				page = "3d_armor:armor"
			})
		end
	elseif self.inv_mod == "unified_inventory" then
		if unified_inventory.current_page[name] == "armor" then
			unified_inventory.set_inventory_formspec(player, "armor")
		end
	else
		if self.inv_mod == "inventory_plus" then
			local formspec = armor:get_armor_formspec(name, true)
			local page = player:get_inventory_formspec()
			if page:find("detached:"..name.."_armor") then
				inventory_plus.set_inventory_formspec(player, formspec)
			end
		elseif not core.setting_getbool("creative_mode") then
			local formspec = armor:get_armor_formspec(name)
			player:set_inventory_formspec(formspec)
		end
	end
end

armor.get_valid_player = function(self, player, msg)
	msg = msg or ""
	if not player then
		minetest.log("error", "3d_armor: Player reference is nil "..msg)
		return
	end
	local name = player:get_player_name()
	if not name then
		minetest.log("error", "3d_armor: Player name is nil "..msg)
		return
	end
	local pos = player:getpos()
	local player_inv = player:get_inventory()
	local armor_inv = minetest.get_inventory({type="detached", name=name.."_armor"})
	if not pos then
		minetest.log("error", "3d_armor: Player position is nil "..msg)
		return
	elseif not player_inv then
		minetest.log("error", "3d_armor: Player inventory is nil "..msg)
		return
	elseif not armor_inv then
		minetest.log("error", "3d_armor: Detached armor inventory is nil "..msg)
		return
	end
	return name, player_inv, armor_inv, pos
end

armor.drop_armor = function(pos, stack)
	local obj = minetest.add_item(pos, stack)
	if obj then
		obj:setvelocity({x=math.random(-1, 1), y=5, z=math.random(-1, 1)})
	end
end
