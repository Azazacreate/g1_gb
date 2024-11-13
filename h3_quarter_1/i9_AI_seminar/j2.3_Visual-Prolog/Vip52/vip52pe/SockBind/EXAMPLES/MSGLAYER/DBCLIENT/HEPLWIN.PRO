/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DBCLIENT
 FileName: HEPLWIN.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "dbclient.inc"
include "dbclient.con"
include "hlptopic.con"

%BEGIN_WIN Help
/**************************************************************************
        Creation and event handling for window: Help
**************************************************************************/

CONSTANTS
%BEGIN Help, CreateParms, 10:42:38-26.11.1999, Code automatically updated!
  win_help_WinType = w_TopLevel
  win_help_Flags = [wsf_Border,wsf_TitleBar,wsf_TopMost,wsf_Close,wsf_ClipChildren]
  win_help_RCT = rct(15,20,366,326)
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
%BEGIN Help, InitControls, 10:42:38-26.11.1999, Code automatically updated!
	win_CreateControl(wc_Edit,rct(5,0,348,300),"",_Win,[wsf_AlignLeft,wsf_ReadOnly,wsf_MultiLine],idc_help_1),
%END Help, InitControls
%BEGIN Help, ToolbarCreate, 10:42:38-26.11.1999, Code automatically updated!
%END Help, ToolbarCreate
	
  	Str1 = "Under the menu Connection you can:\n",
  	concat(Str1,"     Establish a connection to a server\n",Str2),
  	concat(Str2,"     Close a connection\n",Str3),
  	concat(Str3,"     Chose among the open connections\n",Str41),
  	concat(Str41,"     Exit the client program\n\n",Str4),
  	concat(Str4,"Under the menu AcccessDB you can:\n",Str5),
  	concat(Str5,"     Make a search in the databases on the server\n",Str6),
  	concat(Str6,"     Edit the contens of the databases\n",Str7),
  	concat(Str7,"     Make a new item in the databases\n\n",Str8),
  	concat(Str8,"The menupoint Help opens this window",Str),
  	TWin = win_GetCtlHandle(_Win,idc_help_1),
  	win_SetText(TWin,Str),
  	assert(helpDialog(_Win)),
	!.
	
%END Help, e_Create
%MARK Help, new events

%BEGIN Help, e_CloseRequest
  win_help_eh(_Win,e_CloseRequest,0):-
  	retract(helpDialog(_Win)),!,
  	fail.
%END Help, e_CloseRequest

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














