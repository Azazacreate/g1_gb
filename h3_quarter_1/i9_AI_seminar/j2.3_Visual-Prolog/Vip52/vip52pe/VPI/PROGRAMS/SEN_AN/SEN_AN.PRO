/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S
			
 Project:  SEN_AN
 FileName: SEN_AN.PRO
 Purpose: Sentence Analizer
 Written by: Eugene Akimov
 Comments:

******************************************************************************/

include "sen_an.inc"
include "sen_an.con"
include "hlptopic.con"

DOMAINS
  DETER    = none ; deter(string)
  NOUNP    = nounp(DETER,string,RELCL)
  RELCL    = none ; relcl(string,VERBP)
  VP	   = vp(string,string)
  NP	   = np(string)
  SENTENCE = sent(NOUNP,VERBP) ;
  	     question(VP,NP)
  TOKL     =string*
  VERBP    = verb(string) ; verbp(string,NOUNP)

DATABASE - update
  all_sen(slist)
  sen_an(SENTENCE)
  sen_an1(SENTENCE,string)
  word(string)
  open
  update_flag
  name_open_file(string)
  tree_winno(SENTENCE,WINDOW)
  del_sentence(SENTENCE)
  open_new_file
  update_lbox
	
DATABASE - count
  count_noun(integer)
  count_det(integer)
  count_verb(integer)
  count_rel(integer)

PREDICATES
  check(string)
  is_det(string)
  is_noun(string)
  is_rel(string)
  is_verb(string)

CLAUSES
  check(WORD):-is_noun(WORD),!.
  check(WORD):-is_det(WORD),!.
  check(WORD):-is_rel(WORD),!.
  check(WORD):-is_verb(WORD),!.
  check(WORD):- 
	Title="Error",
	T="Unknown word: ",
	concat(T,WORD,Final),
	dlg_Note(Title,Final).
	
  is_noun(X):-noun(X),!.
  is_noun(X):-noun(Y),concat(Y,"s",X),!.

  is_det(X):-det(X),!.

  is_rel(X):-rel(X),!.

  is_verb(X):-verb(X),!.
  is_verb(X):-verb(Y),concat(Y,"s",X),!.
  is_verb(X):-verb(Y),concat(Y,"ed",X),!.
  is_verb(X):-verb(Y),concat(Y,"es",X),!.
  is_verb(X):-verb(Y),concat(Y,"ing",X),!.

PREDICATES
  append(slist,slist,slist)
  fillbox(slist)
  tokl(string,TOKL)
  list_sen
  list_word(slist)
  tom(TOKL)

CLAUSES
  append([],List,List).
  append([X|L1],List2,[X|L3]):-
	append(L1,List2,L3).

  fillbox(X):-
	findall(Var1,verb(Var1),L1),
	findall(Var2,noun(Var2),L2),
	findall(Var3,rel(Var3),L3),
	findall(Var4,det(Var4),L4),
	append(L1,L2,F1),
	append(F1,L3,F2),
	append(F2,L4,X).

  tokl(STR,[TOK|TOKL]):-
	fronttoken(STR,TOK,STR1),
	check(TOK),!,
	tokl(STR1,TOKL).
  tokl(_,[]).

  list_sen:-
	sen(Y),
	all_sen(A),
	Z=[Y],
	append(A,Z,X),
	retractall(all_sen(_)),
	assert(all_sen(X)),
	fail.
  list_sen.

  list_word(X):-
	findall(Var,word(Var),X).

  tom([]).

PREDICATES
  nondeterm s_sentence(TOKL,TOKL,SENTENCE)
  nondeterm s_nounp(TOKL,TOKL,NOUNP)
  nondeterm s_verbp(TOKL,TOKL,VERBP)
  nondeterm s_determ(TOKL,TOKL,DETER)
  nondeterm s_relcl(TOKL,TOKL,RELCL)
  s_quest(TOKL,SENTENCE)

CLAUSES
  s_sentence(TOKL,TOKL2,sent(NOUNP,VERBP)):-
	s_nounp(TOKL,TOKL1,NOUNP),
	s_verbp(TOKL1,TOKL2,VERBP),
	tom(TOKL2),!.

  s_sentence(TOKL,[],question(VP,NP)):-
	s_quest(TOKL,question(VP,NP)).
	
  s_sentence(_,Y,X):-
	Y=[],
	X=sent(nounp(none,"",none),verb("")),
	Title="Error",
	dlg_Note(Title,"Sentence not recognized").

  s_quest([VERB|TOKL],question(vp(VERB,VERB1),np(NOUN))):-
	is_verb(VERB),
	TOKL=[NOUN|TOKL1],
	is_noun(NOUN),
	TOKL1=[VERB1|_],
	is_verb(VERB1).

  s_nounp(TOKL,TOKL2,nounp(DETER,NOUN,RELCL)):-
	s_determ(TOKL,[NOUN|TOKL1],DETER),
	is_noun(NOUN),
	s_relcl(TOKL1,TOKL2,RELCL).

  s_determ([DETER|TOKL],TOKL,deter(DETER)):-
	is_det(DETER).
  s_determ(TOKL,TOKL,none).

  s_relcl([REL|TOKL],TOKL1,relcl(REL,VERBP)):-
	is_rel(REL),
	s_verbp(TOKL,TOKL1,VERBP).
  s_relcl(TOKL,TOKL,none).

  s_verbp([VERB|TOKL],TOKL1,verbp(VERB,NOUNP)):-
	is_verb(VERB),
	s_nounp(TOKL,TOKL1,NOUNP).
  s_verbp([VERB|TOKL],TOKL,verb(VERB)):-
	is_verb(VERB).

PREDICATES
  select_run(WINDOW,SENTENCE,string)
  check_sentence(WINDOW,SENTENCE,string)
  dlg_sen_already_analysed(WINDOW,SENTENCE,string)
  process(WINDOW,SENTENCE,string)
  dbl_sent(WINDOW,string)

