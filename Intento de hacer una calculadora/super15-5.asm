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
#location 0017: counter += 1; if carry goto 0027
zap zaj maj ap 27 zap 
aj 01 ap 00 amw
#location 0022: goto 0007
ap 07 zap aj ff
#
#Circular right shift table 
#initialization
#-From 0200-02ff
#################################
###counter 	0000
###value	0001
#location 0027: counter = 00, value = 00
ap 01 zap zmw zap zmw
###### // while counter != ff
#location 002d: (counter, 02) = value
ap 01 zap zaj maj 
zap map ap 02 amw
#location 0037: value += 80
ap 01 zap zaj aj 80
maj amw
#location 003f: counter += 01
zap zaj aj 01 maj amw
#location 0045: (counter, 02) = value
ap 01 zap zaj maj 
zap map ap 02 amw
#location 004f: value += 81
ap 01 zap zaj aj 81
maj amw
#location 0057: counter += 01; if carry goto 0066
zap zaj maj ap 66 zap
aj 01 zap amw
#location 0061: goto 002d
ap 2d zap aj ff
#
#right shift table initialization
#-From 0400-04ff
#################################
###counter	0000
###value	0001
#location 0066: counter = 00, value = 00
ap 01 zap zmw zap zmw
###### // while counter != ff
#location 006c: (counter, 03) = value
ap 01 zap zaj maj
zap map ap 03 amw
#location 0076: counter += 01
zap zap zaj aj 01 maj amw 
#location 007d: (counter, 03) = value 
ap 01 zap zaj maj
zap map ap 03 amw
#location 0087: value += 01
ap 01 3f aj 01 maj amw
#location 008e: counter += 01, if carry goto ###### main function ######
zap zaj maj ap 94 ap 01
aj 01 zap zap amw
#location 009a: goto 006c
ap 6c zap aj ff
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
#location 009f: a_h = a_h + a_h
ap 01 zap zaj maj maj amw
#location 00a6: add a_l, 80; if carry goto 00b3
zap zaj maj ap b3 zap aj 80
#location 00ae: goto 00bd
ap bd zap aj ff
#location 00b3: a_l = acc; a_h += 01
zap amw ap 01 zap zaj aj 01 maj amw
#
###b_x conversion into 15 bit number
#
#location 00bd: b_h = b_h + b_h
ap 03 zap zaj maj maj amw
#location 00c4: add b_l, 80; if carry goto 00d3
ap 02 zap zaj maj ap d3 zap aj 80
#location 00ce: goto 00df
ap df zap aj ff
#location 00d3: b_l = acc; b_h += 01
ap 02 zap amw ap 03 zap zaj aj 01 maj amw
#
###low byte addition
#
#location 00df: a_l = a_l + b_l
zap zap zaj maj ap 02 zap maj zap amw
#location 00e9: add a_l, 80; if carry goto 00f7
zap zaj maj ap f7 zap aj 80
#location 00f1: goto 0102
ap 02 ap 01 aj ff
#location 00f7: a_l = acc; a_h += 01
zap zap amw ap 01 zap zaj aj 01 maj amw
#
###high byte addition
#
#location 0102: a_h = a_h + b_h
ap 01 zap zaj maj ap 03 zap maj ap 01
zap amw
#
###carry detection
#
#location 010f: add a_h, 80, if carry goto 0124
ap 01 zap zaj maj ap 20 ap 01 aj 80
#location 011a: c_flag = 00
ap 06 zap zmw
#location 011e: goto 0129
ap 29 ap 01 aj ff
#location 0124: c_flag = ff
ap 06 zap mw ff
#
###a_x final conversion
#
#location 0129: right circular shift a_h
ap 01 zap map ap 02 zaj maj ap 01
zap amw
#location 0135: add a_h + 80; if carry goto 0146
ap 01 zap zaj maj ap 46 ap 01 aj 80
#location 0140: goto 0150
ap 50 ap 01 aj ff
#location 0146: a_h = acc; a_l += 80
ap 01 zap amw zap zaj aj 80 maj amw
#
###return function
#
#location 0150:
ap 05 zap zaj maj ap 04 zap map aap
zaj aj ff aj 01
###
#
#16 bit left shift
#-little endian
#################################
###a_l		0000
###a_h		0001
###return_l	0004
###return_h	0005
#
###main operation
#
#location 015f: a_h += a_h
ap 01 zap zaj maj maj amw 
#location 0166: add a_l, 80; if carry goto 0175
zap zaj maj ap 75 ap 01 aj 80
#location 016f: goto 0180
ap 80 ap 01 aj ff
#location 0175: a_l = acc; a_h += 1
zap zap amw ap 01 zap zaj aj 01 maj amw
#location 0180: a_l += a_l
zap zap zaj maj maj amw
#
###return operation
#
#location 0185: return
ap 05 zap zaj maj ap 04 zap map aap
aj ff aj 01
#################################
#main function
#location 0194: calling 15 bit addition
zap zap mw 00		# a = 0000
ap 01 zap mw 00
ap 02 zap mw 01		# b = 0001
ap 03 zap mw 00
#locatioin 01a7
ap 04 zap mw b8		# return = 01b8
ap 05 zap mw 01
#location 01b1
ap 9f zap aj ff aj ff
#location 01b8: 16 bit left shift 
ap 04 zap mw ca     # return = 01ca
ap 05 zap mw 01
#location 01c2
ap 5f ap 01 aj ff aj ff
#location 01ca: output a
zap zap mow ap 01 zap mow
#location 01d1: goto 01a7
ap a7 ap 01 aj ff aj ff