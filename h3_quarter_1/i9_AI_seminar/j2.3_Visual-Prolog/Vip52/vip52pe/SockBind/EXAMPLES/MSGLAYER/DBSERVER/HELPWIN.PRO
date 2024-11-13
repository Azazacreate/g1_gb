/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DBSERVER
 FileName: HELPWIN.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "dbserver.inc"
include "dbserver.con"
include "hlptopic.con"

%BEGIN_WIN Help
/**************************************************************************
        Creation and event handling for window: Help
**************************************************************************/

CONSTANTS
%BEGIN Help, CreateParms, 11:28:28-26.11.1999, Code automatically updated!
  win_help_WinType = w_TopLevel
  win_help_Flags = [wsf_Border,wsf_TitleBar,wsf_Close,wsf_TopMost,wsf_ClipChildren]
  win_help_RCT = rct(10,20,353,264)
  win_help_Menu = no_menu
  win_help_Title = "Help"
  win_help_Help = idh_contents
%END Help, CreateParms

PREDICATES

  win_help_eh : EHANDLER

CLAUSES

  win_help_Create(Parent):-
	win_Create(win_help_WinType,win_help_RCT,win_help_Title,
		   win_help_Menu,Parent,win_help_Flags,win_help_eh,0).

%BEGIN Help, e_Create
  win_help_eh(_Win,e_Create(_),0):-!,
%BEGIN Help, InitControls, 11:28:28-26.11.1999, Code automatically updated!
	win_CreateControl(wc_Edit,rct(3,2,339,238),"",_Win,[wsf_AlignLeft,wsf_ReadOnly,wsf_MultiLine],idc_help_1),
%END Help, InitControls
%BEGIN Help, ToolbarCreate, 11:28:28-26.11.1999, Code automatically updated!
%END Help, ToolbarCreate
  	Str1 = "Press Listen to listen for incoming connections \n\n",
  	concat(Str1, "Under the Menu File you can:\n",Str2),
  	concat(Str2, "    Open a file with databases\n",Str3),
  	concat(Str3, "    Save the databases in a file\n",Str4),
  	concat(Str4, "    Create a new database\n",Str5),
  	concat(Str5, "    Close one database\n",Str6),
  	concat(Str6, "    Close all the databases\n",Str7),
  	concat(Str7, "    List the databases\n",Str8),
  	concat(Str8, "    Exit the database Server\n\n",Str9),
  	concat(Str9, "The Menu Help will open this window",Str),
  	HWin = win_GetCtlHandle(_Win,idc_help_1),
  	win_SetText(HWin,Str),	
  	assert(helpWinOpen()),
	!.
%END Help, e_Create
%MARK Help, new events

%BEGIN Help, e_Destroy
  win_help_eh(_Win,e_Destroy,0):-!,
  	retract(helpWinOpen()),
	!.
%END Help, e_Destroy

%BEGIN Help, e_Size
  win_help_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Help, e_Size

%BEGIN Help, e_Menu, Parent window 
  win_help_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Help, e_Menu, Parent window

%END_WIN Help





