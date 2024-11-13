/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  WEBAGENT
 FileName: WEBAGENT.PRO
 Purpose: Example of HTTP Layer
 Written by: Konstantin Ivanov
 Comments: 
 	DEDICATED To GREENPEACE and Russian rock-group "ChiF", who are protests against
 	nuclear threat in their song "Ditty Against Dirt"
******************************************************************************/

include "webagent.inc"
include "webagent.con"
include "hlptopic.con"

DATABASE - startup
  startUp_lst(INTEGER,STRING)
  determ opt_ok_pressed
  
PREDICATES
  read_stat()
  save_stat()
  del_colored()
  check_ConsultError( INTEGER )				- (i)
  cleanup()
  procedure wa_stop_timer()
  load_fail_proc( INTEGER )				- (i)
  procedure opt_check_exten(STRING,STRING) 		- (i,o)
  opt_check_name(INTEGER,STRING,STRING) 		- (i,i,o)
  opt_log_set(WINDOW) 					- (i)
  opt_get(WINDOW,STRING,STRING,STRING,STRING,STRING) 	- (i,o,o,o,o,o)
  opt_set_brs_path(WINDOW) 				- (i)
  opt_setstate(BOOLEAN,WINDOW,BOOLEAN,WINDOW)		- (i,i,i,i)
  opt_brs_code(INTEGER,INTEGER) 			- (i,o),(o,i)
  procedure wa_lst_startup()
  update_cols_size()
  retrieve_cols_size()
  procedure cleanUp_list()
  procedure brs_run_error(STRING) 			- (i)
  procedure check_version()
  procedure check_version(OSVERSIONINFO)
  
