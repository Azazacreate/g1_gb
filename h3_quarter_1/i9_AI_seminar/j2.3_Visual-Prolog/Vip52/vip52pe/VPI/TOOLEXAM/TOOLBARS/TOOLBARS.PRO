/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  TOOLBARS
 FileName: TOOLBARS.PRO
 Purpose: Toolbar Demonstration
 Written by: Ilyin Yuri
 Comments:

******************************************************************************/

include "toolbars.inc"
include "toolbars.con"

PREDICATES
  toolbar_action : TOOLBAR_ACTION_FUNC
  
CLAUSES  

  toolbar_action(Win,Id,ctrl_value(B1,B2)):-
  	format(S,"Callback event: Win=%,Id=%,En=%,Rel=%",Win,Id,B1,B2),
  	dlg_Note("",S),
  	!.
  toolbar_action(_,_,_).  	

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 16:19:24-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Toolbars"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 16:19:24-24.11.1999, Code automatically updated!
	tb_moveable_Create(_Win),
	tb_status_line_Create(_Win),
	tb_project_toolbar_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
 	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest,0):-!,
%	clear_tooltip_win,  "EA 24.04"
	win_Destroy(_Win),
	!.
%END Task Window, e_CloseRequest

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
  	win_Clear(_Win,color_White),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_Toolbars_inside
  task_win_eh(_Win,e_Menu(id_Toolbars_inside,_),0):-!,
	win_inside_Create(_Win),
	!.
%END Task Window, id_Toolbars_inside
%BEGIN Task Window, id_Toolbars_leftright
  task_win_eh(_Win,e_Menu(id_Toolbars_leftright,_),0):-!,
	win_demo_Create(_Win),
	!.
%END Task Window, id_Toolbars_leftright
%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about
%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("toolbars.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents
%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
%	clear_tooltip_win, "EA 24.04"
	win_Destroy(_Win),
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

  task_win_eh(Win,e_Menu(Id,_),0):-!,
	format(S,"Menu event: Win=%,Id=%",Win,Id),
	dlg_Note("",S).
  task_win_eh(Win,e_Control(Id,_,_,_),0):-!,
	format(S,"Control event: Win=%,Id=%",Win,Id),
	dlg_Note("",S).

/***************************************************************************
			Main Goal Project
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"toolbars",task_win_Title).

%END_WIN Task Window

%BEGIN_TLB Project toolbar, 16:20:00-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0x808080,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"New file",1,1),
		 tb_ctrl(id_file_open,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open file",1,1),
		 tb_ctrl(id_file_save,pushb,idb_save_up,idb_save_dn,idb_save_up,"File save",1,1),
		 separator,
		 tb_ctrl(id_edit_undo,pushb,idb_undo_up,idb_undo_dn,idb_undo_up,"Undo",1,1),
		 tb_ctrl(id_edit_redo,pushb,idb_redo_up,idb_redo_dn,idb_redo_up,"Redo",1,1),
		 separator,
		 tb_ctrl(id_edit_cut,pushb,idb_cut_up,idb_cut_dn,idb_cut_up,"Cut to clipboard",1,1),
		 tb_ctrl(id_edit_copy,pushb,idb_copy_up,idb_copy_dn,idb_copy_up,"Copy to clipboard",1,1),
		 tb_ctrl(id_edit_paste,pushb,idb_paste_up,idb_paste_dn,idb_paste_up,"Paste from clipboard",1,1),
		 separator,
		 separator,
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help",1,1)]),
enddef
	true.
%END_TLB Project toolbar



%BEGIN_TLB Status line, 16:19:48-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Status line
**************************************************************************/

clauses

  tb_status_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0x808080,_Parent,
		[tb_text(idt_status_line_1,tb_static,100,1,4,10,0x800080,"Status Line"),
		 tb_text(idt_status_line_2,tb_context,184,0,4,10,0x0,""),
		 separator,
		 tb_text(idt_status_line_3,tb_static,52,1,3,10,0x80,"PDC")]),
enddef
	true.
%END_TLB Status line


%BEGIN_TLB Moveable, 14:30:32-12.2.1995
/**************************************************************************
		Creation to toolbar: Moveable
**************************************************************************/

CLAUSES

  tb_moveable_Create(_Parent):-
IFDEF use_tbar
	toolbar_create(tb_moveable("Toolbar",pnt(50,55)),0x808080,_Parent,
		[tb_ctrl(idt_moveable_1,checkb,idb_rot_off,idb_rot_on,idb_rot_gr,"On/Off switch",1,1),
		 tb_ctrl(idt_moveable_2,checkb,idb_rot_off,idb_rot_on,idb_rot_gr,"On/Off switch",1,1),
		 tb_ctrl(idt_moveable_3,checkb,idb_rot_off,idb_rot_on,idb_rot_gr,"On/Off switch",1,1),
		 new_row,
		 tb_ctrl(idt_moveable_4,checkb,idb_switch_off,idb_switch_on,idb_switch_gr,"Turbo switch",1,1),
		 tb_ctrl(idt_moveable_5,checkb,idb_switch_off,idb_switch_on,idb_switch_gr,"Turbo switch",1,1),
		 tb_ctrl(idt_moveable_6,checkb,idb_switch_off,idb_switch_on,idb_switch_gr,"Turbo switch",1,1)]),
ENDDEF
	!.
%END_TLB Moveable
%BEGIN_TLB Inside, 15:02:39-20.2.1996, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Inside
**************************************************************************/

CLAUSES

  tb_inside_Create(_Parent):-
