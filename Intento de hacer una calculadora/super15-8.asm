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
#location 00db: goto 00e9
ap e9 zap aj 80
#location 00e0: a_l = acc; a_h += 01
zap amw ap 01 zapaj aj 01 maj amw
#
# high byte addition
#location 00e9: a_h = a_h + b_h
ap 03 zapaj maj
ap 01 zap maj amw
#
# a_x final conversion
#location 00f2: right circular shift a_h
ap 01 zapaj map ap 02 maj
ap 01 zap amw
#location 00fd: add a_h, 80; if carry goto 0109
ap 09 ap 01 aj 80
#location 0103: goto 0111
ap 11 ap 01 aj ff
#location 0109: a_h = acc; a_l += 80
ap 01 zap amw zapaj aj 80 maj amw
#
# b_x final conversion
#location 0111: right circular shift b_h
ap 03 zapaj map ap 02 maj ap 03 zap amw
#location 011d: add b_h, 80; if carry goto 0129
ap 29 ap 01 aj 80
#location 0123: goto 0132
ap 32 ap 01 aj 80
#location 0129: b_h = acc; b_h += 80
ap 03 zap amw ap 02 zap maj amw
#
# return operation
#location 0132:
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
#location 013f: a_h += a_h
ap 01 zapaj maj maj amw
#location 0145: add a_l, 80; if carry goto 0153
zapaj maj ap 53 ap 01 aj 80
#location 014d: goto 015d
ap 5d ap 01 aj 80
#location 0153: a_l = acc; a_h += 1
zap zap amw ap 01 zapaj aj 01 maj amw
#location 015d: a_l += a_l
zap zapaj maj maj amw
#
# return operation
#location 0162:
ap fd zapaj maj ap fc zap
map aap aj ff aj ff
#
#--------------------------------
#--------------------------------
# 15/8 Bit division
# -Little endian
# [0000] a_l
# [0001] a_h
# [0002] b_l
# [0003] b_h
# [0004] temp_a_l
# [0005] temp_a_h
# [0006] temp_b_l
# [0007] temp_b_h
# [0008] temp_c_l
# [0009] temp_c_h
# [000a] temp_d_l
# [000b] temp_d_h
# [00fa] ret_l
# [00fb] ret_h
#l 016f: temp_b_h = 01
ap 07 zap mw 01
#l 0174: temp_a_x = 0000
ap 04 zap zmw
ap 05 zap zmw
#
# while temp_b_h != 00:
#     if (a - b) > 0 then
#l 017c: temp_c_x = a_x
zap zapaj maj ap 08 zap amw
ap 01 zapaj maj ap 09 zap amw
#l 018b: negate a_x
zapaj map ap 01 maj zap zap amw
ap 01 zapaj map ap 01 maj zap amw
#l 019c: add
ap fe zap mw ad
ap ff zap mw 01
ap 91 zap aj ff aj ff
#l 01ad: add a_l, ff; if carry goto 022e
zap zapaj maj ap 2e ap 02 aj ff
zap zap amw
#l 01b9: add a_h, ff; if carry goto 022e
ap 01 zapaj maj ap 2e ap 02 aj ff
ap 01 zap amw
#
#         a = a - b(operation already made)
#         temp_a_x = temp_a_x + temp_b_l
#l 01c7: a_x = temp_c_x
ap 08 zapaj maj zap zap amw
ap 09 zapaj maj ap 01 zap amw
#l 01d6: temp_b_l = b_l
ap 02 zapaj maj ap 06 zap amw
#l 01de: b_l = temp_b_h
ap 07 zapaj maj ap 02 zap amw
#l 01e6: temp_b_h = b_h
ap 03 zapaj maj ap 07 zap amw
#l 01ee: add
ap fe zap mw ff
ap ff zap mw 01
ap 91 zao aj ff aj ff
#l 01ff: b_h = temp_b_h
ap 07 zapaj maj ap 03 zap amw
#l 0207: temp_b_h = b_l
ap 02 zapaj maj ap 07 zap amw
#l 020f: b_l = temp_b_l
ap 06 zapaj maj ap 02 zap amw
#l 0217: a_x = temp_c_x
zap zapaj maj ap 08 zap amw
ap 01 zapaj maj ap 09 zap amw
#l 0226: goto 023d
ap 3d ap 02 aj ff aj ff
#
#undo operation
#l 022e: a_x = temp_c_x
zap zapaj maj ap 08 zap amw
ap 01 zapaj maj ap 09 zap amw
#
#     if (b + b) < a then
#l 023d: temp_d_x = a_x
zap zapaj maj ap 0a zap amw
ap 01 zapaj maj ap 0b zap amw
#l 024c: a_x = b_x
ap 02 zapaj maj zap zap amw
ap 03 zapaj maj ap 01 zap amw
#l 025b: add
ap fe zap mw 36
ap ff zap mw 02
ap 91 zap aj ff aj ff
#l 0236: temp_c_x = a_x
