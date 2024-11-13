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
 dLL1_name = "DLL1.DLL"
 dLL2_name = "DLL2.DLL"

 dll_loaded_text =  "Loaded:"
 dll_load_failed_text = "Unable to Load DLL"
 
 dll_unloaded_text = "UNloaded"
 dll_unload_failed_text = "Unable to Unload DLL"
 
 idc_my_custom = 100
 rct_my_custom = rct(5,92,230,220)

DOMAINS
 DLLNAME = STRING
 
DATABASE - dlltest
 determ prgname(STRING)
 dllHandle(LONG DllHandle,STRING DLLname)
 determ customcontrol( WINDOW )

PREDICATES 
 BOOLEAN  load_dll(DLLNAME) - (i)
CLAUSES 
 load_dll(DLLNAME,b_true):-dllHandle(_,DLLNAME),!.
 load_dll(DLLNAME,b_true):-
	trap(DllHandle = vpi_LoadDll(DLLNAME),_,fail),!,
	assert(dllHandle(DllHandle,DLLNAME)).
 load_dll(DLLNAME,b_false):-
 	dlg_Error("Cannot load DLL",DLLNAME).
 
PREDICATES
 BOOLEAN  unload_dll(DLLNAME) - (i) 
CLAUSES 
 unload_dll(DLLNAME,b_true):-
        dllHandle(DllHandle,DLLNAME),!,
        vpi_FreeDll(DllHandle),
	retractall(dllHandle(DllHandle,DLLNAME)).
 unload_dll(_,b_false).

PREDICATES
  determ LONG /*PredicateHandle =*/ getDllProc( LONG DllHandle, STRING PredicateName ) - (i,i)
CLAUSES
  getDllProc(DllHandle,PredicateName,PredicateHandle):-
    	trap(PredicateHandle = vpi_GetDllProc(DllHandle,PredicateName),_,fail),!.
  getDllProc(DllHandle,PredicateNameL,0):-
   	upper_lower(PredicateName,PredicateNameL),
  	lasterror(_ErrorNo,FileName,_,Position),
  	dllHandle(DllHandle,DLLNAME),
  	beep,
  	format(Msg,"The predicate\"%\"\ndoesn't exist in file: \"%\"\n\nThe error occured in file: \"%\",\n at  Position %",PredicateName,DLLNAME,FileName,Position),
	dlg_MessageBox( "DLL Error",Msg, mesbox_iconExclamation, mesbox_buttonsOK, mesbox_defaultfirst, mesbox_suspendapplication ),
	fail.

 	
%BEGIN_DLG DLL Test
/**************************************************************************
	Creation and event handling for dialog: DLL Test
**************************************************************************/

CONSTANTS

%BEGIN DLL Test, CreateParms, 18:58:12-24.11.1999, Code automatically updated!
  dlg_dll_test_ResID = idd_dll_test
  dlg_dll_test_DlgType = wd_Modal
  dlg_dll_test_Help = idh_the_main_dialog
%END DLL Test, CreateParms

PREDICATES

  dlg_dll_test_eh : EHANDLER
  dlg_dll_test_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_dll_test_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_dll_test_Create(Parent,ID_FILE_DLL1_LOAD_CHECKED,ID_FILE_DLL2_LOAD_CHECKED):-
