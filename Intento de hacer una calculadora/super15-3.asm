#
#Not table initialization
#-From 0100-01ff
#################################
###counter 	0000
###value	0001
#location 0000: value = ff
ap 01 zap mw ff
#location 0005: counter = 00
zap zmw
###### // while counter != ff:
#location 0007: (counter, 01) = value
ap 01 zap zaj maj
zap map ap 01 amw
#location 0011: value -= 01
zap zaj aj ff maj amw
#location 0017: counter += 1; if carry goto 0029
zap zaj maj ap 29 zap 
aj 01 ap 00 amw
#location 0022: goto 0007
ap 07 zap aj 01 aj ff
#
#Circular right shift table 
#initialization
#-From 0200-02ff
#################################
###counter 	0000
###value	0001
#location 0029: counter = 00, value = 00
ap 01 zap zmw zap zmw
###### // while counter != ff
#location 002f: (counter, 02) = value
ap 01 zap zaj maj 
zap map ap 02 amw
#location 0039: value += 80
ap 01 zap zaj aj 80
maj amw
#location 0041: counter += 01
zap zaj aj 01 maj amw
#location 0047: (counter, 02) = value
ap 01 zap zaj maj 
zap map ap 02 amw
#location 0051: value += 81
ap 01 zap zaj aj 81
maj amw
#location 0059: counter += 01; if carry goto 006b
zap zaj maj ap 6b zap
aj 01 zap zap amw
#location 0064: goto 002f
ap 2f zap aj 01 aj ff
#
#right shift table initialization
#-From 0400-04ff
#################################
###counter	0000
###value	0001
#location 006b: counter = 00, value = 00
ap 01 zap zmw zap zmw
###### // while counter != ff
#location 0071: (counter, 03) = value
ap 01 zap zaj maj
zap map ap 03 amw
#location 007b: counter += 01
zap zap zaj aj 01 maj amw 
#location 0082: (counter, 03) = value 
ap 01 zap zaj maj
zap map ap 03 amw
#location 008c: value += 01
ap 01 zap zaj aj 01
maj amw
#location 0094: counter += 01, if carry goto 00a6
zap zaj maj ap a6 zap
aj 01 zap zap amw
#location 009f: goto 0071
ap 71 zap aj ff aj ff
#
###Main function call
#location 00a6: goto main function 
ap 59 ap 01 aj ff aj ff
###
#
#15 bit addition 
#-little endian
#a_x = a_x + b_x
#################################
###a_l			0000
###a_h			0001
###b_l			0002
###b_h			0003
###return_l		0004
###return_h		0005
#
###a_x conversion into 15 bit number
#
#location 00ae: a_h = a_h + a_h
ap 01 zap zaj maj maj amw
#location 00b5: add a_l, 80; if carry goto 00c2
zap zaj maj ap c2 zap aj 80
#location 00bd: goto 00cc
ap cc zap aj ff
#location 00c2: a_l = acc; a_h += 01
zap amw ap 01 zap zaj aj 01 maj amw
#
###b_x conversion into 15 bit number
#
#location 00cc: b_h = b_h + b_h
ap 03 zap zaj maj maj amw
#location 00d3: add b_l, 80; if carry goto 00e4
ap 02 zap zaj maj ap e4 ap 00 aj 80
#location 00de: goto 00f0
ap f0 ap 00 aj ff
#location 00e4: b_l = acc; b_h += 01
ap 02 zap amw ap 03 zap zaj aj 01 maj amw
#
###low byte addition
#
#location 00f0: a_l = a_l + b_l
zap zap zaj maj ap 02 zap maj zap amw
#location 00fa: add a_l, 80; if carry goto 0109
zap zaj maj ap 09 ap 01 aj 80
#location 0103: goto 0114
ap 14 ap 01 aj ff
#location 0109: a_l = acc; a_h += 01
zap zap amw ap 01 zap zaj aj 01 maj amw
#
###high byte addition
#
#location 0114: a_h = a_h + b_h
ap 01 zap zaj maj ap 03 zap maj ap 01
zap amw
#
###a_x final conversion
#
#location 0121: right circular shift a_h
ap 01 zap zaj map ap 02 zaj maj ap 01
zap amw
#location 012e: add a_h + 80; if carry goto 013f
ap 01 zap zaj maj ap 3f ap 01 aj 80
#location 0139: goto 014a
ap 4a ap 01 aj ff
#location 013f: a_h = acc; a_l += 80
ap 01 zap amw zap zap zaj aj 80 maj amw
#
###return function
#
#location 014a:
ap 05 zap zaj maj ap 04 zap map aap
zaj aj ff aj 01
#
#################################
#main function
#location 0159: calling 15 bit addition
zap zap mw 00		# a = 0000
ap 01 zap mw 00
ap 02 zap mw 01		# b = 0001
ap 03 zap mw 00
ap 04 zap mw 7d		# return = 017d
ap 05 zap mw 01
#location 0176
ap ae zap aj ff aj ff
#location 017d: output result
zap zap mow
ap 01 zap mow
#location 0184: goto 0176
ap 76 ap 01 aj ff aj ff
#location 018c