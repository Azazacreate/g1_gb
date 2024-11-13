/*****************************************************************************
		Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  CLASS
 FileName: CLASS.PRO
 Purpose: PDC custom controls handling
 Written by: Alexander Gostintsev
 Comments: class_Create demo
******************************************************************************/

include "class.inc"
include "class.con"

GLOBAL PREDICATES

  pdcswitch_handler : EHANDLER        % "PDCSWITCH" class handler
  pdcedit_handler : EHANDLER          % "PDCEDIT" class handler
  pdctree_handler : EHANDLER          % "PDCTREE" class handler

PREDICATES
  nondeterm cc_member(INTEGER,ILIST)
  INTEGER win_GetCtrlId(WINDOW ParentWindow,LONG ControlWindowPtr,ILIST ControlList)
  get_EditorStartupText(INTEGER CtrlId,STRING StartupText)
  get_StartupTree(INTEGER CtrlId,TREE Tree)

CLAUSES

  cc_member(M,[M|_]).
  cc_member(M,[_|L]):- cc_member(M,L).

  win_GetCtrlId(_Win,ControlWindowPtr,CtrlList,CtrlId):-
	CtrlWin=cast(window,ControlWindowPtr),
	cc_member(CtrlId,CtrlList),
	  CtrlHandle=win_GetCtlHandle(_Win,CtrlId),
	  CtrlHandle=CtrlWin,!.
  win_GetCtrlId(_Win,_ControlWindowPtr,_CtrlList,0).

  get_EditorStartupText(idc_edit,"Hello from IDC_EDIT CustomControl"):-!.
  get_EditorStartupText(idc_editor,"Hello from IDC_EDITOR CustomControl"):-!.
  get_EditorStartupText(_,"It is needed startup text. Use get_EditorStartupText predicate").

  get_StartupTree(idc_tree,Tree):-!,
	Tree = tree ( "0:Null", unmarked,
			[
			tree ( "1:One", unmarked, 
			        [], 0
			     ),
			tree ( "2:Two", unmarked,
			 	[tree("3:Three",unmarked,
			 		[],0
			 	     )
			 	],0
			      ),
			tree ("4:Four",unmarked,
			   	[],0
			       )
		        ],0
		     ).
  get_StartupTree(idc_tree1,Tree):-!,
	Tree = tree ( "1:BeerClub", unmarked,
			[
			tree ( "1.1:Cristian",unmarked,[],0),
			tree ( "1.2:Mobill Clun",unmarked,
			 	[
			 	 tree("2.1.1:Elizabeth Mobill",unmarked,[],0),
			 	 tree("2.1.2:John Mobill",unmarked,[],0)
			 	],0
			      ),
			tree ("1.3:Bob Chesterfield ",unmarked,[],0)
		        ],0
		     ).
  get_StartupTree(_,tree( "empty", unmarked, [], 0 )).

/*************************************************************************************
* "PDCSWITCH" Class implementation
**************************************************************************************/

DATABASE - switch

  switchUP(WINDOW)
	
PREDICATES

determ  draw_switch ( WINDOW )

CLAUSES

%-------- PDCSWITCH_HANDLER ---------

  pdcswitch_handler ( _Win, e_Update ( _ ), 0 ) :- !,
	win_Clear ( _Win, color_Gray ),
	draw_Switch ( _Win ).
  pdcswitch_handler ( _Win, e_MouseUp ( _, _, mouse_button_left ), 0 ) :-
	win_Clear ( _Win, color_Gray ),
	draw_Switch ( _Win ).
  pdcswitch_handler ( _Win, e_Destroy, 0 ) :- !,
	retractall(switchUP(_Win)).

