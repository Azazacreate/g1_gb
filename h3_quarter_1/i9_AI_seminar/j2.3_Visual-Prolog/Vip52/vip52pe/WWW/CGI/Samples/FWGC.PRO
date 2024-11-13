/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  FWGC
 FileName: FWGC.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:

 A farmer with his goat, wolf and cabbage come to a river that they
 wish to cross. There is a boat, but it only has room for two, and
 the farmer is the only one that can row. If the goat and cabbage
 get in the boat at the same time, the cabbage gets eaten.
 Similarly, if the wolf and goat are together without the farmer,
 the goat is eaten. Devise a series of crossings of the river so that all
 concerned make it across safely.

 The state of the system is indicated by a structure STATE stating where
 the farmer, the goat the wolf and the cabbage are located. The goal is then
 how to transform the start state to the endstate through a series of valid
 states.

 The valid states are checked by the predicate 'unsafe'

 The problem is that a state must only be visited once, this is handled by
 collecing the visited stetes in a list, and checking that a new state is
 not already in the list.

 The Predicate "go" can be called with a start state and a final state

  go( state(east,east,east,east), state(west,west,west,west) ).
******************************************************************************/

DOMAINS
  LOC   = east ; west
  STATE = state(LOC farmer,LOC wolf,LOC goat,LOC cabbage)
  PATH  = STATE*
  
PREDICATES
  go(STATE,STATE)		% Start of the algorithm
  path(STATE,STATE,PATH,PATH)	% Finds a path from one state to another
  nondeterm move(STATE,STATE)	% Transfer a system from one side to another
  opposite(LOC,LOC)		% Gives a location on the opposite side
  nondeterm unsafe(STATE)	% Gives the unsafe states
  nondeterm member(STATE,PATH)	% Checks if the state is already visited
  write_path(PATH)
  write_move(STATE,STATE)

GOAL        
	write("Content-type: text/html\n\n"),
        write("<html>\n"),
        write("<body>\n"),

	go(state(east,east,east,east),state(west,west,west,west)),
	write ("<p>Solved\n"),
	
	write("</body>\n"),
	write("</html>\n").

CLAUSES
  go(StartState,GoalState):-
  	path(StartState,GoalState,[StartState],Path),
  	write("<p>A solution is:\n"),
  	write_path(Path).

  path(StartState,GoalState,VisitedPath,Path):-
	move(StartState,NextState),			% Find a move
	not( unsafe(NextState) ),			% Check that it is not unsage
	not( member(NextState,VisitedPath) ),		% Check that we have not had this situation before
	path( NextState,GoalState,[NextState|VisitedPath],Path),!.
  path(GoalState,GoalState,Path,Path).			% The final state is reached
                       
  move(state(X,X,G,C),state(Y,Y,G,C)):-opposite(X,Y). % Move FARMER + WOLF
  move(state(X,W,X,C),state(Y,W,Y,C)):-opposite(X,Y). % Move FARMER + GOAT
  move(state(X,W,G,X),state(Y,W,G,Y)):-opposite(X,Y). % Move FARMER + CABBAGE
  move(state(X,W,G,C),state(Y,W,G,C)):-opposite(X,Y). % Move ONLY FARMER

  opposite(east,west).
  opposite(west,east).

  unsafe( state(F,X,X,_) ):- opposite(F,X),!.  % The wolf eats the goat
  unsafe( state(F,_,X,X) ):- opposite(F,X),!.  % The goat eats the cabbage
  
  member(X,[X|_]):-!.
  member(X,[_|L]):-member(X,L).

  write_path( [] ).
  write_path([H1,H2]) :-!,
  	write_move(H1,H2).
  write_path( [H1,H2|T] ) :-
	write_move(H1,H2),
	write_path([H2|T]).

  write_move( state(X,W,G,C), state(Y,W,G,C) ) :-!,
    write("<br>The farmer crosses the river from ",X," to ",Y),nl.
  write_move( state(X,X,G,C), state(Y,Y,G,C) ) :-!,
    write("<br>The farmer takes the Wolf from ",X," of the river to ",Y),nl.
  write_move( state(X,W,X,C), state(Y,W,Y,C) ) :-!,
    write("<br>The farmer takes the Goat from ",X," of the river to ",Y),nl.
  write_move( state(X,W,G,X), state(Y,W,G,Y) ) :-!,
    write("<br>The farmer takes the cabbage from ",X," of the river to ",Y),nl.

