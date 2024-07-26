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
#-From 0300-03ff
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
zap zaj maj ap 71 ap 02
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
###carry        0004
###return_l		00fe
###return_h		00ff
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
ap 01 zap zaj maj ap 24 ap 01 aj 80
#location 011a: c_flag = 00
ap 04 zap zmw
#location 011e: goto 0129
ap 29 ap 01 aj ff
#location 0124: c_flag = ff
ap 04 zap mw ff
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
###b_x final conversion
#
#location 0150: right circular shift b_h
ap 03 3f map ap 02 maj ap 03 zap amw
#location 015b: add b_h + 80; if carry goto 016b
ap 03 3f maj ap 6b ap 01 aj 80
#location 0165: goto 0174
ap 74 ap 01 aj 80
#location 016b: b_h = acc; b_l += 80
ap 03 zap amw ap 02 zap maj amw 
#
###return function
#
#location 0174:
ap ff zap zaj maj ap fe zap map aap
zaj aj ff aj 01
###
#
#16 bit left shift
#-little endian
#################################
###a_l		0000
###a_h		0001
###return_l	00fc
###return_h	00fd
#
###main operation
#
#location 0183: a_h += a_h
ap 01 zap zaj maj maj amw 
#location 018a: add a_l, 80; if carry goto 0199
zap zaj maj ap 99 ap 01 aj 80
#location 0193: goto 01a4
ap a4 ap 01 aj ff
#location 0199: a_l = acc; a_h += 1
zap zap amw ap 01 zap zaj aj 01 maj amw
#location 01a4: a_l += a_l
zap zap zaj maj maj amw
#
###return operation
#
#location 01aa: return
ap fd zap zaj maj ap fc zap map aap
aj ff aj 01
###
#
#15/8 bit multiplication 
#-little endian
#################################
###a_l      0000
###a_h      0001
###b_l      0002
###b_h      0003
###overflow 0005
###temp_a_l 0006
###temp_a_h 0007
###repeater 0008
###temp_b_l 0009
###return_l 00fa
###return_h 00fb
#
###assignating initial variables
#
#location 01b8: repeater = f8
ap 08 zap mw f8
#location 01bd: temp_a = 0000
ap 06 zap zmw
ap 07 zap zmw
#
###while repeater != 00
#
#location 01c5: right_circular_shift(b_l)
ap 02 3f map ap 02 maj ap 02 zap amw
#location 01d0: add b_l, 80; if carry goto 01e0
ap 02 3f maj ap e0 ap 01 aj 80
#location 01da: goto 0240
ap 40 ap 02 aj 80
#
###temp_a_x = temp_a_x + a_x
#
#location 01e0: temp_b_l = b_l
ap 02 3f maj ap 09 zap amw
#location 01e8: b_x = a_x
zap 3f maj ap 02 zap amw
ap 01 3f maj ap 03 zap amw
#location 01f7: a_x = temp_a_x
ap 06 3f maj zap amw
ap 07 3f maj ap 01 zap amw
#location 0205: add a_x, b_x
ap fe zap mw 16
ap ff zap mw 02
ap 9f zap aj ff aj ff
#location 0216: temp_a_x = a_x
zap 3f maj ap 06 zap amw
ap 01 3f maj ap 07 zap amw
#location 0225: a_x = b_x
ap 02 3f maj zap amw
ap 03 3f maj ap 01 zap amw
#location 0233: b_l = temp_b_l; b_h = 00
ap 03 zap mw 00
ap 09 3f maj ap 02 zap amw
#
###end of addition
#
#location 0240: shift left a_x
ap fc zap mw 52
ap fd zap mw 02
ap 83 ap 01 aj ff aj ff
#location 0252: repeater += 01; if carry goto 0266
ap 08 3f maj ap 66 ap 02 aj 01 ap 08 zap amw
#location 0260: goto 01c5
ap c5 ap 01 aj ff
#
###end of while loop
#
#location 0266: returning operation
ap fb 3f maj ap fa zap map
aap aj ff
#
########MAIN FUNCTION######
#
###multiply 21 and 3dec
#
#location 0271: a = 003f
zap zap mw 3f
ap 01 zap mw 00
#location 027a: b = 004e
ap 02 zap mw 4e
ap 03 zap mw 00
#location 0284: return = 0296
ap fa zap mw 96
ap fb zap mw 02
#location 028e: goto multiply
ap b8 ap 01 aj ff aj ff
#
###output end of program
#
#location 0296: end
ap 96 ap 02 aj ff aj ff 
#location 029e
#