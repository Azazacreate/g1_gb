/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  SPLITWIN
 FileName: SPLITWIN.PRO
 Purpose: Test for Split Window tool
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "splitwin.inc"
include "splitwin.con"
include "hlptopic.con"

include "splitwin\\split.pre"	% Top level tool

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER
procedure  create_WinsInSplit(WINDOW)

CONSTANTS

%BEGIN Task Window, CreateParms, 14:16:00-19.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "SplitWin"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

DATABASE - splitwinTest_db
  split_Window_Info(WINDOW SplitWin)
  test_pict(PICTURE Picture)
  test_data(LONG ID)

%*******************************************************
% Handle events from split Callback
% if split_Create predicate was used for creation
%*******************************************************
PREDICATES
  splitCallback : split_events_cb

CLAUSES

% Retract window on destroy split window, created by split_Create global predicate
  splitCallback(SplitWin, e_Destroy(), 0):-
	retractAll(split_Window_Info(SplitWin)),
	fail.

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 14:16:00-19.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 14:16:00-19.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	PICT = pict_Load("pdc.bmp"),
	assert(test_pict(PICT)),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_createinwindow
  task_win_eh(Win,e_Menu(id_file_createinwindow,_ShiftCtlAlt),0):-!,
	dlg_splitdialog_Create(Win).
%END Task Window, id_file_createinwindow

%BEGIN Task Window, id_Edit_setrowheight
  task_win_eh(Win,e_Menu(id_Edit_setrowheight,_ShiftCtlAlt),0):-!,
	dlg_set2_Create(Win,id_Edit_setrowheight).
%END Task Window, id_Edit_setrowheight

%BEGIN Task Window, id_Edit_setresizebarcolor
  task_win_eh(_Win,e_Menu(id_Edit_setresizebarcolor,_ShiftCtlAlt),0):-
	split_Window_Info(SplitWin),
	trap(split_GetResizeBarColor(SplitWin,OldResizeBarColor),_,fail),
	NewResizeBarColor = dlg_ChooseColor(OldResizeBarColor),
	trap(split_SetResizeBarColor(SplitWin,NewResizeBarColor),_,fail),
	!.
%END Task Window, id_Edit_setresizebarcolor

%BEGIN Task Window, id_Edit_setstyle
  task_win_eh(Win,e_Menu(id_Edit_setstyle,_ShiftCtlAlt),0):-!,
	dlg_style_Create(Win).
%END Task Window, id_Edit_setstyle

%BEGIN Task Window, id_Edit_getrowheight
  task_win_eh(Win,e_Menu(id_Edit_getrowheight,_ShiftCtlAlt),0):-!,
	dlg_set1_Create(Win,id_Edit_getrowheight).
%END Task Window, id_Edit_getrowheight

%BEGIN Task Window, id_Edit_getresizebarcolor
  task_win_eh(_Win,e_Menu(id_Edit_getresizebarcolor,_ShiftCtlAlt),0):-
	split_Window_Info(SplitWin),
	trap(split_GetResizeBarColor(SplitWin,ResizeBarColor),_,fail),!,
	write("GetResizeBarColor, ResizeBarColor=",ResizeBarColor),nl.
%END Task Window, id_Edit_getresizebarcolor

%BEGIN Task Window, id_Edit_getpanecoordinate
  task_win_eh(Win,e_Menu(id_Edit_getpanecoordinate,_ShiftCtlAlt),0):-!,
	dlg_set2_Create(Win,id_Edit_getpanecoordinate).
%END Task Window, id_Edit_getpanecoordinate

%BEGIN Task Window, id_Edit_setpane
  task_win_eh(Win,e_Menu(id_Edit_setpane,_ShiftCtlAlt),0):-!,
	dlg_set2_Create(Win,id_Edit_setpane).
%END Task Window, id_Edit_setpane

%BEGIN Task Window, id_Edit_insertrowat
  task_win_eh(Win,e_Menu(id_Edit_insertrowat,_ShiftCtlAlt),0):-!,
	dlg_set2_Create(Win,id_Edit_insertrowat).
%END Task Window, id_Edit_insertrowat

