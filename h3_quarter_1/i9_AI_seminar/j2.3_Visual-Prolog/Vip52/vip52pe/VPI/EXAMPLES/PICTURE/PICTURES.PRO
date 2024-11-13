/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PICTURES
 FileName: PICTURES.PRO
 Purpose: Demo program for Pictures
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "pictures.inc"
include "pictures.con"
include "hlptopic.con"

GLOBAL PREDICATES
  picture_handler : EHANDLER

DATABASE - db
	get_brush_pattern(PATSTYLE)
	get_rop(ROP)
	
PREDICATES
  draw_background(WINDOW)
CLAUSES
  draw_background(Win):-
	DlgW=win_GetParent(Win),
	BkGrndW = win_GetCtlHandle(DlgW,idc_bkgrnd),
	FileName = win_GetText(BkGrndW),
	FileName <> "",!,
	PICTURE = pict_Load(FileName),
	_RCT = win_GetClientRect(Win),
	pict_GetSize(PICTURE,X,Y,_),
	pict_Draw(Win,PICTURE,_RCT,rct(0,0,X,Y),rop_SrcCopy),
	pict_Destroy(PICTURE).

  draw_background(Win):-
	DlgW=win_GetParent(Win),
	BkGrndW = win_GetCtlHandle(DlgW,idc_bkgrnd),
ifndef os_os2
	win_SetText(BkGrndW,"backgrnd.bmp"),
	PICTURE = pict_Load("backgrnd.bmp"),
elsedef
	win_SetText(BkGrndW,"backgos2.bmp"),
	PICTURE = pict_Load("backgos2.bmp"),
enddef
	_RCT = win_GetClientRect(Win),
	pict_GetSize(PICTURE,X,Y,_),
	pict_Draw(Win,PICTURE,_RCT,rct(0,0,X,Y),rop_SrcCopy),
	pict_Destroy(PICTURE).


PREDICATES
  get_brush(WINDOW,BRUSH)
CLAUSES
  get_brush(Win,brush(PatStyle,Color)):-
	W=win_GetParent(Win),
	ColorW = win_GetCtlHandle(W,idc_brush_color),
	OldVal = win_GetText(ColorW),
	OldVal <> "",
	trap(term_str(long,Color,OldVal),_E,fail),!,
	get_brush_pattern(PatStyle),
	!.
  get_brush(Win,brush(PatStyle,Color)):-
	W=win_GetParent(Win),
	ColorW = win_GetCtlHandle(W,idc_brush_color),
	win_SetText(ColorW,"0xFFFFFF"),
	term_str(long,Color,"0xFFFFFF"),
	get_brush_pattern(PatStyle),
	!.

PREDICATES
  get_bitmap(WINDOW,STRING Filename)
CLAUSES
  get_bitmap(Win,Filename):-
	W=win_GetParent(Win),
	Bitmap = win_GetCtlHandle(W,idc_bitmap),
	FileName = win_GetText(Bitmap),
	FileName <> "",!.

  get_bitmap(Win,Filename):-
	W=win_GetParent(Win),
	Bitmap = win_GetCtlHandle(W,idc_bitmap),
ifndef os_os2
	FileName = "bitmap.bmp",
	win_SetText(Bitmap,"bitmap.bmp").
elsedef
	FileName="bitmaos2.bmp",
	win_SetText(Bitmap,"bitmaos2.bmp").
enddef

PREDICATES
  do_stretch(WINDOW)
CLAUSES
  do_stretch(Win):-
	W=win_GetParent(Win),
	STRW = win_GetCtlHandle(W,idc_stretch_bitmap),
	Checked = win_IsChecked(STRW),
	Checked = checkbox_on.

PREDICATES
	update_picture(WINDOW)
	update_picture(WINDOW,PICTURE,ROP)
	