CLAUSES
  select_run(_Win,S,_):-
	S=sent(nounp(_,"",_),_),!.
  select_run(_Win,SENT,STR):-
	check_sentence(_Win,SENT,STR).

  check_sentence(_Win,SENT,STR):-del_sentence(SENT),!,
	dlg_sen_already_analysed(_Win,SENT,STR),
	process(_Win,SENT,STR).
  check_sentence(_Win,SENT,STR):-sen_an1(SENT,STR),!,
	dlg_sen_already_analysed(_Win,SENT,STR).
  check_sentence(_Win,SENT,STR):-
	process(_Win,SENT,STR),
	TaskWin=vpi_GetTaskWin(),
	dlg_tree_sentence_Create(TaskWin).

  dlg_sen_already_analysed(_Win,SENT,STR):-
	Title="Warning",
	Text="\nSentence already analysed",
	concat(STR,Text,Final),
	dlg_Note(Title,Final),
	tree_winno(SENT,W),!,
	_Window=win_GetParent(W),
	win_SetFocus(_Window).
	
  process(_Win,SENT,STR):-	
	dbl_sent(_Win,STR),
	list_sen,all_sen(X),!,
	LB_2=win_GetCtlHandle(_Win,idc_ledit_2),
	lbox_Clear(LB_2),
	lbox_add(LB_2,-1,X),
	win_SetText(LB_2,STR),
	retractall(all_sen(_)),
	assert(all_sen([])),
	retractall(sen_an(_)),
	assert(sen_an(SENT)),
	asserta(sen_an1(SENT,STR)).
	
  dbl_sent(_Win,STR):-sen(STR),!.
  dbl_sent(_Win,STR):-
	asserta(sen(STR)),
	asserta(update_flag),
	EW=win_GetCtlHandle(_Win,idc_update_sentence),
	win_SetState(EW,[wsf_Enabled]).

PREDICATES
  run(SENTENCE,TREE)
  draw_sentence(SENTENCE,TREE,TREE)
  draw_nounp(NOUNP,TREE)
  draw_relcl(RELCL,TREE)
  draw_verbp(VERBP,TREE)

CLAUSES
  run(SENT,Tree):-
	draw_sentence(SENT,Tree1,Tree3),
	Tree=tree("SENTENCE",unmarked,
		[Tree1,Tree3],0).

  draw_sentence(question(vp(AUX,VERB),np(NOUN)),Tree1,Tree3):-
	A=tree("AUXILIARY",unmarked,
		[tree(AUX,unmarked,[],0)
			],0),
	V=tree("VERB",unmarked,
		[tree(VERB,unmarked,[],0)
			],0),
	Tree1=tree("VERB_PHRASE",unmarked,[A,V],0),
	Tree3=tree("NOUN_PHRASE",unmarked,
		[tree(NOUN,unmarked,[],0)
			],0).
						
  draw_sentence(sent(NOUNP,VERBP),Tree1,Tree3):-
	draw_nounp(NOUNP,Tree1),
	draw_verbp(VERBP,Tree3).

  draw_nounp(nounp(none,X1,none),Tree1):-
	count_noun(W),!,
	W1=W+1,
	retractall(count_noun(_)),
	asserta(count_noun(W1)),		
	str_int(STR,W),
	concat("NOUN_PHRASE_",STR,Final),
	concat("NOUN_",STR,Final1),
	Tree1=tree(Final,unmarked,
		[tree(Final1,unmarked,
			[tree(X1,unmarked,[],0)],0)
		],0).
  draw_nounp(nounp(deter(X1),X2,none),Tree1):-
	count_noun(W1),
	count_det(W2),!,
	WW1=W1+1,WW2=W2+1,
	retractall(count_noun(_)),
	retractall(count_det(_)),
	asserta(count_noun(WW1)),
	asserta(count_det(WW2)),								
	str_int(STR1,W1),
	str_int(STR2,W2),
	concat("NOUN_PHRASE_",STR1,Final),
	concat("NOUN_",STR1,Final1),
	concat("DETERMINER_",STR2,Final2),
	Tree1=tree(Final,unmarked,
		[tree(Final2,unmarked,
			[tree(X1,unmarked,[],0)],0),
		tree(Final1,unmarked,
			[tree(X2,unmarked,[],0)],0)
		],0).
  draw_nounp(nounp(none,X1,relcl(X2,X3)),Tree1):-
	count_noun(W),!,
	W1=W+1,
	retractall(count_noun(_)),
	asserta(count_noun(W1)),					
	str_int(STR,W),
	concat("NOUN_PHRASE_",STR,Final),
	concat("NOUN_",STR,Final1),
	draw_relcl(relcl(X2,X3),Tree2),
	Tree1=tree(Final,unmarked,
		[tree(Final1,unmarked,
			[tree(X1,unmarked,[],0)],0),
		Tree2],0).
  draw_nounp(nounp(deter(X1),X2,relcl(X3,X4)),Tree1):-
	count_noun(W1),
	count_det(W2),!,
	WW1=W1+1,WW2=W2+1,
	retractall(count_noun(_)),
	retractall(count_det(_)),
	asserta(count_noun(WW1)),
	asserta(count_det(WW2)),								
	str_int(STR1,W1),
	str_int(STR2,W2),
	concat("NOUN_PHRASE_",STR1,Final),
	concat("NOUN_",STR1,Final1),
	concat("DETERMINER_",STR2,Final2),
	draw_relcl(relcl(X3,X4),Tree2),
	Tree1=tree(Final,unmarked,
		[tree(Final2,unmarked,
			[tree(X1,unmarked,[],0)],0),
		tree(Final1,unmarked,
			[tree(X2,unmarked,[],0)],0),
		Tree2],0).

  draw_verbp(verb(X1),Tree3):-
	count_verb(W),!,
	W1=W+1,
	retractall(count_verb(_)),
	asserta(count_verb(W1)),					
	str_int(STR,W),
	concat("VERB_PHRASE_",STR,Final),
	concat("VERB_",STR,Final1),
	Tree3=tree(Final,unmarked,
		[tree(Final1,unmarked,
			[tree(X1,unmarked,[],0)],0)
		],0).
	
  draw_verbp(verbp(X1,X2),Tree3):-
	draw_nounp(X2,Tree5),
	count_verb(W),!,
	W1=W+1,
	retractall(count_verb(_)),
	asserta(count_verb(W1)),					
	str_int(STR,W),
	concat("VERB_PHRASE_",STR,Final),
	concat("VERB_",STR,Final1),
	Tree3=tree(Final,unmarked,
		[tree(Final1,unmarked,
			[tree(X1,unmarked,[],0)],0),
		Tree5],0).			

  draw_relcl(relcl(X1,X2),Tree2):-
	count_rel(W),!,
	W1=W+1,
	retractall(count_rel(_)),
	asserta(count_rel(W1)),					
	str_int(STR,W),
	concat("RELATIONAL_CLAUSE_",STR,Final),
	concat("RELATIVE_",STR,Final1),
	draw_verbp(X2,Tree4),
	Tree2=tree(Final,unmarked,
		[tree(Final1,unmarked,
			[tree(X1,unmarked,[],0)],0),
		Tree4],0).

