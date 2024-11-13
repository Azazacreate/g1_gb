/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  WEBAGENT
 FileName: SET&STAT.PRO
 Purpose: Example of HTTP Layer
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/

include "webagent.inc"
include "webagent.con"
include "hlptopic.con"

PREDICATES
  auth_code_decode(BINARY NamePwd, STRING Name, STRING Pass) - (i,o,o),(o,i,i)
  test_targdir(INTEGER,STRING,STRING,STRING) - (i,i,i,o)
  test_fetchpath(INTEGER,STRING,BOOLEAN,BOOLEAN) - (i,i,i,i)
  test_levels(INTEGER,STRING,STRING,INTEGER) - (i,i,i,i)
  md(STRING) - (i)

%BEGIN_DLG Entry settings
/**************************************************************************
	Creation and event handling for dialog: Entry settings
**************************************************************************/

CONSTANTS

%BEGIN Entry settings, CreateParms, 13:18:50-26.11.1999, Code automatically updated!
  dlg_entry_settings_ResID = idd_entry_settings
  dlg_entry_settings_DlgType = wd_Modeless
  dlg_entry_settings_Help = idh_contents
%END Entry settings, CreateParms

PREDICATES

  dlg_entry_settings_eh : EHANDLER
  dlg_entry_settings_update(WINDOW, DIALOG_VAL_LIST)

CLAUSES

  dlg_entry_settings_Create(Parent,Row):-
	uri_entry(Row,_,Uri,_,setts(Levels,IDC_FETCH_PATH_CHECKED,_,TargDir,auth(IDC_USE_AUTHENTICATION_CHECKED,NamePwd_bin)),_,_,_),
	format(IDCT_ENTRY_INFO_TITLE,"Row %d, %s",Row,Uri),
	str_int(Levels,Lvs),
	IDC_LEVELS_VALUE = i(Lvs),
	auth_code_decode(NamePwd_bin,IDC_ENTRY_AUTH_NAME_VALUE,IDC_ENTRY_AUTH_PASS_VALUE),
%MARK Entry settings, new variables

	This_win = dialog_CreateModeless(Parent,dlg_entry_settings_ResID,"",
  		[
%BEGIN Entry settings, ControlList, 13:18:50-26.11.1999, Code automatically updated!
		df(idc_levels,editint(IDC_LEVELS_VALUE,[mandatory,minimum(1)]),dlg_prompt(idct_search_for)),
		df(idc_fetch_path,checkbox(IDC_FETCH_PATH_CHECKED),nopr),
		df(idc_use_authentication,checkbox(IDC_USE_AUTHENTICATION_CHECKED),nopr),
		df(idc_entry_auth_name,editstr(IDC_ENTRY_AUTH_NAME_VALUE,[]),nopr),
		df(idc_entry_auth_pass,editstr(IDC_ENTRY_AUTH_PASS_VALUE,[]),nopr),
		df(idct_entry_info,statictext(IDCT_ENTRY_INFO_TITLE),nopr),
		df(idc_lvs_scrl,scrollbar(0,0,0,100,0),nopr)
%END Entry settings, ControlList
		],
		dlg_entry_settings_eh,0),
	assert(entry_setts_db(This_win,Row)),
	TD_h = win_GetCtlHandle(This_win,idc_entry_target_dir),
	set_dir_SetProc( TD_h, wa_SetDirCallBack ),
	set_dir_set(TD_h,TargDir),
	Font = win_GetFont(This_win),
	win_SetFont(TD_h,Font),!.

  dlg_entry_settings_update(Win,_VALLIST):-
%BEGIN Entry settings, Update controls, 13:18:50-26.11.1999, Code automatically updated!
	_IDC_LEVELS_VALUE = dialog_VLGetint(idc_levels,_VALLIST),
	_IDC_LVS_SCRL_POS = dialog_VLGetScrollBar(idc_lvs_scrl,_VALLIST),
	_IDC_USE_AUTHENTICATION_CHECKED = dialog_VLGetCheck(idc_use_authentication,_VALLIST),
	_IDC_ENTRY_AUTH_NAME_VALUE = dialog_VLGetstr(idc_entry_auth_name,_VALLIST),
	_IDC_ENTRY_AUTH_PASS_VALUE = dialog_VLGetstr(idc_entry_auth_pass,_VALLIST),
	_IDC_FETCH_PATH_CHECKED = dialog_VLGetCheck(idc_fetch_path,_VALLIST),
