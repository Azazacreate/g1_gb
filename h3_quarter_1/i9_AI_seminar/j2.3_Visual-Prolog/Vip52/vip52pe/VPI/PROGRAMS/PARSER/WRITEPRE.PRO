/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PARSER
 FileName: WRITEPRE.PRO
 Purpose: Declare parse predicates
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

DOMAINS
  DECLLIST=DECL*
  DECL=decl(SLIST,PRODNAMES)

PREDICATES
  declarepred(DECLLIST)
  declare1(DECLLIST)
  writestrlist(SLIST)

CLAUSES
  writestrlist([]).
  writestrlist([H|T]):-upper_lower(H,H1),write(H1),writestrlist(T).

  declarepred(DECLLIST):-
	declare1(DECLLIST).

  declare1([]).
  declare1([decl(STRL,DOML)|R]):-
	decl(STRL,DOML),!,
	declare1(R).
  declare1([decl(STRL,DOML)|R]):-
	writestrlist(["  "|STRL]),
	write("(TOKL,TOKL,"),wdoml(DOML),
	write(")\n"),
	assert(decl(STRL,DOML)),
	declare1(R).


/**********************************************************************
		Help predicates around gramtokl's
**********************************************************************/

PREDICATES
  split(INTEGER,GRAMTOKL,GRAMTOKL,GRAMTOKL)
  frontconst(GRAMTOKL)
  lastselfref(PRODNAME,GRAMTOKL)

CLAUSES
  /* split(NO,LIST,FIRST,SECOND) */
  split(0,L,[],L):-!.
  split(N,[H|L],[H|L1],L2):-N1=N-1,split(N1,L,L1,L2).

  frontconst([tok(_,_)|_]).

  lastselfref(PRODNAME,[prodname(PRODNAME,_)]):-!.
  lastselfref(PRODNAME,[_|T]):-lastselfref(PRODNAME,T).


/**********************************************************************
	Writing variabels with unik names in the clauses
**********************************************************************/

PREDICATES
  wclausetok(TOKK,CURSORDEMAND)
  checkwclausevarl(PRODNAMES)
  wclausevarl(PRODNAMES)
  wclausevar(PRODNAME)
  biggerno(PRODNAME,INTEGER)
  wexpecttok(TOKK,CURSORDEMAND)


CLAUSES
  wclausetok(name(NAME,_),curdemand(CURSOR)):-!,
	write("t(",NAME,','),wclausevar(CURSOR),write(')').
  wclausetok(name(NAME,_),_):-!,
	write("t(",NAME,",_)").
  wclausetok(cmp(FUNC,_,DOML),curdemand(CURSOR)):-!,
	write("t(",FUNC,"("),
	wclausevarl(DOML),
	write("),"),
	wclausevar(CURSOR),
	write(')').
  wclausetok(cmp(FUNC,_,DOML),_):-
	write("t(",FUNC,"("),wclausevarl(DOML),write("),_)").

  checkwclausevarl([]):-!.
  checkwclausevarl(DOML):-wclausevarl(DOML),write(",").

  wclausevarl([DOM]):-!,wclausevar(DOM).
  wclausevarl([H|T]):-wclausevar(H),write(','),wclausevarl(T).
  wclausevarl([]).

  biggerno(DOM,NO):-
	clausevar(DOM,NO1),NO1>NO,!.

  wclausevar(DOM):-
	clausevar(DOM,NO),
	not(biggerno(DOM,NO)),!,
	NO1=NO+1,
	assert(clausevar(DOM,NO1)),
	write(DOM,NO1).
  wclausevar(DOM):-
	assert(clausevar(DOM,0)),
	write(DOM).

  wexpecttok(name(NAME,_),curdemand(PRODNAME)):-!,
	write("t(",NAME,','),wclausevar(PRODNAME),write(')').
  wexpecttok(name(NAME,_),_):-
	write("t(",NAME,",_)").
  wexpecttok(cmp(NAME,_,DOML),curdemand(PRODNAME)):-!,
	write("t("),
	write(NAME,'('),
	wclausevarl(DOML),
	write("),"),
	wclausevar(PRODNAME),
	write(')').
  wexpecttok(cmp(NAME,_,DOML),_):-
	write("t("),
	write(NAME,'('),
	wclausevarl(DOML),
	write("),_)").


/**********************************************************************
	Writing variabels with unik names in the output term
**********************************************************************/

PREDICATES
  wClauseOutpTerm(TERM)
  checkwoutptermdoml(PRODNAMES)
  woutptermdoml(PRODNAMES)
  woutptermvar(PRODNAME)
  biggertermno(PRODNAME,INTEGER)

CLAUSES
  checkwoutptermdoml([]):-!.
  checkwoutptermdoml(DOML):-woutptermdoml(DOML),write(",").

  woutptermdoml([DOM]):-!,woutptermvar(DOM).
  woutptermdoml([H|T]):-woutptermvar(H),write(','),woutptermdoml(T).
  woutptermdoml([]).

  biggertermno(DOM,NO):-
	outptermvar(DOM,NO1),NO1>NO,!.

  woutptermvar(DOM):-
	outptermvar(DOM,NO),
	not(biggertermno(DOM,NO)),!,
	NO1=NO+1,assert(outptermvar(DOM,NO1)),
	write(DOM,NO1).
  woutptermvar(DOM):-
	assert(outptermvar(DOM,0)),
	write(DOM).

  wClauseOutpTerm(term(FUNC,_,DOML)):-
	write(FUNC,'('),
	woutptermdoml(DOML),
	write(')').
  wClauseOutpTerm(dom(DOM,_)):-
	woutptermdoml([DOM]).
  wClauseOutpTerm(name(FUNCTOR,_)):-
	write(FUNCTOR).