PREDICATES
  pdctree_handler : EHANDLER

CLAUSES

  pdctree_handler(_Win,e_Create(_),0):- 
	sen_an(SENT),!,
	run(SENT,Tree),
	TreeFont=font_Create(ff_Times,[],10),
	TreeWinInfo=tree_WinInfo(TreeFont,tree_DirRight,[]),
	tree_CreateSubClass(_Win,Tree,TreeWinInfo,[]),
	asserta(tree_winno(SENT,_Win)).

  pdctree_handler(W,e_MouseDbl(_,_,_),0):-
	tree_OpenCloseNode(W).

  pdctree_handler(_Win,e_Menu(id_bottom,_ShiftCtlAlt),0):-!,
	tree_SetDirection(_Win,tree_DirDown),
	!.
  pdctree_handler(_Win,e_Menu(id_right,_ShiftCtlAlt),0):-!,
	tree_SetDirection(_Win,tree_DirRight),
	!.
  pdctree_handler(_Win,e_Menu(id_left,_ShiftCtlAlt),0):-!,
	tree_SetDirection(_Win,tree_DirLeft),
	!.
  pdctree_handler(_Win,e_Menu(id_top,_ShiftCtlAlt),0):-!,
	tree_SetDirection(_Win,tree_DirUp),
	!.
  pdctree_handler(_Win,e_Menu(id_close,_ShiftCtlAlt),0):-!,
	retract(tree_winno(X,_Win)),!,
	retractall(sen_an1(X,_)),
	retractall(del_sentence(X)),
	_Window=win_GetParent(_Win),
	win_Destroy(_Window),
	!.
  pdctree_handler(_Win,e_MouseDown(_PNT,_ShiftCtlAlt,1),0):-!,
	menu_PopUp(_Win,res_menu(idr_menu_tree),_PNT,align_Right),
	!.

PREDICATES
  check_word(WINDOW,string)

CLAUSES
  check_word(_Win,X):-word(X),!.
  check_word(_Win,X):-
	LB_1=win_GetCtlHandle(_Win,idc_ledit_1),
	lbox_Clear(LB_1),
	asserta(word(X)),
	list_word(List),
	lbox_add(LB_1,-1,List),
	win_SetText(LB_1,X).

PREDICATES
  war_message(string)
  war_message1(string)
  
CLAUSES
  war_message(X):-
	T=" - already loaded",
	concat(X,T,Final),
	Title="Warning",
	dlg_Note(Title,Final).

  war_message1(X):-
	Title="Warning",
	T="Invalid word: ",
	concat(T,X,Final),
	dlg_Note(Title,Final).
 	
PREDICATES
  check_dbl_empt(WINDOW,string,string)
  check_verb(WINDOW,string)
  check_noun(WINDOW,string)
  check_det(WINDOW,string)
  check_rel(WINDOW,string)

CLAUSES
  check_dbl_empt(_Win,X,_):-
	X="",!,
	Title="Warning",
	dlg_Note(Title,"String empty ").
  check_dbl_empt(_Win,X,Y):-
	Y="verb",!,
	check_verb(_Win,X).
  check_dbl_empt(_Win,X,Y):-
	Y="noun",!,
	check_noun(_Win,X).
  check_dbl_empt(_Win,X,Y):-
	Y="determiner",!,
	check_det(_Win,X).
  check_dbl_empt(_Win,X,Y):-
	Y="relative",!,
	check_rel(_Win,X).
  check_dbl_empt(_,_,_):-
	Title="Error",
	dlg_Note(Title,"Invalid group").

  check_verb(_Win,X):-
	is_verb(X),!,
	war_message(X).
  check_verb(_Win,X):-
	update_flag,!,
	asserta(verb(X)),
	check_word(_Win,X),
	assert(update_lbox).
  check_verb(_Win,X):-
	asserta(verb(X)),
	check_word(_Win,X),
	asserta(update_flag),
	asserta(update_lbox).
	
  check_noun(_Win,X):-
	is_noun(X),!,
	war_message(X).
  check_noun(_Win,X):-
	update_flag,!,
	asserta(noun(X)),
	check_word(_Win,X),
	asserta(update_lbox).
  check_noun(_Win,X):-
	asserta(noun(X)),
	check_word(_Win,X),
	asserta(update_flag),
	asserta(update_lbox).
	
  check_det(_Win,X):-
	is_det(X),!,
	war_message(X).
  check_det(_Win,X):-
	update_flag,!,
	asserta(det(X)),
	check_word(_Win,X),
	asserta(update_lbox).
  check_det(_Win,X):-
	asserta(det(X)),
	check_word(_Win,X),
	asserta(update_flag),
	asserta(update_lbox).
	
  check_rel(_Win,X):-
	is_rel(X),!,
	war_message(X).
  check_rel(_Win,X):-
	update_flag,!,
	asserta(rel(X)),
	check_word(_Win,X),
	asserta(update_lbox).
  check_rel(_Win,X):-
	asserta(rel(X)),
	check_word(_Win,X),
	asserta(update_flag),
	asserta(update_lbox).

PREDICATES
  check_erase(WINDOW,string,string)
  erase_verb(WINDOW,string)
  erase_noun(WINDOW,string)
  erase_det(WINDOW,string)
  erase_rel(WINDOW,string)

