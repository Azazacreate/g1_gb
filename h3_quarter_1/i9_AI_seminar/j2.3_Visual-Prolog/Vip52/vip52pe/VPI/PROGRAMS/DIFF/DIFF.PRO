/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DIFF
 FileName: DIFF.PRO
 Purpose: Symbolic Differentation
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "diff.inc"
include "diff.con"
include "hlptopic.con"

DOMAINS
	TOKL = STRING*
	EXP=var(STRING);
	    int(INTEGER);
	    plus(EXP,EXP);
	    minus(EXP,EXP);
	    mult(EXP,EXP);
	    div(EXP,EXP);
	    ln(EXP);
	    cos(EXP); 
	    sin(EXP); 
	    tan(EXP); 
	    sec(EXP); 
	    potens(EXP,EXP)
	
DATABASE - listedit
	expression(string)
	all_sen(slist)
	old_expr(string)
	error_flag

PREDICATES
	diff(WINDOW)
	d(EXP,STRING,EXP);
	readexp(WINDOW,EXP);
	check(TOKL);

	writeexp1(WINDOW,EXP);
	writeexp2(WINDOW,EXP);
	strexp(EXP,string);
	strPOTENS(EXP,string);
	strMULT(EXP,string);
	strMINUS(EXP,string);
	strDIV(EXP,string);
	strPAR(EXP,string);

	tokl(STRING,TOKL);      /* Scanner */
	front(STRING,TOKL,TOKL);

	s_exp(TOKL,TOKL,EXP);   /* Parser */
	potensexp(TOKL,TOKL,EXP);
	potensexp1(TOKL,TOKL,EXP,EXP);
	multexp(TOKL,TOKL,EXP);
	multexp1(TOKL,TOKL,EXP,EXP);
	plusexp(TOKL,TOKL,EXP);
	plusexp1(TOKL,TOKL,EXP,EXP);
	elmexp(TOKL,TOKL,EXP);

	reduce(EXP,EXP);        /* Reducer */
	plusr(EXP,EXP,EXP);
	minusr(EXP,EXP,EXP);
	multr(EXP,EXP,EXP);
	divr(EXP,EXP,EXP);
	lnr(EXP,EXP)
	
	repeat
	list_sen
	error_dialog
	dbl_expr(string)
	append(slist,slist,slist)
	check_expression(WINDOW,string)
	
CLAUSES
  diff(_Win):- 
	readexp(_Win,EXP),
	d(EXP,"x",EXP1),
	reduce(EXP1,EXP2),
	writeexp1(_Win,EXP1),
	writeexp2(_Win,EXP2).
  repeat.
  repeat:- repeat.

/*
  CLAUSES FOR DIFFERENTIATION
*/
  d(int(_),_,int(0)):-!.
  d(var(X),X,int(1)):-!.
  d(var(X),_,E):-X="(",!,
	E=int(0),error_dialog,
	asserta(error_flag).
  d(var(X),_,E):-X=")",!,
	E=int(0),error_dialog,
	asserta(error_flag).
  d(var(X),_,E):-X="!",!,
	E=int(0),error_dialog,
	asserta(error_flag).
  d(var(X),_,E):-X="+",!,
	E=int(0),error_dialog,
	asserta(error_flag).
  d(var(X),_,E):-X="-",!,
	E=int(0),error_dialog,
	asserta(error_flag).
  d(var(X),_,E):-X="*",!,
	E=int(0),error_dialog,
	asserta(error_flag).
  d(var(X),_,E):-X="\\",!,
	E=int(0),error_dialog,
	asserta(error_flag).
  d(var(X),_,E):-X="^",!,
	E=int(0),error_dialog,
	asserta(error_flag).
  d(var(X),_,E):-X="_",!,
	E=int(0),error_dialog,
	asserta(error_flag).
  d(var(X),_,E):-X="/",!,
	E=int(0),error_dialog,
	asserta(error_flag).
  d(var(_),_,int(0)):-!.
  d(plus(U,V),X,plus(U1,V1)):-
	d(U,X,U1),
	d(V,X,V1),!.
  d(minus(U,V),X,minus(U1,V1)):-
	d(U,X,U1),
	d(V,X,V1),!.
  d(mult(U,V),X,plus(mult(U1,V),mult(U,V1))):-
	d(U,X,U1),
	d(V,X,V1),!.
  d(div(U,V),X,div(minus(mult(U1,V),mult(U,V1)),mult(V,V))):-
	d(U,X,U1),
	d(V,X,V1),!.
  d(ln(U),X,mult(div(int(1),U),U1)):-d(U,X,U1),!.
  d(potens(E1,int(I)),X,mult(mult(int(I),potens(E1,int(I1))),EXP)):- 
	I1=I-1, 
	d(E1,X,EXP),!.
  d(sin(U),X,mult(cos(U),U1)):-d(U,X,U1),!.
  d(cos(U),X,minus(int(0),mult(sin(U),U1))):-d(U,X,U1),!.
  d(tan(U),X,mult(potens(sec(U),int(2)),U1)):-d(U,X,U1),!.
  d(_,_,E):-!,
	E=int(0),
	error_dialog.

