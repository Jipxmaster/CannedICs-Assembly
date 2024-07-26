#################################
#Table initialization
#-when the functions ends goes to
#the main function
#-Not table				0100-01ff
#-Circular right shift	0200-02ff
#################################
###not table initialization
###counter		0000
###value		0001
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
ap	35
ap	00
aj	01
ap	00
amw
#location 002d	goto 000a
ap	0a
ap	00
aj	01
aj	ff
#location 0035
###circular right shift initialization
###counter		0000
###value		0001
#location 0035	counter = 00, value = 00
ap	01
ap	00
mw	00
ap	00
mw	00
#location 003f	ram[02, counter] = value
ap	01
ap	00
aj	00
maj
ap	00
map
ap	01
amw
#location 004c	value += 80
ap	01
ap	00
aj	00
aj	80
maj
amw
#location 0056	counter += 01
ap	00
aj	00
aj	01
maj
amw
#location 005e	ram[02, counter] = value
ap	01
ap	00
aj	00
maj
ap	00
map
ap	01
amw
#location 006b	value += 81
ap	01
ap	00
aj	00
aj	81
maj
amw
#location 0075	counter += 01, if carry goto xxxx
ap	00
aj	00
maj
ap	8f
ap	00
aj	01
ap	00
ap	00
amw
#location 0085	goto 003f
ap	3f
ap	00
aj	00
aj	ff
aj	01
#location 008f	###goto main function###
ap	87
ap	01
aj	00
aj	ff
aj	01
#location 0099
#################################
#15 bit addition
#a_x = a_x + b_x
#a_l			0000
#a_h			0001
#b_l			0002
#b_h			0003
#return_l		0004
#return_h		0005
#################################
###a_x conversion into 15 bit number
#location 0099	a_h = a_h + a_h
ap	01
ap	00
aj	00
maj
maj
amw
#location 00a2	a_l += 80, if carry goto 00b9, else ignore operation
ap	00
ap	00
aj	00
maj
ap	b0
ap	00
aj	80
#location 00af	goto 00c8
ap	c8
ap	00
aj	00
aj	ff
aj	01
#location 00b9	store value, a_h += 1
ap	00
ap	00
amw
ap	01
ap	00
aj	00
aj	01
maj
amw
###b_x convertion into 15 bit number
#location 00c8	b_h + b_h + b_h
ap	02
ap	00
aj	00
maj
maj
amw
#location 00d1	b_l += 80, if carry goto 00e8, else ignore operation
ap	02
ap	00
aj	00
maj
ap	e8
ap	00
aj	80
#location 00de	goto 00f7
ap	f7
ap	00
aj	00
aj	ff
aj	01
#location 00e8	store value, b_h += 1
ap	02
ap	00
amw
ap	03
ap	00
aj	00
aj	01
maj
amw
###low byte addition
#location 00f7	a_l = a_l + b_l
ap	00
ap	00
aj	00
maj
ap	02
ap	00
maj
ap	00
amw
#location 0106	a_l += 80, if carry goto 011d, else ignore operation
ap	00
ap	00
aj	00
maj
ap	1d
ap	01
aj	80
#location 0113	goto 012c
ap	2c
ap	01
aj	00
aj	ff
aj	01
#location 011d	store value, a_h += 1
ap	00
ap	00
amw
ap	01
ap	00
aj	00
aj	01
maj
amw
###high byte addition
#location 012c	a_h += b_h
ap	01
ap	00
aj	00
maj
ap	03
ap	00
maj
ap	01
ap	00
amw
###a_x final conversion
#location 013d	right circular shift a_h
ap	01
ap	00
aj	00
map
ap	02
aj	00
maj
ap	01
ap	00
amw
#location 014e	a_h += 80, if carry goto 0165, else ignore operation
ap	01
ap	00
aj	00
maj
ap	65
ap	01
aj	80
#location 015b	goto 0174
ap	74
ap	01
aj	00
aj	ff
aj	01
#location 0165	store value, a_l += 80
ap	01
ap	00
amw
ap	00
ap	00
aj	00
aj	80
maj
amw
###return function
#location 0174
ap	04
ap	00
aj	00
maj
ap	05
ap	00
aap
map
aj	00
aj	ff
aj	01
##############
#main function
##############
#location 0187
ap	00	ap	00	mw	ff	#a_l = ff
ap	01	ap	00	mw	00	#a_h = 00
ap	02	ap	00	mw	ff	#b_l = ff
ap	03	ap	00	mw	00	#b_h = 00
ap	04	ap	00	mw	b5	#return_l = b5
ap	05	ap	00	mw	01	#return_h = 01
#location 01ab
ap	99
ap	00
aj	00
aj	ff
aj	01
#location 01b5
ap	00
ap	00
mow
ap	01
ap	00
mow
#location 01bf
ap	bf
ap	01
aj	00
aj	ff
aj	01
#location 01c9