CLAUSES
  check_erase(_Win,X,_):-
	X="",!,
	Title="Warning",
	dlg_Note(Title,"String empty ").
  check_erase(_Win,X,Y):-
	Y="verb",!,
	erase_verb(_Win,X).
  check_erase(_Win,X,Y):-
	Y="noun",!,
	erase_noun(_Win,X).
  check_erase(_Win,X,Y):-
	Y="determiner",!,
	erase_det(_Win,X).
  check_erase(_Win,X,Y):-
	Y="relative",!,
	erase_rel(_Win,X).
  check_erase(_,_,_):-
	Title="Error",
	dlg_Note(Title,"Invalid group").

  erase_verb(_Win,X):-
	update_flag,
	is_verb(X),!,
	retractall(verb(X)),
	check_word(_Win,X),
	asserta(update_lbox).
  erase_verb(_Win,X):-
	is_verb(X),!,
	retractall(verb(X)),
	check_word(_Win,X),
	asserta(update_flag),
	asserta(update_lbox).
  erase_verb(_Win,X):-
	war_message1(X).

  erase_noun(_Win,X):-
	update_flag,
	is_noun(X),!,
	retractall(noun(X)),
	check_word(_Win,X),
	asserta(update_lbox).
  erase_noun(_Win,X):-
	is_noun(X),!,
	retractall(noun(X)),
	check_word(_Win,X),
	asserta(update_flag),
	asserta(update_lbox).
  erase_noun(_Win,X):-
	war_message1(X).

  erase_det(_Win,X):-
	update_flag,
	is_det(X),!,
	retractall(det(X)),
	check_word(_Win,X),
	asserta(update_lbox).
  erase_det(_Win,X):-
	is_det(X),!,
	retractall(det(X)),
	check_word(_Win,X),
	asserta(update_flag),
	asserta(update_lbox).
  erase_det(_Win,X):-
	war_message1(X).

  erase_rel(_Win,X):-
	update_flag,
	is_rel(X),!,
	retractall(rel(X)),
	check_word(_Win,X),
	asserta(update_lbox).
  erase_rel(_Win,X):-
	is_rel(X),!,
	retractall(rel(X)),
	check_word(_Win,X),
	asserta(update_flag),
	asserta(update_lbox).
  erase_rel(_Win,X):-
	war_message1(X).

PREDICATES
  tree_close

CLAUSES
  tree_close:-
	tree_winno(_,_Win),
	_Window=win_GetParent(_Win),
	win_Destroy(_Window),
	fail.
  tree_close.	

PREDICATES
  open_existfile(string)

CLAUSES
  open_existfile(FILENAME):-
	existfile(FILENAME),
	assert(open),!.
  open_existfile(FILENAME):-
	Text="File ",
	Text1=" not found",
	concat(Text,FILENAME,F1),
	concat(F1,Text1,Final),
	Title="Error",
	dlg_Note(Title,Final),
	retractall(open).
		
PREDICATES
  check_list(WINDOW,slist,string)
  check_list(slist,string)
  check_list(slist)

CLAUSES
  check_list(QQ,X):-
	QQ=[X|_],
	X<>"",!.
  check_list(_,X):-X="".
	
  check_list(_Win,QQ,X):-
	QQ=[X|_],
	X<>"",!,
	EW=win_GetCtlHandle(_Win,idc_update_sentence),
	win_SetState(EW,[wsf_Enabled]).
  check_list(_Win,_,X):-X="",
	Title="Warning",
	dlg_Note(Title,"The database not contain sentences"),
	EW=win_GetCtlHandle(_Win,idc_update_sentence),
	win_SetState(EW,[wsf_Disabled]).
	
  check_list([]):-!,
	Title="Warning",
	dlg_Note(Title,"The database not contain key words").
  check_list(_).	

PREDICATES
  erase_word(WINDOW,slist)

CLAUSES
  erase_word(_Win,[]):-!,
	EW=win_GetCtlHandle(_Win,idc_erase_word),
	win_SetState(EW,[wsf_Disabled]),
	EW1=win_GetCtlHandle(_Win,idc_static),
	win_SetText(EW1,"").
  erase_word(_Win,_):-
	EW=win_GetCtlHandle(_Win,idc_erase_word),
	win_SetState(EW,[wsf_Enabled]).
		
PREDICATES
  new_database(WINDOW)
  open_database(WINDOW)

CLAUSES
  new_database(_Win):-
 	tree_close,
	retractall(_),
	retractall(_,count),
	retractall(_,update),
	FILENAME="UNTITLED.SAN",
	concat("SEN_AN","   ",F1),
	concat(F1,FILENAME,Final),
	win_SetText(_Win,Final),
	asserta(name_open_file(FILENAME)),
	EW=win_GetCtlHandle(_Win,idc_save),
	win_SetText(EW,"Save as"),
	asserta(all_sen([])),
	EW1=win_GetCtlHandle(_Win,idc_lbox),
	lbox_Clear(EW1),
	EW2=win_GetCtlHandle(_Win,idc_ledit_2),
	lbox_Clear(EW2),
	EW3=win_GetCtlHandle(_Win,idc_ledit_1),
	lbox_Clear(EW3),
	assert(open_new_file,update),
	EW4=win_GetCtlHandle(_Win,idc_update_sentence),
	win_SetState(EW4,[wsf_Disabled]),
	EW5=win_getCtlHandle(_Win,idc_erase_word),
	win_SetState(EW5,[wsf_Disabled]),
	EW6=win_GetCtlHandle(_Win,idc_static),
	win_SetText(EW6,"").
	
  open_database(_Win):-
	Title="Open file",
	FILENAME=dlg_GetOpenFileName("*.san",["*.san","*.san","*.*","*.*"],Title),
	FILENAME<>"",
 	open_existfile(FILENAME),
 	open,
 	tree_close,
 	retractall(_),
 	retractall(_,count),
 	retractall(_,update),
 	consult(FILENAME),
	concat("SEN_AN"," ",F1),
	concat(F1,FILENAME,Final),
	win_SetText(_Win,Final),
	Text="Save",
	W=win_GetCtlHandle(_Win,idc_save),
	win_SetText(W,Text),
	asserta(name_open_file(FILENAME)),
	assert(all_sen([])),
	LB_1=win_GetCtlHandle(_Win,idc_lbox),
	fillbox(WORDS),
	check_list(WORDS),
	erase_word(_Win,WORDS),
	lbox_Clear(LB_1),
	lbox_add(LB_1,-1,WORDS),
	list_sen,all_sen(QQ),!,
	LB_2=win_GetCtlHandle(_Win,idc_ledit_2),
	lbox_Clear(LB_2),
	lbox_add(LB_2,-1,QQ),
	check_list(_Win,QQ,H),
	win_SetText(LB_2,H),
	LB_3=win_GetCtlHandle(_win,idc_ledit_1),
	lbox_Clear(LB_3),
	retractall(all_sen(_)),
	assert(all_sen([])),
	_Window=win_GetCtlHandle(_Win,idc_static),
	win_SetText(_Window,"").