DOMAINS
  DBAL = PARSE*

PREDICATES
  conversions
  nondeterm var1(PARSE)
  nondeterm var2(PARSE)
  genconversions(DBAL,DBAL)
  genconversion(PARSE,PARSE)
  wvar(PRODNAME,INTEGER)
  check_convmove(PRODNAMES,GRAMTOKL)

CLAUSES
  var1(clausevar(X,Y)):-clausevar(X,Y).
  var2(outptermvar(X,Y)):-outptermvar(X,Y).

  conversions:-
	findall(X1,var1(X1),L1),
	findall(X2,var2(X2),L2),
	genconversions(L1,L2),!.
  conversions:-save("d:dd.dat"),exit(0).

  genconversions([],[]):-write(".\n").
  genconversions([H1|T1],[H2|T2]):-
	genconversion(H1,H2),
	genconversions(T1,T2).

  genconversion(clausevar(X,_),outptermvar(X,_)):-!.
  genconversion(clausevar(X,NO1),outptermvar(Y,NO2)):-
	write(','),wvar(X,NO1),write('='),wvar(Y,NO2).

  wvar(ID,0):-!,write(ID).
  wvar(ID,NO):-write(ID,NO).

  /* If the first token contains a variabel it should be placed
     after the domain list */
  check_convmove([],_):-!.
  check_convmove(_,[prodname(_,_)|_]):-!.
  check_convmove(_,[tok(name(_,_),_)|_]):-!.
  check_convmove(_,_):-
	retract(clausevar(DOM,NO)),!,
	assertz(clausevar(DOM,NO)).


/**********************************************************************
	Generate unik variabel names for difference list's
	And unik predicate numbers
**********************************************************************/

PREDICATES
  newdifflist(STRING)

  initsuffix(INTEGER)
  newsuffix(SUFFIX)

CLAUSES
  newdifflist(DIFFLIST):-
	retract(difflist(N)),N1=N+1,assert(difflist(N1)),!,
	N2=N1 div 2,
	str_int(DD,N2),concat("LL",DD,DIFFLIST).

  initsuffix(_):-retract(suffix(_)),fail.
  initsuffix(N):-assert(suffix(N)).

  newsuffix(SUFFIX):-
	retract(suffix(N)),
	N1=N+1,assert(suffix(N1)),!,
	str_int(SUFFIX,N1).


/**********************************************************************
		Find first symbols
**********************************************************************/

DOMAINS
  EMPTY = emptymeet; false

PREDICATES
  firstsymbols(PRODNAME,PRODNAMES,PRODNAMES,TOKKL,TOKKL,EMPTY)
  firstsymbols1(PRODBODY,PRODNAMES,PRODNAMES,TOKKL,TOKKL,EMPTY)
  firstsymbols11(PRODGROUPS,PRODNAMES,PRODNAMES,TOKKL,TOKKL,EMPTY,EMPTY)
  firstsymbols2(PRIORGROUP,PRODNAMES,PRODNAMES,TOKKL,TOKKL,EMPTY,EMPTY)
  firstsymbols3(GRAMTOKL,PRODNAMES,PRODNAMES,TOKKL,TOKKL,EMPTY,EMPTY)
  firstsymbols4(GRAMTOKL,PRODNAMES,PRODNAMES,TOKKL,TOKKL,EMPTY,EMPTY,EMPTY)
  firstsymbols5(GRAMTOK,PRODNAMES,PRODNAMES,TOKKL,TOKKL,EMPTY)

CLAUSES
  firstsymbols(PRODNAME,SEENPRODS,SEENPRODS1,IL,OL,EMPTY):-
	p(PRODNAME,PRODBODY),!,
	firstsymbols1(PRODBODY,[PRODNAME|SEENPRODS],SEENPRODS1,IL,OL,EMPTY).

  firstsymbols1(list(PRODNAME,_,star,_),SEENPRODS,SEENPRODS1,IL,OL,emptymeet):-
	firstsymbols(PRODNAME,SEENPRODS,SEENPRODS1,IL,OL,_).
  firstsymbols1(list(PRODNAME,_,plus,_),SEENPRODS,SEENPRODS1,IL,OL,EMPTY):-
	firstsymbols(PRODNAME,SEENPRODS,SEENPRODS1,IL,OL,EMPTY).
  firstsymbols1(groups(PRODGROUPS),SEENPRODS,SEENPRODS1,IL,OL,EMPTY):-
	firstsymbols11(PRODGROUPS,SEENPRODS,SEENPRODS1,IL,OL,false,EMPTY).

  firstsymbols11([],SEENPRODS,SEENPRODS,IL,IL,EMPTY,EMPTY).
  firstsymbols11([H|T],SEENPRODS,SEENPRODS2,IL,OL2,EMPTY1,EMPTY3):-
	firstsymbols2(H,SEENPRODS,SEENPRODS1,IL,OL1,EMPTY1,EMPTY2),
	firstsymbols11(T,SEENPRODS1,SEENPRODS2,OL1,OL2,EMPTY2,EMPTY3).

  firstsymbols2([],SEENPRODS,SEENPRODS,L,L,EMPTY,EMPTY).
  firstsymbols2([prod(_,GRAML,_,_)|T],SEENPRODS,SEENPRODS2,IL,OL2,EMPTY1,EMPTY3):-
	firstsymbols3(GRAML,SEENPRODS,SEENPRODS1,IL,OL1,EMPTY1,EMPTY2),
	firstsymbols2(T,SEENPRODS1,SEENPRODS2,OL1,OL2,EMPTY2,EMPTY3).

  firstsymbols3([],SEENPRODS,SEENPRODS,IL,IL,_,emptymeet).
  firstsymbols3([H|T],SEENPRODS,SEENPRODS2,IL,OL2,EMPTY1,EMPTY2):-
	firstsymbols5(H,SEENPRODS,SEENPRODS1,IL,OL1,EMPTYMEET),
	firstsymbols4(T,SEENPRODS1,SEENPRODS2,OL1,OL2,EMPTYMEET,EMPTY1,EMPTY2).

  firstsymbols4(_,SEENPRODS,SEENPRODS,IL,IL,false,EMPTY,EMPTY):-!.
  firstsymbols4(T,SEENPRODS1,SEENPRODS2,IL,OL,_,EMPTY1,EMPTY2):-
	firstsymbols3(T,SEENPRODS1,SEENPRODS2,IL,OL,EMPTY1,EMPTY2).

  firstsymbols5(prodname(PROD,_),SEENPRODS,SEENPRODS1,IL,OL,EMPTY):-
	not(member(PROD,SEENPRODS)),!,
	firstsymbols(PROD,SEENPRODS,SEENPRODS1,IL,OL,EMPTY).
  firstsymbols5(tok(TOK,_),SEENPRODS,SEENPRODS,IL,[TOK|IL],false):-
	not(member(TOK,IL)),!.
  firstsymbols5(_,SEENPRODS,SEENPRODS,L,L,false). /* Not quite enough */


