/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  ZEBRA
 FileName: ZEBRA.PRO

  A PROLOG program to solve the "5 houses" problem
  using a "verify and choose" method.
  A candidate solution is any of the (5!)**5 ways of distributing 5 colours,
  5 drinks, 5 nationalities, 5 cigarettes, and 5 pets amongst 5 houses.
  By Lewis Baxter

  There are five houses with five different colours, in each house lives a person of
  different nationality having favorite drinks, cigaretes and pets, the information is:
	The Englishman lives in the red house
	The Spaniard owns the dog
	The Norwegian lives in the first house on the lleft
	Kools are smoked in the yellow house.
	The man who smokes Chesterfields lives in the house
	next to the man with the fox.
	The Norwegian lives next to the blue house
	The Winston smoker owns snails.
	The lucky strike smoker drinks orange juice
	The Ukrainian drinks tea
	The Japanese smokes parliaments
	Kools are smoked in the house next to the house where the horse is kept.
	Coffee is drunk in the green house
	The green house is immediately to the right (your right) of the ivory house
	Milk is drunk in the middle house.
  The question is then: Where does the zebra live, and in which house do they
  drink water ?

Drinks		Pets	Cigarettes	Nations		Colours
----------------------------------------------------------------------------
  water		zebra	kools		englishman	ivory
  tea		fox	chesterfields	norvegian	green
  cofee		dog	lucky_strike	ukrainian	blue
  milk		horse	parliaments	japanese	yellow
  orange_juice	snails	winston		spaniard	red

******************************************************************************/

GLOBAL DOMAINS
  IDENT = symbol
  HOUSE = h(IDENT,NO)		% A house is identified by a number
  HLIST  = reference HOUSE*	% A list of houses
  NO = INTEGER			% HOUSE Number
  NOLIST = NO*
  CHARLIST = CHAR*
  CHARLISTS = CHARLIST*

DATABASE - houses
  the_house (symbol Color,
             symbol Cigar,
             symbol Nation,
             symbol Drink,
             symbol Pet)
         
  color (symbol)

PREDICATES
  nondeterm solve
  nondeterm candidate(HLIST,HLIST,HLIST,HLIST,HLIST)
  nondeterm perm(HLIST)
  nondeterm constraints(HLIST,HLIST,HLIST,HLIST,HLIST)
  nondeterm permutation(NOLIST,NOLIST)
  nondeterm delete(NO,NOLIST,NOLIST)
  nondeterm next(NO,NO)
  nondeterm lleft(NO,NO)
  nondeterm member(HOUSE,HLIST)

GOAL	
	write("Content-type: text/html\n\n"),
        write("<html>\n"),
        write("<body>\n"),

	solve,
	
	write("</body>\n"),
	write("</html>\n").

CLAUSES
solve() :-
	constraints(Colours,Drinks,Nationalities,Cigarettes,Pets),
	candidate(Colours,Drinks,Nationalities,Cigarettes,Pets),
	write ("<table border>\n"),
	write ("<tr><th>House<th>Pet<th>Drink<th>Nationality<th>Cigarettes</tr>\n"),
	
	member(h(water,WaterHouse), Drinks),member(h(_WaterColour,WaterHouse), Colours),
	member(h(zebra,ZebraHouse), Pets),member(h(_ZebraColour,ZebraHouse), Colours),
	%write("<p>They drink vodka in the ",WaterColour," house\n"),
	%write("<p>The parrot lives in the ",ZebraColour," house\n"),
	
	color(ColToTest),
	 member(h(ColToTest,TestHouse),Colours),
	 member(h(Pet,TestHouse),Pets),
	 member(h(Cigar,TestHouse),Cigarettes),
	 member(h(Drink,TestHouse),Drinks),
	 member(h(Nation,TestHouse),Nationalities),
	 write("<tr><td>",ColToTest,"<td>",Pet,"<td>",Drink,"<td>",Nation,"<td>",Cigar,"</tr>\n"),
	 %write("<p>House:",ColToTest," Pet:",Pet,"\n"),
	fail.
solve() :-
	write ("</table>\n").
	

color(red). color(yellow). color(blue). color(green). color(ivory).

candidate(L1, L2, L3, L4, L5) :-
	perm(L1),perm(L2),perm(L3),perm(L4),perm(L5).

perm([h(_,A),h(_,B),h(_,C),h(_,D),h(_,E)]) :-
	permutation([A,B,C,D,E],[1,2,3,4,5]). 

constraints(Colours, Drinks, Nationalities, Cigarettes, Pets)  :- 
	% The Englishman lives in the red house
	member(h(englishman,H1), Nationalities),
	member(h(red,H1), Colours),
	% The Spaniard owns the dog
	member(h(spaniard,H2), Nationalities),
	member(h(dog,H2), Pets),
	% The Norwegian lives in the first house on the lleft
	member(h(norwegian,1), Nationalities),
	% Kools are smoked in the yellow house.
	member(h(kools,H3), Cigarettes),
	member(h(yellow,H3), Colours),
	% The man who smokes Chesterfields lives in the house
	% next to the man with the fox.
	member(h(chesterfields,H4), Cigarettes),
	next(H4, H5),
	member(h(fox,H5), Pets),
	% The Norwegian lives next to the blue house
	member(h(norwegian,H6), Nationalities),
	next(H6, H7),
	member(h(blue,H7), Colours),
	% The Winston smoker owns snails.
	member(h(winston,H8), Cigarettes),
	member(h(snails,H8), Pets),
	% The lucky strike smoker drinks orange juice
	member(h(lucky_strike,H9), Cigarettes),
	member(h(orange_juice,H9), Drinks),
	% The Ukrainian drinks tea
	member(h(ukrainian,H10), Nationalities),
	member(h(tea,H10), Drinks),
	% The Japanese smokes parliaments
	member(h(japanese,H11), Nationalities),
	member(h(parliaments,H11), Cigarettes),
	% Kools are smoked in the house next to the house where the horse is kept.
	member(h(kools,H12), Cigarettes),
	next(H12, H13),
	member(h(horse,H13), Pets),
	% Coffee is drunk in the green house
	member(h(coffee,H14), Drinks),
	member(h(green,H14), Colours),
	% The green house is immediately to the right (your right) of the ivory house
	member(h(green,H15), Colours),
	lleft(H16, H15),
	member(h(ivory,H16), Colours),
	% Milk is drunk in the middle house.
	member(h(milk,3), Drinks).

permutation([],[]).
permutation([A|X],Y) :- delete(A,Y,Y1), permutation(X,Y1).

delete(A,[A|X],X).
delete(A,[B|X],[B|Y]) :- delete(A,X,Y).

member(A,[A|_]) :- !.
member(A,[_|X]) :- member(A,X).

next(X,Y) :- lleft(X,Y).
next(X,Y) :- lleft(Y,X).

lleft(1,2).
lleft(2,3).
lleft(3,4).
lleft(4,5).
