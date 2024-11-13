/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  WebAgent
 FileName: LOG_WND.PRO
 Purpose: Example of HTTP Layer
 Written by: Konstantin Ivanov
 Comments: Functions for Log window
******************************************************************************/
include "webagent.inc"
include "webagent.con"
include "hlptopic.con"

PREDICATES
  procedure make_time(STRING) - (o)
  
CLAUSES
  
  log_win_eh(_Win,e_Menu(id_File_exit,_),0):-
	win_Destroy(_Win),
	retract(log_wind(_A)),
  	!.
  log_win_eh(_Win,e_Menu(id_File_save_as,_),0):-
  	File_name = dlg_GetFileName("*.*",["All files","*.*"],"Save log information",[dlgfn_Save],"",_FileName),
  	Log_str = edit_GetText(_Win),
	trap(file_str(File_name,Log_str),_,dlg_error("Unable to save information!")),
    	!.
  log_win_eh(_Win,e_Menu(id_clear_log_file,_),0):-
  	options(_,log(_,Path,_,_),_,_,_,_),
  	trap(openwrite(file_log,Path),_,dlg_note("Can not clear log file!")),
  	closefile(file_log),!.
  log_win_eh(_Win,e_Menu(id_clear_log_window,_),0):-
  	edit_pastestr(_Win,""),
  	edit_gotopos(_Win,1),!.
  log_win_eh(_Win,e_Menu(id_log_help,_),0):-
	project_ShowHelpContext(hlp_wa_Log_Information_window),!.
  log_win_eh(_Win,e_CloseRequest,0):-	retract(log_wind(_A)),fail.
  log_win_eh(_,_,0):-fail.
  
  dbg_win_eh(_Win,e_Menu(id_File_exit,_),0):-
	win_Destroy(_Win),
	retract(dbg_wind(_A)),
  	!.
  dbg_win_eh(_Win,e_Menu(id_File_save_as,_),0):-
  	File_name = dlg_GetFileName("*.*",["All files","*.*"],"Save debug log information",[dlgfn_Save],"",_FileName),
  	Log_str = edit_GetText(_Win),
	trap(file_str(File_name,Log_str),_,dlg_error("Unable to save information!")),
    	!.
  dbg_win_eh(_Win,e_Menu(id_clear_dbg_file,_),0):-
  	options(_,log(_,_,_,Path),_,_,_,_),
  	trap(openwrite(file_log,Path),_,dlg_note("Can not clear debug log file!")),
  	closefile(file_log),!.
  dbg_win_eh(_Win,e_Menu(id_clear_dbg_window,_),0):-
  	edit_pastestr(_Win,""),
  	edit_gotopos(_Win,1),!.
  dbg_win_eh(_Win,e_Menu(id_log_help,_),0):-
	project_ShowHelpContext(hlp_wa_Debug_Information_window),!.
  dbg_win_eh(_Win,e_CloseRequest,0):-	retract(dbg_wind(_A)),fail.
  dbg_win_eh(_,_,0):-fail.
  
  write_log(_,Str_in):-
  	write_state(Str_in),
  	fail.
  write_log(1,Str_in):-
  	options(_,log(_,_,1,DbgFileName),_,_,_,_),
  	make_time(Time),
  	trap(openappend(file_log,DbgFileName),E,wa_errproc(250,E)),
  	writedevice(Old),
  	writedevice(file_log),
  	trap(write(Time,Str_in),E1,wa_errproc(250,E1)),nl,
  	writedevice(Old),
  	closefile(file_log),
  	fail.
  write_log(1,_):-
  	options(_,log(_,_,0,_DbgFileName),_,_,_,_),fail.
  write_log(1,Str_in):-  	
  	dbg_wind(Wn),
  	make_time(Time),
  	format(Str_new,"%s%s\n",Time,Str_in),  	
  	edit_setreadonly(Wn,b_false),
  	edit_Appendstr(Wn,Str_new,1000),
  	edit_setreadonly(Wn,b_true),
	!.
  write_log(1,_):-!.
  write_log(0,Str_in):-
  	options(_,log(1,LogFileName,_,_),_,_,_,_),
  	make_time(Time),
  	trap(openappend(file_log,LogFileName),E,wa_errproc(200,E)),
  	writedevice(Old),
  	writedevice(file_log),
  	trap(write(Time,Str_in),E1,wa_errproc(200,E1)),nl,
  	writedevice(Old),
  	closefile(file_log),fail.
  write_log(0,Str_in):- 
    	make_time(Time), 	
  	options(_,log(_,_,1,DbgFileName),_,_,_,_),
  	trap(openappend(file_log,DbgFileName),E,wa_errproc(250,E)),
  	writedevice(Old),
  	writedevice(file_log),
  	trap(write(Time,Str_in),E1,wa_errproc(250,E1)),nl,
  	writedevice(Old),
  	closefile(file_log),fail.
  write_log(0,_):-
  	options(_,log(0,_,0,_),_,_,_,_),fail.
  write_log(0,Str_in):-
  	dbg_wind(Wn),
  	make_time(Time),
  	format(Str_new,"%s%s\n",Time,Str_in),  	
  	edit_setreadonly(Wn,b_false),
  	edit_Appendstr(Wn,Str_new,1000),
  	edit_setreadonly(Wn,b_true),fail.
  write_log(0,Str_in):-
  	log_wind(Wn),
  	make_time(Time),
  	format(Str_new,"%s%s\n",Time,Str_in),  	
  	edit_setreadonly(Wn,b_false),
  	edit_Appendstr(Wn,Str_new,1000),
  	edit_setreadonly(Wn,b_true),
	!.	
  write_log(0,_):-!.
  write_log(_,_):-!.
  
  write_state(Str):-
  	wa_dialog_win(Win),
	CtrlWin = win_GetCtlHandle(Win,idct_tip_text),
	win_SetText(CtrlWin,Str).
	
  make_time(Res):-
	time(Hours,Minutes,Seconds,HSec),
	date(Year,Month,Day),
%2do	
	format(Res,"%d.%d.%d   %d.%d.%d.%d   ",Day,Month,Year,Hours,Minutes,Seconds,Hsec),!.
  	