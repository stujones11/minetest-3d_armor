Modpack - 3d Armor [0.4.9]
==========================

### Table of Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
<!-- END doctoc generated TOC please keep comment here to allow auto update -->

- [[mod] Visible Player Armor [3d_armor]](#mod-visible-player-armor-3d_armor)
- [[mod] Visible Wielded Items [wieldview]](#mod-visible-wielded-items-wieldview)
- [[mod] Shields [shields]](#mod-shields-shields)
- [[mod] Technic Armor [technic_armor]](#mod-technic-armor-technic_armor)
- [[mod] Hazmat Suit [hazmat_suit]](#mod-hazmat-suit-hazmat_suit)
- [[mod] 3d Armor Stand [3d_armor_stand]](#mod-3d-armor-stand-3d_armor_stand)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


[mod] Visible Player Armor [3d_armor]
-------------------------------------

Minetest Version: 0.4.15

Game: minetest_game and many derivatives

Depends: default

Adds craftable armor that is visible to other players. Each armor item worn contributes to
a player's armor group level making them less vulnerable to attack.

Armor takes damage when a player is hurt, however, many armor items offer a 'stackable'
percentage chance of restoring the lost health points. Overall armor level is boosted by 10%
when wearing a full matching set (helmet, chestplate, leggings and boots of the same material)

Fire protection has been added by TenPlus1 and in use when ethereal mod is found and crystal
armor has been enabled.  each piece of armor offers 1 fire protection, level 1 protects
against torches, level 2 against crystal spikes, 3 for fire and 5 protects when in lava.

Compatible with sfinv, inventory plus or unified inventory by enabling the appropriate
inventory module, [3d_armor_sfinv], [3d_armor_ip] and [3d_armor_ui] respectively.
Also compatible with [smart_inventory] without the need for additional modules.

built in support player skins [skins] by Zeg9 and Player Textures [player_textures] by PilzAdam
and [simple_skins] by TenPlus1.

Armor can be configured by adding a file called armor.conf in 3d_armor mod or world directory.
see armor.conf.example for all available options.

[mod] Visible Wielded Items [wieldview]
---------------------------------------

Depends: 3d_armor

Makes hand wielded items visible to other players.

[mod] Shields [shields]
-----------------------

Depends: 3d_armor

Originally a part of 3d_armor, shields have been re-included as an optional extra.
If you do not want shields then simply remove the shields folder from the modpack.

[mod] Technic Armor [technic_armor]
-----------------------------------

Depends: 3d_armor, technic_worldgen

Adds tin, silver and technic materials to 3d_armor.
Requires technic (technic_worldgen at least) mod.

[mod] Hazmat Suit [hazmat_suit]
-------------------------------

Depends: 3d_armor, technic

Adds hazmat suit to 3d_armor. It protects rather well from fire (if enabled in configuration) and radiation*, and it has built-in oxygen supply.

Requires technic mod.

[mod] 3d Armor Stand [3d_armor_stand]
-------------------------------------

Depends: 3d_armor

Adds a chest-like armor stand for armor storage and display.