CLAUSES

  change_to_en(_,[]).
  change_to_en(Win,[E|I1]):-
        Win_ctrl =win_GetCtlHandle(Win,E),
        win_SetState(Win_ctrl, [wsf_Enabled]),
        change_to_en(Win,I1).

  change_to_dis(_,[]).
  change_to_dis(Win,[E|I1]):-
        Win_ctrl =win_GetCtlHandle(WIN,E),
        win_SetState(Win_ctrl, [wsf_Disabled]),
        change_to_dis(Win,I1).

  brs_run_error(Path):-
  	disk(Path),
  	dlg_error("Cannot run Netscape Navigator"),!.

  update_cols_size():-
  	grid_win(Gwin),
  	grid_columnstyle(Gwin,C_lst),
  	C_lst = grid_columnstyle(_,Cols_lst),
  	Cols_lst = [grid_col(_,C1,_,_,_,_,_),grid_col(_,C2,_,_,_,_,_),grid_col(_,C3,_,_,_,_,_),grid_col(_,C4,_,_,_,_,_)],
  	retractall(cols_width(_,_,_,_)),
  	assert(cols_width(C1,C2,C3,C4)),!.
  	
  retrieve_cols_size():-
  	grid_win(Gwin),
  	grid_columnstyle(Gwin,C_lst),
  	C_lst = grid_columnstyle(_,Cols_lst),
  	Cols_lst = [grid_col(A1,_,A3,A4,A5,A6,A7),grid_col(B1,_,B3,B4,B5,B6,B7),grid_col(C1,_,C3,C4,C5,C6,C7),grid_col(D1,_,D3,D4,D5,D6,D7)],
  	cols_width(CZ1,CZ2,CZ3,CZ4),
  	grid_columnstyle(Gwin,grid_columnstyle(0,[grid_col(A1,CZ1,A3,A4,A5,A6,A7),grid_col(B1,CZ2,B3,B4,B5,B6,B7),grid_col(C1,CZ3,C3,C4,C5,C6,C7),grid_col(D1,CZ4,D3,D4,D5,D6,D7)])),
  	!.

  getsysdir(Pth):-
	api_GetWindowsDirectory(Buffer),
	concat(Buffer,"\\",Pth).
	
  check_ConsultError( 7002 ):-
  	dlg_error( "WebAgent ini file can not be found! Defaults are used!" ),!.
  check_ConsultError( Err ):-
  	format( StrNote, "WebAgent ini file can not be properly loaded: error %d. Defaults are used!", Err ),
  	dlg_error( StrNote ),!.
	
  read_stat():-
  	getsysdir(WinPath),
	filenamepath(FullName,WinPath,"WebAgent.ini"),
  	trap( consult( FullName, intern ), E, check_ConsultError( E ) ),
  	!.
  read_stat():-
  	retractall(uri_entry(_,_,_,_,_,_,_,_)),
  	retractall(options(_,_,_,_,_,_)),
  	retractall(cols_width(_,_,_,_)),
  	disk(CurPath),
	filenamepath(FullName,CurPath,"WebAgent.log"),
	filenamepath(ResFullName,CurPath,"WA_reslt.htm"),
  	assert(options(4,log(1,FullName,0,""),proxy(0,"",80),browser(0,"",""),ResFullName,1)),
  	assert(cols_width(65,238,54,120)),
  	!.
  	
  save_stat():-
  	update_cols_size(),
  	getsysdir(WinPath),
	filenamepath(FullName,WinPath,"WebAgent.ini"),  
  	trap(save(FullName,intern),_,dlg_error("Unable to write file WebAgent.ini")),
  	retractall(options(_,_,_,_,_,_)),
  	retractall(cols_width(_,_,_,_)),!.
  save_stat():-
  	retractall(options(_,_,_,_,_,_)),
  	retractall(cols_width(_,_,_,_)),!.
  	
  del_colored():-
  	retract(uri_entry(_,_,"","",setts("2",b_false,notify_setts([],""),"",auth(0,$[0x4F,0x67,0x3D,0x3D,0x00])),stat(""),_,_)),
  	fail.
  del_colored():-
  	retract(uri_entry(Row,Status,Uri,Timer,Path,Levels,color_White,color_Blue)),
  		assert(uri_entry(Row,Status,Uri,Timer,Path,Levels,color_Black,0xC0DCC0)),
  	fail.
  del_colored().

  cleanup():-
  	retractall(log_wind(_)),
  	retractall(grid_win(_)),
  	retractall(wa_dialog_win(_)),
  	retractall(wa_window(_)),
  	retractall(uri_entry(_,_,_,_,_,_,_,_)),
  	retractall(options(_,_,_,_,_,_)),
  	retractall(cols_width(_,_,_,_)),
  	retractall(done_lst(_,_)),
  	retractall(row_remote(_,_,_,_,_)),
  	retractall(row_lboxwin(_,_)),
  	retractall(already_req(_,_,_,_)),
  	retractall(file_refs(_,_,_,_)),
  	retractall(to_conn(_,_,_,_,_)),
	retractall(to_answer_http(_,_,_,_)),
	retractall(to_send_req(_,_,_,_)),
	retractall(row_next_timer(_,_)),
  	wa_stop_timer(),
  	httplay_CloseSession(),
  	!.
  	
  wa_stop_timer():-
  	retract(row_timer(_,T_id,_)),
		trap(timer_Kill(T_id),_,dlg_error("Unable stop timer")),
	fail.
  wa_stop_timer().
  
  load_fail_proc( _ ):-
  	disk(CurPath),
	filenamepath(FullName,CurPath,"WebAgent.log"),
	filenamepath(ResFullName,CurPath,"WA_reslt.log"),
  	assert(options(4,log(1,FullName,0,""),proxy(0,"",80),browser(0,"",""),ResFullName,1)),
  	assert(cols_width(65,238,54,120)),fail.
  load_fail_proc( 7002 ):-
	dlg_error( "Unable to load list: file not found! Defaults are used!" ),!.
  load_fail_proc( Err ):-
  	format(StrNote, "Unable to load list: error %d! Defaults are used!",Err),
	dlg_error(StrNote).

  wa_lst_startup():-
  	uri_entry(Row,Status,_,_,_,_,_,_),
		assert(startup_lst(Row,Status)),
  	fail.
  wa_lst_startup():-	% because uri_entry is changed during proc_state work
  	retract(startup_lst(Row,Status)),
  		proc_state(Row,Status),
  	fail.
  wa_lst_startup().

  cleanup_list():-
  	retractall(uri_entry(_,_,_,_,_,_,_,_)),
  	retractall(options(_,_,_,_,_,_)),
  	retractall(cols_width(_,_,_,_)),
  	retractall(done_lst(_,_)),
  	retractall(row_remote(_,_,_,_,_)),
  	retractall(row_lboxwin(_,_)),
  	retractall(already_req(_,_,_,_)),
  	retractall(file_refs(_,_,_,_)),
  	retractall(to_conn(_,_,_,_,_)),
	retractall(to_answer_http(_,_,_,_)),
	retractall(to_send_req(_,_,_,_)),
	retractall(row_next_timer(_,_)),
  	wa_stop_timer(),
  	!.
	
  check_version():-
  	trap(api_GetVersionEx(Res),_,true),
  	check_version(Res),!.
  check_version().
  
  check_version(osversioninfo(_,4,_,_,api_VER_PLATFORM_WIN32_NT,_)):-!.
  check_version(osversioninfo(_,_,_,_,_,_)):-
  	dlg_note("WebAgent was designed for MS Windows NT 4.0\n Some of WebAgent's features can be inaccessible under other platforms!"),!.
	
  wa_SetDirCallBack( idc_ns_nv_path, Old, New ):-
  	filenamepath( Old, Path, _ ),
	New = dlg_GetFileName("*.exe",["Programs","*.exe","All files","*.*"], "Point to Netscape Navigator executable", [], Path, _ ),!.
  wa_SetDirCallBack( idc_ms_ie_path, Old, New ):-
	filenamepath( Old, Path, _ ),
	New = dlg_GetFileName("*.exe",["Programs","*.exe","All files","*.*"], "Point to Microsoft Explorer executable", [], Path, _ ),!.
  wa_SetDirCallBack( idc_dbg_log_file, Old, New ):-
  	filenamepath( Old, Path, _ ),
	New = dlg_GetFileName( "WA.dbg", ["Debug Log files","*.dbg","All files","*.*"], "Select Debug log file", [], Path, _ ),!.  	
  wa_SetDirCallBack( idc_log_file_dir, Old, New ):-
  	filenamepath( Old, Path, _ ),
	New = dlg_GetFileName( "WA.log", ["Log files","*.log","All files","*.*"], "Select Log file", [], Path, _ ),!.	
  wa_SetDirCallBack( idc_res_file, Old, New ):-
  	filenamepath( Old, Path, _ ),
	New = dlg_GetFileName( "WA_Result.html", ["HTML files","*htm;*.html","All files","*.*"], "Select Reference page file", [], Path, _ ),!.
  wa_SetDirCallBack( idc_entry_target_dir, Old, New ):-
	TaskWin = vpi_GetTaskWin(),
	1 = dlg_GetDirectoryName( TaskWin, Old ,New ),!.
  wa_SetDirCallBack( _, S, S ).	
	
  opt_log_set(Win):-
	Log_path_h = win_GetCtlHandle(Win,idc_log_file_dir),
	Dbg_path_h = win_GetCtlHandle(Win,idc_dbg_log_file),
	Res_file_h = win_GetCtlHandle(Win,idc_res_file),
	Font = win_GetFont(Win),	
  	set_dir_setProc(Log_path_h, wa_SetDirCallBack ),
  	set_dir_setProc(Dbg_path_h, wa_SetDirCallBack ),
	set_dir_setProc(Res_file_h, wa_SetDirCallBack ),
	win_SetFont(Log_path_h, Font),
	win_SetFont(Dbg_path_h, Font),
	win_SetFont(Res_file_h, Font),
	options(_,_,_,_,RS,_),
	set_dir_set(Res_file_h,RS),
	options(_,log(LogState,LogFileName,DbgState,DbgFileName),_,_,_,_),
	set_dir_set(Log_path_h,LogFileName),
	set_dir_set(Dbg_path_h,DbgFileName),
	opt_setstate(LogState,Log_path_h,DbgState,Dbg_path_h),!.
	
  opt_get(Win,LogFileName,DbgFileName,Browser1,Browser2,ResultFileExten):-
  	Log_path_h = win_GetCtlHandle(Win,idc_log_file_dir),
	set_dir_get(Log_path_h,LogFileName),
 	Dbg_path_h = win_GetCtlHandle(Win,idc_dbg_log_file),
	set_dir_get(Dbg_path_h,DbgFileName),
	Res_file_h = win_GetCtlHandle(Win,idc_res_file),
	set_dir_get(Res_file_h,ResultFile),
	opt_check_exten(ResultFile,ResultFileExten),
	MS_h = win_GetCtlHandle(Win,idc_ms_ie_path),
	set_dir_get(MS_h,Browser1),
  	NS_h = win_GetCtlHandle(Win,idc_ns_nv_path),
	set_dir_get(NS_h,Browser2),
	!.
	
  opt_setstate(b_false,Log_path_h,b_false,Dbg_path_h):-
  	set_dir_event_proc(Log_path_h,e_State(disabled())),
  	set_dir_event_proc(Dbg_path_h,e_State(disabled())),!.
  opt_setstate(b_false,Log_path_h,b_true,Dbg_path_h):-
  	set_dir_event_proc(Log_path_h,e_State(disabled())),
  	set_dir_event_proc(Dbg_path_h,e_State(enabled())),!.
  opt_setstate(b_true,Log_path_h,b_false,Dbg_path_h):-
  	set_dir_event_proc(Log_path_h,e_State(enabled())),
  	set_dir_event_proc(Dbg_path_h,e_State(disabled())),!.
  opt_setstate(b_true,Log_path_h,b_true,Dbg_path_h):-
  	set_dir_event_proc(Log_path_h,e_State(enabled())),
  	set_dir_event_proc(Dbg_path_h,e_State(enabled())),!.  	  	  	
	
  opt_set_brs_path(Win):-
  	MS_h = win_GetCtlHandle(Win,idc_ms_ie_path),
  	NS_h = win_GetCtlHandle(Win,idc_ns_nv_path),
	Font = win_GetFont(Win),
  	set_dir_setProc( MS_h, wa_SetDirCallBack ),
  	set_dir_setProc( NS_h, wa_SetDirCallBack ),
	win_SetFont(MS_h, Font),
	win_SetFont(NS_h, Font),
	options(_,_,_,browser(0,Path1,Path2),_,_),
	set_dir_set(MS_h,Path1),
	set_dir_set(NS_h,Path2),
	set_dir_event_proc(NS_h,e_State(disabled())),
	set_dir_event_proc(MS_h,e_State(enabled())),
	!.
  opt_set_brs_path(Win):-
  	MS_h = win_GetCtlHandle(Win,idc_ms_ie_path),
  	NS_h = win_GetCtlHandle(Win,idc_ns_nv_path),
	options(_,_,_,browser(1,Path1,Path2),_,_),
	set_dir_set(MS_h,Path1),
	set_dir_set(NS_h,Path2),
	set_dir_event_proc(NS_h,e_State(enabled())),
	set_dir_event_proc(MS_h,e_State(disabled())),!.
	
  opt_brs_code(0,idc_ms_ie):-!.
  opt_brs_code(1,idc_ns_nav):-!.
  
  opt_check_exten("",""):-!.
  opt_check_exten(Str_in,Str_in):-
	filenameext(Str_in,_,Mask),
	Mask = ".htm",!.
  opt_check_exten(Str_in,Str_in):-
	filenameext(Str_in,_,Mask),
	Mask = ".html",!.
  opt_check_exten(Str_in,Str_out):-
  	filenameext(Str_in,Name,_),
  	filenameext(Str_out,Name,".html"),!.

  opt_check_name(1,"",Log1):-
 	disk(CurPath),
	format(Log1,"%s\\WA.log",CurPath),!.
  opt_check_name(1,Log,Log):-!.
  opt_check_name(2,"",Dbg1):-
 	disk(CurPath),
	format(Dbg1,"%s\\WA.dbg",CurPath),!.
  opt_check_name(2,Dbg,Dbg):-!.
  opt_check_name(3,"",RS1):-
 	disk(CurPath),
	format(RS1,"%s\\WA_reslt.htm",CurPath),!.
  opt_check_name(3,RS,RS):-!.
	
