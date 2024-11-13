/*****************************************************************************

                Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  FTPAgent
 FileName: FTPAgent.PRO
 Purpose: Example of Winsock 1.1 and FTP
 Written by: Konstantin Ivanov
 Comments: Functions for Task window, its list-boxes, focuses and dialogs
******************************************************************************/

include "ftpagent.inc"
include "ftpagent.con"
include "hlptopic.con"
include "iodecl.con"

CONSTANTS

ifdef platform_32bit
  helpfilename = "ftpagent.hlp"
elsedef  
  helpfilename = "ftpag16.hlp"
enddef
  fa_version = "2.53"
  
DATABASE - ftpagent_int1
  timer_pos(LONG)
  determ flag_new_edit(Boolean) %0- dialog in new mode, 1 - edit mode
  startUp_lst(integer, integer, string)
  modified_listentry(integer, integer)
  
DATABASE - ftpagent_int2
  l_e(integer,
      integer,
      string,
      string,
      string,
      integer,
      string,
      string,
      upwd,
      integer,
      string,
      advanced_opts,
      string)

PREDICATES
  off_focus(window, integer)
  change_to_en(window, ilist)
  change_to_dis(window, ilist)
  change_buttons(window, string)
  change_mode_status(window, integer)
  integer change_mode_status_checkSel(window) - (i)
  common_FileErrorHandle_IsDesc(integer, string) - (i,o)
  focus_actions(window, integer)
  focus_actions1(window, integer)
  is_box_empty(window, integer)
  is_new_or_edit(integer,
      integer,
      string,
      string,
      string,
      integer,
      boolean,
      string,
      upwd,
      string,
      advanced_opts,
      string)
  refresh_list(integer, integer)
  check_path(string)
  check_tm(string)
  set_title(window, string)
  nondeterm member(wsflags, wsflag)
  del_state(integer, string)
  del_db(integer, integer)
  fa_pict_handler : ehandler
  is_receive(window)
  is_rec(integer)
  is_fw(window, boolean, string, dialog_long)
  is_anonym(window, string)
  is_sel_in_lb(window, string)
  procedure is_debug(boolean, integer)
  check_ness_file()
  get_debug_info : ftplay_debug_hndl
  read_base_checkBAK

  els_code(integer, integer) - (i,o),(o,i)
  els_code_win(integer, window) - (i,o)
  
ifdef platform_16bit
  procedure file_str_16bit(STRING,STRING) - (i,o)
enddef
  
CLAUSES

%puts away focus from list_box when user clicks on another list-box
  off_focus(_Win, Lbox_code):-
  	els_code_win(Lbox_code, LboxWin),
        Index=lbox_GetSelIndex(LboxWin),
        lbox_SetSel(LboxWin, Index, b_false),!.
  off_focus(_,_).

%predicates for Enable/Disable changing of buttons state
  change_mode_to_en(Win,L):-
        Wsflags=win_GetState(Win),
        not(member(Wsflags,wsf_Disabled)),
        not(member(Wsflags,wsf_Minimized)),
        change_to_en(Win,L),
        !.
  change_mode_to_en(_,_).

  change_to_en(_,[]).
  change_to_en(Win,[E|I1]):-
        Win_ctrl =win_GetCtlHandle(Win,E),
        win_SetState(Win_ctrl, [wsf_Enabled]),
        change_to_en(Win,I1).

  change_mode_to_dis(Win,L):-
        Wsflags=win_GetState(Win),
        not(member(Wsflags,wsf_Disabled)),
        not(member(Wsflags,wsf_Minimized)),
        change_to_dis(Win,L),
        !.
  change_mode_to_dis(_,_).

  change_to_dis(_,[]).
  change_to_dis(Win,[E|I1]):-
        Win_ctrl = win_GetCtlHandle(WIN,E),
        win_SetState(Win_ctrl, [wsf_Disabled]),
        change_to_dis(Win,I1).

%test the status of list_entry and Enable/Disable buttons
  change_mode_status(Win,Lbox_code):-
	els_code_win(Lbox_code,LboxWin),
        Index = change_mode_status_checkSel(LboxWin),
        retractall(global_win(_,_)),!,
        assert(global_win(Lbox_code,Index)),        
        list_entry(Lbox_code,Index,Status,_,_,_,_,_,_,_,_,_,_),!,
        change_buttons(Win,Status).

  change_mode_status_checkSel(LboxWin,Index):-
  	Index = lbox_GetSelIndex(LboxWin),
  	!.
  change_mode_status_checkSel(LboxWin,0):-
  	lbox_SetSel(LboxWin,0,b_true).

  change_buttons(Win,"Stopped"):-
        change_mode_to_en(Win,[idc_new,idc_edit,idc_delete,idc_start]),
        change_mode_to_dis(Win,[idc_stop]),!.
  change_buttons(Win,"Waiting"):-
        change_mode_to_en(Win,[idc_new,idc_stop]),
        change_mode_to_dis(Win,[idc_delete,idc_edit,idc_start]),!.
  change_buttons(Win,_):-
        change_mode_to_en(Win,[idc_new,idc_stop]),
        change_mode_to_dis(Win,[idc_delete,idc_edit,idc_start]),!.

%tests is given list-box empty and changes accordinally the status of buttons
  is_box_empty(Win,Lbox_code):-
	els_code_win(Lbox_code,LboxWin),
        Cnt = lbox_CountAll(LboxWin),
        Cnt = 0,!,
        change_mode_to_en(Win,[idc_new]),
        change_mode_to_dis(Win,[idc_edit,idc_stop,idc_start,idc_delete]),fail.
  is_box_empty(Win,_):-
        change_mode_to_dis(Win,[idc_stop]),
        change_mode_to_en(Win,[idc_edit,idc_new,idc_start,idc_delete]).

%predicate tests is list_entry in edit mode or not, adds or deletes an entry
%###? why the same code is written two times????
  is_new_or_edit(0,Lbox_code,Status,From,To,Timer,Del,U_Id,Pwd,Remdir,Adv,Prof):-
        flag_new_edit(0),!,
        els_code_win(Lbox_code,LboxWin),
        Index = lbox_CountAll(LboxWin),
        del_state(Del,Delete),
        assert(list_entry(Lbox_code,Index,Status,From,To,Timer,Delete,U_Id,Pwd,0,Remdir,Adv,Prof)),
        Str=form_str(Index,Status,From,To,Timer),
	lbox_Suspend(LboxWin),
        lbox_Add(LboxWin, Str),
	lbox_SetSel(LboxWin,Index,b_true),
	lbox_Resume(LboxWin),!.
  is_new_or_edit(1,Lbox_code,Status,From,To,Timer,Del,U_Id,Pwd,Remdir,Adv,Prof):-
        flag_new_edit(0),!,
        els_code_win(Lbox_code,LboxWin),
        Index=lbox_CountAll(LboxWin),
        del_state(Del,Delete),
        assert(list_entry(Lbox_code,Index,Status,To,From,Timer,Delete,U_Id,Pwd,0,Remdir,Adv,Prof)),
        Str=form_str(Index,Status,To,From,Timer),
	lbox_Suspend(LboxWin),
        lbox_Add(LboxWin, Str),
        lbox_SetSel(LboxWin,Index,b_true),
	lbox_Resume(LboxWin),!.
  is_new_or_edit(0,Lbox_code,Status,From,To,Timer,Del,U_Id,U_pwd,Remdir,Adv,Prof):-
        flag_new_edit(1),!,
        els_code_win(Lbox_code,LboxWin),
        Index_prev=lbox_GetSelIndex(LboxWin),
        del_state(Del,Delete),
        retract(list_entry(Lbox_code,Index_prev,_,_,_,_,_,_,_,_,_,_,_)),!,
        assert(list_entry(Lbox_code,Index_prev,Status,From,To,Timer,Delete,U_Id,U_pwd,0,Remdir,Adv,Prof)),
        Str=form_str(Index_prev,Status,From,To,Timer),
        lbox_del_pos(Lbox_code,Index_prev, Str),!.
  is_new_or_edit(1,Lbox_code,Status,From,To,Timer,Del,U_Id,U_pwd,Remdir,Adv,Prof):-
        flag_new_edit(1),!,
        els_code_win(Lbox_code,LboxWin),
        Index_prev=lbox_GetSelIndex(LboxWin),
        del_state(Del,Delete),
        retract(list_entry(Lbox_code,Index_prev,_,_,_,_,_,_,_,_,_,_,_)),!,
        assert(list_entry(Lbox_code,Index_prev,Status,To,From,Timer,Delete,U_Id,U_pwd,0,Remdir,Adv,Prof)),
        Str=form_str(Index_prev,Status,To,From,Timer),
        lbox_del_pos(Lbox_code,Index_prev, Str),!.        

%predicate disables check-box "Delete files after sending" if list entry is from Receive-list
  is_receive(Wn):-
        global_win(1,_),!,
        Ch_hndl = win_GetCtlHandle(Wn,idc_check_del),
        win_SetState(Ch_hndl, [wsf_Disabled]).
  is_receive(_).

%returns 1 if Receive-list is active
   is_rec(Res):-
   	global_win(1,_),!,
   	Res=1.
   is_rec(0).
   
%predicate performs reenumeration in given list-box, is used when an entry is deleted.
  refresh_list(Lbox_code,Index):-
        Ind = Index + 1,
        retract(list_entry(Lbox_code,Ind,Status,From,To,Timer,Delete,U_Id,U_pwd,Cur_timer,Remdir,Adv,Prof)),!,
        assert(list_entry(Lbox_code,Index,Status,From,To,Timer,Delete,U_Id,U_pwd,Cur_timer,Remdir,Adv,Prof)),
        Str=form_str(Index,Status,From,To,Timer),
        lbox_del_pos(Lbox_code,Index,Str),
        refresh_list(Lbox_code,Ind).
  refresh_list(_,_).

%predicate deletes an entry in a given list-box
  lbox_del_pos(Lbox_code,Index_prev,Str):-
  	els_code_win(Lbox_code,LboxWin),
	lbox_Suspend(LboxWin),
        lbox_Add(LboxWin,Index_prev,Str),
        lbox_SetSel(LboxWin,Index_prev,b_true),
        Ind = Index_prev + 1,
        lbox_Delete(LboxWin, Ind),
        lbox_Resume(LboxWin).
        