%END Entry settings, Update controls
	entry_setts_db(Win,Row),
	_IDC_LEVELS_VALUE = i(Lvs),
	str_int(Levels,Lvs),
	auth_code_decode(NamePwd,_IDC_ENTRY_AUTH_NAME_VALUE,_IDC_ENTRY_AUTH_PASS_VALUE),
	retract(uri_entry(Row,A,B,C,setts(PrevLevels,PrevFetchPath,D,E,_),F,G,H)),!,
	test_fetchpath(Row,E,PrevFetchPath,_IDC_FETCH_PATH_CHECKED),
	test_levels(Row,E,PrevLevels,Lvs),
	assert(uri_entry(Row,A,B,C,setts(Levels,_IDC_FETCH_PATH_CHECKED,D,E,auth(_IDC_USE_AUTHENTICATION_CHECKED,NamePwd)),F,G,H)),
	true.

%BEGIN Entry settings, idc_ok _CtlInfo
  dlg_entry_settings_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	VALLIST = dialog_GetValues(_Win),
	dlg_entry_settings_update(_Win,VALLIST),
	entry_setts_db(_Win,Row),
	TD_h = win_GetCtlHandle(_Win,idc_entry_target_dir),
	set_dir_get(TD_h,Path),
	retract(uri_entry(Row,A,B,C,setts(C1,C2,D,PathOld,E),F,G,H)),
	test_targdir(Row,Path,PathOld,PathNew),
	assert(uri_entry(Row,A,B,C,setts(C1,C2,D,PathNew,E),F,G,H)),
	retractall(entry_setts_db(_Win,_)),
	!,fail.
%END Entry settings, idc_ok _CtlInfo
%MARK Entry settings, new events

%BEGIN Entry settings, idc_help _CtlInfo
  dlg_entry_settings_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(hlp_wa_Entry_Settings_dialog),
	!.
%END Entry settings, idc_help _CtlInfo

%BEGIN Entry settings, e_Create
  dlg_entry_settings_eh(_Win,e_Create(_CreationData),0):-
	b_true = dialog_GetCheck(_Win,idc_use_authentication),
	change_to_en(_Win,[idc_entry_auth_name,idc_entry_auth_pass,idc_authentication_parameters,idct_auth_user_name,idct_auth_user_password]),
	!.
  dlg_entry_settings_eh(_Win,e_Create(_CreationData),0):-
	b_false = dialog_GetCheck(_Win,idc_use_authentication),
	change_to_dis(_Win,[idc_entry_auth_name,idc_entry_auth_pass,idc_authentication_parameters,idct_auth_user_name,idct_auth_user_password]),
	!.
%END Entry settings, e_Create

%BEGIN Entry settings, e_Destroy
  dlg_entry_settings_eh(_Win,e_Destroy,0):-
  	retractall(entry_setts_db(_Win,_)),!.
%END Entry settings, e_Destroy

%BEGIN Entry settings, idc_lvs_scrl scroll(_ScrCode,_POS)
  dlg_entry_settings_eh(_Win,e_Control(idc_lvs_scrl,_CtrlType,_CtrlWin,scroll(sc_LineUp,_POS)),0):-!,
	L_d = dialog_GetInt(_Win,idc_levels),
	L_d = i(Lvs),
	L_d1 = Lvs + 1,
	dialog_SetInt(_Win,idc_levels,i(L_d1)),
	!.
  dlg_entry_settings_eh(_Win,e_Control(idc_lvs_scrl,_CtrlType,_CtrlWin,scroll(sc_LineDown,_POS)),0):-!,	
	L_d = dialog_GetInt(_Win,idc_levels),
	L_d = i(Lvs),
	L_d1 = Lvs - 1,
	L_d1 > 0,
	dialog_SetInt(_Win,idc_levels,i(L_d1)),
	!.
%END Entry settings, idc_lvs_scrl scroll(_ScrCode,_POS)

%BEGIN Entry settings, idc_use_authentication _CtlInfo
  dlg_entry_settings_eh(_Win,e_Control(idc_use_authentication,_CtrlType,_CtrlWin,activated),0):-
	b_true = dialog_GetCheck(_Win,idc_use_authentication),!,
	change_to_en(_Win,[idc_entry_auth_name,idc_entry_auth_pass,idc_authentication_parameters,idct_auth_user_name,idct_auth_user_password]),
	!.
  dlg_entry_settings_eh(_Win,e_Control(idc_use_authentication,_CtrlType,_CtrlWin,activated),0):-
  	b_false = dialog_GetCheck(_Win,idc_use_authentication),!,
	change_to_dis(_Win,[idc_entry_auth_name,idc_entry_auth_pass,idc_authentication_parameters,idct_auth_user_name,idct_auth_user_password]),
	!.
