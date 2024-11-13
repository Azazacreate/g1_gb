/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH16E03.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  room     =  symbol
  roomlist = room*

predicates
  gallery(room,room) - nondeterm (i,o),	nondeterm (o,i)	/* There is a gallery between two rooms */
  neighborroom(room,room) - nondeterm (i,o)		/* Necessary because it does not matter */
							/* which direction you go along a gallery */
  avoid(roomlist) - procedure (o)
  go(room,room) - nondeterm (i,i)
  route(room,room,roomlist) - nondeterm (i,i,i)		/* This is the route to be followed. */
							/* roomlist consists of a list of rooms already visited. */
  member(room,roomlist) - nondeterm (i,i)

clauses
  gallery(entry,monsters).              gallery(entry,fountain).
  gallery(fountain,hell).         	gallery(fountain,food).
  gallery(exit,gold_treasure).    	gallery(fountain,mermaid).
  gallery(robbers,gold_treasure). 	gallery(fountain,robbers).
  gallery(food,gold_treasure).    	gallery(mermaid,exit).
  gallery(monsters,gold_treasure).	gallery(gold_treasure,exit).

  neighborroom(X,Y):-gallery(X,Y).
  neighborroom(X,Y):-gallery(Y,X).

  avoid([monsters,robbers]).

  go(Here,There):-route(Here,There,[Here]).
  go(_,_).

  route(Room,Room,VisitedRooms):-
	member(gold_treasure,VisitedRooms),
	write(VisitedRooms),nl.
  route(Room,Way_out,VisitedRooms):-
	neighborroom(Room,Nextroom),
	avoid(DangerousRooms),
	not(member(NextRoom,DangerousRooms)),
	not(member(NextRoom,VisitedRooms)),
	route(NextRoom,Way_out,[NextRoom|VisitedRooms]).

  member(X,[X|_]).
  member(X,[_|H]):-member(X,H).

goal
  go(entry,exit).
