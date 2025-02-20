/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH07E10.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  toklist  = string*

predicates
  tokl(string,toklist) - procedure (i,o)

clauses
  tokl(Str,[H|T]):-
	fronttoken(Str,H,Str1),!,
	tokl(Str1,T).
  tokl(_,[]).

/* * * * * * * * * * * * * * * * * * * * * * * * *
 * This second part of the program is the parser *
 * * * * * * * * * * * * * * * * * * * * * * * * */

domains
  program   = program(statementlist)
  statementlist = statement*

/* * * * * * * * * * * * * * * * * * * * * * * *
 * Definition of what constitutes a statement  *
 * * * * * * * * * * * * * * * * * * * * * * * */

	statement = if_Then_Else(exp,statement,statement);
                    if_Then(exp,statement);
                    while(exp,statement);
                    assign(id,exp)

/* * * * * * * * * * * * * * *
 * Definition of expression  *
 * * * * * * * * * * * * * * */

	exp       = plus(exp,exp);
                    minus(exp,exp);
                    var(id);
                    int(integer)

	id        = string

predicates
  s_program(toklist,program) - determ (i,o)
  s_statement(toklist,toklist,statement) - determ (i,o,o)
  s_statementlist(toklist,toklist,statementlist) - determ (i,o,o)
  s_exp(toklist,toklist,exp) - determ (i,o,o)
  s_exp1(toklist,toklist,exp,exp) - determ (i,o,i,o)
  s_exp2(toklist,toklist,exp) - determ (i,o,o)

clauses
  s_program(List1,program(StatementList)):-
	s_statementlist(List1,List2,StatementList),
	List2=[].

  s_statementlist([],[],[]):-!.
  s_statementlist(List1,List4,[Statement|Program]):-
	s_statement(List1,List2,Statement),
	List2=[";"|List3],
	s_statementlist(List3,List4,Program).

  s_statement(["if"|List1],List7,if_then_else(Exp,Statement1,Statement2)):-
	s_exp(List1,List2,Exp),
	List2=["then"|List3],
	s_statement(List3,List4,Statement1),
	List4=["else"|List5],!,
	s_statement(List5,List6,Statement2),
	List6=["fi"|List7].
  s_statement(["if"|List1],List5,if_then(Exp,Statement)):-!,
	s_exp(List1,List2,Exp),
	List2=["then"|List3],
	s_statement(List3,List4,Statement),
	List4=["fi"|List5].
  s_statement(["do"|List1],List4,while(Exp,Statement)):-!,
	s_statement(List1,List2,Statement),
	List2=["while"|List3],
	s_exp(List3,List4,Exp).
  s_statement([ID|List1],List3,assign(Id,Exp)):-
	isname(ID),
	List1=["="|List2],
	s_exp(List2,List3,Exp).


  s_exp(LIST1,List3,Exp):-
	s_exp2(List1,List2,Exp1),
	s_exp1(List2,List3,Exp1,Exp).

  s_exp1(["+"|List1],List3,Exp1,Exp):-!,
	s_exp2(List1,List2,Exp2),
	s_exp1(List2,List3,plus(Exp1,Exp2),Exp).
  s_exp1(["-"|List1],List3,Exp1,Exp):-!,
	s_exp2(List1,List2,Exp2),
	s_exp1(List2,List3,minus(Exp1,Exp2),Exp).
  s_exp1(List,List,Exp,Exp).


  s_exp2([Int|Rest],Rest,int(I)):-
	str_int(Int,I),!.
  s_exp2([Id|Rest],Rest,var(Id)):-
	isname(Id).

goal
  tokl("b=2; if b then a=1 else a=2 fi; do a=a-1 while a;",Ans),
  s_program(Ans,Res).