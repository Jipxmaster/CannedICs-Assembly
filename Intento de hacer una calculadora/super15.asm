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
#location 0081: counter += 1; if carry goto 0193 ##########
zapaj maj ap 93 ap 01
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
# [0004] carry
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
zap amw ap 01 zapaj aj 01 maj amw
#
# b_x conversion to super15 format
#location 00ac: b_h = b_h + b_h
ap 03 zapaj maj maj amw
#location 00b2: add b_l, 80; if carry goto 00c0
ap 02 zapaj maj ap c0 zap aj 80
#location 00bb: goto 00cb
ap cb zap aj 80
#location 00c0: b_l = acc; b_h += 01
ap 02 zap amw ap 03 zapaj aj 01 maj amw
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
ap 01 zapaj maj ap 03
zapja ap 01 zap amw
#
# carry detection
#location 00f5: add a_h, 80; if carry goto 0109
ap 01 zapaj maj ap 09 ap 01 aj 80
#location 00ff: carry = 00
ap 04 zap zmw
#location 0103: goto 010e
ap 0e ap 01 aj 80
#location 0109: carry = ff
ap 04 zap mw ff
#
# a_x final conversion
#location 010e: right circular shift a_h
ap 01 zapaj map ap 02 maj
ap 01 zap amw
#location 0119: add a_h, 80; if carry goto 0129
ap 01 zapaj maj ap 29
ap 01 aj 80
#location 0123: goto 0132
ap 32 ap 01 aj ff
#location 0129: a_h = acc; a_l += 80
ap 01 zap amw zapaj aj 80 maj amw
#
# b_x final conversion
#location 0132: right circular shift b_h
ap 03 zapaj map ap 02 maj ap 03 zap amw
#location 013d: add b_h, 80; if carry goto 014d
ap 03 zapaj maj ap 4d ap 01 aj 80
#location 0147: goto 0156
ap 56 ap 01 aj 80
#location 014d: b_h = acc; b_h += 80
ap 03 zap amw ap 02 zap maj amw
#
# return operation
#location 0156:
ap ff zapaj maj ap fe zap map
aap aj ff aj ff
#--------------------------------
#--------------------------------
# 16 Bit left shift
# -Little endian
# [0000] a_l
# [0001] a_h
# [00fc] ret_l
# [00fd] ret_h
#location 0163: a_h += a_h
ap 01 zapaj maj maj amw
#location 0169: add a_l, 80; if carry goto 0177
zapaj maj ap 77 ap 01 aj 80
#location 0171: goto 0181
ap 81 ap 01 aj 80
#location 0177: a_l = acc; a_h += 1
zap zap amw ap 01 zapaj aj 01 maj amw
#location 0181: a_l += a_l
zap zapaj maj maj amw
#
# return operation
#location 0186:
ap fd zapaj maj ap fc zap
map aap aj ff aj ff
#--------------------------------
#--------------------------------
# 15/8 Bit multiplication
# -Little endian
# [0000] a_l
# [0001] a_h
# [0002] b_l
# [0003] b_h
# [0005] overflow
# [0006] temp_a_l
# [0007] temp_a_h
# [0008] repeater
# [0009] temp_h_l
# [00fa] ret_l
# [00fb] ret_h
#location 0193: add 0eea, 7b95
ap 00 zap mw ea
ap 01 zap mw 0e
ap 02 zap mw 7b
ap 03 zap mw 95
ap fe zap mw b8
ap ff zap mw 01
#location 01b1: goto add
ap 91 zap aj ff aj ff
#location 01b8: end of program
aj ff aj ff