/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  HTTP32
 FileName: HTTP32.PRO
 Purpose: Example of HTTP Layer
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/

include "http.inc"
include "http.con"
include "hlptopic.con"

CONSTANTS
  http_port=80
  app_mes=0xC499
ifdef platform_16bit
  helpFileName = "http16.hlp"
elsedef
  helpFileName = "http32.hlp"
enddef
  
GLOBAL PREDICATES
  change_to_en(WINDOW,ILIST)
  change_to_dis(WINDOW,ILIST)
  change_mode(WINDOW, INTEGER,BOOLEAN)
  change_mode_lst(WINDOW, ILIST)  
  change_font(WINDOW,ILIST)
  modify_ini(httplay_response,DIALOG_FIELD_LIST,DIALOG_FIELD_LIST) - (i,i,o)

DATABASE - int
  ex_win(WINDOW)
  parent(WINDOW)

DOMAINS
  CLIST = CHAR*

PREDICATES
  ex_init()
  ex_event_eh : ehandler
  ex_proc_answ(httplay_answers)
CLAUSES
  ex_init():-
        not(ex_win(_)),
        ScreenWindow = cast(window,vpi_GetAttrVal(attr_screen_window)),
        WinDefs = [dlg(wdef(wd_ModeLess,rct(0,0,0,0),"",u_Pixels),[wsf_Invisible,wsf_Disabled])],
        CreateData = cast(long,0),
        win_CreateDynDialog(ScreenWindow,WinDefs,ex_event_eh,CreateData),
        !.
  ex_init().

  ex_event_eh(Win,e_Create(_),0):-
        assert(ex_win(Win)),
        win_EnableHook(Win, b_true),
        !.
  ex_event_eh(_Win,e_Native(app_mes,_WParam,_LParam),0):-
        httplay_GetAnswer(Answ),!,
	ex_proc_answ(Answ),
        !.

  ex_proc_answ(ok(_Req,simple_resp(Body_lst))):-
 	parent(Win),
	dlg_view_response_Create(Win,"View Simple Response",simple_resp(Body_lst)),!.
  ex_proc_answ(ok(_Req,Resp)):-
	parent(Win),
	dlg_view_response_Create(Win,"View Full Response",Resp),!. 	
  ex_proc_answ(httplay_error(_Req,Err)):-
  	errormsg("http.err",Err, Msg1, _ ),
 	format( Str,"Error occured: %U; %s", Err, Msg1 ),
 	dlg_error(Str),!.

PREDICATES
  strip_leading_spaces(STRING,STRING) - (i,o)
  strip_last_spaces(STRING,STRING) - (i,o)
  reverse(STRING,STRING) - (i,o)
  trim(STRING,STRING) - (i,o)
  BOOLEAN parse_comment(STRING,product_version) - (i,o)
  BOOLEAN parse_comm(STRING,CLIST,INTEGER,INTEGER)
  is_empty(CLIST,STRING,INTEGER)  
  parse_sep(STRING,CHAR,SLIST)
  form_req(DIALOG_VAL_LIST)  
  form_line(DIALOG_VAL_LIST,request_line)
  form_heads(DIALOG_VAL_LIST,headers_0)
  form_add_heads(DIALOG_VAL_LIST,ILIST,headers_0)
  create_header(DIALOG_VAL_LIST,INTEGER,headers)
  form_body(DIALOG_VAL_LIST,entity_body_0)
%  is_prod_comm(SLIST,product_version)
  form_referer(STRING,httplay_URI)
  form_rel_path(STRING,STRING,SLIST,STRING)
  map_HeaderName( INTEGER, STRING )		- (i,o)
CLAUSES

  strip_leading_spaces(STR,STR2):-
        frontchar(STR,' ',St1),!,
        strip_leading_spaces(St1,STR2).
  strip_leading_spaces(STR,STR).
  
  strip_last_spaces(Str,Str3):-
  	reverse(Str,Str1),
  	strip_leading_spaces(Str1,Str2),
  	reverse(Str2,Str3),!.
  
  reverse("",""):-!.
  reverse(Str,Str1):-
	frontstr(1,Str,StartString,RestString),
	reverse(RestString,Rest),!,
	concat(Rest,StartString,Str1).
  	
  trim(Str,Str2):-
  	strip_leading_spaces(Str,Str1),
  	strip_last_spaces(Str1,Str2),!.
  
  parse_sep("",_,[]):-!.
  parse_sep(In,Sep,L1):-
  	frontchar(In,Sep,Rest),!,
  	parse_sep(Rest,Sep,L1).
  parse_sep(In,Sep,[El|L1]):-
  	searchchar(In,Sep,FoundPos),!,
  	FP = FoundPos - 1,
  	frontstr(FP,In,Ell,RestString),
  	strip_leading_spaces(Ell,El),!,
  	parse_sep(Reststring,Sep,L1).
  parse_sep(In,Sep,[In]):-
	not(searchchar(In,Sep,_)),!.
  
  parse_comment("",[],0):-!.
  parse_comment(In,[prod(In1)],0):-
	not(searchchar(In,'(',_)),
	not(searchchar(In,' ',_)),
	trim(In,In1),!.
  parse_comment(Inn,[comm(Cm)|L],Rs):-
  	trim(Inn,In),
  	frontchar(In,'(',_),!,
  	R = parse_comm(In,[],0,Len),
  	R = 0,!,
  	frontstr(Len,In,Cm1,Rest),
  	trim(Cm1,Cm),!,
  	Rs = parse_comment(Rest,L).
  parse_comment(In,[prod(Pr)|L],R):-
  	searchchar(In,'(',FoundPos),
  	FP =FoundPos - 1,
	frontstr(FP,In,Pr1,Rest),
	trim(Pr1,Pr),!,
	R = parse_comment(Rest,L).
  parse_comment(In,[prod(Pr)|L],R):-
  	searchchar(In,' ',FoundPos),
  	FP =FoundPos - 1,
	frontstr(FP,In,Pr1,Rest),
	trim(Pr1,Pr),
	frontchar(Rest,_,Rst),!,
	R = parse_comment(Rst,L).
  parse_comment(_,[],1).
	
  parse_comm("",_,_,1,1):-!.
  parse_comm(In,L_char,L_b,L1,R):-
	frontchar(In,FrontChar,RestString),
	FrontChar = '(',
	R = parse_comm(RestString,['('|L_char],1,Res),
	R = 0,
	frontstr(Res,In,_,Rest),
	is_empty(L_char,Rest,Rs),
	L1 = Res + Rs + L_b,!.
  parse_comm(In,['('|_],Cnt,C,0):-
  	frontchar(In,FrontChar,_),
  	FrontChar = ')',
  	C = Cnt + 1,!.
  parse_comm(In,L_char,Cn,C,R):-
  	frontchar(In,_,RestString),
  	Cnt = Cn + 1,!,
  	R = parse_comm(RestString,L_char,Cnt,C).
  parse_comm(_,_,_,0,1).	
  
  is_empty([],_,0):-!.
  is_empty(L,Rest,Res):-
  	parse_comm(Rest,L,0,Res).

  form_req(_VALLIST):-
	idc_s_req = dialog_VLGetRadiobutton(idc_f_req,_VALLIST),!,
	_IDC_SERV_VALUE = dialog_VLGetstr(idc_serv,_VALLIST),
	_IDC_RES_VALUE = dialog_VLGetstr(idc_res,_VALLIST),
	Params_str = dialog_VLGetstr(idc_res_par,_VALLIST),
	Query = dialog_VLGetstr(idc_res_query,_VALLIST),
	_IDC_PORT_VALUE = dialog_VLGetlong(idc_port,_VALLIST),
 	ex_win(H_win),
 	_IDC_PORT_VALUE = l( Port_l ),
 	Port = val( USHORT, Port_l ),
