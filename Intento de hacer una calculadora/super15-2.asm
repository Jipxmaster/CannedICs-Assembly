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
#Left shift table initialization
#-From 0300-03ff
#################################
###counter 	0000
###value 	0001
#location 006b: counter = 00, value = 00
ap 01 zap zmw zap zmw
###### // while counter != ff
#location 0071: (counter, 03) = value
ap 01 zap zaj maj 
zap map ap 03 amw
#location 007b: value += 02
ap 01 zap zaj aj 02
maj amw
#location 0083: counter += 1, if carry goto 0095
zap zaj maj ap 95 zap 
aj 01 zap zap amw 
#location 008e: goto 0071
ap 71 zap aj ff aj ff
#
#right shift table initialization
#-From 0400-04ff
#################################
###counter	0000
###value	0001
#location 0095: counter = 00, value = 00
ap 01 zap zmw zap zmw
###### // while counter != ff
#location 009b: (counter, 04) = value
ap 01 zap zaj maj
zap map ap 04 amw
#location 00a5: counter += 01
zap zap zaj aj 01 maj amw 
#location 00ac: (counter, 04) = value 
ap 01 zap zaj maj
zap map ap 04 amw
#location 00b6: value += 01
ap 01 zap zaj aj 01
maj amw
#location 00be: counter += 01, if carry goto 00d0
zap zaj maj ap d0 zap
aj 01 zap zap amw
#location 00c9: goto 009b
ap 9b zap aj ff aj ff
#
###Main function call
#location 00d0: goto main function 
ap 85 ap 01 aj ff aj ff
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
#location 00d8: a_h = a_h + a_h
ap 01 zap zaj maj maj amw
#location 00df: add a_l, 80; if carry goto 00ed
zap zaj maj ap ed zap aj 80
#location 00e7: goto 00f7
ap f7 zap zaj aj ff
#location 00ed: a_l = acc; a_h += 01
zap amw ap 01 zap zaj aj 01 maj amw
#
###b_x conversion into 15 bit number
#
#location 00f7: b_h = b_h + b_h
ap 03 zap zaj maj maj amw
#location 00fe: add b_l, 80; if carry goto 010f
ap 02 zap zaj maj ap 0f ap 01 aj 80
#location 0109: goto 011b
ap 1b ap 01 aj ff
#location 010f: b_l = acc; b_h += 01
ap 02 zap amw ap 03 zap zaj aj 01 maj amw
#
###low byte addition
#
#location 011b: a_l = a_l + b_l
zap zap zaj maj ap 02 zap maj zap amw
#location 0125: add a_l, 80; if carry goto 0135
zap zaj maj ap 35 ap 01 aj 80
#location 012e: goto 0140
ap 40 ap 01 zaj aj ff
#location 0135: a_l = acc; a_h += 01
zap zap amw ap 01 zap zaj aj 01 maj amw
#
###high byte addition
#
#location 0140: a_h = a_h + b_h
ap 01 zap zaj maj ap 03 zap maj ap 01
zap amw
#
###a_x final conversion
#
#location 014d: right circular shift a_h
ap 01 zap zaj map ap 02 zaj maj ap 01
zap amw
#location 015a: add a_h + 80; if carry goto 016c
ap 01 zap zaj maj ap 6c ap 01 aj 80
#location 0165: goto 0176
ap 76 ap 01 aj ff
#location 016b: a_h = acc; a_l += 80
ap 01 zap amw zap zap zaj aj 80 maj amw
#
###return function
#
#location 0176:
ap 05 zap zaj maj ap 04 zap map aap
zaj aj ff aj 01
#
#################################
#main function
#location 0185: calling 15 bit addition
zap zap mw c5		# a = 1ec5
ap 01 zap mw 1e
ap 02 zap mw 76		# b = 0c76
ap 03 zap mw 0c
ap 04 zap mw a9		# return = 01a9
ap 05 zap mw 01
#location 01a2
ap d8 zap aj ff aj ff
#location 01a9: output result
zap zap mow
ap 01 zap mow
#location 01b0: end of program
ap b0 ap 01 aj ff aj ff