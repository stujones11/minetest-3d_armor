-- Boilerplate to support localized strings if intllib mod is installed.
local S = function(s) return s end
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
end

local shield_frame_formspec = "size[8,7]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	default.get_hotbar_bg(0,3) ..
	"list[current_name;armor_shield;3.5,1;1,1;]" ..
	"image[3.5,1;1,1;shield_frame_shield.png]" ..
	"list[current_player;main;0,3;8,1;]" ..
	"list[current_player;main;0,4.25;8,3;8]"

local node_box = {
	type = "wallmounted",
	wall_top    = {-0.4375, 0.4375, -0.4375, 0.4375, 0.5, 0.4375},
	wall_bottom = {-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375},
	wall_side   = {-0.5, -0.4375, -0.4375, -0.4375, 0.4375, 0.4375},
}

local function get_frame_object(pos)
	local object = nil
	local objects = minetest.get_objects_inside_radius(pos, 0.5) or {}
	for _, obj in pairs(objects) do
		local ent = obj:get_luaentity()
		if ent then
			if ent.name == "shield_frame:shield_entity" then
				-- Remove duplicates
				if object then
					obj:remove()
				else
					object = obj
				end
			end
		end
	end
	return object
end

local function update_entity(pos)
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local rot = node.param2 or 0
	local empty = true
	if inv then
		empty = inv:is_empty("armor_shield")
	end
	local object = get_frame_object(pos)
	if object then
		if not string.find(node.name, "shield_frame:") or empty then
			object:remove()
			return
		end
	elseif empty then
		return
	else
		object = minetest.add_entity(pos, "shield_frame:shield_entity")
	end
	if object then
		local yaw = 0
		local w = 0.25
		local t = 0.025
		local collisionbox = {-w,-w,-t, w, w, t}
		local stack = inv:get_stack("armor_shield", 1)
		local item = stack:get_name()
		local def = stack:get_definition() or {}
		local groups = def.groups or {}
		if not groups["armor_shield"] then
			object:remove()
			return
		end
		if rot == 2 then
			yaw = 3 * math.pi / 2
			pos.x = pos.x + 0.4
			collisionbox = {-t,-w,-w, t, w, w}
		elseif rot == 3 then
			yaw = math.pi / 2
			pos.x = pos.x - 0.4
			collisionbox = {-t,-w,-w, t, w, w}
		elseif rot == 4 then
			yaw = math.pi
			pos.z = pos.z + 0.4
		elseif rot > 1 then
			pos.z = pos.z - 0.4
		end
		object:setpos(pos)
		object:setyaw(yaw)
		object:set_properties({
			textures = {item},
			collisionbox = collisionbox,
		})
	end
end

local function has_locked_shield_frame_privilege(meta, player)
	local name = ""
	if player then
		if minetest.check_player_privs(player, "protection_bypass") then
			return true
		end
		name = player:get_player_name()
	end
	if name ~= meta:get_string("owner") then
		return false
	end
	return true
end

minetest.register_node("shield_frame:shield_frame", {
	description = S("Shield Frame"),
	drawtype = "nodebox",
	tiles = {"shield_frame.png"},
	inventory_image = "shield_frame.png",
	wield_image = "shield_frame.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	node_box = node_box,
	groups = {cracky=2, attached_node=1},
	sounds = default.node_sound_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", shield_frame_formspec)
		meta:set_string("infotext", S("Shield Frame"))
		local inv = meta:get_inventory()
		inv:set_size("armor_shield", 1)
	end,
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("armor_shield") then
			return true
		end
		return false
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack)
		local def = stack:get_definition() or {}
		local groups = def.groups or {}
		if groups[listname] then
			return 1
		end
		return 0
	end,
	allow_metadata_inventory_move = function(pos)
		return 0
	end,
	on_metadata_inventory_put = function(pos)
		update_entity(pos)
	end,
	on_metadata_inventory_take = function(pos)
		update_entity(pos)
	end,
	after_destruct = function(pos)
		update_entity(pos)
	end,
})

minetest.register_node("shield_frame:locked_shield_frame", {
	description = S("Locked Shield Frame"),
	drawtype = "nodebox",
	tiles = {"shield_frame_locked.png"},
	inventory_image = "shield_frame_locked.png",
	wield_image = "shield_frame_locked.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	node_box = node_box,
	groups = {cracky=2, attached_node=1},
	sounds = default.node_sound_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", shield_frame_formspec)
		meta:set_string("infotext", S("Shield Frame"))
		local inv = meta:get_inventory()
		inv:set_size("armor_shield", 1)
	end,
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("armor_shield") then
			return has_locked_shield_frame_privilege(meta, player)
		end
		return false
	end,
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", S("Shield Frame (owned by ") ..
		meta:get_string("owner") .. ")")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_shield_frame_privilege(meta, player) then
			return 0
		end
		local def = stack:get_definition() or {}
		local groups = def.groups or {}
		if groups[listname] then
			return 1
		end
		return 0
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_locked_shield_frame_privilege(meta, player) then
			return 0
		end
		return stack:get_count()
	end,
	allow_metadata_inventory_move = function(pos)
		return 0
	end,
	on_metadata_inventory_put = function(pos)
		update_entity(pos)
	end,
	on_metadata_inventory_take = function(pos)
		update_entity(pos)
	end,
	after_destruct = function(pos)
		update_entity(pos)
	end,
	on_blast = function(pos)
		-- Not affected by TNT
	end,
})

minetest.register_entity("shield_frame:shield_entity", {
	physical = false,
	hp_max = 1,
	visual = "wielditem",
	visual_size = {x=0.4, y=0.4},
	textures = {"shield_frame:empty"},
	pos = nil,
	on_activate = function(self)
		self.object:set_armor_groups({immortal=1})
		local pos = self.object:getpos()
		if pos then
			pos = vector.round(pos)
			self.pos = vector.new(pos)
			update_entity(pos)
		end
	end,
	on_punch = function(self, puncher)
		if puncher:is_player() then
			local pos = self.pos or self.object:getpos()
			if pos then
				local node = minetest.get_node(pos) or {name=""}
				if string.find(node.name, "shield_frame:") then
					return
				end
			end
			self.object:remove()
		end
	end,
	on_blast = function(self, damage)
		local drops = {}
		local node = minetest.get_node(self.pos)
		if node.name == "shield_frame:shield_frame" then
			local meta = minetest.get_meta(self.pos)
			local inv = meta:get_inventory()
			local stack = inv:get_stack("armor_shield", 1)
			if stack:get_count() > 0 then
				armor:drop_armor(self.pos, stack)
				inv:set_stack("armor_shield", 1, nil)
			end
			self.object:remove()
		end
		return false, false, drops
	end,
})

minetest.register_craft({
	output = "shield_frame:shield_frame",
	recipe = {
		{"groups:wood", "default:sign_wall_steel", "groups:wood"},
	}
})

minetest.register_craft({
	output = "shield_frame:locked_shield_frame",
	recipe = {
		{"shield_frame:shield_frame", "default:steel_ingot"},
	}
})