% parameters must be devided by ';'
	parse_sep(Params_str,';',Params_lst),
	httplay_SendRequests(H_win,app_mes,_IDC_SERV_VALUE,Port,[simple_req(rel_path(_IDC_RES_VALUE,Params_lst,Query))],1),!.
  form_req(_VALLIST):-
  	form_line(_VALLIST,Req_line),
  	form_heads(_VALLIST,Heads),
  	form_body(_VALLIST,Body),
  	ex_win(H_win),
  	_IDC_SERV_VALUE = dialog_VLGetstr(idc_serv,_VALLIST),
  	_IDC_PORT_VALUE = dialog_VLGetlong(idc_port,_VALLIST),
  	_IDC_PORT_VALUE = l( Port_l ),
  	Port = val( USHORT, Port_l ),
  	httplay_SendRequests(H_win,app_mes,_IDC_SERV_VALUE,Port,[full_req(Req_line,Heads,Body)],1),!.

  form_line(_VALLIST,req_line(Meth,rel_path(_IDC_RES_VALUE,Params_lst,Query),http_ver(Major,Minor))):-
	dialog_VLGetListButton(idc_meth,_VALLIST,Meth,_),
	_IDC_RES_VALUE = dialog_VLGetstr(idc_res,_VALLIST),
	Params_str = dialog_VLGetstr(idc_res_par,_VALLIST),
	Query = dialog_VLGetstr(idc_res_query,_VALLIST),
% parameters must be devided by ';'
	parse_sep(Params_str,';',Params_lst),	
	_IDC_VER_MAJOR_VALUE = dialog_VLGetint(idc_ver_major,_VALLIST),
	_IDC_VER_MINOR_VALUE = dialog_VLGetint(idc_ver_minor,_VALLIST),
	_IDC_VER_MAJOR_VALUE = i(Major),
	_IDC_VER_MINOR_VALUE = i(Minor),!.

  form_heads(_VALLIST,L_heads):-
  	form_add_heads(_VALLIST,[idc_date,idc_pragma,idc_authorization,idc_from,idc_ifm,idc_referer,idc_ua,
  				 idc_allow,idc_contentencoding,idc_contentlength,idc_contenttype,idc_lm,idc_expires],L_heads),!.
  				 
  form_add_heads(_,[],[]):-!.
  form_add_heads(_VALLIST,[El|L_ch_head],[Head|Lst]):-
	b_true = dialog_VLGetCheck(El,_VALLIST),!,
	create_header(_VALLIST,El,Head),
  	form_add_heads(_VALLIST,L_ch_head,Lst).
  form_add_heads(_VALLIST,[_|L_ch_head],Lst):-
  	form_add_heads(_VALLIST,L_ch_head,Lst).
  	
  create_header(_VALLIST,idc_date,date_0(http_date(WeekDay,date(Day,Month,Year),time(Hours,Minutes,Seconds)))):-
  	_IDC_GH_D_Y_VALUE = dialog_VLGetint(idc_gh_d_y,_VALLIST),
	_IDC_GH_D_D_VALUE = dialog_VLGetint(idc_gh_d_d,_VALLIST),
	Weekday = dialog_VLGetstr(idc_gh_d_wd,_VALLIST),
	Month = dialog_VLGetstr(idc_gh_d_m,_VALLIST),
	_IDC_GH_D_H_VALUE = dialog_VLGetint(idc_gh_d_h,_VALLIST),
	_IDC_GH_D_MIN_VALUE = dialog_VLGetint(idc_gh_d_min,_VALLIST),
	_IDC_GH_D_S_VALUE = dialog_VLGetint(idc_gh_d_s,_VALLIST),
	_IDC_GH_D_Y_VALUE = i(Year),
	_IDC_GH_D_D_VALUE = i(Day),
	_IDC_GH_D_H_VALUE = i(Hours),
	_IDC_GH_D_MIN_VALUE = i(Minutes),
	_IDC_GH_D_S_VALUE = i(Seconds),!.
  create_header(_VALLIST,idc_pragma,pragma(Lst)):-
% params must be divided by , (comma)
	_IDC_GH_PRAGMA_VALUE = dialog_VLGetstr(idc_gh_pragma,_VALLIST),
	parse_sep(_IDC_GH_PRAGMA_VALUE,',',Lst),
  	!.
  create_header(_VALLIST,idc_authorization,authorization(basic_credentials(Basic_cookie))):-
	b_true = dialog_VLGetCheck(idc_rh_a_basic,_VALLIST),
	Basic_cookie = dialog_VLGetstr(idc_rh_a_par,_VALLIST),!.
  create_header(_VALLIST,idc_authorization,authorization(authoriz(Sheme,Lst))):-
% params must be divided by , (comma)
  	Params = dialog_VLGetstr(idc_rh_a_par,_VALLIST),
  	parse_sep(Params,',',Lst),
	Sheme = dialog_VLGetstr(idc_rh_a_sheme,_VALLIST),!.
  create_header(_VALLIST,idc_from,from(Mailbox)):-
	Mailbox = dialog_VLGetstr(idc_rh_from,_VALLIST),!.
  create_header(_VALLIST,idc_ifm,if_modified_since(http_date(WeekDay,date(Day,Month,Year),time(Hours,Minutes,Seconds)))):-
	_IDC_RH_IFM_Y_VALUE = dialog_VLGetint(idc_rh_ifm_y,_VALLIST),
	_IDC_RH_IFM_D_VALUE = dialog_VLGetint(idc_rh_ifm_d,_VALLIST),
	Weekday = dialog_VLGetstr(idc_rh_ifm_wd,_VALLIST),
	Month = dialog_VLGetstr(idc_rh_ifm_m,_VALLIST),
	_IDC_RH_IFM_H_VALUE = dialog_VLGetint(idc_rh_ifm_h,_VALLIST),
	_IDC_RH_IFM_MIN_VALUE = dialog_VLGetint(idc_rh_ifm_min,_VALLIST),
	_IDC_RH_IFM_S_VALUE = dialog_VLGetint(idc_rh_ifm_s,_VALLIST),
	_IDC_RH_IFM_Y_VALUE = i(Year),
	_IDC_RH_IFM_D_VALUE = i(Day),
	_IDC_RH_IFM_H_VALUE = i(Hours),
	_IDC_RH_IFM_MIN_VALUE = i(Minutes),
	_IDC_RH_IFM_S_VALUE = i(Seconds),!.
  create_header(_VALLIST,idc_referer,referer(Uri_kind)):-
	Whole = dialog_VLGetstr(idc_rh_refer,_VALLIST),
	form_referer(Whole,Uri_kind),
	!.
  create_header(_VALLIST,idc_ua,user_agent(Res)):-
	Inf = dialog_VLGetstr(idc_rh_ua,_VALLIST),
