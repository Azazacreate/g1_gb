ifndef platform_32bit
code = 5000
enddef
/*****************************************************************************

                Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  FTPAgent
 FileName: sock_tr.PRO
 Purpose: Example of Winsock 1.1 and FTP
 Written by: Konstantin Ivanov
 Comments: Predicates for data transfer
******************************************************************************/
include "ftpagent.inc"
include "error.con"
include "ftpagent.con"
include "iodecl.con"

GLOBAL PREDICATES
  get_last_state_symb(STRING,STRING)		- (i,o)
  make_state_update()
  reflectState( STRING )			- (i)
  test_state(SOCKET,STATE_SOCKET)
  getDateTime( STRING )				- (o)
  slist form_fields1(string, string)		- (i,i)
  
DATABASE - ftpagent_int2
determ  sock(SOCKET,STATE_SOCKET,INTEGER,INTEGER)
  local_files(SOCKET,STRING Name,STAMP)
  server_files(SOCKET,STRING Name,SERV_STAMP)
  local_files1(SOCKET,STRING Name,STAMP)
  server_files1(SOCKET,STRING Name,SERV_STAMP)
  sendFilesToDelete(SOCKET,STRING Name,STAMP)
  recvFilesToDelete(SOCKET,STRING Name,SERV_STAMP)
  noDelIfDirNotExist_db( SOCKET, STRING )
determ  chain(STRING,STRING)
determ  chainDel(STRING,STRING)
determ  hostdirs(SOCKET,STRING)
determ  kind_system(SOCKET,INTEGER)
determ  for_connect(STRING,USHORT,INTEGER,INTEGER)
  pasv_mode_transfer(SOCKET,BOOLEAN)

PREDICATES
  collect_files(BOOLEAN,SOCKET,STRING)
  change_pos_status(INTEGER,INTEGER,STRING)
  check_IsNoDelIfDirNotExist( SOCKET )				- (i)
  check_spaces_copy_elements( INTEGER, INTEGER, SLIST, SLIST )	- (i,i,i,o)
  check_spaces_in_names( INTEGER, SLIST, SLIST )		- (i,i,o)
  check_spaces_is_fifthSize( INTEGER, INTEGER, SLIST )		- (i,i,i)
  nondeterm get_filesRecurs(STRING PATH,STRING FileName,STAMP)	- (i,o,o)
  nondeterm get_files(STRING PATH,STRING FileName,STAMP)	- (i,o,o)
  change_state(SOCKET,STATE_SOCKET)
  check_IsSubDirNecces( BOOLEAN, SOCKET, INTEGER )		- (i,i,i)
  find_diff_send(SOCKET, BOOLEAN UseFileNameOnly )		- (i,i)
  find_diff_recv(SOCKET, BOOLEAN UseFileNameOnly )		- (i,i)
  find_diff_del_send(SOCKET,STRING,STAMP, BOOLEAN )
  find_diff_del_recv(SOCKET,STRING,SERV_STAMP, BOOLEAN )
  find_diff_recv_is_fileAtLocalDisk( SOCKET, STRING )		- (i,i)
  procedure find_diff_PerformNoDelIfDirNotExist( SOCKET )			- (i)
  determ find_diff_PerformNoDelIfDirNotExist_Search( SOCKET, STRING, SERV_STAMP ) - (i,i,i)
  procedure find_diff_recv_AddToDB( SOCKET, STRING, SERV_STAMP )		- (i,i,i)
  is_del_file(STRING,STRING)
  is_ToDelete( SOCKET, INTEGER, INTEGER, BOOLEAN )		- (i,i,i,i)
  test_cwd(SOCKET)
  test_state_end(SOCKET,STATE_SOCKET)
  is_any_files( SOCKET, INTEGER )				- (i,i)
  is_anyToDeleteFiles( SOCKET,INTEGER )				- (i,i)
  err_shutdown_conn(SOCKET,INTEGER,INTEGER) - (i,o,o)
  fill_server_files(SOCKET)
  read_from_fls(SOCKET,FILE)
  fill_dbase(INTEGER,SLIST,SERV_STAMP,STRING)
  is_dot(SOCKET,STRING,SERV_STAMP)
  is_dirs(SOCKET,INTEGER)
  full_names_retr(SOCKET,STRING,STRING)
  procedure change_slash(STRING,STRING)
  what_syst(SOCKET,STRING)
  check_syst(SOCKET,STRING)
  prep_read(INTEGER)
  is_access()
  is_access_wr()
  d_print1(INTEGER,INTEGER,STRING) - (i,i,i)
  d_print(SOCKET,STRING) - (i,i)
  what_win(INTEGER,STRING)
  is_db_send(SOCKET,STRING,INTEGER,INTEGER)
  is_db_recv(SOCKET,INTEGER)
  write_db_recv(FILE,STRING,SERV_STAMP) - (i,i,i)
  write_db(FILE,STRING,STAMP) - (i,i,i)
  write_mes(INTEGER,STRING,STRING,STRING)
  fill_local1(SOCKET,STRING,SLIST)
  fill_local_db(SOCKET,FILE,STRING)
  fill_serv_db(SOCKET,FILE)
  is_local_rest(SOCKET,INTEGER,INTEGER)			- (i,i,i)
  is_local_rest_Go(SOCKET,INTEGER,INTEGER)		- (i,i,i)
  form_lst( FILE, SLIST, STRING )			- (i,o,i)
  mes_no(SOCKET,INTEGER)
  is_empty_sour_dirry(SOCKET,INTEGER)
  is_empty_serv_dirry(SOCKET,INTEGER)
  recvFilesToDelete_Perform( SOCKET )			- (i)
  send_recv(SOCKET)
  is_send_recv(INTEGER)
  process_state(SOCKET,REPLY)
  process_state_str(SOCKET,REPLY,STRING)
  process_error( REPLY, SOCKET, INTEGER, STRING )	- (i,i,i,i)
  process_error( REPLY, SOCKET )			- (i,i)
  process_error_rep(REPLY,SOCKET,INTEGER,STRING)	- (i,i,i,i)
  err_ini(INTEGER,INTEGER)
  is_firewall_enter(BOOLEAN,STRING,STRING,STRING)
  is_firewall_con(BOOLEAN,STRING,USHORT,STRING,USHORT,STRING,USHORT)
  what_error_kind(UNSIGNED,STRING,STRING)
  test_retry(INTEGER,INTEGER,INTEGER,INTEGER)
  get_pass_mode(SOCKET,BOOLEAN) 			- (i,o)

% delete "on work" file (needed for another process for syncronization) 
predicates
  procedure delete_on_work() - ()
clauses
  delete_on_work():-
        trap(deletefile(filename_on_work),_,fail),
        fail.
  delete_on_work().


CLAUSES
%predicate process answers from FTP layer
/*  scan_process_answer(S,Ev):-
  	term_str(ftplay_reply,Ev,Ev_Str),
%  	format(Str,"From FTPLayer % - % \n",S,Ev_Str),
%  	d_print(S,Str),fail.
	fail.*/
  scan_process_answer(S,connect(Host_u,Port)):-
	upper_lower(Host_u,Host),
	for_connect(Host,Port,Lbox_code,Index),
	retract(for_connect(Host,Port,Lbox_code,Index)),!,
        assert(sock(S,sstate_reply(for_connect),Lbox_code,Index)),
        d_print(S,"Connection with host established\n"),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,Remdir,_,_),!,
        change_slash(Remdir,Remdir_u),
        assert(hostdirs(S,Remdir_u)),
        send_recv(S),!.
  scan_process_answer(S,err_connect(ErrStr,Host_u,Port)):-
  	upper_lower(Host_u,Host),
  	ftplay_LastError(Err,Txt),
  	what_error_kind(Err,Txt,Text),
        format(Str_prn,"Hard error in processing: %s; Last error: %s\n",ErrStr,Text),
        d_print(S,Str_prn),
        ftplay_close(S),
        for_connect(Host,Port,Lbox_code,Index),
	retract(for_connect(Host,Port,Lbox_code,Index)),!,
        options(_,_,_,Sr,_),
        entry_cur_retry(Lbox_code,Index,Sr_cur),
        test_retry(Lbox_code,Index,Sr,Sr_cur),
        !.
  scan_process_answer(S,ok):-
        sock(S,sstate_reply(State),_,_),
        process_state(S,State),!.
  scan_process_answer(S,ok_str(Str)):-
        sock(S,sstate_reply(State),_,_),
        process_state_str(S,State,Str),
        !.
  scan_process_answer(S,ftplay_error( ErrVal, ErrStr )):-
  	sock(S,sstate_reply(State),_,_),!,
  	process_error( State, S, ErrVal, ErrStr ),
        !.
