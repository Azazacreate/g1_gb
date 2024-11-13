/*****************************************************************************

                Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  FTPAgent
 FileName: LOG_WND.PRO
 Purpose: Example of Winsock 1.1 and FTP
 Written by: Konstantin Ivanov
 Comments: Functions for Log window
******************************************************************************/
include "ftpagent.inc"
include "ftpagent.con"
include "hlptopic.con"

GLOBAL PREDICATES
  getDateTime( STRING )					- (o)
  
PREDICATES
  test_str(STRING,STRING) - (i,o)
  md(STRING) - (i)
  
CLAUSES
%event handler of log window  
  log_win_eh(_Win,e_Menu(id_File_exit,_),0):-
	win_Destroy(_Win),
	retract(log_wind(_A)),!.
  log_win_eh(_Win,e_Menu(id_File_save_as,_),0):-
  	File_name = dlg_GetFileName("*.*",["All files","*.*"],"Save log information",[dlgfn_Save],"",_FileName),
  	Log_str = edit_GetText(_Win),
	file_str(File_name,Log_str),!.
  log_win_eh(_Win,e_Menu(id_clear_log_file,_),0):-
  	options(log(_,Path),_,_,_,_),
  	trap(openwrite(file_dir,Path),_,dlg_note("Can not clear log file!")),
  	closefile(file_dir),!.
  log_win_eh(_Win,e_Menu(id_clear_log_window,_),0):-
  	edit_pastestr(_Win,""),
  	edit_gotopos(_Win,1),!.
  log_win_eh(_Win,e_Menu(id_log_help,_),0):-
	project_ShowHelpContext(idh_log_window),!.
  log_win_eh(_Win,e_CloseRequest,0):-	retract(log_wind(_A)),fail.
  log_win_eh(_,_,0):-fail.

%writes given string to log window if window is opened; writes to given file. 
  write_log_wnd(Str_in,_):-
  	test_str(Str_in,Str1),
	fa_dialog(DlgWin),
	FA_state_h = win_GetCtlHandle(DlgWin, idct_fa_state),
	win_SetText(FA_state_h, Str1),
	fail.
  write_log_wnd(Str,_):-
  	log_wind(Wn),
  	edit_setreadonly(Wn,b_false),
%ifdef platform_32bit
  	edit_Appendstr(Wn,Str),
%elsedef
%enddef  	
	edit_setreadonly(Wn,b_true),
	fail.
  write_log_wnd(Str_in,FileName):-
  	getDateTime( Str_DateTime ),
  	format( Str_out, "%s  %s", Str_DateTime, Str_in ),
	trap(openappend(file_log,FileName), E, common_FileErrorHandle( E ) ),
  	writedevice(Old),
  	writedevice(file_log),
  	trap( write( Str_out ), E1, common_FileErrorHandle( E1 ) ),
  	writedevice(Old),
  	closefile(file_log),
	!.
  write_log_wnd( Str_in, FileName ):-	% I suggest that this clause works when openappend fails
	filenamepath( FileName, Path, _ ),
	is_md( Path, 0 ),
	closefile(file_log),
	getDateTime( Str_DateTime ),
  	format( Str_out, "%s  %s", Str_DateTime, Str_in ),
	trap(openappend(file_log,FileName), E, common_FileErrorHandle( E ) ),
  	writedevice(Old),
  	writedevice(file_log),
  	trap( write( Str_out ), E1, common_FileErrorHandle( E1 ) ),
  	writedevice(Old),
  	closefile(file_log),
  	format(StrNote,"Attempt to create file %s succeeded!",FileName),
  	dlg_note(StrNote),
	!.
	
%removes end '\n' symbol
  test_str(Str,Start):-
	str_len(Str,L),
	L1 = L - 1,
	trap(frontstr(L1,Str,Start,RestString),_,true),
	RestString = "\n",!.
  test_str(Str,Str).

%creates a directory recursively to be able to write input info to a file
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

%returns timestamp
  getDateTime( Str ):-
	date(Year,Month,Day),
        time(Hours,Minutes,Seconds,_),
        format( Str,"%d.%d.%d  %d.%d.%d",Month,Day,Year,Hours,Minutes,Seconds),
        !.