/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  XCALCULA
 FileName: XCALCULA.PRO
 Purpose: Programming Language Demo of Parser Generator
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "xcalcula.inc"
include "xcalcula.con"
include "hlptopic.con"

facts - xcalcula
  determ  error(MESSAGE,CURSORPOS)	% Error message & cursor position
  run_execute				% Run program
  stop_execute				% Stop program

predicates
  execute(WINDOW DialogWin,PROGRAM Program) - determ (i,i)
  expect(TTOK TokenPos,TOKL Tokl,TOKL Tokl) - determ (t(i,o),i,o)	% Organization syntax error
  syntax_error(MESSAGE ErrMsg,TOKL Tokl) - determ (i,i)			% Set cursor to syntax error
  is_a_deeper_error(integer CursorPos) - determ (i)			% Check error message
  replace_error(MESSAGE ErrMsg,integer CursorPos) - procedure (i,i)	% Replace error message

include "xcalcula.cs"	% calcula source
include "xcalcula.psf"	% prolog source file
include "xcalcula.run"	% Executing the compiled program
include "xcalcula.par"	% parsing predicates
include "xcalcula.sca"	% scanner

clauses
  execute(DialogWin,Stmnts):-
	program_FreeAllVariables,	% Any left over from last run.
	program_Run(DialogWin,Stmnts).

  is_a_deeper_error(Position):-
	error(_,OldPosition),
	!,
	Position > OldPosition.
  is_a_deeper_error(_).

  replace_error(Message,Position):-
  	retractall(error(_,_)),
  	assert(error(Message,Position)).

/* Expect & Syntax_error predicates */
  expect(Token,[Token|Tail],Tail):-!.
  expect(t(Token,_),[t(_,Position)|_],_):-
  	is_a_deeper_error(Position),
	string_token(String,Token),
  	format(Message,"Expected %.",String),
  	replace_error(Message,Position),
  	fail.
  expect(t(Token,_),[],_):-
	string_token(String,Token),
  	format(Message,"Expected % (premature end of text).",String),
	calcula_source_Retrieve(Source),
	str_len(Source,End_of_Text),
  	replace_error(Message,End_of_Text),
  	fail.

  syntax_error(Production,[t(_,Position)|_]):-
  	is_a_deeper_error(Position),
	format(Message,"Syntax error in %.",PRODUCTION),
  	replace_error(Message,Position).
  syntax_error(Production,[]):-
	format(Message, 
	       "Syntax error in % (premature end of text).", 
	       Production),
	calcula_source_Retrieve(Source),
	str_len(Source,End_of_Text),
  	replace_error(Message,End_of_Text).  	

/* Load & Save XCalcula.ini file */
facts - ini
  last_filename(string)

predicates
  load_XCalculaIniFile - procedure ()	% Load XCalcula.ini file
  save_XCalculaIniFile - procedure ()	% Save XCalcula.ini file
  update_XCalculaIniFile(string FileName) - procedure (i)	% Update last_filename

clauses
  load_XCalculaIniFile:-
	existfile("xcalcula.ini"),
	!,
	consult("xcalcula.ini",ini).
  load_XCalculaIniFile:-
	assert(last_filename(""),ini).

  save_XCalculaIniFile:-
	last_filename(""),
	!.
  save_XCalculaIniFile:-
	save("xcalcula.ini",ini).

  update_XCalculaIniFile(""):-
	!.
  update_XCalculaIniFile(FileName):-
	last_filename(FileName),
	!.
  update_XCalculaIniFile(FileName):-
	retractall(last_filename(_)),
	assert(last_filename(FileName)).

/* Set dialog title */
predicates
  set_DialogTitle(WINDOW CalculateDialogWindow) - determ (i)	% Set title for "Calculator" dialog
  get_DialogTitle(string Path,string Name,string Title) - procedure (i,i,o)		% organization dialog title

clauses
  set_DialogTitle(CalculateDialogWindow):-
	last_filename(""),
	!,
	win_SetText(CalculateDialogWindow,"Calculator").
  set_DialogTitle(CalculateDialogWindow):-
	last_filename(FileName),
	!,
	filenamepath(FileName,Path,Name),
	get_DialogTitle(Path,Name,Title),
	win_SetText(CalculateDialogWindow,Title).

  get_DialogTitle(Path,Name,Name):-
	syspath(ProgramPath,_),
	Path=ProgramPath,
	!.
  get_DialogTitle(Path,Name,Title):-
	format(Title,"% [%]",Name,Path).

/* Source & Dialog handlers */
constants
  ctrlX = 24
  ctrlC = 3
  ctrlV = 22