% information must be divided by ' ' (spaces)
	R = parse_comment(Inf,Res),
	R = 0,
	!.
  create_header(_VALLIST,idc_allow,allow(Lst)):-
% methods must be divided by , (comma)  
	Meths = dialog_VLGetstr(idc_eh_allow,_VALLIST),
	parse_sep(Meths,',',Lst),
	!.
  create_header(_VALLIST,idc_contentencoding,content_encoding(Code)):-
  	Code = dialog_VLGetstr(idc_eh_ce,_VALLIST),!.
  create_header(_VALLIST,idc_contentlength,content_length(Len)):-
	_IDC_EH_CL_VALUE = dialog_VLGetlong(idc_eh_cl,_VALLIST),
	_IDC_EH_CL_VALUE = l(Len),!.
  create_header(_VALLIST,idc_contenttype,content_type(Type,SubType,Lst)):-
	Type = dialog_VLGetstr(idc_eh_ct_type,_VALLIST),
	SubType = dialog_VLGetstr(idc_eh_ct_stype,_VALLIST),
	Params = dialog_VLGetstr(idc_eh_ct_par,_VALLIST),
% methods must be divided by ;
	parse_sep(Params,';',Lst),
	!.
  create_header(_VALLIST,idc_lm,last_modified(http_date(WeekDay,date(Day,Month,Year),time(Hours,Minutes,Seconds)))):-
	_IDC_EH_LM_S_VALUE = dialog_VLGetint(idc_eh_lm_s,_VALLIST),
	_IDC_EH_LM_MIN_VALUE = dialog_VLGetint(idc_eh_lm_min,_VALLIST),
	_IDC_EH_LM_H_VALUE = dialog_VLGetint(idc_eh_lm_h,_VALLIST),
	Month = dialog_VLGetstr(idc_eh_lm_m,_VALLIST),
	Weekday = dialog_VLGetstr(idc_eh_lm_wd,_VALLIST),
	_IDC_EH_LM_D_VALUE = dialog_VLGetint(idc_eh_lm_d,_VALLIST),
	_IDC_EH_LM_Y_VALUE = dialog_VLGetint(idc_eh_lm_y,_VALLIST),
	_IDC_EH_LM_Y_VALUE = i(Year),
	_IDC_EH_LM_D_VALUE = i(Day),
	_IDC_EH_LM_H_VALUE = i(Hours),
	_IDC_EH_LM_MIN_VALUE = i(Minutes),
	_IDC_EH_LM_S_VALUE = i(Seconds),
	!.
  create_header(_VALLIST,idc_expires,expires(http_date(WeekDay,date(Day,Month,Year),time(Hours,Minutes,Seconds)))):-
	_IDC_EH_E_Y_VALUE = dialog_VLGetint(idc_eh_e_y,_VALLIST),
	_IDC_EH_E_D_VALUE = dialog_VLGetint(idc_eh_e_d,_VALLIST),
	Weekday = dialog_VLGetstr(idc_eh_e_wd,_VALLIST),
	Month = dialog_VLGetstr(idc_eh_e_m,_VALLIST),
	_IDC_EH_E_H_VALUE = dialog_VLGetint(idc_eh_e_h,_VALLIST),
	_IDC_EH_E_MIN_VALUE = dialog_VLGetint(idc_eh_e_min,_VALLIST),
	_IDC_EH_E_S_VALUE = dialog_VLGetint(idc_eh_e_s,_VALLIST),
	_IDC_EH_E_Y_VALUE = i(Year),
	_IDC_EH_E_D_VALUE = i(Day),
	_IDC_EH_E_H_VALUE = i(Hours),
	_IDC_EH_E_MIN_VALUE = i(Minutes),
	_IDC_EH_E_S_VALUE = i(Seconds),!.
  create_header(_,Hdr_Con,_):-
  	map_HeaderName( Hdr_Con, Header_name ),
  	format( Str, "Error creating header %s", Header_name ),
  	dlg_Error( Str ),fail.
  
  map_HeaderName(idc_date,"Date"):-!.
  map_HeaderName(idc_pragma,"Pragma"):-!.
  map_HeaderName(idc_authorization,"Authorization"):-!.
  map_HeaderName(idc_from,"From"):-!.
  map_HeaderName(idc_ifm,"If-Mod-Since"):-!.
  map_HeaderName(idc_referer,"Referer"):-!.
  map_HeaderName(idc_ua,"User-Agent"):-!.
  map_HeaderName(idc_allow,"Allow"):-!.
  map_HeaderName(idc_contentencoding,"Content-Encoding"):-!.
  map_HeaderName(idc_contentlength,"Content-Length"):-!.
  map_HeaderName(idc_contenttype,"Content-Type"):-!.
  map_HeaderName(idc_lm,"Last-Modified"):-!.
  map_HeaderName(idc_expires,"Expires"):-!.
  
/*  is_prod_comm([],[]):-!.
  is_prod_comm([El|L],[prod(El)|L1]):-
	not(frontchar(El,'(',_)),!,
  	is_prod_comm(L,L1).
  is_prod_comm([El|L],[comm(El)|L1]):-
  	frontchar(El,'(',_),!,
  	is_prod_comm(L,L1).*/
  
  form_referer(In,absoluteURI(Sheme,URI)):-
	searchchar(In,':',FoundPos),
	FP = FoundPos - 1,
	frontstr(FP,In,Sheme,RestString),  % not very right 'cause ':' maybe at a params or query
	frontchar(RestString,_,URI),!.
  form_referer(In,rel_path(Rel_path,Params,Query)):-
  	form_rel_path(In,Rel_path,Params,Query),!.
  
  form_rel_path(In,Rel_path,Params,Query):-
	searchchar(In,'?',FoundPos),
	FP = FoundPos - 1,
	frontstr(FP,In,Rel_par,Query1),
	frontchar(Query1,_,Query),
  	parse_sep(Rel_par,';',Lst),
  	Lst = [Rel_path|Params],!.
  form_rel_path(In,Rel_path,Params,""):-
  	parse_sep(In,';',Lst),
  	Lst = [Rel_path|Params],!.
  	
  form_body(_VALLIST,[]):-
	b_false = dialog_VLGetCheck(idc_entity_body1,_VALLIST),!.
  form_body(_VALLIST,[entity_body(Bin)]):-
	FileName = dialog_VLGetstr(idc_eb_body,_VALLIST),
	trap(openread(file_read,FileName),_,dlg_error("Can not open file for entity body!")),
	readdevice(Old),
	readdevice(file_read),
	readblock(0,Bin),
	readdevice(Old),
	closefile(file_read),!.
  	
	
