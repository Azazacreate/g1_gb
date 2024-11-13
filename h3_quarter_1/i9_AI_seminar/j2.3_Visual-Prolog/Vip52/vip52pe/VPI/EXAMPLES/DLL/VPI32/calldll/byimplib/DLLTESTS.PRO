/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DLLTEST
 FileName: DLLTESTD.PRO
 Purpose: Using Dynamically Loaded DLLs
 Written by: Jonathan Lerwill (PDC)
 Modified by: Yuri Iliin
 Comments:
******************************************************************************/

include "dlltest.inc"
include "dlltest.con" 
include "hlptopic.con"


CONSTANTS
 idc_my_custom = 100
 rct_my_custom = rct(5,32,230,160)

DOMAINS
 DLLNAME = STRING
 
DATABASE - dlltest
 determ prgname(STRING)
 customcontrol( WINDOW )

%BEGIN_DLG DLL Test
/**************************************************************************
	Creation and event handling for dialog: DLL Test
**************************************************************************/

CONSTANTS

%BEGIN DLL Test, CreateParms, 18:53:12-24.11.1999, Code automatically updated!
  dlg_dll_test_ResID = idd_dll_test
  dlg_dll_test_DlgType = wd_Modal
  dlg_dll_test_Help = idh_the_main_dialog
%END DLL Test, CreateParms

PREDICATES

  dlg_dll_test_eh : ehandler
  somecallback : mycallback
  dlg_dll_test_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_dll_test_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_dll_test_Create(Parent):-
%MARK DLL Test, new variables
	dialog_CreateModal(Parent,dlg_dll_test_ResID,"",
  		[
%BEGIN DLL Test, ControlList, 18:53:12-24.11.1999, Code automatically updated!
		df(idc_by_dll1,checkbox(b_false),nopr)
%END DLL Test, ControlList
		],
		dlg_dll_test_eh,0,VALLIST,ANSWER),
	dlg_dll_test_handle_answer(ANSWER,VALLIST).

  dlg_dll_test_handle_answer(idc_ok,VALLIST):-!,
	dlg_dll_test_update(VALLIST).
  dlg_dll_test_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_dll_test_handle_answer(_,_):-
	errorexit().


  dlg_dll_test_update(_VALLIST):-
%BEGIN DLL Test, Update controls, 18:53:12-24.11.1999, Code automatically updated!
	_IDC_BY_DLL1_CHECKED = dialog_VLGetCheck(idc_by_dll1,_VALLIST),
%END DLL Test, Update controls
	true.

%MARK DLL Test, new events

%BEGIN DLL Test, e_Destroy
  dlg_dll_test_eh(_Win,e_Destroy,0):-!,
 	retract(customcontrol( CustWIN )),
 	dll1_custom_Destroy(CustWIN),
	!.
%END DLL Test, e_Destroy
%BEGIN DLL Test, idc_get_string _CtlInfo
  dlg_dll_test_eh(_Win,e_Control(idc_get_string,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	dll2_mark_gstack( StackMark ),
  	dll2_getstring(Str),
  	NewStr = Str, %<--- copy string to memory of calling process
  	dll2_release_gstack( StackMark ),
  	dlg_Note("Get",NewStr),
	!.
%END DLL Test, idc_get_string _CtlInfo

%BEGIN DLL Test, idc_hello _CtlInfo
  dlg_dll_test_eh(_Win,e_Control(idc_hello,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	dll2_callCallback(somecallback),
	!.
%END DLL Test, idc_hello _CtlInfo

%BEGIN DLL Test, idc_by_dll1 _CtlInfo
  dlg_dll_test_eh(_Win,e_Control(idc_by_dll1,_CtrlType,_CtrlWin,_CtlInfo),0):-
 	retract(customcontrol( CustWIN )),!,
 	dll1_custom_Destroy(CustWIN),
	dialog_SetCheck(_Win, idc_by_dll1, b_false ),
	!.
  dlg_dll_test_eh(_Win,e_Control(idc_by_dll1,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	CustWIN = dll1_custom_Create(_WIN, rct_my_custom, idc_my_custom),
	dialog_SetCheck(_Win, idc_by_dll1, b_true ),
 	assert(customcontrol( CustWIN )),
 	!.
%END DLL Test, idc_by_dll1 _CtlInfo

%BEGIN DLL Test, idc_help _CtlInfo
  dlg_dll_test_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(idh_The_Main_Dialog),
	!.
%END DLL Test, idc_help _CtlInfo

  dlg_dll_test_eh(_,_,_):-!,fail.

  somecallback( String, 0 ):-
  	dlg_Note("In callback", String),
  	fail. %<---- free GStack
  somecallback( _, 0).

%END_DLG DLL Test

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:53:22-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "DLLTEST - Statically Linked DLL's"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 18:53:22-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:53:22-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	syspath(_Path, FullName),
	filenameext(FullName,Name,_),
	osversion(OSVersion),
	write("Program ",Name," running on Windows ",OSVersion,"\n",
	      "Remember to read the \"HELP\" file\n"),
	assert(prgname(Name)),
	win_PostEvent(_Win,e_Menu(id_file_main_dialog,0)),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, id_file_main_dialog
  task_win_eh(_Win,e_Menu(id_file_main_dialog,_ShiftCtlAlt),0):-!,
	dlg_dll_test_Create(_Win),
	!.
%END Task Window, id_file_main_dialog


%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("dlltest.hlp").
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win).
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win).
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
  	vpi_ShowHelpContext("dlltest.hlp",HelpTopic).

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"dlltest",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 23:22:52-10.1.2000, Code automatically updated!
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












