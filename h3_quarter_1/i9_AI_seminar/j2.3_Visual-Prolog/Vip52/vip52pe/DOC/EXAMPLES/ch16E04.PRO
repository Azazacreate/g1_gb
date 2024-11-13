/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH16E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  d = integer

predicates
  not_(D,D) - nondeterm (o,o)
  and_(D,D,D) - nondeterm (i,i,o)
  or_(D,D,D) - nondeterm (i,i,o)
  xor(D,D,D) - nondeterm (o,o,o)

clauses
  not_(1,0).      not_(0,1).
  and_(0,0,0).    and_(0,1,0).
  and_(1,0,0).    and_(1,1,1).
  or_(0,0,0).     or_(0,1,1).
  or_(1,0,1).     or_(1,1,1).

  xor(Input1,Input2,Output):-
	not_(Input1,N1),
	not_(Input2,N2),
	and_(Input1,N2,N3),
	and_(Input2,N1,N4),
	or_(N3,N4,Output).

goal
  xor(Input1,Input2,Output).