CLAUSES
  picture_handler(_Win,e_Update(_),0):-!,
	update_picture(_Win),
  	!.

  update_picture(Win):-
	draw_background(Win),
	get_brush(Win,BRUSH),
	win_SetBrush(Win,BRUSH),
	get_bitmap(Win,Filename),
	get_rop(ROP),!,
	PICTURE = pict_Load(FileName),
	update_picture(Win,Picture,ROP),
	pict_Destroy(PICTURE).

  update_picture(Win,Picture,ROP):-
	do_stretch(Win),!,
	_RCT = win_GetClientRect(Win),
	pict_GetSize(PICTURE,X,Y,_),
	pict_Draw(Win,PICTURE,_RCT,rct(0,0,X,Y),ROP).

  update_picture(Win,Picture,ROP):-
	pict_Draw(Win,PICTURE,pnt(0,0),ROP).

PREDICATES
	select_rop(string,ROP)
CLAUSES
  select_rop("rop_Blackness",rop_Blackness).
  select_rop("rop_Whiteness",rop_Whiteness).
  select_rop("rop_DstInvert",rop_DstInvert).
  select_rop("rop_MergeCopy",rop_MergeCopy).
  select_rop("rop_MergePaint",rop_MergePaint).
  select_rop("rop_NotSrcCopy",rop_NotSrcCopy).
  select_rop("rop_NotSrcErase",rop_NotSrcErase).
  select_rop("rop_PatCopy",rop_PatCopy).
  select_rop("rop_PatInvert",rop_PatInvert).
  select_rop("rop_PatPaint",rop_PatPaint).
  select_rop("rop_SrcAnd",rop_SrcAnd).
  select_rop("rop_SrcCopy",rop_SrcCopy).
  select_rop("rop_SrcErase",rop_SrcErase).
  select_rop("rop_SrcInvert",rop_SrcInvert).
  select_rop("rop_SrcPaint",rop_SrcPaint).
  	 
PREDICATES
	select_pattern(string,PATSTYLE)

CLAUSES
  select_pattern("pat_Hollow",pat_Hollow).
  select_pattern("pat_Solid",pat_Solid).
  select_pattern("pat_Horz",pat_Horz).
  select_pattern("pat_Vert",pat_Vert).
  select_pattern("pat_FDiag",pat_FDiag).
  select_pattern("pat_BDiag",pat_BDiag).
  select_pattern("pat_Cross",pat_Cross).
  select_pattern("pat_DiagCross",pat_DiagCross).
  	