/**********************************************************************
		HELP PREDICATE
**********************************************************************/

PREDICATES
  minprior(PRIORITY,PRIORITY,PRIORITY)

CLAUSES
  minprior(X,Y,X):-X<=Y,!.
  minprior(_,Y,Y).


/**********************************************************************
		Check for cut
**********************************************************************/

DOMAINS
  FOLLOWPROD =  /* a list of productions folowing this clause */
  		first(FIRSTLIST);
		second(INTEGER,PRIORGROUP)

PREDICATES
  checkcuta(GRAMTOKL,FOLLOWPROD,CUT)
  checkcutb(CUT)
  morematch(TOKK,FOLLOWPROD)
  do_match(TOKK,GRAMTOKL)
  do_match1(TOKK,TOKKL,EMPTY)

CLAUSES
  checkcutb(setcut):-!,write(",!").
  checkcutb(_).

  checkcuta([prodname(_,_)|_],_,setcut):-!.
  checkcuta([tok(TOK,_)|_],FOLLOWPRODS,setcut):-
	morematch(TOK,FOLLOWPRODS),!.
  checkcuta(_,_,nill):-write("!,").

  morematch(_,first([])):-!,fail.
  morematch(_,second(_,[])):-!,fail.
  morematch(TOK,first([first(_,_,prod(_,TOKL,_,_),_)|_])):-
	do_match(TOK,TOKL),!.
  morematch(TOK,second(NOOFEQ,[prod(_,TOKL,_,_)|_])):-
	split(NOOFEQ,TOKL,_,TOKL1),
	do_match(TOK,TOKL1),!.
  morematch(TOK,first([_|T])):-morematch(TOK,first(T)).
  morematch(TOK,second(N,[_|T])):-morematch(TOK,second(N,T)).

  do_match(TOK,[tok(TOK,_)|_]):-!.
  do_match(TOK,GRAML):-
	firstsymbols3(GRAML,[],_,[],FIRSTSYMBOLS,false,EMPTY),
	do_match1(TOK,FIRSTSYMBOLS,EMPTY).

  do_match1(_,_,emptymeet):-!.
  do_match1(cmp(ID,_,_),FIRSTSYMBOLS,_):-
	member(cmp(ID,_,_),FIRSTSYMBOLS),!.
  do_match1(name(ID,_),FIRSTSYMBOLS,_):-
	member(name(ID,_),FIRSTSYMBOLS),!.


/**********************************************************************
		Generate parse predicates for prefix op's
**********************************************************************/

PREDICATES
  genpred(PRODNAMES,ASSOC,GRAMTOKL,TERM,PRODNAME,SUFFIX,PRIORITY,FOLLOWPROD)
  genpredstart(PRODNAME,SUFFIX,GRAMTOKL,GRAMTOKL)
  genbody_b(GRAMTOKL,PRODNAME,SUFFIX,SUFFIX)
  genbody_a(GRAMTOKL,PRODNAME,SUFFIX)
  gencall_a(GRAMTOK,PRODNAME,SUFFIX)
  gencall_b(GRAMTOK,PRODNAME,SUFFIX)
  regconstinhead
  initgenpred