%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 13:19:18-26.11.1999, Code automatically updated!
  task_win_Flags = [wsf_TitleBar,wsf_Close,wsf_Minimize,wsf_ClipChildren]
  task_win_Menu  = no_menu
  task_win_Title = "WebAgent"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 13:19:18-26.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 13:19:18-26.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(1000),
ENDDEF
	check_version(),
	read_stat(),
	check_row_dir(),
	class_Create("grid",grid_handler),
	class_Create("set_dir",setdir_handler),
	wa_init(),
	dlg_webagent_Create(_Win),
%	win_PostEvent(_Win,e_Menu(id_start,0)),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

  task_win_eh(_Win,e_Menu(id_start,_),0):-
dlg_note("Hi"),
	!.
  task_win_eh(_Win,e_Menu(id_helpf,_),0):-
	project_ShowHelpContext(hlp_wa_WebAgent_Help),
	!.
%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
  	del_colored(),
  	save_stat(),
  	cleanup(),
	class_Destroy("grid"),
	class_Destroy("set_dir"),
	api_NetTerminate(),
	sMAPI_Terminate(),
	!.
%END Task Window, e_Destroy
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
  	vpi_ShowHelpContext("webagent.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF os_os2
  vpi_SetAttrVal(attr_use_outer_rct_edit_controls,b_true),
ELSEDEF
IFDEF use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
ENDDEF
ENDDEF
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"webagent",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 13:48:10-26.11.1999, Code automatically updated!
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

%BEGIN About dialog, idc_help _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(hlp_wa_About_dialog),
	!.
%END About dialog, idc_help _CtlInfo

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog


%BEGIN_DLG WebAgent
/**************************************************************************
	Creation and event handling for dialog: WebAgent
**************************************************************************/

CONSTANTS

%BEGIN WebAgent, CreateParms, 20:18:38-7.7.1997, Code automatically updated!
  dlg_webagent_ResID = idd_webagent
  dlg_webagent_DlgType = wd_Modeless
%END WebAgent, CreateParms

PREDICATES

  dlg_webagent_eh : EHANDLER
%  dlg_webagent_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_webagent_Create(Parent):-

%MARK WebAgent, new variables

	D_win = dialog_CreateModeless(Parent,dlg_webagent_ResID,"",
  		[
%BEGIN WebAgent, ControlList, 20:18:38-7.7.1997, Code automatically updated!
%END WebAgent, ControlList
		],
		dlg_webagent_eh,0),!,
	D_rct = win_GetClientRect(D_win),
	D_rct = rct(_,_,W,H),
	OuterRct = win_GetOuterRect(Parent),
	In_RCT = rect_GetClient(task_win_Flags,b_false,OuterRct),
	In_RCT = rct(L,T,_,_),
	R = W + L + 2,
	B = H + T + 2,
	win_Move(Parent,rct(L,T,R,B)).

  dlg_webagent_Create(_):-
	dlg_Note("Error: Fail in dlg_webagent_Create").

/*  dlg_webagent_update(_VALLIST):-
%BEGIN WebAgent, Update controls, 20:18:38-7.7.1997, Code automatically updated!
%END WebAgent, Update controls
	!.
  dlg_webagent_update(_):-
	dlg_Note("Error: Fail in dlg_webagent_update").*/

%MARK WebAgent, new events

%BEGIN WebAgent, idc_help _CtlInfo
  dlg_webagent_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(hlp_wa_WebAgent_window),
	!.
%END WebAgent, idc_help _CtlInfo

%BEGIN WebAgent, idc_view_res _CtlInfo
  dlg_webagent_eh(_Win,e_Control(idc_view_res,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	options(_,_,_,browser(_,"",""),_,_),
  	dlg_error("Path to browser is undefined!"),!.
  dlg_webagent_eh(_Win,e_Control(idc_view_res,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	options(_,_,_,browser(0,Path,_),RS,_),!,
  	NullWin = cast(WINDOW, 0),
  	format(Parm,"file://%s",RS),
  	trap(vpi_CreateProcess(NullWin,Path,Parm,wsf_Maximized),_Err,dlg_error("Cannot run MS Internet Explorer")),
	!.
  dlg_webagent_eh(_Win,e_Control(idc_view_res,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	options(_,_,_,browser(1,_,Path),RS,_),!,
	filenamepath(RS,RSPath,RSName),
  	NullWin = cast(WINDOW, 0),
  	format(Parm,"file://\\%s",RSName),
  	disk(Old),
  	disk(RSPath),
  	trap(vpi_CreateProcess(NullWin,Path,Parm,wsf_Maximized),_Err,brs_run_error(Old)),
  	disk(Old),
	!.	
%END WebAgent, idc_view_res _CtlInfo

%BEGIN WebAgent, idc_about _CtlInfo
  dlg_webagent_eh(_Win,e_Control(idc_about,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END WebAgent, idc_about _CtlInfo

%BEGIN WebAgent, idc_load_list _CtlInfo
  dlg_webagent_eh(_Win,e_Control(idc_load_list,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	FileName = dlg_GetFileName("*.lst",["List file","*.lst","All files","*.*"],"Load list",[],"",_FileName),
  	httplay_CancelPrevious(),
  	cleanUp_list(),
  	grid_win(GrWin),
  	grid_Invalidate(GrWin,grid_all),
  	trap(consult(FileName,intern),E,load_fail_proc(E)),
  	check_row_dir(),
  	wa_lst_startup(),
	retrieve_cols_size(),  	
  	grid_Invalidate(GrWin,grid_all),
  	write_log(1,"List loaded"),
	!.
%END WebAgent, idc_load_list _CtlInfo

%BEGIN WebAgent, idc_save_list _CtlInfo
  dlg_webagent_eh(_Win,e_Control(idc_save_list,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	FileName = dlg_GetFileName("*.lst",["List file","*.lst","All files","*.*"],"Save list",[dlgfn_Save],"",_FileName),
  	del_colored(),
  	trap(save(FileName,intern),_,dlg_error("Unable to save list")),
  	write_log(1,"List saved"),  	
	!.
%END WebAgent, idc_save_list _CtlInfo

%BEGIN WebAgent, e_Create
  dlg_webagent_eh(_Win,e_Create(_CreationData),0):-
  	win_SetIcon(_Win,vpi_application_icon),
  	D_rct = win_GetClientRect(_Win),
  	D_rct = rct(_,_,W,H),
  	GW = W - 110,
  	GH = H - 53,
	 _GridWin = win_CreateDynControl([customctl(wdef(wc_Custom,rct(10,10,GW,GH),"",u_Pixels),
					  "grid",777,[ctl_Group,ctl_TabStop])],_Win),
	assert(wa_dialog_win(_Win)),
	write_log(0,"WebAgent starts!"),
	wa_lst_startup(),
	!.
%END WebAgent, e_Create


%BEGIN WebAgent, idc_options _CtlInfo
  dlg_webagent_eh(_Win,e_Control(idc_options,_CtrlType,_CtrlWin,_CtlInfo),0):-
	dlg_options_Create(_Win),
	!.
%END WebAgent, idc_options _CtlInfo


%BEGIN WebAgent, e_EndApplication
  dlg_webagent_eh(_Win,e_EndApplication(_ApplicationID),0):-
  	P_win = vpi_GetTaskWin(),
	win_Destroy(P_win),
	fail.  
%END WebAgent, e_EndApplication


%BEGIN WebAgent, idc_exit _CtlInfo
  dlg_webagent_eh(_Win,e_Control(idc_exit,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	P_win = vpi_GetTaskWin(),
	win_Destroy(P_win),
	fail.
%END WebAgent, idc_exit _CtlInfo


  dlg_webagent_eh(_,_,_):-!,fail.

%END_DLG WebAgent




%BEGIN_DLG Options
/**************************************************************************
	Creation and event handling for dialog: Options
**************************************************************************/

CONSTANTS

%BEGIN Options, CreateParms, 13:19:02-26.11.1999, Code automatically updated!
  dlg_options_ResID = idd_options
  dlg_options_DlgType = wd_Modal
  dlg_options_Help = idh_contents
%END Options, CreateParms

PREDICATES

  dlg_options_eh : EHANDLER
  dlg_options_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_options_Create(Parent):-
	options(Val0,log(IDC_LOG_FILE_CHECKED,_LogFileName,IDC_DBG_LOG_CHECKED,_),proxy(IDC_USE_PROXY_CHECKED,IDC_PR_NAME_VALUE,Val1),browser(BRS_CODE,_,_),_,IDC_CLEAR_START_UP_DIRS_CHECKED),
	opt_brs_code(BRS_CODE,IDC_MS_IE),
	IDC_PR_PORT_VALUE = l(Val1),
	IDC_NUMBERCONN_VALUE = i(Val0),
%MARK Options, new variables

	dialog_CreateModal(Parent,dlg_options_ResID,"",
  		[
%BEGIN Options, ControlList, 13:19:02-26.11.1999, Code automatically updated!
		df(idc_numberconn,editint(IDC_NUMBERCONN_VALUE,[mandatory,default(4),range(1,1000)]),dlg_prompt(idct_conn_number)),
		df(idc_use_proxy,checkbox(IDC_USE_PROXY_CHECKED),nopr),
		df(idc_pr_name,editstr(IDC_PR_NAME_VALUE,[default("")]),str_prompt("Proxy name")),
		df(idc_pr_port,editlong(IDC_PR_PORT_VALUE,[default(80),minimum(0)]),str_prompt("Proxy port")),
		df(idc_log_file,checkbox(IDC_LOG_FILE_CHECKED),nopr),
		df(idc_dbg_log,checkbox(IDC_DBG_LOG_CHECKED),nopr),
		df(idc_clear_start_up_dirs,checkbox(IDC_CLEAR_START_UP_DIRS_CHECKED),nopr),
		df(idc_numberconn_scrl,scrollbar(0,0,0,100,0),nopr),
		df(IDC_MS_IE,radiobuttongroup([idc_ms_ie,idc_ns_nav]),nopr)
%END Options, ControlList
		],
		dlg_options_eh,0,VALLIST,ANSWER),!,
	ANSWER = idc_ok,
	dlg_options_update(VALLIST),!.

  dlg_options_Create(_):-
	dlg_Note("Error: Fail in dlg_options_Create").

  dlg_options_update(_VALLIST):-
%BEGIN Options, Update controls, 13:19:02-26.11.1999, Code automatically updated!
	_IDC_LOG_FILE_CHECKED = dialog_VLGetCheck(idc_log_file,_VALLIST),
	_IDC_USE_PROXY_CHECKED = dialog_VLGetCheck(idc_use_proxy,_VALLIST),
	_IDC_PR_NAME_VALUE = dialog_VLGetstr(idc_pr_name,_VALLIST),
	_IDC_PR_PORT_VALUE = dialog_VLGetlong(idc_pr_port,_VALLIST),
	_IDC_CLEAR_START_UP_DIRS_CHECKED = dialog_VLGetCheck(idc_clear_start_up_dirs,_VALLIST),
	_IDC_NUMBERCONN_VALUE = dialog_VLGetint(idc_numberconn,_VALLIST),
	_IDC_NUMBERCONN_SCRL_POS = dialog_VLGetScrollBar(idc_numberconn_scrl,_VALLIST),
	_IDC_DBG_LOG_CHECKED = dialog_VLGetCheck(idc_dbg_log,_VALLIST),
	_IDC_MS_IE = dialog_VLGetRadiobutton(idc_ms_ie,_VALLIST),
%END Options, Update controls
	retract(options(_,log(_,LogFileName,_,DbgFileName),_,browser(_,P1,P2),RF,_)),
	_IDC_PR_PORT_VALUE = l(Val2),
	_IDC_NUMBERCONN_VALUE = i(Val1),
	opt_brs_code(BRS_CODE,_IDC_MS_IE),
	Val1_us = cast( USHORT, Val1 ),
	Val2_us = cast( USHORT, Val2 ),
	assert(options(Val1_us,log(_IDC_LOG_FILE_CHECKED,LogFileName,_IDC_DBG_LOG_CHECKED,DbgFileName),proxy(_IDC_USE_PROXY_CHECKED,_IDC_PR_NAME_VALUE,Val2_us),browser(BRS_CODE,P1,P2),RF,_IDC_CLEAR_START_UP_DIRS_CHECKED)),
	!.
  dlg_options_update(_):-
	dlg_Note("Error: Fail in dlg_options_update").

%MARK Options, new events

%BEGIN Options, idc_ok _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	retractall(opt_ok_pressed),
  	assert(opt_ok_pressed),fail.
%END Options, idc_ok _CtlInfo

%BEGIN Options, idc_help _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(hlp_wa_Options_dialog),
	!.
%END Options, idc_help _CtlInfo

%BEGIN Options, idc_dbg_log _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_dbg_log,_CtrlType,CtrlWin,_CtlInfo),0):-
	b_true = win_IsChecked(CtrlWin),
	change_to_en(_Win,[idc_dbg_log_file]),
	!.
  dlg_options_eh(_Win,e_Control(idc_dbg_log,_CtrlType,CtrlWin,_CtlInfo),0):-
	b_false = win_IsChecked(CtrlWin),
	change_to_dis(_Win,[idc_dbg_log_file]),
	!.
%END Options, idc_dbg_log _CtlInfo

%BEGIN Options, idc_view_dbg _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_view_dbg,_CtrlType,_CtrlWin,_CtlInfo),0):-
	not(dbg_wind(_)),
	Par_win = cast( window, vpi_GetAttrVal(attr_screen_window)),
	Dbg_path_h = win_GetCtlHandle(_Win,idc_dbg_log_file),
	set_dir_get(Dbg_path_h,DbgFileName),	
	trap(openappend(file_ini,DbgFileName),_,dlg_error("Unable to read debug log")),
	closefile(file_ini),
	trap(file_str(DbgFileName,Str_file),_,dlg_error("Unable to read debug log")),
	str_len( Str_file, L ),
	L1 = L + 1,
        Font=font_Create(ff_System,[],10),
        Flags = [wsf_SizeBorder,wsf_Close,wsf_Minimize,wsf_ClipChildren,wsf_Maximize,wsf_ClipSiblings,wsf_Titlebar,wsf_HScroll,wsf_VScroll],
  	Dbg_win = edit_Create(w_TopLevel,rct(50,50,600,400),"Debug Information",res_menu(idr_dbg_menu),Par_win,Flags,Font,b_true,b_false,Str_file,L1,dbg_win_eh),
  	assert(dbg_wind(Dbg_win)),
  	trap(edit_StatusLineShow(Dbg_win,b_false),_,true),
  	!.
  dlg_options_eh(_Win,e_Control(idc_view_dbg,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	dbg_wind(Dw),
  	win_BringToTop(Dw),
	!.
%END Options, idc_view_dbg _CtlInfo
	
%BEGIN Options, idc_view_log _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_view_log,_CtrlType,_CtrlWin,_CtlInfo),0):-
	not(log_wind(_)),
	Par_win = cast( window, vpi_GetAttrVal(attr_screen_window)),
	Log_path_h = win_GetCtlHandle(_Win,idc_log_file_dir),
	set_dir_get(Log_path_h,LogFileName),
	trap(openappend(file_ini,LogFileName),_,dlg_error("Unable to read log file")),
	closefile(file_ini),
	trap(file_str(LogFileName,Str_file),_,dlg_error("Unable to read log file")),
	str_len( Str_file, L ),
	L1 = L + 1,
        Font=font_Create(ff_System,[],10),
        Flags = [wsf_SizeBorder,wsf_Close,wsf_Minimize,wsf_ClipChildren,wsf_Maximize,wsf_ClipSiblings,wsf_Titlebar,wsf_HScroll,wsf_VScroll],
  	Log_win = edit_Create(w_TopLevel,rct(50,50,600,400),"Log Information",res_menu(idr_log_menu),Par_win,Flags,Font,b_true,b_false,Str_file,L1,log_win_eh),
  	assert(log_wind(Log_win)),
  	trap(edit_StatusLineShow(Log_win,b_false),_,true),
  	!.
  dlg_options_eh(_Win,e_Control(idc_view_log,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	log_wind(Lw),
  	win_BringToTop(Lw),
	!.
%END Options, idc_view_log _CtlInfo

%BEGIN Options, idc_numberconn_scrl scroll(_ScrCode,_POS)
  dlg_options_eh(_Win,e_Control(idc_numberconn_scrl,_CtrlType,_CtrlWin,scroll(sc_LineUp,_POS)),0):-
	L_d = dialog_GetInt(_Win,idc_numberconn),
	L_d = i(Lvs),
	L_d1 = Lvs + 1,
	dialog_SetInt(_Win,idc_numberconn,i(L_d1)),
	!.
  dlg_options_eh(_Win,e_Control(idc_numberconn_scrl,_CtrlType,_CtrlWin,scroll(sc_LineDown,_POS)),0):-
	L_d = dialog_GetInt(_Win,idc_numberconn),
	L_d = i(Lvs),
	L_d1 = Lvs - 1,
	L_d1 > 0,
	dialog_SetInt(_Win,idc_numberconn,i(L_d1)),
	!.
%END Options, idc_numberconn_scrl scroll(_ScrCode,_POS)

%BEGIN Options, idc_ns_nav _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_ns_nav,_CtrlType,_CtrlWin,activated()),0):-
  	change_to_en(_Win,[idc_ns_nv_path]),
  	change_to_dis(_Win,[idc_ms_ie_path]),
	!.
%END Options, idc_ns_nav _CtlInfo

%BEGIN Options, idc_ms_ie _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_ms_ie,_CtrlType,_CtrlWin,activated()),0):-
  	change_to_en(_Win,[idc_ms_ie_path]),
  	change_to_dis(_Win,[idc_ns_nv_path]),
	!.
%END Options, idc_ms_ie _CtlInfo

%BEGIN Options, e_Destroy
  dlg_options_eh(_Win,e_Destroy,0):-
  	opt_ok_pressed,
	opt_get(_Win,LogFileNameO,DbgFileNameO,P1,P2,RSO),
	opt_check_name(1,LogFileNameO,LogFileName),
	opt_check_name(2,DbgFileNameO,DbgFileName),
	opt_check_name(3,RSO,RS),
	retract(options(A,log(B,_,B1,_),proxy(C,D,E),browser(F,_,_),_,H)),
	assert(options(A,log(B,LogFileName,B1,DbgFileName),proxy(C,D,E),browser(F,P1,P2),RS,H)),
	retract(opt_ok_pressed),
	!.
%END Options, e_Destroy

%BEGIN Options, idc_log_file _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_log_file,_CtrlType,CtrlWin,_CtlInfo),0):-
	b_true = win_IsChecked(CtrlWin),
	change_to_en(_Win,[idc_log_file_dir]),
	!.
  dlg_options_eh(_Win,e_Control(idc_log_file,_CtrlType,CtrlWin,_CtlInfo),0):-
	b_false = win_IsChecked(CtrlWin),
	change_to_dis(_Win,[idc_log_file_dir]),
	!.
%END Options, idc_log_file _CtlInfo

%BEGIN Options, e_Create
  dlg_options_eh(_Win,e_Create(_CreationData),0):-
  	opt_log_set(_Win),
  	opt_set_brs_path(_Win),
  	b_true = dialog_GetCheck(_Win,idc_use_proxy),
	Pr_name = dialog_GetStr(_Win,idc_pr_name),
	Pr_port = dialog_GetLong(_Win,idc_pr_port),
	change_to_en(_Win,[idc_pr_name,idc_pr_port,idct_proxy_name,idc_proxy,idct_proxy_port]),
	dialog_SetFields(_Win,[df(idc_pr_name, editstr(Pr_name,[mandatory]), str_prompt("Proxy name"))]),
	dialog_SetFields(_Win,[df(idc_pr_port,editlong(Pr_port,[mandatory,range(1,65535)]),str_prompt("Proxy port"))]),
	!.
  dlg_options_eh(_Win,e_Create(_CreationData),0):-
  	b_false = dialog_GetCheck(_Win,idc_use_proxy),
	Pr_name = dialog_GetStr(_Win,idc_pr_name),
	Pr_port = dialog_GetLong(_Win,idc_pr_port),
	change_to_dis(_Win,[idc_pr_name,idc_pr_port,idct_proxy_name,idc_proxy,idct_proxy_port]),
	dialog_SetFields(_Win,[df(idc_pr_name, editstr(Pr_name,[]), nopr)]),
	dialog_SetFields(_Win,[df(idc_pr_port,editlong(Pr_port,[]),nopr)]),
	!.	
%END Options, e_Create

%BEGIN Options, idc_use_proxy _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_use_proxy,_CtrlType,CtrlWin,activated()),0):-
	Res =win_IsChecked(CtrlWin),
	Res = 1,!,
	Pr_name = dialog_GetStr(_Win,idc_pr_name),
	Pr_port = dialog_GetLong(_Win,idc_pr_port),
	change_to_en(_Win,[idc_pr_name,idc_pr_port,idct_proxy_name,idc_proxy,idct_proxy_port]),
	dialog_SetFields(_Win,[df(idc_pr_name, editstr(Pr_name,[mandatory]), str_prompt("Proxy name"))]),
	dialog_SetFields(_Win,[df(idc_pr_port,editlong(Pr_port,[mandatory,range(1,65535)]),str_prompt("Proxy port"))]),
	!.
  dlg_options_eh(_Win,e_Control(idc_use_proxy,_CtrlType,CtrlWin,activated()),0):-
  	Res =win_IsChecked(CtrlWin),
	Res = 0,!,
	Pr_name = dialog_GetStr(_Win,idc_pr_name),
	Pr_port = dialog_GetLong(_Win,idc_pr_port),
	change_to_dis(_Win,[idc_pr_name,idc_pr_port,idct_proxy_name,idc_proxy,idct_proxy_port]),
	dialog_SetFields(_Win,[df(idc_pr_name, editstr(Pr_name,[]), nopr)]),
	dialog_SetFields(_Win,[df(idc_pr_port,editlong(Pr_port,[]),nopr)]),
	!.
%END Options, idc_use_proxy _CtlInfo

  dlg_options_eh(_,_,_):-!,fail.

%END_DLG Options





