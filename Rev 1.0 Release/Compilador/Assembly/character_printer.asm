#############
#RESET VECTOR
#############
#location 0000
ap	01
ap	63
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

########################
#INITIALIZE LCD
#Return high	0000	most significant byte of the return address
#Return	low		0001	least significant byte of the return address
########################
#location 0093
ow	02	#set to 4 bit mode
ow	12
ow	02
#location 0099
ow	00	#clear display
ow	10
ow	00
#location 009f
ow	01
ow	11
ow	01
#location 00a5
ow	00	#return home
ow	10
ow	00
ow	01
ow	11
ow	01
#location 00b1
ow	00	#display on
ow	10
ow	00
ow	0f
ow	1f
ow	0f
#location 00bd	RETURN
ap	00	#load return low
ap	01
aj	00
maj
#location 00c4
ap	00	#load return high
ap	00
map
aap
#location 00ca
aj	00	#jump to return
aj	ff
aj	01
#location 00d0

########################
#PRINT LCD
#Character		0004
#Return high	0005	most significant byte of the return address
#Return low		0006	least significant byte of the return address
########################
##############PRINTING HIGH CHAR
#location 00d0	Calling circular shift[character, fc, 00, f8]
ap	00	#0000 = character
ap	04
aj	00
maj
ap	00
ap	00
amw
#location 00dc
ap	00	#0001 = fc
ap	01
mw	fc
#location 00e2
ap	00	#0002 = 00
ap	02
mw	00
#location 00e8
ap	00	#0003 = f8
ap	03
mw	f8
#location 00ee
ap	00	#goto circular shift function
ap	0a
aj	00
aj	ff
aj	01
#location 00f8	Calling byte to low nibble
ap	00	#0001 = 01
ap	01
mw	01
#location 00fe
ap	00	#0002 = 0e
ap	02
mw	0e
#location 0104
ap	00
ap	5f
aj	00
aj	ff
aj	01
#location 010e	Output function
ap	00
ap	00
aj	00
maj
aj	20
aow
amw	maj
aj	10
aow	mow
##############PRINTING LOW CHAR
#location 011e
ap	00	#0000 = character
ap	04
aj	00
maj
ap	00
ap	00
amw
#location 012a
ap	00	#0001 = 01
ap	01
mw	01
#location 0130
ap	00	#0002 = 3a
ap	02
mw	40
#location 0136
ap	00	#goto byte to low nibble
ap	5f
aj	00
aj	ff
aj	01
#location 0140	Output function
ap	00
ap	00
aj	00
maj
aj	20
aow
amw	maj
aj	10
aow	mow
#location 0150	RETURN
ap	00	#load return low
ap	06
aj	00
maj
ap	00	#load return high
ap	05
map
aap
aj	00	#jump to return
aj	ff
aj	01
#location 0163

##############
#MAIN FUNCTION
##############
#location 0163			INITIALIZE LCD
ap	00	#return high
ap	00
mw	01
#location 0169
ap	00	#return low
ap	01
mw	79
#location 016f
ap	00	#goto INITIALIZE LCD
ap	93
aj	00
aj	ff
aj	01

#location 0179			PRINT CHAR 'A'
ap	00	#char A
ap	04
mw	7f
#location 017f
ap	00	#return high
ap	05
mw	01
#location 0185
ap	00	#return low
ap	06
mw	95
#location 018b
ap	00	#goto PRINT LCD
ap	d0
aj	00
aj	ff
aj	01
#location 0195
ap	01
ap	79
aj	00
aj	ff
aj	01