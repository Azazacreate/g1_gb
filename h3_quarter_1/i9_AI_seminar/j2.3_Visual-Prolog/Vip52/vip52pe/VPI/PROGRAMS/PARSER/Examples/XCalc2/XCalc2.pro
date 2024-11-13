/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  XCALC2
 FileName: XCALC2.PRO
 Purpose: Calculator Demo of Parser Generator
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "xcalc2.inc"
include "xcalc2.con"
include "hlptopic.con"

constants
  end_of_text		= -1

facts - xcalc2
% Error message & cursor position
  determ  error(MESSAGE ErrMsg,integer CursorPos)

predicates
/* Is a deeper error */
  expect(TTOK TokenPos,TOKL Tokl,TOKL Tokl) - determ (t(i,o),i,o)	% Organization syntax error
  syntax_error(MESSAGE ErrMsg,TOKL Tokl) - determ (i,i)			% Set cursor to syntax error
  is_a_deeper_error(integer CursorPos) - determ (i)			% Check error message
  replace_error(MESSAGE ErrMsg,integer CursorPos) - procedure (i,i)	% Replace error message

include "..\\include\\xcalc.par"	% parser
include "..\\include\\xcalc.run"	% calculator
include "xcalc2.sca"			% scanner

clauses
  is_a_deeper_error(Position):-
  	error(_,Old_Cursor),
  	!,
  	Position > Old_Cursor.
  is_a_deeper_error(_).
  	
/* Replace error */
  replace_error(Message,Position):-
  	retractall(error(_,_)),
  	assert(error(Message,Position)).
  
/* expect & syntax_error */
  expect(TOK,[TOK|L],L):-!.
  expect(t(Token,_),[t(_,Position)|_],_):-
  	is_a_deeper_error(Position),
	string_token(String,Token),
  	format(Message,"Expected %.",String),
  	replace_error(Message,Position),
  	fail.
  expect(t(Token,_),[],_) :-
	string_token(String,Token),
  	format(Message,"Expected % (premature end of text).",String),
  	replace_error(Message,end_of_text),
  	fail.

  syntax_error(Prod,[t(_,Position)|_]):-
  	is_a_deeper_error(Position),
	format(Message,"Syntax error in %.",Prod),
	replace_error(Message,Position).
  syntax_error(Prod,[]):-
	format(Message,"Syntax error in % (premature end of text).",Prod),
  	replace_error(Message,end_of_text).  	

/* Result handler */
constants
  ctrlC = 3

predicates
  result_handler : EHANDLER

clauses
  result_handler(_Win,e_create(_),0):-!,
	Font = font_Create(ff_Times,[],11),
	edit_CreateSubClass(_Win,"",Font,b_true,b_true,b_false,"",1,result_handler),
	!.
  result_handler(_Win,e_Char(ctrlC,_),0):-
	edit_Copy(_Win),!.

/* Handling Run button 
	run - 					main predicate for evaluate of expression
	evaluate_expression - 			evaluate of the expression
	parse - 				use parsing predicates
	tokenize - 				activate scanner
	insure_list_is_empty - 			check empty unused tokens list
	point_to_error_if_appropriate - 	set cursor to error position
*/
predicates
  run(WINDOW SimplCalcDialogWindow) - determ (i)
  evaluate_expression(SOURCE Text,WINDOW ResultWindow) - determ (i,i)
  tokenize(SOURCE Text,TOKL Tokl) - determ (i,o)
  parse(TOKL Tokl,EXPR Expression) - determ (i,o)
  insure_list_is_empty(TOKL Tokl) - determ (i)
  point_to_error_if_appropriate(WINDOW ResultWindow,integer CursorPos,SOURCE Text) - procedure (i,i,i)

clauses
  run(Win):-
	Expr=dialog_GetStr(Win,idc_calc),
	ResultWin=win_GetCtlHandle(Win,idc_result),
	evaluate_expression(Expr,ResultWin).

  evaluate_expression(Expr,ResultWin) :-
	tokenize(Expr,Tokens),
	term_str(TOKL,Tokens,TokensStr),
	format(OutTokens,"Tokens = %\n",TokensStr),
	edit_AppendStr(ResultWin,OutTokens),
	parse(Tokens,Term),
	term_str(EXPR,Term,TermStr),
	format(OutTerm,"Term = %\n",TermStr),
	edit_AppendStr(ResultWin,OutTerm),
	calculate(Term,Result),
	!,
	format(OutResult,"Answer = %\n",Result),
	edit_AppendStr(ResultWin,OutResult).
  evaluate_expression(Expr,ResultWin) :-
	edit_AppendStr(ResultWin,"<<Illegal Expression>>\n"),
	retract(error(Message,Position)),		% Get error info.
	format(OutMessage,"%\n",Message),
	edit_AppendStr(ResultWin,OutMessage),
	point_to_error_if_appropriate(ResultWin,Position,Expr).

  tokenize(Expr,Tokens):-scan(0,Expr,Tokens).

  parse(Tokens,Term):- 
  	s_expr(Tokens,Unused_Tokens,Term),
	insure_list_is_empty(Unused_Tokens).

  insure_list_is_empty([]):-!.
  insure_list_is_empty([t(_,Position)|_]) :-
	is_a_deeper_error(Position),
  	replace_error("Unexpected token.",Position),
  	fail.

  point_to_error_if_appropriate(_,end_of_text,_):-!.	% Don't if end-of-text.
  point_to_error_if_appropriate(ResultWin,Position,Expr):-
	Pos=edit_GetPos(ResultWin),
	format(OutExpr,"%\n",Expr),
	edit_AppendStr(ResultWin,OutExpr),
	ErrorPos=Pos+Position,
	edit_GoToPos(ResultWin,ErrorPos),
	win_SetFocus(ResultWin).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 09:35:22-18.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "XCalc2"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 09:35:22-18.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 09:35:22-18.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	class_Create("Result",result_handler),
	msg_AppendStr("Press F7"),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	dlg_simple_calculator_Create(_Win),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("xcalc2.hlp"),
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
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
ifdef use_message
	msg_Resize(_Win),
