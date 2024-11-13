/*****************************************************************************

                Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  FTPAgent
 FileName: SOCK_INI.PRO
 Purpose: Example of Winsock 1.1 and FTP
 Written by: Konstantin Ivanov
 Comments: Functions for profiles: load,save,delete
******************************************************************************/

include "ftpagent.inc"
include "ftpagent.con"

PREDICATES
  is_name_in_list(WINDOW,STRING,SLIST)

CLAUSES
%predicate for new button in New dialog - clears edit fields
  pfini_new(Win):-
        UserId_hndl=win_GetCtlHandle(Win,idc_browse_address_2),
        Userpwd_hndl=win_GetCtlHandle(Win,idc_browse_address_3),
        Chkdel_hndl=win_GetCtlHandle(Win,idc_check_del),
        Dest_hndl=win_GetCtlHandle(Win,idc_dest),
        Sour_hndl=win_GetCtlHandle(Win,idc_sour),
        Remdir_hndl=win_GetCtlHandle(Win,idc_rem_dirry),
        Timer_hndl=win_GetCtlHandle(Win,idc_timer),
        Pflist_hndl=win_GetCtlHandle(Win,idc_pf_list),
        An_hndl=win_GetCtlHandle(Win,idc_anonymous_logon),
	SvPwd_h = win_GetCtlHandle(Win, idc_save_password),
        win_SetText(UserId_hndl,""),
        win_SetText(Userpwd_hndl,""),
        win_SetText(Dest_hndl,""),
        win_SetText(Sour_hndl,""),
        win_SetText(Remdir_hndl,""),
        win_SetText(Timer_hndl,""),
        win_SetText(Pflist_hndl,""),
        win_Check(Chkdel_hndl,b_false),
        win_Check(An_hndl,b_false),
        win_Check(SvPwd_h,b_false),
        retractall(adv_vals(_)),
        assert(adv_vals(adv_opts(21,proxy(0,"",0),b_false,b_false,b_false,b_false))),
        win_SetFocus(Pflist_hndl),
        !.

%predicate for save button in New dialog - checks information in edit fields and saves it in ftpagent.ini
  pfini_save(Win):-
        Pflist_hndl = win_GetCtlHandle(Win,idc_pf_list),
        Pf_name1 = win_GetText(Pflist_hndl),
        LboxList = lbox_GetAll(Pflist_hndl),
        strip_leading_spaces(Pf_name1,Pf_name),
        is_name_in_list(Win,Pf_name,LboxList),
        check_new_dialog(Win,Sour,Chk,Timer,Dest,Uid,Upwd,Rem_dir),
        check_null(Pf_name,"There is no name for profile!"),
	SvPwd_h = win_GetCtlHandle(Win, idc_save_password),
	SvPwd = win_IsChecked(SvPwd_h),
	pwd_str_bin(Upwd,Upwd_bin1),
        pwd_check(pwd(SvPwd,Upwd_bin1),Upwd_bin),
        adv_vals(ADV_OPTS),
        assert(profiles(Pf_name,Sour,Dest,Timer,Chk,Uid,pwd(SvPwd,Upwd_bin),Rem_dir,ADV_OPTS)),
        lbox_Add(Pflist_hndl,Pf_name),
        win_SetText(Pflist_hndl,Pf_name),
        !.
  pfini_save(_).      

%predicate reads profiles names from ftpagent.ini and fills list-box with these information
  pfini_load(Win):-
        Pflist_hndl=win_GetCtlHandle(Win,idc_pf_list),
	lbox_Clear(Pflist_hndl),
	findall(Pf_name,profiles(Pf_name,_,_,_,_,_,_,_,_), L1 ),
	lbox_Add(Pflist_hndl, L1),
        !.

%predicate fills edit fields of New dialog from ftpagent.ini for selected name from list_box pf_list
  pfini_load_item(Win):-
        Pflist_hndl = win_GetCtlHandle(Win,idc_pf_list),
        Index = lbox_GetSelIndex(Pflist_hndl),
        Item = lbox_GetItem(Pflist_hndl,Index),
  	profiles(Item,Sour,Dest,Timer,Chk,Uid,pwd(SvPwd,Pwd_bin),Rem_dir,ADV_OPTS),
        retractall(adv_vals(_)),
        assert(adv_vals(ADV_OPTS)),
        pwd_str_bin(Pwd_str,Pwd_bin),
        fill_edit_dialog(0,Win,Sour,Chk,Timer,Dest,Uid,Pwd_str,Rem_dir),
        SvPwd_h = win_GetCtlHandle(Win, idc_save_password),
	win_Check(SvPwd_h, SvPwd),
	!.

%predicate for delete button of New dialog - deletes information from ftpagent.ini for selected name of profile in pf_list
  pfini_delete(Win):-
        Pflist_hndl = win_GetCtlHandle(Win,idc_pf_list),
        Item = win_GetText(Pflist_hndl),
	retract(profiles(Item,_,_,_,_,_,_,_,_)),
	pfini_load(Win),
        !.

%predicates prevents user from creating profiles with the same name
  is_name_in_list(_,_,[]):-!.
  is_name_in_list(_,Pf_name,[Pf_name|_]):-!,fail.
  is_name_in_list(Win,Pf_name,[_|Lst]):-is_name_in_list(Win,Pf_name,Lst).
