#location 0000	variable value[0001] = 00
ap	01
ap	00
mw	00
#location 0006	variable counter[0000] = 00
ap	00
mw	00
###### // while a != 255:
#location 000a	load value
ap	01
ap	00
aj	00
aj	ff
maj
#location 0013	ram[01, counter] = value
ap	00
map
ap	01
amw
#location 0019	store value
ap	00
amw
#location 001c	counter += 1; if carry goto 0030
ap	00
aj	00
maj
ap	30
ap	00
aj	01
ap	00
amw
#location 002a	goto 000a
ap	0a
ap	00
aj	ff

###Substract two numbers
#Variables:
#byte		a		0000
#byte		b		0001
#location 0030: a = 6f
ap 00 ap 00 mw 6f
#location 0036: b = 1f
ap 01 ap 00 mw 1f

### The unsigned substraction operation takes 
### 34 bytes and 21 machine cycles or 42 clock cycles
### Theoretical substractions per second at 4 MHz: 95238
#location 003c: a = not(a)
ap 00 ap 00 map ap 01 aj 00 maj ap 00 ap 00 amw
#location 004b: a = a + b
ap 01 ap 00 maj ap 00 amw 
#location 0053: a = not(a)
aap ap 01 aj 00 maj ap 00 ap 00 amw


#location 005e: output a
ap 00 ap 00 mow 
#location 0063: goto 0063
ap 63 ap 00 aj 00 aj ff aj 01