PREDICATES        
  new_time(INTEGER,STRING) - (i,o)
  check_rest(INTEGER,INTEGER,INTEGER,INTEGER) - (i,i,o,o)
  
CLAUSES
%returns the time of next sync. 
%The current time is summarized with a number of minutes of delay between syncs.
  new_time(Timer,Out):-
	time(Hours,Minutes,Seconds,_),
	H = Timer div 60,
	H1 = Hours + H,
	M1 = (Timer - H*60) + Minutes,
	check_rest(H1,M1,H2,M2),
	format(Out,"%d:%d:%d",H2,M2,Seconds),!.
	
  check_rest(H1,M1,H1,M1):-
  	H1 < 24,
  	M1 < 60,!.
  check_rest(H1,M1,H,M1):-
  	H1 >= 24,
  	M1 < 60,
  	H = H1 - 24,!.
  check_rest(H1,M1,H,M):-
  	H1 < 24,
  	M1 >= 60,
  	M2 = M1 - 60,
  	H2 = H1 + 1,!,
  	check_rest(H2,M2,H,M).
  check_rest(H1,M1,H,M):-
  	H1 >= 24,
  	M1 >= 60,
  	M2 = M1 - 60,
  	H2 = H1 - 23,!,
  	check_rest(H2,M2,H,M).

%predicate creates a string that represents list entry in a list-box
  form_str(Index,"Waiting",From,To,Timer,Result):-
  	new_time(Timer,NewTimer),
        format(Result,"%-3%-10%-27.26%-26.25%-9",Index,"Waiting",From,To,NewTimer),!.
  form_str(Index,Status,From,To,Timer,Result):-
        format(Result,"%-3%-10%-27.26%-26.25%-9",Index,Status,From,To,Timer).

%no comments
  member([F|_],F).
  member([_|L],F):-member(L,F).

%predicates set focus on a string in list-box or make actions if Task Window is disabled or minimized
  set_focus(Win,Lbox_code):-
        Wsflags = win_GetState(Win),
        not(member(Wsflags,wsf_Disabled)),
        not(member(Wsflags,wsf_Minimized)),
        els_code_win(Lbox_code,LboxWin),
        win_SetFocus(LboxWin),
        !.
  set_focus(Win,Lbox_code):-
        focus_actions(Win,Lbox_code).

  focus_actions(Win,Lbox_code):-
        retractall(global_win(_,_)),!,
        assert(global_win(Lbox_code,0)),
        off_focus(Win,Lbox_code),
        focus_actions1(Win,Lbox_code),
        !.

  focus_actions1(Win,Lbox_code):-
        is_box_empty(Win,Lbox_code),
        change_mode_status(Win,Lbox_code),!.
  focus_actions1(_,_).

%deletes leading spaces in a given string
  strip_leading_spaces(STR,STR2):-
        frontchar(STR,' ',St1),!,
        strip_leading_spaces(St1,STR2).
  strip_leading_spaces(STR,STR).

%check is given path exist
  check_path(PATH):-
        PATH="",
        dlg_Error("Local directory path is null"),!,fail.
  check_path(PATH):-
        trap(dirfiles(PATH,fa_subdir,_,_,_,_,_,_,_,_,_),_,true),!. %2DO dosn't understand root dir-ry
  check_path( Path ):-
  	format( Str, "Local directory %s does not exist! Create this directory?", Path ),
  	resp_default = dlg_Ask("Attention",Str,["&Yes","&No"]),
	is_md( Path, 0 ).

%check is given timer (delay between syncs) valid
  check_tm(Value):-
        Value="",
        dlg_Error("Check every field is null"),!,fail.
  check_tm(Value):-
        str_int(Value,_),!.
  check_tm(_):-
        dlg_Error("Check every field is not integer"),!.

%checks input string and fires a dialog with a given comment if it is empty.
  check_null(Value,Comm):-
        Value="",
        dlg_Error(Comm),!,fail.
  check_null(_,_).

%replaces empty directory path with a root directory
  check_DirNull("","/"):-!.
  check_DirNull(Dir,Dir).

%checks the existance of ini file, if not - then defaults are saved.
  check_ness_file():-
  	disk(CurPath),
	filenamepath(FullName,CurPath,"ftpagent.ini"),
  	trap(openread(file_ini,FullName),_,true),
  	closefile(file_ini),
  	!.
  check_ness_file():-
  	dlg_Error("There is no file ftpagent.ini! Defaults are used!"),
  	disk(CurPath),
	filenamepath(FullName,CurPath,"ftpagent.ini"),
	filenamepath(FullName2,CurPath,"ftpagent.log"),
	filenamepath(FullName3,CurPath,"ftpagent.dbg"),
  	assert(options(log(b_false,FullName2),"guest",dbg(b_false,FullName3),1,60)),
  	trap(save(FullName,synch_els),_,dlg_error("Can not save program information in the file ftpagent.ini!")),!,
  	retractall(options(log(b_false,FullName2),"guest",dbg(b_false,FullName3),1,60)).
  check_ness_file():-
  	retractall(options(_,_,_,_,_)).

%error handler is used in file operations. Searches for error code and fires a message.
  common_FileErrorHandle( Err ):-
  	common_FileErrorHandle_IsDesc( Err, Str ),
  	dlg_error( Str ).

  common_FileErrorHandle_IsDesc( Err, Str ):-
	trap( errormsg( "prolog.err", Err, ErrorMsg, _ ),_,true),
	format( Str, "File operation failed with an error: %s", ErrorMsg ),!.
  common_FileErrorHandle_IsDesc( Err, Str ):-
  	format( Str, "File operation failed with an error: %d", Err ).
	
%predicates save and restore a state of list boxes between sessions.
PREDICATES
  what_real_status(INTEGER,STRING) - (i,o)
  check_save_els()
  check_read_els()
  read_base()
  save_base()
  save_base_intermediate()
  save_base_intermed()
  copy_Entries_Back()
  copy_Entries()
  startup_entry(INTEGER,INTEGER,STRING) - (i,i,i)
  sort_entries(INTEGER) - (i)
  write_Headers()
  
CLAUSES

  check_save_els():-
  	retract(list_entry(Lbox_code,Index,_,A,B,C,D,E,F,-1,G,H,K)),
  		what_real_status(Lbox_code,Status_real),
  		assert(list_entry(Lbox_code,Index,Status_real,A,B,C,D,E,F,0,G,H,K)),
  	fail.
%KI add begin 03.09.1998
  check_save_els():-
  	retract(list_entry(Lbox_code,Index,"Waiting",A,B,C,D,E,F,_,G,H,K)),
	  	what_real_status(Lbox_code,Status_real),
  		assert(list_entry(Lbox_code,Index,Status_real,A,B,C,D,E,F,0,G,H,K)),
  	fail.
%KI add end 03.09.1998  	
  check_save_els():-
  	sort_entries(0),
  	!.
  check_save_els().

  what_real_status(0,"Sending"):-!.
  what_real_status(1,"Receiving"):-!.

  startup_entry(_Lbox_code,_Index,"Stopped"):-!.
  startup_entry(Lbox_code,Index,"Waiting"):-
        retract(list_entry(Lbox_code,Index,_,From,To,Timer,Delete,U_id,U_pwd,_,Remdir,ADV_OPTS,Profile)),
        assert(list_entry(Lbox_code,Index,"Waiting",From,To,Timer,Delete,U_id,U_pwd,0,Remdir,ADV_OPTS,Profile)),
        Str=form_str(Index,"Waiting",From,To,Timer),
        lbox_del_pos(Lbox_code,Index,Str),
        !.
  startup_entry(Lbox_code,Index,"Sending"):-
        retract(list_entry(Lbox_code,Index,_,From,To,Timer,Delete,U_id,U_pwd,_,Remdir,ADV_OPTS,Profile)),
        assert(list_entry(Lbox_code,Index,"Waiting",From,To,Timer,Delete,U_id,U_pwd,-1,Remdir,ADV_OPTS,Profile)),
        Str=form_str(Index,"Waiting",From,To,Timer),
        lbox_del_pos(Lbox_code,Index,Str),        
        not(on_work),
	fa_dialog(DlgWin),
        win_PostEvent(DlgWin,e_Native(msg_is_on,0,0)),!.
  startup_entry(_Lbox_code,_Index,"Sending"):-!.        
  startup_entry(Lbox_code,Index,"Receiving"):-
        retract(list_entry(Lbox_code,Index,_,From,To,Timer,Delete,U_id,U_pwd,_,Remdir,ADV_OPTS,Profile)),
        assert(list_entry(Lbox_code,Index,"Waiting",From,To,Timer,Delete,U_id,U_pwd,-1,Remdir,ADV_OPTS,Profile)),
        Str=form_str(Index,"Waiting",From,To,Timer),
        lbox_del_pos(Lbox_code,Index,Str),        
        not(on_work),
	fa_dialog(DlgWin),
        win_PostEvent(DlgWin,e_Native(msg_is_on,0,0)),!.
  startup_entry(_Lbox_code,_Index,"Receiving"):-!.
  
       
  check_read_els():-
  	list_entry(Lbox_code,Index,Status,From,To,Timer,_,_,_,_,_,_,_),
  		Str_box=form_str(Index,Status,From,To,Timer),
  		els_code_win(Lbox_code,LboxWin),
		lbox_Suspend(LboxWin),
        	lbox_Add(LboxWin,Index,Str_box),
		lbox_SetSel(LboxWin,Index,b_true),
		lbox_Resume(LboxWin),
	fail.
  check_read_els():-
	list_entry(Lbox_code,Index,Status,_,_,_,_,_,_,_,_,_,_),
		assert(startUp_lst(Lbox_code,Index,Status)),
	fail.
  check_read_els():-
  	retract(startUp_lst(Lbox_code,Index,Status)),
  		startup_entry(Lbox_code,Index,Status),
  	fail.
  check_read_els().
  
  els_code(0,idc_send):-!.
  els_code(1,idc_receive):-!.
  els_code_win(0,Win):-
	fa_dialog(DlgWin),
	Win = win_GetCtlHandle(DlgWin,idc_send),!.
  els_code_win(1,Win):-
	fa_dialog(DlgWin),
	Win = win_GetCtlHandle(DlgWin,idc_receive),!.
	
  sort_entries(Numb):-
  	retract(list_entry(Lbox_code,Numb,X,A,B,C,D,E,F,0,G,H,K)),
  		assertz(list_entry(Lbox_code,Numb,X,A,B,C,D,E,F,-2,G,H,K)),
  	fail.
  sort_entries(Numb):-
  	NN = Numb + 1,
  	list_entry(_,NN,_,_,_,_,_,_,_,_,_,_,_),!,
  	sort_entries(NN).
  sort_entries(_):-
  	retract(list_entry(Lbox_code,Numb,X,A,B,C,D,E,pwd(PWD1,PWD2),-2,G,H,K)),
  		pwd_check(pwd(PWD1,PWD2),PWD3),
  		assertz(list_entry(Lbox_code,Numb,X,A,B,C,D,E,pwd(PWD1,PWD3),0,G,H,K)),
  	fail.
  sort_entries(_).
  