PREDICATES
  select_close(WINDOW,integer)
  select_close1(WINDOW,integer)
  select_save(WINDOW)

CLAUSES
  select_close(_Win,0):-!,
	select_save(_Win),
	new_database(_Win).
  select_close(_Win,1):-
	new_database(_Win).
	
  select_close1(_Win,0):-!,
	select_save(_Win),
	open_database(_Win).
  select_close1(_Win,1):-
	open_database(_Win).
	
  select_save(_Win):-open_new_file,!,
  	Title="Save as file",
	FILENAME = dlg_GetSaveFileName("*.san",["*.san","*.san","*.*","*.*"],Title),
	FILENAME<>"",
	concat("SEN_AN"," ",F1),
	concat(F1,FILENAME,Final),
	win_SetText(_Win,Final),
	retractall(update_flag),
	openwrite(myfile,FILENAME),
	closefile(myfile),
	save(FILENAME),
	EW=win_GetCtlHandle(_Win,idc_save),
	win_SetText(EW,"Save").
	
  select_save(_Win):-
	retractall(update_flag),
	name_open_file(FILENAME),!,
	openwrite(myfile,FILENAME),
	closefile(myfile),
	save(FILENAME).

PREDICATES
  select_CloseRequest(WINDOW,integer)

CLAUSES
  select_CloseRequest(_Win,0):-open_new_file,!,
  	Title="Save as file",
	FILENAME = dlg_GetSaveFileName("*.san",["*.san","*.san","*.*","*.*"],Title),
	FILENAME<>"",
	openwrite(myfile,FILENAME),
	closefile(myfile),
	save(FILENAME),
	_Window=win_GetParent(_Win),
	win_Destroy(_Window).

  select_CloseRequest(_Win,0):-!,
	select_save(_Win),
	_Window=win_GetParent(_Win),
	win_Destroy(_Window).
  select_CloseRequest(_Win,1):-!,
	_Window=win_GetParent(_Win),
	win_Destroy(_Window).
	
PREDICATES
  start_dlg_update_sentence(slist)
  start_dlg_sen_an(slist,slist,string)

CLAUSES
  start_dlg_update_sentence(SENTENCE):-
	retractall(all_sen(_)),
	assert(all_sen([])),
	list_sen,all_sen(SENTENCE),
	!.

  start_dlg_sen_an(WORDS,QQ,X):-
	existfile("sen_an.san"),
	consult("sen_an.san"),
	asserta(name_open_file("SEN_AN.SAN")),
	fillbox(WORDS),
	check_list(WORDS),
	retractall(all_sen(_)),
	assert(all_sen([])),
	list_sen,all_sen(QQ),
	check_list(QQ,X),
	!.
  start_dlg_sen_an(WORDS,QQ,X):-
	Title="Warning",
	dlg_Note(Title,"File sen_an.san not found "),
	WORDS=[],QQ=[],X="".

PREDICATES
  check_empty_sentence(WINDOW,slist)
  check_tree_active(string)
  select_tree_active(integer,SENTENCE,WINDOW)

CLAUSES
  check_empty_sentence(_Win,[]):-!,
	EW=win_GetCtlHandle(_Win,idc_delete),
	EW1=win_GetCtlHandle(_Win,idc_delete_all),
	win_SetState(EW,[wsf_Disabled]),
	win_SetState(EW1,[wsf_Disabled]),
	_Window=win_GetParent(_Win),
	EW2=win_GetCtlHandle(_Window,idc_update_sentence),
	win_SetState(EW2,[wsf_Disabled]).
  check_empty_sentence(_Win,_).	

  check_tree_active(STR):-
	tokl(STR,TOKL),
	s_sentence(TOKL,_,SENT),
	tree_winno(SENT,_Win),!,
	Title="Question",
	Text="Tree sentence\n",
	Text1="\nis active. Close ?",
	concat(Text,STR,F1),
	concat(F1,Text1,Final),
	_ANSWER = dlg_Ask(Title,Final,["Yes","No"]),
	select_tree_active(_ANSWER,SENT,_Win).
  check_tree_active(_).

  select_tree_active(0,SENT,_Win):-!,
	_Window=win_GetParent(_Win),
	retract(tree_winno(SENT,_Win)),!,
	retractall(sen_an1(SENT,_)),
	retractall(del_sentence(SENT)),
	win_Destroy(_Window).
  select_tree_active(_,SENT,_):-
	asserta(del_sentence(SENT)).	
	
PREDICATES
  delete_all_sentence
  search_group(string,string)

CLAUSES
  delete_all_sentence:-
	tree_winno(SENT,_Win),
	sen_an1(SENT,STR),
	Title="Question",
	Text="Tree sentence\n",
	Text1="\nis active. Close ?",
	concat(Text,STR,F1),
	concat(F1,Text1,Final),
	_ANSWER = dlg_Ask(Title,Final,["Yes","No"]),
	select_tree_active(_ANSWER,SENT,_Win),
	fail.
  delete_all_sentence.
	
  search_group(X,Y):-
	is_noun(X),!,
	Y="noun".
  search_group(X,Y):-
	is_verb(X),!,
	Y="verb".
  search_group(X,Y):-
	is_det(X),!,
	Y="determiner".
  search_group(X,Y):-
	is_rel(X),!,
	Y="relative".
				