%-------- draw OFF switch ---------

  draw_switch ( W ) :-
	retract(switchUP(W)), !,
	win_SetPen ( W, pen (1, ps_Solid, color_Blue ) ),
	win_SetBrush ( W, brush ( pat_Solid, color_LtGray ) ),
	CLRCT = win_GetClientRect ( W ),
	CLRCT = rct ( _, _, WIDTH, HEIGHT ),
	BASEX = WIDTH / 2, BASEY = HEIGHT / 2,
	L = BASEX - 10, T = BASEY - 20,
	R = BASEX + 20, B = BASEY + 10,
	draw_Rect ( W, rct ( L, T, R, B ) ),
	X1 = L - 10, Y1 = T + 10,
	X2 = X1, Y2 = Y1 + 30,
	X3 = X2 + 30, Y3 = Y2,
	X4 = R, Y4 = B,
	X5 = X2, Y5 = Y2,
	X6 = L, Y6 = B,
	draw_PolyLine ( W, [ pnt ( L, T ), pnt ( X1, Y1 ), pnt ( X2, Y2 ), pnt ( X3, Y3 ), pnt ( X4, Y4 ) ] ),
	draw_Line ( W, pnt ( X5, Y5 ), pnt ( X6, Y6 ) ).

%-------- draw ON switch ---------

  draw_switch ( W ):-
	assert(switchUP(W)),		
	win_SetPen ( W, pen ( 1, ps_Solid, color_Blue ) ),
	win_SetBrush ( W, brush ( pat_Solid, color_Red ) ),
	CLRCT = win_GetClientRect ( W ),
	CLRCT = rct ( _, _, WIDTH, HEIGHT ),
	BASEX = WIDTH / 2, BASEY = HEIGHT / 2,
	L = BASEX - 15, T = BASEY - 15,
	R = BASEX + 15, B = BASEY + 15,
	draw_Rect ( W, rct ( L, T, R, B ) ),
	X1 = L - 5, Y1 = T + 5,
	X2 = X1, Y2 = Y1 + 30,
	X3 = X2 + 30, Y3 = Y2,
	X4 = R, Y4 = B,
	X5 = X2, Y5 = Y2,
	X6 = L, Y6 = B,
	draw_PolyLine ( W, [ pnt ( L, T ), pnt ( X1, Y1 ), pnt ( X2, Y2 ), pnt ( X3, Y3 ), pnt ( X4, Y4 ) ] ),
	draw_Line ( W, pnt ( X5, Y5 ), pnt ( X6, Y6 ) ).

/*************************************************************************************
* "PDCEDIT" Class implementation
**************************************************************************************/

CONSTANTS

  ctrlX = 24
  ctrlC = 3
  ctrlV = 22
  getStartupText = 1000
  getStartupTree = 1010

CLAUSES

  pdcedit_handler (_Win,e_create(_),0 ) :-
	ParentWin=win_GetParent(_Win),
	ControlWindowPtr=cast(long,_Win),
	TextPtr=win_SendEvent(ParentWin,e_User(getStartupText,ControlWindowPtr)),
	Text=cast(string,TextPtr),
	Font = font_Create ( ff_Times, [], 15 ),
	edit_CreateSubClass ( _Win, "*.pro", Font, b_false, b_true, b_false,Text, 1, pdcedit_handler ),!,
	fail.

  pdcedit_handler (_Win,e_Char(ctrlX,_),0 ) :-
	edit_Cut(_Win),!.
  pdcedit_handler (_Win,e_Char(ctrlC,_),0 ) :-
	edit_Copy(_Win),!.
  pdcedit_handler (_Win,e_Char(ctrlV,_),0 ) :-
	edit_Paste(_Win),!.
  pdcedit_handler ( W, e_MouseDown ( _, _, _ ), 0 ) :- !, 
	win_SetFocus ( W ), fail.

/*************************************************************************************
* "PDCTREE" Class implementation
**************************************************************************************/
PREDICATES

%  INTEGER win_GetCtrlId(WINDOW ParentWindow,LONG ControlWindowPtr,ILIST ControlList)

CLAUSES

  pdctree_handler ( _Win, e_Create(_), 0 ) :- 
	ParentWin=win_GetParent(_Win),
	ControlWindowPtr=cast(long,_Win),
	TreePtr=win_SendEvent(ParentWin,e_User(getStartupTree,ControlWindowPtr)),
	Tree=cast(tree,TreePtr),
	TreeFont = font_Create ( ff_Times, [], 10 ),
	TreeWinInfo = tree_WinInfo ( TreeFont, tree_DirRight, [] ),
	tree_CreateSubClass( _Win, Tree, TreeWinInfo, [] ),
	fail.

  pdctree_handler ( _Win, e_User(Id,Data), Return ) :- !,
	_ControlId=win_GetCtlId(_Win) ,
	Return=cast(long,_ControlId),
	nl,writef("ControlId=% Id=% Data=%",_ControlId,Id,Data).

  pdctree_handler ( W, e_MouseDbl ( _, _, _ ), 0 ) :-
		tree_OpenCloseNode ( W ).
		