%KI add begin 15.09.1998
  scan_process_answer(S,ftplay_error( ErrVal, ErrStr )):-		% sock() can fail only if ftplay_SetConn was called and connect did not come
  	process_error( for_connect, S, ErrVal, ErrStr ),
        !.
%KI add end 15.09.1998
  scan_process_answer(S,error_rep(Code,Str)):-
  	sock(S,sstate_reply(State),_,_),
  	process_error_rep(State,S,Code,Str),
        !.
%KI add begin 16.10.1998        
  scan_process_answer(S,close):-
  	not(sock(S,_,_,_)),					% sock() can fail only if ftplay_SetConn was called and connect did not come
  	process_error( for_connect, S, 0, "Connection was broken" ),
  	!.
%KI add end 16.10.1998
  scan_process_answer(S,close):-
        d_print(S,"Connection closed\n"),
        retract(sock(S,_,Lbox_code,Index)),
        retractall(for_connect(_,_,Lbox_code,Index)),
        retractall(server_files(S,_,_)),!,
        retractall(local_files(S,_,_)),
  	retractall(sendFilesToDelete(S,_,_)),
  	retractall(recvFilesToDelete(S,_,_)),
  	retractall(noDelIfDirNotExist_db(S,_)),
        retractall(pasv_mode_transfer(S,_)),
        retractall(kind_system(S,_)),
        retractall(hostdirs(S,_)),
        retractall(chain(_,_)),
        retractall(chainDel(_,_)),
        list_entry(Lbox_code,Index,_,_From,_,_,_Delete,_,_,_,_,_,_),!,
        retract(entry_cur_retry(Lbox_code,Index,_)),
        change_pos_status(Lbox_code,Index,"Waiting"),
	fa_dialog(DlgWin),
        change_mode_to_en(DlgWin,[idc_stop]),
        retract(on_work), delete_on_work(),
        win_PostEvent(DlgWin,e_Native(msg_is_on,0,0)),
        !.
  scan_process_answer( _S, progress( ftplay_ActionSend, _FileName, _BlockSize )):-
%  	write( "Send: ",FileName, " - ", BlockSize),nl,
	make_state_update(),
  	!.
  scan_process_answer( _S, progress( ftplay_ActionReceive, _FileName, _BlockSize )):-
%  	write( "Receive: ",FileName, " - ", BlockSize),nl,
	make_state_update(),
  	!.
  	
%fails if 1 that means that active list-box is ReceiveList
  is_send_recv(0):-!.                 
  is_send_recv(1):-fail.

%STARTING POINT of SYNC
%defines what enry is in sync mode - sending or receiving.
  send_recv(S):-
        sock(S,sstate_reply(for_connect),Lbox_code,Index),
        is_send_recv(Lbox_code),!,
        list_entry(Lbox_code,Index,_,From,_,_,_,_,_,_,_,adv_opts(_,_,_,InclDir,_,_),_),!,
        collect_files(InclDir,S,From),
        is_empty_sour_dirry(S,Index),
        is_db_send(S,From,Lbox_code,Index),
        !.
  send_recv(S):-
        sock(S,sstate_reply(for_connect),Lbox_code,Index),!,
        list_entry(Lbox_code,Index,_,From,_,_,_,User_Id,pwd(_,User_pwd),_,_,adv_opts(_,proxy(Is_fw,_,_),_,_,_,_),_),!,
        change_pos_status(Lbox_code,Index,"Receiving"),
        change_state(S,sstate_reply(login)),
        is_firewall_enter(Is_fw,From,User_Id,User_Id_f),
        pwd_str_bin(User_pwd_str,User_pwd),
        ftplay_login(S,User_Id_f,User_pwd_str,""),
        !.
%process ok reply from FTP Layer according to current state of a sync.
  process_state(S,login):-
        change_state(S,sstate_reply(syst)),
        ftplay_SystCommand(S),!.
  process_state(S,cwd):-
        test_cwd(S),!.
  process_state(S,list):-
        is_access(),
        fill_server_files(S),
        trap(deletefile("fls.tmp"),_,dlg_error("Unexpected error: FTPAgent can not delete a temp. file!")),
        kind_system(S,Kind),
        sock(S,sstate_reply(list),Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,adv_opts(_,_,_,InclSubDir,_,_),_),!,
        check_IsSubDirNecces( InclSubDir, S, Kind ),
        is_dirs(S,Kind),
        !.
  process_state( S, sendDel(LocalFilestor) ):-
        sock(S,sstate_reply( sendDel(LocalFilestor) ),Lbox_code, Index ),
        list_entry(Lbox_code,Index,_,From,To,_,_,_,_,_,_,_,_),!,
        retract( sendFilesToDelete( S, LocalFilestor, _ )),
        retract( chainDel( LocalFilestor, Remfile ) ),
        format(LocalFile_stor,"%s\\%s",From,LocalFilestor),        
        write_mes( 11, LocalFile_stor, To, Remfile ),
        vpi_ProcessEvents(b_true),
        is_anyToDeleteFiles(S,1),
        !.
  process_state(S,retr(LocalFile_retr)):-
        sock(S,sstate_reply(retr(LocalFile_retr)),Lbox_code,Index),
        list_entry(Lbox_code,Index,_,From,_,_,_,_,_,_,_,_,_),!,
        retract(chain(LocalFile_retr,RemoteFile_retr)),
        retract(server_files(S,RemoteFile_retr,SV_STAMP)),
        format(OSFileName,"recv%d.db",Index),
        trap(openappend(file_db,OSFileName),_,dlg_error("Please, report about it to an author. Int.err. #1")),
        write_db_recv(file_db,RemoteFile_retr,SV_STAMP),
        closefile(file_db),
        write_mes(2,From,RemoteFile_retr,LocalFile_retr),
        vpi_ProcessEvents(b_true),
        is_access_wr(),
        is_any_files(S,2),
        !.
  process_state(S,stor(LocalFilestor)):-
        sock(S,sstate_reply(stor(LocalFilestor)),Lbox_code,Index),
        list_entry(Lbox_code,Index,_,From,To,_,Delete,_,_,_,_,_,_),!,
        format(LocalFile_stor,"%s\\%s",From,LocalFilestor),
        is_del_file(LocalFile_stor,Delete),
        retract(local_files(S,LocalFilestor,STAMP)),
        retract(chain(LocalFilestor,Remfile)),
        format(OSFileName,"send%d.db",Index),
        trap(openappend(file_db,OSFileName),_,dlg_error("Please, report about it to an author. Int.err. #2")),
        write_db(file_db,LocalFile_stor,STAMP),
        closefile(file_db),
        write_mes(1,LocalFile_stor,To,Remfile),
        vpi_ProcessEvents(b_true),
        is_any_files(S,1),
        !.
  process_state(S,quit):-
  	sock( S, _, Lbox_code, Index ),
  	what_win( Lbox_code, Str_win ),
        format( Str_prn, "%s,%d: Done", Str_win, Index ),
        reflectState( Str_prn ),!.

%process ok_str reply from FTP Layer according to current state of a sync and reported in Str information.
  process_state_str(S,syst,Str):-
        what_syst(S,Str),
        change_state(S,sstate_reply(cwd)),
        hostdirs(S,Remdir),
        ftplay_CwdCommand(S,Remdir),!.

