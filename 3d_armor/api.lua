armor = {
	timer = 0,
	elements = {"head", "torso", "legs", "feet"},
	physics = {"jump", "speed", "gravity"},
	formspec = "size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"list[current_player;craft;3,0.5;3,3;]"..
		"list[current_player;craftpreview;7,1.5;1,1;]"..
		"image[6,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
		"listring[current_player;main]"..
		"listring[current_player;craft]"..
		default.get_hotbar_bg(0,4.25),
	version = "0.5.0",
	def = {state=0,	count = 0},
	registered_callbacks = {
		on_update = {},
		on_equip = {},
		on_unequip = {},
		on_destroy = {},
	},
	textures = {},
}

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
	local state = 0
	local items = 0
	local elements = {}
	local textures = {}
	local physics = {speed=1, gravity=1, jump=1}
	local material = {count=1}
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
						armor_level = armor_level + level
						state = state + stack:get_wear()
						items = items + 1
						armor_heal = armor_heal + (def.groups["armor_heal"] or 0)
						armor_fire = armor_fire + (def.groups["armor_fire"] or 0)
						armor_water = armor_water + (def.groups["armor_water"] or 0)
						for i, p in pairs(self.physics) do
							local value = def.groups["physics_"..p] or 0
							physics[p] = physics[p] + value
						end
						local mat = string.match(item, "%:.+_(.+)$")
						if material.name then
							if material.name == mat then
								material.count = material.count + 1
							end
						else
							material.name = mat
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
	if material.name and material.count == #self.elements then
		armor_level = armor_level * 1.1
	end
	armor_level = armor_level * ARMOR_LEVEL_MULTIPLIER
	armor_heal = armor_heal * ARMOR_HEAL_MULTIPLIER
	if #textures > 0 then
		armor_texture = table.concat(textures, "^")
	end
	local armor_groups = {fleshy=100}
	if armor_level > 0 then
		armor_groups.level = math.floor(armor_level / 20)
		armor_groups.fleshy = 100 - armor_level
	end
	self.def[name].state = state
	self.def[name].count = items
	self.def[name].level = armor_level
	self.def[name].heal = armor_heal
	self.def[name].jump = physics.jump
	self.def[name].speed = physics.speed
	self.def[name].gravity = physics.gravity
	self.def[name].fire = armor_fire
	self.def[name].water = armor_water
	player:set_armor_groups(armor_groups)
	player:set_physics_override(physics)
	multiskin[name].armor = armor_texture
	multiskin:update_player_visuals(player)
end

armor.get_armor_formspec = function(self, name)
	local formspec = armor.formspec.."list[detached:"..name.."_armor;armor;0,0.5;2,3;]"
	formspec = formspec:gsub("armor_level", armor.def[name].level)
	formspec = formspec:gsub("armor_heal", armor.def[name].heal)
	formspec = formspec:gsub("armor_fire", armor.def[name].fire)
	return formspec
end

armor.update_inventory = function(self, player)
	local name = armor:get_valid_player(player, "[set_player_armor]")
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
	multiskin:update_player_visuals(player)
end

armor.update_armor = function(self, player)
	-- Called when armor levels are changed
	-- Other mods can hook on to this function, see hud mod for example 
end

