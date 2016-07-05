[mod] Multi Skins [multiskin]
=============================

Depends: default

Common multi-layer player texturing api used by the modpack.

Supported skin changing mods: 

	player_textures (PilzAdam)
	simple_skins (Tenplus1)
	skins (Zeg9)
	u_skins (SmallJoker)
	wardrobe (prestidigitator)

Optional support for format 1.8 skins.

To enable set multiskin_format = "1.8" in minetest.conf
Note that it is currently not possible to mix formats.

API
---

Allows other mods to read/write individual player model texture layers.

local name = player:get_player_name()
local skin = multiskin.layers[name].skin

multiskin:set_player_textures(player, {skin="character.png"})

Layers:

	skin:      Player skin, aspect ratio 2:1 (MC 1.7 skin format)
	clothing:  Player Clothing, aspect ratio 1:1 (MC 1.8 skin format)
	wielditem: Hand wielded item, aspect ratio 1:1
	armor:     Player Armor, aspect ratio 2:1 (custom skin format)

Notes: skin aspect ratio 1:1 if when using format 1.8 skins.
wielditem and armor require wieldview and 3d_armor mods respectively, to have
any visible effect.

