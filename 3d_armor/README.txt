[mod] Visible Player Armor [3d_armor]
=====================================

Depends: default

Recommends: sfinv, inventory_plus or unified_inventory (use only one to avoid conflicts)

Adds craftable armor that is visible to other players. Each armor item worn contributes to
a player's armor group level making them less vulnerable to weapons.

Armor takes damage when a player is hurt but also offers a percentage chance of healing.
Overall level is boosted by 10% when wearing a full matching set.

Fire protection added by TenPlus1 when using crystal armor if Ethereal mod active, level 1
protects against torches, level 2 for crystal spike, level 3 for fire, level 5 for lava.

Armor Configuration
-------------------

Override the following default settings by adding them to your minetest.conf file.

-- Set false to disable individual armor materials.
armor_material_wood = true
armor_material_cactus = true
armor_material_steel = true
armor_material_bronze = true
armor_material_diamond = true
armor_material_gold = true
armor_material_mithril = true
armor_material_crystal = true

-- Increase this if you get initialization glitches when a player first joins.
armor_init_delay = 1

-- Number of initialization attempts.
-- Use in conjunction with ARMOR_INIT_DELAY if initialization problems persist.
armor_init_times = 1

-- Increase this if armor is not getting into bones due to server lag.
armor_bones_delay = 1

-- How often player armor items are updated.
armor_update_time = 1

-- Drop armor when a player dies.
-- Uses bones mod if present, otherwise items are dropped around the player.
armor_drop = true

-- Pulverise armor when a player dies, overrides armor_drop.
armor_destroy = false

-- You can use this to increase or decrease overall armor effectiveness,
-- eg: level_multiplier = 0.5 will reduce armor level by half.
armor_level_multiplier = 1

-- You can use this to increase or decrease overall armor healing,
-- eg: armor_heal_multiplier = 0 will disable healing altogether.
armor_heal_multiplier = 1

-- You can use this to increase or decrease overall armor radiation protection,
-- eg: armor_radiation_multiplier = 0 will completely disable radiation protection.
armor_radiation_multiplier = 1

-- Enable fire protection (defaults true if using ethereal mod)
armor_fire_protect = false