%BEGIN_WIN Task Window
/***************************************************************************
        Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 10:03:30-26.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_Maximized]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "HTTP"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 10:03:30-26.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 10:03:30-26.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
        msg_Create(100),
ENDDEF
	ex_init(),
	assert(parent(_Win)),
        !.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	project_ShowHelpContext(task_win_Help),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest,0):-
  	httplay_CloseSession(),fail.
%END Task Window, e_CloseRequest

%BEGIN Task Window, id_form_req
  task_win_eh(Win,e_Menu(id_form_req,_ShiftCtlAlt),0):-!,
	dlg_format_request_Create(Win),
	!.
%END Task Window, id_form_req

%BEGIN Task Window, id_exit
  task_win_eh(Win,e_Menu(id_exit,_ShiftCtlAlt),0):-!,
        win_Destroy(Win),
        httplay_CloseSession(),
	!.
%END Task Window, id_exit


%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
        dlg_about_dialog_Create(Win),
        !.
%END Task Window, id_help_about

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
        vpi_ShowHelpContext("http_w16.hlp",HelpTopic),
elsedef
        vpi_ShowHelpContext("http.hlp",HelpTopic),
enddef
        !.

/***************************************************************************
        Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
ENDDEF
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"http32",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
        Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 13:48:12-26.11.1999, Code automatically updated!
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

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog

%BEGIN_DLG Format Request
/**************************************************************************
	Creation and event handling for dialog: Format Request
**************************************************************************/

CONSTANTS

%BEGIN Format Request, CreateParms, 10:03:04-26.11.1999, Code automatically updated!
  dlg_format_request_ResID = idd_form_req
  dlg_format_request_DlgType = wd_Modal
  dlg_format_request_Help = idh_format_request
%END Format Request, CreateParms

PREDICATES

  dlg_format_request_eh : EHANDLER
  dlg_format_request_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_format_request_Create(Parent):-

