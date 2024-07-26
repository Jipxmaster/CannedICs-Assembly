#####################
#Initialize not table
#From 0100 to 01ff
#counter		0000
#value			0001
#####################
#location 0000	variable value[0001] = ff
ap	01
ap	00
mw	ff
#location 0006	variable counter[0000] = 00
ap	00
mw	00
###### // while a != 255:
#location 000a	load value
ap	01
ap	00
aj	00
maj
#location 0011	ram[01, counter] = value
ap	00
map
ap	01
amw
#location 0017	value -= 1
ap	00
aj	00
aj	ff
maj
amw
#location 001f	counter += 1; if carry goto 0037
ap	00
aj	00
maj
ap	37
ap	00
aj	01
ap	00
amw
#location 002d	goto 000a
ap	0a
ap	00
aj	00
aj	ff
aj	01
#location 0037
ap	00
ap	01
mow
ap	37
ap	00
aj	00
aj	ff
aj	01