predicates
  source_handler : EHANDLER
  dialog_handler : EHANDLER

clauses
  source_handler(_Win,e_create(_),0):-
	Font = font_Create(ff_Times,[],10),
	last_filename(FileName),
	calcula_source_Load(FileName,OutFileName),
	update_XCalculaIniFile(OutFileName),
	calcula_source_Retrieve(Text),
	edit_CreateSubClass(_Win,"",Font,b_false,b_true,b_false,Text,1,source_handler),!,
	fail.

  source_handler(_Win,e_Char(ctrlX,_),0):-
	edit_Cut(_Win),!.
  source_handler(_Win,e_Char(ctrlC,_),0):-
	edit_Copy(_Win),!.
  source_handler(_Win,e_Char(ctrlV,_),0):-
	edit_Paste(_Win),!.
  source_handler(W,e_MouseDown(_,_,_),0):-!, 
	win_SetFocus (W),fail.

  dialog_handler(_Win,e_create(_),0):-
	Font = font_Create(ff_Times,[],10),
	Text="",
	edit_CreateSubClass(_Win,"",Font,b_true,b_true,b_false,Text,1,dialog_handler),!,
	fail.

  dialog_handler(_Win,e_Char(ctrlC,_),0):-
	edit_Copy(_Win),!.
  dialog_handler(W,e_MouseDown(_,_,_),0):-!, 
	win_SetFocus (W),fail.

/* Create & destroy window classes 
	destroy_WindowClasses -	Destroy window classes "Source" & "Dialog"
	create_WindowClasses  -	Create window classes "Source" & "Dialog"
*/
predicates
  destroy_WindowClasses
  create_WindowClasses

clauses
  destroy_WindowClasses:-
	class_Destroy("Source"),
	class_Destroy("Dialog").

  create_WindowClasses:-
	class_Create("Source",source_handler),
	class_Create("Dialog",dialog_handler).

/* Enable/Disable Culculator's dialog buttons */
predicates
  set_EnableOrDisableButtons(WINDOW CalculateDialogWindow,ILIST ControlsList,WSFLAGS CtrlState)

clauses
  set_EnableOrDisableButtons(_,[],_):-
	!.
  set_EnableOrDisableButtons(CalculateDialogWindow,[H|T],CtrlState):-
	CtrlWin=win_GetCtlHandle(CalculateDialogWindow,H),
	win_SetState(CtrlWin,CtrlState),
	set_EnableOrDisableButtons(CalculateDialogWindow,T,CtrlState).

/* Set text to "Run" button */
predicates
  set_RunButtonText(WINDOW CalculateDialogWindow,string Text) - procedure (i,i)

clauses
  set_RunButtonText(CalculateDialogWindow,Text):-
	CtrlWin=win_GetCtlHandle(CalculateDialogWindow,idc_run),
	win_SetText(CtrlWin,Text).

/* Handling Load button */
predicates
  load_Source(WINDOW CalculateDialogWindow) - determ (i)	% Load source chosen by user
  check_ExistFileName(WINDOW CalculateDialogWindow,string FileName) - determ (i,i)	% Check present file

clauses
  load_Source(CalculateDialogWindow):-
	InitSelection="*.db",
	FileTypeFilters=["*.db","*.db"],
	Title="Open XCalcula source",
	Flag=[],
	FileName=dlg_GetFileName(InitSelection,FileTypeFilters,Title,Flag,"",_),
	check_ExistFileName(CalculateDialogWindow,FileName).

  check_ExistFileName(CalculateDialogWindow,FileName):-
	trap(existfile(FileName),_,fail),
	!,
	retractall(calcula_source(_)),
	consult(FileName,calcula_source),
	calcula_source_Retrieve(Source),
	SourceWin=win_GetCtlHandle(CalculateDialogWindow,idc_source),
	edit_PasteStr(SourceWin,Source),
	retractall(last_filename(_)),
	assert(last_filename(FileName)),
	set_DialogTitle(CalculateDialogWindow).
  check_ExistFileName(_,FileName):-
	format(Msg,"File % not found",FileName),
	dlg_Error(Msg).

/* Handling Save As button */
predicates
  save_AsSource(WINDOW CalculateDialogWindow) - determ (i)	% main save as process
  check_CorrectFileName(WINDOW CalculateDialogWindow,string FileName) - determ (i,i)	% check correct path