%predicates for read program data - consults from ini file.
  read_base():-
	disk(Path),
	filenamepath(FullName,Path,"ftpagent.ini"),
	trap(consult(FullName,synch_els),_,true),!,
	options(_,_,dbg(DE,_),_,NetTimeOut),
	is_debug(DE,NetTimeOut).
  read_base():-						%consult failed
  	read_base_checkBAK().

%new feature: if ini file is broken (consult failed) then the current ini is renamed to bak and 
%defaults are written to ini file
  read_base_checkBAK():-
  	disk(Path),
	filenamepath(FullName,Path,"ftpagent.bak"),
  	trap(openread(file_ini,FullName),_,true),!,
  	closefile(file_ini),
  	dlg_error("The file ftpagent.ini is corrupt!\n ftpagent.bak exits!\n Correct ftpagent.ini or delete ftpagent.bak!"),
  	timer_pos(Timer_Id),
  	retractall(timer_pos(_)),
        timer_Kill(Timer_Id),
        retractall(fa_dialog(_)),
	P_win = vpi_GetTaskWin(),
  	win_Destroy(P_win),
  	!.
  read_base_checkBAK():-				% ftpagent.bak does not exists
  	disk(CurPath),
  	filenamepath(FullName,CurPath,"ftpagent.ini"),
	filenamepath(FullNameBak,CurPath,"ftpagent.bak"),
  	copyfile(FullName,FullNameBak),
  	dlg_error("The file ftpagent.ini is corrupt!\n ftpagent.ini was copied to ftpagent.bak!\n Defaults are used!"),
  	retractall(options(_,_,_,_,_)),
  	retractall(list_entry(_,_,_,_,_,_,_,_,_,_,_,_,_)),
  	retractall(profiles(_,_,_,_,_,_,_,_,_)),
	filenamepath(FullName1,CurPath,"ftpagent.log"),
	filenamepath(FullName2,CurPath,"ftpagent.dbg"),
  	assert(options(log(b_false,FullName1),"guest",dbg(b_false,FullName2),1,60)),
  	is_debug(b_false,60),
  	!.
  	
%predicates perform a save of program data in ini file when some modifications in this data are done 
%during session
  save_base_intermediate():-
  	copy_Entries(),
	save_base_intermed(),
  	copy_Entries_Back(),
  	!.
  save_base_intermediate().
  
  copy_Entries():-
  	retractall(l_e(_,_,_,_,_,_,_,_,_,_,_,_,_)),
  	fail.
  copy_Entries():-
  	list_entry(A,B,C,D,E,F,G,H,I,J,K,L,M),
  		assert(l_e(A,B,C,D,E,F,G,H,I,J,K,L,M)),
  	fail.
  copy_Entries().
  
  copy_Entries_Back():-
  	retractall(list_entry(_,_,_,_,_,_,_,_,_,_,_,_,_)),
  	fail.
  copy_Entries_Back():-
  	retract(l_e(A,B,C,D,E,F,G,H,I,J,K,L,M)),
  		assert(list_entry(A,B,C,D,E,F,G,H,I,J,K,L,M)),
  	fail.
  copy_Entries_Back().
  	
  save_base_intermed():-
  	check_save_els(),
  	disk(Path),
	filenamepath(FullName,Path,"ftpagent.ini"),
	trap(save(FullName,synch_els),_,dlg_error("Can not save program information in the file ftpagent.ini!")),
	!.
  save_base_intermed():-!.
  	
%predicates for save program data - saves at ini file.
  save_base():-
  	check_save_els(),
  	disk(Path),
	filenamepath(FullName,Path,"ftpagent.ini"),
	trap(save(FullName,synch_els),_,dlg_error("Can not save program information in the file ftpagent.ini!")),
	retractall(options(_,_,_,_,_)),
  	retractall(list_entry(_,_,_,_,_,_,_,_,_,_,_,_,_)),
  	retractall(profiles(_,_,_,_,_,_,_,_,_)),!.
  save_base():-
  	retractall(options(_,_,_,_,_)),
  	retractall(list_entry(_,_,_,_,_,_,_,_,_,_,_,_,_)),
  	retractall(profiles(_,_,_,_,_,_,_,_,_)),!.

%sets the debug info handler if debug info is turned on in program options
  is_debug(1,Net):-
  	ftplay_MiscOptions( get_debug_info, Net ),!.
  is_debug(0,Net):-
	NULL_ptr = cast( FTPLAY_DEBUG_HNDL, 0 ),
  	ftplay_MiscOptions( NULL_ptr, Net ),
  	!.
  is_debug(_,_).

%writes header information in log, dbg files upon session start up.
  write_Headers():-
  	options( log(1,FileName),_,_,_,_),
  	format( Str_prn, "\n\tFTPAgent %s\n\tCopyright (c) 1996-98\n\tProlog Development Center A/S\n", fa_version ),
  	write_log_wnd( Str_prn, FileName ),
  	fail.
  write_Headers():-
	options(_,_,dbg(1,FileName),_,_),
  	format( Str_prn, "\n\tFTPAgent %s\n\tCopyright (c) 1996-98\n\tProlog Development Center A/S\n", fa_version ),
  	write_log_wnd( Str_prn, FileName ),
  	fail.
  write_Headers().
  	
%_______predicates for password processing - stores a password at FTP server in ini file encoded base64
  pwd_str_bin(Str,Bin):-
  	bound(Str),
  	code_base64(Str,U_pwd_c),
  	term_bin(STRING,U_pwd_c,Bin),!.
  pwd_str_bin(Str,Bin):-
  	bound(Bin),
  	term_bin(STRING,Upwd_c,Bin),
  	code_base64(Str,Upwd_c),!.
  	
%checks if password saving in ini file is allowed, if not empty binary is stored in file
  pwd_check(pwd(b_true,Upwd_bin),Upwd_bin):-!.
  pwd_check(pwd(b_false,_),$[00]):-!.
  
        
PREDICATES
  is_in_queue(INTEGER,INTEGER,INTEGER,INTEGER)
  is_endtm(INTEGER,INTEGER,INTEGER,INTEGER)
  increm_timer()
  is_left()
  
CLAUSES

%finds out entries with Waiting status
  increm_timer():-
        list_entry(Lbox_code,Index,"Waiting",_,_,Timer_value,_,_,_,Cur_timer,_,_,_),
        	not(modified_listentry( Lbox_code, Index )),
		is_in_queue(Lbox_code,Index,Timer_value,Cur_timer),
        fail.
  increm_timer():-
  	retractall( modified_listentry( _, _ ) ),
        not(on_work),
	fa_dialog(DlgWin),
        win_PostEvent(DlgWin,e_Native(msg_is_on,0,0)),
        !.
  increm_timer().

%predicate tests is given list_entry already in queue for beginning of sync
  is_in_queue(_,_,_,-1):-!.
  is_in_queue(Lbox_code,Index,Timer_value,Cur_timer):-
        New_Cur_timer=Cur_timer + 1,
        is_endtm(Lbox_code,Index,New_Cur_timer,Timer_value),
        assert( modified_listentry( Lbox_code,Index ) ),
        !.


clauses
%if database is readonly, skip current syncronization ( 0 as timer counter).
  is_endtm(Lbox_code,Index,Timer_value,Timer_value):-
        Lbox_code = 0, %only for sending
        format(OSFileName,filename_dba_send,Index),
        existfile(OSFileName),
        fileattrib(OSFileName,Attribute),
        bitand(Attribute,fa_rdonly,Z), Z = fa_rdonly, %file is readonly.
        retract(list_entry(Lbox_code,Index,_,From,To,Timer_value,Delete,U_Id,U_pwd,_,Remdir,Adv,Prof)),
        !,
        assert(list_entry(Lbox_code,Index,"Waiting",From,To,Timer_value,Delete,
            U_Id,U_pwd,0,Remdir,Adv,Prof)).
%if timer isn't complete then CurTimer of list_entry increases, otherwise list_entry is moved to the queue 
%(-1 is mark of queue)
  is_endtm(Lbox_code,Index,New_Cur_timer,Timer_value):-
        New_Cur_timer=Timer_value,!,
        retract(list_entry(Lbox_code,Index,_,From,To,Timer_value,Delete,U_Id,U_pwd,_,Remdir,Adv,Prof)),
        assert(list_entry(Lbox_code,Index,"Waiting",From,To,Timer_value,Delete,U_Id,U_pwd,-1,Remdir,Adv,Prof)),
        !.
  is_endtm(Lbox_code,Index,New_Cur_timer,_):-
        retract(list_entry(Lbox_code,Index,_,From,To,Timer_value,Delete,U_Id,U_pwd,_,Remdir,Adv,Prof)),
        assert(list_entry(Lbox_code,Index,"Waiting",From,To,Timer_value,Delete,
            U_Id,U_pwd,New_Cur_timer,Remdir,Adv,Prof)),
        !.

