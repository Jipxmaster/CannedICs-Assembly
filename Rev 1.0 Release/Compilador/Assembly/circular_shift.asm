#############
#RESET VECTOR
#############
#location 0000
ap	00
ap	93
aj	00
aj	ff
aj	01
#location 000a

########################
#CIRCULAR SHIFT FUNCTION
#Variable a		0000	will be circular shifted
#Variable b		0001	number of times to repeat n = (100 - b)
#Return high	0002	most significant byte of the return address
#Return low		0003	least significant byte of the return address
########################
#location 000a		while a < ff:
ap	00	#variable a *= 2
ap	00
aj	00
maj
ap	00	#if carry goto 0025
ap	25
aaj
#location 0016
ap	00	#store char byte
ap	00
amw
ap	00	#goto 0030
ap	30
aj	00
aj	ff
aj	01
#location 0025
ap	00	#variable a +=1
ap	00
amw
aj	00
aj	01
maj
amw
#location 0030
ap	00	#variable b += 1, if carry goto 004c
ap	01
aj	00
maj
ap	00
ap	4c
aj	01
ap	00
ap	01
amw
#location 0042
ap	00	#goto 000a
ap	0a
aj	00
aj	ff
aj	01
#location 004c	Return function
ap	00	#load return low
ap	03
aj	00
maj
ap	00	#load return high
ap	02
map
aap
aj	00	#jump
aj	ff
aj	01
#location 005f

########################
#BYTE TO LOW NIBBLE
#Variable a		0000	after the function, will have only the least significant nibble, the rest all zeroes
#Return high	0001	most significant byte of the return address
#Return low		0002	least significant byte of the return address
########################
#location 005f
ap	00	#Variable a += 10
ap	00
aj	00
maj
ap	00	#if carry goto 007b
ap	7b
aj	10
#location 006c
ap	00
ap	00
amw
ap	00	#goto 005f
ap	5f
aj	00
aj	ff
aj	01
#location 007b #store char byte
ap	00
ap	00
amw
ap	00	#load low return byte
ap	02
aj	00
maj
ap	00	#load high return byte
ap	01
map
aap
aj	00	#goto return location
aj	ff
aj	01
#location 0093

##############
#MAIN FUNCTION
##############
#location 0093
ap	00	#Return high = 00
ap	02
mw	00
ap	00	#Return low = b5
ap	03
mw	b5
ap	00	#Variable a	= 9f
ap	00
mw	9f
ap	00	#Variable b	= fc
ap	01
mw	fc
ap	00	#goto 000a
ap	0a
aj	00
aj	ff
aj	01
#location 00b5
ap	00
ap	00
mow
ap	00
ap	b5
aj	00
aj	ff
aj	01