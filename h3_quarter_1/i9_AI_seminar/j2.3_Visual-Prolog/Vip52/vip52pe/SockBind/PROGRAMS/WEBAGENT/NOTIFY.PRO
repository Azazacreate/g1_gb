/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  WEBAGENT
 FileName: NOTIFY.PRO
 Purpose: Example of HTTP Layer
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/

include "webagent.inc"
include "webagent.con"
include "hlptopic.con"

PREDICATES
  notif_set_text(WINDOW,INTEGER) - (i,i)
  notif_test_rest(WINDOW) - (i)
  notif_code(INTEGER,INTEGER) - (i,o),(o,i)
  copy_db_in(WINDOW,NOTIFY_LIST) - (i,i)
  copy_db_out(WINDOW,NOTIFY_LIST) - (i,o)
  
  
DATABASE - notif_db
  notif_db(WINDOW,STRING,INTEGER)
  notif_profname( WINDOW, STRING )
  
CONSTANTS
  mess_mode = 0
  email_mode = 1
%BEGIN_DLG NotifDialog
/**************************************************************************
	Creation and event handling for dialog: NotifDialog
**************************************************************************/

CONSTANTS

%BEGIN NotifDialog, CreateParms, 13:19:02-26.11.1999, Code automatically updated!
  dlg_notifdialog_ResID = idd_notifdialog
  dlg_notifdialog_DlgType = wd_Modal
  dlg_notifdialog_Help = idh_contents
%END NotifDialog, CreateParms

PREDICATES

  dlg_notifdialog_eh : EHANDLER
  procedure dlg_notifdialog_update(DIALOG_VAL_LIST)

CLAUSES

  notify_notifdialog_Create(Parent,notify_setts(Lst_in,ProfName_in), notify_setts(Lst_out,ProfName_out) ):-

	retractall(notif_db(Parent,_,_)),
	retractall(notif_profname(Parent,_)),
	assert(notif_profname(Parent,ProfName_in)),
	copy_db_in(Parent,Lst_in),
	findall(Item,notif_db(Parent,Item,_), NOTIF_LST_ITEMLIST ),
	IDC_NOTIF_EL_VALUE = "",
	IDC_NOTIF_KIND = idc_notif_mess,
%MARK NotifDialog, new variables

	dialog_CreateModal(Parent,dlg_notifdialog_ResID,"",
  		[
%BEGIN NotifDialog, ControlList, 13:19:02-26.11.1999, Code automatically updated!
		df(idc_notif_lst,listbox(NOTIF_LST_ITEMLIST,[0]),nopr),
		df(idc_notif_el,editstr(IDC_NOTIF_EL_VALUE,[]),dlg_prompt(idc_notif_mess)),
		df(IDC_NOTIF_KIND,radiobuttongroup([idc_notif_mess,idc_notif_mail]),nopr)
%END NotifDialog, ControlList
		],
		dlg_notifdialog_eh,0,VALLIST,ANSWER),!,
	ANSWER = idc_ok,
	copy_db_out(Parent,Lst_out),
  	retractall(notif_db(Parent,_,_)),
  	retract(notif_profname(Parent,ProfName_out)),
	dlg_notifdialog_update(VALLIST),!.

  notify_notifdialog_Create(_,_,notify_setts([],"")):-
	dlg_Note("Error: Fail in dlg_notifdialog_Create").

  dlg_notifdialog_update(_VALLIST):-
%BEGIN NotifDialog, Update controls, 13:19:02-26.11.1999, Code automatically updated!
	dialog_VLGetListBox(idc_notif_lst,_VALLIST,_NOTIF_LST_ITEMLIST,_NOTIF_LST_SELECT),
	_IDC_NOTIF_EL_VALUE = dialog_VLGetstr(idc_notif_el,_VALLIST),
	_IDC_NOTIF_KIND = dialog_VLGetRadiobutton(idc_notif_mess,_VALLIST),