clauses
  save_AsSource(CalculateDialogWindow):-
	InitSelection="*.db",
	FileTypeFilters=["*.db","*.db"],
	Title="Save As XCalcula source",
	Flag=[dlgfn_Save],
	FileName=dlg_GetFileName(InitSelection,FileTypeFilters,Title,Flag,"",_),
	check_CorrectFileName(CalculateDialogWindow,FileName).
	
  check_CorrectFileName(CalculateDialogWindow,FileName):-
	filenamepath(FileName,Path,_),
	trap(disk(Path),_,fail),!,
	SourceWin=win_GetCtlHandle(CalculateDialogWindow,idc_source),
	Source=edit_GetText(SourceWin),
	retractall(calcula_source(_)),
	assert(calcula_source(Source)),
	save(FileName,calcula_source),
	retractall(last_filename(_)),
	assert(last_filename(FileName)),
	set_DialogTitle(CalculateDialogWindow).
  check_CorrectFileName(_,FileName):-
	format(Msg,"Incorrect file Name\n%",FileName),
	dlg_Error(Msg).

/* Hanling Save button */
predicates
  save_Source(WINDOW CalculateDialogWindow) - determ (i)	% main save process

clauses
  save_Source(CalculateDialogWindow):-
	last_filename(""),
	!,
	save_AsSource(CalculateDialogWindow).
  save_Source(CalculateDialogWindow):-
	last_filename(FileName),
	!,
	SourceWin=win_GetCtlHandle(CalculateDialogWindow,idc_source),
	Source=edit_GetText(SourceWin),
	retractall(calcula_source(_)),
	assert(calcula_source(Source)),
	save(FileName,calcula_source).

/* Handling Run button */
predicates
  run(WINDOW CalculateDialogWindow) - determ (i)			% main predicate for evaluate of source
  tokenize(SOURCE Text,TOKL Tokl) - determ (i,o)			% activate scanner
  parse(TOKL Tokl,PROGRAM Program) - determ (i,o)			% use parsing predicates
  insure_list_is_empty(TOKL Tokl) - determ (i)				% check empty unused tokens list
  save_SourceBeforeRun(WINDOW CalculateDialogWindow) - determ (i)	%Save source to file

clauses
  run(CalculateDialogWindow):-
	SourceWin=win_GetCtlHandle(CalculateDialogWindow,idc_source),
	DialogWin=win_GetCtlHandle(CalculateDialogWindow,idc_dialog),
	Source=edit_GetText(SourceWin),
	retractall(calcula_source(_)),
	assert(calcula_source(Source)),
	save_SourceBeforeRun(CalculateDialogWindow),
	prolog_source_file_DeleteIfPresent,
	tokenize(Source,Tokens),
	parse(Tokens,Term),
	execute(DialogWin,Term),
	!,
	prolog_source_file_Create(Source,Term).
  run(CalculateDialogWindow):-
	retract(error(Message,Position)),		% Get error info.
	!,
	format(OutMessage,"%\n",Message),
	DialogWin=win_GetCtlHandle(CalculateDialogWindow,idc_dialog),
	SourceWin=win_GetCtlHandle(CalculateDialogWindow,idc_source),
	edit_AppendStr(DialogWin,OutMessage),
	edit_AppendStr(DialogWin,"\nProcess failed\n"),
	Pos=Position+1,
	edit_GoToPos(SourceWin,Pos),
	win_SetFocus(SourceWin).
  run(CalculateDialogWindow):-
	DialogWin=win_GetCtlHandle(CalculateDialogWindow,idc_dialog),
	edit_AppendStr(DialogWin,"\nProcess failed\n").

  save_SourceBeforeRun(CalculateDialogWindow):-
	retract(last_filename("")),
	!,
	syspath(Path,_),
	concat(Path,"xcalcula.db",FileName),
	assert(last_filename(FileName)),
	save_Source(CalculateDialogWindow).
  save_SourceBeforeRun(CalculateDialogWindow):-
	save_Source(CalculateDialogWindow).

  tokenize(Expr,Tokens):- 
	scan(0,Expr,Tokens), 	
% In case any error occurred, clean up when done.
	retractall(error(_,_)).
 
  parse(Tokens,Term):-
  	s_program(Tokens,Unused_Tokens,Term),	% Top-level parsing predicate.
	insure_list_is_empty(Unused_Tokens),	% Must use all tokens.
 % In case any error occurred, clean up when done.
	retractall(error(_,_)).

  insure_list_is_empty([]):-!.
  insure_list_is_empty([t(_,Position)|_]):-
	is_a_deeper_error(Position),
  	replace_error("Unexpected token.",Position),
  	fail.

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 16:28:32-17.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "XCalcula"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 16:28:32-17.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 16:28:32-17.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	load_XCalculaIniFile,
	msg_AppendStr("Press F7"),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	destroy_WindowClasses,
	create_WindowClasses,
	dlg_calculator_Create(_Win),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("xcalcula.hlp"),
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
  	vpi_ShowHelpContext("xcalcula.hlp",HelpTopic).

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"xcalcula",task_win_Title).