%process error reply from FTP Layer according to current state of a sync.
  process_error( _, S, ErrVal, Txt ):-
  	what_error_kind( ErrVal, Txt, Text ),
        format(Str_prn,"Hard error in processing: %u; Last error: %s\n",ErrVal,Text),
        d_print(S,Str_prn),
        fail.
  process_error( State, S, error_file_not_found, _ ):-
  	process_error( State, S ),!.
  process_error( State, S, error_path_not_found, _ ):-
  	process_error( State, S ),!.
  process_error( State, S, error_access_denied, _ ):-
  	process_error( State, S ),!.
  process_error( State, S, error_sharing_violation, _ ):-
  	process_error( State, S ),!.
  process_error( for_connect, NullSocket, _, _ ):-
  	term_str( REPLY, for_connect, State_str ),
        format( Str_prn,"An error is critical in this stage of processing (programm state: %s) and connection will be closed\n",State_str ),
        d_print( NullSocket, Str_prn ),
        err_shutdown_conn( NullSocket, Lbox_code, Index ),
        options(_,_,_,Sr,_),
        entry_cur_retry(Lbox_code,Index,Sr_cur),
        test_retry(Lbox_code,Index,Sr,Sr_cur),
	!.
  process_error( State, S, _, _ ):-
  	term_str( REPLY, State, State_str ),
        format(Str_prn,"An error is critical in this stage of processing (programm state: %s) and connection will be closed\n",State_str),
        d_print(S,Str_prn),
	ftplay_QuitCommand( S ),
        ftplay_close(S),
        err_shutdown_conn(S,Lbox_code,Index),
        options(_,_,_,Sr,_),
        entry_cur_retry(Lbox_code,Index,Sr_cur),
        test_retry(Lbox_code,Index,Sr,Sr_cur),
        !.
  process_error( list, S ):-
  	trap(deletefile("fls.tmp"),_,dlg_error("Unexpected error: FTPAgent can not delete a temp. file!")),
        kind_system( S, Kind ),
        sock( S, sstate_reply(list), Lbox_code, Index),
        list_entry( Lbox_code,Index,_,_,_,_,_,_,_,_,_,adv_opts(_,_,_,InclSubDir,_,_),_),!,
        check_IsSubDirNecces( InclSubDir, S, Kind ),
        is_dirs(S,Kind),
        !.
  process_error( sendDel( LocalFilestor ), S ):-
        sock(S,sstate_reply(sendDel(LocalFilestor)),Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,_,_),!,
        retract(sendFilesToDelete(S,LocalFilestor,_)),
        retract(chainDel(LocalFilestor,_)),
        vpi_ProcessEvents(b_true),
        is_anyToDeleteFiles(S,1),
        !.
  process_error( retr( LocalFile_retr ), S ):-
  	sock(S,sstate_reply(retr(LocalFile_retr)),Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,_,_),!,
        retract(chain(LocalFile_retr,RemoteFile_retr)),
        retract(server_files(S,RemoteFile_retr,_)),
        vpi_ProcessEvents(b_true),
        is_access_wr(),
        is_any_files(S,2),
        !.
  process_error( stor( LocalFilestor ), S ):-
        sock(S,sstate_reply(stor(LocalFilestor)),Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,_,_),!,
        retract(local_files(S,LocalFilestor,_)),
        retract(chain(LocalFilestor,_)),
        vpi_ProcessEvents(b_true),
        is_any_files(S,1),
        !.
        