CLAUSES
  initgenpred:-retract(clausevar(_,_)),fail.
  initgenpred:-retract(outptermvar(_,_)),fail.
  initgenpred:-retract(difflist(_)),fail.
  initgenpred:-assert(difflist(1)).

  /* The rest of the list is empty */
  genpred(DOML,_,[],TERM,PRODNAME,SUFFIX,_,_):-!,
	assert(catchallflag),
	upper_lower(PRODNAME,PID),
	write("  s_",PID,SUFFIX,"(LL,LL,"),
	checkwclausevarl(DOML),
	wClauseOutpTerm(TERM),
	write("):-!"),
	conversions.

  /* The rest of the list is only one constant token */
  genpred(DOML,_,[tok(TOK,CURSORDEMAND)],TERM,PRODNAME,SUFFIX,_,_):-!,
	upper_lower(PRODNAME,PID),
	write("  s_",PID,SUFFIX,"(["),
	wclausetok(TOK,CURSORDEMAND),
	write("|LL],LL,"),
	regconstinhead,
	checkwclausevarl(DOML),
	check_convmove(DOML,[tok(TOK,CURSORDEMAND)]),
	wClauseOutpTerm(TERM),
	write("):-!"),
	conversions.

  /*
  A right associative operator:
  s_exp1a([t(potens,_)|LL1],LL0,plus(EXP,EXP1),EXP_):-!,
	s_exp2(LL1,LL2,EXP1),
	s_exp1a(LL2,LL0,EXP,EXP_).
  */
  genpred(DOML,right(_),TOKL,TERM,PRODNAME,SUFFIX,PRIORITY,_):-
	PRIORITY>0,
	lastselfref(PRODNAME,TOKL),!,
	genpredstart(PRODNAME,SUFFIX,TOKL,TOKL1),
	checkwclausevarl(DOML),
	check_convmove(DOML,TOKL),
	wClauseOutpTerm(TERM),
	write("):-!,"),
	str_int(SUFFIX1,PRIORITY),
	genbody_b(TOKL1,PRODNAME,"",SUFFIX1),
	conversions.

  /*
  A left associative operator:
  s_exp1a([t(plus,_)|LL1],LL0,EXP,EXP_):-!,
	s_exp2(LL1,LL2,EXP1),
	s_exp1a(LL2,LL0,plus(EXP,EXP1),EXP_).
  */
  genpred(DOML,_,TOKL,TERM,PRODNAME,SUFFIX,PRIORITY,_):-
	PRIORITY>0,lastselfref(PRODNAME,TOKL),
	frontconst(TOKL),
	str_int(SUFFIX,DD),DD><PRIORITY,!, /* NOT predfirst */
	genpredstart(PRODNAME,SUFFIX,TOKL,TOKL1),
	checkwclausevarl(DOML),
	check_convmove(DOML,TOKL),
	DOM=PRODNAME,
	write(DOM,"_):-!,"),
	PRIOR2=PRIORITY+1,
	exist_prior(PRODNAME,MAXPRIOR),
	minprior(PRIOR2,MAXPRIOR,PRIOR22),
	str_int(SUFFIX2,PRIOR22),
	genbody_a(TOKL1,PRODNAME,SUFFIX2),
	newdifflist(LL3),
	upper_lower(PRODNAME,PID),
	write("\n\ts_",PID,SUFFIX,"(",LL3,",LL0,"),
	wClauseOutpTerm(TERM),
	write(",",DOM,"_)"),
	conversions,!.

  /* With A operator the last call must be a call to the same priority */
  genpred(DOML,_,TOKL,TERM,PRODNAME,SUFFIX,PRIORITY,FOLLOWPROD):-
	PRIORITY>0,lastselfref(PRODNAME,TOKL),!,
	genpredstart(PRODNAME,SUFFIX,TOKL,TOKL1),
	checkwclausevarl(DOML),
	check_convmove(DOML,TOKL),
	wClauseOutpTerm(TERM),
	write("):-"),checkcuta(TOKL,FOLLOWPROD,CUT),
	str_int(SUFFIX2,PRIORITY),
	genbody_b(TOKL1,PRODNAME,"",SUFFIX2),
	checkcutb(CUT),
	conversions.

  /* The general form of a production */
  genpred(DOML,_,TOKL,TERM,PRODNAME,SUFFIX,_,FOLLOWPROD):-
	genpredstart(PRODNAME,SUFFIX,TOKL,TOKL1),
	checkwclausevarl(DOML),
	check_convmove(DOML,TOKL),
	wClauseOutpTerm(TERM),
	write("):-"),checkcuta(TOKL,FOLLOWPROD,CUT),
	genbody_b(TOKL1,PRODNAME,"",""),
	checkcutb(CUT),
	conversions.

  regconstinhead:-constinhead,!.
  regconstinhead:-assert(constinhead).

  genpredstart(PRODNAME,SUFFIX,[tok(TOK,CURSORDEMAND)|TOKL],TOKL):-!,
	upper_lower(PRODNAME,PID),
	newdifflist(LL1),
	write("  s_",PID,SUFFIX,"(["),
	wclausetok(TOK,CURSORDEMAND),
	write("|",LL1,"],LL0,"),
	regconstinhead.
  genpredstart(PRODNAME,SUFFIX,TOKL,TOKL):-
	upper_lower(PRODNAME,PID),
	newdifflist(LL1),
	write("  s_",PID,SUFFIX,"(",LL1,",LL0,").


/*********************************************************************
  genbody_b generate calls to productions in the body of the clause.
*********************************************************************/

  genbody_a([],_,_).
  genbody_a([H|T],PRODNAME,SUFFIX):-
	gencall_a(H,PRODNAME,SUFFIX),write(','),
	genbody_a(T,PRODNAME,SUFFIX).


/*********************************************************************
  genbody_b generate the body of the clause. The last call need to
  be handled special so the name of the last difference list will
  be the name of the output differencelist in the head.
  The last call does also have a special suffix.
*********************************************************************/

  genbody_b([],_,_,_).
  genbody_b([H],PRODNAME,_,SUFFIX):-!,
	gencall_b(H,PRODNAME,SUFFIX).
  genbody_b([H|T],PRODNAME,SUFFIX,SUFFIX1):-
	gencall_a(H,PRODNAME,SUFFIX),write(","),
	genbody_b(T,PRODNAME,SUFFIX,SUFFIX1).

