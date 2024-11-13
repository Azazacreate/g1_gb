/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  RUNAPPL
 FileName: RUNAPPL.PRO
 Purpose: Demonstration Run\Close Application
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "runappl.inc"
include "runappl.con"
include "hlptopic.con"

FACTS - db
  command(string)
  param(string)
  flag(long)
  applid(long,string)

FACTS - db1
  all_appl(SLIST)
  dlg_close_win(WINDOW)
	
PREDICATES
  set(BOOLEAN,WINDOW,WINDOW,WINDOW,WINDOW)
  check_close_list(WINDOW,SLIST)
  check_menu(WINDOW)
  close_appl(WINDOW)
  append(SLIST,SLIST,SLIST)
  list_appl(string)
  cor_list(SLIST,SLIST,string,long)
	
CLAUSES
  set(wsf_Invisible,W1,W2,W3,W4):-!,
	win_Check(W1,checkbox_on),
	win_Check(W2,checkbox_off),
	win_Check(W3,checkbox_off),
	win_Check(W4,checkbox_off).
  set(wsf_Restored,W1,W2,W3,W4):-
   	win_Check(W1,checkbox_off),
	win_Check(W2,checkbox_on),
	win_Check(W3,checkbox_off),
	win_Check(W4,checkbox_off).
  set(wsf_Maximized,W1,W2,W3,W4):-
	win_Check(W1,checkbox_off),
	win_Check(W2,checkbox_off),
	win_Check(W3,checkbox_on),
	win_Check(W4,checkbox_off).
  set(wsf_Minimized,W1,W2,W3,W4):-
  	win_Check(W1,checkbox_off),
  	win_Check(W2,checkbox_off),
  	win_Check(W3,checkbox_off),
  	win_Check(W4,checkbox_on).	
 		
  check_menu(_Win):-
  	applid(_,_),!.
  check_menu(_Win):-  	
  	menu_Enable(_Win,id_Application_close,b_false).
  	
  list_appl(Y):-
	all_appl(A),
	Z=[Y],
	append(A,Z,X),
	retractall(all_appl(_)),
	assert(all_appl(X)),
	fail.
  list_appl(_).

  append([],List,List).
  append([X|L1],List2,[X|L3]):-
	append(L1,List2,L3).

  close_appl(_Win):-
	Index=lbox_GetSelIndex(_Win),
	Item=lbox_GetItem(_Win,Index),
	applid(ApplID,Item),!,
	vpi_CloseProcess(ApplID).

  check_close_list(_Win,[]):-!,
	Window=win_GetParent(_Win),
	W=win_GetCtlHandle(Window,idc_close_app),
	win_SetState(W,[wsf_Disabled]).
  check_close_list(_Win,_):-
	lbox_SetSel(_Win,0,b_true).

  cor_list([],[],_,_).
  cor_list([H|T],NewList,Item,ApplID):-
	H=Item,
	applid(ApplID,Item),
	retract(applid(ApplID,Item)),!,
  	cor_list(T,NewList,Item,ApplID).
  cor_list([H|T],[H|NewList],Item,ApplID):-
  	cor_list(T,NewList,Item,ApplID).

PREDICATES
  check_DlgClose(SLIST)

CLAUSES
  check_DlgClose(T):-
	dlg_close_win(Win),!,
	W=win_GetCtlHandle(Win,idc_close_1),
	lbox_Clear(W),
	lbox_Add(W,T),
	check_close_list(W,T).
  check_DlgClose(_).

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 14:01:34-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Runappl"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 14:01:34-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 14:01:34-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	assert(command("")),
	assert(param("")),
	assert(flag(wsf_Restored)),
	assert(all_appl([])),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_EndApplication
  task_win_eh(_Win,e_EndApplication(ApplID),0):-
	applid(ApplID,Item),!,
	concat("Close Application : ",Item,Final),
	write(Final),nl,
	all_appl(L),
	cor_list(L,T,Item,ApplID),
	retractall(all_appl(_)),
	assert(all_appl(T)),
	check_DlgClose(T),
	check_menu(_Win),
	!.