%process error_rep reply from FTP Layer according to current state of a sync and reported in Str information.  
  process_error_rep(syst,S,_,_):-
  	%I assume that SYST command can be not suppotted only by UNIX - patch :(
  	assert(kind_system(S,2)),
        change_state(S,sstate_reply(cwd)),
        hostdirs(S,Remdir),
        ftplay_CwdCommand(S,Remdir),!.
  process_error_rep(_,S,Code,Str):-
        format(Str_prn,"Soft error in processing: FTP code - %d, FTP description - %s",Code,Str),
        d_print(S,Str_prn),
        fail.
  process_error_rep(list,S,_,_):-
  	check_IsNoDelIfDirNotExist( S ),
        trap(deletefile("fls.tmp"),_,dlg_error("Unexpected error: FTPAgent can not delete a temp. file!")),
        kind_system(S,Kind),
        sock(S,sstate_reply(list),Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,adv_opts(_,_,_,InclSubDir,_,_),_),!,
        check_IsSubDirNecces( InclSubDir, S, Kind ),
        is_dirs(S,Kind),
        !.
  process_error_rep(senddel(LocalFilestor),S,_,_):-
        sock(S,sstate_reply(sendDel(LocalFilestor)),Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,_,_),!,
        retract(sendFilesToDelete(S,LocalFilestor,_)),
        retract(chainDel(LocalFilestor,_)),
        vpi_ProcessEvents(b_true),
        is_anyToDeleteFiles(S,1),
        !.
  process_error_rep(retr(LocalFile_retr),S,_,_):-
        sock(S,sstate_reply(retr(LocalFile_retr)),Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,_,_),!,
        retract(chain(LocalFile_retr,RemoteFile_retr)),
        retract(server_files(S,RemoteFile_retr,_)),
        vpi_ProcessEvents(b_true),
        is_access_wr(),
        is_any_files(S,2),
        !.
  process_error_rep(stor(LocalFilestor),S,_,_):-
        sock(S,sstate_reply(stor(LocalFilestor)),Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,_,_),!,
        retract(local_files(S,LocalFilestor,_)),
        retract(chain(LocalFilestor,_)),
        vpi_ProcessEvents(b_true),
        is_any_files(S,1),
        !.
  process_error_rep(State,S,_,_):-
  	term_str( REPLY, State, State_str ),
        format(Str_prn,"An error is critical in this stage of processing (programm state: %s) and connection will be closed\n",State_str),
        d_print(S,Str_prn),
	ftplay_QuitCommand( S ),
        ftplay_close(S),
        err_shutdown_conn(S,Lbox_code,Index),
        options(_,_,_,Sr,_),
        entry_cur_retry(Lbox_code,Index,Sr_cur),
        test_retry(Lbox_code,Index,Sr,Sr_cur),!.

%check is hidden option turned on or off
  check_IsNoDelIfDirNotExist( S ):-
  	sock(S,_,Lbox_code,Index),
  	disabledelindbifdirnotexist_recv(Lbox_code,Index),
  	hostdirs( S, CurRemoteDir ),
  	assert( noDelIfDirNotExist_db( S, CurRemoteDir ) ),
  	!.
  check_IsNoDelIfDirNotExist( _ ).
  
%defines actions after command CWD
  test_cwd(S):-
        sock(S,_,Lbox_code,_),
        is_send_recv(Lbox_code),
        test_state_end(S,sstate_reply(stor(""))),!.
  test_cwd(S):-
        hostdirs(S,CurRemdir),
        get_pass_mode(S,Pv),
        change_state(S,sstate_reply(list)),
        ftplay_listfile(S,"fls.tmp",CurRemdir,Pv),!.

%predicate tests what list_box is source - socket will send or socket will receive
  send_or_receive(Lbox_code,Index):-
        is_send_recv(Lbox_code),!,
        list_entry(Lbox_code,Index,_,_,To,_,_,_,_,_,_,adv_opts(Port,proxy(Is_fw,Fw_Host,Fw_Port),_,_,_,_),_),!,
        scan_window(Scan_win),
        is_firewall_con(Is_fw,To,Port,Fw_Host,Fw_Port,To_r,Port_r),
	upper_lower(To_r,To_r_l),
        trap(ftplay_SetConnection(To_r_l,Port_r,Scan_win,scan_mes),_,err_ini(Lbox_code,Index)),
	assert(for_connect(To_r_l,Port_r,Lbox_code,Index)),
        format(Ss,"Trying to connect to %s, port %U\n",To_r_l,Port_r),
        d_print1(Lbox_code,Index,Ss),
        !.
  send_or_receive(Lbox_code,Index):-
        list_entry(Lbox_code,Index,_,From,_,_,_,_,_,_,_,adv_opts(Port,proxy(Is_fw,Fw_Host,Fw_Port),_,_,_,_),_),!,
        scan_window(Scan_win),
        is_firewall_con(Is_fw,From,Port,Fw_Host,Fw_Port,From_r,Port_r),        
        upper_lower(From_r,From_r_l),
        trap(ftplay_SetConnection(From_r_l,Port_r,Scan_win,scan_mes),_,err_ini(Lbox_code,Index)),
	assert(for_connect(From_r_l,Port_r,Lbox_code,Index)),        
        format(Ss,"Trying to connect to %s, port %U\n",From_r_l,Port_r),
        d_print1(Lbox_code,Index,Ss),
        !.

%predicate fills database local_files with files collected from a given path
  collect_files(b_true,S,Path):-
        get_filesRecurs(Path,FullName,STAMP),
           PATH >< FullName,
           not(STAMP=dir),
           filenamereduce(FullName,Path,ReducedName),
           assert(local_files(S,ReducedName,STAMP)),
        fail.
  collect_files(b_false,S,Path):-
        get_files(Path,FullName,STAMP),
           PATH >< FullName,
           not(STAMP=dir),
           filenamereduce(FullName,Path,ReducedName),
           assert(local_files(S,ReducedName,STAMP)),
        fail.
  collect_files(_,_,_).

%predicate get files recursively from all subdirectories with a STAMP from given path
%  get_filesRecurs("","",dir):- !,fail.
  get_filesRecurs(PATH,UpperPath,dir):- upper_lower(UpperPath,PATH).
  get_filesRecurs(PATH,FName,STAMP):-
        concat(PATH,"\\*.*",PP),
        trap(dirfiles(PP,fa_subdir,SUBDIR,_,_,_,_,_,_,_,_),_,true),
        SUBDIR >< ".",
        SUBDIR >< "..",
        format(NEWPATH,"%\\%",PATH,SUBDIR),
        get_filesRecurs(NEWPATH,FName,STAMP).
  get_filesRecurs(PATH,FullName,s(Hour,Min,Sec,Year,Month,Day,Size)):-
        concat(PATH,"\\*.*",PP),
        trap(dirfiles(PP,0x40,FName,_,Hour,Min,Sec,Year,Month,Day,Size),_,true),
        format(FullName,"%\\%",PATH,FName).
  
  get_files(PATH,FullName,s(Hour,Min,Sec,Year,Month,Day,Size)):-
        concat(PATH,"\\*.*",PP),
        trap(dirfiles(PP,0x40,FName,_,Hour,Min,Sec,Year,Month,Day,Size),_,true),
        format(FullName,"%\\%",PATH,FName).
        
%changes state of socket
  change_state(S,NewState):-
        retract(sock(S,_,Lbox_code,Index)),!,
        assert(sock(S,NewState,Lbox_code,Index)).

%changes status of list_entry
  change_pos_status(Lbox_code,Index,Status):-
        retract(list_entry(Lbox_code,Index,_,From,To,Timer,Delete,U_Id,U_pwd,_,Remdir,Adv,Prof)),!,
        assert(list_entry(Lbox_code,Index,Status,From,To,Timer,Delete,U_Id,U_pwd,0,Remdir,Adv,Prof)),
        Str = form_str(Index,Status,From,To,Timer),
        lbox_del_pos(Lbox_code,Index,Str),
	fa_dialog(DlgWin),
        set_focus(DlgWin,Lbox_code).

%a set of predicates find_diff
%find different files in two databases: local_files - from disk and local_files1 - from file send*.db
%the rest in local_files
  find_diff_send( S, UseFileNameOnly ):-
        local_files1( S, FileName, STAMP ),
                find_diff_del_send( S, FileName, STAMP, UseFileNameOnly ),
        fail.
  find_diff_send( _, _ ).

  find_diff_del_send( S, FileName, STAMP1, b_true ):-	%stamp is ignored at all
  	local_files( S, FileName, STAMP ),!,
        retractall(local_files(S,FileName, STAMP )),
        retractall(local_files1(S,FileName,STAMP1)),
        sock(S,_,Lbox_code,Index),
        list_entry(Lbox_code,Index,_,From,_,_,_,_,_,_,_,_,_),
        format(OSFileName,"send%d.db",Index),
        format(LocalFile_stor,"%s\\%s",From,FileName),
        trap(openappend(file_db,OSFileName),_,dlg_error("Please, report about it to an author. Int.err. #3")),
        write_db( file_db, LocalFile_stor, STAMP ),
        closefile(file_db),
  	!.
  find_diff_del_send(S,FileName,STAMP, b_false ):-
        local_files(S,FileName,STAMP),!,
        retractall(local_files(S,FileName,STAMP)),
        retractall(local_files1(S,FileName,STAMP)),
        sock(S,_,Lbox_code,Index),
        list_entry(Lbox_code,Index,_,From,_,_,_,_,_,_,_,_,_),
        format(OSFileName,"send%d.db",Index),
        format(LocalFile_stor,"%s\\%s",From,FileName),
        trap(openappend(file_db,OSFileName),_,dlg_error("Please, report about it to an author. Int.err. #3")),
        write_db(file_db,LocalFile_stor,STAMP),
        closefile(file_db),
        !.
  find_diff_del_send(S,FileName,STAMP1, _ ):-		% this file was deleted
  	not(local_files(S,FileName,_)),!,
        retractall(local_files1(S,FileName,STAMP1)),
        assert( sendFilesToDelete( S, FileName, STAMP1 ) ),
        !.
  find_diff_del_send(S,FileName,STAMP1, _ ):-		% this file's STAMP was modified
        retractall(local_files1(S,FileName,STAMP1)),
        !.


%find different files in two databases: server_files - from disk and server_files1 - from file recv*.db
%the rest in server_files
  find_diff_recv( S, UseFileNameOnly ):-
        server_files1( S, FileName, SV_STAMP ),
                find_diff_del_recv(S,FileName,SV_STAMP, UseFileNameOnly ),
        fail.
  find_diff_recv( S, _ ):-
  	sock(S,_,Lbox_code,Index),
  	forceCheckAtDisk_Recv(Lbox_code, Index),
  	server_files( S, FileName, SV_STAMP ),	%files at a remote site don't exist at a local site
  		find_diff_recv_is_fileAtLocalDisk( S, FileName ),
  		%yes, file is at local disk
  		retractall( server_files( S, FileName, SV_STAMP ) ),
  		find_diff_recv_AddToDB( S, FileName, SV_STAMP ),
  	fail.
  find_diff_recv(_,_).

  find_diff_del_recv(S,FileName,SV_STAMP1, b_true ):-
        server_files(S,FileName,SV_STAMP),!,
        retract(server_files1(S,FileName,SV_STAMP1)),!,
        retract(server_files(S,FileName,SV_STAMP)),
        find_diff_recv_AddToDB( S, FileName, SV_STAMP ),
        !.
  find_diff_del_recv(S,FileName,SV_STAMP, b_false ):-
        server_files(S,FileName,SV_STAMP),!,
        retract(server_files1(S,FileName,SV_STAMP)),!,
        retract(server_files(S,FileName,SV_STAMP)),
        find_diff_recv_AddToDB( S, FileName, SV_STAMP ),
        !.
  find_diff_del_recv(S,FileName,SV_STAMP, _ ):-	% there is no such file at a remote host
        retract(server_files1(S,FileName,SV_STAMP)),
        assert( recvFilesToDelete(S,FileName,SV_STAMP) ),
        !.
        
  find_diff_recv_AddToDB( S, FileName, SV_STAMP ):-
  	sock( S, _, _, Index ),
	format( OSFileName, "recv%d.db", Index ),
        trap(openappend( file_db,OSFileName ),_,dlg_error("Please, report about it to an author. Int.err. #4")),
	write_db_recv( file_db, FileName, SV_STAMP ),
        closefile( file_db ),
        !.
  find_diff_recv_AddToDB( _, _, _ ).


  find_diff_recv_is_fileAtLocalDisk( S, RemoteFile_retr ):-
        full_names_retr( S, RemoteFile_retr, LocalFile_retr ),
        trap(existfile( LocalFile_retr ),Err,common_FileErrorHandle(Err)),
   	!.
   
  find_diff_PerformNoDelIfDirNotExist( S ):-
  	sock( S, _, Lbox_code,Index ),
  	disabledelindbifdirnotexist_recv(Lbox_code, Index),
  	server_files1( S, FileName, SV_STAMP ),
  		find_diff_PerformNoDelIfDirNotExist_Search( S, FileName, SV_STAMP ),
  	fail.
  find_diff_PerformNoDelIfDirNotExist( S ):-
  	sock( S, _, Lbox_code,Index ),
  	disabledelindbifdirnotexist_recv(Lbox_code, Index),
  	retractall( noDelIfDirNotExist_db( S, _ ) ),
  	!.
  find_diff_PerformNoDelIfDirNotExist( _ ).
  
  find_diff_PerformNoDelIfDirNotExist_Search( S, FileName, SV_STAMP ):-
	noDelIfDirNotExist_db( S, RemDir ),
		searchstring( FileName, RemDir, _ ),!,
		%yes, this files belongs to removed directory or its subdirs.
  		retractall( server_files1( S, FileName, SV_STAMP ) ),
  		find_diff_recv_AddToDB( S, FileName, SV_STAMP ),
  	fail.
  find_diff_PerformNoDelIfDirNotExist_Search( _, _, _ ).
  
%predicate tests the state of socket after reply from server 226 - action completed
  test_state_end(S,sstate_reply(stor(_))):-
        is_anyToDeleteFiles(S,1),
        !.
  test_state_end(S,sstate_reply(retr(_))):-
        is_access_wr(),
        is_anyToDeleteFiles(S,2),
        !.

%tests database for files to delete according to option "Do Full Synch"
  is_anyToDeleteFiles(S,1):-
  	sendFilesToDelete( S, LocalFile_stor, _ ),!,
        sock( S,_, Lbox_code, Index ),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,_,_),!,
        hostdirs( S, Remdir ),
        format( RemFile_stor, "%s/%s", Remdir, LocalFile_stor ),
        change_slash( RemFile_stor, RemoteFile_stor ),
        retractall( chainDel(_,_) ),
        assert( chainDel( LocalFile_stor, RemoteFile_stor ) ),
        change_state( S, sstate_reply(sendDel( LocalFile_stor ) ) ),
        what_win( Lbox_code,Str_win ),
        format( Str_prn, "%s,%d: Deleting %s |", Str_win, Index, RemoteFile_stor ),
        reflectState( Str_prn ),
        ftplay_DeleCommand( S, RemoteFile_stor ),
  	!.
  is_anyToDeleteFiles(S,1):-
  	not( sendFilesToDelete( S, _, _ ) ),
  	is_any_files(S,1),
  	!.
  is_anyToDeleteFiles(S,2):-
  	sock( S,_, Lbox_code, Index ),
  	list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,adv_opts(_,_,_,_,_,b_false),_),
        retractall(recvFilesToDelete( S, _, _ )),
        fail.
  is_anyToDeleteFiles(S,2):-
  	recvFilesToDelete( S, _Name, _SV_STAMP ),
	  	recvFilesToDelete_Perform( S ),
  	fail.
  is_anyToDeleteFiles(S,2):-
  	not( recvFilesToDelete( S, _, _ ) ),
        is_access_wr(),
        is_any_files(S,2),
  	!.