/*********************************************************************
	Call productions in clause body except last call
*********************************************************************/

  gencall_a(prodname(PROD1,_),_,SUFFIX):-
	upper_lower(PROD1,PID),
	newdifflist(LL1),newdifflist(LL2),DOM=PROD1,
	write("\n\ts_",PID,SUFFIX,"(",LL1,",",LL2,","),wclausevar(DOM),write(")").
  gencall_a(tok(TOK,CURSORDEMAND),_,_):-
	newdifflist(LL1),newdifflist(LL2),
	write("\n\texpect("),
	wexpecttok(TOK,CURSORDEMAND),
	write(",",LL1,",",LL2,")").

/*********************************************************************
  Last call in clause body, handle name of differencelist special
*********************************************************************/

  gencall_b(prodname(PROD1,_),_,SUFFIX):-
	upper_lower(PROD1,PID),
	newdifflist(LL1),DOM=PROD1,
	write("\n\ts_",PID,SUFFIX,"(",LL1,",LL0,"),wclausevar(DOM),write(")").
  gencall_b(tok(TOK,CURDEMAND),_,_):-
	newdifflist(LL1),
	write("\n\texpect("),
	wexpecttok(TOK,CURDEMAND),
	write(",",LL1,",LL0)").

/*********************************************************************
  Generate as many underscores as there are elements in the list
*********************************************************************/

PREDICATES
  writeuscores(PRODNAMES)

CLAUSES
  writeuscores([]).
  writeuscores([_|T]):-
	write(",_"),
	writeuscores(T).


/*********************************************************************
  genpred_first and genopred_second is introduced to get an efficient
  parser. If more than one production in a group start with the same
  sequence of productions and tokens, these same 'gramtokens' is handled
  by genpred_first and the rest is handled by genpred_second.

  Ex:

  SENT =  if_ EXP then SENT		-> ifthen(EXP,SENT),
	  if_ EXP then SENT else SENT	-> ifthenelse(EXP,SENT,SENT),

>> genpred_first generates:

 s_sent([t(if_,_)|LL1],LL0,SENT_):-!,
	s_exp(LL1,LL2,EXP),
	expect(then,LL2,LL3),
	s_sent(LL3,LL4,SENT),
	s_sent1(LL4,LL0,EXP,SENT,SENT_).


>> genpred_second generates:

  s_sent1([t(else,_)|LL1],LL0,EXP,SENT,ifthenelse(EXP,SENT,SENT1)):-!,
	s_sent(LL1,LL0,SENT1).
  s_sent1(LL,LL,EXP,SENT,ifthen(EXP,SENT)).
		
**********************************************************************/

PREDICATES
  genpred_firstlist(PRODNAME,SUFFIX,PRIORITY,FIRSTLIST)
  genpred_first(INTEGER,PRODNAMES,SINGPROD,PRODNAME,SUFFIX,SUFFIX,PRIORITY,FIRSTLIST)
  genpred_second(INTEGER,PRODNAMES,PRIORGROUP,PRODNAME,SUFFIX,PRIORITY)

CLAUSES
  genpred_firstlist(_,_,_,[]):-catchallflag,!.
  genpred_firstlist(_,_,_,[]):-not(constinhead),!.
  genpred_firstlist(PRODNAME,SUFFIX,_,[]):-
	upper_lower(PRODNAME,PID),
	write("  s_",PID,SUFFIX,"(LL,_,_):-"),
	SUFF=SUFFIX,
	strlist_str([PID,SUFF],PIDD),
	write("syntax_error(",PIDD,",LL),fail.\n").
  genpred_firstlist(PRODNAME,SUFFIX,PRIORITY,[first(N,DOML,PROD,SUFFIX1)|T]):-
	genpred_first(N,DOML,PROD,PRODNAME,SUFFIX,SUFFIX1,PRIORITY,T),
	genpred_firstlist(PRODNAME,SUFFIX,PRIORITY,T).

  /* Make the entry predicate to a production with priorities	*/
  /* Ex.  s_exp(LL1,LL0,EXP):- s_exp1(LL1,LL0,EXP).		*/
  genpred_first(-1,[DOM],_,PRODNAME,_,_,_,_):-!,
	upper_lower(PRODNAME,PID),
	write("  s_",PID,"(LL1,LL0,",DOM,"):-\n"),
	write("\ts_",PID,"1(LL1,LL0,",DOM,").\n").