%BEGIN Task Window, id_Edit_insertcolumnat
  task_win_eh(Win,e_Menu(id_Edit_insertcolumnat,_ShiftCtlAlt),0):-!,
	dlg_set2_Create(Win,id_Edit_insertcolumnat).
%END Task Window, id_Edit_insertcolumnat

%BEGIN Task Window, id_Edit_deleterow
  task_win_eh(Win,e_Menu(id_Edit_deleterow,_ShiftCtlAlt),0):-!,
	dlg_set1_Create(Win,id_Edit_deleterow).
%END Task Window, id_Edit_deleterow

%BEGIN Task Window, id_Edit_deletecolumn
  task_win_eh(Win,e_Menu(id_Edit_deletecolumn,_ShiftCtlAlt),0):-!,
	dlg_set1_Create(Win,id_Edit_deletecolumn).
%END Task Window, id_Edit_deletecolumn

%BEGIN Task Window, id_Edit_clearpane
  task_win_eh(Win,e_Menu(id_Edit_clearpane,_ShiftCtlAlt),0):-!,
	dlg_set2_Create(Win,id_Edit_clearpane).
%END Task Window, id_Edit_clearpane

%BEGIN Task Window, id_Edit_setresizebarwidth
  task_win_eh(Win,e_Menu(id_Edit_setresizebarwidth,_ShiftCtlAlt),0):-!,
	dlg_set1_Create(Win,id_Edit_setresizebarwidth).
%END Task Window, id_Edit_setresizebarwidth

%BEGIN Task Window, id_Edit_getresizebarwidth
  task_win_eh(_Win,e_Menu(id_Edit_getresizebarwidth,_ShiftCtlAlt),0):-
	split_Window_Info(SplitWin),
	trap(split_GetResizeBarWidth(SplitWin,ResizeBarWidth),_,fail),!,
	write("GetResizeBarWidth, ResizeBarWidth=",ResizeBarWidth),nl.
%END Task Window, id_Edit_getresizebarwidth

%BEGIN Task Window, id_Edit_setmarginwidth
  task_win_eh(Win,e_Menu(id_Edit_setmarginwidth,_ShiftCtlAlt),0):-!,
	dlg_set1_Create(Win,id_Edit_setmarginwidth).
%END Task Window, id_Edit_setmarginwidth

%BEGIN Task Window, id_Edit_setcolumnwidth
  task_win_eh(Win,e_Menu(id_Edit_setcolumnwidth,_ShiftCtlAlt),0):-!,
	dlg_set2_Create(Win,id_Edit_setcolumnwidth).
%END Task Window, id_Edit_setcolumnwidth

%BEGIN Task Window, id_Edit_getcolumnwidth
  task_win_eh(Win,e_Menu(id_Edit_getcolumnwidth,_ShiftCtlAlt),0):-!,
	dlg_set1_Create(Win,id_Edit_getcolumnwidth).
%END Task Window, id_Edit_getcolumnwidth

%BEGIN Task Window, id_Edit_getmarginwidth
  task_win_eh(_Win,e_Menu(id_Edit_getmarginwidth,_ShiftCtlAlt),0):-
	split_Window_Info(SplitWin),
	trap(split_GetMarginWidth(SplitWin,WidthInPixels),_,fail),!,
	write("GetMarginWidth, WidthInPixels=",WidthInPixels),nl.
%END Task Window, id_Edit_getmarginwidth

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	retract(test_pict(Pict)),
	pict_Destroy(Pict),
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest,0):-!,
	win_Destroy(_Win),
	!.
%END Task Window, e_CloseRequest

%BEGIN Task Window, id_file_new
  task_win_eh(ParentWindow,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	WinType = w_TopLevel,
	Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_Invisible],
	Rectangle = rct(100,80,529,277),
	Title = "Split",
	Columns = 3,
	Rows = 3,
	SplitWin = split_Create(WinType,Rectangle,Title,no_menu,ParentWindow,Flags,splitCallback,Columns,Rows),
  	create_WinsInSplit(SplitWin),
	split_Show(SplitWin),
	assert(split_Window_Info(SplitWin)).
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("splitwin.hlp"),
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
  	vpi_ShowHelpContext("splitwin.hlp",HelpTopic).

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF ws_win
  IFDEF use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  ENDDEF