%BEGIN_TLB Project toolbar, 16:37:06-17.11.1999, Code automatically updated!
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


%BEGIN_TLB Help line, 16:28:32-17.11.1999, Code automatically updated!
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

%BEGIN About dialog, CreateParms, 10:16:24-11.1.2000, Code automatically updated!
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

%BEGIN_DLG Calculator
/**************************************************************************
	Creation and event handling for dialog: Calculator
**************************************************************************/

constants

%BEGIN Calculator, CreateParms, 16:03:06-10.4.2000, Code automatically updated!
  dlg_calculator_ResID = idd_calculator
  dlg_calculator_DlgType = wd_Modal
  dlg_calculator_Help = idh_contents
%END Calculator, CreateParms

predicates

  dlg_calculator_eh : EHANDLER
  dlg_calculator_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_calculator_update(DIALOG_VAL_LIST)

clauses

  dlg_calculator_Create(Parent):-

%MARK Calculator, new variables

	dialog_CreateModal(Parent,dlg_calculator_ResID,"",
  		[
%BEGIN Calculator, ControlList, 16:03:06-10.4.2000, Code automatically updated!
%END Calculator, ControlList
		],
		dlg_calculator_eh,0,VALLIST,ANSWER),
	dlg_calculator_handle_answer(ANSWER,VALLIST).

  dlg_calculator_handle_answer(idc_ok,VALLIST):-!,
	dlg_calculator_update(VALLIST).
  dlg_calculator_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_calculator_handle_answer(_,_):-
	errorexit().

  dlg_calculator_update(_VALLIST):-
%BEGIN Calculator, Update controls, 16:03:06-10.4.2000, Code automatically updated!
%END Calculator, Update controls
	true.

%MARK Calculator, new events

%BEGIN Calculator, e_CloseRequest
  dlg_calculator_eh(_Win,e_CloseRequest,0):-
	run_execute,
	!,
	assert(stop_execute),
	win_Destroy(_Win).
  dlg_calculator_eh(_Win,e_CloseRequest,0):-!,
	win_Destroy(_Win),
	!.
%END Calculator, e_CloseRequest

%BEGIN Calculator, idc_close _CtlInfo
  dlg_calculator_eh(_Win,e_Control(idc_close,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_SendEvent(_Win,e_CloseRequest()),
	!.
%END Calculator, idc_close _CtlInfo

%BEGIN Calculator, idc_load _CtlInfo
  dlg_calculator_eh(_Win,e_Control(idc_load,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	load_Source(_Win),
	!.
%END Calculator, idc_load _CtlInfo

%BEGIN Calculator, idc_save_as _CtlInfo
  dlg_calculator_eh(_Win,e_Control(idc_save_as,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	save_AsSource(_Win),
	!.
%END Calculator, idc_save_as _CtlInfo

%BEGIN Calculator, idc_save _CtlInfo
  dlg_calculator_eh(_Win,e_Control(idc_save,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	save_Source(_Win),
	!.
%END Calculator, idc_save _CtlInfo

%BEGIN Calculator, e_Create
  dlg_calculator_eh(_Win,e_Create(_CreationData),0):-
	set_DialogTitle(_Win),
	!.
%END Calculator, e_Create

%BEGIN Calculator, e_Destroy
  dlg_calculator_eh(_Win,e_Destroy,0):-!,
	save_XCalculaIniFile,
	retractall(_,calcula_source),
	retractall(_,xcalcula),
	!.
%END Calculator, e_Destroy

%BEGIN Calculator, idc_run _CtlInfo
  dlg_calculator_eh(_Win,e_Control(idc_run,_CtrlType,_CtrlWin,_CtlInfo),0):-
	run_execute,
	!,
	assert(stop_execute),
	set_RunButtonText(_Win,"Run").
  dlg_calculator_eh(_Win,e_Control(idc_run,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	List=[idc_load],
	set_EnableOrDisableButtons(_Win,List,[wsf_Disabled]),
	set_RunButtonText(_Win,"Stop"),
	retractall(_,xcalcula),
	assert(run_execute),
	run(_Win),
	set_EnableOrDisableButtons(_Win,List,[wsf_Enabled]),
	retractall(_,xcalcula),
	set_RunButtonText(_Win,"Run"),
	!.
%END Calculator, idc_run _CtlInfo

  dlg_calculator_eh(_,_,_):-!,fail.

%END_DLG Calculator
