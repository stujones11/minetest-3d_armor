local skin_previews = {}
local use_player_monoids = minetest.global_exists("player_monoids")
local use_armor_monoid = minetest.global_exists("armor_monoid")

armor = {
	timer = 0,
	elements = {"head", "torso", "legs", "feet"},
	physics = {"jump", "speed", "gravity"},
	attributes = {"heal", "fire", "water"},
	formspec = "image[2.5,0;2,4;armor_preview]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		default.get_hotbar_bg(0, 4.7)..
		"list[current_player;main;0,4.7;8,1;]"..
		"list[current_player;main;0,5.85;8,3;8]",
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
	registered_groups = {["fleshy"]=100},
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
	water_protect = true,
	fire_protect = minetest.get_modpath("ethereal") ~= nil
}

-- Armor Registration

armor.register_armor = function(self, name, def)
	minetest.register_tool(name, def)
end

armor.register_armor_group = function(self, group, base)
	base = base or 100
	self.registered_groups[group] = base
	if use_armor_monoid then
		armor_monoid.register_armor_group(group, base)
	end
end

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
	local name, player_inv = self:get_valid_player(player, "[set_player_armor]")
	if not name then
		return
	end
	local state = 0
	local count = 0
	local material = {count=1}
	local preview = armor:get_preview(name)
	local texture = "3d_armor_trans.png"
	local textures = {}
	local physics = {}
	local attributes = {}
	local levels = {}
	local groups = {}
	local change = {}
	for _, phys in pairs(self.physics) do
		physics[phys] = 1
	end
	for _, attr in pairs(self.attributes) do
		attributes[attr] = 0
	end
	for group, _ in pairs(self.registered_groups) do
		change[group] = 1
		levels[group] = 0
	end
	local list = player_inv:get_list("armor")
	for i, stack in pairs(list) do
		if stack:get_count() == 1 then
			local def = stack:get_definition()
			for _, element in pairs(self.elements) do
				if def.groups["armor_"..element] then
					if def.armor_groups then
						for group, level in pairs(def.armor_groups) do
							if levels[group] then
								levels[group] = levels[group] + level
							end
						end
					else
						local level = def.groups["armor_"..element]
						levels["fleshy"] = levels["fleshy"] + level
					end
				end
				-- DEPRECATED, use armor_groups instead
				if def.groups["armor_radiation"] and levels["radiation"] then
					levels["radiation"] = def.groups["armor_radiation"]
				end
			end
			local item = stack:get_name()
			local tex = def.texture or item:gsub("%:", "_")
			tex = tex:gsub(".png$", "")
			local prev = def.preview or tex.."_preview"
			prev = prev:gsub(".png$", "")
			texture = texture.."^"..tex..".png"
			preview = preview.."^"..prev..".png"
			state = state + stack:get_wear()
			count = count + 1
			for _, phys in pairs(self.physics) do
				local value = def.groups["physics_"..phys] or 0
				physics[phys] = physics[phys] + value
			end
			for _, attr in pairs(self.attributes) do
				local value = def.groups["armor_"..attr] or 0
				attributes[attr] = attributes[attr] + value
			end
			local mat = string.match(item, "%:.+_(.+)$")
			if material.name then
				if material.name == mat then
					material.count = material.count + 1
				end
			else
				material.name = mat
			end
		end
	end
	for group, level in pairs(levels) do
		if level > 0 then
			level = level * armor.config.level_multiplier
			if material.name and material.count == #self.elements then
				level = level * 1.1
			end
		end
		local base = self.registered_groups[group]
		self.def[name].groups[group] = level
		if level > base then
			level = base
		end
		groups[group] = base - level
		change[group] = groups[group] / base
	end
	for _, attr in pairs(self.attributes) do
		self.def[name][attr] = attributes[attr]
	end
	for _, phys in pairs(self.physics) do
		self.def[name][phys] = physics[phys]
	end
	if use_armor_monoid then
		armor_monoid.monoid:add_change(player, change, "3d_armor:armor")
	else
		player:set_armor_groups(groups)
	end
	if use_player_monoids then
		player_monoids.speed:add_change(player, physics.speed,
			"3d_armor:physics")
		player_monoids.jump:add_change(player, physics.jump,
			"3d_armor:physics")
		player_monoids.gravity:add_change(player, physics.gravity,
			"3d_armor:physics")
	else
		player:set_physics_override(physics)
	end
	self.textures[name].armor = texture
	self.textures[name].preview = preview
	self.def[name].level = self.def[name].groups.fleshy or 0
	self.def[name].state = state
	self.def[name].count = count
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
		local skins = wardrobe.playerSkins or {}
		if skins[name] then
			skin = string.gsub(skins[name], "%.png$","")
		end
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
	local formspec = armor.formspec..
		"list[detached:"..name.."_armor;armor;0,0.5;2,3;]"
	if listring == true then
		formspec = formspec.."listring[current_player;main]"..
			"listring[detached:"..name.."_armor;armor]"
	end
	if not armor.def[name] or not armor.textures[name] then
		return formspec
	end
	formspec = formspec:gsub("armor_preview", armor.textures[name].preview)
	formspec = formspec:gsub("armor_level", armor.def[name].level)
	for _, attr in pairs(self.attributes) do
		formspec = formspec:gsub("armor_attr_"..attr, armor.def[name][attr])
	end
	for _, group in pairs(self.attributes) do
		formspec = formspec:gsub("armor_group_"..group, armor.def[name][group])
	end
	return formspec
end

armor.update_inventory = function(self, player)
	-- DEPRECATED: Legacy inventory support
end

armor.set_inventory_stack = function(self, player, i, stack)
	local msg = "[set_inventory_stack]"
	local name = player:get_player_name()
	if not name then
		minetest.log("warning", "3d_armor: Player name is nil "..msg)
		return
	end
	local player_inv = player:get_inventory()
	local armor_inv = minetest.get_inventory({type="detached", name=name.."_armor"})
	if not player_inv then
		minetest.log("warning", "3d_armor: Player inventory is nil "..msg)
		return
	elseif not armor_inv then
		minetest.log("warning", "3d_armor: Detached armor inventory is nil "..msg)
		return
	end
	player_inv:set_stack("armor", i, stack)
	armor_inv:set_stack("armor", i, stack)
end

armor.get_valid_player = function(self, player, msg)
	msg = msg or ""
	if not player then
		minetest.log("warning", "3d_armor: Player reference is nil "..msg)
		return
	end
	local name = player:get_player_name()
	if not name then
		minetest.log("warning", "3d_armor: Player name is nil "..msg)
		return
	end
	local pos = player:getpos()
	local inv = player:get_inventory()
	if not pos then
		minetest.log("warning", "3d_armor: Player position is nil "..msg)
		return
	elseif not inv then
		minetest.log("warning", "3d_armor: Player inventory is nil "..msg)
		return
	elseif not minetest.get_inventory({type="detached", name=name.."_armor"}) then
		minetest.log("warning", "3d_armor: Detached armor inventory is nil "..msg)
		return
	end
	return name, inv, pos
end

armor.drop_armor = function(pos, stack)
	local obj = minetest.add_item(pos, stack)
	if obj then
		obj:setvelocity({x=math.random(-1, 1), y=5, z=math.random(-1, 1)})
	end
end