/*
  CLAUSES FOR READING OF AN EXPRESSION
*/
  readexp(_Win,EXP) :-
	EDWIN=win_GetCtlHandle(_Win,idc_diff_1),
	STR1=win_GetText(EDWIN),
	dbl_expr(STR1),
	tokl(STR1,TOKL),
	s_exp(TOKL,OL,EXP),
	!,
	check(OL).
  readexp(_,int(0)):-error_dialog.

  dbl_expr(X):-old_expr(X),!,
	Title="Warning",
	Text="Expression already analysed.",
	dlg_Note(Title,Text).
  dbl_expr(X):-
	retractall(old_expr(_)),
	asserta(old_expr(X)).

  check(OL):-OL=[],!.
  check(_):-!,error_dialog.

  error_dialog:-
	old_expr(X),!,
	Text="\nInvalid expression",
	concat(X,Text,Final),
	Title="Error",
	dlg_Note(Title,Final),
	asserta(error_flag),
	retractall(old_expr(_)).

  tokl(STR,[TOK|TOKL]):-
	fronttoken(STR,TOK,STR1),!,
	tokl(STR1,TOKL).
  tokl(_,[]).

/*
  CLAUSES FOR PARSING OF AN EXPRESSION
*/

  s_exp(IL,OL,EXP):-plusexp(IL,OL,EXP),!.

  plusexp(IL,OL,EXP2):-
	multexp(IL,OL1,EXP1),
	plusexp1(OL1,OL,EXP1,EXP2).

  plusexp1(["+"|IL],OL,EXP1,EXP3):-!,
	multexp(IL,OL1,EXP2),
	plusexp1(OL1,OL,plus(EXP1,EXP2),EXP3).
  plusexp1(["-"|IL],OL,EXP1,EXP3):-!,
	multexp(IL,OL1,EXP2),
	plusexp1(OL1,OL,minus(EXP1,EXP2),EXP3).
  plusexp1(IL,IL,EXP,EXP).

  multexp(IL,OL,EXP2):-
	potensexp(IL,OL1,EXP1),
	multexp1(OL1,OL,EXP1,EXP2).

  multexp1(["*"|IL],OL,EXP1,EXP3):-!,
	potensexp(IL,OL1,EXP2),
	multexp1(OL1,OL,mult(EXP1,EXP2),EXP3).
  multexp1(["/"|IL],OL,EXP1,EXP3):-!,
	potensexp(IL,OL1,EXP2),
	multexp1(OL1,OL,div(EXP1,EXP2),EXP3).
  multexp1(IL,IL,EXP,EXP).

  potensexp(IL,OL,EXP2):-
	elmexp(IL,OL1,EXP1),
	potensexp1(OL1,OL,EXP1,EXP2).
  potensexp1(["^"|IL],OL,EXP1,EXP3):-!,
	elmexp(IL,OL1,EXP2),!,
	potensexp1(OL1,OL,potens(EXP1,EXP2),EXP3).
  potensexp1(IL,IL,EXP,EXP).

  elmexp(["("|IL],OL,EXP):-
	s_exp(IL,OL1,EXP),
	front(")",OL1,OL),!.
  elmexp(["ln","("|IL],OL,ln(EXP)):-
	s_exp(IL,OL1,EXP),
	front(")",OL1,OL),!.
  elmexp(["sin","("|IL],OL,sin(EXP)):-
	s_exp(IL,OL1,EXP),
	front(")",OL1,OL),!.
  elmexp(["cos","("|IL],OL,cos(EXP)):-
	s_exp(IL,OL1,EXP),
	front(")",OL1,OL),!.
  elmexp(["tan","("|IL],OL,tan(EXP)):-
	s_exp(IL,OL1,EXP),
	front(")",OL1,OL),!.
  elmexp(["-",TALSTR|IL],IL,int(INT)):-!,
	str_int(TALSTR,INTp),
	INT = -INTp.
  elmexp([TALSTR|IL],IL,int(INT)):-str_int(TALSTR,INT),!.
  elmexp([NAME|IL],IL,var(NAME)).

  front(TOK,[TOK|L],L).

