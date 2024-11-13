/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  HTTP32
 FileName: DLG_PROC.PRO
 Purpose: Example of HTTP Layer
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/

include "http.inc"
include "http.con"
include "hlptopic.con"


GLOBAL PREDICATES
  change_to_en(WINDOW,ILIST)
  change_to_dis(WINDOW,ILIST)
  change_mode(WINDOW, INTEGER,BOOLEAN)
  change_mode_lst(WINDOW, ILIST)    
  change_font(WINDOW,ILIST)
  modify_ini(httplay_response,DIALOG_FIELD_LIST,DIALOG_FIELD_LIST) - (i,i,o)

PREDICATES
  form_str_body(entity_body_0,STRING) - (i,o)
  form_str(SLIST,STRING Separator,STRING) - (i,i,o)
  check_end(STRING,STRING,STRING) - (i,i,o)      %checks is a separator at the end of a string
  form_server_str(product_version,STRING) -(i,o) 
  replace_field(DIALOG_FIELD_LIST,DIALOG_FIELD,DIALOG_FIELD,DIALOG_FIELD_LIST) - (i,i,i,o)
  modify_heads(DIALOG_FIELD_LIST,headers_0,DIALOG_FIELD_LIST)
  what_head_field(headers,DIALOG_FIELD_LIST,DIALOG_FIELD_LIST)

DATABASE - int_dlg
  un_head(SLIST)  
