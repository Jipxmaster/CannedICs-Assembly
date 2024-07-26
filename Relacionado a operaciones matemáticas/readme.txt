RAM memory map:
+---------------------------------+
| Zero page		0000-00ff |
| Not table		0100-01ff |
| Circular right shift	0200-02ff |
| Right shift		0300-03ff |
+---------------------------------+

Math rom memory map	Call addr	Ret addr
Table initialization	Reset[0000]
14 bit addition		0091		0e 0f
14 bit rotate left	00e1		10 11
14 bit rotate right	0138		12 13
14 bit multiplication	01a0		14 15
14 bit division		02e3		16 17