%MARK Format Request, new variables

	dialog_CreateModal(Parent,dlg_format_request_ResID,"",
  		[
%BEGIN Format Request, ControlList, 10:03:04-26.11.1999, Code automatically updated!
		df(idc_serv,editstr("spb_nt_server",[mandatory]),nopr),
		df(idc_port,editlong(l(80),[mandatory,minimum(0)]),dlg_prompt(idct_port)),
		df(idc_meth,listbutton(["GET","HEAD","POST"],0),nopr),
		df(idc_ver_major,editint(i(1),[minimum(0)]),str_prompt("Major version number")),
		df(idc_ver_minor,editint(i(0),[minimum(0)]),str_prompt("Minor version number")),
		df(idc_res,editstr("",[mandatory]),nopr),
		df(idc_res_par,editstr("",[]),nopr),
		df(idc_res_query,editstr("",[]),nopr),
		df(idc_date,checkbox(b_false),nopr),
		df(idc_gh_d_wd,editstr("",[default(""),length(3)]),nopr),
		df(idc_gh_d_d,editint(void,[range(1,31)]),str_prompt("Day")),
		df(idc_gh_d_m,editstr("",[default(""),length(3)]),nopr),
		df(idc_gh_d_y,editint(void,[range(1980,3000)]),str_prompt("Year")),
		df(idc_gh_d_h,editint(void,[range(0,23)]),str_prompt("Hour")),
		df(idc_gh_d_min,editint(void,[range(0,59)]),str_prompt("Minute")),
		df(idc_gh_d_s,editint(void,[range(0,59)]),str_prompt("Second")),
		df(idc_pragma,checkbox(b_false),nopr),
		df(idc_gh_pragma,editstr("",[default("")]),nopr),
		df(idc_authorization,checkbox(b_false),nopr),
		df(idc_rh_a_basic,checkbox(b_false),nopr),
		df(idc_rh_a_sheme,editstr("",[default("")]),nopr),
		df(idc_rh_a_par,editstr("",[default("")]),nopr),
		df(idc_from,checkbox(b_false),nopr),
		df(idc_rh_from,editstr("",[default("")]),nopr),
		df(idc_ifm,checkbox(b_false),nopr),
		df(idc_rh_ifm_wd,editstr("",[default(""),length(3)]),nopr),
		df(idc_rh_ifm_d,editint(void,[range(1,31)]),str_prompt("Day")),
		df(idc_rh_ifm_m,editstr("",[default(""),length(3)]),nopr),
		df(idc_rh_ifm_y,editint(void,[range(1980,3000)]),str_prompt("Year")),
		df(idc_rh_ifm_h,editint(void,[range(0,23)]),str_prompt("Hour")),
		df(idc_rh_ifm_min,editint(void,[range(0,59)]),str_prompt("Minute")),
		df(idc_rh_ifm_s,editint(void,[range(0,59)]),str_prompt("Second")),
		df(idc_referer,checkbox(b_false),nopr),
		df(idc_rh_refer,editstr("",[default("")]),nopr),
		df(idc_ua,checkbox(b_false),nopr),
		df(idc_rh_ua,editstr("",[default("")]),nopr),
		df(idc_allow,checkbox(b_false),nopr),
		df(idc_eh_allow,editstr("",[]),nopr),
		df(idc_contentencoding,checkbox(b_false),nopr),
		df(idc_eh_ce,editstr("",[]),nopr),
		df(idc_contentlength,checkbox(b_false),nopr),
		df(idc_eh_cl,editlong(void,[]),nopr),
		df(idc_contenttype,checkbox(b_false),nopr),
		df(idc_eh_ct_type,editstr("",[]),nopr),
		df(idc_eh_ct_stype,editstr("",[]),nopr),
		df(idc_eh_ct_par,editstr("",[]),nopr),
		df(idc_expires,checkbox(b_false),nopr),
		df(idc_eh_e_wd,editstr("",[]),nopr),
		df(idc_eh_e_d,editint(void,[]),nopr),
		df(idc_eh_e_m,editstr("",[]),nopr),
		df(idc_eh_e_y,editint(void,[]),nopr),
		df(idc_eh_e_h,editint(void,[]),nopr),
		df(idc_eh_e_min,editint(void,[]),nopr),
		df(idc_eh_e_s,editint(void,[range(0,59)]),str_prompt("Second")),
		df(idc_lm,checkbox(b_false),nopr),
		df(idc_eh_lm_wd,editstr("",[]),nopr),
		df(idc_eh_lm_d,editint(void,[]),nopr),
		df(idc_eh_lm_m,editstr("",[]),nopr),
		df(idc_eh_lm_y,editint(void,[]),nopr),
		df(idc_eh_lm_h,editint(void,[]),nopr),
		df(idc_eh_lm_min,editint(void,[]),nopr),
		df(idc_eh_lm_s,editint(void,[range(0,59)]),str_prompt("Second")),
		df(idc_entity_body1,checkbox(b_false),nopr),
		df(idc_eb_body,editstr("",[default("")]),nopr),
		df(idc_f_req,radiobuttongroup([idc_f_req,idc_s_req]),nopr)
%END Format Request, ControlList
		],
		dlg_format_request_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_format_request_update(VALLIST),
	form_req(VALLIST),
	!.

  dlg_format_request_update(_VALLIST):-!,
%BEGIN Format Request, Update controls, 10:03:04-26.11.1999, Code automatically updated!
	_IDC_SERV_VALUE = dialog_VLGetstr(idc_serv,_VALLIST),
	_IDC_RES_VALUE = dialog_VLGetstr(idc_res,_VALLIST),
	_IDC_PORT_VALUE = dialog_VLGetlong(idc_port,_VALLIST),
	_IDC_GH_D_Y_VALUE = dialog_VLGetint(idc_gh_d_y,_VALLIST),
	_IDC_GH_D_D_VALUE = dialog_VLGetint(idc_gh_d_d,_VALLIST),
	_IDC_GH_D_WD_VALUE = dialog_VLGetstr(idc_gh_d_wd,_VALLIST),
	_IDC_GH_D_M_VALUE = dialog_VLGetstr(idc_gh_d_m,_VALLIST),
	_IDC_GH_D_H_VALUE = dialog_VLGetint(idc_gh_d_h,_VALLIST),
	_IDC_GH_D_MIN_VALUE = dialog_VLGetint(idc_gh_d_min,_VALLIST),
	_IDC_GH_D_S_VALUE = dialog_VLGetint(idc_gh_d_s,_VALLIST),
	_IDC_GH_PRAGMA_VALUE = dialog_VLGetstr(idc_gh_pragma,_VALLIST),
	_IDC_VER_MAJOR_VALUE = dialog_VLGetint(idc_ver_major,_VALLIST),
	_IDC_VER_MINOR_VALUE = dialog_VLGetint(idc_ver_minor,_VALLIST),
	_IDC_RH_IFM_Y_VALUE = dialog_VLGetint(idc_rh_ifm_y,_VALLIST),
	_IDC_RH_IFM_D_VALUE = dialog_VLGetint(idc_rh_ifm_d,_VALLIST),
	_IDC_RH_IFM_WD_VALUE = dialog_VLGetstr(idc_rh_ifm_wd,_VALLIST),
	_IDC_RH_IFM_M_VALUE = dialog_VLGetstr(idc_rh_ifm_m,_VALLIST),
	_IDC_RH_IFM_H_VALUE = dialog_VLGetint(idc_rh_ifm_h,_VALLIST),
	_IDC_RH_IFM_MIN_VALUE = dialog_VLGetint(idc_rh_ifm_min,_VALLIST),
	_IDC_RH_IFM_S_VALUE = dialog_VLGetint(idc_rh_ifm_s,_VALLIST),
	_IDC_EH_E_S_VALUE = dialog_VLGetint(idc_eh_e_s,_VALLIST),
	_IDC_RH_A_BASIC_CHECKED = dialog_VLGetCheck(idc_rh_a_basic,_VALLIST),
	_IDC_RH_A_SHEME_VALUE = dialog_VLGetstr(idc_rh_a_sheme,_VALLIST),
	_IDC_RH_A_PAR_VALUE = dialog_VLGetstr(idc_rh_a_par,_VALLIST),
	_IDC_RH_FROM_VALUE = dialog_VLGetstr(idc_rh_from,_VALLIST),
	_IDC_RH_REFER_VALUE = dialog_VLGetstr(idc_rh_refer,_VALLIST),
	_IDC_RH_UA_VALUE = dialog_VLGetstr(idc_rh_ua,_VALLIST),
	_IDC_EH_LM_S_VALUE = dialog_VLGetint(idc_eh_lm_s,_VALLIST),
	_IDC_EB_BODY_VALUE = dialog_VLGetstr(idc_eb_body,_VALLIST),
	dialog_VLGetListButton(idc_meth,_VALLIST,_IDC_METH_ITEMLIST,_IDC_METH_SELECT),
	_IDC_USERAGENT_CHECKED = dialog_VLGetCheck(idc_ua,_VALLIST),
	_IDC_REFERER_CHECKED = dialog_VLGetCheck(idc_referer,_VALLIST),
	_IDC_IFMODIFIEDSINCE_CHECKED = dialog_VLGetCheck(idc_ifm,_VALLIST),
	_IDC_CHECK_BOX_CHECKED = dialog_VLGetCheck(idc_from,_VALLIST),
	_IDC_DATE_CHECKED = dialog_VLGetCheck(idc_date,_VALLIST),
	_IDC_PRAGMA_CHECKED = dialog_VLGetCheck(idc_pragma,_VALLIST),
	_IDC_AUTHORIZATION_CHECKED = dialog_VLGetCheck(idc_authorization,_VALLIST),
	_IDC_ALLOW_CHECKED = dialog_VLGetCheck(idc_allow,_VALLIST),
	_IDC_CONTENTENCODING_CHECKED = dialog_VLGetCheck(idc_contentencoding,_VALLIST),
	_IDC_CONTENTLENGTH_CHECKED = dialog_VLGetCheck(idc_contentlength,_VALLIST),
	_IDC_CONTENTTYPE_CHECKED = dialog_VLGetCheck(idc_contenttype,_VALLIST),
	_IDC_LASTMODIFIED_CHECKED = dialog_VLGetCheck(idc_lm,_VALLIST),
	_IDC_EXPIRES_CHECKED = dialog_VLGetCheck(idc_expires,_VALLIST),
	_IDC_ENTITY_BODY1_CHECKED = dialog_VLGetCheck(idc_entity_body1,_VALLIST),
	_IDC_RES_QUERY_VALUE = dialog_VLGetstr(idc_res_query,_VALLIST),
	_IDC_RES_PAR_VALUE = dialog_VLGetstr(idc_res_par,_VALLIST),
	_IDC_EH_E_Y_VALUE = dialog_VLGetint(idc_eh_e_y,_VALLIST),
	_IDC_EH_E_D_VALUE = dialog_VLGetint(idc_eh_e_d,_VALLIST),
	_IDC_EH_E_WD_VALUE = dialog_VLGetstr(idc_eh_e_wd,_VALLIST),
	_IDC_EH_E_M_VALUE = dialog_VLGetstr(idc_eh_e_m,_VALLIST),
	_IDC_EH_E_H_VALUE = dialog_VLGetint(idc_eh_e_h,_VALLIST),
	_IDC_EH_E_MIN_VALUE = dialog_VLGetint(idc_eh_e_min,_VALLIST),
	_IDC_EH_CE_VALUE = dialog_VLGetstr(idc_eh_ce,_VALLIST),
	_IDC_EH_CL_VALUE = dialog_VLGetlong(idc_eh_cl,_VALLIST),
	_IDC_EH_CT_TYPE_VALUE = dialog_VLGetstr(idc_eh_ct_type,_VALLIST),
	_IDC_EH_CT_STYPE_VALUE = dialog_VLGetstr(idc_eh_ct_stype,_VALLIST),
	_IDC_EH_LM_MIN_VALUE = dialog_VLGetint(idc_eh_lm_min,_VALLIST),
	_IDC_EH_LM_H_VALUE = dialog_VLGetint(idc_eh_lm_h,_VALLIST),
	_IDC_EH_LM_M_VALUE = dialog_VLGetstr(idc_eh_lm_m,_VALLIST),
	_IDC_EH_LM_WD_VALUE = dialog_VLGetstr(idc_eh_lm_wd,_VALLIST),
	_IDC_EH_LM_D_VALUE = dialog_VLGetint(idc_eh_lm_d,_VALLIST),
	_IDC_EH_LM_Y_VALUE = dialog_VLGetint(idc_eh_lm_y,_VALLIST),
	_IDC_EH_ALLOW_VALUE = dialog_VLGetstr(idc_eh_allow,_VALLIST),
	_IDC_EH_CT_PAR_VALUE = dialog_VLGetstr(idc_eh_ct_par,_VALLIST),
	_IDC_F_REQ = dialog_VLGetRadiobutton(idc_f_req,_VALLIST),
%END Format Request, Update controls
	!.

%MARK Format Request, new events

%BEGIN Format Request, idc_help _CtlInfo
  dlg_format_request_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(dlg_format_request_Help),
	!.
%END Format Request, idc_help _CtlInfo


%BEGIN Format Request, idc_entity_body1 _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_entity_body1,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_entity_body1,IsChecked),	
	!.