%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 17:17:58-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Class"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
	class_Create("PDCSWITCH",pdcswitch_handler),
	class_Create("PDCEDIT",pdcedit_handler),
	class_Create("PDCTREE",pdctree_handler),
%BEGIN Task Window, InitControls, 17:17:58-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 17:17:58-23.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.

%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	dlg_custom_controls_dialog_Create(_Win),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
  	win_Clear(_Win,color_White),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("class.hlp"),
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

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	class_Destroy("PDCSWITCH"),
	class_Destroy("PDCEDIT"),
	class_Destroy("PDCTREE").
%END Task Window, e_Destroy

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"class",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 15:03:10-25.11.1999, Code automatically updated!
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

  dlg_about_dialog_eh(_,_,0):-!,fail.
%END_DLG About dialog

%BEGIN_TLB Help line, 17:18:38-23.11.1999, Code automatically updated!
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


%BEGIN_TLB Project toolbar, 17:18:34-23.11.1999, Code automatically updated!
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
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help;Help",1,1)]),
enddef
	true.
%END_TLB Project toolbar


%BEGIN_DLG Custom controls Dialog
/**************************************************************************
	Creation and event handling for dialog: Custom controls Dialog
**************************************************************************/

CONSTANTS

%BEGIN Custom controls Dialog, CreateParms, 10:57:25-10.12.1999, Code automatically updated!
  dlg_custom_controls_dialog_DlgType = wd_Modeless
  dlg_custom_controls_dialog_Title = "Custom controls Dialog"
  dlg_custom_controls_dialog_RCT = rct(49,15,319,213)
  dlg_custom_controls_dialog_Flags = [wsf_Close,wsf_TitleBar,wsf_ClipSiblings]
  dlg_custom_controls_dialog_Help = idh_contents
%END Custom controls Dialog, CreateParms

PREDICATES

  dlg_custom_controls_dialog_eh : EHANDLER

CLAUSES

  dlg_custom_controls_dialog_Create(Parent):-
	win_CreateDynDialog(Parent,
		[
%BEGIN Custom controls Dialog, WinDefList, 10:57:25-10.12.1999, Code automatically updated!
		 dlg(wdef(dlg_custom_controls_dialog_DlgType,dlg_custom_controls_dialog_RCT,dlg_custom_controls_dialog_Title,u_DlgBase),dlg_custom_controls_dialog_Flags),
		 customctl(wdef(wc_Custom,rct(7,24,88,82),"tree",u_DlgBase),"PDCTREE",idc_tree,[wsf_Group,wsf_TabStop]),
		 customctl(wdef(wc_Custom,rct(94,24,175,82),"Switch",u_DlgBase),"PDCSWITCH",idc_switch,[wsf_Group,wsf_TabStop]),
		 customctl(wdef(wc_Custom,rct(180,24,261,82),"Tree",u_DlgBase),"PDCTREE",idc_tree1,[wsf_Group,wsf_TabStop]),
		 customctl(wdef(wc_Custom,rct(7,85,261,112),"Edit",u_DlgBase),"PDCEDIT",idc_edit,[wsf_Group,wsf_TabStop,wsf_VScroll,wsf_HScroll]),
		 customctl(wdef(wc_Custom,rct(29,133,132,189),"pdctree",u_DlgBase),"PDCTREE",idc_pdctree,[wsf_Group,wsf_TabStop]),
		 customctl(wdef(wc_Custom,rct(141,133,244,189),"EDITOR",u_DlgBase),"PDCEDIT",idc_editor,[wsf_Group,wsf_TabStop,wsf_VScroll,wsf_HScroll]),
		 ctl(wdef(wc_PushButton,rct(23,121,133,131),"Send message to CustomControl",u_DlgBase),idc_send_message_to_customcontrol,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(140,116,180,128),"OK",u_DlgBase),idc_ok,[wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(6,5,92,14),"PDCTREE Custom Control",u_DlgBase),idct_press_button_to_activate_tree,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(93,13,168,23),"PDCSWITCH C- Control",u_DlgBase),idc_custom_controls_dialog_7,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(179,5,265,15),"PDCTREE Custom Control",u_DlgBase),idc_custom_controls_dialog_8,[wsf_AlignLeft])
