#############
#RESET VECTOR
#############
#location 0000
ap	01
ap	c7
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

########################
#PRINT STRING FUNCTION
#StringLocH		0007
#StringLocL		0008
#Return high	0009	most significant byte of the return address
#Return low		000a	least significant byte of the return address
#Variable a		000b	number of times to repeat n = (100 - b)
########################
#location 0163	while variable a < ff:
ap	00	#load stringloc low
ap	08
aj	00
maj
#location 016a
ap	00	#load stringloc high
ap	07
map
aap
#location 0170
aj	00	#0004 = stringloc high, low
maj
ap	00
ap	04
amw
#location 0178
ap	00	#0005 = 01
ap	05
mw	01
#location 017e
ap	00	#0006 = 8e
ap	06
mw	8e
#location 0184
ap	00	#goto print character[stringloc]
ap	d0
aj	00
aj	ff
aj	01
#location 018e
ap	00	#stringloc low += 1
ap	08
aj	00
maj
aj	01
#location 0197
amw
#location 0198
ap	00	#variable a += 1
ap	0b
aj	00
maj
ap	01	#if carry goto 01b4
ap	b4
aj	01
ap	00
ap	0b
amw
#location 01aa
ap	01	#goto 0163
ap	63
aj	00
aj	ff
aj	01
#location 01b4	RETURN
ap	00	#load return low
ap	0a
aj	00
maj
#location 01bb
ap	00	#load return high
ap	09
map
aap
#location 01c1
aj	00	#goto return high, low
aj	ff
aj	01
#location 01c7

##############
#MAIN FUNCTION
##############
#location 01c7			INITIALIZE LCD
ap	00	#return high
ap	00
mw	01
#location 01cd
ap	00	#return low
ap	01
mw	dd
#location 01d3
ap	00	#goto INITIALIZE LCD
ap	93
aj	00
aj	ff
aj	01
#location 01dd

#location 01dd	CHARACTER H
ap	00
ap	10
mw	48
#location 01e3	CHARACTER O
ap	00
ap	11
mw	4f
#location 01e9	CHARACTER L
ap	00
ap	12
mw	4c
#location 01ef	CHARACTER A
ap	00
ap	13
mw	41
#location 01f5

#location 01f5
ap	00	#stringloc high
ap	07
mw	00
#location 01fb
ap	00	#stringloc low
ap	08
mw	10
#location 0201
ap	00	#rth
ap	09
mw	02
#location 0207
ap	00	#rtl
ap	0a
mw	1d
#location 020d
ap	00	#variable a
ap	0b
mw	fc
#location 0213
ap	01
ap	63
aj	00
aj	ff
aj	01
#location 021d

#location 021d
ap	02
ap	1d
aj	00
aj	ff
aj	01