%performs a delete of files at local disk  
  recvFilesToDelete_Perform( S ):-
  	retract( recvFilesToDelete( S, RemoteFile_retr, _ ) ),
  		full_names_retr( S, RemoteFile_retr, LocalFile_retr ),
  		trap(deletefile( LocalFile_retr ), _, true ),
	        sock( S, _, Lbox_code, Index ),
	        list_entry( Lbox_code,Index,_,From,_,_,_,_,_,_,_,_,_ ),
	        write_mes( 12, From, RemoteFile_retr, LocalFile_retr ),
  	fail.
  recvFilesToDelete_Perform( _ ).
  
%tests is any file in database, 1 - sending, 2 - receiving
%if any then it is sent or retrieved
  is_any_files(S,1):-
        local_files(S,LocalFile_stor,_),
        sock(S,_,Lbox_code,Index),
        list_entry(Lbox_code,Index,_,From,_,_,_,_,_,_,_,adv_opts(_,_,Pv,_,_,_),_),!,
        hostdirs(S,Remdir),
        format(RemFile_stor,"%s/%s",Remdir,LocalFile_stor),
        change_slash(RemFile_stor,RemoteFile_stor),
        retractall(chain(_,_)),
        assert(chain(LocalFile_stor,RemoteFile_stor)),
        format(FullLocalFile_stor,"%s\\%s",From,LocalFile_stor),
        change_state(S,sstate_reply(stor(LocalFile_stor))),
        what_win(Lbox_code,Str_win),
        format( Str_prn, "%s,%d: Sending %s |",Str_win,Index, FullLocalFile_stor ),
        reflectState( Str_prn ),
        ftplay_sendfile(S,FullLocalFile_stor,RemoteFile_stor,Pv),
        !.
  is_any_files(S,2):-
        server_files(S,RemoteFile_retr,ss(_,_,_,_,Size_str,_,_,_,_)),    %i.e even one left
        full_names_retr(S,RemoteFile_retr,LocalFile_retr),
        retractall(chain(_,_)),
        assert(chain(LocalFile_retr,RemoteFile_retr)),
        change_state(S,sstate_reply(retr(LocalFile_retr))),
        term_str(ULONG,Size,Size_str),
        get_pass_mode(S,Pv),
        sock(S,_,Lbox_code,Index),
        what_win( Lbox_code, Str_win ),
        format( Str_prn, "%s,%d: Receiving %s |",Str_win,Index, RemoteFile_retr ),
        reflectState( Str_prn ),
        ftplay_recvfile(S,LocalFile_retr,RemoteFile_retr,Size,Pv),
        !.
  is_any_files(S,_):-		%no files - we can finish sync.
        change_state(S,sstate_reply(quit)),
        ftplay_logout(S),
        !.

%predicates check the type of remote system - now only UNIX and MS WIndows NT
%it is neccesary for working with files-lists from remote hosts - they have different format
  what_syst(S,Str):-           		    % Reply format: 215-Some system
        searchchar(Str,' ',FoundPos),
        FoundPos <> 4,
        FP = FoundPos - 1,
        frontstr(FP,Str,StartString,_),
        frontstr(4,StartString,_,Syst_name),
        check_syst(S,Syst_name),
        !.
  what_syst(S,Str):-                        % Reply format: 215 Some system
        searchchar(Str,' ',FoundPos),
        FoundPos = 4,
        frontstr(4,Str,_,RestString),
        searchchar(RestString,' ',FP),
        FP1 = FP - 1,
        frontstr(FP1,RestString,Syst_name,_),
        check_syst(S,Syst_name),
        !.
  what_syst(_,_).

  check_syst(S,"UNIX"):-
        assert(kind_system(S,2)).
  check_syst(S,"Windows_NT"):-
        assert(kind_system(S,3)).

%predicate tests result answer
  what_error_kind(Err,"",Out):-
        errormsg("prolog.err",Err,Out,_),!.
  what_error_kind(_,Out,Out).
  
%predicates for closing connection in unusual situations
  err_shutdown_conn(S,Lbox_code,Index):-
        retract(sock(S,_,Lbox_code,Index)),!,
        retractall(for_connect(_,_,Lbox_code,Index)),
        retractall(server_files(S,_,_)),
        retractall(chain(_,_)),
        retractall(chainDel(_,_)),
        retractall(local_files(S,_,_)),
       	retractall(sendFilesToDelete(S,_,_)),
  	retractall(recvFilesToDelete(S,_,_)),
  	retractall(noDelIfDirNotExist_db(S,_)),
        retractall(hostdirs(S,_)),
        retractall(kind_system(S,_)),
        retractall(pasv_mode_transfer(S,_)),
        !.
  err_shutdown_conn(_S,Lbox_code,Index):-
  	%NOTE: THIS SOLUTION WILL WORK ONLY IF ONE CONNECTION PER TIME
  	%because of for_connect - the design of program should be reengineered to support multiconnections 
  	%per time
  	for_connect(_,_,Lbox_code,Index),
  	retract(for_connect(_,_,Lbox_code,Index)),
  	!.
  	
%error handler that is used during establishing of connection
  err_ini(Lbox_code,Index):-
  	options(_,_,_,Sr,_),
        entry_cur_retry(Lbox_code,Index,Sr_cur),
        test_retry(Lbox_code,Index,Sr,Sr_cur),
        change_pos_status(Lbox_code,Index,"Waiting"),
	fa_dialog(DlgWin),
        change_mode_to_en(DlgWin,[idc_stop]),
        retractall(on_work), delete_on_work(),
        win_PostEvent(DlgWin,e_Native(msg_is_on,0,0)),!.

/*
%deletes files and directories from a given path
  is_del(Path,"Yes"):-
        delete_files(Path),
        delete_dirs(Path).
  is_del(_,"No").
*/
%deletes a given file
  is_del_file(FileName,"Yes"):-
%KI change 03.09.1998
%  	deletefile(FileName)
        trap(deletefile(FileName),_,true),!.
  is_del_file(_,"No").