%END Custom controls Dialog, WinDefList
		],dlg_custom_controls_dialog_eh,0),!.

%BEGIN Custom controls Dialog, idc_ok _CtlInfo
  dlg_custom_controls_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Custom controls Dialog, idc_ok _CtlInfo
%MARK Custom controls Dialog, new events

%BEGIN Custom controls Dialog, idc_send_message_to_customcontrol _CtlInfo
  dlg_custom_controls_dialog_eh(_Win,e_Control(idc_send_message_to_customcontrol,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	 CustomWindow =win_GetCtlHandle(_Win, idc_pdctree),
	_Reply=win_SendEvent(CustomWindow,e_User(45,234)),
	nl,writef("Recieved Control's Id = % (should be % )",_Reply,idc_pdctree),
	!.
%END Custom controls Dialog, idc_send_message_to_customcontrol _CtlInfo

%BEGIN Custom controls Dialog, e_User
  dlg_custom_controls_dialog_eh(_Win,e_User(getStartupText,ControlWindowPtr),StrPtr):-
	ControlWindow=cast(window,ControlWindowPtr),
	CtrlId=win_GetCtlId(ControlWindow),
	get_EditorStartupText(CtrlId,Text),
	StrPtr=cast(long,Text),
	!.

  dlg_custom_controls_dialog_eh(_Win,e_User(getStartupTree,ControlWindowPtr),TreePtr):-
	ControlWindow=cast(window,ControlWindowPtr),
	CtrlId=win_GetCtlId(ControlWindow),
	get_StartupTree(CtrlId,Tree),
	TreePtr=cast(long,Tree),
	!.
%END Custom controls Dialog, e_User
  dlg_custom_controls_dialog_eh(_,_,0):-!,fail.
%END_DLG Custom controls Dialog

%BEGIN_WIN myclass_ed
/**************************************************************************
        Creation and event handling for window: myclass_ed
**************************************************************************/

CONSTANTS
%BEGIN myclass_ed, CreateParms, 17:18:20-23.11.1999, Code automatically updated!
  win_myclass_ed_WinType = w_TopLevel
  win_myclass_ed_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  win_myclass_ed_RCT = rct(100,80,440,176)
  win_myclass_ed_Menu = no_menu
  win_myclass_ed_Title = "myclass_ed"
  win_myclass_ed_Help = idh_contents
%END myclass_ed, CreateParms

PREDICATES

  win_myclass_ed_eh : EHANDLER

CLAUSES

  win_myclass_ed_Create(Parent):-
	win_Create(win_myclass_ed_WinType,win_myclass_ed_RCT,win_myclass_ed_Title,
		   win_myclass_ed_Menu,Parent,win_myclass_ed_Flags,win_myclass_ed_eh,0).

%BEGIN myclass_ed, e_Create
  win_myclass_ed_eh(_Win,e_Create(_),0):-!,
%BEGIN myclass_ed, InitControls, 17:18:20-23.11.1999, Code automatically updated!
%END myclass_ed, InitControls
%BEGIN myclass_ed, ToolbarCreate, 17:18:20-23.11.1999, Code automatically updated!
%END myclass_ed, ToolbarCreate
	!.
%END myclass_ed, e_Create
%MARK myclass_ed, new events

%BEGIN myclass_ed, e_Size
  win_myclass_ed_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END myclass_ed, e_Size

%BEGIN myclass_ed, e_Menu, Parent window 
  win_myclass_ed_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END myclass_ed, e_Menu, Parent window
%END_WIN myclass_ed


