%END Task Window, e_EndApplication

%BEGIN Task Window, id_Application_run
  task_win_eh(_Win,e_Menu(id_Application_run,_ShiftCtlAlt),0):-!,
	dlg_set_Create(_Win),
	!.
%END Task Window, id_Application_run

%BEGIN Task Window, id_Application_close
  task_win_eh(_Win,e_Menu(id_Application_close,_ShiftCtlAlt),0):-!,
	dlg_close_Create(_Win),
	!.
%END Task Window, id_Application_close

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("runappl.hlp"),
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
  	vpi_ShowHelpContext("runappl.hlp",HelpTopic),!.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"runappl",task_win_Title).

%BEGIN_TLB Project toolbar, 14:01:46-24.11.1999, Code automatically updated!
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


%BEGIN_TLB Help line, 14:01:50-24.11.1999, Code automatically updated!
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

CONSTANTS

%BEGIN About dialog, CreateParms, 14:01:30-24.11.1999, Code automatically updated!
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

%BEGIN_DLG Set
/**************************************************************************
	Creation and event handling for dialog: Set
**************************************************************************/

CONSTANTS

%BEGIN Set, CreateParms, 21:26:36-14.3.1997, Code automatically updated!
  dlg_set_ResID = idd_set
  dlg_set_DlgType = wd_Modal
  dlg_set_Help = idh_contents
%END Set, CreateParms

PREDICATES

  dlg_set_eh : EHANDLER
  dlg_set_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_set_Create(Parent):-

	command(COMMAND),
	param(PARAM),
