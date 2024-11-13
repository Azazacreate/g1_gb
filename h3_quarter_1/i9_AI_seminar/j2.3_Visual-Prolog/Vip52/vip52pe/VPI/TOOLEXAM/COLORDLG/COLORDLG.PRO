/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  COLORDLG
 FileName: COLORDLG.PRO
 Purpose: Color Setup Dialog Demo
 Written by: Lars Henrik Jacobsen
 Comments:
******************************************************************************/

include "colordlg.inc"
include "colordlg.con"

DATABASE - local_color_db
  color_item(Integer,BRUSH)
  item_name(Integer,String)
  temp_item(Integer,BRUSH)

CLAUSES
  color_item(0,brush(pat_Solid,color_blue)).
  color_item(1,brush(pat_Solid,color_red)).
  color_item(2,brush(pat_Solid,color_green)).
  
  item_name(0,"Item 1").
  item_name(1,"Item 2").
  item_name(2,"Item 3").

PREDICATES
  nondeterm nd_color_elem(COLOR_ELEM)
CLAUSES
  nd_color_elem(elem(Item,Brush)) :-
	item_name(ItemId,Item),
	color_item(ItemId,Brush).

PREDICATES
  color_inits(COLOR_LIST)
CLAUSES
  color_inits(_) :-
	retractall(temp_item(_,_)),
	fail.
  color_inits(_) :-
	item_name(ItemId,_Item),
	  color_item(ItemId,Brush),
	    assert(temp_item(ItemId,Brush)),
	fail.
  color_inits(L) :-
	findall(X,nd_color_elem(X),L).
	

PREDICATES
  refresh_colors_in_all_windows
CLAUSES
  refresh_colors_in_all_windows.
  
/***************************************************************************
	Color callback
***************************************************************************/
PREDICATES
  color_cb : COLOR_CALLBACK
CLAUSES
  color_cb(_,color_cb_ok,_,ITEM,BRUSH) :- 
    item_name(ID,ITEM),
    retract(color_item(ID,_)), !,
    assert(color_item(ID,BRUSH)),
    refresh_colors_in_all_windows.
    
  color_cb(_,color_cb_cancel,_,_,_) :- !,
    refresh_colors_in_all_windows.
  
  color_cb(_,color_cb_accept,IDSEL,ITEM,CBRUSH) :-
    IDSEL<>-1,
    item_name(ID,ITEM),
    retract(temp_item(ID,_)), !,
    assert(temp_item(ID,CBRUSH)).

  color_cb(CW,color_cb_apply,IDSEL,ITEM,CBRUSH) :-
    IDSEL<>-1,
    item_name(ID,ITEM),
    retract(color_item(ID,_)), !,
    assert(color_item(ID,CBRUSH)),
    refresh_colors_in_all_windows,
    win_SetFocus(CW).

  color_cb(_,_,_,_,_).


%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 11:32:46-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Colordlg"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 11:32:46-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 11:32:46-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("colordlg.hlp"),
	!.
ENDDEF
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

%MARK Task Window, new events

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	color_inits(L),
	colsetup_set_configuration(_Win,"Color Setup",0,color_cb,L),
	!.
%END Task Window, id_file_new
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"colordlg",task_win_Title).

%END_WIN Task Window,

%BEGIN_TLB Project toolbar, 11:33:14-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
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
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help",0,1)]),
enddef
	true.
%END_TLB Project toolbar















%BEGIN_TLB Help line, 11:33:20-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/

clauses

  tb_help_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0x808080,_Parent,
		[tb_text(idt_help_line,tb_context,452,0,4,10,0x0,"")]),
enddef
	true.
%END_TLB Help line


%BEGIN_DLG About dialog
/**************************************************************************
        Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 19:58:42-24.11.1999, Code automatically updated!
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

%BEGIN About dialog, System handled events
  dlg_about_dialog_eh(_,_,0):-!,fail.
%END About dialog, System handled events
%END_DLG About dialog



















