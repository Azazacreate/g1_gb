/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH03E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  phone_number(symbol,symbol) - nondeterm (i,o)

clauses
  phone_number("Albert","EZY-3665").
  phone_number("Betty","555-5233").
  phone_number("Carol","909-1010").
  phone_number("Dorothy","438-8400").

goal
  phone_number("Carol",Number).
	