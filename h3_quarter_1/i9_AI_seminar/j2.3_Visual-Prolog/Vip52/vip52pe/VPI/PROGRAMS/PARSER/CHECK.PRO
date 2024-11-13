/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PARSER
 FileName: CHECK.PRO
 Purpose: Check parser
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

PREDICATES
  determ	check_assoc(PRODNAME, ASSOC, GRAMTOKL)
  determ	check_compatrestlist(TERM, TERML)
  determ	check_compatterm(TERM, TERM)
  determ	check_compatterml(PRODNAME, TERML)
  determ	check_domains
  determ	check_doml(CURSOR, PRODNAMES)
  determ	check_equallength(CURSOR, PRODNAMES, PRODNAMES)
  determ	check_equalsize(CURSOR, GRAMTOKL, TERM)
  determ	check_graml(GRAMTOKL)
  determ	check_gramtok(GRAMTOK)
  determ	check_groups(PRODNAME, PRODGROUPS)
  determ	check_parser
  determ	check_priorgroup(PRODNAME, PRIORGROUP)
  determ	check_prod(CURSOR, PRODNAME)
  determ	check_reserved(STRING, CURSOR)
  determ	check_sepp(SEPARATOR, CURSOR)
  determ	check_term(TERM)
  determ	check_terms
  determ	check_tok(TOKK)
  determ	gettermdoml(TERM, PRODNAMES)
  determ	none_selfref(PRODNAME, PRIORGROUP)
  determ	reserved_word1(STRING)
  determ	reserved_word2(STRING)