ENDDEF  
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"splitwin",task_win_Title).

%BEGIN_TLB Project toolbar, 17:13:56-19.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"Split;Create Split window",1,1),
		 tb_ctrl(id_file_createinwindow,pushb,idb_open_up,idb_open_dn,idb_open_up,"Split Dialog;Create in window",1,1),
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






%BEGIN_TLB Help line, 14:16:58-19.11.1999, Code automatically updated!
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

%BEGIN About dialog, CreateParms, 14:39:22-19.11.1999, Code automatically updated!
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

%========== Create pane windows in Split window =========
PREDICATES
procedure  WINDOW  createWinInSplit(WINDOW SplitWin)
CLAUSES
  createWinInSplit(SplitWin,PaneWin):-
	WinType = w_Child,
	Flags = [wsf_ClipSiblings],
	Rct = rct(0,0,0,0),
	Title = "",
	PaneWin = win_Create(WinType,Rct,Title,no_menu,SplitWin,Flags,wins_InSplit_eh,0).	

PREDICATES
  wins_InSplit_eh : EHANDLER
CLAUSES
% Create and init 9 panes in split window
  create_WinsInSplit(SplitWin):-

	SplitWin1 = createWinInSplit(SplitWin),
	SplitWin2 = createWinInSplit(SplitWin),
	SplitWin3 = createWinInSplit(SplitWin),
	SplitWin4 = createWinInSplit(SplitWin),
	SplitWin5 = createWinInSplit(SplitWin),
	SplitWin6 = createWinInSplit(SplitWin),
	SplitWin7 = createWinInSplit(SplitWin),
	SplitWin8 = createWinInSplit(SplitWin),
	SplitWin9 = createWinInSplit(SplitWin),


	split_SetPane(SplitWin,0,0,SplitWin1),
	split_SetPane(SplitWin,1,0,SplitWin2),
	split_SetPane(SplitWin,2,0,SplitWin3),
	split_SetPane(SplitWin,0,1,SplitWin4),
	split_SetPane(SplitWin,1,1,SplitWin5),
	split_SetPane(SplitWin,2,1,SplitWin6),
	split_SetPane(SplitWin,0,2,SplitWin7),
	split_SetPane(SplitWin,1,2,SplitWin8),
	split_SetPane(SplitWin,2,2,SplitWin9).

% Draw picture in pane
PREDICATES
procedure  drawPDCPicture(WINDOW Win)

CLAUSES
  drawPDCPicture(Win):-
	test_pict(Pict),
	!,
	pict_GetSize(Pict,Width,Height,_ImageSize),
	SourceRCT = rct(0,0,Width,Height),
	DestRCT =win_GetClientRect(Win),
	pict_Draw(Win,Pict,DestRCT,SourceRCT,rop_SrcCopy).
  drawPDCPicture(_Win):-errorexit().


%========== Pane handling =========
  wins_InSplit_eh(Win,e_Update(_UpdateRct),0):-!,
        drawPDCPicture(Win),
	fail.

  wins_InSplit_eh(_Win, e_EraseBackground(), 0):-!.

  wins_InSplit_eh(Win,e_Size(_,_),0):-!,
        drawPDCPicture(Win),
	fail.

