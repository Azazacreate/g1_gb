/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  APICALL
 FileName: APICALL.PRO
 Purpose: Demo API call
 Written by: Yuri Illin
 Comments:
******************************************************************************/

include "apicall.inc"
include "apicall.con"
include "hlptopic.con"

CONSTANTS
ifdef ws_win
 snd_sync             = 0x0000  /* play synchronously (default) */
 snd_async            = 0x0001  /* play asynchronously */
 snd_nodefault        = 0x0002  /* silence (!default) if sound not found */
 snd_memory           = 0x0004  /* pszsound points to a memory file */
 snd_loop             = 0x0008  /* loop the sound until next sndplaysound */
 snd_nostop           = 0x0010  /* don't stop any currently playing sound */
enddef

GLOBAL PREDICATES
ifdef ws_win
 ifdef os_nt
 GetModuleFileName( LONG, STRING, DWORD ) - (i,i,i) language stdcall as "GetModuleFileNameA"
 sndPlaySound(STRING, UNSIGNED) - (i,i) language stdcall as "sndPlaySoundA"
 elsedef
 INTEGER GetModuleFileName( UNSIGNED, STRING, INTEGER ) - (i,i,i) language PASCAL
 sndPlaySound(STRING, UNSIGNED) - (i,i) language PASCAL
 enddef
elsedef
 DWORD WinQueryTaskTitle(DWORD, STRING, DWORD) - (i,i,i) language syscall
enddef

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 17:15:08-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "APICALL"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 17:15:08-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 17:15:08-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
ifdef ws_win
	FileName = dlg_GetFileName( "*.wav", ["Wav files","*.wav","All files","*.*"], 
		"Choose WAV file to play", [], "", _),
	SNDFLAGS = snd_nodefault + snd_sync,
	sndPlaySound( FileName, SNDFLAGS ),
	HINST = val( unsigned, vpi_GetAttrVal(attr_win_instance)),
	LEN = 300,
	str_len(BUFF,LEN),
	GetModuleFileName(HINST, BUFF, LEN),
elsedef
	LEN = 300,
	str_len(BUFF,LEN),
 	WinQueryTaskTitle(0, BUFF, LEN),
enddef	
	write(BUFF),nl,
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
ifdef platform_16bit
  	vpi_ShowHelp("apicall.hlp"),
elsedef
  	vpi_ShowHelp("apical32.hlp"),
enddef
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
ifdef platform_16bit
  	vpi_ShowHelpContext("apicall.hlp",HelpTopic).
elsedef
  	vpi_ShowHelpContext("apical32.hlp",HelpTopic).
enddef

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"apicall",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 17:15:02-23.11.1999, Code automatically updated!
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






