/*  delete_files(Path):-
        get_filesRecurs(Path,FullName,_),
           PATH >< FullName,
           trap(deletefile(FullName),_,true),
        fail.
  delete_files(_).

  delete_dirs(Path):-
        get_dirs(Path,FullName,STAMP),
           PATH >< FullName,
           STAMP = dir,
           trap(rmdir(FullName),_,true),
        fail.
  delete_dirs(_).

%gets a directory from a given path
%  get_dirs("","",dir):- !, fail.
  get_dirs(PATH,UpperPath,dir):- upper_lower(UpperPath,PATH).
  get_dirs(PATH,FName,STAMP):-
        concat(PATH,"\\*.*",PP),
        trap(dirfiles(PP,fa_subdir,SUBDIR,_,_,_,_,_,_,_,_),_,true),
        SUBDIR >< ".",
        SUBDIR >< "..",
        format(NEWPATH,"%\\%",PATH,SUBDIR),
        get_dirs(NEWPATH,FName,STAMP).
  get_dirs(PATH,PATH,dir).
*/

%predicates that read information from fls.tmp - a result of last LIST command
%and fills server_files database. There is no a requirement in specification for a format of output of LIST command
%so it varies between UNIX and MSDOS 
%+ the set of check_spaces* predicates
  fill_server_files(S):-
        readdevice(Old),
        readdevice(file_dir),
        kind_system(S,Kind),
        prep_read(Kind),
        readdevice(Old),
        read_from_fls(S,file_dir),
        closefile(file_dir),
        !.

  prep_read(2):-readln(_).
  prep_read(3):-!.

/*  check_spaces_concate_names( [], "" ):-!.
  check_spaces_concate_names( [El|L], Str ):-!,
  	check_spaces_concate_names( L, Str_out ),
  	format( Str, "%s %s", El, Str_out ).*/

  check_spaces_is_fifthSize( Cnt, Cnt, [Size_str|_] ):-
  	trap( term_str(ULONG,_,Size_str), _, true ),
  	!.
  check_spaces_is_fifthSize( Cnt, Cnt, _ ):-!,
  	fail.
  check_spaces_is_fifthSize( Cnt, Number, [_|L] ):-
  	NewCnt = Cnt + 1,!,
  	check_spaces_is_fifthSize( NewCnt, Number, L ).
  check_spaces_is_fifthSize( _, _, [] ):-!,
  	fail.

  check_spaces_copy_elements( Cnt, Cnt, Names, [WholeName] ):-
  	list_to_string( Names, " ", WholeName ),
  	!.
  check_spaces_copy_elements( Cnt, Number, [El|L_in], [El|L_out] ):-
  	NewCnt = Cnt + 1,!,
  	check_spaces_copy_elements( NewCnt, Number, L_in, L_out ).

  check_spaces_in_names( 2, LstS, LstS ):-			% no spaces in filename
  	LstS = [_,_,_,_,_,_,_,_,_],!.
  check_spaces_in_names( 2, LstS, Lst ):-
  	check_spaces_copy_elements( 0, 8, LstS, Lst ),!.	%ninth element is filename
  check_spaces_in_names( 3, LstS, LstS ):-			% no spaces in filenames MS-DOS style
  	LstS = [_,_,_,_],!.
  check_spaces_in_names( 3, LstS, LstS ):-			% no spaces in filenames UNIX style
  	LstS = [_,_,_,_,Size_str,_,_,_,_],
  	trap( term_str(ULONG,_,Size_str), _, true ),
  	!.
  check_spaces_in_names( 3, LstS, Lst ):-			% UNIX with spaces
	check_spaces_is_fifthSize( 0, 4, LstS ),!,		% UNIX places size at 5th position
	check_spaces_copy_elements( 0, 8, LstS, Lst ).
  check_spaces_in_names( 3, LstS, Lst ):-			%MS DOS with spaces
  	check_spaces_copy_elements( 0, 3, LstS, Lst ),
  	!.
  	
  fill_dbase(2,[Perm,Cat,Cr,Cr1,Size,Mon,Day,Time,Name],ss(Perm,Cat,Cr,Cr1,Size,Mon,Day,Time,Name),Name):-!.
  fill_dbase(2,[FullName,Perm,Cat,Cr,Cr1,Size,Mon,Day,Time,Name],ss(Perm,Cat,Cr,Cr1,Size,Mon,Day,Time,Name),FullName):-!. %files from db - UNIX
  fill_dbase(3,[Date,Time,Size,Name],ss("_","_","_","_",Size,Date,"_",Time,Name),Name):-      %files
        Size<>"<DIR>",
        !.
  fill_dbase(3,[Date,Time,Dir,Name],ss(Dir,"_","_","_","_",Date,"_",Time,Name),Name):-!.      %dir-ries
  fill_dbase(3,[Perm,Cat,Cr,Cr1,Size,Mon,Day,Time,Name],ss(Perm,Cat,Cr,Cr1,Size,Mon,Day,Time,Name),Name):-!. %NT  with UNIX type path
  fill_dbase(3,[FullName,"_","_","_","_",Size,Date,"_",Time,Name],ss("_","_","_","_",Size,Date,"_",Time,Name),FullName):-!. %files from db - NT MSDOS
  fill_dbase(3,[FullName,Perm,Cat,Cr,Cr1,Size,Mon,Day,Time,Name],ss(Perm,Cat,Cr,Cr1,Size,Mon,Day,Time,Name),FullName):-!. %files from db - NT UNIX  

  read_from_fls(S,File):-
        not(eof(File)),
        form_lst(File,LstS," "),
        kind_system(S,Kind),
        check_spaces_in_names( Kind, LstS, Lst ),
        fill_dbase(Kind,Lst,SERV_STAMP,Name),
        is_dot(S,Name,SERV_STAMP),!,
        read_from_fls(S,File).
  read_from_fls(_,_).

  is_dot(S,Name,SERV_STAMP):-
        Name<>".",
        Name<>"..",
        hostdirs(S,CurRemdir),
        format(FullName,"%/%",CurRemdir,Name),
        assert(server_files(S,FullName,SERV_STAMP)),!.
  is_dot(_,_,_).

%predicate forms a list of strings from a string from file, ignoring spaces btw information
  form_fields1("", _, [] ):-
      !.
  form_fields1(Str, Delim, Result):-
      str_char( Delim, DelimChar ),
      frontchar(Str, DelimChar, RestString ),!,
      Result = form_fields1( RestString, Delim ).
  form_fields1(Str, Delim, [Element|Result]):-
      searchstring( Str, Delim, Pos ),
      NB=Pos-1,
      frontstr(NB,Str,Element,RestString),!,
      Result = form_fields1( RestString, Delim ).
  form_fields1(Str, _, [Str]):-
      !.

%predicate checks is retrieve of subdirectories required
  check_IsSubDirNecces(b_false,S,2):-
  	server_files(S,Name,ss(Perm,_,_,_,_,_,_,_,_)),
        	frontchar(Perm,'d',_),
	        retract(server_files(S,Name,ss(Perm,_,_,_,_,_,_,_,_))),
	fail.
  check_IsSubDirNecces(b_false,_,2):-!.
  check_IsSubDirNecces(b_true,_,2):-!.
  check_IsSubDirNecces(b_false,S,3):-
  	server_files(S,Name,ss(Perm,_,_,_,_,_,_,_,_)),
	        frontchar(Perm,'d',_),
	        retract(server_files(S,Name,ss(Perm,_,_,_,_,_,_,_,_))),
  	fail.
  check_IsSubDirNecces(b_false,S,3):-
  	server_files(S,Name,ss(Dir,_,_,_,_,_,_,_,_)),
	        Dir = "<DIR>",
	        retract(server_files(S,Name,ss(Dir,_,_,_,_,_,_,_,_))),        
  	fail.
  check_IsSubDirNecces(b_false,_,3):-!.
  check_IsSubDirNecces(b_true,_,3):-!.
  
