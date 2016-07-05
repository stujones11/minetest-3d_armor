armor = {
	timer = 0,
	elements = {"head", "torso", "legs", "feet"},
	physics = {"jump", "speed", "gravity"},
	attributes = {"heal", "fire", "water", "radiation"},
	groups = {"fleshy", "cracky", "snappy", "choppy", "crumbly"},
	formspec = "size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		default.get_hotbar_bg(0,4.25)..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"list[current_player;craft;3,0.5;3,3;]"..
		"list[current_player;craftpreview;7,1.5;1,1;]"..
		"image[6,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
		"listring[current_player;main]"..
		"listring[current_player;craft]",
	version = "0.5.0",
	def = {},
	registered_callbacks = {
		on_update = {},
		on_equip = {},
		on_unequip = {},
		on_destroy = {},
	},
	textures = {},
}

armor.set_player_armor = function(self, player)
	local name, inv = armor:get_valid_player(player, "[set_player_armor]")
	if not name then
		return
	end
	local texture = "3d_armor_trans.png"
	local groups = {level=0}
	local levels = {}
	local textures = {}
	local state = 0
	local count = 0
	local material = {count=1}
	local physics = {speed=1, gravity=1, jump=1}
	local attributes = {}
	for _, attr in pairs(self.attributes) do
		attributes[attr] = 0
	end
	for _, group in pairs(self.groups) do
		groups[group] = 100
		levels[group] = 0
	end
	for i=1, 6 do
		local stack = inv:get_stack("armor", i)
		local item = stack:get_name()
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
					elseif levels["fleshy"] then
						local level = def.groups["armor_"..element]
						levels["fleshy"] = levels["fleshy"] + level
					end
				end
			end
			local filename = def.texture or item:gsub("%:", "_")
			if not string.find(filename, ".png$") then
				filename = filename..".png"
			end
			table.insert(textures, filename)
			state = state + stack:get_wear()
			count = count + 1
			for _, attr in pairs(self.attributes) do
				local value = def.groups["armor_"..attr] or 0
				attributes[attr] = attributes[attr] + value
			end
			for _, phys in pairs(self.physics) do
				local value = def.groups["physics_"..phys] or 0
				physics[phys] = physics[phys] + value
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
	self.def[name] = {groups={}}
	for group, level in pairs(levels) do
		if level > 0 then
			if minetest.get_modpath("shields") then
				level = level * 0.9
			end
			if material.name and material.count == #self.elements then
				level = level * 1.1
			end
			groups[group] = 100 - level * ARMOR_LEVEL_MULTIPLIER
			self.def[name].groups[group] = groups[group]
		end
	end
	if levels["fleshy"] then
		groups.level = math.floor(levels["fleshy"] / 20)
	end
	attributes.heal = attributes.heal * ARMOR_HEAL_MULTIPLIER
	attributes.radiation = attributes.radiation * ARMOR_RADIATION_MULTIPLIER
	for _, attr in pairs(self.attributes) do
		self.def[name][attr] = attributes[attr]
	end
	for _, phys in pairs(self.physics) do
		self.def[name][phys] = physics[phys]
	end
	if #textures > 0 then
		texture = table.concat(textures, "^")
	end
	self.def[name].level = levels["fleshy"] or 0
	self.def[name].state = state
	self.def[name].count = count
	player:set_armor_groups(groups)
	player:set_physics_override(physics)
	multiskin:set_player_textures(player, {armor=texture})
	for _, func in pairs(armor.registered_callbacks.on_update) do
		func(player)
	end
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

armor.get_armor_formspec = function(self, name)
	local formspec = armor.formspec.."list[detached:"..name.."_armor;armor;0,0.5;2,3;]"
	formspec = formspec:gsub("armor_level", armor.def[name].level)
	for _, attr in pairs(self.attributes) do
		formspec = formspec:gsub("armor_"..attr, armor.def[name][attr])
	end
	return formspec
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

armor.update_inventory = function(self, player)
	local name = armor:get_valid_player(player, "[update_inventory]")
	if not name or self.inv_mod == "inventory_enhanced" then
		return
	end
	if self.inv_mod == "unified_inventory" then
		if unified_inventory.current_page[name] == "armor" then
			unified_inventory.set_inventory_formspec(player, "armor")
		end
	else
		local formspec = armor:get_armor_formspec(name)
		if self.inv_mod == "inventory_plus" then
			local page = player:get_inventory_formspec()
			if page:find("detached:"..name.."_armor") then
				inventory_plus.set_inventory_formspec(player, formspec..
					"listring[current_player;main]"..
					"listring[detached:"..name.."_armor;armor]")
			end
		elseif not core.setting_getbool("creative_mode") then
			player:set_inventory_formspec(formspec)
		end
	end
end

armor.drop_armor = function(self, pos, stack)
	local obj = minetest.add_item(pos, stack)
	if obj then
		obj:setvelocity({x=math.random(-1, 1), y=5, z=math.random(-1, 1)})
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

-- Legacy support

armor.update_player_visuals = function(self, player)
	local textures = armor.textures[name] or {}
	if textures.skin then
		multiskin:set_player_textures(player, {skin=textures.skin})
	end
end

armor.update_armor = function(self, player)
	-- Called when player hp changes
end