IFDEF use_tbar
	toolbar_create(tb_inside(pnt(50,5)),0xC0C0C0,_Parent,
		[tb_lbut(idt_inside_1,112,["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],b_true,2),
		 new_row,
		 tb_ctrl(idt_inside_2,checkb,idb_switch_off,idb_switch_on,idb_switch_gr,"Processor",1,1),
		 tb_ctrl(idt_inside_3,checkb,idb_switch_off,idb_switch_on,idb_switch_gr,"Memory",1,1),
		 tb_ctrl(idt_inside_4,checkb,idb_switch_off,idb_switch_on,idb_switch_gr,"Adapters",1,1),
		 new_row,
		 tb_text(idt_inside_5,tb_context,96,0,3,10,8388608,"Select command")],
		 toolbar_action),
ENDDEF
	!.
%END_TLB Inside

%BEGIN_WIN Inside
/**************************************************************************
        Creation and event handling for window: Inside
**************************************************************************/

CONSTANTS
%BEGIN Inside, CreateParms, 15:32:47-20.2.1996, Code automatically updated!
  win_inside_WinType = w_TopLevel
  win_inside_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren]
  win_inside_RCT = rct(35,58,435,258)
  win_inside_Menu = no_menu
  win_inside_Title = "Fixed inside ParentWin"
  win_inside_Help = idh_contents
%END Inside, CreateParms

PREDICATES

  win_inside_eh : EHANDLER

CLAUSES

  win_inside_Create(Parent):-
	win_Create(win_inside_WinType,win_inside_RCT,win_inside_Title,
		   win_inside_Menu,Parent,win_inside_Flags,win_inside_eh,0).

%BEGIN Inside, e_Create
  win_inside_eh(_Win,e_Create(_),0):-!,
%BEGIN Inside, InitControls, 15:32:47-20.2.1996, Code automatically updated!
%END Inside, InitControls
%BEGIN Inside, ToolbarCreate, 15:32:47-20.2.1996, Code automatically updated!
	tb_inside_Create(_Win),
%END Inside, ToolbarCreate
	!.
%END Inside, e_Create
%MARK Inside, new events

%BEGIN Inside, e_GetFocus
  win_inside_eh(_Win,e_GetFocus,0):-!,
IFDEF os_os2
	win_Invalidate(_Win),
ENDDEF
	!.
%END Inside, e_GetFocus

%BEGIN Inside, e_Size
  win_inside_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Inside, e_Size

%BEGIN Inside, e_Menu, Parent window 
  win_inside_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Inside, e_Menu, Parent window

%END_WIN Inside

%BEGIN_TLB Right, 15:59:36-20.2.1996, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Right
**************************************************************************/

CLAUSES

  tb_right_Create(_Parent):-
IFDEF use_tbar
	toolbar_create(tb_right,0x800000,_Parent,
		[tb_ctrl(idt_right_1,checkb,idb_switch_off,idb_switch_on,idb_switch_gr,"Switch",1,0),
		 separator,
		 tb_ctrl(idt_right_2,checkb,idb_switch_off,idb_switch_on,idb_switch_gr,"ON/OFF",1,1)],
		 toolbar_action),
ENDDEF
	!.
%END_TLB Right

%BEGIN_TLB Left, 16:19:30-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Left
**************************************************************************/

clauses

  tb_left_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_left,0x808080,_Parent,
		[tb_ctrl(idt_left_1,pushb,idb_flower_up,idb_flower_dn,idb_flower_up,"one",1,0),
		 tb_ctrl(idt_left_2,pushb,idb_flower_up,idb_flower_dn,idb_flower_up,"two",1,1),
		 tb_ctrl(idt_left_3,pushb,idb_flower_up,idb_flower_dn,idb_flower_up,"three",1,1),
		 tb_ctrl(idt_left_4,pushb,idb_flower_up,idb_flower_dn,idb_flower_up,"four",1,1),
		 tb_ctrl(idt_left_5,pushb,idb_flower_up,idb_flower_dn,idb_flower_up,"five",1,1)]),
enddef
	true.
%END_TLB Left



%BEGIN_WIN Demo
/**************************************************************************
        Creation and event handling for window: Demo
**************************************************************************/

CONSTANTS
%BEGIN Demo, CreateParms, 16:28:37-20.2.1996, Code automatically updated!
  win_demo_WinType = w_TopLevel
  win_demo_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren]
  win_demo_RCT = rct(10,58,460,258)
  win_demo_Menu = no_menu
  win_demo_Title = "Left and Right Toolbar Demo"
  win_demo_Help = Contents
%END Demo, CreateParms

PREDICATES

  win_demo_eh : EHANDLER

CLAUSES

  win_demo_Create(Parent):-
	win_Create(win_demo_WinType,win_demo_RCT,win_demo_Title,
		   win_demo_Menu,Parent,win_demo_Flags,win_demo_eh,0).

%BEGIN Demo, e_Create
  win_demo_eh(_Win,e_Create(_),0):-!,
%BEGIN Demo, InitControls, 16:28:37-20.2.1996, Code automatically updated!
%END Demo, InitControls
%BEGIN Demo, ToolbarCreate, 16:28:37-20.2.1996, Code automatically updated!
	tb_left_Create(_Win),
	tb_right_Create(_Win),
%END Demo, ToolbarCreate
	!.
%END Demo, e_Create
%MARK Demo, new events

%BEGIN Demo, e_Size
  win_demo_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Demo, e_Size

%BEGIN Demo, e_Menu, Parent window 
  win_demo_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
		!.
%END Demo, e_Menu, Parent window


%END_WIN Demo













%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 16:19:18-24.11.1999, Code automatically updated!
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