%predicate tests is there directories in server_files database
  is_dirs(S,2):-
        server_files(S,Name,ss(Perm,_,_,_,_,_,_,_,_)),
        frontchar(Perm,'d',_),
        retract(hostdirs(S,_)),!,
        assert(hostdirs(S,Name)),
        retract(server_files(S,Name,ss(Perm,_,_,_,_,_,_,_,_))),
        get_pass_mode(S,Pv),
        ftplay_listfile(S,"fls.tmp",Name,Pv),
        !.
  is_dirs(S,3):-          % NT with UNIX type path
        server_files(S,Name,ss(Perm,_,_,_,_,_,_,_,_)),
        frontchar(Perm,'d',_),
        retract(hostdirs(S,_)),!,
        assert(hostdirs(S,Name)),
        retract(server_files(S,Name,ss(Perm,_,_,_,_,_,_,_,_))),
        get_pass_mode(S,Pv),
        ftplay_listfile(S,"fls.tmp",Name,Pv),
        !.                      
  is_dirs(S,3):-
        server_files(S,Name,ss(Dir,_,_,_,_,_,_,_,_)),
        Dir = "<DIR>",
        retract(hostdirs(S,_)),!,
        assert(hostdirs(S,Name)),
        retract(server_files(S,Name,ss(Dir,_,_,_,_,_,_,_,_))),
        get_pass_mode(S,Pv),
        ftplay_listfile(S,"fls.tmp",Name,Pv),
        !.
  is_dirs(S,_):-                  %no dir-ries
        sock(S,_,Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,Remdir,_,_),!,
        change_slash(Remdir,Remdir_u),
        retract(hostdirs(S,_)),!,
        assert(hostdirs(S,Remdir_u)),
        is_empty_serv_dirry(S,Index),
        is_db_recv(S,Index),
        mes_no(S,Index),
        change_state(S,sstate_reply(retr(""))),
        test_state_end(S,sstate_reply(retr(""))),
        !.

%formats a full name of local file for receiving (incoming data will be written to this file)
  full_names_retr(S,FullFile_retr,LocalFile_retr):-
        sock(S,_,Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,To,_,_,_,_,_,Remdir,_,_),!,
        str_len(Remdir,L),
        L1=L+1,
        frontstr(L1,FullFile_retr,_,ReducedFile_retr),
        change_slash(Loc_file,ReducedFile_retr),
        format(LocalFile_retr,"%s\\%s",To,Loc_file),
        !.

%predicate transforms a DOS-name into UNIX-name- (i,o),(o,i)
  change_slash(StrDos,StrUnix):-
        bound(StrDos),
        searchchar(StrDos,'\\',FoundPos),
        NB=FoundPos-1,
        frontstr(NB,StrDos,StartString,RestString),
        frontchar(RestString,'\\',Rest1),
        format(Str,"%/%",StartString,Rest1),!,
        change_slash(Str,StrUnix).
  change_slash(StrDos,StrUnix):-
        bound(StrUnix),
        searchchar(StrUnix,'/',FoundPos),
        NB=FoundPos-1,
        frontstr(NB,StrUnix,StartString,RestString),
        frontchar(RestString,'/',Rest1),
        format(Str,"%\\%",StartString,Rest1),!,
        change_slash(StrDos,Str).
  change_slash(Str,Str):-!.

%closes every open socket, used if unexpected situation occured
  kill_sockets():-
        sock(S,_,_,_),
                ftplay_close(S),
                err_shutdown_conn(S,_,_),
        fail.
  kill_sockets().

%predicates test does reading or writing of new file possible
  is_access():-
        trap(openread(file_dir,"fls.tmp"),_,true),
        !.
  is_access():-
        vpi_ProcessEvents(b_true),
        is_access().

  is_access_wr():-
        filenameunique("tr",OSFile),
        trap(openwrite(file_dir,OSFile),_,true),
        closefile(file_dir),
        deletefile(OSFile),
        !.
  is_access_wr():-
        vpi_ProcessEvents(b_true),
        is_access_wr().

%predicates print into file ftpagent.log and screen (log window) if it is in full log mode
  d_print(S,Str):-
	options(log(1,FileName),_,_,_,_),
        sock(S,_,Lbox_code,Index),
        what_win(Lbox_code,Str_win),
        format(Str_prn,"%s,%d: %s",Str_win,Index,Str),
        write_log_wnd(Str_prn,FileName),
        !.
  d_print(S,Str):-
        options(log(1,FileName),_,_,_,_),
        not(sock(S,_,_,_)),!,
        format(Str_prn,"Error while establishing connection: %s",Str),
        write_log_wnd(Str_prn,FileName),
        !.
  d_print(_,_).

  d_print1(Lbox_code,Index,Str):-
        options(log(1,FileName),_,_,_,_),
        what_win(Lbox_code,Str_win),
        format(Str_prn,"%s,%d: %s",Str_win,Index,Str),
        write_log_wnd(Str_prn,FileName),
        !.
  d_print1(_,_,_).

  what_win(0,"SendList").
  what_win(1,"ReceiveList").

%predicate tests does for given list_entry file send*.db exists
  is_db_send(S,From,Lbox_code,Index):-
        format(OSFileName,filename_dba_send,Index),
        existfile(OSFileName),
        trap(openread(file_db,OSFileName),E,common_FileErrorHandle(E)),
        fill_local_db(S,file_db,From),
        closefile(file_db),!,
        deletefile(OSFileName),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,adv_opts(_,_,_,_,UseFileNameOnly,DoFullSynch),_),!,
        find_diff_send( S, UseFileNameOnly ),
        is_ToDelete( S, Lbox_code, Index, DoFullSynch ),
        !.
  is_db_send(S,_,Lbox_code,Index):-       %no database for this position yet
        format(OSFileName,filename_dba_send,Index),
        not(existfile(OSFileName)),
        is_local_rest(S,Lbox_code,Index),
        !.

%predicate tests does for given list_entry file recv*.db exists
  is_db_recv(S,Index):-
        format(OSFileName,"recv%d.db",Index),
        existfile(OSFileName),
        trap(openread(file_db,OSFileName),E,common_FileErrorHandle(E)),
        fill_serv_db(S,file_db),
        closefile(file_db),!,
        deletefile(OSFileName),
        sock(S,_,Lbox_code,Index),
        list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,adv_opts(_,_,_,_,UseFileNameOnly,_),_),!,
        find_diff_PerformNoDelIfDirNotExist( S ),
        find_diff_recv( S, UseFileNameOnly ),
        !.
  is_db_recv(_,Index):-    %no database for this position yet
        format(OSFileName,"recv%d.db",Index),
        not(existfile(OSFileName)),
        !.

%clears database of files to delete if it is not needed
  is_ToDelete( S, Lbox_code, Index, b_false ):-
  	retractall( sendFilesToDelete( S, _, _ ) ),
        is_local_rest( S, Lbox_code, Index ),
        !.
  is_ToDelete( S, Lbox_code, Index, b_true ):-
  	is_local_rest( S, Lbox_code, Index ),
  	!.


%predicates for writing *.db files
  write_db(File,FileName,s(Hour,Min,Sec,Year,Month,Day,Size)):-
        format(Str,"%s;%u;%u;%u;%u;%u;%u;%U\n",FileName,Hour,Min,Sec,Year,Month,Day,Size),
        writedevice(Old),
        writedevice(File),
        trap(write(Str),_,dlg_Error("Error while writing db-file!")),
        writedevice(Old),!.

  write_db_recv(File,FullName,ss(Perm,Cat,Cr,Cr1,Size,Mon,Day,Time,Name)):-
        format(Str,"%s;%s;%s;%s;%s;%s;%s;%s;%s;%s\n",FullName,Perm,Cat,Cr,Cr1,Size,Mon,Day,Time,Name),
        writedevice(Old),
        writedevice(File),
        trap(write(Str),_,dlg_Error("Error while writing db-file!")),
        writedevice(Old),!.

%predicate for writing ftpagent.log file
  write_mes(1,LocalFile,Host,RemFile):-
  	options(log(1,FileName),_,_,_,_),
        format(Str_prn,"%s  >>>  %s  %s\n",LocalFile,Host,RemFile),
        write_log_wnd(Str_prn,FileName),
        !.
  write_mes(11,LocalFile,Host,RemFile):-
  	options(log(1,FileName),_,_,_,_),
        format(Str_prn,"%s  DELETED AT  %s  %s\n",LocalFile,Host,RemFile),
        write_log_wnd(Str_prn,FileName),
        !.
  write_mes(2,Host,RemFile,LocalFile):-
  	options(log(1,FileName),_,_,_,_),
	format(Str_prn,"%s  %s  >>>  %s\n",Host,RemFile,LocalFile),
        write_log_wnd(Str_prn,FileName),
        !.
  write_mes(12,Host,RemFile,LocalFile):-
  	options(log(1,FileName),_,_,_,_),
	format(Str_prn,"%s  %s  DELETED AT  %s\n",Host,RemFile,LocalFile),
        write_log_wnd(Str_prn,FileName),
        !.
  write_mes(_,_,_,_).