%MARK DLL Test, new variables
	dialog_CreateModal(Parent,dlg_dll_test_ResID,"",
  		[
%BEGIN DLL Test, ControlList, 18:58:12-24.11.1999, Code automatically updated!
		df(id_file_dll1_load,checkbox(ID_FILE_DLL1_LOAD_CHECKED),nopr),
		df(id_file_dll2_load,checkbox(ID_FILE_DLL2_LOAD_CHECKED),nopr),
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

PREDICATES
 procedure dl11_load_state(BOOLEAN State) - (o)
 procedure dl12_load_state(BOOLEAN State) - (o)
 procedure dlg_dll_test_enable_buttons(WINDOW) - (i)
 someCallback : mycallback
 
CLAUSES
dl11_load_state(b_true):-dllHandle(_,dll1_Name),!.
dl11_load_state(b_false).
dl12_load_state(b_true):-dllHandle(_,dll2_Name),!.
dl12_load_state(b_false).

 %Other buttons
 dlg_dll_test_enable_buttons(_Win):-
  	dl11_load_state(State1),
  	dl12_load_state(State2),
	dialog_SetState(_Win, [
		enable(idc_by_dll1,State1),
		enable(idc_hello,State2),
		enable(idc_get_string,State2)
		]).

  dlg_dll_test_update(_VALLIST):-
%BEGIN DLL Test, Update controls, 18:58:12-24.11.1999, Code automatically updated!
	_ID_FILE_DLL1_LOAD_CHECKED = dialog_VLGetCheck(id_file_dll1_load,_VALLIST),
	_ID_FILE_DLL2_LOAD_CHECKED = dialog_VLGetCheck(id_file_dll2_load,_VALLIST),
	_IDC_BY_DLL1_CHECKED = dialog_VLGetCheck(idc_by_dll1,_VALLIST),
%END DLL Test, Update controls
	true.

%MARK DLL Test, new events

%BEGIN DLL Test, idc_get_string _CtlInfo
  dlg_dll_test_eh(_Win,e_Control(idc_get_string,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dllHandle(Handle,dll2_Name),!,
  	PredicateHandleMark = cast( dll2_mark_gstack, getDllProc(Handle,"dll2_mark_gstack")),
  	PredicateHandle = cast( dll2_getstring, getDllProc(Handle,"dll2_getstring")),
  	PredicateHandleRel = cast( dll2_release_gstack, getDllProc(Handle,"dll2_release_gstack")),
  	PredicateHandleMark( StackMark ),
  	PredicateHandle(Str),
  	NewStr = Str, %<--- copy string to memory of calling process
  	PredicateHandleRel( StackMark ),
  	dlg_Note("Get",NewStr),
	!.
%END DLL Test, idc_get_string _CtlInfo

%BEGIN DLL Test, idc_hello _CtlInfo
  dlg_dll_test_eh(_Win,e_Control(idc_hello,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dllHandle(Handle,dll2_Name),!,
  	PredicateHandle = cast( dll2_callCallback, getDllProc(Handle,"dll2_callCallback")),
  	PredicateHandle(someCallback),
	!.
%END DLL Test, idc_hello _CtlInfo

%BEGIN DLL Test, idc_by_dll1 _CtlInfo
  dlg_dll_test_eh(_Win,e_Control(idc_by_dll1,_CtrlType,_CtrlWin,_CtlInfo),0):-
 	retract(customcontrol( CustWIN )),!,
	dllHandle(Handle,dll1_Name),
  	PredicateHandle = cast( dll1_custom_destroy, getDllProc(Handle,"dll1_custom_Destroy")),
 	PredicateHandle(CustWIN),
	dialog_SetCheck(_Win, idc_by_dll1, b_false ),
	dlg_dll_test_enable_buttons(_Win),
	!.
  dlg_dll_test_eh(_Win,e_Control(idc_by_dll1,_CtrlType,_CtrlWin,_CtlInfo),0):-
	dllHandle(Handle,dll1_Name),!,
  	PredicateHandle = cast( dll1_custom_create, getDllProc(Handle,"dll1_custom_Create")),
  	CustWIN = PredicateHandle(_WIN, rct_my_custom, idc_my_custom),
	dialog_SetCheck(_Win, idc_by_dll1, b_true ),
 	assert(customcontrol( CustWIN )),
	dlg_dll_test_enable_buttons(_Win),
 	!.
%END DLL Test, idc_by_dll1 _CtlInfo

%BEGIN DLL Test, idc_help _CtlInfo
  dlg_dll_test_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(idh_The_Main_Dialog),
	!.
%END DLL Test, idc_help _CtlInfo

%BEGIN DLL Test, id_file_dll2_load _CtlInfo
  dlg_dll_test_eh(_Win,e_Control(id_file_dll2_load,_CtrlType,_CtrlWin,_CtlInfo),0):-
        not(dllHandle(_,dll2_Name)),!,
 	b_true = load_dll(dll2_Name),
	dlg_dll_test_enable_buttons(_Win).
  dlg_dll_test_eh(_Win,e_Control(id_file_dll2_load,_CtrlType,_CtrlWin,_CtlInfo),0):-
 	b_true = unload_dll(dll2_Name),
	dlg_dll_test_enable_buttons(_Win),
	!.
%END DLL Test, id_file_dll2_load _CtlInfo

%BEGIN DLL Test, id_file_dll1_load _CtlInfo
  dlg_dll_test_eh(_Win,e_Control(id_file_dll1_load,_CtrlType,_CtrlWin,_CtlInfo),0):-
	not(dllHandle(_,dll1_Name)),!,
 	b_true = load_dll(dll1_Name),
	dlg_dll_test_enable_buttons(_Win).
  dlg_dll_test_eh(_Win,e_Control(id_file_dll1_load,_CtrlType,_CtrlWin,_CtlInfo),0):-
 	retract(customcontrol( CustWIN )),
	dllHandle(Handle,dll1_Name),
  	PredicateHandle = cast( dll1_custom_destroy, getDllProc(Handle,"dll1_custom_Destroy")),
 	PredicateHandle(CustWIN),
	dialog_SetCheck(_Win, idc_by_dll1, b_false ),
 	fail.
  dlg_dll_test_eh(_Win,e_Control(id_file_dll1_load,_CtrlType,_CtrlWin,_CtlInfo),0):-
 	b_true = unload_dll(dll1_Name),
	dlg_dll_test_enable_buttons(_Win),
	!.
%END DLL Test, id_file_dll1_load _CtlInfo

%BEGIN DLL Test, e_Destroy
  dlg_dll_test_eh(_Win,e_Destroy,0):-
 	retract(customcontrol( CustWIN )),
	dllHandle(Handle,dll1_Name),
  	PredicateHandle = cast( dll1_custom_destroy, getDllProc(Handle,"dll1_custom_Destroy")),
 	PredicateHandle(CustWIN),
 	fail.
  dlg_dll_test_eh(_Win,e_Destroy,0):-
	dllHandle(_,dll1_Name),
 	unload_dll(dll1_Name),
 	fail.
  dlg_dll_test_eh(_Win,e_Destroy,0):-
	dllHandle(_,dll2_Name),
 	unload_dll(dll2_Name),
 	fail.
%END DLL Test, e_Destroy

%BEGIN DLL Test, e_Create
  dlg_dll_test_eh(_Win,e_Create(_CreationData),0):-
  	dlg_dll_test_enable_buttons(_Win),
  	fail.
%END DLL Test, e_Create

  dlg_dll_test_eh(_,_,_):-!,fail.

  somecallback( String, 0 ):-
  	dlg_Note("In callback", String),
  	fail. %<---- free GStack
  somecallback( _, 0).
  
%END_DLG DLL Test

PREDICATES
  dll_cb_value(WINDOW,INTEGER CTRL_ID,BOOLEAN) - (i,i,o)
  dlg_dll_test_init(WINDOW,BOOLEAN ID_FILE_DLL1_LOAD_CHECKED,BOOLEAN ID_FILE_DLL2_LOAD_CHECKED) - (i,o,o)
CLAUSES
 dll_cb_value(_Win,id_file_dll1_load,b_true):-dllHandle(_,dll1_Name),!.
 dll_cb_value(_Win,id_file_dll2_load,b_true):-dllHandle(_,dll2_Name),!.
 dll_cb_value(_Win,_,b_false).
 	
 dlg_dll_test_init(_Win,ID_FILE_DLL1_LOAD_CHECKED,ID_FILE_DLL2_LOAD_CHECKED):-
 	dll_cb_value(_Win,id_file_dll1_load,ID_FILE_DLL1_LOAD_CHECKED),
 	dll_cb_value(_Win,id_file_dll2_load,ID_FILE_DLL2_LOAD_CHECKED).
%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:58:16-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "DLLTEST - Dynamic DLL Calls"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 18:58:16-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:58:16-24.11.1999, Code automatically updated!
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
        dlg_dll_test_init(_Win,ID_FILE_DLL1_LOAD_CHECKED,ID_FILE_DLL2_LOAD_CHECKED),
	dlg_dll_test_Create(_Win,ID_FILE_DLL1_LOAD_CHECKED,ID_FILE_DLL2_LOAD_CHECKED),
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