/* Only one production which match, genpred_second not used	*/
  genpred_first(0,DOML,prod(ASSOC,TOKL,_,TERM),PRODNAME,SUFFIX,_,PRIORITY,REST):-!,
	initgenpred,
	genpred(DOML,ASSOC,TOKL,TERM,PRODNAME,SUFFIX,PRIORITY,first(REST)).

  /*
  Self referential production: EXP :== EXP + EXP
  >> genpred_first:
  s_exp1(LL1,LL0,EXP_):-
	s_exp2(LL1,LL2,EXP),
	s_exp1a(LL2,LL0,EXP,EXP_).

  >> genpred_second:
  s_exp1a([t(plus,_)|LL1],LL0,EXP,EXP_):-!,
	s_exp2(LL1,LL2,EXP1),
	s_exp1a(LL2,LL0,plus(EXP,EXP1),EXP_).
  s_exp1a(LL,LL,EXP,EXP).
  */
  genpred_first(NOOFEQ,DOML,prod(_,[prodname(PRODNAME,CURSOR)|TOKL],_,_),PRODNAME,SUFFIX,SUFFIX1,PRIORITY,_):-!,
	split(NOOFEQ,[prodname(PRODNAME,CURSOR)|TOKL],TOKL1,_),
	upper_lower(PRODNAME,PID),
	initgenpred,
	newdifflist(LL1),
	write("  s_",PID,SUFFIX,"(",LL1,",LL0,",PRODNAME,"_):-"),
	PRIOR2=PRIORITY+1, str_int(SUFFIX2,PRIOR2),
	genbody_a(TOKL1,PRODNAME,SUFFIX2),
	newdifflist(LL3),
	write("\n\ts_",PID,SUFFIX1,"(",LL3,",LL0,"),
	checkwoutptermdoml(DOML),
	write(PRODNAME,"_)"),
	conversions.

  /* Production like: if EXP then SENT else SENT where NOOFEQ==4 */
  genpred_first(NOOFEQ,DOML,prod(_,TOKL,_,_),PRODNAME,SUFFIX,SUFFIX1,_,REST):-
	initgenpred,
	split(NOOFEQ,TOKL,TOKL1,_),
	genpredstart(PRODNAME,SUFFIX,TOKL1,TOKL2),
	write(PRODNAME,"_):-"),checkcuta(TOKL,first(REST),CUT),
	genbody_a(TOKL2,PRODNAME,""),
	newdifflist(LL3),
	upper_lower(PRODNAME,PID),
	write("\n\ts_",PID,SUFFIX1,"(",LL3,",LL0,"),
	checkwoutptermdoml(DOML),
	write(PRODNAME,"_)"),checkcutb(CUT),
	conversions.

  genpred_second(_,_,[],_,_,_):-catchallflag,!.
  genpred_second(_,[PRODNAME],[],PRODNAME,SUFFIX,_):-!,
	DOM=PRODNAME,upper_lower(PRODNAME,PID),
	write("  s_",PID,SUFFIX,"(LL,LL,",DOM,",",DOM,").\n").
  genpred_second(_,_,[],_,_,_):-not(constinhead),!.
  genpred_second(_,DOML,[],PRODNAME,SUFFIX,_):-!,
	upper_lower(PRODNAME,PID),
	write("  s_",PID,SUFFIX,"(LL,_,_"),
	writeuscores(DOML),write("):-"),
	SUFF=SUFFIX,
	strlist_str([PID,SUFF],PIDD),
	write("syntax_error(",PIDD,",LL),fail.\n").
  genpred_second(NOOFEQ,DOML,[prod(ASSOC,TOKL,_,TERM)|T],PRODNAME,SUFFIX,PRIORITY):-
	initgenpred,
	split(NOOFEQ,TOKL,_,TOKL1),
	genpred(DOML,ASSOC,TOKL1,TERM,PRODNAME,SUFFIX,PRIORITY,second(NOOFEQ,T)),
	genpred_second(NOOFEQ,DOML,T,PRODNAME,SUFFIX,PRIORITY).

/*********************************************************************
		Generate parse predicates for list`s
**********************************************************************/

PREDICATES
  genlist(PRODNAME,PRODNAME,STAR_PLUS,SEPARATOR)

CLAUSES
  genlist(PRODNAME,PRODNAME1,plus,sep(SEPARATOR)):-
	upper_lower(PRODNAME,PID),DOMID=PRODNAME,
	upper_lower(PRODNAME1,PID1),DOMID1=PRODNAME1,
	write("  s_",PID,"(LL1,LL0,[",DOMID1,"|",DOMID,"]):-\n"),
	write("\ts_",PID1,"(LL1,LL2,",DOMID1,"),\n"),
	write("\ts_",PID,"1(LL2,LL0,",DOMID,").\n\n"),
	write("  s_",PID,"1(["),
	wclausetok(name(SEPARATOR,0),none),
	write("|LL1],LL2,",DOMID,"):-!,\n"),
	write("\ts_",PID,"(LL1,LL2,",DOMID,").\n"),
	write("  s_",PID,"1(LL,LL,[]).\n").
  genlist(PRODNAME,PRODNAME1,plus,none):-
	upper_lower(PRODNAME,PID),DOMID=PRODNAME,
	upper_lower(PRODNAME1,PID1),DOMID1=PRODNAME1,
	write("  s_",PID,"(LL1,LL0,[",DOMID1,"|",DOMID,"]):-\n"),
	write("\ts_",PID1,"(LL1,LL2,",DOMID1,"),\n"),
	write("\ts_",PID,"1(LL2,LL0,",DOMID,").\n"),
	write("\n  s_",PID,"1(LL1,LL0,[",DOMID1,"|",DOMID,"]):-\n"),
	write("\ts_",PID1,"(LL1,LL2,",DOMID1,"),!,\n"),
	write("\ts_",PID,"1(LL2,LL0,",DOMID,").\n"),
	write("  s_",PID,"1(LL,LL,[]).\n").
  genlist(PRODNAME,PRODNAME1,star,sep(SEPARATOR)):-
	upper_lower(PRODNAME,PID),DOMID=PRODNAME,
	upper_lower(PRODNAME1,PID1),DOMID1=PRODNAME1,
	write("  s_",PID,"(LL1,LL0,[",DOMID1,"|",DOMID,"]):-\n"),
	write("\ts_",PID1,"(LL1,LL2,",DOMID1,"),!,\n"),
	write("\ts_",PID,"1(LL2,LL0,",DOMID,").\n"),
	write("  s_",PID,"(LL,LL,[]).\n\n"),
	write("  s_",PID,"1(["),
	wclausetok(name(SEPARATOR,0),none),
	write("|LL1],LL2,",DOMID,"):-!,\n"),
	write("\ts_",PID,"(LL1,LL2,",DOMID,").\n"),
	write("  s_",PID,"1(LL,LL,[]).\n").
  genlist(PRODNAME,PRODNAME1,star,none):-
	upper_lower(PRODNAME,PID),DOMID=PRODNAME,
	upper_lower(PRODNAME1,PID1),DOMID1=PRODNAME1,
	write("  s_",PID,"(LL1,LL0,[",DOMID1,"|",DOMID,"]):-\n"),
	write("\ts_",PID1,"(LL1,LL2,",DOMID1,"),!,\n"),
	write("\ts_",PID,"(LL2,LL0,",DOMID,").\n"),
	write("  s_",PID,"(LL,LL,[]).\n").