%predicates for filling local_files1 from a string from send*.db file
  fill_local_db(S,File,From):-
        not(eof(File)),
        form_lst(File,Lst,";"),
        fill_local1(S,From,Lst),!,
        fill_local_db(S,File,From).
  fill_local_db(_,_,_).

  fill_local1(S,From,[FullName,Hour,Min,Sec,Year,Month,Day,Size]):-
        filenamereduce(FullName,From,ReducedName),
        term_str( UNSIGNED ,Hour1,Hour),
        term_str( UNSIGNED ,Min1,Min),
        term_str( UNSIGNED ,Sec1,Sec),
        term_str( UNSIGNED ,Year1,Year),
        term_str( UNSIGNED ,Month1,Month),
        term_str( UNSIGNED ,Day1,Day),
        term_str(ulong,Size1,Size),
        assert(local_files1(S,ReducedName,s(Hour1,Min1,Sec1,Year1,Month1,Day1,Size1))),
        !.

%predicates for filling server_files1 from a string from recv*.db file
  fill_serv_db(S,File):-
        not(eof(File)),
        form_lst(File,Lst,";"),
        kind_system(S,Kind),
        fill_dbase(Kind,Lst,SERV_STAMP,FullName),
        assert(server_files1(S,FullName,SERV_STAMP)),!,
        fill_serv_db(S,File).
  fill_serv_db(_,_).

%predicates test is local_files database empty: if not then socket starts connection
  is_local_rest(S,Lbox_code,Index):-
        local_files(S,_,_),!,                %there is at least one file
  	is_local_rest_Go( S,Lbox_code,Index ),
        !.
  is_local_rest(S,Lbox_code,Index):-
        not(local_files(S,_,_)),
        sendFilesToDelete( S, _, _ ),!,
        is_local_rest_Go( S,Lbox_code,Index ),
        !.
  is_local_rest(S,Lbox_code,Index):-
        not(local_files(S,_,_)),!,
        d_print1(Lbox_code,Index,"There is nothing to send!\n"),
        list_entry(Lbox_code,Index,_,_From,_,_,_Delete,_,_,_,_,_,_),
        !,
%        is_del(From,Delete),
        retractall(hostdirs(S,_)),
        ftplay_logout(S),
        !.
        
  is_local_rest_Go( S,Lbox_code,Index ):-
        change_pos_status(Lbox_code,Index,"Sending"),
        list_entry(Lbox_code,Index,_,_,To,_,_,User_Id,pwd(_,User_pwd),_,_,adv_opts(_,proxy(Is_fw,_,_),_,_,_,_),_),!,
        change_state(S,sstate_reply(login)),
        is_firewall_enter(Is_fw,To,User_Id,User_Id_f),
        pwd_str_bin(User_pwd_str,User_pwd),
        ftplay_login(S,User_Id_f,User_pwd_str,""),
        !.

%predicate reads a string from file and returns a list of strings
  form_lst(File,Lst, Delim ):-
        readdevice(Old),
        readdevice(File),
        readln(Str),
        readdevice(Old),
        Lst = form_fields1( Str, Delim ),
        !.

%predicate test server_files database after comparing it with server_files1 database
  mes_no(S,_):-
        not(server_files(S,_,_)),
        d_print(S,"There is nothing to receive!\n"),!.
  mes_no(_,_).

%predicates test is server_files or local_files database empty after collecting information from
%local disk or remote host
  is_empty_sour_dirry(S,Index):-
        not(local_files(S,_,_)),
        format(OSFileName,"send%d.db",Index),
        trap(openwrite(file_db,OSFileName),E,common_FileErrorHandle(E)),
        closefile(file_db),!.
  is_empty_sour_dirry(_,_).

  is_empty_serv_dirry(S,Index):-
        not(server_files(S,_,_)),
        format(OSFileName,"recv%d.db",Index),
        trap(openwrite(file_db,OSFileName),E,common_FileErrorHandle(E)),
        closefile(file_db),!.
  is_empty_serv_dirry(_,_).

%for log purposes - in case of usage of proxy it forms a string that is passed to proxy server itself
  is_firewall_enter(1,Host_dest,Id,Res):-
        format(Res,"%s@%s",Id,Host_dest),!.
  is_firewall_enter(0,_,Id,Id).

%returns a name of host and a port in case of usage of proxy (1) and without (0)
  is_firewall_con(1,_,_,H,P,H,P):-!.
  is_firewall_con(0,H,P,_,_,H,P).

%initiates another retry to perform sync if previous failed.
  test_retry(Lbox_code,Index,Sr,Sr):-
  	retract(entry_cur_retry(Lbox_code,Index,_)),
      	change_pos_status(Lbox_code,Index,"Waiting"),
	fa_dialog(DlgWin),
        change_mode_to_en(DlgWin,[idc_stop]),
        retract(on_work), delete_on_work(),
        win_PostEvent(DlgWin,e_Native(msg_is_on,0,0)),!.
  test_retry(Lbox_code,Index,Sr,Sr_cur):-
  	Sr <> Sr_cur,
  	retract(entry_cur_retry(Lbox_code,Index,Sr_cur)),
  	Sr1 = Sr_cur + 1,
  	assert(entry_cur_retry(Lbox_code,Index,Sr1)),!,
  	send_or_receive(Lbox_code,Index).

%returns the value that determs passive mode transfer
  get_pass_mode(S,Pv):-
  	sock(S,_,Lbox_code,Index),
  	list_entry(Lbox_code,Index,_,_,_,_,_,_,_,_,_,adv_opts(_,_,Pv,_,_,_),_),!.

%clean up all entry related databases	
  stop_entry(Lbox_code,Index):-
  	retract(sock(S,_,Lbox_code,Index)),!,		% sending/receiving is going
  	d_print1(Lbox_code,Index,"Synchronization was stoped by a user\n"),
  	retractall(local_files(S,_,_)),
  	retractall(local_files1(S,_,_)),
  	retractall(server_files(S,_,_)),
  	retractall(server_files1(S,_,_)),
  	retractall(noDelIfDirNotExist_db(S,_)),
  	retractall(sendFilesToDelete(S,_,_)),
  	retractall(recvFilesToDelete(S,_,_)),
  	retractall(chain(_,_)),
  	retractall(chainDel(_,_)),
  	retractall(hostdirs(S,_)),
  	retractall(kind_system(S,_)),
  	retractall(pasv_mode_transfer(S,_)),
  	ftplay_QuitCommand( S ),
  	ftplay_close(S),
        change_pos_status(Lbox_code,Index,"Stopped"),
	fa_dialog(DlgWin),
        change_mode_to_en(DlgWin,[idc_stop]),
        retractall(on_work),delete_on_work(),
        win_PostEvent(DlgWin,e_Native(msg_is_on,0,0)),!.
  stop_entry(Lbox_code,Index):-				%waiting for connection
  	retract(for_connect(_,_,Lbox_code,Index)),!,
        change_pos_status(Lbox_code,Index,"Stopped"),
        fa_dialog(DlgWin),
        change_mode_to_en(DlgWin,[idc_stop]),
        retractall(on_work),delete_on_work(),
        win_PostEvent(DlgWin,e_Native(msg_is_on,0,0)),!.  	  
  stop_entry(Lbox_code,Index):-				%waiting for general timer event
        change_pos_status(Lbox_code,Index,"Stopped"),
        fa_dialog(DlgWin),
        change_mode_to_en(DlgWin,[idc_stop]),
	!.  	  
	
%predicates update status line in main window - when data is transferred a rolling stick is shown
  make_state_update():-
	fa_dialog(DlgWin),
	CtrlWin = win_GetCtlHandle(DlgWin, idct_fa_state ),
	Str_state_old = win_GetText(CtrlWin),
	str_len(Str_state_old,L),
	L1 = L - 1,
	frontstr(L1,Str_state_old,StartString,RestString),
	get_last_state_symb(RestString,LastSymb),
	format(Str_state_new,"%s%s",StartString,LastSymb),
	win_SetText(CtrlWin,Str_state_new).
	
  get_last_state_symb("|","\\"):-!.
  get_last_state_symb("\\","-"):-!.
  get_last_state_symb("-","/"):-!.
  get_last_state_symb("/","|"):-!.

  reflectState( Str ):-
	fa_dialog(DlgWin),
	CtrlWin = win_GetCtlHandle(DlgWin, idct_fa_state ),
	win_SetText( CtrlWin, Str ).

