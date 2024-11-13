/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  BRWSLIST
 FileName: BRWSLIST.PRO
 Purpose: Treebrows example
 Written by: Visual Prolog
 Comments:
******************************************************************************/
include "brwslist.inc"
include "brwslist.con"
include "hlptopic.con"

DATABASE - browse
	browselistwin(WINDOW)

PREDICATES
	information_handler:BROWSELIST_INFORMATIONCALLBACK
CLAUSES
	information_handler(_Win,cursor_lost(_ITEM,_POS)):-!.

	information_handler(_Win,closeRequest):-!,
		win_Destroy(_Win).
	information_handler(_Win,cursor_got(_ITEM,_POS)):-!.

	information_handler(Win,key_down(302,c_nothing)):-!,
		browselist_cursormovenext(Win).

	information_handler(Win,key_down(301,c_nothing)):-!,
		browselist_cursormoveprev(Win).

	information_handler(Win,key_down(302,c_shift)):-!,
		browselist_openitem(Win,[2,1]).

	information_handler(Win,key_down(301,c_shift)):-!,
		browselist_closeitem(Win,[2,1]).
	
	information_handler(Win,key_down(303,c_nothing)):-!,
		browselist_cursorlevelmovenext(Win).
	
	information_handler(Win,key_down(304,c_nothing)):-!,
		browselist_cursorlevelmoveprev(Win).
	
	information_handler(_Win,key_down(A,B)):-!,
		write(A," ",B),nl,!.
	
	information_handler(Win,node_open(_ITEM,POS)):-
		Pict_5 = 	pict_GetFromRes(idb_bmp5),
		Pict_6 =	pict_GetFromRes(idb_bmp6),
		Pict_Computer =	pict_GetFromRes(idb_computer),
		Pict_Folder = 	pict_GetFromRes(idb_folder),
		Pict_Max = 	pict_GetFromRes(idb_max),
		Pict_Paper = 	pict_GetFromRes(idb_paper),
		browselist_ItemUpdate(Win,Pos,
			browselistitem(0,"Open",node(open,
			  [browselistItem(0,"Node1",node(open,
			    [browselistItem(0,"Node2",node(open,
			      [browselistItem(0,"Node3",node(open,
			        [browselistItem(0,"Node4",node(open,
			          [browselistItem(0,"Node5",node(open,
			            [browselistItem(0,"Node6",leaf,Pict_Max)]),
			          Pict_5)]),
			        Pict_5)]),
			      Pict_6)]),
			    Pict_Paper)]),
		          Pict_Folder)]),
		        Pict_Computer)),!.

	information_handler(Win,node_close(_ITEM,POS)):-
		Pict_6 = 	pict_GetFromRes(idb_bmp6),
		browselist_ItemUpdate(Win,Pos,browselistitem(0,"Closed",node(close,[]),Pict_6)),!.

	information_handler(Win,create(_Long)):-!,
		Pict_5 = 	pict_GetFromRes(idb_bmp5),
		Pict_6 =	pict_GetFromRes(idb_bmp6),
		Pict_Computer =	pict_GetFromRes(idb_computer),
		Pict_Folder = 	pict_GetFromRes(idb_folder),
		Pict_Max = 	pict_GetFromRes(idb_max),
		Pict_Paper = 	pict_GetFromRes(idb_paper),
		ITEM=browselistItem(0,"Ms-dos_6(C:)",node(open,
			[browselistItem(0,"Node1",node(open,
		  	  [browselistItem(0,"Node2",node(open,
		    	    [browselistItem(0,"Node3",node(open,
		      	      [browselistItem(0,"Node4",node(open,
		        	[browselistItem(0,"Node5",node(open,
		          	  [browselistItem(0,"Node6",leaf,Pict_Max)]),
		           	 Pict_5)]),
		               Pict_6)]),
		       	     Pict_Paper)]),
		     	   Pict_Paper)]),
		   	 Pict_Folder)]),
		      Pict_Computer),
		browselist_ItemUpdate(Win,[],ITEM),
		browselist_cursorset(Win,[]).

	information_handler(_,_).


%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 16:28:18-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_Maximized]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Brwslist"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 16:28:18-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 16:28:18-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	write("Press F7 to open windows"),nl,
	!.
%END Task Window, e_Create

%MARK Task Window, new events


%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest,0):-!,
		win_destroy(_WIn),
	!.
%END Task Window, e_CloseRequest

%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-!,
	!.
%END Task Window, id_file_open

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	  BROWSELISTWIN=browselist_create(w_toplevel,rct(50,50,300,400),"BROWSELIST1",no_menu,_Win,[wsf_ClipSiblings,wsf_sizeborder,wsf_titlebar,wsf_hscroll,wsf_vscroll,wsf_minimize,wsf_maximize,wsf_close],0,information_handler),
		assert(browselistwin(BROWSELISTWIN)),
	  BROWSELISTWIN2=browselist_create(w_toplevel,rct(350,150,600,600),"BROWSELIST2",no_menu,_Win,[wsf_ClipSiblings,wsf_sizeborder,wsf_titlebar,wsf_hscroll,wsf_vscroll,wsf_minimize,wsf_maximize,wsf_close],0,information_handler),
		assert(browselistwin(BROWSELISTWIN2)),
		write("Please notice that in this demo it's only dummy data which is inserted when opening a node."),nl,
		write("The user application has the entire control of what's happening when opening a node."),nl,
		!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("brwslist.hlp"),
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
  	vpi_ShowHelpContext("brwslist.hlp",HelpTopic),!.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"brwslist",task_win_Title).

%BEGIN_TLB Project toolbar, 16:28:34-24.11.1999, Code automatically updated!
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



















%BEGIN_TLB Help line, 16:28:38-24.11.1999, Code automatically updated!
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

%BEGIN About dialog, CreateParms, 11:03:32-11.1.2000, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modeless
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