CLAUSES
  change_to_en(_,[]).
  change_to_en(Win,[E|I1]):-
        Win_ctrl =win_GetCtlHandle(Win,E),
        win_SetState(Win_ctrl, [wsf_Enabled]),!,
        change_to_en(Win,I1).

  change_to_dis(_,[]).
  change_to_dis(Win,[E|I1]):-
        Win_ctrl =win_GetCtlHandle(WIN,E),
        win_SetState(Win_ctrl, [wsf_Disabled]),!,
        change_to_dis(Win,I1).

  change_mode_lst(_,[]).
  change_mode_lst(Win,[E|L]):-
  	Cw=win_GetCtlHandle(Win,E),
  	IsChecked =win_IsChecked(Cw),
  	change_mode(Win,E,IsChecked),!,
	change_mode_lst(Win,L).

  change_mode(Win,idc_rh_a_basic,1):-
	Cw =win_GetCtlHandle(Win,idc_rh_a_sheme),
 	win_SetText(Cw,"Basic"),
 	change_to_dis(Win,[idc_rh_a_sheme]),!.
  change_mode(Win,idc_rh_a_basic,0):-
	Cw =win_GetCtlHandle(Win,idc_rh_a_sheme),  
 	win_SetText(Cw,""),
 	change_to_en(Win,[idc_rh_a_sheme]),!.
  change_mode(Win,idc_ua,0):-change_to_dis(Win,[idc_rh_ua]),!.
  change_mode(Win,idc_ua,1):-change_to_en(Win,[idc_rh_ua]),!.
  change_mode(Win,idc_referer,0):-change_to_dis(Win,[idc_rh_refer]),!.
  change_mode(Win,idc_referer,1):-change_to_en(Win,[idc_rh_refer]),!.
  change_mode(Win,idc_ifm,0):-change_to_dis(Win,[idc_rh_ifm_wd,idc_rh_ifm_d,idc_rh_ifm_m,idc_rh_ifm_y,idc_rh_ifm_h,idc_rh_ifm_min,idc_rh_ifm_s]),!.
  change_mode(Win,idc_ifm,1):-change_to_en(Win,[idc_rh_ifm_wd,idc_rh_ifm_d,idc_rh_ifm_m,idc_rh_ifm_y,idc_rh_ifm_h,idc_rh_ifm_min,idc_rh_ifm_s]),!.
  change_mode(Win,idc_from,0):-change_to_dis(Win,[idc_rh_from]),!.
  change_mode(Win,idc_from,1):-change_to_en(Win,[idc_rh_from]),!.
  change_mode(Win,idc_date,0):-change_to_dis(Win,[idc_gh_d_wd,idc_gh_d_d,idc_gh_d_m,idc_gh_d_y,idc_gh_d_h,idc_gh_d_min,idc_gh_d_s]),!.
  change_mode(Win,idc_date,1):-change_to_en(Win,[idc_gh_d_wd,idc_gh_d_d,idc_gh_d_m,idc_gh_d_y,idc_gh_d_h,idc_gh_d_min,idc_gh_d_s]),!.
  change_mode(Win,idc_pragma,0):-change_to_dis(Win,[idc_gh_pragma]),!.
  change_mode(Win,idc_pragma,1):-change_to_en(Win,[idc_gh_pragma]),!.
  change_mode(Win,idc_authorization,0):-Cw=win_GetCtlHandle(Win,idc_rh_a_basic),IsChecked =win_IsChecked(Cw),change_mode(Win,idc_rh_a_basic,IsChecked),change_to_dis(Win,[idc_rh_a_basic,idc_rh_a_par,idc_rh_a_sheme]),!.
  change_mode(Win,idc_authorization,1):-Cw=win_GetCtlHandle(Win,idc_rh_a_basic),IsChecked =win_IsChecked(Cw),change_mode(Win,idc_rh_a_basic,IsChecked),change_to_en(Win,[idc_rh_a_basic,idc_rh_a_par]),!.
  change_mode(Win,idc_allow,0):-change_to_dis(Win,[idc_eh_allow]),!.
  change_mode(Win,idc_allow,1):-change_to_en(Win,[idc_eh_allow]),!.
  change_mode(Win,idc_contentencoding,0):-change_to_dis(Win,[idc_eh_ce]),!.
  change_mode(Win,idc_contentencoding,1):-change_to_en(Win,[idc_eh_ce]),!.
  change_mode(Win,idc_contentlength,0):-change_to_dis(Win,[idc_eh_cl]),!.
  change_mode(Win,idc_contentlength,1):-change_to_en(Win,[idc_eh_cl]),!.
  change_mode(Win,idc_contenttype,0):-change_to_dis(Win,[idc_eh_ct_type,idc_eh_ct_stype,idc_eh_ct_par]),!.
  change_mode(Win,idc_contenttype,1):-change_to_en(Win,[idc_eh_ct_type,idc_eh_ct_stype,idc_eh_ct_par]),!.
  change_mode(Win,idc_lm,0):-change_to_dis(Win,[idc_eh_lm_wd,idc_eh_lm_d,idc_eh_lm_m,idc_eh_lm_y,idc_eh_lm_h,idc_eh_lm_min,idc_eh_lm_s]),!.
  change_mode(Win,idc_lm,1):-change_to_en(Win,[idc_eh_lm_wd,idc_eh_lm_d,idc_eh_lm_m,idc_eh_lm_y,idc_eh_lm_h,idc_eh_lm_min,idc_eh_lm_s]),!.
  change_mode(Win,idc_expires,0):-change_to_dis(Win,[idc_eh_e_wd,idc_eh_e_d,idc_eh_e_m,idc_eh_e_y,idc_eh_e_h,idc_eh_e_min,idc_eh_e_s]),!.
  change_mode(Win,idc_expires,1):-change_to_en(Win,[idc_eh_e_wd,idc_eh_e_d,idc_eh_e_m,idc_eh_e_y,idc_eh_e_h,idc_eh_e_min,idc_eh_e_s]),!.
  change_mode(Win,idc_entity_body1,0):-change_to_dis(Win,[idc_eb_body,idc_browse]),!.
  change_mode(Win,idc_entity_body1,1):-change_to_en(Win,[idc_eb_body,idc_browse]),!.
 	
  change_font(_,[]).
  change_font(Win,[E|L1]):-
	Font=font_Create(ff_Helvetica,[fs_UnderLine],8),
	CtrlWin =win_GetCtlHandle(Win,E),
	win_SetFont(CtrlWin,Font),!,
	change_font(Win,L1).
  	
  modify_ini(simple_resp(Bin_lst),Lst_fields,Res_lst):-
  	form_str_body(Bin_lst,Body),
  	replace_field(Lst_fields,df(idc_ent_b,editstr("",[default("")]),nopr),df(idc_ent_b,editstr(Body,[default("")]),nopr),Res_lst),!.
  modify_ini(full_resp(res_line(http_ver(Major,Minor),Code,Descr),Heads,Bin_lst),Lst_fields,Res_lst):-
  	replace_field(Lst_fields,df(idc_ver_major,editint(void,[]),nopr),df(idc_ver_major,editint(i(Major),[]),nopr),Lst_fields1),
  	replace_field(Lst_fields1,df(idc_ver_minor,editint(void,[]),nopr),df(idc_ver_minor,editint(i(Minor),[]),nopr),Lst_fields2),
	replace_field(Lst_fields2,df(idc_st_code,editint(void,[]),nopr),df(idc_st_code,editint(i(Code),[]),nopr),Lst_fields3),
	replace_field(Lst_fields3,df(idc_descr,editstr("",[]),nopr),df(idc_descr,editstr(Descr,[]),nopr),Lst_fields4),
	assert(un_head([])),
	modify_heads(Lst_fields4,Heads,Lst_fields5),
	retract(un_head(Lst_hds)),
	replace_field(Lst_fields5,df(idc_unrec_heads,listbutton([],0),nopr),df(idc_unrec_heads,listbutton(Lst_hds,0),nopr),Lst_fields6),
  	form_str_body(Bin_lst,Body),
  	replace_field(Lst_fields6,df(idc_ent_b,editstr("",[default("")]),nopr),df(idc_ent_b,editstr(Body,[default("")]),nopr),Res_lst),
  	!.
  
  modify_heads(L,[],L):-!.
  modify_heads(L_f,[Head|L],L_out):-
  	what_head_field(Head,L_f,L_fn),!,
  	modify_heads(L_fn,L,L_out).
  
  what_head_field(date_0(http_date(Weekday,date(Day,Month,Year),time(H,M,S))),L_old,L_new):-
  	replace_field(L_old,df(idc_gh_d_wd,editstr("",[]),nopr),df(idc_gh_d_wd,editstr(Weekday,[]),nopr),L_old1),
  	replace_field(L_old1,df(idc_gh_d_d,editint(void,[]),nopr),df(idc_gh_d_d,editint(i(Day),[]),nopr),L_old2),
  	replace_field(L_old2,df(idc_gh_d_m,editstr("",[]),nopr),df(idc_gh_d_m,editstr(Month,[]),nopr),L_old3),
  	replace_field(L_old3,df(idc_gh_d_y,editint(void,[]),nopr),df(idc_gh_d_y,editint(i(Year),[]),nopr),L_old4),
  	replace_field(L_old4,df(idc_gh_d_h,editint(void,[]),nopr),df(idc_gh_d_h,editint(i(H),[]),nopr),L_old5),
  	replace_field(L_old5,df(idc_gh_d_min,editint(void,[]),nopr),df(idc_gh_d_min,editint(i(M),[]),nopr),L_old6),
  	replace_field(L_old6,df(idc_gh_d_s,editint(void,[]),nopr),df(idc_gh_d_s,editint(i(S),[]),nopr),L_new),!.
  what_head_field(pragma(Direct_lst),L_old,L_new):-
  	form_str(Direct_lst,",",Pragma_str1),
  	check_end(Pragma_str1,",",Pragma_str),
  	replace_field(L_old,df(idc_gh_pragma,editstr("",[]),nopr),df(idc_gh_pragma,editstr(Pragma_str,[]),nopr),L_new),!.
  what_head_field(location("",URI),L_old,L_new):-
  	replace_field(L_old,df(idc_loc,editstr("",[]),nopr),df(idc_loc,editstr(URI,[]),nopr),L_new),!.
  what_head_field(location(Sheme,URI),L_old,L_new):-
  	format(Loc,"%s:%s",Sheme,URI),
  	replace_field(L_old,df(idc_loc,editstr("",[]),nopr),df(idc_loc,editstr(Loc,[]),nopr),L_new),!.  	
  what_head_field(server(Prod_lst),L_old,L_new):-
  	form_server_str(Prod_lst,Prod_str),
  	replace_field(L_old,df(idc_serv,editstr("",[]),nopr),df(idc_serv,editstr(Prod_str,[]),nopr),L_new),!.
  what_head_field(www_authenticate(Sheme,Realm,Params_lst),L_old,L_new):-
  	replace_field(L_old,df(idc_rh_w_sheme,editstr("",[]),nopr),df(idc_rh_w_sheme,editstr(Sheme,[]),nopr),L_old1),
  	replace_field(L_old1,df(idc_realm,editstr("",[]),nopr),df(idc_realm,editstr(Realm,[]),nopr),L_old2),
  	form_str(Params_lst,",",Params_str1),
  	check_end(Params_str1,",",Params_str),
  	replace_field(L_old2,df(idc_rh_w_par,editstr("",[]),nopr),df(idc_rh_w_par,editstr(Params_str,[]),nopr),L_new),!.
  what_head_field(allow(Meth_lst),L_old,L_new):-
  	form_str(Meth_lst,",",Meth_str1),
  	check_end(Meth_str1,",",Meth_str),
  	replace_field(L_old,df(idc_eh_allow,editstr("",[]),nopr),df(idc_eh_allow,editstr(Meth_str,[]),nopr),L_new),!.
  what_head_field(content_encoding(EnCode),L_old,L_new):-
  	replace_field(L_old,df(idc_eh_ce,editstr("",[]),nopr),df(idc_eh_ce,editstr(Encode,[]),nopr),L_new),!.
  what_head_field(content_length(Len),L_old,L_new):-
  	replace_field(L_old,df(idc_eh_cl,editlong(void,[]),nopr),df(idc_eh_cl,editlong(l(Len),[]),nopr),L_new),!.
  what_head_field(content_type(Type,SubType,Params_lst),L_old,L_new):-
  	replace_field(L_old,df(idc_eh_ct_type,editstr("",[]),nopr),df(idc_eh_ct_type,editstr(Type,[]),nopr),L_old1),
  	replace_field(L_old1,df(idc_eh_ct_stype,editstr("",[]),nopr),df(idc_eh_ct_stype,editstr(SubType,[]),nopr),L_old2),
  	form_str(Params_lst,",",Params_str1),
  	check_end(Params_str1,",",Params_str),
  	replace_field(L_old2,df(idc_eh_ct_par,editstr("",[]),nopr),df(idc_eh_ct_par,editstr(Params_str,[]),nopr),L_new),!.
  what_head_field(expires(http_date(Weekday,date(Day,Month,Year),time(H,M,S))),L_old,L_new):-
  	replace_field(L_old,df(idc_eh_e_wd,editstr("",[]),nopr),df(idc_eh_e_wd,editstr(Weekday,[]),nopr),L_old1),
  	replace_field(L_old1,df(idc_eh_e_d,editint(void,[]),nopr),df(idc_eh_e_d,editint(i(Day),[]),nopr),L_old2),
  	replace_field(L_old2,df(idc_eh_e_m,editstr("",[]),nopr),df(idc_eh_e_m,editstr(Month,[]),nopr),L_old3),
  	replace_field(L_old3,df(idc_eh_e_y,editint(void,[]),nopr),df(idc_eh_e_y,editint(i(Year),[]),nopr),L_old4),
  	replace_field(L_old4,df(idc_eh_e_h,editint(void,[]),nopr),df(idc_eh_e_h,editint(i(H),[]),nopr),L_old5),
  	replace_field(L_old5,df(idc_eh_e_min,editint(void,[]),nopr),df(idc_eh_e_min,editint(i(M),[]),nopr),L_old6),
  	replace_field(L_old6,df(idc_eh_e_s,editint(void,[]),nopr),df(idc_eh_e_s,editint(i(S),[]),nopr),L_new),!.
  what_head_field(last_modified(http_date(Weekday,date(Day,Month,Year),time(H,M,S))),L_old,L_new):-
  	replace_field(L_old,df(idc_eh_lm_wd,editstr("",[]),nopr),df(idc_eh_lm_wd,editstr(Weekday,[]),nopr),L_old1),
  	replace_field(L_old1,df(idc_eh_lm_d,editint(void,[]),nopr),df(idc_eh_lm_d,editint(i(Day),[]),nopr),L_old2),
  	replace_field(L_old2,df(idc_eh_lm_m,editstr("",[]),nopr),df(idc_eh_lm_m,editstr(Month,[]),nopr),L_old3),
  	replace_field(L_old3,df(idc_eh_lm_y,editint(void,[]),nopr),df(idc_eh_lm_y,editint(i(Year),[]),nopr),L_old4),
  	replace_field(L_old4,df(idc_eh_lm_h,editint(void,[]),nopr),df(idc_eh_lm_h,editint(i(H),[]),nopr),L_old5),
  	replace_field(L_old5,df(idc_eh_lm_min,editint(void,[]),nopr),df(idc_eh_lm_min,editint(i(M),[]),nopr),L_old6),
  	replace_field(L_old6,df(idc_eh_lm_s,editint(void,[]),nopr),df(idc_eh_lm_s,editint(i(S),[]),nopr),L_new),!.
  what_head_field(unrecognized_header(Name,Value),L,L):-
  	format(Str,"%s: %s",Name,Value),
  	retract(un_head(Lst_prev)),!,
  	assert(un_head([Str|Lst_prev])).
  	
  replace_field([],_,_,[]):-!.
  replace_field([Old|L],Old,New,[New|L]):-!.
  replace_field([El|L],Old,New,[El|L1]):-
  	replace_field(L,Old,New,L1).
  
  form_str_body([],""):-!.
  form_str_body([entity_body(Bin)|L],Str):-
        Lst = binary_to_strlist(Bin),
        form_str(Lst,"",S1),!,
        form_str_body(L,S2),
        concat(S1,S2,Str).
  	
  form_str([],_,""):-!.
  form_str([El|L],Sep,Str):-!,
  	form_str(L,Sep,S1),
  	concat(El,Sep,Ss),
  	concat(Ss,S1,Str).
  
  check_end("",_,""):-!.
  check_end(In,Sep,Out):-
  	str_len(Sep,Ls),str_len(In,Li),
  	Lf = Li-Ls,
	frontstr(Lf,In,Out,Rest),
	Rest = Sep,!.
  check_end(In,_,In).
  	
  
  form_server_str([],""):-!.
  form_server_str([prod(Pr)|L],Str_out):-
  	form_server_str(L,Str),
  	concat(Pr," ",S),
  	concat(S,Str,Str_out),!.
  form_server_str([comm(Cm)|L],Str_out):-
  	form_server_str(L,Str),
  	concat(Cm," ",S),
  	concat(S,Str,Str_out),!.