/*
  CLAUSE FOR WRITING OF AN EXPRESSION
*/
  writeexp1(_WIN,_):-error_flag,!,EXP=int(0),
	strexp(EXP,STR),
	EDWIN=win_GetCtlHandle(_Win,idc_diff_2),
	win_SetText(EDWIN,STR).
  writeexp1(_WIN,EXP):-
	strexp(EXP,STR),
	EDWIN=win_GetCtlHandle(_Win,idc_diff_2),
	win_SetText(EDWIN,STR).
  writeexp2(_WIN,_):-error_flag,!,
	STR="Result of function is undefined",
	EDWIN=win_GetCtlHandle(_Win,idc_diff_3),
	win_SetText(EDWIN,STR),
	retractall(error_flag).
  writeexp2(_WIN,EXP):-
	strexp(EXP,STR),
	EDWIN=win_GetCtlHandle(_Win,idc_diff_3),
	win_SetText(EDWIN,STR).
/*
  CLAUSES FOR REDUCTION OF AN EXPRESSION
*/

  reduce(plus(X,Y),R):- !,
	reduce(X,X1),
	reduce(Y,Y1),
	plusr(X1,Y1,R).
  reduce(minus(X,Y),R):-!,
	reduce(X,X1),
	reduce(Y,Y1),
	minusr(X1,Y1,R).
  reduce(mult(X,Y),R):-!,
	reduce(X,X1),
	reduce(Y,Y1),
	multr(X1,Y1,R).
  reduce(div(X,Y),R):-!,
	reduce(X,X1),
	reduce(Y,Y1),
	divr(X1,Y1,R).
  reduce(ln(X),R):-!,
	reduce(X,X1),
	lnr(X1,R).
  reduce(potens(E,int(1)),E):-!.
  reduce(R,R).

/*
  CLAUSES FOR REDUCTION OF AN ADDITION EXPRESSION
*/

  plusr(int(0),X,X):-!.
  plusr(X,int(0),X):-!.
  plusr(int(X),int(Y),int(Z)):-!,
	X+Y=Z.
  plusr(X,X,mult(int(2),X)):-!.
  plusr(int(X),Y,Z) :- 
	X < 0,
	T = -X, !,
	minusr(int(T),Y,Z).
  plusr(Y,int(X),Z) :-  
	X < 0,
	T = -X, !,
	minusr(int(T),Y,Z).
  plusr(mult(int(I),X),X,mult(int(I1),X)):-!,
	I+1=I1.
  plusr(X,mult(int(I),X),mult(int(I1),X)):-!,
	I+1=I1.
  plusr(mult(int(I1),X),mult(int(I2),X),mult(int(I3),X)):-!,
	I1+I2=I3.
  plusr(int(I),X,plus(X,int(I))):-!.
  plusr(plus(X,int(I1)),int(I2),plus(X,int(I3))):-!,
	I1+I2=I3.
  plusr(plus(X,int(I1)),plus(Y,int(I2)),plus(R,int(I3))):-!,
	I1+I2=I3,
	plusr(X,Y,R).
  plusr(plus(X,int(I)),Y,plus(R,int(I))):-!,
	plusr(X,Y,R).
  plusr(X,Y,plus(X,Y)).

/*
  CLAUSES FOR REDUCTION OF A MINUS EXPRESSION
*/

  minusr(int(X),int(Y),int(Z)):-!,
	Z=X-Y.
  minusr(X,int(0),X):-!.
  minusr(X,X,int(0)):-!.
  minusr(X,int(I),plus(int(I1),X)):- !,
	I1=-I.
  minusr(X,Y,minus(X,Y)).