/*************************************************************************
	 Predicates for Set1 dialog
**************************************************************************/
PREDICATES
procedure  dialog1_CreateSet(WINDOW,LONG)
CLAUSES

  dialog1_CreateSet(Win,id_Edit_getcolumnwidth):-!,
	win_SetText(Win,"GetColumnWidth"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Column"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0")
	.
  dialog1_CreateSet(Win,id_Edit_setmarginwidth):-!,
	win_SetText(Win,"SetMarginWidth"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Width"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"1")
	.
  dialog1_CreateSet(Win,id_Edit_setresizebarwidth):-!,
	win_SetText(Win,"SetResizeBarWidth"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Width"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"6")
	.
  dialog1_CreateSet(Win,id_Edit_deletecolumn):-!,
	win_SetText(Win,"DeleteColumn"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Column"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0")
	.
  dialog1_CreateSet(Win,id_Edit_deleterow):-!,
	win_SetText(Win,"DeleteRow"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Row"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0")
	.
  dialog1_CreateSet(Win,id_Edit_getrowheight):-!,
	win_SetText(Win,"GetRowHeight"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Row"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0")
	.
  dialog1_CreateSet(_Win,_):-errorexit().



PREDICATES
determ  get_Param1(WINDOW Win,LONG LP)
CLAUSES

  get_Param1(Win,LP):-
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	EdText1 = win_GetText(EdWin1),
	trap(term_str(LONG,LP,EdText1),_,fail).

PREDICATES
determ  dialog1_HandleSet(WINDOW)
CLAUSES
  
  dialog1_HandleSet(Win):-
	test_data(id_Edit_getcolumnwidth),
	get_Param1(Win,Column),
	split_Window_Info(SplitWin),
	trap(split_GetColumnWidth(SplitWin,Column,Width),_,fail),
	write("GetColumnWidth, Width=",Width),nl,
	!,fail.
  dialog1_HandleSet(Win):-
	test_data(id_Edit_setmarginwidth),
	get_Param1(Win,Width),
	split_Window_Info(SplitWin),
	trap(split_SetMarginWidth(SplitWin,Width),_,fail),
	!,fail.
  dialog1_HandleSet(Win):-
	test_data(id_Edit_setresizebarwidth),
	get_Param1(Win,Width),
	split_Window_Info(SplitWin),
	trap(split_SetResizeBarWidth(SplitWin,Width),_,fail),
	!,fail.
  dialog1_HandleSet(Win):-
	test_data(id_Edit_deletecolumn),
	get_Param1(Win,Column),
	split_Window_Info(SplitWin),
	trap(split_DeleteColumn(SplitWin,Column),_,fail),
	!,fail.
  dialog1_HandleSet(Win):-
	test_data(id_Edit_deleterow),
	get_Param1(Win,Row),
	split_Window_Info(SplitWin),
	trap(split_DeleteRow(SplitWin,Row),_,fail),
	!,fail.
  dialog1_HandleSet(Win):-
	test_data(id_Edit_getrowheight),
	get_Param1(Win,Row),
	split_Window_Info(SplitWin),
	trap(split_GetRowHeight(SplitWin,Row,Height),_,fail),
	write("GetRowHeight, Height=",Height),nl,
	!,fail.
  dialog1_HandleSet(_Win):-
	dlg_Note("Illegal parameter value !.").


%BEGIN_DLG Set1
/**************************************************************************
	Creation and event handling for dialog: Set1
**************************************************************************/

CONSTANTS

%BEGIN Set1, CreateParms, 16:07:09-18.11.1998, Code automatically updated!
  dlg_set1_ResID = idd_set1
  dlg_set1_DlgType = wd_Modal
  dlg_set1_Help = idh_contents
%END Set1, CreateParms

PREDICATES

  dlg_set1_eh : EHANDLER
  dlg_set1_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_set1_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_set1_Create(Parent,MenuId):-

%MARK Set1, new variables

	dialog_CreateModal(Parent,dlg_set1_ResID,"",
  		[
%BEGIN Set1, ControlList, 16:07:09-18.11.1998, Code automatically updated!
		df(idc_e1,editstr("",[]),nopr)
%END Set1, ControlList
		],
		dlg_set1_eh,MenuId,VALLIST,ANSWER),
	dlg_set1_handle_answer(ANSWER,VALLIST).

  dlg_set1_handle_answer(idc_ok,VALLIST):-!,
	dlg_set1_update(VALLIST).
  dlg_set1_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_set1_handle_answer(_,_):-
	errorexit().

  dlg_set1_update(_VALLIST):-
%BEGIN Set1, Update controls, 16:07:09-18.11.1998, Code automatically updated!
	_IDC_E1_VALUE = dialog_VLGetstr(idc_e1,_VALLIST),
%END Set1, Update controls
	true.

%MARK Set1, new events

%BEGIN Set1, idc_ok _CtlInfo
  dlg_set1_eh(Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dialog1_HandleSet(Win).
%END Set1, idc_ok _CtlInfo

%BEGIN Set1, e_Destroy
  dlg_set1_eh(_Win,e_Destroy,0):-!,
	retractAll(test_data(_)),
	fail.
%END Set1, e_Destroy

%BEGIN Set1, e_Create
  dlg_set1_eh(Win,e_Create(MenuId),0):-!,
	assert(test_data(MenuId)),
	dialog1_CreateSet(Win,MenuId),
	fail.
%END Set1, e_Create

  dlg_set1_eh(_,_,_):-!,fail.

%END_DLG Set1

/*************************************************************************
	 Predicates for Set2 dialog
**************************************************************************/
PREDICATES
procedure  dialog2_CreateSet(WINDOW,LONG)
CLAUSES

  dialog2_CreateSet(Win,id_Edit_setrowheight):-!,
	win_SetText(Win,"SetRowHeight"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Row"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0"),
	TextWin2 = win_GetCtlHandle(Win,idct_t2),
	win_SetText(TextWin2,"Height"),
	EdWin2 = win_GetCtlHandle(Win,idc_e2),
	win_SetText(EdWin2,"50")
	.
  dialog2_CreateSet(Win,id_Edit_setcolumnwidth):-!,
	win_SetText(Win,"SetColumnWidth"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Column"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0"),
	TextWin2 = win_GetCtlHandle(Win,idct_t2),
	win_SetText(TextWin2,"Width"),
	EdWin2 = win_GetCtlHandle(Win,idc_e2),
	win_SetText(EdWin2,"50")
	.
  dialog2_CreateSet(Win,id_Edit_clearpane):-!,
	win_SetText(Win,"ClearPane"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Column"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0"),
	TextWin2 = win_GetCtlHandle(Win,idct_t2),
	win_SetText(TextWin2,"Row"),
	EdWin2 = win_GetCtlHandle(Win,idc_e2),
	win_SetText(EdWin2,"0")
	.
  dialog2_CreateSet(Win,id_Edit_insertcolumnat):-!,
	win_SetText(Win,"InsertColumnAt"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Column"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0"),
	TextWin2 = win_GetCtlHandle(Win,idct_t2),
	win_SetText(TextWin2,"Width"),
	EdWin2 = win_GetCtlHandle(Win,idc_e2),
	win_SetText(EdWin2,"10")
	.
  dialog2_CreateSet(Win,id_Edit_insertrowat):-!,
	win_SetText(Win,"InsertRowAt"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Row"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0"),
	TextWin2 = win_GetCtlHandle(Win,idct_t2),
	win_SetText(TextWin2,"Height"),
	EdWin2 = win_GetCtlHandle(Win,idc_e2),
	win_SetText(EdWin2,"10")
	.
  dialog2_CreateSet(Win,id_Edit_setpane):-!,
	win_SetText(Win,"SetPane"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Column"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0"),
	TextWin2 = win_GetCtlHandle(Win,idct_t2),
	win_SetText(TextWin2,"Row"),
	EdWin2 = win_GetCtlHandle(Win,idc_e2),
	win_SetText(EdWin2,"0")
	.
  dialog2_CreateSet(Win,id_Edit_getpanecoordinate):-!,
	win_SetText(Win,"GetPaneCoordinate"),
	TextWin1 = win_GetCtlHandle(Win,idct_t1),
	win_SetText(TextWin1,"Column"),
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	win_SetText(EdWin1,"0"),
	TextWin2 = win_GetCtlHandle(Win,idct_t2),
	win_SetText(TextWin2,"Row"),
	EdWin2 = win_GetCtlHandle(Win,idc_e2),
	win_SetText(EdWin2,"0")
	.
  dialog2_CreateSet(_Win,_):-errorexit().



PREDICATES
determ  get_Param2(WINDOW Win,LONG Lp1,LONG Lp2)
CLAUSES

  get_Param2(Win,Lp1,Lp2):-
	EdWin1 = win_GetCtlHandle(Win,idc_e1),
	EdText1 = win_GetText(EdWin1),
	EdWin2 = win_GetCtlHandle(Win,idc_e2),
	EdText2 = win_GetText(EdWin2),
	trap(term_str(LONG,Lp1,EdText1),_,fail),
	trap(term_str(LONG,Lp2,EdText2),_,fail).

PREDICATES
procedure clear_Window(WINDOW)
CLAUSES
  clear_Window(Win):- trap(win_Destroy(Win),_,fail),!.
  clear_Window(_).

PREDICATES
determ  dialog2_HandleSet(WINDOW)
CLAUSES

  dialog2_HandleSet(Win):-
	test_data(id_Edit_setrowheight),
	get_Param2(Win,Row,Height),
	split_Window_Info(SplitWin),
	trap(split_SetRowHeight(SplitWin,Row,Height),_,fail),
	!,fail.
  dialog2_HandleSet(Win):-
	test_data(id_Edit_setcolumnwidth),
	get_Param2(Win,Column,Width),
	split_Window_Info(SplitWin),
	trap(split_SetColumnWidth(SplitWin,Column,Width),_,fail),
	!,fail.
  dialog2_HandleSet(Win):-
	test_data(id_Edit_clearpane),
	get_Param2(Win,Column,Row),
	split_Window_Info(SplitWin),
	trap(ClearWin = split_ClearPane(SplitWin,Column,Row),_,fail),
	clear_Window(ClearWin),
	write("ClearPane, ClearWindow=",ClearWin),nl,
	!,fail.
  dialog2_HandleSet(Win):-
	test_data(id_Edit_insertcolumnat),
	get_Param2(Win,Column,Width),
	split_Window_Info(SplitWin),
	trap(split_InsertColumnAt(SplitWin,Column,Width),_,fail),
	!,
	dlg_Note("After addition of a column it is necessary to set Panes in the added column."),
	fail.
  dialog2_HandleSet(Win):-
	test_data(id_Edit_insertrowat),
	get_Param2(Win,Row,Height),
	split_Window_Info(SplitWin),
	trap(split_InsertRowAt(SplitWin,Row,Height),_,fail),
	!,
	dlg_Note("After addition of a row it is necessary to set Panes in the added row."),
	fail.
  dialog2_HandleSet(Win):-
	test_data(id_Edit_setpane),
	get_Param2(Win,Column,Row),
	split_Window_Info(SplitWin),
	NewPaneWin = createWinInSplit(SplitWin),
	trap(OldWin = split_SetPane(SplitWin,Column,Row,NewPaneWin),_,fail),
	!,
	write("SetPane, Old Window=",OldWin),nl,
	trap(win_Destroy(OldWin),_,fail),
	fail.
  dialog2_HandleSet(Win):-
	test_data(id_Edit_getpanecoordinate),
	get_Param2(Win,Column,Row),
	split_Window_Info(SplitWin),
	PaneWin = split_GetPane(SplitWin,Column,Row),
	trap(Pnt = split_GetPaneCoordinate(SplitWin,PaneWin),_,fail),
	!,
	write("GetPaneCoordinate, Pnt=",Pnt),nl,
	fail.
  dialog2_HandleSet(Win):-
	test_data(id_Edit_getpanecoordinate),
	get_Param2(Win,Column,Row),
	!,
	format(S,"GetPaneCoordinate, No Pane in Column=%, Row=%",Column,Row),
	write(S),nl,
	fail.
  dialog2_HandleSet(_Win):-
	dlg_Note("Illegal parameter value !.").

%BEGIN_DLG Set2
/**************************************************************************
	Creation and event handling for dialog: Set2
**************************************************************************/

CONSTANTS

%BEGIN Set2, CreateParms, 12:17:42-19.11.1998, Code automatically updated!
  dlg_set2_ResID = idd_set2
  dlg_set2_DlgType = wd_Modal
  dlg_set2_Help = idh_contents
%END Set2, CreateParms

PREDICATES

  dlg_set2_eh : EHANDLER
  dlg_set2_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_set2_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_set2_Create(Parent,MenuId):-

%MARK Set2, new variables

	dialog_CreateModal(Parent,dlg_set2_ResID,"",
  		[
%BEGIN Set2, ControlList, 12:17:42-19.11.1998, Code automatically updated!
		df(idc_e1,editstr("",[]),nopr),
		df(idc_e2,editstr("",[]),nopr)
%END Set2, ControlList
		],
		dlg_set2_eh,MenuId,VALLIST,ANSWER),
	dlg_set2_handle_answer(ANSWER,VALLIST).

  dlg_set2_handle_answer(idc_ok,VALLIST):-!,
	dlg_set2_update(VALLIST).
  dlg_set2_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_set2_handle_answer(_,_):-
	errorexit().

  dlg_set2_update(_VALLIST):-
%BEGIN Set2, Update controls, 12:17:42-19.11.1998, Code automatically updated!
	_IDC_E1_VALUE = dialog_VLGetstr(idc_e1,_VALLIST),
	_IDC_E2_VALUE = dialog_VLGetstr(idc_e2,_VALLIST),
%END Set2, Update controls
	true.

%MARK Set2, new events

%BEGIN Set2, e_Destroy
  dlg_set2_eh(_Win,e_Destroy,0):-!,
	retractAll(test_data(_)),
	fail.
%END Set2, e_Destroy

%BEGIN Set2, e_Create
  dlg_set2_eh(Win,e_Create(MenuId),0):-!,
	assert(test_data(MenuId)),
	dialog2_CreateSet(Win,MenuId),
	fail.
%END Set2, e_Create

%BEGIN Set2, idc_ok _CtlInfo
  dlg_set2_eh(Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dialog2_HandleSet(Win).
%END Set2, idc_ok _CtlInfo
%END_DLG Set2

%BEGIN_DLG style
/**************************************************************************
	Creation and event handling for dialog: style
**************************************************************************/

CONSTANTS

%BEGIN style, CreateParms, 17:42:32-11.12.1998, Code automatically updated!
  dlg_style_ResID = idd_style
  dlg_style_DlgType = wd_Modal
  dlg_style_Help = idh_contents
%END style, CreateParms

PREDICATES

  dlg_style_eh : EHANDLER
  dlg_style_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_style_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_style_Create(Parent):-

%MARK style, new variables

	dialog_CreateModal(Parent,dlg_style_ResID,"",
  		[
%BEGIN style, ControlList, 17:42:32-11.12.1998, Code automatically updated!
		df(idc_style_1,listbutton([],0),nopr)
%END style, ControlList
		],
		dlg_style_eh,0,VALLIST,ANSWER),
	dlg_style_handle_answer(ANSWER,VALLIST).

  dlg_style_handle_answer(idc_ok,VALLIST):-!,
	dlg_style_update(VALLIST).
  dlg_style_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_style_handle_answer(_,_):-
	errorexit().

  dlg_style_update(_VALLIST):-
%BEGIN style, Update controls, 17:42:32-11.12.1998, Code automatically updated!
	dialog_VLGetListButton(idc_style_1,_VALLIST,_IDC_STYLE_1_ITEMLIST,_IDC_STYLE_1_SELECT),
%END style, Update controls
	true.

%MARK style, new events

%BEGIN style, idc_ok _CtlInfo
  dlg_style_eh(Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	CtrlWin = win_GetCtlHandle(Win,idc_style_1),
	lbox_GetSel(CtrlWin,Sel,_),
	Sel = [StrStyle],
	term_str(split_style,TermStyle,StrStyle),
	split_Window_Info(SplitWin),
	trap(split_SetStyle(SplitWin,TermStyle),_,fail),
	!,fail.
%END style, idc_ok _CtlInfo

%BEGIN style, e_Create
  dlg_style_eh(Win,e_Create(_CreationData),0):-!,
	CtrlWin = win_GetCtlHandle(Win,idc_style_1),
	lbox_Add(CtrlWin,["split_style_3d","split_style_2d"]),
	lbox_SetSel(CtrlWin,0,b_true),
	!.
%END style, e_Create

  dlg_style_eh(_,_,_):-!,fail.

%END_DLG style

%BEGIN_DLG SplitDialog
/**************************************************************************
	Creation and event handling for dialog.
**************************************************************************/

CONSTANTS

%BEGIN SplitDialog, CreateParms, 14:14:36-19.11.1999, Code automatically updated!
  dlg_splitdialog_ResID = idd_splitdialog
  dlg_splitdialog_DlgType = wd_Modeless
  dlg_splitdialog_Help = idh_contents
%END SplitDialog, CreateParms

PREDICATES

  dlg_splitdialog_eh : EHANDLER
  dlg_splitdialog_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_splitdialog_Create(Parent):-

%MARK SplitDialog, new variables

	dialog_CreateModeless(Parent,dlg_splitdialog_ResID,"",
  		[
%BEGIN SplitDialog, ControlList, 14:14:36-19.11.1999, Code automatically updated!
%END SplitDialog, ControlList
		],
		dlg_splitdialog_eh,0).

  dlg_splitdialog_update(_VALLIST):-
%BEGIN SplitDialog, Update controls, 14:14:36-19.11.1999, Code automatically updated!
%END SplitDialog, Update controls
	true.

%BEGIN SplitDialog, idc_ok _CtlInfo
  dlg_splitdialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	VALLIST = dialog_GetValues(_Win),
	dlg_splitdialog_update(VALLIST),
	fail.
%END SplitDialog, idc_ok _CtlInfo
%MARK SplitDialog, new events

%BEGIN SplitDialog, e_Create
  dlg_splitdialog_eh(Win,e_Create(_CreationData),0):-!,
	win_splitindialog_Create(Win),
	fail.
%END SplitDialog, e_Create

  dlg_splitdialog_eh(_,_,_):-!,fail.

%END_DLG SplitDialog


%BEGIN_WIN splitInDialog
/**************************************************************************

      Split window creation,
      event handling and initialization by split_CreateInWindow predicate

**************************************************************************/

CONSTANTS
%BEGIN splitInDialog, CreateParms, 14:15:34-19.11.1999, Code automatically updated!
  win_splitindialog_WinType = w_Child
  win_splitindialog_Flags = [wsf_Border,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings,wsf_Invisible]
  win_splitindialog_RCT = rct(100,80,440,240)
  win_splitindialog_Menu = no_menu
  win_splitindialog_Title = "splitInDialog"
  win_splitindialog_Help = idh_contents
%END splitInDialog, CreateParms

PREDICATES

  win_splitindialog_eh : EHANDLER

CLAUSES
%*************************************************************
% Split window creation
%*************************************************************
  win_splitindialog_Create(DlgWin):-
	ParentRct = win_GetClientRect(DlgWin),
	ParentRct = rct(_,_,X,Y),
	X1 = X - 100,
	SplitRct = rct(0,0,X1,Y),
	Flags = [wsf_ClipSiblings,wsf_Invisible],
	win_Create(win_splitindialog_WinType,SplitRct,win_splitindialog_Title,
		   win_splitindialog_Menu,DlgWin,Flags,win_splitindialog_eh,0).

%*************************************************************
% Initialization on e_Create by split_CreateInWindow predicate
%*************************************************************
%BEGIN splitInDialog, e_Create
  win_splitindialog_eh(SplitWin, e_Create(_),0):-!,
%BEGIN splitInDialog, InitControls, 14:15:34-19.11.1999, Code automatically updated!
%END splitInDialog, InitControls
%BEGIN splitInDialog, ToolbarCreate, 14:15:34-19.11.1999, Code automatically updated!
%END splitInDialog, ToolbarCreate
	Columns = 3, Rows = 3,
	split_CreateInWindow(SplitWin, Columns, Rows),
  	create_WinsInSplit(SplitWin),
	split_Show(SplitWin),
	assert(split_Window_Info(SplitWin)),
	fail.
%END splitInDialog, e_Create
%MARK splitInDialog, new events

%BEGIN splitInDialog, e_Destroy
  win_splitindialog_eh(SplitWin,e_Destroy,0):-!,
	retract(split_Window_Info(SplitWin)),
	fail.
%END splitInDialog, e_Destroy

%BEGIN splitInDialog, e_Size
  win_splitindialog_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	fail.
%END splitInDialog, e_Size

%BEGIN splitInDialog, e_Menu, Parent window 
  win_splitindialog_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	fail.
%END splitInDialog, e_Menu, Parent window

%END_WIN splitInDialog