CLAUSES
  check_parser:-retract(error(_,_)),fail.
  check_parser:-
	check_domains,
	check_terms.

  check_domains:-
	p(_,list(PROD1,CURSOR,_,SEPARATOR)),
	check_sepp(SEPARATOR,CURSOR),
	not(check_prod(CURSOR,PROD1)),
	!,fail.
  check_domains:-
	p(PRODNAME,groups(GROUPS)),
	not(check_groups(PRODNAME,GROUPS)),
	!,fail.
  check_domains.

  check_groups(_,[]).
  check_groups(PRODNAME,[PRODUCTIONS]) :- !,
	check_priorgroup(PRODNAME,PRODUCTIONS),
	none_selfref(PRODNAME,PRODUCTIONS).
  check_groups(PRODNAME,[H|T]) :-
	check_priorgroup(PRODNAME,H),
	check_groups(PRODNAME,T).

  none_selfref(_,[]).
  none_selfref(PRODNAME,[prod(_,[prodname(PRODNAME,CURSOR)|_],_,_)|_]) :- !,
	change_error("Split up in priority groups !",CURSOR),
	fail.
  none_selfref(PRODNAME,[_|T]) :-
	none_selfref(PRODNAME,T).

  check_priorgroup(_,[]).
  check_priorgroup(PRODNAME,[prod(ASSOC,GRAML,CURSOR,TERM)|T]) :-
	check_assoc(PRODNAME,ASSOC,GRAML),
	check_graml(GRAML),
	check_term(TERM),
	check_equalsize(CURSOR,GRAML,TERM),
	check_priorgroup(PRODNAME,T).

  check_assoc(_,left,_) :- !.
  check_assoc(_,_,[prodname(_,_)|_]) :- !.
  check_assoc(_,right(CURSOR),_) :-
	change_error("rightassoc not alloved here",CURSOR),
	fail.

  check_graml([]).
  check_graml([GRAMTOK|T]) :-
	check_gramtok(GRAMTOK),
	check_graml(T).

  check_gramtok(prodname(PROD1,CURSOR)) :-check_prod(CURSOR,PROD1).
  check_gramtok(tok(name(NAME,CURSOR),_)) :-
	check_tok(name(NAME,CURSOR)).
  check_gramtok(tok(cmp(NAME,CURSOR,DOML),_)) :-
	check_tok(cmp(NAME,CURSOR,DOML)),
	check_doml(CURSOR,DOML).

  check_tok(name(NAME,CURSOR)) :-
	check_reserved(NAME,CURSOR),
	decltok(NAME,name(NAME,_)),!.
  check_tok(name(NAME,CURSOR)) :-
	not(decltok(NAME,_)),!,
	assert(decltok(NAME,name(NAME,CURSOR))).
  check_tok(cmp(NAME,CURSOR,DOML)) :-
	check_reserved(NAME,CURSOR),
	decltok(NAME,cmp(NAME,_,DOML)),!.
  check_tok(cmp(NAME,CURSOR,DOML)) :-
	not(decltok(NAME,_)),!,
	assert(decltok(NAME,cmp(NAME,CURSOR,DOML))).
  check_tok(cmp(_,CURSOR,_)) :-
	change_error("Token not compatible with old use of same name",CURSOR),
	fail.
  check_tok(name(_,CURSOR)) :-
	change_error("Token not compatible with old use of same name",CURSOR),
	fail.

  check_sepp(sep(NAME),CURSOR) :- !,check_tok(name(NAME,CURSOR)).
  check_sepp(_,_).

  check_doml(_,[]).
  check_doml(CURSOR,[H|T]) :-
	check_prod(CURSOR,H),
	check_doml(CURSOR,T).

  check_term(dom(PROD1,CURSOR)) :- !,check_prod(CURSOR,PROD1).
  check_term(term(_,CURSOR,DOML)) :- !,check_doml(CURSOR,DOML).
  check_term(_).

  check_equalsize(CURSOR,GRAML,TERM) :-
	getdoml(GRAML,9999,DOML1),
	gettermdoml(TERM,DOML2),
	check_equallength(CURSOR,DOML1,DOML2).

  gettermdoml(term(_,_,DOML),DOML) :- !.
  gettermdoml(dom(DOM,_),[DOM]) :- !.
  gettermdoml(_,[]).

  check_equallength(_,[],[]) :- !.
  check_equallength(CURSOR,[_|T1],[_|T2]) :- !,
	check_equallength(CURSOR,T1,T2).
  check_equallength(CURSOR,_,_) :-
	change_error("There are not the same number of domain names on both sides",CURSOR),
	fail.

  check_prod(_,PROD) :-prodname(PROD),!.
  check_prod(_,"CURSOR") :- !.
  check_prod(_,"STRING") :- !.
  check_prod(_,"REAL") :- !.
  check_prod(_,"INTEGER") :- !.
  check_prod(_,"CHAR") :- !.
  check_prod(_,"SYMBOL") :- !.
  check_prod(_,PROD) :-userprod(PROD),!.
  check_prod(_,PROD) :-userdom(PROD),!.
  check_prod(CURSOR,PROD) :-
	concat("Unknown production name: ",PROD,MSG),
	change_error(MSG,CURSOR),
	fail.

  check_terms:-
	p(PRODNAME,_),
	findall(TERMS,terms(PRODNAME,TERMS),TERML),
	not(check_compatterml(PRODNAME,TERML)),
	!,fail.
  check_terms.

  check_compatterml(_,[]).
  check_compatterml(PRODNAME,[dom(PROD1,CURSOR)|_]) :-
	not(PROD1=PRODNAME),!,
	change_error("A reference to a new domain is not allowed",CURSOR),
	fail.
  check_compatterml(PRODNAME,[H|T]) :-
	check_compatrestlist(H,T),
	check_compatterml(PRODNAME,T).

  check_compatrestlist(_,[]).
  check_compatrestlist(TERM,[H|T]) :-
	check_compatterm(TERM,H),
	check_compatrestlist(TERM,T).

  check_compatterm(name(ID,_),term(ID,CURSOR,_)) :- !,
	change_error("Same functor twice with different parameters",CURSOR),fail.
  check_compatterm(term(ID,_,_),name(ID,CURSOR)) :- !,
	change_error("Same functor twice with different parameters",CURSOR),fail.

  check_compatterm(term(ID,_,DOML1),term(ID,CURSOR,DOML2)) :-not(DOML1=DOML2),!,
	change_error("Same functor twice with different parameters",CURSOR),fail.
  check_compatterm(_,_).

  check_reserved(NAME,CURSOR) :-
	reserved_word1(NAME),
	!,
	change_error("Reserved words in the prolog system can not be used", CURSOR),
	fail.
  check_reserved(NAME,CURSOR) :-
	reserved_word2(NAME),
	!,
	change_error("Reserved words in the prolog system can not be used", CURSOR),
	fail.
  check_reserved(_,_).

  reserved_word1("and").
  reserved_word1("arc").
  reserved_word1("assert").
  reserved_word1("asserta").
  reserved_word1("assertz").
  reserved_word1("attribute").
  reserved_word1("bar").
  reserved_word1("bar3d").
  reserved_word1("beep").
  reserved_word1("bios").
  reserved_word1("bitand").
  reserved_word1("bitleft").
  reserved_word1("bitnot").
  reserved_word1("bitor").
  reserved_word1("bitright").
  reserved_word1("bitxor").
  reserved_word1("bound").
  reserved_word1("break").
  reserved_word1("breakpressed").
  reserved_word1("bt_close").
  reserved_word1("bt_create").
  reserved_word1("bt_delete").
  reserved_word1("bt_open").
  reserved_word1("bt_statistics").
  reserved_word1("chain_delete").
  reserved_word1("chain_first").
  reserved_word1("chain_inserta").
  reserved_word1("chain_insertafter").
  reserved_word1("chain_insertz").
  reserved_word1("chain_last").
  reserved_word1("chain_next").
  reserved_word1("chain_prev").
  reserved_word1("chain_terms").
  reserved_word1("char").
  reserved_word1("char_int").
  reserved_word1("circle").
  reserved_word1("clauses").
  reserved_word1("cleardevice").
  reserved_word1("clearviewport").
  reserved_word1("clearwindow").
  reserved_word1("closefile").
  reserved_word1("closegraph").
  reserved_word1("colorsetup").
  reserved_word1("comline").
  reserved_word1("concat").
  reserved_word1("constants").
  reserved_word1("consult").
  reserved_word1("consulterror").
  reserved_word1("cursor").
  reserved_word1("cursorform").
  reserved_word1("cutbacktrack").
  reserved_word1("database").
  reserved_word1("date").
  reserved_word1("db_btrees").
  reserved_word1("db_chains").
  reserved_word1("db_close").
  reserved_word1("db_copy").
  reserved_word1("db_create").
  reserved_word1("db_delete").
  reserved_word1("db_flush").
  reserved_word1("db_garbagecollect").
  reserved_word1("db_open").
  reserved_word1("db_openinvalid").
  reserved_word1("db_statistics").
  reserved_word1("debug").
  reserved_word1("deletefile").
  reserved_word1("detectgraph").
  reserved_word1("dir").
  reserved_word1("disk").
  reserved_word1("display").
  reserved_word1("domains").
  reserved_word1("drawpoly").
  reserved_word1("edit").
  reserved_word1("editmsg").
  reserved_word1("ellipse").
  reserved_word1("elsedef").
  reserved_word1("envsymbol").
  reserved_word1("enddef").
  reserved_word1("eof").
  reserved_word1("errormsg").
  reserved_word1("existfile").
  reserved_word1("existwindow").
  reserved_word1("exit").
  reserved_word1("fail").
  reserved_word1("field_attr").
  reserved_word1("field_str").
  reserved_word1("file").
  reserved_word1("filemode").
  reserved_word1("filepos").
  reserved_word1("file_str").
  reserved_word1("fillellipse").
  reserved_word1("fillpoly").
  reserved_word1("findall").
  reserved_word1("floodfill").
  reserved_word1("flush").
  reserved_word1("format").
  reserved_word1("framewindow").
  reserved_word1("free").
  reserved_word1("frontchar").
  reserved_word1("frontstr").
  reserved_word1("fronttoken").
  reserved_word1("getarccoords").
  reserved_word1("getaspectratio").
  reserved_word1("getbacktrack").
  reserved_word1("getbkcolor").
  reserved_word1("getcolor").
  reserved_word1("getdefaultpalette").
  reserved_word1("getdrivername").
  reserved_word1("getfillpattern").
  reserved_word1("getfillsettings").
  reserved_word1("getgraphmode").
  reserved_word1("getimage").
  reserved_word1("getlinesettings").
  reserved_word1("getmaxcolor").
  reserved_word1("getmaxx").
  reserved_word1("getmaxy").
  reserved_word1("getmodename").
  reserved_word1("getmoderange").
  reserved_word1("getpalette").
  reserved_word1("getpalettesize").

  reserved_word2("getpixel").
  reserved_word2("gettextsettings").
  reserved_word2("getviewsettings").
  reserved_word2("getx").
  reserved_word2("gety").
  reserved_word2("global").
  reserved_word2("goal").
  reserved_word2("gotowindow").
  reserved_word2("graphdefaults").
  reserved_word2("if").
  reserved_word2("ifdef").
  reserved_word2("ifndef").
  reserved_word2("imagesize").
  reserved_word2("include").
  reserved_word2("initgraph").
  reserved_word2("integer").
  reserved_word2("inkey").
  reserved_word2("isname").
  reserved_word2("key_current").
  reserved_word2("key_delete").
  reserved_word2("key_first").
  reserved_word2("key_insert").
  reserved_word2("key_last").
  reserved_word2("key_next").
  reserved_word2("key_prev").
  reserved_word2("key_search").
  reserved_word2("keypressed").
  reserved_word2("line").
  reserved_word2("linerel").
  reserved_word2("lineto").
  reserved_word2("makewindow").
  reserved_word2("membyte").
  reserved_word2("memword").
  reserved_word2("moverel").
  reserved_word2("moveto").
  reserved_word2("nl").
  reserved_word2("not").
  reserved_word2("or").
  reserved_word2("openappend").
  reserved_word2("openmodify").
  reserved_word2("openread").
  reserved_word2("openwrite").
  reserved_word2("outtext").
  reserved_word2("outtextxy").
  reserved_word2("pieslice").
  reserved_word2("pieslicexy").
  reserved_word2("port_byte").
  reserved_word2("predicates").
  reserved_word2("project").
  reserved_word2("ptr_dword").
  reserved_word2("putimage").
  reserved_word2("putpixel").
  reserved_word2("random").
  reserved_word2("readchar").
  reserved_word2("readdevice").
  reserved_word2("readint").
  reserved_word2("readln").
  reserved_word2("readreal").
  reserved_word2("readterm").
  reserved_word2("readtermerror").
  reserved_word2("real").
  reserved_word2("rectangle").
  reserved_word2("ref_term").
  reserved_word2("removewindow").
  reserved_word2("renamefile").
  reserved_word2("resizewindow").
  reserved_word2("restorecrtmode").
  reserved_word2("retract").
  reserved_word2("retractall").
  reserved_word2("save").
  reserved_word2("scr_attr").
  reserved_word2("scr_char").
  reserved_word2("scroll").
  reserved_word2("setactivepage").
  reserved_word2("setallpalette").
  reserved_word2("setaspectratio").
  reserved_word2("setbkcolor").
  reserved_word2("setcolor").
  reserved_word2("setfillpattern").
  reserved_word2("setfillstyle").
  reserved_word2("setgraphmode").
  reserved_word2("setlinestyle").
  reserved_word2("setpalette").
  reserved_word2("settextjustify").
  reserved_word2("settextstyle").
  reserved_word2("setusercharsize").
  reserved_word2("setviewport").
  reserved_word2("setvisualpage").
  reserved_word2("setwritemode").
  reserved_word2("shiftwindow").
  reserved_word2("snowcheck").
  reserved_word2("sound").
  reserved_word2("storage").
  reserved_word2("string").
  reserved_word2("str_char").
  reserved_word2("str_int").
  reserved_word2("str_len").
  reserved_word2("str_real").
  reserved_word2("symbol").
  reserved_word2("system").
  reserved_word2("term_delete").
  reserved_word2("term_replace").
  reserved_word2("textheight").
  reserved_word2("textmode").
  reserved_word2("textwidth").
  reserved_word2("time").
  reserved_word2("trace").
  reserved_word2("trap").
  reserved_word2("true").
  reserved_word2("unreadchar").
  reserved_word2("upper_lower").
  reserved_word2("window_attr").
  reserved_word2("window_str").
  reserved_word2("write").
  reserved_word2("writedevice").
  reserved_word2("writef").
 