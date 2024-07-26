aj	00			# Empty registers and m[0000] = 00
aj	00
ap	00
ap	00
mw	00
ow	00
		*loop
ap	00			# Load m[0000] to the AU
ap	00
maj
ap	00			# Add m[0000] and 1
ap	17
aj	01
ap	00			# Store the result into m[0000]
ap	00
amw
aow
aj	00			# goto *loop
aj	ff
ap	+loop
ap	-loop
aj	01