%END Entry settings, idc_use_authentication _CtlInfo

%BEGIN Entry settings, idc_notify_persons _CtlInfo
  dlg_entry_settings_eh(_Win,e_Control(idc_notify_persons,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	entry_setts_db(_Win,Row),
  	uri_entry(Row,A,B,C,setts(D,C2,NotifSettsIn,E,F),G,H,L),
  	notify_notifdialog_Create(_Win,NotifSettsIn, NotifSettsOut ),
  	retractall(uri_entry(Row,A,B,C,setts(D,C2,NotifSettsIn,E,F),G,H,L)),
  	assert(uri_entry(Row,A,B,C,setts(D,C2,NotifSettsOut,E,F),G,H,L)),
	!.
%END Entry settings, idc_notify_persons _CtlInfo

  dlg_entry_settings_eh(_,_,_):-!,fail.

%END_DLG Entry settings

CLAUSES
  auth_code_decode(NP,N,P):-
  	bound(NP),free(N),free(P),
  	term_bin(STRING,NP_str,NP),
  	code_base64(NamePass,NP_str),
	searchchar(NamePass,':',FoundPos),!,
	FP = FoundPos - 1,
	frontstr(FP,NamePass,N,RestString),
	frontchar(RestString,_,P).
  auth_code_decode(NP,N,P):-
  	free(NP),bound(N),bound(P),
  	format(Str,"%s:%s",N,P),
  	code_base64(Str,NP_str),
  	term_bin(STRING,NP_str,NP),
  	!.

  test_targdir(_,PathCur,PathOld,PathOld):-
  	0 = str_strCmpi(PathCur,PathOld),
  	!. % was not changed
  test_targdir(Row,PathCur,PathOld,PathCur):-
  	0 <> str_strCmpi(PathCur,PathOld),
  	retractall(already_req(Row,_,_,_)),
  	retractall(file_refs(Row,_,_,_)),
  	retractall(done_lst(Row,_)),
  	make_done_lst(),
  	PathCur <> "",
  	trap(diropen(PathCur,0x10,_Bl),_,true),
  	trap(dirclose(_Bl),_,true),
	del_dirry(PathCur),!.
  test_targdir(_,PathCur,_,PathCur):-			% doesn't exist
  	PathCur <> "",
  	is_md(PathCur,0),!.
  test_targdir(_,PathCur,_,PathCur).			% empty name

  is_md(Path,Pos):-
	frontstr(Pos,Path,_,Pth),
	searchstring(Pth,"\\",FoundPos),
	FP = FoundPos - 1 + Pos,
	frontstr(FP,Path,PathN,_),
        md(PathN),
        P = FP + 2,!,
        is_md(Path,P).
  is_md(Path,_):-		% because incoming path to is_md does't contain a slash at the end so last dir will not be created
  	md(Path).
  
  md(Path):-trap(mkdir(Path),_,true),!.
  md(_).

  test_fetchpath(Row,PathCur,b_false,b_true):-		% only if not set => set 
  	retractall(already_req(Row,_,_,_)),
  	retractall(file_refs(Row,_,_,_)),
  	retractall(done_lst(Row,_)),
  	make_done_lst(),
  	PathCur <> "",
  	trap(diropen(PathCur,0x10,_Bl),_,true),
  	trap(dirclose(_Bl),_,true),
	del_dirry(PathCur),!.
  test_fetchpath(_,_,_,_).
  
  test_levels(Row,PathCur,Old_levels_str,New_levels):-	% number of levels was decreased
  	str_int(Old_levels_str,Old_levels),
  	New_levels < Old_levels,
  	retractall(already_req(Row,_,_,_)),
  	retractall(file_refs(Row,_,_,_)),
  	retractall(done_lst(Row,_)),
  	make_done_lst(),
  	PathCur <> "",
  	trap(diropen(PathCur,0x10,_Bl),_,true),
  	trap(dirclose(_Bl),_,true),
	del_dirry(PathCur),!.
  test_levels(_,_,_,_).
  	