/*********************************************************************
		Generate parse predicates
**********************************************************************/

PREDICATES
  genprodgroup(PRODGROUPS,PRODNAME)
  sortgroup(PRIORGROUP,PRODNAME,SUFFIX,PRIORITY,FIRSTLIST)
  sortgroup1(PRIORGROUP,SINGPROD,INTEGER,INTEGER,PRIORGROUP,PRIORGROUP,PRIORGROUP,PRODNAME,SUFFIX)
  handlesplit(PRODNAME,SUFFIX,PRIORITY,INTEGER,SINGPROD,PRIORGROUP,FIRST)
  match(SINGPROD,SINGPROD,INTEGER,INTEGER)
  matchlength(GRAMTOKL,GRAMTOKL,INTEGER)
  tokmatch(GRAMTOK,GRAMTOK)
  genpriorgroups(PRODGROUPS,PRODNAME,PRIORITY)
  declarelist(PRODNAME,STAR_PLUS,SEPARATOR)
  retract_catchallflag
  maxprior(PRODGROUPS,PRIORITY)


CLAUSES
  write_parsing_predicates_aux :-
	write("/***********************************************************\n"),
	write("\t\tPARSING PREDICATES"),nl,
	write("***********************************************************/\n\n"),
	write("PREDICATES\n"),
	p(PRODNAME,list(_,_,STAR_PLUS,SEPP)),
	declarelist(PRODNAME,STAR_PLUS,SEPP),
	fail.
  write_parsing_predicates_aux :-
	p(PRODNAME,groups(PRODUCTIONGROUPS)),
	genprodgroup(PRODUCTIONGROUPS,PRODNAME),
	fail.

  write_parsing_predicates_aux:-
	write("\nCLAUSES\n"),
	fail.

  write_parsing_predicates_aux:-
	pred_first(PRODNAME,SUFFIX,PRIORITY,FIRSTLIST),
	retract_catchallflag,
	genpred_firstlist(PRODNAME,SUFFIX,PRIORITY,FIRSTLIST),
	nl,
	fail.

  write_parsing_predicates_aux:-
	pred_second(MATCHLENGTH,DOML,MATCH,PRODNAME,SUFFIX,PRIORITY),
	retract_catchallflag,
	genpred_second(MATCHLENGTH,DOML,MATCH,PRODNAME,SUFFIX,PRIORITY),
	nl,
	fail.

  write_parsing_predicates_aux:-
	p(PRODNAME,list(PRODNAME1,_,STAR_PLUS,SEPARATOR)),
	genlist(PRODNAME,PRODNAME1,STAR_PLUS,SEPARATOR),
	nl,
	fail.

  write_parsing_predicates_aux:-closefile(outfile).

  retract_catchallflag:-retract(catchallflag),fail.
  retract_catchallflag:-retract(constinhead),fail.
  retract_catchallflag.


  declarelist(PRODNAME,star,none):-!,
	DOM=PRODNAME,PRODNAME=PID,
	declarepred([decl(["s_",PID],[DOM])]).
  declarelist(PRODNAME,_,_):-
	DOM=PRODNAME,PRODNAME=PID,
	declarepred([decl(["s_",PID],[DOM]),decl(["s_",PID,"1"],[DOM])]).

  genprodgroup([PRODUCTIONS],PRODNAME):-!,
	initsuffix(0),
	sortgroup(PRODUCTIONS,PRODNAME,"",0,FIRSTLIST),
	assert(pred_first(PRODNAME,"",0,FIRSTLIST)).

  genprodgroup(PRODUCTIONGROUPS,PRODNAME):-
	maxprior(PRODUCTIONGROUPS,MAXPRIOR),
	MAXPR=MAXPRIOR,
	initsuffix(MAXPR),
	PID=PRODNAME,DOM=PRODNAME,
	declarepred([decl(["s_",PID],[DOM])]),
	/* generate entry to prior group */
	assert(pred_first(PRODNAME,"",0,[first(-1,[DOM],prod(left,[prodname(PRODNAME,0)],0,dom(DOM,0)),"")])),
	assert(exist_prior(PRODNAME,MAXPRIOR)),
	genpriorgroups(PRODUCTIONGROUPS,PRODNAME,1).

  maxprior([],0).
  maxprior([_|T],N):-maxprior(T,N1),N=N1+1.

/************************************************************************
		Generete predicate group with priority
************************************************************************/

  genpriorgroups([],_,_).
  genpriorgroups([H|T],PRODNAME,PRIORITY):-
	str_int(SUFFIX,PRIORITY),
	sortgroup(H,PRODNAME,SUFFIX,PRIORITY,FIRSTLIST),
	assert(pred_first(PRODNAME,SUFFIX,PRIORITY,FIRSTLIST)),
	PRIORITY1=PRIORITY+1,
	genpriorgroups(T,PRODNAME,PRIORITY1).

