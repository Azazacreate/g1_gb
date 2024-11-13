/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: MYDOM.PRO
 Purpose: 
 Written by: PDC
 Comments: 
******************************************************************************/
project "mydom"

global domains
   mydom = i(integer); c(char); s(string)

global predicates
   determ make_mydom(mydom) - (o) language C

goal
	make_mydom(MD), write(MD), nl.