%looks for entris in queue and starts sync if there is no other active sync.
  is_left():-
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,-1,_,_,_),!,
	not(on_work),
        assert(on_work),
        file_str(filename_on_work,"On"),
        assert(entry_cur_retry(Lbox_code,Index,1)),
        send_or_receive(Lbox_code,Index),
        !.
  is_left():-!.

%predicate checks Use Firewall check-box value
  is_fw(_Win,1,Str_v,P_v):-
	change_to_en(_Win,[idct_port,idct_host_name,idc_firewall_information,idc_h_name,idc_port]),
	dialog_SetFields(_Win,[df(idc_h_name, editstr(Str_v,[mandatory]), str_prompt("Host name for firewall"))]),
	dialog_SetFields(_Win,[df(idc_port,editlong(P_v,[mandatory,range(1,65535)]),str_prompt("Port number for firewall"))]),	  	
	!.
  is_fw(_Win,0,Str_v,P_v):-	
	change_to_dis(_Win,[idct_port,idct_host_name,idc_firewall_information,idc_h_name,idc_port]),
	dialog_SetFields(_Win,[df(idc_h_name, editstr(Str_v,[]), nopr)]),
	dialog_SetFields(_Win,[df(idc_port,editlong(P_v,[]),nopr)]),		
	!.	  
  
%predicate changes title of New dialog
  set_title(Win,Title):-
       global_win(0,_),!,
       concat(Title," - SendList",Whole_title),
       win_SetText(Win,Whole_title).
  set_title(Win,Title):-
       concat(Title," - ReceiveList",Whole_title),
       win_SetText(Win,Whole_title).

%predicate gets and checks information from edit fields of New dialog
  check_new_dialog(Win,Str_e1n,State,Tm_value,Str_e2n,User_Id1,User_pwd1,Remdir2):-
        First_hndl=win_GetCtlHandle(Win,idc_sour),
        Second_hndl=win_GetCtlHandle(Win,idc_dest),
        Timer_hndl=win_GetCtlHandle(Win,idc_timer),
        State_hndl=win_GetCtlHandle(Win,idc_check_del),
        U_Id_hndl=win_GetCtlHandle(Win,idc_browse_address_2),
        U_pwd_hndl=win_GetCtlHandle(Win,idc_browse_address_3),
        Rem_dir_hndl=win_GetCtlHandle(Win,idc_rem_dirry),
        Str_e1=win_GetText(First_hndl),
        Str_e2=win_GetText(Second_hndl),
        Str_tm=win_GetText(Timer_hndl),
        User_Id=win_GetText(U_Id_hndl),
        User_pwd=win_GetText(U_pwd_hndl),
        Remdir=win_GetText(Rem_dir_hndl),
        check_tm(Str_tm),
        str_int(Str_tm,Tm_value),
        strip_leading_spaces(Str_e1,Str_e1n),
        check_path(Str_e1n),
        strip_leading_spaces(Str_e2,Str_e2n),
        check_null(Str_e2n,"Host name is null"),
        strip_leading_spaces(User_Id,User_Id1),
        check_null(User_Id1,"User ID is null!"),
        strip_leading_spaces(User_pwd,User_pwd1),
        check_null(User_pwd1,"User password is null!"),
        strip_leading_spaces(Remdir,Remdir1),
        check_DirNull(Remdir1,Remdir2),
        State = win_IsChecked(State_hndl),
        !.

%predicate fills edit fileds of New dialog
  fill_edit_dialog(0,Win,From,State,Timer,To,User_Id,User_pwd,Remdir):-
	Timer_hndl=win_GetCtlHandle(Win,idc_timer),
	State_hndl=win_GetCtlHandle(Win,idc_check_del),
	U_Id_hndl=win_GetCtlHandle(Win,idc_browse_address_2),
	U_pwd_hndl=win_GetCtlHandle(Win,idc_browse_address_3),
	Remdir_hndl=win_GetCtlHandle(Win,idc_rem_dirry),
	str_int(Str_timer,Timer),
	win_SetText(Timer_hndl,Str_timer ),
	is_anonym(Win,User_Id),
	win_SetText(U_Id_hndl,User_Id ),
	win_SetText(U_pwd_hndl,User_pwd),
	win_SetText(Remdir_hndl,Remdir),
	win_Check(State_hndl,State),
	First_hndl=win_GetCtlHandle(Win,idc_sour),
	Second_hndl=win_GetCtlHandle(Win,idc_dest),
	win_SetText(First_hndl,From ),
	win_SetText(Second_hndl,To ),!.
  fill_edit_dialog(1,Win,From,State,Timer,To,User_Id,User_pwd,Remdir):-
  	Timer_hndl=win_GetCtlHandle(Win,idc_timer),
       	State_hndl=win_GetCtlHandle(Win,idc_check_del),
       	U_Id_hndl=win_GetCtlHandle(Win,idc_browse_address_2),
       	U_pwd_hndl=win_GetCtlHandle(Win,idc_browse_address_3),
       	Remdir_hndl=win_GetCtlHandle(Win,idc_rem_dirry),
       	str_int(Str_timer,Timer),
       	win_SetText(Timer_hndl,Str_timer ),
	is_anonym(Win,User_Id),	       	
       	win_SetText(U_Id_hndl,User_Id ),
       	win_SetText(U_pwd_hndl,User_pwd),
       	win_SetText(Remdir_hndl,Remdir),
       	win_Check(State_hndl,State),       
       	First_hndl=win_GetCtlHandle(Win,idc_sour),
       	Second_hndl=win_GetCtlHandle(Win,idc_dest),
       	win_SetText(First_hndl,To),
       	win_SetText(Second_hndl,From).

%disables the check box "Save password" if anonymous logon is chosen
  is_anonym(Win,U_Id):-
  	U_Id = "Anonymous",!,
	Win_ch = win_GetCtlHandle(Win,idc_anonymous_logon),
	win_Check(Win_ch, b_true),
	Savepwd_win = win_GetCtlHandle( Win,idc_save_password ),
	win_SetState( Savepwd_win, [wsf_Disabled] ),
	!.
  is_anonym(Win,U_Id):-
  	U_Id <> "Anonymous",!,
	Win_ch =win_GetCtlHandle(Win,idc_anonymous_logon),
	win_Check(Win_ch, b_false),!.


%connects Check box state and word in list-box string
%###legacy - should be once upon a time changed to normal code
  del_state(1,"Yes").
  del_state(0,"No").

%predicate for deleting internal dbases of list_entries
  del_db(0,Index):-
        format(OSFileName,"send%d.db",Index),
        deletefile(OSFileName),!.
  del_db(1,Index):-
        format(OSFileName,"recv%d.db",Index),
        deletefile(OSFileName),!.

%returns the name of profile under which the info is stored
  is_sel_in_lb(_Win,Prof_name):-
  	Pflist_hndl = win_GetCtlHandle(_Win,idc_pf_list),
        Ind_sel = lbox_GetSelIndex(Pflist_hndl),
        Prof_name = lbox_GetItem(Pflist_hndl,Ind_sel),
        pfini_save(_Win),
        !.
  is_sel_in_lb(_Win,Prof_name):-
  	Pflist_hndl = win_GetCtlHandle(_Win,idc_pf_list),
  	not(lbox_GetSelIndex(Pflist_hndl)),
  	Prof_name1 = win_GetText(Pflist_hndl),
  	strip_leading_spaces(Prof_name1,Prof_name),
  	Prof_name <> "",
  	pfini_save(_Win),
  	!.
  is_sel_in_lb(_Pflist_hndl,"").

%handler for debug info - called from FTP Layer.
  get_debug_info(Str):-
  	options(_,_,dbg(1,FileName),_,_),
  	write_log_wnd(Str,FileName),!.
  get_debug_info(_).
  
ifdef platform_16bit
PREDICATES
  procedure check_size_16bit(STRING,ULONG,STRING) - (i,i,o)
  
CLAUSES

%predicates perform file_str for long files under 16-bit platform 
  check_size_16bit(FileName, Size, Str_file):-
  	Size <= 65535,
  	file_str(FileName,Str_file),!.
  check_size_16bit(FileName, Size, Str_file):-
  	RestPos = Size - 65280,
	trap(openread(file_ini,FileName),_,dlg_error("Can not open log file")),
	readdevice(Old),
	readdevice(file_ini),
	filepos(file_ini,RestPos,0),
	trap(readblock(0,Binary),_,dlg_error("Can not read log file")),
	readdevice(Old),
	closefile(file_ini),
	trap(openwrite(file_ini,"log.tmp"),_,dlg_error("Can not open tmp log file")),
	writedevice(Old1),
	writedevice(file_ini),
	trap(writeblock(0,Binary),_,dlg_error("Can not write to tmp log file")),
	writedevice(Old1),
	closefile(file_ini),
	trap(file_str("log.tmp",Str_file),_,dlg_error("Can not read tmp log file")),
	trap(deletefile("log.tmp"),_,dlg_error("Can not delete tmp log file")),
	!.
  check_size_16bit(_,_,""):-
  	closefile(file_ini).
	
  file_str_16bit(FileName, Str_file):-
	diropen(FileName,fa_normal,InfoBlock),
	dirmatch(InfoBlock,_,_,_,_,_,_,_,_,Size),
	dirclose(InfoBlock),
	check_size_16bit(FileName, Size,Str_file),!.
  file_str_16bit( _, "" ).

enddef

%predicates create a null window that receive messages from FTP Layer
PREDICATES
  scan_init()
  scan_event_eh : ehandler
CLAUSES
  scan_init():-
        not(scan_window(_)),
        ScreenWindow = cast(window,vpi_GetAttrVal(attr_screen_window)),
        WinDefs = [dlg(wdef(wd_ModeLess,rct(0,0,0,0),"",u_Pixels),[wsf_Invisible,wsf_Disabled])],
        CreateData = cast(long,0),
        win_CreateDynDialog(ScreenWindow,WinDefs,scan_event_eh,CreateData),
        !.
  scan_init().

  scan_event_eh(Win,e_Create(_),0):-
        assert(scan_window(Win)),
        win_EnableHook(Win, b_true),
        !.
  scan_event_eh(_Win,e_Native(scan_mes,Socket,0),0):-
        Answ=ftplay_GetAnswer(Socket),!,
        scan_process_answer(Socket,Answ),
        !.

        
