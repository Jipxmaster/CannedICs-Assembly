#location 0000
ap	00	#value = fb
ap	00
mw	fb
##############
#long sync
#value	0000
##############
#location 0006
ow	00	#sync level
not		#16 no ops
not
not
not
not
not
not
not
not
not
not
not
not
not
not
not
ap	00	#load value
ap	00
aj	00
maj
ap	34
ap	00
aj	01	#value += 1, if carry goto 0034
ap	00	#store value
amw
ap	06
ap	00
aj	00
aj	ff
ow	01	#black level
aj	01
#location 0034
not
ap	01	#return = 71
ap	00
mw	71
ap	00	#value = fb
mw	fb
ow	01	#black level
not
##############
#short sync
#value	0000
#return	0001
##############
#location 0042
ow	00	#sync level
not
ow	01	#black level
not		#13 no ops
not
not
not
not
not
not
not
not
not
not
not
not
ap	00	#load value
ap	00
aj	00
maj
ap	01
ap	00
map
ap	00
aj	01	#if value + 1 = carry, return
ap	00	#store value
amw
ap	42	#goto 0042
ap	00
aj	00
aj	ff
aj	01
#location 0071
ap	01	#return = d0
ap	00
mw	d0
ap	00	#value = 00
mw	00
not
not
##############
#video frame
#value	0000
#return 0001
#location 007d
ow	00	#sync level
not
not
not
ow	01	#black level
not
not
not
not
not
not
not
ow	02	#gray level
not		#25 no ops
not
not
not
not
not
not
not
not
not
not
not
ow	03	#white level
not
not
not
not
not
not
not
not
not
not
not
not
ow	02	#gray level
not		#8 no ops
not
not
not
not
not
not
ap	00	#load value
ap	00
aj	00
maj
ap	01
ow	03	#white level
ap	00
map
ap	00
aj	01	#if value + 1 = carry, return
not
ap	00	#store value
amw
ap	7d	#goto 007d
ap	00
aj	00
aj	ff
aj	01
#location 00d0
ap	01	#return = e0
ap	00
mw	e0
ap	00	#value = d0
mw	d0
ap	7d	#goto 007d
ap	00
aj	ff
#location 00e0
ap	01	#return = f0
ap	00
mw	f0
ap	00	#value = fa
mw	fa
ap	42	#goto 0042
ap	00
aj	ff
#location 00f0
ap	00	#goto 0000
not
not
aj	ff
#location 00f6