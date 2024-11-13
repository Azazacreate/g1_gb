/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E05.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
	Note that the format strings in this example specify 16bit integers
******************************************************************************/
goal
	A = "one",
	B = 330.12,
	C = 4.3333375,
	D = "one two three",
	writef("A = '%-7' \nB = '%8.1e'\n",A,B),
	writef("A = '%' \nB = '%8.4e'\n",A,B),nl,
	writef("C = '%-7.7g' \nD = '%7.7'\n",C,D),
	writef("C = '%-7.0f' \nD = '%0'\n",C,D),
	writef("char: %c, decimal: %d, octal: %o, hex: %x",'a','a','a','a').