%MARK Set, new variables

	dialog_CreateModal(Parent,dlg_set_ResID,"",
  		[
%BEGIN Set, ControlList, 21:26:36-14.3.1997, Code automatically updated!
		df(idc_set_1,editstr(COMMAND,[]),nopr),
		df(idc_set_2,editstr(PARAM,[]),nopr)
%END Set, ControlList
		],
		dlg_set_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_set_update(VALLIST),!.

  dlg_set_update(_VALLIST):-!,
%BEGIN Set, Update controls, 21:26:36-14.3.1997, Code automatically updated!
	_COMMAND = dialog_VLGetstr(idc_set_1,_VALLIST),
	_PARAM = dialog_VLGetstr(idc_set_2,_VALLIST),
%END Set, Update controls
	!.

%MARK Set, new events

%BEGIN Set, idc_minimized _CtlInfo
  dlg_set_eh(_Win,e_Control(idc_minimized,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(flag(_)),
	assert(flag(wsf_Minimized)),
	!.
%END Set, idc_minimized _CtlInfo

%BEGIN Set, idc_maximized _CtlInfo
  dlg_set_eh(_Win,e_Control(idc_maximized,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(flag(_)),
	assert(flag(wsf_Maximized)),
	!.
%END Set, idc_maximized _CtlInfo

%BEGIN Set, idc_restored _CtlInfo
  dlg_set_eh(_Win,e_Control(idc_restored,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(flag(_)),
	assert(flag(wsf_Restored)),
	!.
%END Set, idc_restored _CtlInfo

%BEGIN Set, idc_invisible _CtlInfo
  dlg_set_eh(_Win,e_Control(idc_invisible,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(flag(_)),
	assert(flag(wsf_Invisible)),
	!.
%END Set, idc_invisible _CtlInfo

%BEGIN Set, idc_run _CtlInfo
  dlg_set_eh(_Win,e_Control(idc_run,_CtrlType,_CtrlWin,_CtlInfo),0):-
	Com=dialog_GetStr(_Win,idc_set_1),
	Par=dialog_GetStr(_Win,idc_set_2),
	flag(WSFLAG),
	W=win_GetParent(_Win),
	trap(ApplID=vpi_CreateProcess(W,Com,Par,WSFLAG),_,fail),!,
	retractall(command(_)),
	retractall(param(_)),
	assert(command(Com)),
	assert(param(Par)),
	assert(applid(ApplID,Com)),
	list_appl(Com),
	menu_Enable(W,id_Application_close,b_true),
	concat("Run Application : ",Com,Final),
	write(Final),nl,
	win_Destroy(_Win),
	!.
  dlg_set_eh(_Win,e_Control(idc_run,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dlg_Error("File not found or not executable"),
	CtrlWin=win_GetCtlHandle(_Win,idc_set_1),
	Com=dialog_GetStr(_Win,idc_set_1),
	str_len(Com,L),
	win_SetFocus(CtrlWin),
	win_SelectText(CtrlWin,0,L),
	!.
%END Set, idc_run _CtlInfo

%BEGIN Set, idc_browse _CtlInfo
  dlg_set_eh(_Win,e_Control(idc_browse,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	FileName=dlg_GetOpenFileName("*.exe"/*Mask*/,["*.*","*.*","*.exe","*.exe","*.com","*.com","*.bat","*.bat"],""),
	FileName<>"",!,
	W=win_GetCtlHandle(_Win,idc_set_1),
	win_SetText(W,FileName),
	!.
%END Set, idc_browse _CtlInfo

%BEGIN Set, e_Create
  dlg_set_eh(_Win,e_Create(_CreationData),0):-!,
	flag(Flag),
	W1=win_GetCtlHandle(_Win,idc_invisible),
	W2=win_GetCtlHandle(_Win,idc_restored),
	W3=win_GetCtlHandle(_Win,idc_maximized),
	W4=win_GetCtlHandle(_Win,idc_minimized),
	set(Flag,W1,W2,W3,W4),
	!.
%END Set, e_Create

  dlg_set_eh(_,_,_):-!,fail.

%END_DLG Set
%BEGIN_DLG Close
/**************************************************************************
	Creation and event handling for dialog: Close
**************************************************************************/

CONSTANTS

%BEGIN Close, CreateParms, 14:01:26-24.11.1999, Code automatically updated!
  dlg_close_ResID = idd_close
  dlg_close_DlgType = wd_Modal
  dlg_close_Help = idh_contents
%END Close, CreateParms

PREDICATES

  dlg_close_eh : EHANDLER
  dlg_close_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_close_Create(Parent):-

%MARK Close, new variables
	all_appl(RUN_APPL),

	dialog_CreateModal(Parent,dlg_close_ResID,"",
  		[
%BEGIN Close, ControlList, 14:01:26-24.11.1999, Code automatically updated!
		df(idc_close_1,listbox(RUN_APPL,[0]),nopr)
%END Close, ControlList
		],
		dlg_close_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_close_update(VALLIST),!.

  dlg_close_update(_VALLIST):-!,
%BEGIN Close, Update controls, 14:01:26-24.11.1999, Code automatically updated!
	dialog_VLGetListBox(idc_close_1,_VALLIST,_RUN_APPL,_IDC_CLOSE_1_SELECT),
%END Close, Update controls
	!.

%MARK Close, new events

%BEGIN Close, e_Create
  dlg_close_eh(_Win,e_Create(_CreationData),0):-!,
	assert(dlg_close_win(_Win)),
	!.
%END Close, e_Create

%BEGIN Close, e_Destroy
  dlg_close_eh(_Win,e_Destroy,0):-
	retract(dlg_close_win(_Win)),
	!.
%END Close, e_Destroy

%BEGIN Close, idc_close_app _CtlInfo
  dlg_close_eh(_Win,e_Control(idc_close_app,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	W=win_GetCtlHandle(_Win,idc_close_1),
	close_appl(W),
	!.
%END Close, idc_close_app _CtlInfo

%BEGIN Close, idc_close_1 activated
  dlg_close_eh(_Win,e_Control(idc_close_1,_CtrlType,LW,activated),0):-!,
	close_appl(LW),
	!.
%END Close, idc_close_1 activated

  dlg_close_eh(_,_,_):-!,fail.

%END_DLG Close















