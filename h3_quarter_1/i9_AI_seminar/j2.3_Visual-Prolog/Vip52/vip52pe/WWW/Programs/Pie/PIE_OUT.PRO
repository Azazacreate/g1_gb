/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PIE
 FileName: PIE.OUT
 Purpose: The term writer
 Written by: PDC
 Comments:
******************************************************************************/

PREDICATES
  wterm(MODE,TERM)
  wterm(MODE,STERM)
  wterml(MODE,TERML)
  wterml(MODE,STERML)
  wcmp(MODE,REFSYMB,TERML)
  wcmp(MODE,STRING,STERML)
  wfix(MODE,PRIOR,XFY,OP,TERML)
  wfix(MODE,PRIOR,XFY,OP,STERML)
  wleft(MODE,ASSOC,PRIOR,STERM)
  wleft(MODE,ASSOC,PRIOR,TERM)
  wright(MODE,ASSOC,PRIOR,TERM)
  wright(MODE,ASSOC,PRIOR,STERM)
  wpfixop(OP)
  quotepfixop(STRING)
%  rest_composable(STRING)
  prefix(XFY,ASSOC)
  suffix(XFY,ASSOC)
  infix(XFY,ASSOC,ASSOC)
  brackets_needed(ASSOC,PRIOR,TERM)
  brackets_needed(ASSOC,PRIOR,STERM)
  wlist(MODE,TERM)
  wlist(MODE,STERM)
  write_str (string)

CLAUSES
  wterm(_,TERM):-free(TERM),!,write('_').
  wterm(_,int(X)):-!,write(X).
  wterm("write",str(X)):-!,write_str(X).
  wterm(_,str(X)):-!,write('"'),write_str(X),write('"').
  wterm("write",char(X)):-!,write(X).
  wterm(_,char(X)):-!,write('`',X).
  wterm(_,atom(X)):-!,write(X).
  wterm(_,var(X)):-!,write(X).
  wterm(_,nill):-!,write("[]").
  wterm(MODE,list(HEAD,TAIL)):-!,
	write('['),wlist(MODE,list(HEAD,TAIL)),write(']').
  wterm(MODE,cmp(FID,TERML)):-wcmp(MODE,FID,TERML).

  wcmp(MODE,FID,TERML):-
	MODE><"display",
	OP=FID,op(PRIOR,ASSOC,OP),
	wfix(MODE,PRIOR,ASSOC,OP,TERML),!.
  wcmp(MODE,FID,TERML):-
	FID=OP,
	wpfixop(OP),write('('),wterml(MODE,TERML),write(')').

  wpfixop(OP):-
	quotepfixop(OP),!,
	write(''',OP,''').
  wpfixop(OP):-
	write(OP).

  quotepfixop(OP):-op(_,_,OP),!.
  quotepfixop(OP):-
	frontchar(OP,CH,_),CH><'_',upper_lower(CH,LO),CH=LO,
	isname(OP),!,fail.
/*
  quotepfixop(OP):-
	frontchar(OP,CH,REST),CH><'.',is_composable(CH),
	rest_composable(REST),!,fail.
*/
  quotepfixop(_).

/*
  rest_composable(""):-!.
  rest_composable(STR):-
	frontchar(STR,CH,REST),
	is_composable(CH),
	rest_composable(REST).
*/

  prefix(fx,x).	prefix(fy,y).

  suffix(xf,x).	suffix(yf,y).

  infix(xfx,x,x). infix(xfy,x,y). infix(yfx,y,x). infix(yfy,y,y).

  wfix(MODE,PRIOR,ASSOC,OP,[TERM]):-
	prefix(ASSOC,XY),!,
	write(OP,' '),wright(MODE,XY,PRIOR,TERM).
  wfix(MODE,PRIOR,ASSOC,OP,[TERM]):-
	suffix(ASSOC,XY),!,
	wleft(MODE,XY,PRIOR,TERM),write(' ',OP).
  wfix(MODE,PRIOR,ASSOC,OP,[TERM1,TERM2]):-
	infix(ASSOC,LEFT_XY,RIGHT_XY),
	wleft(MODE,LEFT_XY,PRIOR,TERM1),
	write(' ',OP,' '),
	wright(MODE,RIGHT_XY,PRIOR,TERM2).

  brackets_needed(_,PRIOR,TERM):-
	bound(TERM),TERM=cmp(FID,_),
	OP=FID, op(PRIOR1,_,OP), PRIOR1>PRIOR,!.
  brackets_needed(x,PRIOR,TERM):-
	bound(TERM),TERM=cmp(FID,_),
	OP=FID, op(PRIOR,_,OP),!.

  wright(MODE,XY,PRIOR,TERM):-
	brackets_needed(XY,PRIOR,TERM),!,
	write('('),wterm(MODE,TERM),write(')').
  wright(MODE,_,_,TERM):-wterm(MODE,TERM).

  wleft(MODE,XY,PRIOR,TERM):-
	brackets_needed(XY,PRIOR,TERM),!,
	write('('),wterm(MODE,TERM),write(')').
  wleft(MODE,_,_,TERM):-wterm(MODE,TERM).

  wterml(_,[]):-!.
  wterml(MODE,[H]):-!,wterm(MODE,H).
  wterml(MODE,[H|T]):-wterm(MODE,H),write(','),wterml(MODE,T).

  wlist(_,nill):-!.
  wlist(MODE,list(H,T)):-free(T),!,wterm(MODE,H),write("|_").
  wlist(MODE,list(H,var(VAR))):-!,wterm(MODE,H),write("|"),write(VAR).
  wlist(MODE,list(H,nill)):-!,wterm(MODE,H).
  wlist(MODE,list(H,T)):-wterm(MODE,H),write(','),wlist(MODE,T).

  write_str (S) :-
  	searchstring (S,"\\n",Pos),
  	P=Pos-1,
  	frontstr(P,S,Front,R1),
  	frontstr(2,R1,_,R2),
  	write (Front),
  	nl,!,
  	write_str (R2).
  write_str (S) :- write (S).
  