%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 21:09:44-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_Invisible]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Pictures"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 21:09:44-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 21:09:44-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	assert(get_brush_pattern(pat_FDiag)),
	assert(get_rop(rop_SrcCopy)),
	class_Create("PICTURE",picture_handler),
	dlg_pictures_Create(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("pictures.hlp"),
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
  	vpi_ShowHelpContext("pictures.hlp",HelpTopic),!.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"pictures",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 21:09:40-23.11.1999, Code automatically updated!
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

%BEGIN_DLG Pictures
/**************************************************************************
	Creation and event handling for dialog: Pictures
**************************************************************************/

CONSTANTS

%BEGIN Pictures, CreateParms, 21:09:36-23.11.1999, Code automatically updated!
  dlg_pictures_ResID = idd_pictures
  dlg_pictures_DlgType = wd_Modal
  dlg_pictures_Help = idh_contents
%END Pictures, CreateParms

PREDICATES

  dlg_pictures_eh : EHANDLER
  dlg_pictures_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_pictures_Create(Parent):-

%MARK Pictures, new variables

	dialog_CreateModal(Parent,dlg_pictures_ResID,"",
  		[
%BEGIN Pictures, ControlList, 21:09:36-23.11.1999, Code automatically updated!
		df(idc_rop,listbox(["rop_Blackness","rop_Whiteness","rop_DstInvert","rop_MergeCopy","rop_MergePaint","rop_NotSrcCopy","rop_NotSrcErase","rop_PatCopy","rop_PatInvert","rop_PatPaint","rop_SrcAnd","rop_SrcCopy","rop_SrcErase","rop_SrcInvert","rop_SrcPaint"],[11]),nopr),
		df(idc_brush_color,editstr("",[]),nopr),
		df(idc_brush_pattern,listbutton(["pat_Hollow","pat_Solid","pat_Horz","pat_Vert","pat_FDiag","pat_BDiag","pat_Cross","pat_DiagCross"],4),nopr),
		df(idc_bitmap,editstr("",[]),nopr),
		df(idc_bkgrnd,editstr("",[]),nopr),
		df(idc_stretch_bitmap,checkbox(b_false),nopr)
%END Pictures, ControlList
		],
		dlg_pictures_eh,0,VALLIST,ANSWER),!,
	ANSWER = idc_ok,
	TaskWin=vpi_GetTaskWin(),
	win_SendEvent(TaskWin,e_menu(id_file_exit,c_Nothing)),
	dlg_pictures_update(VALLIST),!.

  dlg_pictures_Create(_):-
	dlg_Note("Error: Fail in dlg_pictures_Create").

  dlg_pictures_update(_VALLIST):-
%BEGIN Pictures, Update controls, 21:09:36-23.11.1999, Code automatically updated!
	dialog_VLGetListBox(idc_rop,_VALLIST,_IDC_ROP_ITEMLIST,_IDC_ROP_SELECT),
	_IDC_BRUSH_COLOR_VALUE = dialog_VLGetstr(idc_brush_color,_VALLIST),
	_IDC_BITMAP_VALUE = dialog_VLGetstr(idc_bitmap,_VALLIST),
	_IDC_BKGRND_VALUE = dialog_VLGetstr(idc_bkgrnd,_VALLIST),
	dialog_VLGetListButton(idc_brush_pattern,_VALLIST,_IDC_BRUSH_PATTERN_ITEMLIST,_IDC_BRUSH_PATTERN_SELECT),
	_IDC_STRETCH_BITMAP_CHECKED = dialog_VLGetCheck(idc_stretch_bitmap,_VALLIST),
%END Pictures, Update controls
	!.
  dlg_pictures_update(_):-
	dlg_Note("Error: Fail in dlg_pictures_update").

%MARK Pictures, new events

%BEGIN Pictures, idc_about _CtlInfo
  dlg_pictures_eh(_Win,e_Control(idc_about,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	TaskWin=win_GetParent(_Win),
	win_SendEvent(TaskWin,e_menu(id_help_about,c_Nothing)),
	!.
%END Pictures, idc_about _CtlInfo

%BEGIN Pictures, e_Create
  dlg_pictures_eh(_Win,e_Create(_CreationData),0):-!,
	ColorW = win_GetCtlHandle(_Win,idc_brush_color),
	format(Text,"0x%X",color_blue),
	win_SetText(ColorW,Text),
	BitmapW = win_GetCtlHandle(_Win,idc_bitmap),
	CheckBoxW=win_GetCtlHandle(_Win,idc_stretch_bitmap),
	win_Check(CheckBoxW,checkbox_on),
ifdef os_os2
	win_SetText(BitmapW,"bitmaos2.bmp"),
elsedef
	win_SetText(BitmapW,"bitmap.bmp"),
enddef
	BkGrndW = win_GetCtlHandle(_Win,idc_bkgrnd),
ifdef os_os2
	win_SetText(BkGrndW,"backgos2.bmp"),
elsedef
	win_SetText(BkGrndW,"backgrnd.bmp"),
enddef
	!.
%END Pictures, e_Create

%BEGIN Pictures, idc_stretch_bitmap _CtlInfo
  dlg_pictures_eh(_Win,e_Control(idc_stretch_bitmap,_CtrlType,CWin,_CtlInfo),0):-
	State = win_IsChecked(CWin),
	State =checkbox_on,!,
	win_Check(CWin,checkbox_off),
	W = win_GetCtlHandle(_Win,idc_custom),
	update_picture(W),
	!.
  dlg_pictures_eh(_Win,e_Control(idc_stretch_bitmap,_CtrlType,CWin,_CtlInfo),0):-!,
	win_Check(CWin,b_true),
	W = win_GetCtlHandle(_Win,idc_custom),
	update_picture(W),
	!.
%END Pictures, idc_stretch_bitmap _CtlInfo

%BEGIN Pictures, idc_choose_bitmap _CtlInfo
  dlg_pictures_eh(_Win,e_Control(idc_choose_bitmap,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	FileName=dlg_GetFileName("*.bmp",["*.bmp","*.bmp"],"",[],"",_),
	FileName<>"",
	existfile(FileName),
	BitmapW = win_GetCtlHandle(_Win,idc_bitmap),
	win_SetText(BitmapW,FileName),
	W=win_GetCtlHandle(_Win,idc_custom),
	update_picture(W),
	!.
%END Pictures, idc_choose_bitmap _CtlInfo

%BEGIN Pictures, idc_choose_bkgrnd _CtlInfo
  dlg_pictures_eh(_Win,e_Control(idc_choose_bkgrnd,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	FileName=dlg_GetFileName("*.bmp",["*.bmp","*.bmp"],"",[],"",_),
	FileName<>"",
	existfile(FileName),
	BitmapW = win_GetCtlHandle(_Win,idc_bkgrnd),
	win_SetText(BitmapW,FileName),
	W=win_GetCtlHandle(_Win,idc_custom),
	update_picture(W),
	!.
%END Pictures, idc_choose_bkgrnd _CtlInfo

%BEGIN Pictures, idc_set_brush_color _CtlInfo
  dlg_pictures_eh(_Win,e_Control(idc_set_brush_color,_CtrlType,_CtrlWin,_CtlInfo),0):-
	ColorW = win_GetCtlHandle(_Win,idc_brush_color),
	OldVal = win_GetText(ColorW),
	OldVal <> "",
	trap(term_str(long,OldColor,OldVal),_E,dlg_Note("Invalid Brush Color value")),!,
	NewCOLOR = dlg_ChooseColor(OldColor),
	format(Text,"0x%X",NewCOLOR),
	win_SetText(ColorW,Text),
	W=win_GetCtlHandle(_Win,idc_custom),
	update_picture(W),
	!.
  dlg_pictures_eh(_Win,e_Control(idc_set_brush_color,_CtrlType,_CtrlWin,_CtlInfo),0):-
	ColorW = win_GetCtlHandle(_Win,idc_brush_color),
	NewCOLOR = dlg_ChooseColor(color_White),
	format(Text,"0x%X",NewCOLOR),
	win_SetText(ColorW,Text),
	W=win_GetCtlHandle(_Win,idc_custom),
	update_picture(W),
	!.
%END Pictures, idc_set_brush_color _CtlInfo

%BEGIN Pictures, idc_rop activated
  dlg_pictures_eh(_Win,e_Control(idc_rop,_CtrlType,LW,activated),0):-!,
	W=win_GetCtlHandle(_Win,idc_custom),
	Index=lbox_GetSelIndex(LW),
	Item=lbox_GetItem(LW,Index),
	select_rop(Item,S),
	retractall(get_rop(_)),
	assert(get_rop(S)),
	update_picture(W),
	!.
%END Pictures, idc_rop activated

%BEGIN Pictures, idc_brush_pattern selchanged
  dlg_pictures_eh(_Win,e_Control(idc_brush_pattern,_CtrlType,_CtrlWin,selchanged),0):-!,
	S=win_GetCtlHandle(_Win,idc_brush_pattern),
	T=win_GetText(S),
	select_pattern(T,P),
	retractall(get_brush_pattern(_)),
	assert(get_brush_pattern(P)),
	W=win_GetCtlHandle(_Win,idc_custom),
	update_picture(W),
	!.
%END Pictures, idc_brush_pattern selchanged

%BEGIN Pictures, idc_ok _CtlInfo
  dlg_pictures_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	_VALLIST = dialog_GetValues(_Win),
	dlg_pictures_update(_VALLIST),
	!,fail.
%END Pictures, idc_ok _CtlInfo

  dlg_pictures_eh(_,_,_):-!,fail.

%END_DLG Pictures