%END NotifDialog, Update controls
	!.
  dlg_notifdialog_update(_):-
	dlg_Note("Error: Fail in dlg_notifdialog_update").

%MARK NotifDialog, new events

%BEGIN NotifDialog, idc_em_cfg _CtlInfo
  dlg_notifdialog_eh(_Win,e_Control(idc_em_cfg,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	idc_ok = dlg_choose_profile_name_Create(_Win, ProfileName),
	ParentWin = win_GetParent(_Win),
	retract(notif_profname(ParentWin,_)),
	assert(notif_profname(ParentWin,ProfileName)),
	!.
%END NotifDialog, idc_em_cfg _CtlInfo

%BEGIN NotifDialog, idc_help _CtlInfo
  dlg_notifdialog_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(hlp_wa_Notify_Persons_dialog),
	!.
%END NotifDialog, idc_help _CtlInfo

%BEGIN NotifDialog, e_Destroy
  dlg_notifdialog_eh(_Win,e_Destroy,0):-!.
%END NotifDialog, e_Destroy

%BEGIN NotifDialog, idc_notif_mail _CtlInfo
  dlg_notifdialog_eh(_Win,e_Control(idc_notif_mail,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	notif_set_text(_Win,idc_notif_mail),
	!.
%END NotifDialog, idc_notif_mail _CtlInfo

%BEGIN NotifDialog, idc_notif_mess _CtlInfo
  dlg_notifdialog_eh(_Win,e_Control(idc_notif_mess,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	notif_set_text(_Win,idc_notif_mess),
	!.
%END NotifDialog, idc_notif_mess _CtlInfo

%BEGIN NotifDialog, idc_notif_lst selchanged
  dlg_notifdialog_eh(_Win,e_Control(idc_notif_lst,_CtrlType,CtrlWin,selchanged),0):-!,
	Index = lbox_GetSelIndex(CtrlWin),
	Item = lbox_GetItem(CtrlWin, Index),
	ParentWin = win_GetParent(_Win),
	notif_db(ParentWin,Item,Code),
	notif_code(Code,Mode),
	dialog_SetStr(_Win,idc_notif_el,Item),
	dialog_SetRadiobutton(_Win,idc_notif_mess,Mode),
	notif_set_text(_Win,Mode),
	!.
%END NotifDialog, idc_notif_lst selchanged

%BEGIN NotifDialog, idc_notif_new _CtlInfo
  dlg_notifdialog_eh(_Win,e_Control(idc_notif_new,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	NA = dialog_GetStr(_Win,idc_notif_el),
	Mode = dialog_GetRadiobutton(_Win,idc_notif_mess),
	notif_code(Code,Mode),
	ParentWin = win_GetParent(_Win),
	assert(notif_db(ParentWin,NA,Code)),
	Lbnot_h = win_GetCtlHandle(_Win, idc_notif_lst),
	lbox_Suspend(Lbnot_h),
	lbox_Add(Lbnot_h, [NA]),
	NoOfItems = lbox_CountAll(Lbnot_h),
	NoOfItem = NoOfItems - 1,
	lbox_SetSel(Lbnot_h, NoOfItem, b_true),
	lbox_Resume(Lbnot_h),
	change_to_en(_Win,[idc_notif_del]),
	!.
%END NotifDialog, idc_notif_new _CtlInfo

%BEGIN NotifDialog, idc_notif_del _CtlInfo
  dlg_notifdialog_eh(_Win,e_Control(idc_notif_del,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	Item = dialog_GetStr(_Win,idc_notif_el),
  	Mode = dialog_GetRadiobutton(_Win,idc_notif_mess),
  	notif_code(Code,Mode),
  	ParentWin = win_GetParent(_Win),
  	retract(notif_db(ParentWin,Item,Code)),!,
	Lbnot_h = win_GetCtlHandle(_Win, idc_notif_lst),
	findall(Item1,notif_db(ParentWin,Item1,_), Items ),
	lbox_Suspend(Lbnot_h),
	lbox_Clear(Lbnot_h),
	lbox_Add(Lbnot_h, Items),
	lbox_SetSel(Lbnot_h, 0, b_true),
	lbox_Resume(Lbnot_h),
	notif_test_rest(_Win),
	!.
  dlg_notifdialog_eh(_Win,e_Control(idc_notif_del,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	dlg_error("Notify list does not contain such entry!"),
  	!.
%END NotifDialog, idc_notif_del _CtlInfo

%BEGIN NotifDialog, e_Create
  dlg_notifdialog_eh(_Win,e_Create(_CreationData),0):-
	notif_test_rest(_Win),
  	!.
%END NotifDialog, e_Create

%BEGIN NotifDialog, idc_notif_el modified
  dlg_notifdialog_eh(_Win,e_Control(idc_notif_el,_CtrlType,CtrlWin,modified),0):-
	Text = win_GetText(CtrlWin),
	Text = "",
	change_to_dis(_Win,[idc_notif_new]),	
	!.
  dlg_notifdialog_eh(_Win,e_Control(idc_notif_el,_CtrlType,CtrlWin,modified),0):-
	Text = win_GetText(CtrlWin),
	Text <> "",
	change_to_en(_Win,[idc_notif_new]),	
	!.	
%END NotifDialog, idc_notif_el modified

  dlg_notifdialog_eh(_,_,_):-!,fail.
  
%END_DLG NotifDialog

  notif_set_text(Win,idc_notif_mess):-
	Txt_h = win_GetCtlHandle(Win, idct_notif_name),
	win_SetText(Txt_h, "Computer name:"),!.
  notif_set_text(Win,idc_notif_mail):-
  	Txt_h = win_GetCtlHandle(Win, idct_notif_name),
	win_SetText(Txt_h, "E-mail address:"),!.

  notif_test_rest(_Win):-
  	Lbnot_h = win_GetCtlHandle(_Win, idc_notif_lst),
  	0 = lbox_CountAll(Lbnot_h),
	change_to_dis(_Win,[idc_notif_del,idc_notif_new]),
	dialog_SetStr(_Win,idc_notif_el,""),
	dialog_SetRadiobutton(_Win,idc_notif_mess,idc_notif_mess),
	!.
  notif_test_rest(_Win):-
  	Lbnot_h = win_GetCtlHandle(_Win, idc_notif_lst),
  	Item = lbox_GetItem(Lbnot_h, 0),
  	ParentWin = win_GetParent(_Win),
	notif_db(ParentWin,Item,Code),
	notif_code(Code,Mode),
  	dialog_SetStr(_Win,idc_notif_el,Item),
	dialog_SetRadiobutton(_Win,idc_notif_mess,Mode),
	notif_set_text(_Win,Mode),
	!.

  notif_code(0,idc_notif_mess):-!.
  notif_code(1,idc_notif_mail):-!.

  copy_db_out(Win,[]):-
  	not(notif_db(Win,_,_)),!.
  copy_db_out(Win,[notify(NameAddr,Mode)|L]):-
  	retract(notif_db(Win,NameAddr,Mode)),!,
  	copy_db_out(Win,L).
  copy_db_in(_,[]):-!.
  copy_db_in(Win,[notify(NameAddr,Mode)|L]):-
  	assert(notif_db(Win,NameAddr,Mode)),!,
  	copy_db_in(Win,L).

PREDICATES
  send_mess(NOTIFY_LIST,STRING) - (i,i)
  send_mail_adds(NOTIFY_LIST, MAPIRECIPDESC_LIST) - (i,o)
  procedure send_mail_msg(MAPIRECIPDESC_LIST ,STRING, STRING ) - (i,i,i)
  send_mail_check_RC( ULONG ) - (i)
  send_mess_check_RC( DWORD ) - (i)
  
  procedure email_getsubkeys( HKEY, DWORD, SLIST ) - (i,i,o)
  procedure email_getprofiles( SLIST ) 	- (o)
  email_checktest( LONG , STRING )	- (i,i)
  email_checkreg( LONG , STRING )	- (i,i)
  BOOLEAN check_RC_subkey( LONG )		- (i)
CLAUSES

  notify_send_notifications(Lst,Comm_a, ProfileName ):-
  	Comm_w = api_MultiByteToWideChar(api_cp_acp,[],Comm_a),
  	send_mess(Lst,Comm_w),
  	send_mail_adds(Lst,Recips),
  	send_mail_msg( Recips, Comm_a, ProfileName ).
  	
  send_mess([],_):-!.
  send_mess([notify(_,email_mode)|L],Comm):-!,
  	send_mess(L,Comm).
  send_mess([notify(Name_a,mess_mode)|L],Comm):-
  	Name_w = api_MultiByteToWideChar(api_cp_acp,[],Name_a),
  	RC = api_NetMessageBufferSend("",Name_w,"",Comm),
  	send_mess_check_RC( RC ),!,
  	send_mess(L,Comm).
	
  send_mail_adds([],[]):-!.
  send_mail_adds([notify(Address,email_mode)|L],[mapirecipdesc(0,sMAPI_CC,Address,SMTP_addr,0,NULL_EntryID)|Recips]):-
  	format(SMTP_addr, "SMTP:%s", Address),
  	NULL_EntryID = cast(BINARY, 0),!,
  	send_mail_adds(L,Recips).
  send_mail_adds([notify(_,mess_mode)|L],Recips):-!,
  	send_mail_adds(L,Recips).

  send_mail_msg( [], _, _ ):-!.
  send_mail_msg( Recips_list, Comment, ProfileName ):-
  	sMAPI_ConvRecipDesc_Array( Recips_list, Recips_ptr, Count ),
  	NULL_originator = cast( MAPIRECIPDESC_ARRAY, 0 ),
  	NULL_files = cast( MAPIFILEDESC_ARRAY, 0 ),
  	RC0 = sMAPI_Logon( 0, ProfileName, "", [], Hndl ),	%??? Password ???
	send_mail_check_RC( RC0 ),
  	RC1 = sMAPI_SendMail( Hndl, 0, mapimessage(0, Comment, "", "", "", "", 0, NULL_originator,Count,Recips_ptr,0,NULL_files), [] ),
  	RC2 = sMAPI_Logoff( Hndl, 0 ),
  	send_mail_check_RC( RC1 ),
  	send_mail_check_RC( RC2 ),
  	!.
  send_mail_msg( _, _, _ ).  	

  send_mess_check_RC ( 0 ):-!.
  send_mess_check_RC ( ErrCode ):-
	wa_errproc(300,ErrCode).
	
  send_mail_check_RC( sMAPI_SUCCESS_SUCCESS ):-!.
  send_mail_check_RC( ErrCode ):-
  	wa_errproc(301,ErrCode),fail.

  check_RC_subkey( 0, b_true ):-!.
  check_RC_subkey( 259, b_false ):-!.	% NO_ITEMS
  check_RC_subkey( Err, b_false ):-
  	format( Str, "Enumerating Registry Keys failure - error %U", Err),
  	dlg_error( Str ),fail.

  email_getsubkeys( Key, Index, [ SubKey| L ] ):-
	RC = api_RegEnumKey( Key, Index, Subkey ),
	b_true = check_RC_subkey( RC ),
	NewIndex = Index + 1,!,
	email_getsubkeys( Key, NewIndex, L ).
  email_getsubkeys( _, _, [] ).
  	
  email_getprofiles( Res ):-
	RC1 = api_RegOpenKey(api_HKEY_CURRENT_USER, "Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows Messaging Subsystem\\Profiles", Key ),
	email_checkReg( RC1, "Open Registry Key" ),
	email_getsubkeys( Key, 0, Res ),
	RC3 = api_RegCloseKey( Key ),
	email_checkReg( RC3, "Close Registry Key" ),!.
  email_getprofiles( [] ).
  
  email_checktest( sMAPI_SUCCESS_SUCCESS, _ ):-!.
  email_checktest( Err, Text ):-
  	format( Str, " %s failure - error %U",Text, Err),
  	dlg_error( Str ),fail.
  	
  email_checkReg( 0, _ ):-!.
  email_checkReg( Err, Text ):-
  	format( Str, " %s failure - error %U",Text, Err),
  	dlg_error( Str ),fail.
  	
%BEGIN_DLG Choose Profile Name
/**************************************************************************
	Creation and event handling for dialog: Choose Profile Name
**************************************************************************/

CONSTANTS

%BEGIN Choose Profile Name, CreateParms, 13:18:40-26.11.1999, Code automatically updated!
  dlg_choose_profile_name_ResID = idd_choose_profile_name
  dlg_choose_profile_name_DlgType = wd_Modal
  dlg_choose_profile_name_Help = idh_contents
%END Choose Profile Name, CreateParms

PREDICATES

  dlg_choose_profile_name_eh : EHANDLER
  dlg_choose_profile_name_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST, STRING) - (i,i,o)
%  dlg_choose_profile_name_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_choose_profile_name_Create(Parent, ProfileName, ANSWER ):-
	email_getprofiles( IDC_PROFILES_ITEMLIST ),
	IDC_PROFILES_SELECT = 0,
%MARK Choose Profile Name, new variables

	dialog_CreateModal(Parent,dlg_choose_profile_name_ResID,"",
  		[
%BEGIN Choose Profile Name, ControlList, 13:18:40-26.11.1999, Code automatically updated!
		df(idc_profiles,listbutton(IDC_PROFILES_ITEMLIST,IDC_PROFILES_SELECT),nopr)
%END Choose Profile Name, ControlList
		],
		dlg_choose_profile_name_eh,0,VALLIST,ANSWER),
	dlg_choose_profile_name_handle_answer(ANSWER,VALLIST, ProfileName).

  dlg_choose_profile_name_handle_answer( idc_ok, VALLIST, IDC_PROFILES_ITEM ):-!,
	dialog_VLGetListButton( idc_profiles, VALLIST, IDC_PROFILES_ITEM, _ ).
  dlg_choose_profile_name_handle_answer(idc_cancel,_,""):-!.  % Handle Esc and Cancel here
  dlg_choose_profile_name_handle_answer(_,_,""):-
	errorexit().

%  dlg_choose_profile_name_update(_VALLIST):-
%BEGIN Choose Profile Name, Update controls, 13:18:40-26.11.1999, Code automatically updated!
%	dialog_VLGetListButton(idc_profiles,_VALLIST,_IDC_PROFILES_ITEMLIST,_IDC_PROFILES_SELECT),
%END Choose Profile Name, Update controls
%	true.

%MARK Choose Profile Name, new events

%BEGIN Choose Profile Name, idc_test _CtlInfo
  dlg_choose_profile_name_eh(_Win,e_Control(idc_test,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	CtrlWin = win_GetCtlHandle( _Win, idc_profiles ),
	ProfileName = win_GetText( CtrlWin ),
	RC = sMAPI_Logon( 0, ProfileName, "", [], Hndl ),	%??? Password ???
	email_checktest( RC, "Logon" ),
	RC1 = sMAPI_Logoff( Hndl, 0 ),
	email_checktest( RC1, "Logoff" ),
	dlg_note( "Test successfully passed!" ),
	!.
%END Choose Profile Name, idc_test _CtlInfo

  dlg_choose_profile_name_eh(_,_,_):-!,fail.

%END_DLG Choose Profile Name







