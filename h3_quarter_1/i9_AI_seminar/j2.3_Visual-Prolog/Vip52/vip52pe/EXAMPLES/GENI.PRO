/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  GENI
 FileName: GENI.PRO
 Purpose: example to create expert-system
 Written by: Visual Prolog
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

domains
  CONDITIONS = CNO*
  HISTORY = RNO*
  RNO, CNO, FNO = INTEGER
  CATEGORY = STRING
  SLIST = STRING*

database - geni
  rule(RNO,CATEGORY,CATEGORY,CONDITIONS)
  cond(CNO,STRING)
  topic(STRING maingoal,STRING purpose)

database - tmp
  yes(CNO)
  no(CNO)
  fact(FNO,CATEGORY,CATEGORY)

predicates
  evalans(char)
  reverse(CONDITIONS,CONDITIONS)
  reverse1(CONDITIONS,CONDITIONS,CONDITIONS)

  % Inferences engine
  nondeterm go(HISTORY,CATEGORY)
  check(RNO,HISTORY,CONDITIONS)
  notest(CNO)

  % Helping predicates
  inpq(HISTORY,RNO,CNO,STRING)
  do_answer(HISTORY,RNO,STRING,CNO,INTEGER)

  % Explanations
  sub_cat(CATEGORY,CATEGORY,CATEGORY)
  show_conditions(CONDITIONS,string)
  show_rule(RNO,string)
  report(HISTORY,string)

clauses
  go(_,Mygoal):-
	not(rule(_,Mygoal,_,_)),
	!,
	nl,
	write("I think it is a(n): ",Mygoal),nl,nl,
	write("I was right, wasn't I? (enter y or n)"),
	readchar(Ans),
	evalans(Ans),
	!.
  go(HISTORY,Mygoal):-
	rule(RNO,Mygoal,NY,COND),
	check(RNO,HISTORY,COND),
	go([RNO|HISTORY],NY).

  % Check the conditions for the Rule !
  check(RNO,HISTORY,[CNO|REST]):-
	yes(CNO),
	!,
	check(RNO,HISTORY,REST).
  check(_,_,[CNO|_]):-
	no(CNO),
	!,
	fail.
  check(RNO,HISTORY,[CNO|REST]):-
	cond(CNO,NCOND),
	fronttoken(NCOND,"not",_COND),
	frontchar(_COND,_,COND),
	cond(CNO1,COND),
	notest(CNO1), 
	!,
	check(RNO,HISTORY,REST).
  check(_,_, [CNO|_]):-
	cond(CNO,NCOND),
	fronttoken(NCOND,"not",_COND),
	frontchar(_COND,_,COND),
	cond(CNO1,COND),
	yes(CNO1),
	!,
	fail.
  check(RNO,HISTORY,[CNO|REST]):-
	cond(CNO,TEXT),
	!,
	inpq(HISTORY,RNO,CNO,TEXT),
	check(RNO,HISTORY,REST).
  check(_,_,[]).

  notest(CNO):-
	no(CNO),
	!.
  notest(CNO):-
	not(yes(CNO)),
	!.

  inpq(HISTORY,RNO,CNO,TEXT):-
	write("Is it true that ",TEXT," (Yes/No/Why):"),
	readchar(CH),
	upper_lower(CH,CHOICE),
	do_answer(HISTORY,RNO,TEXT,CNO,CHOICE).

  do_answer(_,_,_,CNO,'y'):-
	!,
	assert(yes(CNO)),
	write("Yes\n").
  do_answer(_,_,_,CNO,'n'):-
	!,
	assert(no(CNO)),
	write("No\n"),
	fail.
  do_answer(HISTORY,RNO,TEXT,CNO,'w'):-
	!,
	write("Why\n"),
	rule(RNO,Mygoal1,Mygoal2,_),
	!,
	sub_cat(Mygoal1,Mygoal2,Lstr),
	concat("I try to show that: ",Lstr,Lstr1),
	concat(Lstr1,"\nBy using rule number ",Ls1),
	str_int(Str_num,RNO),
	concat(Ls1,Str_num,Ans),
	show_rule(RNO,Lls1),
	concat(Ans,Lls1,Ans1),
	report(HISTORY,Sng),
	concat(Ans1,Sng,Answ),
	write(Answ),
	nl,
	inpq(HISTORY,RNO,CNO,TEXT).
  do_answer(_,_,_,_,_):-
	write("\nOK, we are Terminating\n"),
	exit.

  % List Rules / Explanation Mechanism
  show_rule(RNO,Strg):-
	rule(RNO,Mygoal1,Mygoal2,CONDINGELSER),
	!,
	str_int(RNO_str,RNO),
	concat("\n Rule ",RNO_str,Ans),
	concat(Ans,": ",Ans1),
	sub_cat(Mygoal1,Mygoal2,Lstr),
	concat(Ans1,Lstr,Ans2),
	concat(Ans2,"\n     if ",Ans3),
	reverse(CONDINGELSER,CONILS),
	show_conditions(CONILS,Con),
	concat(Ans3,Con,Strg).

  show_conditions([],"").
  show_conditions([COND],Ans):-
	cond(COND,Ans),
	!.
  show_conditions([COND|REST],Ans):-
	cond(COND,Text),
	!,
	concat("\n    and ",Text,Nstr),
	show_conditions(REST,Next_ans),
	concat(Next_ans,Nstr,Ans).

  sub_cat(Mygoal1,Mygoal2,Lstr):-
	format(LStr,"% is a %",MyGoal1,MyGoal2).

  report([],"").
  report([RNO|REST],Strg):-
	rule(RNO,Mygoal1,Mygoal2,_),
	!,
	sub_cat(Mygoal1,Mygoal2,Lstr),
	concat("\nI have shown that: ",Lstr,L1),
	concat(L1,"\nBy using rule number ",L2),
	str_int(Str_RNO,RNO),
	concat(L2,Str_RNO,L3),
	concat(L3,":\n ",L4),
	show_rule(RNO,Str),
	concat(L4,Str,L5),
	report(REST,Next_strg),
	concat(L5,Next_strg,Strg).

  evalans('y'):-
	!,
	write("\nOf course, I am always right!").
  evalans('n'):-
	!,
	write("\nyou're the boss\nUpdate my Knowledge Base!").
  evalans(_):-
	write("\nOK, we are Terminating\n").

  reverse(X,Y):-
	reverse1([],X,Y).

  reverse1(Y,[],Y).
  reverse1(X1,[U|X2],Y):-
	reverse1([U|X1],X2,Y).

goal
% Chose knowledgebase
%  consult("geni.gni",geni),
  consult("vacation.gni",geni),
  topic(MAINGOAL,PURPOSE),
  write(PURPOSE),nl,
  go([],MAINGOAL);
  write("\nSorry that one I did not know"),
  nl.