/*
  CLAUSES FOR REDUCTION OF A MULTIPLICATION EXPRESSION
*/

  multr(int(X),int(Y),int(Z)):-!,
	X*Y=Z.
  multr(int(0),_,int(0)):-!.
  multr(_,int(0),int(0)):-!.
  multr(int(1),X,X):-!.
  multr(X,int(1),X):-!.
  multr(M,plus(X,Y),plus(X1,Y1)):-!,   
	multr(M,X,X1),multr(M,Y,Y1). 
  multr(M,minus(X,Y),minus(X1,Y1)):-!, 
	multr(M,X,X1),multr(M,Y,Y1). 
  multr(plus(X,Y),M,plus(X1,Y1)):-!, 
	multr(M,X,X1),multr(M,Y,Y1). 
  multr(minus(X,Y),M,minus(X1,Y1)):-!,
	multr(M,X,X1),multr(M,Y,Y1). 
  multr(mult(int(I1),X),int(I2),M1):-!,
	I1*I2=I3,
	multr(int(I3),X,M1).
  multr(int(I1),mult(int(I2),X),M1):-!,
	I1*I2=I3,
	multr(int(I3),X,M1).
  multr(mult(int(I1),X),mult(int(I2),Y),mult(int(I3),R)):-!,
	I1*I2=I3, 
	multr(X,Y,R).
  multr(mult(int(I),X),Y,mult(int(I),R)):-!,
	multr(X,Y,R).
  multr(X,int(I),mult(int(I),X)):-!.
  multr(potens(X,int(I1)),potens(X,int(I2)),potens(X,int(I3))):-!,
	I3=I1+I2.
  multr(X,potens(X,int(I)),potens(X,int(I1))):-!,
	I1=I+1.
  multr(potens(X,int(I)),X,potens(X,int(I1))):-!,
	I1=I+1.
  multr(X,X,potens(X,int(2))):-!.
  multr(X,Y,mult(X,Y)).

/*
  CLAUSES FOR REDUCTION OF A DIVISION EXPRESION
*/

  divr(int(0),_,int(0)):-!.
  divr(_,int(0),var("'endless'")):-!,
	error_dialog.
  divr(X,int(1),X):-!.
  divr(X,Y,div(X,Y)).

/*
  CLAUSES FOR REDUCTION OF A LOGARITHM EXPRESSION
*/

  lnr(int(0),var("endless")):-!,
	error_dialog.
  lnr(int(1),int(0)):-!.
  lnr(X,ln(X)).