/************************************************************************
		Generete predicate group with no priority
************************************************************************/

  sortgroup([],_,_,_,[]).
  sortgroup([H|PRODUCTIONS],PRODNAME,SUFFIX,PRIORITY,[FIRST|FIRSTL]):-
	sortgroup1(PRODUCTIONS,H,9999,RESMATCHLENGTH,[H],RESMATCH,RESNOMATCH,PRODNAME,SUFFIX),
	handlesplit(PRODNAME,SUFFIX,PRIORITY,RESMATCHLENGTH,H,RESMATCH,FIRST),
	sortgroup(RESNOMATCH,PRODNAME,SUFFIX,PRIORITY,FIRSTL).

  handlesplit(PRODNAME,SUFFIX,PRIORITY,_,prod(ASSOC,[prodname(PRODNAME,CURSOR)|TOKL],ACURSOR,TERM),[MATCH],
		first(1,[DOM],prod(ASSOC,[prodname(PRODNAME,CURSOR)|TOKL],ACURSOR,TERM),SUFFIX1)):-!,
	newsuffix(SUFFIX1),
	PID=PRODNAME,DOM=PRODNAME,SUFF1=SUFFIX1,SUFF=SUFFIX,
	declarepred([decl(["s_",PID,SUFF],[DOM]),decl(["s_",PID,SUFF1],[DOM,DOM])]),
	assert(pred_second(1,[DOM],[MATCH],PRODNAME,SUFFIX1,PRIORITY)).
  handlesplit(PRODNAME,SUFFIX,_,_,PRODUCTION,[_],
		first(0,[],PRODUCTION,"")):-!,
	PID=PRODNAME,DOM=PRODNAME,SUFF=SUFFIX,
	declarepred([decl(["s_",PID,SUFF],[DOM])]).
  handlesplit(PRODNAME,SUFFIX,PRIORITY,MATCHLENGTH,prod(ASSOC,GRAML,ACURSOR,TERM),MATCH,
		first(MATCHLENGTH,DOML,prod(ASSOC,GRAML,ACURSOR,TERM),SUFFIX1)):-
	getdoml(GRAML,MATCHLENGTH,DOML),
	newsuffix(SUFFIX1),
	PID=PRODNAME,DOM=PRODNAME,SUFF1=SUFFIX1,SUFF=SUFFIX,
	append(DOML,[DOM],DOML1),
	declarepred([decl(["s_",PID,SUFF],[DOM]),decl(["s_",PID,SUFF1],DOML1)]),
	reverse(MATCH,[],REVMATCH),
	assert(pred_second(MATCHLENGTH,DOML,REVMATCH,PRODNAME,SUFFIX1,PRIORITY)).
/*
  sortgroup1(PRODLIST,PROD,OLDMATCHLENGTH,RESMATCHLENGTH,MATCHLIST,RESMATCHLIST,
	NOMATCHLIST,PRODNAME,SUFFIX)
*/
  sortgroup1([],_,MATCHLENGTH,MATCHLENGTH,MATCHLIST,MATCHLIST,[],_,_).
  sortgroup1([PROD2|T],PROD1,OLDMATCHLENGTH,RESMATCHLENGTH,MATCH,RESMATCH,NOMATCH,PRODNAME,SUFFIX):-
	match(PROD1,PROD2,OLDMATCHLENGTH,NEWMATCHLENGTH),!,
	sortgroup1(T,PROD1,NEWMATCHLENGTH,RESMATCHLENGTH,[PROD2|MATCH],RESMATCH,NOMATCH,PRODNAME,SUFFIX).
  sortgroup1([H|T],PROD,MATCHLENGTH,RESMATCHLENGTH,MATCH,RESMATCH,[H|NOMATCH],PRODNAME,SUFFIX):-
	sortgroup1(T,PROD,MATCHLENGTH,RESMATCHLENGTH,MATCH,RESMATCH,NOMATCH,PRODNAME,SUFFIX).

  match(prod(_,GRAML1,_,_),prod(_,GRAML2,_,_),OLDMATCHLENGTH,NEWMATCHLENGTH):-
	matchlength(GRAML1,GRAML2,LENGTH),
	LENGTH>0,
	min(LENGTH,OLDMATCHLENGTH,NEWMATCHLENGTH).

  matchlength([H1|T1],[H2|T2],N):-
	  tokmatch(H1,H2),!,
	  matchlength(T1,T2,N1),
	  N=N1+1.
  matchlength(_,_,0).

  tokmatch(prodname(N,_),prodname(N,_)):-!.
  tokmatch(tok(cmp(ID,_,DOML),CURDEM),tok(cmp(ID,_,DOML),CURDEM)):-!.
  tokmatch(TOK,TOK).

  getdoml(_,0,[]):-!.
  getdoml([],_,[]):-!.
  getdoml([prodname(DOM,_)|T],N,[DOM|T1]):-!,
	N1=N-1,
	getdoml(T,N1,T1).
  getdoml([tok(name(_,_),curdemand(CURSOR))|T],N,[CURSOR|DOML]):-!,
	N1=N-1,
	getdoml(T,N1,DOML).
  getdoml([tok(cmp(_,_,DOML),curdemand(CURSOR))|T],N,DOML2):-!,
	N1=N-1,
	getdoml(T,N1,DOML1),
	append(DOML,[CURSOR|DOML1],DOML2).
  getdoml([tok(cmp(_,_,DOML),_)|T],N,DOML2):-!,
	N1=N-1,
	getdoml(T,N1,DOML1),
	append(DOML,DOML1,DOML2).
  getdoml([_|T],N,T1):-
	N1=N-1,
	getdoml(T,N1,T1).
 