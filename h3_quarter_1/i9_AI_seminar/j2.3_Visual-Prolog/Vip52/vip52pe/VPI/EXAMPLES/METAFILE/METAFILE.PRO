/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  METAFILE
 FileName: METAFILE.PRO
 Purpose: Metafile handling
 Written by: Alexander Gostintsev
 Comments:
******************************************************************************/

include "metafile.inc"
include "metafile.con"
include "hlptopic.con"

predicates
  error_handler(integer)

clauses
  error_handler(ErrNo):-
	errormsg("prolog.err",ErrNo,ErrMsg,_),
	dlg_Error(ErrMsg).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 20:34:48-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Metafile"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 20:34:48-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
  	win_Clear(_Win,color_White),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("metafile.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, id_MetaFile_clear
  task_win_eh(_Win,e_Menu(id_MetaFile_clear,_ShiftCtlAlt),0):-!,
	win_Clear ( _Win, color_White ),
	win_SetMapMode(_Win,mm_Text),
	!.
%END Task Window, id_MetaFile_clear
%BEGIN Task Window, id_MetaFile_create_new
  task_win_eh(_Win,e_Menu(id_MetaFile_create_new,_ShiftCtlAlt),0):-!,
	Mfw = mf_Open(),
	win_SetPen(Mfw,pen(3,ps_Solid,color_Red)),
	win_SetBrush(Mfw,brush(pat_Solid,color_Yellow)),
	draw_RoundRect(Mfw,rct(0,0,200,80),30,30),
	win_SetPen(Mfw,pen(2,ps_Solid,color_Blue)),
	draw_PolyLine(Mfw,[pnt(20,20),pnt(50,50),pnt(50,20),pnt(100,50),pnt(100,20)]),
	win_SetBrush(Mfw,brush(pat_Cross,color_Magenta)),
	draw_Pie(Mfw,rct(0,100,300,200),250,0,0,150),

	Font=font_Create(ff_Helvetica,[fs_Bold],12),
	win_SetFont(Mfw,Font),
	win_SetForeColor(Mfw,color_Black),
	draw_Text(Mfw,10,60,"Metafile DEMO"),
	Mf=mf_Close(Mfw),
	mf_Play(_Win,Mf),
	mf_Destroy(Mf),
	!.
%END Task Window, id_MetaFile_create_new
%BEGIN Task Window, id_MetaFile_save
  task_win_eh(_,e_Menu(id_MetaFile_save,_ShiftCtlAlt),0):-
	InitSelection="*.emf",
	FileTypeFilters=["Metafiles","*.emf","All Files","*.*"],
	Title="Save metafile as",
	Flags=[dlgfn_Save],
	StartPath="",
	FileName=dlg_GetFileName(InitSelection,FileTypeFilters,Title,Flags,StartPath,_),
	_Win = mf_Open(),
	win_SetPen(_Win,pen(3,ps_Solid,color_Red)),
	win_SetBrush(_Win,brush(pat_Solid,color_Yellow)),
	draw_RoundRect(_Win,rct(0,0,200,80),30,30),
	win_SetPen(_Win,pen(2,ps_Solid,color_Blue)),
	draw_PolyLine(_Win,[pnt(20,20),pnt(50,50),pnt(50,20),pnt(100,50),pnt(100,20)]),
	win_SetBrush(_Win,brush(pat_Cross,color_Magenta)),
	draw_Pie(_Win,rct(0,100,300,200),250,0,0,150),
	Font=font_Create(ff_Helvetica,[fs_Bold],12),
	win_SetFont(_Win,Font),
	win_SetForeColor(_Win,color_Black),
	draw_Text(_Win,10,60,"Metafile DEMO"),
	Mf=mf_Close(_Win),
	trap(mf_Save(Mf,rct(0,0,0,0),FileName),ErrNo,error_handler(ErrNo)),
	mf_Destroy(Mf),
	!.
  task_win_eh(_,e_Menu(id_MetaFile_save,_ShiftCtlAlt),0):-
	!.
%END Task Window, id_MetaFile_save
%BEGIN Task Window, id_MetaFile_open
  task_win_eh(_Win,e_Menu(id_MetaFile_open,_ShiftCtlAlt),0):-
	File=dlg_GetOpenFileName("*.wmf",["Metafiles","*.wmf"],""),
	File<>"",
	Mf=mf_Load(File),
	mf_Play(_Win,Mf),
	mf_Destroy(Mf),
	!.
%END Task Window, id_MetaFile_open
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"metafile",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 23:22:38-10.1.2000, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(_Win):-
	win_CreateResDialog(_Win,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,0) :- !,fail.
%END_DLG About dialog