%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 20:50:58-10.12.1996, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_Invisible,wsf_ClipSiblings,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Sen_An"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 20:50:58-10.12.1996, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 20:50:58-10.12.1996, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	class_Create("TREE",pdctree_handler),
	dlg_sen_an_Create(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("sen_an.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
IFDEF use_message
	msg_Resize(_Win),
ENDDEF
	!.
%END Task Window, e_Size

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
ifdef platform_16bit
  	vpi_ShowHelpContext("sen_w16.hlp",HelpTopic),
elsedef  
  	vpi_ShowHelpContext("sen_an.hlp",HelpTopic),
enddef
 	!.

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
ENDDEF
IFDEF use_tbar
  vpi_SetAttrVal(attr_win_tbar,use_tbar),
ENDDEF
IFDEF use_sbar
  vpi_SetAttrVal(attr_win_sbar,use_sbar),
ENDDEF
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"sen_an",task_win_Title).

%END_WIN Task Window



%BEGIN_DLG Tree sentence
/**************************************************************************
	Creation and event handling for dialog: Tree sentence
**************************************************************************/

CONSTANTS

%BEGIN Tree sentence, CreateParms, 19:47:04-25.11.1999, Code automatically updated!
  dlg_tree_sentence_ResID = idd_tree_sentence
  dlg_tree_sentence_DlgType = wd_Modeless
  dlg_tree_sentence_Help = idh_contents
%END Tree sentence, CreateParms

PREDICATES

  dlg_tree_sentence_eh : EHANDLER
  dlg_tree_sentence_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_tree_sentence_Create(Parent):-

%MARK Tree sentence, new variables
	dialog_CreateModeless(Parent,dlg_tree_sentence_ResID,"Tree sentence",
  		[
%BEGIN Tree sentence, ControlList, 19:47:04-25.11.1999, Code automatically updated!
%END Tree sentence, ControlList
		],
		dlg_tree_sentence_eh,0),!.

  dlg_tree_sentence_update(_VALLIST):-!,
%BEGIN Tree sentence, Update controls, 19:47:04-25.11.1999, Code automatically updated!
%END Tree sentence, Update controls
	!.
%MARK Tree sentence, new events

%BEGIN Tree sentence, e_Move
  dlg_tree_sentence_eh(_Win,e_Move(_X,_Y),0):-!,
	RCT=win_GetClientRect(_Win),
	RCT=rct(_,_,R,B),
	Left=15, Top=15, 
	Right=R-15, Bottom=B-15,
	RCT1=rct(Left,Top,Right,Bottom),
	W=win_GetCtlHandle(_Win,idc_tree_sentence_1),
	win_Move(W,RCT1),
	!.
%END Tree sentence, e_Move

%BEGIN Tree sentence, e_CloseRequest
  dlg_tree_sentence_eh(_Win,e_CloseRequest,0):-!,
	W=win_GetCtlHandle(_Win,idc_tree_sentence_1),
	retract(tree_winno(X,W)),!,
	retractall(sen_an1(X,_)),
	retractall(del_sentence(X)),
	win_Destroy(_Win),
	!.
%END Tree sentence, e_CloseRequest

  dlg_tree_sentence_eh(_,_,0):-!,fail.
%END_DLG Tree sentence

%BEGIN_DLG Update sentence
/**************************************************************************
	Creation and event handling for dialog: Update sentence
**************************************************************************/

CONSTANTS

%BEGIN Update sentence, CreateParms, 19:46:54-25.11.1999, Code automatically updated!
  dlg_update_sentence_ResID = idd_update_sentence
  dlg_update_sentence_DlgType = wd_Modal
  dlg_update_sentence_Help = idh_contents
%END Update sentence, CreateParms

PREDICATES

  dlg_update_sentence_eh : EHANDLER
  dlg_update_sentence_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_update_sentence_Create(Parent):-
	start_dlg_update_sentence(SENTENCE),
	
%MARK Update sentence, new variables

	dialog_CreateModal(Parent,dlg_update_sentence_ResID,"Update sentence",
  		[
%BEGIN Update sentence, ControlList, 19:46:54-25.11.1999, Code automatically updated!
		df(idc_update_sentence_1,listbox(SENTENCE,[0]),nopr)
%END Update sentence, ControlList
		],
		dlg_update_sentence_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_update_sentence_update(VALLIST),!.

  dlg_update_sentence_update(_VALLIST):-!,
%BEGIN Update sentence, Update controls, 19:46:54-25.11.1999, Code automatically updated!
	dialog_VLGetListBox(idc_update_sentence_1,_VALLIST,_SENTENCE,_IDC_UPDATE_SENTENCE_1_SELECT),
%END Update sentence, Update controls
	!.

%MARK Update sentence, new events

%BEGIN Update sentence, e_Create
  dlg_update_sentence_eh(_Win,e_Create(_CreationData),0):-!,
	!.
%END Update sentence, e_Create

%BEGIN Update sentence, idc_delete_all _CtlInfo
  dlg_update_sentence_eh(_Win,e_Control(idc_delete_all,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(sen(_)),
	delete_all_sentence,
	EW1=win_GetCtlHandle(_Win,idc_update_sentence_1),
	lbox_Clear(EW1),
	W=win_GetParent(_Win),
	EW2=win_GetCtlHandle(W,idc_ledit_2),
	lbox_Clear(EW2),
	assert(update_flag),
	EW3=win_GetCtlHandle(_Win,idc_delete),
	win_SetState(EW3,[wsf_Disabled]),
	EW4=win_GetCtlHandle(_Win,idc_delete_all),
	win_SetState(EW4,[wsf_Disabled]),
	_Window=win_GetParent(_Win),
	EW5=win_GetCtlHandle(_Window,idc_update_sentence),
	win_SetState(EW5,[wsf_Disabled]),
	!.
%END Update sentence, idc_delete_all _CtlInfo

%BEGIN Update sentence, idc_delete _CtlInfo
  dlg_update_sentence_eh(_Win,e_Control(idc_delete,_CtrlType,_WinType,_CtlInfo),0):-!,
	EDWIN=win_GetCtlHandle(_Win,idc_update_sentence_1),
	Index=lbox_GetSelIndex(EDWIN),
	Item=lbox_GetItem(EDWIN,Index),
	Item<>"",
	check_tree_active(Item),	
	retractall(sen(Item)),
	retractall(all_sen(_)),
	assert(all_sen([])),
	assert(update_flag),
	list_sen,all_sen(SENTENCE),!,
	check_empty_sentence(_Win,SENTENCE),
	lbox_Clear(EDWIN),
	lbox_Add(EDWIN,-1,SENTENCE),
	W=win_GetParent(_Win),
	EW2=win_GetCtlHandle(W,idc_ledit_2),
	lbox_Clear(EW2),
	lbox_Add(EW2,-1,SENTENCE),
	SENTENCE=[Head|_],
	win_SetText(EW2,Head),
	!.
%END Update sentence, idc_delete _CtlInfo

%BEGIN Update sentence, idc_update_sentence_1 lbox(_DblClick)
  dlg_update_sentence_eh(_Win,e_Control(idc_update_sentence_1,_CtrlType,LBWIN,activated()),0):-!,
  	Index=lbox_GetSelIndex(LBWIN),
	Item=lbox_GetItem(LBWIN,Index),
	check_tree_active(Item),	
	retractall(sen(Item)),
	retractall(all_sen(_)),
	assert(all_sen([])),
	assert(update_flag),
	list_sen,all_sen(SENTENCE),!,
	check_empty_sentence(_Win,SENTENCE),
	EW1=win_GetCtlHandle(_Win,idc_update_sentence_1),
	lbox_Clear(EW1),
	lbox_Add(EW1,-1,SENTENCE),
	W=win_GetParent(_Win),
	EW2=win_GetCtlHandle(W,idc_ledit_2),
	lbox_Clear(EW2),
	lbox_Add(EW2,-1,SENTENCE),
	SENTENCE=[Head|_],
	win_SetText(EW2,Head),
	!.
%END Update sentence, idc_update_sentence_1 lbox(_DblClick)

  dlg_update_sentence_eh(_,_,0):-!,fail.
%END_DLG Update sentence

%BEGIN_DLG SEN_AN
/**************************************************************************
	Creation and event handling for dialog: SEN_AN
**************************************************************************/

CONSTANTS

%BEGIN SEN_AN, CreateParms, 14:58:04-5.5.2000, Code automatically updated!
  dlg_sen_an_ResID = idd_sen_an
  dlg_sen_an_DlgType = wd_Modeless
  dlg_sen_an_Help = idh_contents
%END SEN_AN, CreateParms

PREDICATES

  dlg_sen_an_eh : EHANDLER
  dlg_sen_an_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_sen_an_Create(Parent):-
	start_dlg_sen_an(WORDS,QQ,X),
%MARK SEN_AN, new variables

	dialog_CreateModeless(Parent,dlg_sen_an_ResID,"",
  		[
%BEGIN SEN_AN, ControlList, 14:58:04-5.5.2000, Code automatically updated!
		df(idc_lbox,listbox(WORDS,[0]),nopr),
		df(idc_ledit_2,listedit(QQ,X),nopr),
		df(idc_group,listbutton(["noun","relative","verb","determiner"],0),nopr),
		df(idc_ledit_1,listedit([],""),nopr)
%END SEN_AN, ControlList
		],
		dlg_sen_an_eh,0),!.

  dlg_sen_an_update(_VALLIST):-!,
%BEGIN SEN_AN, Update controls, 14:58:04-5.5.2000, Code automatically updated!
	dialog_VLGetListBox(idc_lbox,_VALLIST,_WORDS,_IDC_LBOX_SELECT),
	_IDC_LEDIT_1_DEFAULT = dialog_VLGetListEdit(idc_ledit_1,_VALLIST),
	dialog_VLGetListButton(idc_group,_VALLIST,_IDC_GROUP_ITEMLIST,_IDC_GROUP_SELECT),
	_X = dialog_VLGetListEdit(idc_ledit_2,_VALLIST),
%END SEN_AN, Update controls
	!.

%MARK SEN_AN, new events

%BEGIN SEN_AN, idc_help _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(dlg_sen_an_Help),
	!.
%END SEN_AN, idc_help _CtlInfo



%BEGIN SEN_AN, idc_about _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_about,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	Window=win_GetParent(_Win),
	win_SendEvent(Window,e_menu(id_help_about,c_Nothing)),
	!.
%END SEN_AN, idc_about _CtlInfo

%BEGIN SEN_AN, idc_save _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_save,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	select_save(_Win),
	!.
%END SEN_AN, idc_save _CtlInfo

%BEGIN SEN_AN, idc_analysis _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_analysis,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(all_sen(_)),
	assert(all_sen([])),
	retractall(_,count),
	asserta(count_noun(1)),
	asserta(count_det(1)),
	asserta(count_verb(1)),
	asserta(count_rel(1)),
	EDWIN=win_GetCtlHandle(_Win,idc_ledit_2),
	QUESTIONTXT=win_GetText(EDWIN),
	tokl(QUESTIONTXT,TOKL),
	s_sentence(TOKL,_,SENT),
	select_run(_Win,SENT,QUESTIONTXT),
	!.
%END SEN_AN, idc_analysis _CtlInfo

%BEGIN SEN_AN, e_CloseRequest
  dlg_sen_an_eh(_Win,e_CloseRequest,0):-
	update_flag,
	name_open_file(FILENAME),!,
	Text="Do you want to save change to\n",
	concat(Text,FILENAME,Final),
	ANSWER = dlg_Ask("Question",Final,["Yes","No"]),
	select_CloseRequest(_Win,ANSWER),
	!.
  dlg_sen_an_eh(_Win,e_CloseRequest,0):-
	_Window=win_GetParent(_Win),
	win_Destroy(_Window),
	!.
%END SEN_AN, e_CloseRequest

%BEGIN SEN_AN, idc_open _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_open,_CtrlType,_CtrlWin,_CtlInfo),0):-
	update_flag,
	name_open_file(FILENAME),!,
	Text="Do you want to save change to\n",
	concat(Text,FILENAME,Final),
	ANSWER = dlg_Ask("Question",Final,["Yes","No","Cancel"]),
	ANSWER<>2,
	select_close1(_Win,ANSWER),
	!.
  dlg_sen_an_eh(_Win,e_Control(idc_open,_CtrlType,_CtrlWin,_CtlInfo),0):-
	open_database(_Win),
	!.
%END SEN_AN, idc_open _CtlInfo

%BEGIN SEN_AN, idc_lbox lbox(_DblClick)
  dlg_sen_an_eh(_Win,e_Control(idc_lbox,_CtrlType,LBWIN,activated()),0):-!,
	Index=lbox_GetSelIndex(LBWIN),
	Item=lbox_GetItem(LBWIN,Index),
	EDWIN=win_GetCtlHandle(_Win,idc_ledit_2),
	OLDTXT=win_GetText(EDWIN),
	concat(OLDTXT," ",TMPTXT),
	concat(TMPTXT,Item,FINALTXT),
	win_SetText(EDWIN,FINALTXT),
	!.
  dlg_sen_an_eh(_Win,e_Control(idc_lbox,_CtrlType,LBWIN,selchanged()),0):-!,
	Index=lbox_GetSelIndex(LBWIN),
	Item=lbox_GetItem(LBWIN,Index),
	search_group(Item,STR),
	EW=win_GetCtlHandle(_Win,idc_static),
	win_SetText(EW,STR),
	!.
%END SEN_AN, idc_lbox lbox(_DblClick)

%BEGIN SEN_AN, idc_add _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_add,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	EDWIN=win_GetCtlHandle(_Win,idc_lbox),
	Index=lbox_GetSelIndex(EDWIN),
	Item=lbox_GetItem(EDWIN,Index),
	EDWIN1=win_GetCtlHandle(_Win,idc_ledit_2),
	OLDTXT=win_GetText(EDWIN1),
	concat(OLDTXT," ",TMPTXT),
	concat(TMPTXT,Item,FINALTXT),
	win_SetText(EDWIN1,FINALTXT),
	!.
%END SEN_AN, idc_add _CtlInfo

%BEGIN SEN_AN, idc_exit _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_exit,_CtrlType,_CtrlWin,_CtlInfo),0):-
	update_flag,
	name_open_file(FILENAME),!,
	Text="Do you want to save change to\n",
	concat(Text,FILENAME,Final),
	ANSWER = dlg_Ask("Question",Final,["Yes","No","Cancel"]),
	ANSWER<>2,
	select_CloseRequest(_Win,ANSWER),
	!.
  dlg_sen_an_eh(_Win,e_Control(idc_exit,_CtrlType,_CtrlWin,_CtlInfo),0):-
	_Window=win_GetParent(_Win),
	win_Destroy(_Window),
	!.
