/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  TREE
 FileName: TREE.PRO
 Purpose: VPI tree example
 Written by: Eugene Akimov
 Comments:

******************************************************************************/

include "tree.inc"
include "tree.con"

DATABASE - edwin
	edwin(WINDOW)
	
DATABASE - visualprj
	gen_from(STRING,STRING)
	includes(STRING,STRING)

/****************************************************************
	Building a tree from a network:
	The tree is only built to the depth given by an integer
****************************************************************/

DATABASE - seen_nodes
  nocopy seen_node(STRING)

PREDICATES
  collect_tree(STRING,INTEGER,TREE)
  nondeterm collect_tree1(STRING,INTEGER,TREE)
  rev_treelist(TREELIST,TREELIST,TREELIST)
  register_seen_node(STRING)

CLAUSES
  rev_treelist([],L,L).
  rev_treelist([H|L1],L2,L3):-
	rev_treelist(L1,[H|L2],L3).

  collect_tree(NODE,_,tree(NODE,unmarked,[],0)):-
	seen_node(NODE),!.
  collect_tree(NODE,1,tree(NODE,unmarked,[],0)):-!.
  collect_tree(NODE,N,tree(NODE,unmarked,RevList,0)):-
	findall(T,collect_tree1(NODE,N,T),TREEL),
	rev_treelist(TREEL,[],RevList).

  collect_tree1(NODE,N,TREE):-
	N1=N-1,
	includes(NODE,NODE1),
	register_seen_node(NODE),
	collect_tree(NODE1,N1,TREE).

  collect_tree1(NODE,N,TREE):-
	N1=N-1,
	gen_from(NODE,NODE1),
	register_seen_node(NODE),
	collect_tree(NODE1,N1,TREE).

  register_seen_node(NODE):-
	seen_node(NODE),!.
  register_seen_node(NODE):-
	assert(seen_node(NODE)).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 16:24:36-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Tree"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 16:24:36-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	consult("visual.dba",visualprj),
	retractall(seen_node(_)),
	win_project_tree_Create(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
	win_Clear(_Win,color_LtGray),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-!,
	retractall(_,edwin),
	retractall(seen_node(_)),
	win_project_tree_Create(_Win),
	menu_Enable(_Win,id_Direction_left,b_true),
	menu_Enable(_Win,id_Direction_right,b_true),
	menu_Enable(_Win,id_Direction_up,b_true),
	menu_Enable(_Win,id_Direction_down,b_true),
	menu_Enable(_Win,id_openclose_node,b_true),
	menu_Enable(_Win,id_file_open,b_false),
	menu_Update(_Win),
	!.
%END Task Window, id_file_open

%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	retractall(_,seen_nodes),
	win_Destroy(_Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, id_openclose_node
  task_win_eh(_Win,e_Menu(id_openclose_node,_ShiftCtlAlt),0):-!,
	edwin(_Window),
	tree_OpenCloseNode(_Window) ,
	!.
%END Task Window, id_openclose_node

%BEGIN Task Window, id_Direction_up
  task_win_eh(_Win,e_Menu(id_Direction_up,_ShiftCtlAlt),0):-!,
	edwin(_Window),
	tree_SetDirection(_Window,tree_DirUp) ,
	!.
%END Task Window, id_Direction_up

%BEGIN Task Window, id_Direction_right
  task_win_eh(_Win,e_Menu(id_Direction_right,_ShiftCtlAlt),0):-!,
	edwin(_Window),
	tree_SetDirection(_Window,tree_DirRight) ,
	!.
%END Task Window, id_Direction_right

%BEGIN Task Window, id_Direction_left
  task_win_eh(_Win,e_Menu(id_Direction_left,_ShiftCtlAlt),0):-!,
	edwin(_Window),
	tree_SetDirection(_Window,tree_DirLeft) ,
	!.
%END Task Window, id_Direction_left

%BEGIN Task Window, id_Direction_down
  task_win_eh(_Win,e_Menu(id_Direction_down,_ShiftCtlAlt),0):-!,
	edwin(_Window),
	tree_SetDirection(_Window,tree_DirDown) ,
	!.
%END Task Window, id_Direction_down

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about

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

  task_win_eh(_,_,0):-fail.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"tree",task_win_Title).

%END_WIN Task Window

%BEGIN_WIN Project Tree
/**************************************************************************
	Creation and event handling for window: "Project Tree"
**************************************************************************/

CONSTANTS

%BEGIN Project Tree, CreateParms, 16:24:24-24.11.1999, Code automatically updated!
  win_project_tree_WinType = w_TopLevel
  win_project_tree_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren]
  win_project_tree_RCT = rct(100,80,440,240)
  win_project_tree_Menu = no_menu
  win_project_tree_Title = "Project Tree"
  win_project_tree_Help = idh_contents
%END Project Tree, CreateParms

PREDICATES

  win_project_tree_eh : EHANDLER

CLAUSES

  win_project_tree_Create(Parent):-
IFDEF use_tree
	CRCT=win_GetClientRect(Parent),
	CRCT=rct(L,T,R,B),
	L1=L+50,
	T1=T+50,
	R1=R-50,
	B1=B-50,
	collect_tree("VISUAL.EXE",9,Tree),!,
	TreeDir = tree_dirright,
	Font = font_Create(ff_Times,[],12),
	TreeWinInfo = tree_WinInfo(Font,TreeDir,[]),
	EW=tree_Create(win_project_tree_WinType,rct(L1,T1,R1,B1),win_project_tree_Title,
		win_project_tree_Menu,Parent,win_project_tree_Flags,win_project_tree_eh,0,Tree,TreeWinInfo,[]),
ENDDEF
	assert(edwin(EW)),
	!.

%BEGIN Project Tree, e_Create
  win_project_tree_eh(_Win,e_Create(_),0):-!,
%BEGIN Project Tree, InitControls, 16:24:24-24.11.1999, Code automatically updated!
%END Project Tree, InitControls
%BEGIN Project Tree, ToolbarCreate, 16:24:24-24.11.1999, Code automatically updated!
%END Project Tree, ToolbarCreate
	!.
%END Project Tree, e_Create
%MARK Project Tree, new events

%BEGIN Project Tree, e_CloseRequest
  win_project_tree_eh(_Win,e_CloseRequest,0):-!,
	_Window=win_GetParent(_Win),
	menu_Enable(_Window,id_Direction_left,b_false),
	menu_Enable(_Window,id_Direction_right,b_false),
	menu_Enable(_Window,id_Direction_up,b_false),
	menu_Enable(_Window,id_Direction_down,b_false),
	menu_Enable(_Window,id_openclose_node,b_false),
	menu_Enable(_Window,id_file_open,b_true),
	win_Destroy(_Win),
	!.
%END Project Tree, e_CloseRequest

%BEGIN Project Tree, e_MouseDbl
  win_project_tree_eh(_Win,e_MouseDbl(_,_,_),0):-!,
	FileName = tree_GetSelectedNode(_Win),!,
	format(S,"You choose: %",FileName), dlg_Note("",S).

%END Project Tree, e_MouseDbl

%BEGIN Project Tree, e_Size
  win_project_tree_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Project Tree, e_Size

%BEGIN Project Tree, e_Menu, Parent window 
  win_project_tree_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Project Tree, e_Menu, Parent window

%END_WIN Project Tree






































%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 16:24:12-24.11.1999, Code automatically updated!
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