%END Format Request, idc_entity_body1 _CtlInfo

%BEGIN Format Request, idc_expires _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_expires,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_expires,IsChecked),	
	!.
%END Format Request, idc_expires _CtlInfo

%BEGIN Format Request, idc_lm _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_lm,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_lm,IsChecked),	
	!.
%END Format Request, idc_lm _CtlInfo

%BEGIN Format Request, idc_contenttype _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_contenttype,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_contenttype,IsChecked),	
	!.
%END Format Request, idc_contenttype _CtlInfo

%BEGIN Format Request, idc_contentlength _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_contentlength,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_contentlength,IsChecked),	
	!.
%END Format Request, idc_contentlength _CtlInfo

%BEGIN Format Request, idc_contentencoding _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_contentencoding,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_contentencoding,IsChecked),	
	!.
%END Format Request, idc_contentencoding _CtlInfo

%BEGIN Format Request, idc_allow _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_allow,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_allow,IsChecked),	
	!.
%END Format Request, idc_allow _CtlInfo

%BEGIN Format Request, idc_authorization _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_authorization,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_authorization,IsChecked),	
	!.
%END Format Request, idc_authorization _CtlInfo

%BEGIN Format Request, idc_pragma _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_pragma,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_pragma,IsChecked),	
	!.
%END Format Request, idc_pragma _CtlInfo

%BEGIN Format Request, idc_date _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_date,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_date,IsChecked),	
	!.
%END Format Request, idc_date _CtlInfo

%BEGIN Format Request, idc_from _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_from,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_from,IsChecked),	
	!.
%END Format Request, idc_from _CtlInfo

%BEGIN Format Request, idc_ifm _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_ifm,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_ifm,IsChecked),	
	!.
%END Format Request, idc_ifm _CtlInfo

%BEGIN Format Request, idc_referer _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_referer,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_referer,IsChecked),	
	!.
%END Format Request, idc_referer _CtlInfo

%BEGIN Format Request, idc_ua _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_ua,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_ua,IsChecked),
	!.
%END Format Request, idc_ua _CtlInfo

%BEGIN Format Request, idc_browse _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_browse,_CtrlType,_CtrlWin,activated()),0):-!,
	FileName=dlg_GetOpenFileName("*.*",["All files (*.*)","*.*","HyperText (*.htm, *.html)","*.htm;*.html","Text (*.txt)","*.txt"],"Select a file for sending as an entity body:"),
	FileName<>"",
	Ctrl_hndl =win_GetCtlHandle(Win,idc_eb_body),
        win_SetText(Ctrl_hndl,FileName),
	dirfiles(FileName,fa_normal,_,_,_,_,_,_,_,_,Size),!,
	Ctrl_hndl1 =win_GetCtlHandle(Win,idc_eh_cl),
	term_str(ulong,Size,Size_str),
        win_SetText(Ctrl_hndl1,Size_str),
	dialog_SetCheck(Win,idc_contentlength,b_true),
	change_mode(Win,idc_contentlength,b_true),
	!.
%END Format Request, idc_browse _CtlInfo

%BEGIN Format Request, e_Create
  dlg_format_request_eh(Win,e_Create(_CreationData),0):-!,
  	change_font(Win,[idc_allow,idc_authorization,idc_contentencoding,idc_contentlength,idc_contenttype,idc_pragma,
  			          idc_date,idc_from,idc_referer,idc_ua,idc_ifm,idc_lm,idc_expires]),
  	!.
%END Format Request, e_Create

%BEGIN Format Request, idc_rh_a_basic _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_rh_a_basic,_CtrlType,CtrlWin,activated()),0):-!,
	IsChecked =win_IsChecked(CtrlWin),
  	change_mode(Win,idc_rh_a_basic,IsChecked),
	!.
%END Format Request, idc_rh_a_basic _CtlInfo

