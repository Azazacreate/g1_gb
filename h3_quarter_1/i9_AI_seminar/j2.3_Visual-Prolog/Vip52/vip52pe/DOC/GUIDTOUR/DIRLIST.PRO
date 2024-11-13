/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MYPROJ
 FileName: DIRLIST.PRO
 Purpose: A little Demo
 Written by: Leo Jensen
 Comments:
******************************************************************************/

include "myproj.inc"
include "myproj.con"
include "hlptopic.con"
include "iodecl.con"

%BEGIN_WIN Directory

/******************************************************
	Return subdirectories and files in a DIR
******************************************************/
domains
  STAMP = s(INTEGER Hour,INTEGER Min,INTEGER Sec,INTEGER Year,INTEGER Month,INTEGER Day,LONG Size);
	  dir  % No stamp for derectories
predicates
  nondeterm get_files(STRING Path,STRING FileName,STAMP)
clauses
  get_files(PATH,SUBDIR,dir):-
	concat(PATH,"*.*",PP),
	dirfiles(PP,fa_subdir,SUBDIR,_,_,_,_,_,_,_,_),
	SUBDIR >< ".".
  get_files(PATH,FName,s(Hour,Min,Sec,Year,Month,Day,Size)):-
	concat(PATH,"*.*",PP),
	dirfiles(PP,fa_normal,FName,_,Hour,Min,Sec,Year,Month,Day,Size).

/******************************************************
	Fill a listbox with the files in a subdir
******************************************************/
predicates
  fill_lbox(WINDOW,STRING PATH)
  fill_lbox(WINDOW,STRING FileName, STAMP)

clauses
  fill_lbox(Win,Path):-
	lbox_Clear(Win),
	get_files(Path,FName,STAMP),
	  fill_lbox(Win,FName,STAMP),
	fail.
  fill_lbox(_Win,_Path).

  fill_lbox(Win,SubDir,dir):-
	format(Str,"%\t%",SubDir,"<dir>"),
	lbox_Add(Win, -1, Str).
  fill_lbox(Win,FName,s(Hour,Min,Sec,Year,Month,Day,Size)):-
	format(Str,"%\t%8\t%2:%2:%2\t%4/%2/%2",FNAME,Size,Hour,Min,Sec,Year,Month,Day),
	lbox_Add(Win, -1, Str).

predicates
  get_path(STRING Item,STRING Path,STRING Rest)

clauses
  get_path(Item,Path,Rest):-
	searchchar(Item,'\t',Pos),
	Len = Pos -1,
	frontstr(Len,Item,Path,Rest).

/**************************************************************************
        Creation and event handling for window: Directory
	Code style: Single window
**************************************************************************/

constants
%BEGIN Directory, CreateParms, 10:07:24-24.11.1999, Code automatically updated!
  win_directory_WinType = w_TopLevel
  win_directory_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  win_directory_RCT = rct(100,80,440,240)
  win_directory_Menu = no_menu
  win_directory_Title = "Directory"
  win_directory_Help = idh_contents
%END Directory, CreateParms

predicates
  win_directory_eh : EHANDLER

clauses
  win_directory_Create(Parent):-
	win_Create(win_directory_WinType,win_directory_RCT,win_directory_Title,
		   win_directory_Menu,Parent,win_directory_Flags,win_directory_eh,0).

%BEGIN Directory, e_Create
  win_directory_eh(_Win,e_Create(_),0):-!,
%BEGIN Directory, InitControls, 10:07:24-24.11.1999, Code automatically updated!
	win_CreateControl(wc_LBox,rct(7,10,288,133),"",_Win,[wsf_Group,wsf_TabStop,wsf_VScroll,wsf_Sort,wsf_NoIntegralHeight,wsf_UseTabStops,wsf_NoBorder],idc_listbox),
%END Directory, InitControls
%BEGIN Directory, ToolbarCreate, 10:07:24-24.11.1999, Code automatically updated!
%END Directory, ToolbarCreate
	LBWIN = win_GetCtlHandle(_Win, idc_listbox),
ifndef os_os2
	lbox_SetTabStops(LBWIN, [0,75,125,175,225]),
enddef
	Font=font_Create(ff_Fixed, [], 10),
	win_SetFont(LBWIN,Font),
	win_SetText(_Win,"C:\\"),
	fill_lbox(LBWIN,"C:\\"),
	!.
%END Directory, e_Create
%MARK Directory, new events

%BEGIN Directory, idc_listbox selchanged
  win_directory_eh(_Win,e_Control(idc_listbox,_CtrlType,_CtrlWin,activated()),0):-
	Index = lbox_GetSelIndex(_CtrlWin),
	Item = lbox_GetItem(_CtrlWin, Index),
	get_path(Item,SubPath,Rest), Rest="\t<dir>",!,
	CurPath = win_GetText(_Win),
	format(NewPath,"%\\%",CurPath,SubPath),
	filenamepath(FullName,NewPath,"dd.dat"),
	filenamepath(FullName,ReducedPath,_),
	win_SetText(_Win, ReducedPath),
	fill_lbox(_CtrlWin,ReducedPath),
	!.
%END Directory, idc_listbox selchanged

%BEGIN Directory, e_Size
  win_directory_eh(_Win,e_Size(_Width,_Height),0):-!,
	LBWin = win_GetCtlHandle(_Win, idc_listbox),
	win_Move(LBWin,rct(0,0,_Width,_Height)),
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Directory, e_Size

%BEGIN Directory, e_Menu, Parent window 
  win_directory_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Directory, e_Menu, Parent window

%END_WIN Directory
