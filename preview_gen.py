#!/usr/bin/python

import os
import sys
import Image

try :
	arg = sys.argv[1]
except IndexError :
	print "Usage: preview_gen.py <index_file>"
	sys.exit(1)

try :
	index = open(arg, "r")
except IOError :
	print "Failed to open index file%s" %s (arg)
	sys.exit(1)

preview = []

for line in index.readlines() :
	if ":" in line :
		line = line.rstrip('\n')
		preview.append(line.split(':'))

print "Generating preview images..."
for fn, place in preview :
	try :
		imi = Image.open(fn)
	except IOError :
		print "Failed to open %s" % (fn)
		sys.exit(1)

	w, h = imi.size
	if h != w / 2:
		print "Incompatible texture size %s" % (fn)
		sys.exit(1)

	s = w / 64
	imo = Image.new("RGBA", (16 * s, 32 * s))
	
	if place == "all" or place == "head" :
		face = (40 * s, 8 * s, 48 * s, 16 * s)
		side_l = (56 * s, 8 * s, 57 * s, 16 * s)
		side_r = (63 * s, 8 * s, 64 * s, 16 * s)
		imo.paste(imi.crop(side_l), (4 * s, 0, 5 * s, 8 * s))
		imo.paste(imi.crop(side_r), (11 * s, 0, 12 * s, 8 * s))
		imo.paste(imi.crop(face), (4 * s, 0, 12 * s, 8 * s))

	if place == "all" or place == "torso" :
		arm = (44 * s, 20 * s, 48 * s, 32 * s)
		body = (20 * s, 20 * s, 28 * s, 32 * s)
		imo.paste(imi.crop(arm), (0 * s, 8 * s, 4 * s, 20 * s))
		imo.paste(imi.crop(arm).transpose(Image.FLIP_LEFT_RIGHT),
				(12 * s, 8 * s, 16 * s, 20 * s))
		imo.paste(imi.crop(body), (4 * s, 8 * s, 12 * s, 20 * s))

	if place == "all" or place == "legs" :
		leg = (4 * s, 20 * s, 8 * s, 32 * s)
		imo.paste(imi.crop(leg), (4 * s, 20 * s, 8 * s, 32 * s))
		imo.paste(imi.crop(leg).transpose(Image.FLIP_LEFT_RIGHT),
				(8 * s, 20 * s, 12 * s, 32 * s))

	if place == "all" or place == "feet" :
		boot = (20 * s, 4 * s, 24 * s, 11 * s)
		imo.paste(imi.crop(boot), (4 * s, 25 * s, 8 * s, 32 * s))
		imo.paste(imi.crop(boot).transpose(Image.FLIP_LEFT_RIGHT),
				(8 * s, 25 * s, 12 * s, 32 * s))

	size = (32 * s, 64 * s)
	imo = imo.resize(size)

	if place == "shield" :
		shield = (0, 0, 16 * s, 16 * s)
		imo.paste(imi.crop(shield), (16 * s, 32 * s, 32 * s, 48 * s))

	outfile = fn.replace(".png", "_preview.png")
	imo.save(outfile)
	print outfile


