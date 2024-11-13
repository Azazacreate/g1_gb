/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  HARDWARE
 FileName: HARDWARE.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

domains
  d = integer

predicates
  not_(D,D)
  and_(D,D,D)
  or_(D,D,D)
  xor_(D,D,D)

clauses
  not_(1,0).
  not_(0,1).
  and_(0,0,0).
  and_(0,1,0).
  and_(1,0,0).
  and_(1,1,1).
  or_(0,0,0).
  or_(0,1,1).
  or_(1,0,1).
  or_(1,1,1).

  % See the documentarion for the XOR circuit
  xor_(Input1,Input2,Output):-
	not_(Input1,N1),
	not_(Input2,N2),
	and_(Input1,N2,N3),
	and_(Input2,N1,N4),
	or_(N3,N4,Output).

goal	
  xor_(Input1,Input2,Output),   % Use GOAL mode to see results !!!
  format(Msg," xor_(%,%,%)",Input1,Input2,Output),
  write(Msg).