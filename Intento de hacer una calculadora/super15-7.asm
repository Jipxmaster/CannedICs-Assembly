#--------------------------------
#--------------------------------
# Not table initialization
# -From 0100-01ff
# [0000] counter
# [0001] value
#location 0000: value = ff, counter = 00
ap 01 zap mw ff zap zmw
#
# while (counter + 1) != carry
#location 0007: (counter, 01) = value
ap 01 zapaj maj
zap map ap 01 amw
#location 0010: value -= 1
zapaj aj ff maj amw
#location 0015: counter += 1; if carry goto 0023
zapaj maj ap 23 zap
aj 01 zap amw
#location 001e: goto 0007
ap 07 zap aj ff
#--------------------------------
#--------------------------------
# Right circular shift table
# -From 0200-02ff
# [0000] counter
# [0001] value
#location 0023: counter = 00, value = 00
ap 01 zap zmw zap zmw
#
# while (counter + 1) != carry
#location 0029: (counter, 02) = value
ap 01 zapaj maj
zap map ap 02 amw
#location 0032: value += 80
ap 01 zapaj
aj 80 maj amw
#location 0039: counter += 1
zapaj aj 01 maj amw
#location 003e: (counter, 02) = value
ap 01 zapaj maj
zap map ap 02 amw
#location 0047: value += 81
ap 01 zapaj aj 81
maj amw
#location 004e: counter += 1; if carry goto 005c
zapaj maj ap 5c zap
aj 01 zap amw
#location 0057: goto 0029
ap 29 zap aj ff
#--------------------------------
#--------------------------------
# Right shift table
# -From 0300-03ff
# [0000] counter
# [0001] value
#location 005c: counter = 00, value = 00
ap 01 zap zmw zap zmw
#
#while (counter + 1) != carry
#location 0062: (counter, 03) = value
ap 01 zapaj maj
zap map ap 03 amw
#location 006b: counter += 01
zap zapaj aj 01 maj amw
#location 0071: (counter, 03) = value
ap 01 zapaj maj
zap map ap 03 amw
#location 007a: value += 1
ap 01 zapaj aj 01 maj amw     ### MAIN FUNCTION ADDRESS ###
#location 0081: counter += 1; if carry goto 023f ##########
zapaj maj ap 3f ap 02
aj 01 zap zap amw
#location 008c: goto 0062
ap 62 zap aj ff
#--------------------------------
#--------------------------------
# 15 Bit addition
# -Little endian
# [0000] a_l
# [0001] a_h
# [0002] b_l
# [0003] b_h
# [00fe] ret_l
# [00ff] ret_h
#
# a_x conversion to super15 format
#location 0091: a_h = a_h + a_h
ap 01 zapaj maj maj amw
#location 0097: add a_l, 80; if carry goto 00a3
zapaj maj ap a3 zap aj 80
#location 009e: goto 00ac
ap ac zap aj 80
#location 00a3: a_l = acc; a_h += 01
zap amw ap 01 zap aj 01 maj amw
#
# b_x conversion to super15 format
#location 00ac: b_h = b_h + b_h
ap 03 zapaj maj maj amw
#location 00b2: add b_l, 80; if carry goto 00c0
ap 02 zapaj maj ap c0 zap aj 80
#location 00bb: goto 00cb
ap cb zap aj 80
#location 00c0: b_l = acc; b_h += 01
ap 02 zap amw ap 03 zap aj 01 maj amw
#
# low byte addition
#location 00cb: a_l = a_l + b_l
zap zapaj maj ap 02 zap maj zap amw
#location 00d4: add a_l, 80; if carry goto 00e0
zapaj maj ap e0 zap aj 80
#location 00db: goto 00ea
ap ea zap aj 80
#location 00e0: a_l = acc; a_h += 01
zap zap amw ap 01 zapaj aj 01 maj amw
#
# high byte addition
#location 00ea: a_h = a_h + b_h
ap 03 zapaj maj
ap 01 zap maj amw
#
# a_x final conversion
#location 00f3: right circular shift a_h
ap 01 zapaj map ap 02 maj
ap 01 zap amw
#location 00fe: add a_h, 80; if carry goto 010e
ap 01 zapaj maj ap 0e
ap 01 aj 80
#location 0108: goto 0117
ap 17 ap 01 aj ff
#location 010e: a_h = acc; a_l += 80
ap 01 zap amw zapaj aj 80 maj amw
#
# b_x final conversion
#location 0117: right circular shift b_h
ap 03 zapaj map ap 02 maj ap 03 zap amw
#location 0122: add b_h, 80; if carry goto 0132
ap 03 zapaj maj ap 32 ap 01 aj 80
#location 012c: goto 013b
ap 3b ap 01 aj 80
#location 0132: b_h = acc; b_h += 80
ap 03 zap amw ap 02 zap maj amw
#
# return operation
#location 013b:
ap ff zapaj maj ap fe zap map
aap aj ff aj ff
#
#--------------------------------
#--------------------------------
# 16 Bit left shift
# -Little endian
# [0000] a_l
# [0001] a_h
# [00fc] ret_l
# [00fd] ret_h
#location 0148: a_h += a_h
ap 01 zapaj maj maj amw
#location 014e: add a_l, 80; if carry goto 015c
zapaj maj ap 5c ap 01 aj 80
#location 0156: goto 0166
ap 66 ap 01 aj 80
#location 015c: a_l = acc; a_h += 1
zap zap amw ap 01 zapaj aj 01 maj amw
#location 0166: a_l += a_l
zap zapaj maj maj amw
#
# return operation
#location 016b:
ap fd zapaj maj ap fc zap
map aap aj ff aj ff
#
#--------------------------------
#--------------------------------
# 15/8 Bit multiplication
# -Little endian
# [0000] a_l
# [0001] a_h
# [0002] b_l
# [0003] b_h
# [0004] temp_a_l
# [0005] temp_a_h
# [0006] repeater
# [0007] temp_h_l
# [00fa] ret_l
# [00fb] ret_h
#
# assignating initial variables
#location 0178: repeater = f8
ap 06 zap mw f8
#location 017d: temp_a = 0000
ap 04 zap zmw
ap 05 zap zmw
#
# while repeater != 00
#location 0185: right_circular_shift(b_l)
ap 02 3f map ap 02 maj ap 02 zap amw
#location 0190: add b_l, 80; if carry goto 01a0
ap 02 3f maj ap a0 ap 01 aj 80
#location 019a: goto 0200
ap 00 ap 02 aj 80
#
# temp_a_x = temp_a_x + a_x
#location 01a0: temp_b_l = b_l
ap 02 3f maj ap 07 zap amw
#location 01a8: b_x = a_x
zap 3f maj ap 02 zap amw
ap 01 3f maj ap 03 zap amw
#location 01b7: a_x = temp_a_x
ap 04 3f maj zap amw
ap 05 3f maj ap 01 zap amw
#location 01c5: add a_x, b_x
ap fe zap mw d6
ap ff zap mw 01
ap 91 zap aj ff aj ff
#location 01d6: temp_a_x = a_x
zap 3f maj ap 04 zap amw
ap 01 3f maj ap 05 zap amw
#location 01e5: a_x = b_x
ap 02 3f maj zap amw
ap 03 3f maj ap 01 zap amw
#location 01f3: b_l = temp_b_l; b_h = 00
ap 03 zap mw 00
ap 07 3f maj ap 02 zap amw
#
# end of addition
#location 0200: shift left a_x
ap fc zap mw 12
ap fd zap mw 02
ap 48 ap 01 aj ff aj ff
#location 0212: repeater += 01; if carry goto 0226
ap 06 3f maj ap 26 ap 02 aj 01 ap 06 zap amw
#location 0220: goto 0185
ap 85 ap 01 aj ff
#
# end of while loop
#location 0226: a_x = temp_a_x
ap 04 zapaj maj zap amw
ap 05 zapaj maj ap 01 zap amw
#location 0234: returning operation
ap fb 3f maj ap fa zap map
aap aj ff
#
########MAIN FUNCTION######
#
###multiply 21 and 3dec
#
#location 023f: a = 003f
zap zap mw 3f
ap 01 zap mw 00
#location 0248: b = 004e
ap 02 zap mw 4e
ap 03 zap mw 00
#location 0252: return = 0264
ap fa zap mw 64
ap fb zap mw 02
#location 025c: goto multiply
ap 78 ap 01 aj ff aj ff
#
###output end of program
#
#location 0264: end
aj ff
#location 0266
#