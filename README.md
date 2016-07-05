Modpack - 3d Armor [0.5.0]
==========================

**Minetest Version:** 0.4.14

**Games:** Minetest Game and default mod compatible sub-games.

[mod] Multi Skins [multiskin]
-----------------------------

Common multi-layer player texturing api used by the modpack.
Includes optional support for version 1.8 skins.

**Depends:** default

Supported skin changing mods: 

	player_textures (PilzAdam)
	simple_skins (Tenplus1)
	skins (Zeg9)
	u_skins (SmallJoker)
	wardrobe (prestidigitator)

[mod] Visible Player Armor [3d_armor]
-------------------------------------

Adds craftable armor that is visible to other players.

**Depends:** multiskin

**Recommends:** inventory_plus or unified_inventory (use only one)

[mod] Visible Wielded Items [wieldview]
---------------------------------------

Makes hand wielded items visible to other players.

**Depends:** multiskin

[mod] Shields [shields]
-----------------------

Adds visible shields to 3d_armor.

**Depends:** 3d_armor

[mod] Technic Armor [technic_armor]
-----------------------------------

Adds lead, tin, silver and technic materials to 3d_armor.
Requires technic (technic_worldgen at least) mod.

**Depends:** 3d_armor, technic_worldgen

[mod] Hazmat Suit [hazmat_suit]
-------------------------------

Adds hazmat suit to 3d_armor. It protects from fire (if enabled) and radiation*
Also features a built-in oxygen supply for underwater breathing.

**Depends:** 3d_armor, technic

*Radiation protection requires patched version of [minetest-technic](https://github.com/minetest-technic/technic/pull/275) to take effect.

[mod] 3d Armor Stand [3d_armor_stand]
-------------------------------------

Adds a chest-like armor stand for armor storage and display.

**Depends:** 3d_armor

[mod] Shield Frame [shield_frame]
-------------------------------------

Adds a wallmounted frame for shield storage and display.

**Depends:** shields

