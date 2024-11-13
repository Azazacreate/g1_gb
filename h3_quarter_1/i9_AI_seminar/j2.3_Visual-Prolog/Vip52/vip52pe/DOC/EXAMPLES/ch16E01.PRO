/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH16E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

facts
  xpositive(symbol,symbol)
  xnegative(symbol,symbol)

predicates
  animal_is(symbol) - nondeterm (o)
  it_is(symbol) - nondeterm (i)
  ask(symbol,symbol,symbol) - determ (i,i,i)
  remember(symbol,symbol,symbol) - determ (i,i,i)
  positive(symbol,symbol) - determ (i,i)
  negative(symbol,symbol) - determ (i,i)
  clear_facts - determ ()
  run - determ ()

clauses
  animal_is(cheetah):-
	it_is(mammal),
	it_is(carnivore),
	positive(has,tawny_color),
	positive(has,dark_spots).

  animal_is(tiger):-
	it_is(mammal),
	it_is(carnivore),
	positive(has, tawny_color),
	positive(has, black_stripes).

  animal_is(giraffe):-
	it_is(ungulate),
	positive(has,long_neck),
	positive(has,long_legs),
	positive(has, dark_spots).

  animal_is(zebra):-
	it_is(ungulate),
	positive(has,black_stripes).

  animal_is(ostrich):-
	it_is(bird),
	negative(does,fly),
	positive(has,long_neck),
	positive(has,long_legs),
	positive(has, black_and_white_color).

  animal_is(penguin):-
	it_is(bird),
	negative(does,fly),
	positive(does,swim),
	positive(has,black_and_white_color).

  animal_is(albatross):-
	it_is(bird),positive(does,fly_well).

  it_is(mammal):-
	positive(has,hair).
  it_is(mammal):-
	positive(does,give_milk).

  it_is(bird):-
	positive(has,feathers).
  it_is(bird):-
	positive(does,fly),
	positive(does,lay_eggs).

  it_is(carnivore):-
	positive(does,eat_meat).

  it_is(carnivore):-
	positive(has,pointed_teeth),
	positive(has, claws),
        positive(has,forward_eyes).

  it_is(ungulate):-
	it_is(mammal),
	positive(has,hooves).

  it_is(ungulate):-
	it_is(mammal),
	positive(does,chew_cud).

  positive(X,Y):-
	xpositive(X,Y),!.
  positive(X,Y):-
	not(xnegative(X,Y)),
	ask(X,Y,yes).

  negative(X,Y):-
	xnegative(X,Y),!.
  negative(X,Y):-
	not(xpositive(X,Y)),
	ask(X,Y,no).

  ask(X,Y,yes):-
	!,
	write(X," it ",Y,'\n'),
	readln(Reply),nl,
	frontchar(Reply,'y',_),
	remember(X,Y,yes).
  ask(X,Y,no):-
	!,
	write(X," it ",Y,'\n'),
	readln(Reply),nl,
	frontchar(Reply,'n',_),
	remember(X,Y,no).

  remember(X,Y,yes):-
	assertz(xpositive(X,Y)).
  remember(X,Y,no):-
	assertz(xnegative(X,Y)).

  clear_facts:-
	write("\n\nPlease press the space bar to exit\n"),
	retractall(_,dbasedom),
	readchar(_).

  run:-
	animal_is(X),!,
	write("\nYour animal may be a (an) ",X),
	nl,
	clear_facts.
  run:-
	write("\nUnable to determine what"),
	write("your animal is.\n\n"),
	clear_facts.

goal
  run.