%BEGIN_WIN Task Window
/***************************************************************************
        Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 13:43:34-26.11.1999, Code automatically updated!
  task_win_Flags = [wsf_TitleBar,wsf_Minimize,wsf_ClipSiblings,wsf_Close]
  task_win_Menu  = no_menu
  task_win_Title = "FTPAgent"
  task_win_Help  = idh_main_window
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 13:43:34-26.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 13:43:34-26.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
        msg_Create(1000),
ENDDEF
        scan_init(),
	class_Create("set_dir",setdir_handler),
	class_Create("fa_pict",fa_pict_handler),
	dlg_ftpagent_Create(_Win),
        !.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	class_Destroy("set_dir"),
	class_Destroy("fa_pict"),
	ftplay_closeall(),
        ftplay_bye(),
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, e_EndSession
%KI 05.08.1998 - FTPAgent should ignore WM_ENDSESSION to be able to run as service
/*  task_win_eh(_Win,e_EndSession(_AbortPossible),0):-!,
        retract(timer_pos(Timer_Id)),
        timer_Kill(Timer_Id),
        retractall(global_win(_,_)),
        save_base(),
        kill_sockets(),
        retractall(options(_,_,_,_,_)),
        win_Destroy(_Win),
        fail.*/
%END Task Window, e_EndSession

%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest,0):-
        retract(timer_pos(Timer_Id)),
        timer_Kill(Timer_Id),
        retractall(global_win(_,_)),
        save_base(),
        kill_sockets(),
        retractall(options(_,_,_,_,_)),
        fail.
%END Task Window, e_CloseRequest

%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
        toolbar_Resize(_Win),
ENDDEF
IFDEF use_message
        msg_Resize(_Win),
ENDDEF
        Wsflags = win_GetState(_Win),
        not(member(Wsflags,wsf_Disabled)),
        not(member(Wsflags,wsf_Minimized)),
        global_win(Lbox_code,_),
        fa_dialog(DlgWin),
        change_mode_status(DlgWin,Lbox_code),
        !.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
        Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
ifdef platform_16bit
  	vpi_ShowHelpContext("ftpa_w16.hlp",HelpTopic),
elsedef
  	vpi_ShowHelpContext("ftpagent.hlp",HelpTopic),
enddef
 	!.

/***************************************************************************
        Main Goal
***************************************************************************/

GOAL
%exceptionsHandling(0),
IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
ENDDEF
IFDEF use_tbar
  vpi_SetAttrVal(attr_win_tbar,use_tbar),
ENDDEF
IFDEF use_sbar
  vpi_SetAttrVal(attr_win_sbar,use_sbar),
