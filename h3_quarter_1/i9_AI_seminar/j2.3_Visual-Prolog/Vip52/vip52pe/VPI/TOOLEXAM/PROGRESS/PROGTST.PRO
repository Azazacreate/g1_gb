/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PROGTST
 FileName: PROGTST.PRO
 Purpose: Progressbar test
 Written by: Lars Juul Pedersen
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

include "progtst.inc"
include "progtst.con"
include "hlptopic.con"

facts - db
  stop
  progress_db
  
facts - set
  data(long,long)
  show(integer)
  
predicates
  process(WINDOW)
  get_IncipientSettings(WINDOW,WINDOW,long,long)
  start_Process(WINDOW,long,long,long)
  stop_Process(WINDOW)
  
clauses
  process(_Win):-
	get_IncipientSettings(_Win,ProcessBarWin,Val,Max),
	ButtonWin=win_GetCtlHandle(_Win,idc_ok),
	win_SetText(ButtonWin,"&Stop"),
	start_Process(ProcessBarWin,0,Val,Max).

  get_IncipientSettings(_Win,ProcessBarWin,Val,Max):-
	show(checkbox_on),
	ProcessBarWin=win_GetCtlHandle(_Win,idc_progressbar_12),
	data(Val,Max),
	!.
  get_IncipientSettings(_Win,ProcessBarWin,Val,Max):-
	ProcessBarWin=win_GetCtlHandle(_Win,idc_progressbar_11),
	data(Val,Max),
	!.

  start_Process(ProcessBarWin,_,_,_):-
	stop,
	!,
	stop_Process(ProcessBarWin).
  start_Process(ProcessBarWin,Val,Val,_):-
	!,
	stop_Process(ProcessBarWin).
  start_Process(ProcessBarWin,CurrentVal,Val,Max):-
	vpi_ProcessEvents(b_true),
	New_Val=CurrentVal+1,
	progress_bar_set_value(ProcessBarWin,Max,New_Val),
	start_Process(ProcessBarWin,New_Val,Val,Max).
	
  stop_Process(ProcessBarWin):-
	ParentWin=win_GetParent(ProcessBarWin),
	ButtonWin=win_GetCtlHandle(ParentWin,idc_ok),
	win_SetText(ButtonWin,"&Start"),
	retractall(_,db).

predicates
  check_ShowBar(integer)

clauses
  check_ShowBar(ShowBar):-
	show(Id),Id=checkbox_on,!,
	ShowBar=idc_horizontal_bar.
  check_ShowBar(idc_vertical_bar).
  
%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 14:55:34-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Progtst"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 14:55:34-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 14:55:34-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	progress_register,
	assert(data(50,100)),
	assert(show(checkbox_on)),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	progress_Unregister,
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, id_progressbar
  task_win_eh(_Win,e_Menu(id_progressbar,_ShiftCtlAlt),0):-!,
	dlg_progressbar_Create(_Win),
	!.
%END Task Window, id_progressbar

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("progtst.hlp"),
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

%BEGIN Task Window, e_User
% Help button in dialog "Find Text"
  task_win_eh(_Win,e_User(idc_help,edit_HelpFind),0):-!,
	!.
% Help button in dialog "Replace Text"
  task_win_eh(_Win,e_User(idc_help,edit_HelpReplace),0):-!,
	!.
% Help button in dialog "Go To Line"
  task_win_eh(_Win,e_User(idc_help,edit_HelpLine),0):-!,
	!.
% Help button in dialog "Go To Position"
  task_win_eh(_Win,e_User(idc_help,edit_HelpPos),0):-!,
	!.
% Help button in dialog "Editor Options"
  task_win_eh(_Win,e_User(idc_help,edit_HelpOptions),0):-!,
	!.
%END Task Window, e_User

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("progtst.hlp",HelpTopic).

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"progtst",task_win_Title).

%BEGIN_TLB Project toolbar, 14:55:52-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(idd_progressbar,pushb,idb_new_up,idb_new_dn,idb_new_up,"New;Progress Bar",1,1),
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

%BEGIN_TLB Help line, 14:56:08-24.11.1999, Code automatically updated!
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

%BEGIN About dialog, CreateParms, 11:03:44-11.1.2000, Code automatically updated!
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

%BEGIN_DLG Progressbar
/**************************************************************************
	Creation and event handling for dialog: Progressbar
**************************************************************************/

constants

%BEGIN Progressbar, CreateParms, 13:25:43-16.3.2000, Code automatically updated!
  dlg_progressbar_ResID = idd_progressbar
  dlg_progressbar_DlgType = wd_Modal
  dlg_progressbar_Help = idh_contents
%END Progressbar, CreateParms

predicates

  dlg_progressbar_eh : EHANDLER
  dlg_progressbar_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_progressbar_update(DIALOG_VAL_LIST)

clauses

  dlg_progressbar_Create(Parent):-

%MARK Progressbar, new variables

	dialog_CreateModal(Parent,dlg_progressbar_ResID,"",
  		[
%BEGIN Progressbar, ControlList, 13:25:43-16.3.2000, Code automatically updated!
%END Progressbar, ControlList
		],
		dlg_progressbar_eh,0,VALLIST,ANSWER),
	dlg_progressbar_handle_answer(ANSWER,VALLIST).

  dlg_progressbar_handle_answer(idc_ok,VALLIST):-!,
	dlg_progressbar_update(VALLIST).
  dlg_progressbar_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_progressbar_handle_answer(_,_):-
	errorexit().

  dlg_progressbar_update(_VALLIST):-
%BEGIN Progressbar, Update controls, 13:25:43-16.3.2000, Code automatically updated!
%END Progressbar, Update controls
	true.

%MARK Progressbar, new events

%BEGIN Progressbar, idc_settings _CtlInfo
  dlg_progressbar_eh(_Win,e_Control(idc_settings,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dlg_setting_Create(_Win),
	!.
%END Progressbar, idc_settings _CtlInfo

%BEGIN Progressbar, idc_ok _CtlInfo
  dlg_progressbar_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
	progress_db,
	!,
	assert(stop).
  dlg_progressbar_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
	assert(progress_db),
	process(_Win),
	!.
%END Progressbar, idc_ok _CtlInfo

%BEGIN Progressbar, e_Create
  dlg_progressbar_eh(_Win,e_Create(_CreationData),0):-!,
	ProgressWindow_Hor = win_GetCtlHandle(_Win, idc_progressbar_12),
	ProgressWindow_Ver = win_GetCtlHandle(_Win, idc_progressbar_11),
	progress_bar_set_colors(ProgressWindow_Ver,color_Green,color_DkGray,pat_Vert),
	progress_bar_set_value(ProgressWindow_Hor,0,0),
	progress_bar_set_value(ProgressWindow_Ver,0,0),
	!.
%END Progressbar, e_Create

  dlg_progressbar_eh(_,_,_):-!,fail.

%END_DLG Progressbar

%BEGIN_DLG Setting
/**************************************************************************
	Creation and event handling for dialog: Setting
**************************************************************************/

constants

%BEGIN Setting, CreateParms, 12:03:44-16.3.2000, Code automatically updated!
  dlg_setting_ResID = idd_setting
  dlg_setting_DlgType = wd_Modal
  dlg_setting_Help = idh_contents
%END Setting, CreateParms

predicates

  dlg_setting_eh : EHANDLER
  dlg_setting_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_setting_update(DIALOG_VAL_LIST)

clauses

  dlg_setting_Create(Parent):-

	data(Val,Max),!,
	check_ShowBar(SHOW_BAR),
	IDC_VAL_VALUE = l(Val),
	IDC_MAX_VALUE = l(Max),
%MARK Setting, new variables

	dialog_CreateModal(Parent,dlg_setting_ResID,"",
  		[
%BEGIN Setting, ControlList, 12:03:44-16.3.2000, Code automatically updated!
		df(idc_val,editlong(IDC_VAL_VALUE,[range(0,100)]),str_prompt("Value")),
		df(idc_max,editlong(IDC_MAX_VALUE,[range(0,100)]),str_prompt("Maximum Value")),
		df(SHOW_BAR,radiobuttongroup([idc_horizontal_bar,idc_vertical_bar]),nopr)
%END Setting, ControlList
		],
		dlg_setting_eh,0,VALLIST,ANSWER),
	dlg_setting_handle_answer(ANSWER,VALLIST).

  dlg_setting_handle_answer(idc_ok,VALLIST):-!,
	dlg_setting_update(VALLIST).
  dlg_setting_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_setting_handle_answer(_,_):-
	errorexit().

  dlg_setting_update(_VALLIST):-
%BEGIN Setting, Update controls, 12:03:44-16.3.2000, Code automatically updated!
	_IDC_VAL_VALUE = dialog_VLGetlong(idc_val,_VALLIST),
	_IDC_MAX_VALUE = dialog_VLGetlong(idc_max,_VALLIST),
	_SHOW_BAR = dialog_VLGetRadiobutton(idc_horizontal_bar,_VALLIST),
%END Setting, Update controls
	_IDC_VAL_VALUE=l(Val),
	_IDC_MAX_VALUE=l(Max),
	retractall(data(_,_)),
	assert(data(Val,Max)),
	true.

%MARK Setting, new events

%BEGIN Setting, idc_vertical_bar _CtlInfo
  dlg_setting_eh(_Win,e_Control(idc_vertical_bar,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(show(_)),
	assert(show(checkbox_off)),
	!.
%END Setting, idc_vertical_bar _CtlInfo

%BEGIN Setting, idc_horizontal_bar _CtlInfo
  dlg_setting_eh(_Win,e_Control(idc_horizontal_bar,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(show(_)),
	assert(show(checkbox_on)),
	!.
%END Setting, idc_horizontal_bar _CtlInfo

  dlg_setting_eh(_,_,_):-!,fail.

%END_DLG Setting