%BEGIN Format Request, idc_f_req _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_f_req,_CtrlType,_CtrlWin,activated()),0):-!,
  	change_to_en(Win,[idc_browse,idc_eb_body,idc_eh_allow,idc_eh_ce,idc_eh_cl,idc_eh_ct_par,idc_eh_ct_stype,idc_eh_ct_type,
  				     idc_eh_e_d,idc_eh_e_h,idc_eh_e_m,idc_eh_e_min,idc_eh_e_s,idc_eh_e_wd,idc_eh_e_y,
  				     idc_eh_lm_d,idc_eh_lm_wd,idc_eh_lm_m,idc_eh_lm_y,idc_eh_lm_h,idc_eh_lm_min,idc_eh_lm_s,
  				     idc_gh_d_d,idc_gh_d_wd,idc_gh_d_m,idc_gh_d_y,idc_gh_d_h,idc_gh_d_min,idc_gh_d_s,
  				     idc_gh_pragma,idc_meth,idc_rh_a_basic,idc_rh_a_par,idc_rh_a_sheme,idc_rh_from,
  				     idc_rh_ifm_d,idc_rh_ifm_wd,idc_rh_ifm_m,idc_rh_ifm_y,idc_rh_ifm_h,idc_rh_ifm_min,idc_rh_ifm_s,
  				     idc_rh_refer,idc_rh_ua,idc_ver_major,idc_ver_minor,idc_allow,idc_authorization,idc_contentencoding,idc_contentlength,idc_contenttype,idc_pragma,
  			             idc_date,idc_from,idc_referer,idc_ua,idc_ifm,idc_lm,idc_expires,idc_entity_body1]),
	change_mode_lst(Win,[idc_allow,idc_authorization,idc_contentencoding,idc_contentlength,idc_contenttype,idc_pragma,
  			             idc_date,idc_from,idc_referer,idc_ua,idc_ifm,idc_lm,idc_expires,idc_entity_body1]),
	!.
%END Format Request, idc_f_req _CtlInfo

%BEGIN Format Request, idc_s_req _CtlInfo
  dlg_format_request_eh(Win,e_Control(idc_s_req,_CtrlType,_CtrlWin,activated()),0):-!,
  	change_to_dis(Win,[idc_browse,idc_eb_body,idc_eh_allow,idc_eh_ce,idc_eh_cl,idc_eh_ct_par,idc_eh_ct_stype,idc_eh_ct_type,
  				     idc_eh_e_d,idc_eh_e_h,idc_eh_e_m,idc_eh_e_min,idc_eh_e_s,idc_eh_e_wd,idc_eh_e_y,
  				     idc_eh_lm_d,idc_eh_lm_wd,idc_eh_lm_m,idc_eh_lm_y,idc_eh_lm_h,idc_eh_lm_min,idc_eh_lm_s,
  				     idc_gh_d_d,idc_gh_d_wd,idc_gh_d_m,idc_gh_d_y,idc_gh_d_h,idc_gh_d_min,idc_gh_d_s,
  				     idc_gh_pragma,idc_meth,idc_rh_a_basic,idc_rh_a_par,idc_rh_a_sheme,idc_rh_from,
  				     idc_rh_ifm_d,idc_rh_ifm_wd,idc_rh_ifm_m,idc_rh_ifm_y,idc_rh_ifm_h,idc_rh_ifm_min,idc_rh_ifm_s,
  				     idc_rh_refer,idc_rh_ua,idc_ver_major,idc_ver_minor,idc_allow,idc_authorization,idc_contentencoding,idc_contentlength,idc_contenttype,idc_pragma,
                                     idc_date,idc_from,idc_referer,idc_ua,idc_ifm,idc_lm,idc_expires,idc_entity_body1]),
	!.
%END Format Request, idc_s_req _CtlInfo

  dlg_format_request_eh(_,_,_):-!,fail.

%END_DLG Format Request

%BEGIN_DLG View Response
/**************************************************************************
	Creation and event handling for dialog: View Response
**************************************************************************/

CONSTANTS

%BEGIN View Response, CreateParms, 16:14:22-24.1.1997, Code automatically updated!
  dlg_view_response_ResID = idd_view_response
  dlg_view_response_DlgType = wd_Modal
  dlg_view_response_Help = idh_contents
%END View Response, CreateParms