ENDDEF
  vpi_Init(task_win_Flags,task_win_eh,no_menu,"FTPAgent",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
        Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 12:05:46-25.1.2000, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_about_dialog
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

%BEGIN About dialog, e_Create
  dlg_about_dialog_eh(_Win,e_Create(_CreationData),0):-
	CtrlWin = win_GetCtlHandle(_Win, idc_dlg_about_st_nomb),
	format(Str,"Version %s",fa_version),
	win_SetText(CtrlWin, Str),
	!.
%END About dialog, e_Create

%BEGIN About dialog, idc_help _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
        project_ShowHelpContext(dlg_about_dialog_Help),
        !.
%END About dialog, idc_help _CtlInfo

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog

%BEGIN_DLG New
/**************************************************************************
        Creation and event handling for dialog: New
**************************************************************************/

CONSTANTS

%BEGIN New, CreateParms, 19:13:09-21.1.1998, Code automatically updated!
  dlg_new_ResID = idd_new_edit
  dlg_new_DlgType = wd_Modal
  dlg_new_Help = idh_new_edit_dialog
%END New, CreateParms

PREDICATES

  dlg_new_eh : EHANDLER

CLAUSES

  dlg_new_Create(Parent):-
        win_CreateResDialog(Parent,dlg_new_DlgType,dlg_new_ResID,dlg_new_eh,0),
        !.
%BEGIN New, idc_ok _CtlInfo
  dlg_new_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
        global_win(Lbox_code,_),
        els_code_win(Lbox_code,LboxWin),
        check_new_dialog(_Win,Str_e1n,State,Tm_value,Str_e2n,User_Id1,User_pwd,Remdir1),
        Status = "Stopped",
        is_rec(Cur),
        is_sel_in_lb(_Win,Prof_name),
        retract(adv_vals(ADV)),!,
	SvPwd_h = win_GetCtlHandle(_Win, idc_save_password),
	SvPwd = win_IsChecked(SvPwd_h),
	pwd_str_bin(User_pwd,User_pwd1),
        is_new_or_edit(Cur,Lbox_code,Status,Str_e1n,Str_e2n,Tm_value,State,User_Id1,pwd(SvPwd,User_pwd1),Remdir1,ADV,Prof_name),
        win_Destroy(_Win),
        retractall(global_win(_,_)),
        Ind = lbox_GetSelIndex(LboxWin),
        assert(global_win(Lbox_code,Ind)),
        retractall(flag_new_edit(_)),
        save_base_intermediate(),
        fa_dialog(DlgWin),
        set_focus(DlgWin,Lbox_code),
        !.
%END New, idc_ok _CtlInfo
%MARK New, new events

%BEGIN New, idc_advanced _CtlInfo
  dlg_new_eh(_Win,e_Control(idc_advanced,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	adv_vals(ADV),
        dlg_advanced_Create(_Win,ADV),!.
%END New, idc_advanced _CtlInfo

%BEGIN New, idc_anonymous_logon _CtlInfo
  dlg_new_eh(_Win,e_Control(idc_anonymous_logon,_CtrlType,CtrlWin,activated()),0):-
	Res = win_IsChecked(CtrlWin),
	Res = 1,!,
	Pwd_win = win_GetCtlHandle(_Win,idc_browse_address_3),
	U_id_win = win_GetCtlHandle(_Win,idc_browse_address_2),
	options(_,Em,_,_,_),
	win_SetText(Pwd_win,Em),
	win_SetText(U_id_win,"Anonymous"),
	Savepwd_win = win_GetCtlHandle(_Win, idc_save_password ),
	win_Check(Savepwd_win, checkbox_on),
	win_SetState(Savepwd_win, [wsf_Disabled]),
	!.
  dlg_new_eh(_Win,e_Control(idc_anonymous_logon,_CtrlType,CtrlWin,activated()),0):-
	Res = win_IsChecked(CtrlWin),
	Res = 0,!,
	Pwd_win = win_GetCtlHandle(_Win,idc_browse_address_3),
	U_id_win = win_GetCtlHandle(_Win,idc_browse_address_2),
	win_SetText(Pwd_win,""),
	win_SetText(U_id_win,""),
	Savepwd_win = win_GetCtlHandle(_Win, idc_save_password ),
	win_Check(Savepwd_win, checkbox_off),
	win_SetState(Savepwd_win, [wsf_Enabled]),
	!.
%END New, idc_anonymous_logon _CtlInfo

%BEGIN New, idc_help _CtlInfo
  dlg_new_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
        project_ShowHelpContext(dlg_new_Help),
        !.
%END New, idc_help _CtlInfo

%BEGIN New, idc_pf_list selchanged
  dlg_new_eh(_Win,e_Control(idc_pf_list,_CtrlType,_CtrlWin,selchanged),0):-!,
        pfini_load_item(_Win),
        !.
%END New, idc_pf_list selchanged

%BEGIN New, idc_pf_new _CtlInfo
  dlg_new_eh(_Win,e_Control(idc_pf_new,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
        pfini_new(_Win),
        !.
%END New, idc_pf_new _CtlInfo

%BEGIN New, idc_pf_delete _CtlInfo
  dlg_new_eh(_Win,e_Control(idc_pf_delete,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
        pfini_delete(_Win),
        !.
%END New, idc_pf_delete _CtlInfo

%BEGIN New, e_CloseRequest
  dlg_new_eh(_Win,e_CloseRequest,0):-
        retractall(flag_new_edit(_)),
        retractall(adv_vals(_)),
        fail.
%END New, e_CloseRequest

%BEGIN New, e_Create
  dlg_new_eh(Win,e_Create(_CreationData),0):-
  	is_receive(Win),
        flag_new_edit(State),
        State = 0,!,
        set_title(Win,"New"),
        assert(adv_vals(adv_opts(21,proxy(0,"",0),b_false,b_false,b_false, b_false ))),
        pfini_load(Win),!.
 dlg_new_eh(_Win,e_Create(_CreationData),0):-
        set_title(_Win,"Edit"),
	global_win(Lbox_code,Index),
        list_entry(Lbox_code,Index,_,From,To,Timer,Delete,User_Id,pwd(SvPwd,User_pwd),_,Remdir,ADV_OPTS,Prof),
        del_state(State,Delete),
        is_rec(Cur),
        pwd_str_bin(User_pwd_str,User_pwd),
        fill_edit_dialog(Cur,_Win,From,State,Timer,To,User_Id,User_pwd_str,Remdir),
        assert(adv_vals(ADV_OPTS)),
        pfini_load(_Win),
        Pflist_hndl=win_GetCtlHandle(_Win,idc_pf_list),
	win_SetText(Pflist_hndl,Prof),
	SvPwd_h = win_GetCtlHandle(_Win, idc_save_password),
	win_Check(SvPwd_h, SvPwd),
        !.
%END New, e_Create

%BEGIN New, idc_cancel _CtlInfo
  dlg_new_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
        win_Destroy(_Win),
        retractall(flag_new_edit(_)),
        retractall(adv_vals(_)),        
        !.
%END New, idc_cancel _CtlInfo

%BEGIN New, idc_browse_dirry _CtlInfo
  dlg_new_eh(_Win,e_Control(idc_browse_dirry,_CtrlType,_CtrlWin,_CtlInfo),0):-
	Cnt = win_GetCtlHandle(_Win,idc_sour),
	Current_path = win_GetText(Cnt),
	trap(dirfiles(Current_path,fa_subdir,_,_,_,_,_,_,_,_,_),_,true),!,
        1 = dlg_GetDirectoryName(_Win,Current_path,NewPath),
        Ctrl_hndl =win_GetCtlHandle(_Win, idc_sour),
        win_SetText(Ctrl_hndl,NewPath),
        !.
  dlg_new_eh(_Win,e_Control(idc_browse_dirry,_CtrlType,_CtrlWin,_CtlInfo),0):-
        disk(Current_path),
        1 = dlg_GetDirectoryName(_Win,Current_path,NewPath),
        Ctrl_hndl =win_GetCtlHandle(_Win, idc_sour),
        win_SetText(Ctrl_hndl,NewPath),
        !.
%END New, idc_browse_dirry _CtlInfo

  dlg_new_eh(_,_,_):-!,fail.

%END_DLG New
%BEGIN_DLG Options
/**************************************************************************
	Creation and event handling for dialog: Options
**************************************************************************/

CONSTANTS

%BEGIN Options, CreateParms, 22:14:30-19.3.1997, Code automatically updated!
  dlg_options_ResID = idd_options
  dlg_options_DlgType = wd_Modal
  dlg_options_Help = idh_options
%END Options, CreateParms

PREDICATES

  dlg_options_eh : EHANDLER
  dlg_options_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_options_Create(Parent):-

	options(log(IDC_ENABLE_LOG_CHECKED,_),IDC_E_MAIL_VALUE,dbg(IDC_DEBUG_INFO_CHECKED,_),Vl1,Vl2),
	IDC_SYNCH_VALUE = i(Vl1),
	IDC_NET_TIME_VALUE = i(Vl2),
%MARK Options, new variables
	dialog_CreateModal(Parent,dlg_options_ResID,"",
  		[
%BEGIN Options, ControlList, 22:14:30-19.3.1997, Code automatically updated!
		df(idc_synch,editint(IDC_SYNCH_VALUE,[mandatory,default(1),range(1,10)]),str_prompt("Synchronization retry")),
		df(idc_net_time,editint(IDC_NET_TIME_VALUE,[mandatory,default(60),minimum(10)]),str_prompt("Network timeout")),
		df(idc_enable_log,checkbox(IDC_ENABLE_LOG_CHECKED),nopr),
		df(idc_debug_info,checkbox(IDC_DEBUG_INFO_CHECKED),nopr),
		df(idc_e_mail,editstr(IDC_E_MAIL_VALUE,[]),nopr)
%END Options, ControlList
		],
		dlg_options_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_options_update(VALLIST),!.

  dlg_options_update(_VALLIST):-!,
%BEGIN Options, Update controls, 22:14:30-19.3.1997, Code automatically updated!
	_IDC_ENABLE_LOG_CHECKED = dialog_VLGetCheck(idc_enable_log,_VALLIST),
	_IDC_E_MAIL_VALUE = dialog_VLGetstr(idc_e_mail,_VALLIST),
	_IDC_DEBUG_INFO_CHECKED = dialog_VLGetCheck(idc_debug_info,_VALLIST),
	_IDC_SYNCH_VALUE = dialog_VLGetint(idc_synch,_VALLIST),
	_IDC_NET_TIME_VALUE = dialog_VLGetint(idc_net_time,_VALLIST),
%END Options, Update controls
	!.

%MARK Options, new events

%BEGIN Options, idc_debug_info _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_debug_info,_CtrlType,CtrlWin,_CtlInfo),0):-
  	b_true = win_IsChecked(CtrlWin),!,
  	change_to_en(_Win,[idc_debug_path]),
	!.
  dlg_options_eh(_Win,e_Control(idc_debug_info,_CtrlType,CtrlWin,_CtlInfo),0):-
  	b_false = win_IsChecked(CtrlWin),!,
  	change_to_dis(_Win,[idc_debug_path]),
	!.	
%END Options, idc_debug_info _CtlInfo

%BEGIN Options, idc_enable_log _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_enable_log,_CtrlType,CtrlWin,_CtlInfo),0):-
        b_true = win_IsChecked(CtrlWin),!,
        change_to_en(_Win,[idc_log_path]),
        !.
  dlg_options_eh(_Win,e_Control(idc_enable_log,_CtrlType,CtrlWin,_CtlInfo),0):-
        b_false = win_IsChecked(CtrlWin),!,
        change_to_dis(_Win,[idc_log_path]),
        !.
%END Options, idc_enable_log _CtlInfo

%BEGIN Options, idc_help _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(dlg_options_Help),
	!.
%END Options, idc_help _CtlInfo

%BEGIN Options, e_Create
  dlg_options_eh(_Win,e_Create(_CreationData),0):-
  	Font = win_GetFont(_Win),
  	options(log(_,L_path),_,dbg(_,D_path),_,_),
  	L_p_h = win_GetCtlHandle(_Win, idc_log_path),
	D_p_h = win_GetCtlHandle(_Win, idc_debug_path),
	win_SetFont(L_p_h, Font),
	win_SetFont(D_p_h, Font),
	set_dir_set_kind(L_p_h,1),
	set_dir_set_kind(D_p_h,1),
	set_dir_set(L_p_h,L_path),
	set_dir_set(D_p_h,D_path),
	options(log(1,L_path),_,dbg(1,D_path),_,_),
	change_to_en(_Win,[idc_log_path]),
	change_to_en(_Win,[idc_debug_path]),!.
  dlg_options_eh(_Win,e_Create(_CreationData),0):-
  	options(log(1,_),_,dbg(0,_),_,_),
	change_to_en(_Win,[idc_log_path]),
	change_to_dis(_Win,[idc_debug_path]),!.
  dlg_options_eh(_Win,e_Create(_CreationData),0):-
  	options(log(0,_),_,dbg(1,_),_,_),
	change_to_dis(_Win,[idc_log_path]),
	change_to_en(_Win,[idc_debug_path]),!.
  dlg_options_eh(_Win,e_Create(_CreationData),0):-
  	options(log(0,_),_,dbg(0,_),_,_),
	change_to_dis(_Win,[idc_log_path]),
	change_to_dis(_Win,[idc_debug_path]),!.		
%END Options, e_Create

%BEGIN Options, idc_ok _CtlInfo
  dlg_options_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	retractall(options(_,_,_,_,_)),
  	Vls = dialog_GetValues(_Win),
	El = dialog_VLGetCheck(idc_enable_log,Vls),
	Em = dialog_VLGetstr(idc_e_mail,Vls),
	Di = dialog_VLGetCheck(idc_debug_info,Vls),
	Sy1 = dialog_VLGetint(idc_synch,Vls),
	Nt1 = dialog_VLGetint(idc_net_time,Vls),
	Sy1 = i(Sy),
	Nt1 = i(Nt),
	is_debug(Di,Nt),
	L_p_h = win_GetCtlHandle(_Win, idc_log_path),
	D_p_h = win_GetCtlHandle(_Win, idc_debug_path),
	set_dir_get(L_p_h,L_path),
	set_dir_get(D_p_h,D_path),
	assert(options(log(El,L_path),Em,dbg(Di,D_path),Sy,Nt)),
%KI add begin 03.09.1998
        save_base_intermediate(),
%KI add end 03.09.1998
	fail.
%END  Options, idc_ok _CtlInfo

  dlg_options_eh(_,_,_):-!,fail.

%END_DLG Options

%BEGIN_DLG Advanced
/**************************************************************************
	Creation and event handling for dialog: Advanced
**************************************************************************/

CONSTANTS

%BEGIN Advanced, CreateParms, 20:38:41-25.11.1998, Code automatically updated!
  dlg_advanced_ResID = idd_advanced
  dlg_advanced_DlgType = wd_Modal
  dlg_advanced_Help = idh_advanced_dialog
%END Advanced, CreateParms

PREDICATES

  dlg_advanced_eh : EHANDLER
  dlg_advanced_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_advanced_Create(Parent,adv_opts(Val,proxy(IDC_USE_FIREWALL_CHECKED,IDC_H_NAME_VALUE,Val1),IDC_PASSIVE_TRANSFERS_CHECKED,IDC_INCLUDE_SUBDIRECTORIES_CHECKED,IDC_FILENAME_MATCH_CHECKED,IDC_DELETEFILES_CHECKED)):-

	IDC_R_PORT_VALUE = l(Val),
	IDC_PORT_VALUE = l(Val1),
%MARK Advanced, new variables

	dialog_CreateModal(Parent,dlg_advanced_ResID,"",
  		[
%BEGIN Advanced, ControlList, 20:38:41-25.11.1998, Code automatically updated!
		df(idc_r_port,editlong(IDC_R_PORT_VALUE,[mandatory,default(21),range(1,65535)]),str_prompt("Remote port")),
		df(idc_use_firewall,checkbox(IDC_USE_FIREWALL_CHECKED),nopr),
		df(idc_h_name,editstr(IDC_H_NAME_VALUE,[default("")]),nopr),
		df(idc_port,editlong(IDC_PORT_VALUE,[range(1,65535)]),str_prompt("Port")),
		df(idc_passive_transfers,checkbox(IDC_PASSIVE_TRANSFERS_CHECKED),nopr),
		df(idc_include_subdirectories,checkbox(IDC_INCLUDE_SUBDIRECTORIES_CHECKED),nopr),
		df(idc_filename_match,checkbox(IDC_FILENAME_MATCH_CHECKED),nopr),
		df(idc_deletefiles,checkbox(IDC_DELETEFILES_CHECKED),nopr)
%END Advanced, ControlList
		],
		dlg_advanced_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_advanced_update(VALLIST),!.

  dlg_advanced_update(_VALLIST):-
%BEGIN Advanced, Update controls, 20:38:41-25.11.1998, Code automatically updated!
	_IDC_R_PORT_VALUE = dialog_VLGetlong(idc_r_port,_VALLIST),
	_IDC_USE_FIREWALL_CHECKED = dialog_VLGetCheck(idc_use_firewall,_VALLIST),
	_IDC_H_NAME_VALUE = dialog_VLGetstr(idc_h_name,_VALLIST),
	_IDC_PORT_VALUE = dialog_VLGetlong(idc_port,_VALLIST),
	_IDC_PASSIVE_TRANSFERS_CHECKED = dialog_VLGetCheck(idc_passive_transfers,_VALLIST),
	_IDC_INCLUDE_SUBDIRECTORIES_CHECKED = dialog_VLGetCheck(idc_include_subdirectories,_VALLIST),
	_IDC_FILENAME_MATCH_CHECKED = dialog_VLGetCheck(idc_filename_match,_VALLIST),
	_IDC_DELETEFILES_CHECKED = dialog_VLGetCheck(idc_deletefiles,_VALLIST),
%END Advanced, Update controls
	_IDC_R_PORT_VALUE = l(Val),
	_IDC_PORT_VALUE = l(Val1),
	retractall(adv_vals(_)),
	Val_us = cast( USHORT, Val ), 
	Val1_us = cast( USHORT, Val1 ), 
	assert(adv_vals(adv_opts(Val_us,proxy(_IDC_USE_FIREWALL_CHECKED,_IDC_H_NAME_VALUE,Val1_us),_IDC_PASSIVE_TRANSFERS_CHECKED,_IDC_INCLUDE_SUBDIRECTORIES_CHECKED,_IDC_FILENAME_MATCH_CHECKED,_IDC_DELETEFILES_CHECKED))),
	!.
  dlg_advanced_update(_):-
	dlg_Note("Error: Fail in dlg_advanced_update").

%MARK Advanced, new events

%BEGIN Advanced, idc_use_firewall _CtlInfo
  dlg_advanced_eh(_Win,e_Control(idc_use_firewall,_CtrlType,CtrlWin,activated()),0):-
	Res =win_IsChecked(CtrlWin),
	Res = 1,!,
  	Vls = dialog_GetValues(_Win),	
	F_n = dialog_VLGetstr(idc_h_name,Vls),	
	F_p = dialog_VLGetlong(idc_port,Vls),	
	change_to_en(_Win,[idct_port,idct_host_name,idc_firewall_information,idc_h_name,idc_port]),
	dialog_SetFields(_Win,[df(idc_h_name, editstr(F_n,[mandatory]), str_prompt("Host name for firewall"))]),
	dialog_SetFields(_Win,[df(idc_port,editlong(F_p,[mandatory,range(1,65535)]),str_prompt("Port number for firewall"))]),	
	!.
  dlg_advanced_eh(_Win,e_Control(idc_use_firewall,_CtrlType,CtrlWin,activated()),0):-
  	Res =win_IsChecked(CtrlWin),
	Res = 0,!,
  	Vls = dialog_GetValues(_Win),
	F_n = dialog_VLGetstr(idc_h_name,Vls),	
	F_p = dialog_VLGetlong(idc_port,Vls),
	change_to_dis(_Win,[idct_port,idct_host_name,idc_firewall_information,idc_h_name,idc_port]),
	dialog_SetFields(_Win,[df(idc_h_name, editstr(F_n,[]), nopr)]),
	dialog_SetFields(_Win,[df(idc_port,editlong(F_p,[]),nopr)]),		
	!.
%END Advanced, idc_use_firewall _CtlInfo

%BEGIN Advanced, e_Create
  dlg_advanced_eh(_Win,e_Create(_CreationData),0):-!,
	Vls = dialog_GetValues(_Win),
	IDC_USE_FIREWALL_CHECKED = dialog_VLGetCheck(idc_use_firewall,Vls),	  
	IDC_H_NAME_VALUE = dialog_VLGetstr(idc_h_name,Vls),
	IDC_PORT_VALUE = dialog_VLGetlong(idc_port,Vls),
	is_fw(_Win,IDC_USE_FIREWALL_CHECKED,IDC_H_NAME_VALUE,IDC_PORT_VALUE),  	
	!.
%END Advanced, e_Create

%BEGIN Advanced, idc_help _CtlInfo
  dlg_advanced_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(dlg_advanced_Help),
	!.
%END Advanced, idc_help _CtlInfo

  dlg_advanced_eh(_,_,_):-!,fail.

%END_DLG Advanced









%BEGIN_DLG FTPAgent
/**************************************************************************
	Creation and event handling for dialog: FTPAgent
**************************************************************************/

constants

%BEGIN FTPAgent, CreateParms, 13:43:18-26.11.1999, Code automatically updated!
  dlg_ftpagent_ResID = idd_ftpagent
  dlg_ftpagent_DlgType = wd_Modeless
  dlg_ftpagent_Help = idh_main_window
%END FTPAgent, CreateParms

predicates

  dlg_ftpagent_eh : EHANDLER
%  dlg_ftpagent_update(DIALOG_VAL_LIST)

clauses

  dlg_ftpagent_Create(Parent):-

%MARK FTPAgent, new variables

	D_win = dialog_CreateModeless(Parent,dlg_ftpagent_ResID,"",
  		[
%BEGIN FTPAgent, ControlList, 13:43:18-26.11.1999, Code automatically updated!
		df(idc_send,listbox([],[0]),nopr),
		df(idc_receive,listbox([],[0]),nopr)
%END FTPAgent, ControlList
		],
		dlg_ftpagent_eh,0),!,
	D_rct = win_GetClientRect(D_win),
	D_rct = rct(_,_,W,H),
	OuterRct = win_GetOuterRect(Parent),
	In_RCT = rect_GetClient(task_win_Flags,b_false,OuterRct),
	In_RCT = rct(L,T,_,_),
	R = W + L + 2,
	B = H + T + 2,
	win_Move(Parent,rct(L,T,R,B)).
/*
  dlg_ftpagent_update(_VALLIST):-
%BEGIN FTPAgent, Update controls, 13:43:18-26.11.1999, Code automatically updated!
	dialog_VLGetListBox(idc_send,_VALLIST,_IDC_SEND_ITEMLIST,_IDC_SEND_SELECT),
	dialog_VLGetListBox(idc_receive,_VALLIST,_IDC_RECEIVE_ITEMLIST,_IDC_RECEIVE_SELECT),
%END FTPAgent, Update controls
	true.
*/
%MARK FTPAgent, new events

%BEGIN FTPAgent, idc_receive losefocus
  dlg_ftpagent_eh(_Win,e_Control(idc_receive,_CtrlType,_CtrlWin,losefocus),0):-
        global_win(1,_),
        LboxWin=win_GetCtlHandle(_Win,idc_receive),
        Index=lbox_GetSelIndex(LboxWin),
        retractall(global_win(1,_)),
        assert(global_win(1,Index)),
        !.
%END FTPAgent, idc_receive losefocus

%BEGIN FTPAgent, idc_receive getfocus
  dlg_ftpagent_eh(_Win,e_Control(idc_receive,_CtrlType,_CtrlWin,getfocus),0):-
        retractall(global_win(_,_)),
        assert(global_win(1,0)),
        off_focus(_Win,0),
        is_box_empty(_Win,1),
        change_mode_status(_Win,1),fail.
  dlg_ftpagent_eh(_Win,e_Control(idc_receive,_CtrlType,_CtrlWin,getfocus),0):-
        Ic_dn = win_GetCtlHandle(_Win,idc_arrow_dn),
        Ic_up = win_GetCtlHandle(_Win,idc_arrow_up),        
        win_SetState(Ic_dn,[wsf_Visible]),
        win_SetState(Ic_up,[wsf_Invisible]),
        !.
%END FTPAgent, idc_receive getfocus

%BEGIN FTPAgent, idc_send getfocus
  dlg_ftpagent_eh(_Win,e_Control(idc_send,_CtrlType,_CtrlWin,getfocus),0):-
        retractall(global_win(_,_)),
        assert(global_win(0,0)),
        off_focus(_Win,1),
        is_box_empty(_Win,0),
        change_mode_status(_Win,0),fail.
  dlg_ftpagent_eh(_Win,e_Control(idc_send,_CtrlType,_CtrlWin,getfocus),0):-
        Ic_dn = win_GetCtlHandle(_Win,idc_arrow_dn),
        Ic_up = win_GetCtlHandle(_Win,idc_arrow_up),
        win_SetState(Ic_dn,[wsf_Invisible]),
        win_SetState(Ic_up,[wsf_Visible]),
	!.
%END FTPAgent, idc_send getfocus

%BEGIN FTPAgent, idc_send losefocus
  dlg_ftpagent_eh(_Win,e_Control(idc_send,_CtrlType,_CtrlWin,losefocus),0):-
        global_win(0,_),
        LboxWin=win_GetCtlHandle(_Win,idc_send),
        Index=lbox_GetSelIndex(LboxWin),
        retractall(global_win(0,_)),
        assert(global_win(0,Index)),
        !.
%END FTPAgent, idc_send losefocus

%BEGIN FTPAgent, idc_receive selchanged
  dlg_ftpagent_eh(_Win,e_Control(idc_receive,_CtrlType,_CtrlWin,selchanged),0):-!,
	change_mode_status(_Win,1).
%END FTPAgent, idc_receive selchanged

%BEGIN FTPAgent, idc_send selchanged
  dlg_ftpagent_eh(_Win,e_Control(idc_send,_CtrlType,_CtrlWin,selchanged),0):-!,
	change_mode_status(_Win,0).
%END FTPAgent, idc_send selchanged

%BEGIN FTPAgent, e_Native
  dlg_ftpagent_eh(_Win,e_Native(_Message,_WParam,_LParam),0):-
  	is_left(),
	!.
%END FTPAgent, e_Native

%BEGIN FTPAgent, idc_receive activated
  dlg_ftpagent_eh(Win,e_Control(idc_receive,_CtrlType,_CtrlWin,activated),0):-!,
	Win_but = win_GetCtlHandle(Win,idc_start),
	Wsflags = win_GetState(Win_but),
	not(member(Wsflags,wsf_Disabled)),
        assert(flag_new_edit(1)),
        dlg_new_Create(Win),
	!.
%END FTPAgent, idc_receive activated

%BEGIN FTPAgent, idc_send activated
  dlg_ftpagent_eh(Win,e_Control(idc_send,_CtrlType,_CtrlWin,activated),0):-!,
  	Win_but = win_GetCtlHandle(Win,idc_start),
	Wsflags = win_GetState(Win_but),
	not(member(Wsflags,wsf_Disabled)),
        assert(flag_new_edit(1)),
        dlg_new_Create(Win),
	!.
%END FTPAgent, idc_send activated


%BEGIN FTPAgent, idc_log _CtlInfo
  dlg_ftpagent_eh(_Win,e_Control(idc_log,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	win_SendEvent(_Win,e_Menu(id_log,0)),
	!.
%END FTPAgent, idc_log _CtlInfo

%BEGIN FTPAgent, idc_options _CtlInfo
  dlg_ftpagent_eh(_Win,e_Control(idc_options,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	dlg_options_Create(_Win),
	!.
%END FTPAgent, idc_options _CtlInfo

%BEGIN FTPAgent, idc_about _CtlInfo
  dlg_ftpagent_eh(_Win,e_Control(idc_about,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	dlg_about_dialog_Create(_Win),
	!.
%END FTPAgent, idc_about _CtlInfo

%BEGIN FTPAgent, idc_exit _CtlInfo
  dlg_ftpagent_eh(_Win,e_Control(idc_exit,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	win_SendEvent(_Win,e_Menu(id_exit,0)),
	!.
%END FTPAgent, idc_exit _CtlInfo

%BEGIN FTPAgent, idc_start _CtlInfo
  dlg_ftpagent_eh(_Win,e_Control(idc_start,_CtrlType,_CtrlWin,_CtlInfo),0):-
	global_win(Lbox_code,Index),
        retract(list_entry(Lbox_code,Index,_,From,To,Timer,Delete,U_id,U_pwd,_,Remdir,Adv,Prof)),
        assert(list_entry(Lbox_code,Index,"Waiting",From,To,Timer,Delete,U_id,U_pwd,-1,Remdir,Adv,Prof)),
        Str = form_str(Index,"Waiting",From,To,Timer),
        lbox_del_pos(Lbox_code,Index,Str),
        save_base_intermediate(),
        set_focus(_Win,Lbox_code),!,
        not(on_work),
        win_PostEvent(_Win,e_Native(msg_is_on,0,0)),
	!.
%END FTPAgent, idc_start _CtlInfo

%BEGIN FTPAgent, idc_help _CtlInfo
  dlg_ftpagent_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(dlg_ftpagent_Help),
	!.
%END FTPAgent, idc_help _CtlInfo

%BEGIN FTPAgent, idc_edit _CtlInfo
  dlg_ftpagent_eh(_Win,e_Control(idc_edit,_CtrlType,_CtrlWin,_CtlInfo),0):-
        assert(flag_new_edit(1)),
        dlg_new_Create(_Win),
	!.
%END FTPAgent, idc_edit _CtlInfo

%BEGIN FTPAgent, idc_stop _CtlInfo
  dlg_ftpagent_eh(_Win,e_Control(idc_stop,_CtrlType,_CtrlWin,_CtlInfo),0):-
        global_win(Lbox_code,Index),
        stop_entry(Lbox_code,Index),
        save_base_intermediate(),
	change_mode_to_dis(_Win,[idc_stop]),
        set_focus(_Win,Lbox_code),
	!.
%END FTPAgent, idc_stop _CtlInfo

%BEGIN FTPAgent, idc_delete _CtlInfo
  dlg_ftpagent_eh(_Win,e_Control(idc_delete,_CtrlType,_CtrlWin,_CtlInfo),0):-
    	win_SendEvent(_Win,e_Menu(id_delete,0)),!.
%END FTPAgent, idc_delete _CtlInfo

%BEGIN FTPAgent, idc_new _CtlInfo
  dlg_ftpagent_eh(_Win,e_Control(idc_new,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	assert(flag_new_edit(0)),
        dlg_new_Create(_Win),
	!.
%END FTPAgent, idc_new _CtlInfo


%BEGIN FTPAgent, e_Timer
  dlg_ftpagent_eh(_Win,e_Timer(Timer_Id),0):-
  	timer_pos(Timer_Id),!,
        increm_timer().
%END FTPAgent, e_Timer

%BEGIN FTPAgent, e_Create
  dlg_ftpagent_eh(_Win,e_Create(_CreationData),0):-
ifndef platform_16bit  
  	win_SetIcon(_Win,vpi_application_icon),
enddef
  	assert(fa_dialog(_Win)),
        LboxWin1 = win_GetCtlHandle(_Win,idc_send),
        LboxWin2 = win_GetCtlHandle(_Win,idc_receive),
        Font=font_Create(ff_Fixed,[],10),
        win_SetFont(LboxWin1,Font),
        win_SetFont(LboxWin2,Font),
        trap(Timer_Id=timer_Set(_Win,60000),_,dlg_Error("Too many timers (>15)")),
        assert(timer_pos(Timer_Id)),
        check_ness_file(),
        read_base(),
        check_read_els(),
        write_Headers(),
	set_focus(_Win,0),
	change_mode_status(_Win,0),
	!.
%END FTPAgent, e_Create

%BEGIN FTPAgent, e_EndApplication
  dlg_ftpagent_eh(_Win,e_EndApplication(_ApplicationID),0):-
  	retract(timer_pos(Timer_Id)),
        timer_Kill(Timer_Id),
        retractall(global_win(_,_)),
        save_base(),
        kill_sockets(),
        retractall(options(_,_,_,_,_)),
    	P_win = vpi_GetTaskWin(),
	win_Destroy(P_win),
	fail.
%END FTPAgent, e_EndApplication

  dlg_ftpagent_eh(Win,e_Menu(id_new,_),0):-
	C_w = win_GetCtlHandle(Win,idc_new),
	C_flags = win_GetState(C_w),
	not(member(C_flags,wsf_Disabled)),  
        assert(flag_new_edit(0)),
        dlg_new_Create(Win),
        !.
  dlg_ftpagent_eh(Win,e_Menu(id_delete,_),0):-
	C_w = win_GetCtlHandle(Win,idc_delete),
	C_flags = win_GetState(C_w),
	not(member(C_flags,wsf_Disabled)),  
        global_win(Lbox_code,Index),
        els_code_win(Lbox_code,LboxWin),
        resp_default = dlg_Ask("Attention","Are you sure?",["Yes","No",""]),!,
        retract(list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,_,_)),!,
	lbox_Suspend(LboxWin),
        lbox_Delete(LboxWin,Index),
        lbox_SetSel(LboxWin, 0, b_true),
        lbox_Resume(LboxWin),
        del_db(Lbox_code,Index),
        refresh_list(Lbox_code,Index),
        save_base_intermediate(),
        retract(global_win(Lbox_code,Index)),
        trap(assert(global_win(Lbox_code,0)),_,true),        
        set_focus(Win,Lbox_code),
        !.
  dlg_ftpagent_eh(Win,e_Menu(id_edit,_),0):-
	Ed_w = win_GetCtlHandle(Win,idc_edit),
	Ed_flags = win_GetState(Ed_w),
	not(member(Ed_flags,wsf_Disabled)),
        assert(flag_new_edit(1)),
        dlg_new_Create(Win),
        !.
  dlg_ftpagent_eh(_Win,e_Menu(id_help,_),0):-
        project_ShowHelpContext(dlg_ftpagent_Help),!.
  dlg_ftpagent_eh(_Win,e_Menu(id_help1,_),0):-
        project_ShowHelpContext(idh_contents),!.
  dlg_ftpagent_eh(_Win,e_Menu(id_about,_),0):-
        dlg_about_dialog_Create(_Win),!.
  dlg_ftpagent_eh(_Win,e_Menu(id_exit,_),0):-
  	retract(timer_pos(Timer_Id)),
        timer_Kill(Timer_Id),
        retractall(global_win(_,_)),
        save_base(),
        kill_sockets(),
        retractall(options(_,_,_,_,_)),
       	P_win = vpi_GetTaskWin(),
	win_Destroy(P_win),
        !.
  dlg_ftpagent_eh(Win,e_Menu(id_opt,_),0):-
	C_w = win_GetCtlHandle(Win,idc_options),
	C_flags = win_GetState(C_w),
	not(member(C_flags,wsf_Disabled)),  
   	dlg_options_Create(Win),!.
  dlg_ftpagent_eh(_Win,e_Menu(id_log,_),0):-
  	not(log_wind(_)),
	Par_win = cast( window, vpi_GetAttrVal(attr_screen_window)),
	options(log(_,FileName),_,_,_,_),
ifdef platform_32bit
	trap(openappend(file_ini,FileName),_,dlg_error("Log file not found. Path does not exist!")),
	closefile(file_ini),
	file_str(FileName,Str_file),
elsedef
	file_str_16bit(FileName,Str_file),
enddef	
	str_len(Str_file,L),
	L1 = L+1,
        Font=font_Create(ff_System,[],10),
        Flags = [wsf_SizeBorder,wsf_Close,wsf_Minimize,wsf_ClipChildren,wsf_Maximize,wsf_ClipSiblings,wsf_Titlebar,wsf_HScroll,wsf_VScroll],
  	Log_win = edit_Create(w_TopLevel,rct(50,50,600,400),"Log file",res_menu(idr_log_menu),Par_win,Flags,Font,b_true,b_false,Str_file,L1,log_win_eh),
  	assert(log_wind(Log_win)),  	
  	trap(edit_StatusLineShow(Log_win,b_false),_,true),
  	!.
  dlg_ftpagent_eh(_Win,e_Menu(id_log,_),0):-
  	log_wind(Lw),
  	win_BringToTop(Lw),
  	!.

  dlg_ftpagent_eh(_,_,_):-!,fail.

%END_DLG FTPAgent

  fa_pict_handler(Pict_win,e_Update(_),0):-
	Value = vpi_GetAttrVal(attr_color_btnface),
        win_Clear(Pict_win,Value),
        trap(PICT = pict_GetFromRes(idb_pic_main),_,dlg_error("Can not load data!")),
        pict_GetSize(PICT,WIDTH,HEIGHT,_),
 	DESTRECT = win_GetClientRect(Pict_win),
	SOURCERECT = rct(0,0,WIDTH,HEIGHT),
        win_NeedsUpdate(Pict_win,DESTRECT),
	pict_Draw(Pict_win,PICT,DESTRECT,SOURCERECT,rop_SrcCopy),
	pict_Destroy(PICT),
	!.
  fa_pict_handler(_Win,_Ev,0):-fail.






