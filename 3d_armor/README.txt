[mod] Visible Player Armor [3d_armor]
=====================================

Depends: default

Recommends: inventory_plus or unified_inventory (use only one)

Adds craftable armor that is visible to other players. Each armor item worn contributes to
a player's armor group level making them less vulnerable to weapons.

Armor takes damage when a player is hurt but also offers a percentage chance of healing.
Overall level is boosted by 10% when wearing a full matching set.

Fire protection added by TenPlus1 when using crystal armor if Ethereal mod active, level 1
protects against torches, level 2 for crystal spike, level 3 for fire, level 5 for lava.

Configuration
-------------

Armor can be configured by adding a file called armor.conf in 3d_armor mod and/or world directory.
see armor.conf.example for all available options.

Note: worldpath config settings override any settings made in the mod's directory.

Crafting
--------

Helmets:

+---+---+---+
| X | X | X |
+---+---+---+
| X |   | X |
+---+---+---+
|   |   |   |
+---+---+---+

[3d_armor:helmet_wood] X = [default:wood]
[3d_armor:helmet_cactus] X = [default:cactus]
[3d_armor:helmet_steel] X = [default:steel_ingot]
[3d_armor:helmet_bronze] X = [default:bronze_ingot]
[3d_armor:helmet_diamond] X = [default:diamond]
[3d_armor:helmet_gold] X = [default:gold_ingot]
[3d_armor:helmet_mithril] X = [moreores:mithril_ingot] *
[3d_armor:helmet_crystal] X = [ethereal:crystal_ingot] **

Chestplates:

+---+---+---+
| X |   | X |
+---+---+---+
| X | X | X |
+---+---+---+
| X | X | X |
+---+---+---+

[3d_armor:chestplate_wood] X = [default:wood]
[3d_armor:chestplate_cactus] X = [default:cactus]
[3d_armor:chestplate_steel] X = [default:steel_ingot]
[3d_armor:chestplate_bronze] X = [default:bronze_ingot]
[3d_armor:chestplate_diamond] X = [default:diamond]
[3d_armor:chestplate_gold] X = [default:gold_ingot]
[3d_armor:chestplate_mithril] X = [moreores:mithril_ingot] *
[3d_armor:chestplate_crystal] X = [ethereal:crystal_ingot] **

Leggings:

+---+---+---+
| X | X | X |
+---+---+---+
| X |   | X |
+---+---+---+
| X |   | X |
+---+---+---+

[3d_armor:leggings_wood] X = [default:wood]
[3d_armor:leggings_cactus] X = [default:cactus]
[3d_armor:leggings_steel] X = [default:steel_ingot]
[3d_armor:leggings_bronze] X = [default:bronze_ingot]
[3d_armor:leggings_diamond] X = [default:diamond]
[3d_armor:leggings_gold] X = [default:gold_ingot]
[3d_armor:leggings_mithril] X = [moreores:mithril_ingot] *
[3d_armor:leggings_crystal] X = [ethereal:crystal_ingot] **

Boots:

+---+---+---+
| X |   | X |
+---+---+---+
| X |   | X |
+---+---+---+

[3d_armor:boots_wood] X = [default:wood]
[3d_armor:boots_cactus] X = [default:cactus]
[3d_armor:boots_steel] X = [default:steel_ingot]
[3d_armor:boots_bronze] X = [default:bronze_ingot
[3d_armor:boots_diamond] X = [default:diamond]
[3d_armor:boots_gold] X = [default:gold_ingot]
[3d_armor:boots_mithril] X = [moreores:mithril_ingot] *
[3d_armor:boots_crystal] X = [ethereal:crystal_ingot] **

 * Requires moreores mod by Calinou - https://forum.minetest.net/viewtopic.php?id=549
** Requires ethereal mod by Chinchow & TenPlus1 - https://github.com/tenplus1/ethereal