%END SEN_AN, idc_exit _CtlInfo

%BEGIN SEN_AN, idc_add_new_word _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_add_new_word,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	EDWIN_1=win_GetCtlHandle(_Win,idc_group),
	Text_1=win_GetText(EDWIN_1),
	EDWIN_2=win_GetCtlHandle(_Win,idc_ledit_1),
	Text_2=win_GetText(EDWIN_2),
	check_dbl_empt(_Win,Text_2,Text_1),
	update_lbox,!,
	retractall(update_lbox),
	LB_1=win_GetCtlHandle(_Win,idc_lbox),
	lbox_Clear(LB_1),
	fillbox(WORDS),
	lbox_add(LB_1,-1,WORDS),
	erase_word(_Win,WORDS),
	!.
%END SEN_AN, idc_add_new_word _CtlInfo

%BEGIN SEN_AN, idc_erase_word _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_erase_word,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	EDWIN_1=win_GetCtlHandle(_Win,idc_group),
	Text_1=win_GetText(EDWIN_1),
	EDWIN_2=win_GetCtlHandle(_Win,idc_ledit_1),
	Text_2=win_GetText(EDWIN_2),
	check_erase(_Win,Text_2,Text_1),
	update_lbox,!,
	retractall(update_lbox),
	LB_1=win_GetCtlHandle(_Win,idc_lbox),
	lbox_Clear(LB_1),
	fillbox(WORDS),
	lbox_add(LB_1,-1,WORDS),
	erase_word(_Win,WORDS),
	!.