/*
  CLAUSES FOR CONVERTING AN EXPRESSION TO A STRING
*/
% Taken from the old writeexp clauses

  strexp(var(NAME),NAME).
  strexp(int(INT),INTSTR) :-
	str_int(INTSTR,INT).
  strexp(ln(EXP),STR)  :-
	strPAR(EXP,STRp),
	concat("ln",STRp,STR).
  strexp(sin(EXP),STR) :- 
	strPAR(EXP,STRp),
	concat("sin",STRp,STR).
  strexp(cos(EXP),STR) :- 
	strPAR(EXP,STRp),
	concat("cos",STRp,STR).
  strexp(tan(EXP),STR) :- 
	 strPAR(EXP,STRp),
	concat("tan",STRp,STR).
  strexp(sec(EXP),STR) :- 
	strPAR(EXP,STRp),
	concat("sec",STRp,STR).
  strexp(plus(EXP1,EXP2),STR):-
	strexp(EXP1,STR1),
	concat(STR1,"+",STR3),
	strexp(EXP2,STR2),
	concat(STR3,STR2,STR).
  strexp(minus(EXP1,EXP2),STR):-
	strexp(EXP1,STR1),
	concat(STR1,"-",STR3),
	strMINUS(EXP2,STR2),
	concat(STR3,STR2,STR).
  strexp(mult(EXP1,EXP2),STR):-
	strMINUS(EXP1,STR1),
	concat(STR1,"*",STR3),
	strMULT(EXP2,STR2),
	concat(STR3,STR2,STR).
  strexp(div(EXP1,EXP2),STR):-
	strMULT(EXP1,STR1),
	concat(STR1,"/",STR3),
	strDIV(EXP2,STR2),
	concat(STR3,STR2,STR).
  strexp(potens(EXP1,EXP2),STR):-
	strDIV(EXP1,STR1), 
	concat(STR1,"^",STR3),
	strPOTENS(EXP2,STR2),
	concat(STR3,STR2,STR).

  strPOTENS(div(X,Y),STR):-!,strPAR(div(X,Y),STR).
  strPOTENS(X,STR):-strDIV(X,STR).

  strDIV(mult(X,Y),STR):-!,strPAR(mult(X,Y),STR).
  strDIV(X,STR):-strMULT(X,STR).

  strMULT(minus(X,Y),STR):- !,strPAR(minus(X,Y),STR).
  strMULT(X,STR):-strMINUS(X,STR).
  strMINUS(plus(X,Y),STR):-!,strPAR(plus(X,Y),STR).
  strMINUS(X,STR):-strexp(X,STR).

  strPAR(EXP,STR):-
	strexp(EXP,STR1),
	concat("(",STR1,STR2),
	concat(STR2,")",STR).
				
  check_expression(_Win,STR):-expression(STR),!.
  check_expression(_Win,STR):-
	asserta(expression(STR)),
	list_sen,all_sen(X),!,
	lbox_Clear(_Win),
	lbox_add(_Win,-1,X),
	win_SetText(_Win,STR),
	retractall(all_sen(_)),
	asserta(all_sen([])).
	
  list_sen:-
	expression(Y),
	all_sen(A),
	Z=[Y],
	append(A,Z,X),
	retractall(all_sen(_)),
	asserta(all_sen(X)),
	fail.
  list_sen.

  append([],List,List).
  append([X|L1],List2,[X|L3]):-
	append(L1,List2,L3).

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 17:09:44-25.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_Invisible]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "DIFF"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 17:09:44-25.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 17:09:44-25.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	asserta(all_sen([])),
	dlg_diff_Create(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
ifdef platform_16bit
  	vpi_ShowHelp("diff_w16.hlp"),
elsedef
  	vpi_ShowHelp("diff.hlp"),
enddef
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

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
ifdef platform_16bit
  	vpi_ShowHelpContext("diff_w16.hlp",HelpTopic),
elsedef
  	vpi_ShowHelpContext("diff.hlp",HelpTopic),
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"diff",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 12:57:54-26.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog
%BEGIN_DLG Diff
/**************************************************************************
	Creation and event handling for dialog: Diff
**************************************************************************/

CONSTANTS

%BEGIN Diff, CreateParms, 23:23:16-9.12.1999, Code automatically updated!
  dlg_diff_ResID = idd_diff
  dlg_diff_DlgType = wd_Modal
  dlg_diff_Help = idh_contents
%END Diff, CreateParms

PREDICATES

  dlg_diff_eh : EHANDLER
  dlg_diff_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_diff_Create(Parent):-

%MARK Diff, new variables

	dialog_CreateModal(Parent,dlg_diff_ResID,"",
  		[
%BEGIN Diff, ControlList, 23:23:16-9.12.1999, Code automatically updated!
		df(idc_diff_1,listedit([],""),nopr),
		df(idc_diff_2,editstr("",[]),nopr),
		df(idc_diff_3,editstr("",[]),nopr)
%END Diff, ControlList
		],
		dlg_diff_eh,0,VALLIST,ANSWER),!,
	ANSWER = idc_ok,
	TaskWin=vpi_GetTaskWin(),
	win_SendEvent(TaskWin,e_menu(id_file_exit,c_Nothing)),
	dlg_diff_update(VALLIST),!.

  dlg_diff_Create(_):-
	dlg_Note("Error: Fail in dlg_diff_Create").

  dlg_diff_update(_VALLIST):-
%BEGIN Diff, Update controls, 23:23:16-9.12.1999, Code automatically updated!
	_IDC_DIFF_1_DEFAULT = dialog_VLGetListEdit(idc_diff_1,_VALLIST),
	_IDC_DIFF_2_VALUE = dialog_VLGetstr(idc_diff_2,_VALLIST),
	_IDC_DIFF_3_VALUE = dialog_VLGetstr(idc_diff_3,_VALLIST),
%END Diff, Update controls
	!.
  dlg_diff_update(_):-
	dlg_Note("Error: Fail in dlg_diff_update").

%MARK Diff, new events

%BEGIN Diff, idc_about _CtlInfo
  dlg_diff_eh(_Win,e_Control(idc_about,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	TaskWin=win_GetParent(_Win),
	win_SendEvent(TaskWin,e_menu(id_help_about,c_Nothing)),
	!.
%END Diff, idc_about _CtlInfo

%BEGIN Diff, idc_analysis _CtlInfo
  dlg_diff_eh(_Win,e_Control(idc_analysis,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	diff(_Win),
	EW=win_GetCtlHandle(_Win,idc_diff_1),
	STR=win_GetText(EW),
	check_expression(EW,STR),
	!.
%END Diff, idc_analysis _CtlInfo

%BEGIN Diff, idc_help _CtlInfo
  dlg_diff_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(dlg_diff_Help),
	!.
%END Diff, idc_help _CtlInfo

%BEGIN Diff, e_Create
  dlg_diff_eh(_Win,e_Create(_CreationData),0):-!,
	A="x*(2+y)^2",
	EDWIN=win_GetCtlHandle(_Win,idc_diff_1),
	win_SetText(EDWIN,A),
	!.
%END Diff, e_Create

  dlg_diff_eh(_,_,_):-!,fail.

%END_DLG Diff


































































