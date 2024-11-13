/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DATECTRL
 FileName: DATECTRL.PRO
 Purpose: Date custom control test
 Written by: Alexander Butovsky
 Comments:
******************************************************************************/

include "datectrl.inc"
include "datectrl.con"
include "hlptopic.con"

% Date custom control tool:
include "error.con"
include "datecust\\date_cc.pre"
include "datecust\\date_cc.pro"

constants
  date_cc_class = "date_cc_class"	% USER DEFINED NAME FOR THE CLASS

  % EXAMPLES OF VALID FORMAT STRINGS FOR THE DATE CUSTOM CONTROL:
  date_cc_format_string1 = " %DD-%MD-%YL   %HH:%MM"
  date_cc_format_string2 = " %YS/%MD/%DD"
  date_cc_format_string3 = " %HH:%MM  %DD.%MD.%YS"
  date_cc_format_string4 = " %HH:%MM"

  % ControlId's for date custom control created in window
  date_cc_id1 = 3737
  date_cc_id2 = 3738

/***************************************************************************
	DATE CUSTOM CONTROL CLASS EVENT HANDLER
***************************************************************************/
predicates
  date_cc_class_handler : EHANDLER
  determ MINUT_OFFSET get_init_value()
  STRING get_format_string(WINDOW)
  determ STRING get_format_str(INTEGER)

clauses
  date_cc_class_handler(Win,e_Create(_),0):-!,		% CALL date_cc_Init ON
	InitValue = get_init_value(),			% E_CREATE EVENT
	FormatStr = get_format_string(Win),
	date_cc_Init(Win,InitValue,FormatStr).

  date_cc_class_handler(Win,EVENT,0):-!,			% CALL date_cc_HandleEvent
	date_cc_HandleEvent(Win,Event).			% ON ANY OTHER EVENT


  % Get initial value for the date custom control
  % Ex.: get current date and time:
  get_init_value(MinOffset):-
	date(Y,M,D),
	time(H,Min,_,_),
	dt_min_to_offset(Y,M,D,H,Min,MinOffset).

  % Get format string for the date custom control
  % Ex.: get one of the four example format string
  get_format_string(Win,FormatStr):-
	ControlId = win_GetCtlId(Win),
	FormatStr = get_format_str(ControlId),!.
  get_format_string(_,""):-errorexit().

  get_format_str(date_cc_id1,date_cc_format_string1):-!.
  get_format_str(date_cc_id2,date_cc_format_string2):-!.
  get_format_str(date_cc_id3,date_cc_format_string3):-!.
  get_format_str(date_cc_id4,date_cc_format_string4):-!.

database - date_editor
  determ win_counter(INTEGER)

predicates
  determ RCT calc_rectangle()
  
clauses
  % Shift each new top level window 20 pixels down
  % and 20 pixels to the right
  calc_rectangle(rct(100,80,360,240)):-
	not(win_counter(_)),!,
	assert(win_counter(20)).
  calc_rectangle(rct(L,T,R,B)):-
	retract(win_counter(D)),!,
	L = 100 + D, T = 80 + D, R = 360 + D, B = 240 + D,
	D1 = D + 20,
	assert(win_counter(D1)).

predicates
  determ sel_wsflag(DIALOG_CONTROL_ID,WSFLAGS)

clauses
  sel_wsflag(idc_rb_disabled, [wsf_Disabled]):-!.
  sel_wsflag(idc_rb_enabled,  [wsf_Enabled]):-!.
  sel_wsflag(idc_rb_visible,  [wsf_Visible]):-!.
  sel_wsflag(idc_rb_invisible,[wsf_Invisible]):-!.

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 12:00:12-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Date Custom Control Test"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 12:00:12-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 12:00:12-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	class_Create(date_cc_class,date_cc_class_handler),
	menu_Enable(_Win,"Test",b_false),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_test_getvalue
  task_win_eh(_Win,e_Menu(id_test_getvalue,_ShiftCtlAlt),0):-!,
	TopLevelWin = win_GetActiveWindow(),	% TEST - GET VALUE
	trap(DateCCWin = win_GetCtlHandle(TopLevelWin,date_cc_id1),_,fail),
	win_SetFocus(DateCCWin),
	MinOffset = date_cc_GetValue(DateCCWin),
	dt_minoffset_to_str(MinOffset,date_cc_format_string1,StrVal),
	format(MSG,"  date_cc_GetValue RETURN:\nMinOffset=%  (% )\n",MinOffset,StrVal),
	write(MSG),
	!.
%END Task Window, id_test_getvalue

%BEGIN Task Window, id_test_setvalue
  task_win_eh(_Win,e_Menu(id_test_setvalue,_),0):-!,
	TopLevelWin = win_GetActiveWindow(),	% TEST - SET VALUE
	trap(DateCCWin = win_GetCtlHandle(TopLevelWin,date_cc_id1),_,fail),
	win_SetFocus(DateCCWin),
	MinOffset = date_cc_GetValue(DateCCWin),
	NewOffset = MinOffset + 1501,	% Add 1 day, 1 hour and 1 min
	date_cc_SetValue(DateCCWin,NewOffset),
	write("  date_cc_SetValue TEST:\n1 day, 1 hour and 1 min added\n").
%END Task Window, id_test_setvalue

%BEGIN Task Window, id_test_setfont
  task_win_eh(_Win,e_Menu(id_test_setfont,_),0):-
	TopLevelWin = win_GetActiveWindow(),	% TEST - SET FONT
	trap(DateCCWin1 = win_GetCtlHandle(TopLevelWin,date_cc_id1),_,fail),
	trap(DateCCWin2 = win_GetCtlHandle(TopLevelWin,date_cc_id2),_,fail),
	OldFont = win_GetFont(DateCCWin1),
	NewFont = dlg_ChooseFont(OldFont),!,
	win_SetFont(DateCCWin1,NewFont),
	win_SetFont(DateCCWin2,NewFont).
%END Task Window, id_test_setfont

%BEGIN Task Window, id_test_setstate
  task_win_eh(Win,e_Menu(id_test_setstate,_),0):-
	TopLevelWin = win_GetActiveWindow(),	% TEST - SET STATE
	trap(DateCCWin1 = win_GetCtlHandle(TopLevelWin,date_cc_id1),_,fail),
	trap(DateCCWin2 = win_GetCtlHandle(TopLevelWin,date_cc_id2),_,fail),
	WSFlags = dlg_set_state_Create(Win),!,
	win_SetState(DateCCWin1,WSFlags),
	win_SetState(DateCCWin2,WSFlags).
%END Task Window, id_test_setstate

%BEGIN Task Window, id_create_dlg
  task_win_eh(_Win,e_Menu(id_create_dlg,_ShiftCtlAlt),0):-!,
	dlg_date_editor_dialog_Create(_Win),
	!.
%END Task Window, id_create_dlg

%BEGIN Task Window, id_create_win
  task_win_eh(_Win,e_Menu(id_create_win,_ShiftCtlAlt),0):-!,
	win_date_editor_Create(_Win),
	menu_Enable(_Win,"Test",b_true),
	menu_Update(_Win),
	!.
%END Task Window, id_create_win

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	class_Destroy(date_cc_class),
	fail.
%END Task Window, e_Destroy

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("datectrl.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_exit,_ShiftCtlAlt),0):-!,
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
  	vpi_ShowHelpContext("datectrl.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

ifdef use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
enddef
ifdef ws_win
  ifdef use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  enddef
enddef  
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"datectrl",task_win_Title).

%BEGIN_TLB Project toolbar, 12:00:30-24.11.1999, Code automatically updated!
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











%BEGIN_TLB Help line, 12:00:36-24.11.1999, Code automatically updated!
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

%BEGIN About dialog, CreateParms, 19:58:40-24.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

predicates

  dlg_about_dialog_eh : EHANDLER

clauses

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

%BEGIN_DLG Date editor dialog
/**************************************************************************
	Creation and event handling for dialog: Date editor dialog
**************************************************************************/

constants

%BEGIN Date editor dialog, CreateParms, 11:59:28-24.11.1999, Code automatically updated!
  dlg_date_editor_dialog_ResID = idd_date_dialog
  dlg_date_editor_dialog_DlgType = wd_Modal
  dlg_date_editor_dialog_Help = idh_contents
%END Date editor dialog, CreateParms

predicates

  dlg_date_editor_dialog_eh : EHANDLER

clauses

  dlg_date_editor_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_date_editor_dialog_DlgType,dlg_date_editor_dialog_ResID,dlg_date_editor_dialog_eh,0),!.

%BEGIN Date editor dialog, idc_ok _CtlInfo
  dlg_date_editor_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Date editor dialog, idc_ok _CtlInfo
%MARK Date editor dialog, new events

  dlg_date_editor_dialog_eh(_,_,_):-!,fail.

%END_DLG Date editor dialog


%BEGIN_DLG Set state
/**************************************************************************
	Creation and event handling for dialog: Set state
**************************************************************************/

constants

%BEGIN Set state, CreateParms, 11:59:44-24.11.1999, Code automatically updated!
  dlg_set_state_ResID = idd_set_state
  dlg_set_state_DlgType = wd_Modal
  dlg_set_state_Help = idh_contents
%END Set state, CreateParms

predicates

  dlg_set_state_eh : EHANDLER
  dlg_set_state_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_set_state_update(DIALOG_VAL_LIST)

clauses

  dlg_set_state_Create(Parent,WSFlag):-

%MARK Set state, new variables

	dialog_CreateModal(Parent,dlg_set_state_ResID,"",
  		[
%BEGIN Set state, ControlList, 11:59:44-24.11.1999, Code automatically updated!,
		df(idc_rb_disabled,radiobuttongroup([idc_rb_disabled,idc_rb_enabled,idc_rb_invisible,idc_rb_visible]),nopr)
%END Set state, ControlList
		],
		dlg_set_state_eh,0,VALLIST,ANSWER),
	dlg_set_state_handle_answer(ANSWER,VALLIST),
	Selection = dialog_VLGetRadiobutton(idc_rb_disabled,VALLIST),!,
	sel_wsflag(Selection,WSFlag).

  dlg_set_state_handle_answer(idc_ok,VALLIST):-!,
	dlg_set_state_update(VALLIST).
  dlg_set_state_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_set_state_handle_answer(_,_):-
	errorexit().

  dlg_set_state_update(_VALLIST):-
%BEGIN Set state, Update controls, 11:59:44-24.11.1999, Code automatically updated!
	_IDC_RB_DISABLED = dialog_VLGetRadiobutton(idc_rb_disabled,_VALLIST),
%END Set state, Update controls
	true.

%MARK Set state, new events

  dlg_set_state_eh(_,_,_):-!,fail.

%END_DLG Set state


%BEGIN_WIN Date editor
/**************************************************************************
        Creation and event handling for window: Date editor
**************************************************************************/

constants
%BEGIN Date editor, CreateParms, 11:27:30-26.9.1996, Code automatically updated!
  win_date_editor_WinType = w_TopLevel
  win_date_editor_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings]
  win_date_editor_Menu = no_menu
  win_date_editor_Title = "Date editor"
  win_date_editor_Help = idh_contents
%END Date editor, CreateParms

predicates

  win_date_editor_eh : EHANDLER

clauses

  win_date_editor_Create(Parent):-
	RCT = calc_rectangle(),
	win_Create(win_date_editor_WinType,RCT,win_date_editor_Title,
		   win_date_editor_Menu,Parent,win_date_editor_Flags,win_date_editor_eh,0),!.
  win_date_editor_Create(_).

%BEGIN Date editor, e_Create
  win_date_editor_eh(_Win,e_Create(_),0):-!,
%BEGIN Date editor, InitControls, 11:27:30-26.9.1996, Code automatically updated!
%END Date editor, InitControls
%BEGIN Date editor, ToolbarCreate, 11:27:30-26.9.1996, Code automatically updated!
%END Date editor, ToolbarCreate
	%--- Date custom controls create ---
ifdef os_os2
	WDef1 = wdef(wc_Custom,rct(40,40,200,67),"",u_Pixels),
	WDef2 = wdef(wc_Custom,rct(70,90,170,117),"",u_Pixels),
elsedef
	WDef1 = wdef(wc_Custom,rct(40,40,200, 62),"",u_Pixels),
	WDef2 = wdef(wc_Custom,rct(70,90,170,112),"",u_Pixels),
enddef
	win_CreateDynControl([customctl(WDef1,date_cc_class,date_cc_id1,[]),
			      customctl(WDef2,date_cc_class,date_cc_id2,[])],_Win),
	!.
%END Date editor, e_Create
%MARK Date editor, new events

%BEGIN Date editor, e_CloseRequest
  win_date_editor_eh(_Win,e_CloseRequest,0):-!,
	TaskWin=vpi_GetTaskWin(),
	menu_Enable(TaskWin,"Test",b_false),
	menu_Update(TaskWin),
	win_Destroy(_Win),
	!.
%END Date editor, e_CloseRequest

%BEGIN Date editor, e_GetFocus
  win_date_editor_eh(Win,e_GetFocus(),0):-
	trap(DateCCWin1 = win_GetCtlHandle(Win,date_cc_id1),_,fail),
	trap(win_SetFocus(DateCCWin1),_,fail).
%END Date editor, e_GetFocus

%BEGIN Date editor, e_Size
  win_date_editor_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	!.
%END Date editor, e_Size

%BEGIN Date editor, e_Menu, Parent window 
  win_date_editor_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Date editor, e_Menu, Parent window

%END_WIN Date editor