%END SEN_AN, idc_erase_word _CtlInfo

%BEGIN SEN_AN, idc_update_sentence _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_update_sentence,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dlg_update_sentence_Create(_Win),
	!.
%END SEN_AN, idc_update_sentence _CtlInfo

%BEGIN SEN_AN, idc_new _CtlInfo
  dlg_sen_an_eh(_Win,e_Control(idc_new,_CtrlType,_CtrlWin,_CtlInfo),0):-
	update_flag,
	name_open_file(FILENAME),!,
	Text="Do you want to save change to\n",
	concat(Text,FILENAME,Final),
	ANSWER = dlg_Ask("Question",Final,["Yes","No","Cancel"]),
	ANSWER<>2,
	select_close(_Win,ANSWER),
	!.
	
   dlg_sen_an_eh(_Win,e_Control(idc_new,_CtrlType,_CtrlWin,_CtlInfo),0):-
	new_database(_Win),
	!.
%END SEN_AN, idc_new _CtlInfo

%BEGIN SEN_AN, e_Create
  dlg_sen_an_eh(_Win,e_Create(_CreationData),0):-!,
	disk(OSPath),
	concat(OSPath,"\\SEN_AN.SAN",F),
	asserta(name_open_file(F)),
	Text="SEN_AN  ",
	concat(Text,F,Final),
	win_SetText(_Win,Final),
	retractall(all_sen(_)),
	assert(all_sen([])),
	list_sen,all_sen(QQ),
	check_list(_Win,QQ,_),
	fillbox(WORDS),
	erase_word(_Win,WORDS),
	!.
%END SEN_AN, e_Create

  dlg_sen_an_eh(_,_,0):-!,fail.
%END_DLG SEN_AN






















%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 02:35:41-2.11.1998, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0).

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog
