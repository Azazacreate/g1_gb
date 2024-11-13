/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	MAPTEST
 FileName:	MAPTEST.PRO
 Purpose:	Map custom control example program
 Written by:	Alexander Butovsky
 Comments:
******************************************************************************/
ifdef platform_16bit
  code = 5000
enddef

include "maptest.inc"
include "maptest.con"

constants
  mvctrl_id = 987
  destroy_message = 7575

database - maptest_local
  determ mode(INTEGER)

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/
predicates
  task_win_eh : EHANDLER
  % import()

constants
%BEGIN Task Window, CreateParms, 13:16:22-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Maptest"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 13:16:22-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 13:16:22-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	class_Create("mapctrl",mapctrl_eh),
	!.

%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_map_create_dyn
  task_win_eh(_Win,e_Menu(id_map_create_dyn,_ShiftCtlAlt),0):-
	assert(mode(1)),
	dlg_mapctrl_test_Create(_Win),!.
%END Task Window, id_map_create_dyn

%BEGIN Task Window, id_map_create_file
  task_win_eh(_Win,e_Menu(id_map_create_file,_ShiftCtlAlt),0):-
	assert(mode(2)),
	dlg_mapctrl_test_Create(_Win),!.
%END Task Window, id_map_create_file

%BEGIN Task Window, id_map_create_edit
  task_win_eh(_Win,e_Menu(id_map_create_edit,_ShiftCtlAlt),0):-
	assert(mode(3)),
	Title="Map editor",
	win_map_Create(_Win,Title),
	!.
%END Task Window, id_map_create_edit

%BEGIN Task Window, id_map_create_win
  task_win_eh(_Win,e_Menu(id_map_create_win,_ShiftCtlAlt),0):-
	assert(mode(2)),
	Title="Map view",
	win_map_Create(_Win,Title),
	!.
%END Task Window, id_map_create_win

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("maptest.hlp"),
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
  	vpi_ShowHelpContext("maptest.hlp",HelpTopic),!.

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
enddef  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"maptest",task_win_Title).

%BEGIN_TLB Project toolbar, 15:22:24-4.9.1997, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_map_create_file,pushb,idb_new_up,idb_new_dn,idb_new_up,"New;Create data from file",1,1),
		 tb_ctrl(id_map_create_dyn,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open;Create dynamic data",1,1),
		 tb_ctrl(id_map_create_win,pushb,idb_save_up,idb_save_dn,idb_save_up,"Save;Create in window",1,1),
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

%BEGIN_TLB Help line, 17:58:45-27.3.1997, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/

clauses

  tb_help_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0xC0C0C0,_Parent,
		[tb_text(idt_help_line,tb_context,452,0,4,10,0,"")]),
enddef
	!.
%END_TLB Help line

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

constants

%BEGIN About dialog, CreateParms, 15:08:06-4.9.1997, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = contents
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

%BEGIN_DLG MapCtrl Test
/**************************************************************************
	Creation and event handling for dialog: MapCtrl Test
**************************************************************************/

constants

%BEGIN MapCtrl Test, CreateParms, 13:19:10-11.4.1997, Code automatically updated!
  dlg_mapctrl_test_ResID = idd_mapctrl_test
  dlg_mapctrl_test_DlgType = wd_Modal
  dlg_mapctrl_test_Help = contents
%END MapCtrl Test, CreateParms

predicates
  dlg_mapctrl_test_eh : EHANDLER

clauses
  dlg_mapctrl_test_Create(Parent):-
	win_CreateResDialog(Parent,dlg_mapctrl_test_DlgType,dlg_mapctrl_test_ResID,dlg_mapctrl_test_eh,0).

%BEGIN MapCtrl Test, idc_ok _CtlInfo
  dlg_mapctrl_test_eh(Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(Win),
	!.
%END MapCtrl Test, idc_ok _CtlInfo
%MARK MapCtrl Test, new events

%BEGIN MapCtrl Test, idc_get_marker _CtlInfo
  dlg_mapctrl_test_eh(_Win,e_Control(idc_get_marker,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	MapCtrlWin = win_GetCtlHandle(_Win,idc_mapctrl),
	Marker =  mapctrl_GetMarker(MapCtrlWin),
	write("mapctrl_GetMarker return: Marker=",Marker,"\n"),
	!.
%END MapCtrl Test, idc_get_marker _CtlInfo

%BEGIN MapCtrl Test, idc_set_marker _CtlInfo
  dlg_mapctrl_test_eh(_Win,e_Control(idc_set_marker,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	MapCtrlWin = win_GetCtlHandle(_Win,idc_mapctrl),
	mapctrl_SetMarker(MapCtrlWin,[781,783,785]),
	write("mapctrl_SetMarker marked objects 781, 783 and 785.\n"),
	!.
%END MapCtrl Test, idc_set_marker _CtlInfo

%BEGIN MapCtrl Test, idc_save_data _CtlInfo
  dlg_mapctrl_test_eh(_Win,e_Control(idc_save_data,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	CtrlWin = win_GetCtlHandle(_Win,idc_mapctrl),
	FileName = dlg_GetSaveFileName("*.dat",["Map data files","*.dat"],"Save Map data as..."),
	not(FileName = ""),
	mapctrl_SaveData(CtrlWin,Filename),
	!.
%END MapCtrl Test, idc_save_data _CtlInfo

%BEGIN MapCtrl Test, e_Create
  dlg_mapctrl_test_eh(_Win,e_Create(_),0):-!,
	MapCtrlWin = win_GetCtlHandle(_Win,idc_mapctrl),
	win_SetFocus(MapCtrlWin).
%END MapCtrl Test, e_Create

  dlg_mapctrl_test_eh(_,_,_):-!,fail.

%END_DLG MapCtrl Test

/**************************************************************************
	MapCtrl class event handler
**************************************************************************/
database - active_mapctrls
  active_mapctrl(WINDOW)

predicates
  mapctrl_eh  : EHANDLER

clauses
  mapctrl_eh(Win,e_Create(_),0):-
	retract(mode(1)),!,			% Create map control with dynamic data in view mode
	mapctrl_Init(Win,color_Cyan,
		data([
		      polygon_bg([pnt(20,20),pnt(120,32),pnt(140,96),pnt(35,160)],pen(2,ps_Solid,color_Blue),brush(pat_Solid,color_Yellow)),
		      polygon_bg([pnt(170,66),pnt(250,30),pnt(300,200),pnt(150,220)],pen(3,ps_Solid,color_Black),brush(pat_Solid,color_White)),
		      polyline_bg([pnt(33,33),pnt(48,90),pnt(116,211),pnt(288,137)],pen(6,ps_Solid,color_Green)),
		      circle_bg(pnt(80,80),20,pen(2,ps_Solid,color_Red),brush(pat_Solid,color_LtGray)),
		      circle_bg(pnt(320,207),30,pen(2,ps_Solid,color_Green),brush(pat_Solid,color_Yellow)),
		      text_bg(pnt(190,110),"Copenhagen",ff_Helvetica,[fs_Italic,fs_Bold],12,color_Blue),
		      bitmap_bg(pnt(38,148),"Hus.bmp",rop_SrcCopy),
		      bitmap_bg(pnt(208,38),"Hus.bmp",rop_SrcCopy)
		      ],
		     [
		      polygon(777,pnt(470,270),[pnt(-10,-20),pnt(-18,48),pnt(30,-26),pnt(40,70)],pen(2,0,16711680),brush(2,65535),nolabel),
		      polygon(778,pnt(110,220),[pnt(-10,-20),pnt(-18,48),pnt(30,-26),pnt(40,70)],pen(2,0,16711680),brush(2,65535),nolabel),
		      polygon(779,pnt(270,27),[pnt(-10,-20),pnt(-18,48),pnt(30,-26),pnt(40,70)],pen(2,0,16711680),brush(2,65535),nolabel),
		      circle(780,pnt(170,55),36,pen(2,0,16711680),brush(2,65535),nolabel),
		      circle(781,pnt(300,300),20,pen(2,0,16711680),brush(2,65535),nolabel),
		      bitmap(782,pnt(450,100),"Silo.bmp",12,label(pnt(30,5),"New SILO",4,[1],11,16711680)),
		      bitmap(783,pnt(50,300),"Silo.bmp",12,label(pnt(30,5),"Old SILO",4,[1],11,16711680)),
		      arrow(784,pnt(446,90),pnt(446,312),pen(3,ps_Solid,color_Black),nolabel),
		      arrow(785,pnt(211,101),pnt(10,312),pen(3,ps_Solid,color_Black),nolabel),
		      arrow(786,pnt(246,190),pnt(426,190),pen(3,ps_Solid,color_Black),nolabel)
		      ]),
		view([txt(901,"Action1",0,b_true,mis_None,[]),
		      txt(902,"Action2",0,b_true,mis_None,[]),
		      txt(903,"Action3",0,b_true,mis_None,[])]),mapscale(pnt(0,0),1.0),mapctrl_callback).
  mapctrl_eh(Win,e_Create(_),0):-
	retract(mode(2)),			% Create map control with data from file in view mode
	FileName = dlg_GetOpenFileName("*.dat",["Map data files","*.dat"],"Select map data source file:"),
	not(Filename = ""),!,
	mapctrl_Init(Win,color_Cyan,
		filename(Filename),
		view([txt(901,"Action1",0,b_true,mis_None,[]),
		      txt(902,"Action2",0,b_true,mis_None,[]),
		      txt(903,"Action3",0,b_true,mis_None,[])]),mapscale(pnt(0,0),40.0),mapctrl_callback).

  mapctrl_eh(Win,e_Create(_),0):-
	retract(mode(3)),			% Create map control with data from file in edit mode
	FileName = dlg_GetOpenFileName("*.dat",["Map data files","*.dat"],"Select map data source file:"),
	not(Filename = ""),!,
	mapctrl_Init(Win,color_Cyan,
		filename(Filename),
		edit(),mapscale(pnt(0,0),40.0),mapctrl_callback).
  mapctrl_eh(Win,e_Create(_),0):-		% Cancel button is pressed in GetOpenFileName dialog.
	win_PostEvent(Win,e_User(destroy_message,0)),!.

  mapctrl_eh(Win,e_User(destroy_message,_),0):-!,		% Cancel button is pressed in GetOpenFileName dialog.
	DlgWin = win_GetParent(Win),
	win_Destroy(DlgWin).

  mapctrl_eh(Win,Event,0):-
	mapctrl_HandleEvent(Win,Event).

/**************************************************************************
	MapCtrl callback function
**************************************************************************/
predicates
  mapctrl_callback : MAPCTRL_CALLBACK

clauses

  mapctrl_callback(_Win,Event):-
	term_str(mapctrl_event,Event,_Str),
%	write("Callback: ",_Str,"\n"),
	fail.

%BEGIN_WIN Map
/**************************************************************************
        Creation and event handling for window: Map
**************************************************************************/

constants
%BEGIN Map, CreateParms, 13:16:08-24.11.1999, Code automatically updated!
  win_map_WinType = w_TopLevel
  win_map_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings]
  win_map_RCT = rct(30,30,460,460)
  win_map_Menu = no_menu
  win_map_Title = "Map"
  win_map_Help = idh_contents
%END Map, CreateParms

predicates

  win_map_eh : EHANDLER

clauses

  win_map_Create(_Parent,Title):-
	win_Create(win_map_WinType,win_map_RCT,Title,
		   win_map_Menu,_Parent,win_map_Flags,win_map_eh,0).

%BEGIN Map, e_Create
  win_map_eh(_Win,e_Create(_),0):-!,
%BEGIN Map, InitControls, 13:16:08-24.11.1999, Code automatically updated!
%END Map, InitControls
%BEGIN Map, ToolbarCreate, 13:16:08-24.11.1999, Code automatically updated!
%END Map, ToolbarCreate
	WDEF = wdef(wc_Custom,rct(0,0,400,400),"",u_Pixels),
	MapW = win_CreateDynControl([customctl(WDEF,"mapctrl",mvctrl_id,[])],_Win),
	win_SetFocus(MapW),
	!.
%END Map, e_Create
%MARK Map, new events

%BEGIN Map, e_Size
  win_map_eh(_Win,e_Size(Width,Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	trap(MapCtrlWin = win_GetCtlHandle(_Win,mvctrl_id),_,fail),
	win_Move(MapCtrlWin,rct(0,0,Width,Height)),
	!.
%END Map, e_Size

%BEGIN Map, e_Menu, Parent window 
  win_map_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Map, e_Menu, Parent window

%END_WIN Map



