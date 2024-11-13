/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH02E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  likes(symbol,symbol) - nondeterm (i,i)

clauses
  likes(ellen,tennis).
  likes(john,football).
  likes(tom,baseball).
  likes(eric,swimming).
  likes(mark,tennis).
  likes(bill,Activity):-
	likes(tom, Activity).

goal
  likes(bill,baseball).
