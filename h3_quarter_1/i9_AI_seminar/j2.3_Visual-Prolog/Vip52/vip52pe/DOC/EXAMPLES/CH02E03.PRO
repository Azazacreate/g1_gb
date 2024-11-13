/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH02E03.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  likes(symbol,symbol) - nondeterm (o,i), nondeterm (i,i)

clauses
  likes(ellen,reading).
  likes(john,computers).
  likes(john,badminton).
  likes(leonard,badminton).
  likes(eric,swimming).
  likes(eric,reading).

goal
  likes(Person,reading),
  likes(Person,swimming).