enddef
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
		Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("xcalc2.hlp",HelpTopic).

/***************************************************************************
			Main Goal
***************************************************************************/

goal

ifdef use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
enddef
ifdef ws_win
  ifdef use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  enddef
enddef  
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"xcalc2",task_win_Title).

%BEGIN_TLB Project toolbar, 09:36:48-18.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"New;New file",1,1),
		 tb_ctrl(id_file_open,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open;Open file",1,1),
		 tb_ctrl(id_file_save,pushb,idb_save_up,idb_save_dn,idb_save_up,"Save;File save",1,1),
		 separator,
		 tb_ctrl(id_edit_undo,pushb,idb_undo_up,idb_undo_dn,idb_undo_up,"Undo;Undo",1,1),
		 tb_ctrl(id_edit_redo,pushb,idb_redo_up,idb_redo_dn,idb_redo_up,"Redo;Redo",1,1),
		 separator,
		 tb_ctrl(id_edit_cut,pushb,idb_cut_up,idb_cut_dn,idb_cut_up,"Cut;Cut to clipboard",1,1),
		 tb_ctrl(id_edit_copy,pushb,idb_copy_up,idb_copy_dn,idb_copy_up,"Copy;Copy to clipboard",1,1),
		 tb_ctrl(id_edit_paste,pushb,idb_paste_up,idb_paste_dn,idb_paste_up,"Paste;Paste from clipboard",1,1),
		 separator,
		 separator,
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help;Help",0,1)]),
enddef
	true.
%END_TLB Project toolbar



%BEGIN_TLB Help line, 09:36:14-18.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/

clauses

  tb_help_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0xC0C0C0,_Parent,
		[tb_text(idt_help_line,tb_context,452,0,4,10,0x0,"")]),
enddef
	true.
%END_TLB Help line


%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

constants

%BEGIN About dialog, CreateParms, 10:16:26-11.1.2000, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

predicates

  dlg_about_dialog_eh : EHANDLER

clauses

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


%BEGIN_DLG Simple Calculator
/**************************************************************************
	Creation and event handling for dialog: Simple Calculator
**************************************************************************/

constants

%BEGIN Simple Calculator, CreateParms, 22:53:54-9.12.1999, Code automatically updated!
  dlg_simple_calculator_ResID = idd_simple_calculator
  dlg_simple_calculator_DlgType = wd_Modal
  dlg_simple_calculator_Help = idh_contents
%END Simple Calculator, CreateParms

predicates

  dlg_simple_calculator_eh : EHANDLER
  dlg_simple_calculator_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_simple_calculator_update(DIALOG_VAL_LIST)

clauses

  dlg_simple_calculator_Create(Parent):-

%MARK Simple Calculator, new variables

	dialog_CreateModal(Parent,dlg_simple_calculator_ResID,"",
  		[
%BEGIN Simple Calculator, ControlList, 22:53:54-9.12.1999, Code automatically updated!
		df(idc_calc,editstr("(5+3)*10",[]),nopr)
%END Simple Calculator, ControlList
		],
		dlg_simple_calculator_eh,0,VALLIST,ANSWER),
	dlg_simple_calculator_handle_answer(ANSWER,VALLIST).

  dlg_simple_calculator_handle_answer(idc_ok,VALLIST):-!,
	dlg_simple_calculator_update(VALLIST).
  dlg_simple_calculator_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_simple_calculator_handle_answer(_,_):-
	errorexit().

  dlg_simple_calculator_update(_VALLIST):-
%BEGIN Simple Calculator, Update controls, 22:53:54-9.12.1999, Code automatically updated!
	_IDC_CALC_VALUE = dialog_VLGetstr(idc_calc,_VALLIST),
%END Simple Calculator, Update controls
	true.

%MARK Simple Calculator, new events

%BEGIN Simple Calculator, idc_run _CtlInfo
  dlg_simple_calculator_eh(_Win,e_Control(idc_run,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	run(_Win),
	!.
%END Simple Calculator, idc_run _CtlInfo

  dlg_simple_calculator_eh(_,_,_):-!,fail.

%END_DLG Simple Calculator