PREDICATES

  dlg_view_response_eh : EHANDLER
  dlg_view_response_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_view_response_Create(Parent,Title,Resp):-
	modify_ini(Resp,[
		df(idc_gh_d_y,editint(void,[]),nopr),
		df(idc_gh_d_d,editint(void,[]),nopr),
		df(idc_gh_d_wd,editstr("",[]),nopr),
		df(idc_gh_d_m,editstr("",[]),nopr),
		df(idc_gh_d_h,editint(void,[]),nopr),
		df(idc_gh_d_min,editint(void,[]),nopr),
		df(idc_gh_d_s,editint(void,[]),nopr),
		df(idc_gh_pragma,editstr("",[]),nopr),
		df(idc_eh_e_y,editint(void,[]),nopr),
		df(idc_eh_e_d,editint(void,[]),nopr),
		df(idc_eh_e_wd,editstr("",[]),nopr),
		df(idc_eh_e_m,editstr("",[]),nopr),
		df(idc_eh_e_h,editint(void,[]),nopr),
		df(idc_eh_e_min,editint(void,[]),nopr),
		df(idc_eh_e_s,editint(void,[]),nopr),
		df(idc_eh_allow,editstr("",[]),nopr),
		df(idc_eh_ce,editstr("",[]),nopr),
		df(idc_eh_cl,editlong(void,[]),nopr),
		df(idc_eh_ct_type,editstr("",[]),nopr),
		df(idc_eh_ct_stype,editstr("",[]),nopr),
		df(idc_eh_ct_par,editstr("",[]),nopr),
		df(idc_eh_lm_s,editint(void,[]),nopr),
		df(idc_eh_lm_min,editint(void,[]),nopr),
		df(idc_eh_lm_h,editint(void,[]),nopr),
		df(idc_eh_lm_m,editstr("",[]),nopr),
		df(idc_eh_lm_wd,editstr("",[]),nopr),
		df(idc_eh_lm_d,editint(void,[]),nopr),
		df(idc_eh_lm_y,editint(void,[]),nopr),
		df(idc_descr,editstr("",[]),nopr),
		df(idc_ver_major,editint(void,[]),nopr),
		df(idc_ver_minor,editint(void,[]),nopr),
		df(idc_st_code,editint(void,[]),nopr),
		df(idc_ent_b,editstr("",[default("")]),nopr),
		df(idc_loc,editstr("",[]),nopr),
		df(idc_serv,editstr("",[]),nopr),
		df(idc_rh_w_sheme,editstr("",[]),nopr),
		df(idc_rh_w_par,editstr("",[]),nopr),
		df(idc_realm,editstr("",[]),nopr),
		df(idc_eb_body,editstr("",[]),nopr),
		df(idc_entity_body1,checkbox(b_false),nopr),
		df(idc_unrec_heads,listbutton([],0),nopr)],Res_lst),
	dialog_CreateModal(Parent,dlg_view_response_ResID,Title,
		Res_lst,
		dlg_view_response_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_view_response_update(VALLIST),!.

  dlg_view_response_update(_VALLIST):-!,
%BEGIN View Response, Update controls, 16:14:22-24.1.1997, Code automatically updated!
	_IDC_GH_D_Y_VALUE = dialog_VLGetint(idc_gh_d_y,_VALLIST),
	_IDC_GH_D_D_VALUE = dialog_VLGetint(idc_gh_d_d,_VALLIST),
	_IDC_GH_D_WD_VALUE = dialog_VLGetstr(idc_gh_d_wd,_VALLIST),
	_IDC_GH_D_M_VALUE = dialog_VLGetstr(idc_gh_d_m,_VALLIST),
	_IDC_GH_D_H_VALUE = dialog_VLGetint(idc_gh_d_h,_VALLIST),
	_IDC_GH_D_MIN_VALUE = dialog_VLGetint(idc_gh_d_min,_VALLIST),
	_IDC_GH_D_S_VALUE = dialog_VLGetint(idc_gh_d_s,_VALLIST),
	_IDC_GH_PRAGMA_VALUE = dialog_VLGetstr(idc_gh_pragma,_VALLIST),
	_IDC_EH_E_Y_VALUE = dialog_VLGetint(idc_eh_e_y,_VALLIST),
	_IDC_EH_E_D_VALUE = dialog_VLGetint(idc_eh_e_d,_VALLIST),
	_IDC_EH_E_WD_VALUE = dialog_VLGetstr(idc_eh_e_wd,_VALLIST),
	_IDC_EH_E_M_VALUE = dialog_VLGetstr(idc_eh_e_m,_VALLIST),
	_IDC_EH_E_H_VALUE = dialog_VLGetint(idc_eh_e_h,_VALLIST),
	_IDC_EH_E_MIN_VALUE = dialog_VLGetint(idc_eh_e_min,_VALLIST),
	_IDC_EH_E_S_VALUE = dialog_VLGetint(idc_eh_e_s,_VALLIST),
	_IDC_EH_ALLOW_VALUE = dialog_VLGetstr(idc_eh_allow,_VALLIST),
	_IDC_EH_CE_VALUE = dialog_VLGetstr(idc_eh_ce,_VALLIST),
	_IDC_EH_CL_VALUE = dialog_VLGetlong(idc_eh_cl,_VALLIST),
	_IDC_EH_CT_TYPE_VALUE = dialog_VLGetstr(idc_eh_ct_type,_VALLIST),
	_IDC_EH_CT_STYPE_VALUE = dialog_VLGetstr(idc_eh_ct_stype,_VALLIST),
	_IDC_EH_CT_PAR_VALUE = dialog_VLGetstr(idc_eh_ct_par,_VALLIST),
	_IDC_EH_LM_S_VALUE = dialog_VLGetint(idc_eh_lm_s,_VALLIST),
	_IDC_EH_LM_MIN_VALUE = dialog_VLGetint(idc_eh_lm_min,_VALLIST),
	_IDC_EH_LM_H_VALUE = dialog_VLGetint(idc_eh_lm_h,_VALLIST),
	_IDC_EH_LM_M_VALUE = dialog_VLGetstr(idc_eh_lm_m,_VALLIST),
	_IDC_EH_LM_WD_VALUE = dialog_VLGetstr(idc_eh_lm_wd,_VALLIST),
	_IDC_EH_LM_D_VALUE = dialog_VLGetint(idc_eh_lm_d,_VALLIST),
	_IDC_EH_LM_Y_VALUE = dialog_VLGetint(idc_eh_lm_y,_VALLIST),
	_IDC_RES_VALUE = dialog_VLGetstr(idc_descr,_VALLIST),
	_IDC_VER_MAJOR_VALUE = dialog_VLGetint(idc_ver_major,_VALLIST),
	_IDC_VER_MINOR_VALUE = dialog_VLGetint(idc_ver_minor,_VALLIST),
	_IDC_VIEW_RESPONSE_1_VALUE = dialog_VLGetint(idc_st_code,_VALLIST),
	_IDC_ENT_B_VALUE = dialog_VLGetstr(idc_ent_b,_VALLIST),
	_IDC_LOC_VALUE = dialog_VLGetstr(idc_loc,_VALLIST),
	_IDC_SERV_VALUE = dialog_VLGetstr(idc_serv,_VALLIST),
	_IDC_RH_W_SHEME_VALUE = dialog_VLGetstr(idc_rh_w_sheme,_VALLIST),
	_IDC_RH_W_PAR_VALUE = dialog_VLGetstr(idc_rh_w_par,_VALLIST),
	_IDC_REALM_VALUE = dialog_VLGetstr(idc_realm,_VALLIST),
	_IDC_EB_BODY_VALUE = dialog_VLGetstr(idc_eb_body,_VALLIST),
	_IDC_ENTITY_BODY1_CHECKED = dialog_VLGetCheck(idc_entity_body1,_VALLIST),
	dialog_VLGetListButton(idc_unrec_heads,_VALLIST,_IDC_UNREC_HEADS_ITEMLIST,_IDC_UNREC_HEADS_SELECT),
%END View Response, Update controls
	!.

%MARK View Response, new events

%BEGIN View Response, idc_help _CtlInfo
  dlg_view_response_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(dlg_view_response_Help),
	!.
%END View Response, idc_help _CtlInfo

%BEGIN View Response, e_CloseRequest
  dlg_view_response_eh(_Win,e_CloseRequest,0):-fail.
%END View Response, e_CloseRequest


%BEGIN View Response, idc_entity_body1 _CtlInfo
  dlg_view_response_eh(_Win,e_Control(idc_entity_body1,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	IsChecked =win_IsChecked(_CtrlWin),
	change_mode(_Win,idc_entity_body1,IsChecked),
	!.
%END View Response, idc_entity_body1 _CtlInfo

%BEGIN View Response, idc_browse _CtlInfo
  dlg_view_response_eh(_Win,e_Control(idc_browse,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	FileName=dlg_GetSaveFileName("*.*",["All files (*.*)","*.*","HyperText (*.htm, *.html)","*.htm;*.html","Text (*.txt)","*.txt"],"Select a file for saving of an entity body:"),
	FileName<>"",
	Ctrl_hndl =win_GetCtlHandle(_Win,idc_eb_body),
        win_SetText(Ctrl_hndl,FileName),
	!.
%END View Response, idc_browse _CtlInfo

%BEGIN View Response, idc_ok _CtlInfo
  dlg_view_response_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
	Save_file = win_GetCtlHandle(_Win,idc_entity_body1),
	File_name = win_GetCtlHandle(_Win,idc_eb_body),
	Cont = win_GetCtlHandle(_Win,idc_ent_b),
	b_true = win_IsChecked(Save_file),
	OutString=win_GetText(File_name),
	Content=win_GetText(Cont),
 	trap(openwrite(file_write,OutString),_,dlg_error("Unable to write in a file!")),
	writedevice(Old),
	writedevice(file_write),
	filemode(file_write,0),
	write(Content),
	writedevice(Old),
	closefile(file_write),!,
	fail.
%END View Response, idc_ok _CtlInfo

  dlg_view_response_eh(_,_,_):-!,fail.

%END_DLG View Response
















































































