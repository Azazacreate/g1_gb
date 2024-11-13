/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH16E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  town     = symbol
  distance = integer

predicates
  road(town,town,distance) - nondeterm (i,o,o), nondeterm (i,i,o)
  route(town,town,distance) - nondeterm (i,i,o)

clauses
  road(tampa,houston,200).
  road(gordon,tampa,300).
  road(houston,gordon,100).
  road(houston,kansas_city,120).
  road(gordon,kansas_city,130).

  route(Town1,Town2,Distance):-
	road(Town1,Town2,Distance).
  route(Town1,Town2,Distance):-
	road(Town1,X,Dist1),
	route(X,Town2,Dist2),
	Distance=Dist1+Dist2,
	!.

goal
  route(tampa,kansas_city,X).