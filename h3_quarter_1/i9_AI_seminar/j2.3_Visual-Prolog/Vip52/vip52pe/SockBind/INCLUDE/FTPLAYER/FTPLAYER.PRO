/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Tool:  FTP layer
 FileName: ftplayer.pro
 Purpose: A layer over Message layer for FTP using applications
 Written by: Konstantin Ivanov
 Comments: Include it in your project!
******************************************************************************/
    
CONSTANTS
  ftp_socket=0xC500
  net_timeout_err = 50000
  ftpl_msgl_err = 0
  ftpl_ftpl_err = 1
  
DOMAINS  
  ftplay_hndl=ftplay_win(WINDOW,UNSIGNED)
  ftp_sequence=ini(STRING,USHORT);
               login(STRING,STRING);
               prep_file_trans(FTP_SEQUENCE);
               listfile(STRING,STRING);
               appendfile(STRING,STRING);
               renamefile(STRING);
               user;pass;acct;cdup;cwd;smnt;
               quit;rein;
               type;port;mode;stru;pasv;
               stor(STRING,STRING);retr(STRING,STRING);stou;rnfr;rnto;dele;abor;rest;allo;rmd;pwd;mkd;
               syst;stat;help;
               noop;site
DATABASE - internal
  sock_acc(SOCKET Control,SOCKET Accepted,STRING Kind)
  unique_file(SOCKET,STRING)
  mkd_dir(SOCKET,STRING,STRING,STRING,STRING,STRING)
  ftp_created_dirs( SOCKET Control, STRING RemoteDir )
  control_sock(SOCKET)
determ ftp_window(WINDOW)
  ftp_sock_cond(SOCKET,FTPLAY_HNDL,FTP_SEQUENCE)
  for_connect(SOCKET,FTPLAY_HNDL,USHORT,STRING)
  recv_close(SOCKET)
  code_com(SOCKET,STRING)
determ busy_port(USHORT)
determ ftplay_LastErrorDB( UNSIGNED )
determ debug_file(FTPLAY_DEBUG_HNDL)
determ nettime(INTEGER)
  ftp_timer(SOCKET,LONG,INTEGER)
  ftp_accept_timer(SOCKET Sc,SOCKET Sd,LONG,INTEGER)
  ftp_connection_timer(SOCKET,LONG,INTEGER)
  ftp_connect_timer(FTPLAY_HNDL,LONG,INTEGER)
  pasv_answer(SOCKET,STRING Port,STRING WholeAnsw)
  
  debug_timer( LONG )
  
  data_incoming(SOCKET,BINARY)
  data_recvfile(SOCKET,STRING,ULONG)
  data_connect(SOCKET)
  data_open(SOCKET)
  data_close(SOCKET)
  data_sent(SOCKET)
  data_recvd(SOCKET)

  msglay_answer(SOCKET,msglay_event)
  ftplay_answer(SOCKET, ftplay_reply)
%____________________________________________________________
%             Handlers for Msglayer
%____________________________________________________________
PREDICATES
  common_hndl : msglay_handler

%____________________________________________________________
%               PROCESS PREDICATES
%____________________________________________________________
PREDICATES
  determ manage_hndl(SOCKET,msglay_event)
  determ send_hndl(SOCKET,msglay_event)
  determ recv_hndl(SOCKET,msglay_event)
%____________________________________________________________
%              ERROR PREDICATES
%____________________________________________________________
PREDICATES
  determ connection_err(SOCKET, UNSIGNED, INTEGER )		- (i,i,i)
  connection_err(SOCKET, UNSIGNED )			- (i,i)
  determ controlconn_err(SOCKET Data,UNSIGNED, INTEGER )	- (i,i,i)
  all_err(SOCKET,FTPLAY_HNDL,UNSIGNED)	- (i,i,i)
  ini_err(FTPLAY_HNDL,UNSIGNED)		- (i,i)
  determ ini_err2( SOCKET, UNSIGNED )		- (i,i)
  what_err(UNSIGNED,STRING)
  what_err_err(MSGLAY_ERROR_KIND,STRING)
%____________________________________________________________
%              DATA CONNECTION PREDICATES
%____________________________________________________________
PREDICATES
  test_beg_recv(SOCKET)
  test_beg_send(SOCKET)
  procedure test_end_recv(SOCKET)
  test_end_send(SOCKET)
procedure  data_clear_flags(SOCKET)
%____________________________________________________________
%                   PORT predicates
%____________________________________________________________
PREDICATES
  determ make_port(STRING,USHORT,STRING) - (i,i,o),(o,o,i)
  STRING sc(STRING,STRING,CHAR,CHAR)
  determ new_port(USHORT,USHORT) - (i,o)
  was_busy_port(USHORT)
  USHORT port_increment( USHORT, USHORT ) - (i,i)
  investig_pasv_answ(SOCKET,STRING) - (i,i)
%____________________________________________________
%          Directory creating predicates
%____________________________________________________
  is_md1(STRING)
  is_md_int( STRING, UNSIGNED )	- (i,i)
  md(STRING)
  procedure sear_slash(STRING,STRING,STRING)
  procedure is_mkd(SOCKET,STRING,STRING,STRING)				 - (i,i,i,i)
  determ is_mkd_dir(SOCKET,INTEGER,STRING)
  procedure check_RemDir( SOCKET, STRING, STRING, STRING, STRING, STRING ) - (i,i,i,i,i,i)
%____________________________________________________
%                Write a string to a socket
%____________________________________________________
  procedure ftp_write_str(SOCKET,STRING,STRING)
  procedure close_connections( SOCKET )		- (i)
  check_OtherConnection()
  write_debug(STRING)  
%____________________________________________________
%                Misc predicates
%____________________________________________________
  procedure myCloseSocket( SOCKET ) 	- (i)
  procedure isAnyTimer( SOCKET )	- (i)

%____________________________________________________
%                Timer predicates
%____________________________________________________
PREDICATES
  procedure test_rest1(SOCKET,INTEGER)
  procedure test_rest_connection(SOCKET,INTEGER)
  procedure test_rest_accept(SOCKET,SOCKET,INTEGER)
  procedure test_rest0(ftplay_hndl,INTEGER)
  what_rest_time(ULONG,ULONG,INTEGER) - (i,o,o)
  determ set_ftp_timer0(ftplay_hndl,INTEGER)
  determ set_ftp_timer1(SOCKET,INTEGER)
  determ set_ftp_connection_timer(SOCKET,INTEGER)
  determ set_ftp_accept_timer(SOCKET,SOCKET,INTEGER)
CLAUSES

  set_ftp_timer0(User_hndl,Cur):-
  	ftp_window(FTPwin),
        what_rest_time(Cur,Nt_ul ,Rest),
        Nt = val( UNSIGNED, Nt_ul ),
        FTPtimer = timer_Set(FTPwin, Nt),
        retractall(ftp_connect_timer(User_hndl,_,_)),
        assert(ftp_connect_timer(User_hndl,FTPtimer,Rest)),
        !.
  set_ftp_timer1(S,Cur):-
  	ftp_window(FTPwin),
        what_rest_time(Cur,Nt_ul,Rest),
	Nt = val( UNSIGNED, Nt_ul ),
        FTPtimer = timer_Set(FTPwin, Nt),
        assert(ftp_timer(S,FTPtimer,Rest)),
        !.
  set_ftp_connection_timer(Sd,Cur):-
  	ftp_window(FTPwin),
        what_rest_time(Cur,Nt_ul,Rest),
	Nt = val( UNSIGNED, Nt_ul ),
        FTPtimer = timer_Set(FTPwin, Nt),
        assert(ftp_connection_timer(Sd,FTPtimer,Rest)),
        !.
  set_ftp_accept_timer(Sc,Sd,Cur):-
  	ftp_window(FTPwin),
        what_rest_time(Cur,Nt_ul,Rest),
	Nt = val( UNSIGNED, Nt_ul ),
        FTPtimer = timer_Set(FTPwin, Nt),
        assert(ftp_accept_timer(Sc,Sd,FTPtimer,Rest)),
        !.
  test_rest1(S,0):-controlconn_err(S, net_timeout_err, ftpl_ftpl_err ),!.
  test_rest1(_,0):-!.
  test_rest1(S,Rest_cur):-set_ftp_timer1(S,Rest_cur),!.
  test_rest1(_,_).
  test_rest_connection(Sd,0):- connection_err( Sd, net_timeout_err, ftpl_ftpl_err ),!.
  test_rest_connection(_,0):-!.
  test_rest_connection(Sd,Rest_cur):-set_ftp_connection_timer(Sd,Rest_cur),!.
  test_rest_connection(_,_).
  test_rest_accept(_,Sx,0):- connection_err( Sx, net_timeout_err, ftpl_ftpl_err ),!.
  test_rest_accept(_,_,0):-!.
  test_rest_accept(Sc,Sx,Rest_cur):-set_ftp_accept_timer(Sc,Sx,Rest_cur),!.
  test_rest_accept(_,_,_).
  test_rest0(User_hndl,0):-trap(ini_err(User_hndl,net_timeout_err),_,true),!.
  test_rest0( _, 0 ):-!.
  test_rest0(User_hndl,Rest_cur):-set_ftp_timer0(User_hndl,Rest_cur),!.
  test_rest0(_,_).
  
  what_rest_time(Net,Nt,0):-
  	Net <= 60,
  	Nt = Net*1000,
  	!.
  what_rest_time(Net,60000,Rest):-
  	Rest = Net - 60,!.
%____________________________________________________
%                Misc predicates
%____________________________________________________
  myCloseSocket( S ):-
  	isAnyTimer( S ),
  	trap( msglay_CloseSoft(S), _, true ),
  	!.
  myCloseSocket( _ ).
  
  isAnyTimer( S ):-
  	retract( ftp_timer( S, TimerID, _ ) ),
  		timer_Kill( TimerID ),
  	fail.
  isAnyTimer( S ):-
  	retract( ftp_connection_timer( S, TimerID, _ ) ),
  		timer_Kill( TimerID ),
  	fail.
  isAnyTimer( S ):-
  	retract( ftp_accept_timer( _, S, TimerID, _ ) ),
  		timer_Kill( TimerID ),
  	fail.
  isAnyTimer( S ):-
  	retract( ftp_accept_timer( S, _, TimerID, _ ) ),
  		timer_Kill( TimerID ),
  	fail.
  isAnyTimer( _ ).
  
%____________________________________________________
%                Handle Msglay events
%____________________________________________________
CLAUSES
  common_hndl(_,e_Close(msglay_self)):-!.
  common_hndl(S,e_Connect(S)):-
        not(control_sock(_)),!,
        trap( S_Addr = sck_GetSockName( S ), Err1, ini_err2( S, Err1 ) ),
  	trap( sck_SplitAddress_IN(S_Addr,_,Port_h,_), Err2, ini_err2( S, Err2 ) ),
        retract(for_connect(S,User_hndl,Port_con,Host)),
        ftp_connect_timer(User_hndl,T_id,_),
        retractall(ftp_connect_timer(User_hndl,T_id,_)),
  	timer_Kill(T_id),
  	Port = sck_htons(Port_h),
        was_busy_port(Port),
        assert(ftp_sock_cond(S,User_hndl,ini(Host,Port_con))),
        assert(sock_acc(S,S,"connect")),
        ftp_window(FTPwin),
        assert(msglay_answer(S,e_Connect(S))),
        win_PostEvent(FTPwin,e_Native(ftp_socket,S,0)),
        !.
  common_hndl(S,Ev):-
        ftp_window(FTPwin),
        assert(msglay_answer(S,Ev)),
        win_PostEvent(FTPwin,e_Native(ftp_socket,S,0)),
        !.
%____________________________________________________________
%         INITIAL OF WINDOW FOR MSGlay->FTPlay WinMessages
%____________________________________________________________
PREDICATES
  ftplayer_init()
  ftp_event_eh : ehandler
  determ ftp_process_answer(SOCKET,STRING,msglay_event)
CLAUSES
  ftplayer_init():-
        not(ftp_window(_)),
        ScreenWindow = cast(window,vpi_GetAttrVal(attr_screen_window)),
        WinDefs = [dlg(wdef(wd_ModeLess,rct(0,0,0,0),"",u_Pixels),[wsf_Invisible,wsf_Disabled])],
        CreateData = cast(long,0),
        win_CreateDynDialog(ScreenWindow,WinDefs,ftp_event_eh,CreateData),
        !.
  ftplayer_init().

  ftp_event_eh(Win,e_Create(_),0):-
        assert(ftp_window(Win)),
        win_EnableHook(Win, b_true),
        !.
  ftp_event_eh(_Win,e_Timer(T_id),0):-
  	retract(ftp_timer(S,T_id,Rest)),!,
  	timer_Kill(T_id),
	test_rest1(S,Rest),
  	!.
  ftp_event_eh(_Win,e_Timer(T_id),0):-
  	retract(ftp_connection_timer(S,T_id,Rest)),!,
	timer_Kill(T_id),
	test_rest_connection(S,Rest),
  	!.
  ftp_event_eh(_Win,e_Timer(T_id),0):-
  	retract(ftp_accept_timer(Sc,Sd,T_id,Rest)),!,
	timer_Kill(T_id),
	test_rest_accept(Sc,Sd,Rest),
  	!.
  ftp_event_eh(_Win,e_Timer(T_id),0):-
  	retract(ftp_connect_timer(User_hndl,T_id,Rest)),!,
	timer_Kill(T_id),
	test_rest0(User_hndl,Rest),
  	!.
  ftp_event_eh(_Win,e_Timer(T_id),0):-
  	retract( debug_timer(T_id) ),
  	timer_kill( T_id ),
	TaskWin = vpi_GetTaskWin(),
	win_Destroy( TaskWin ),
	!.  	
  ftp_event_eh(_Win,e_Native(ftp_socket,Socket,_LParam),0):-
        control_sock(Socket),
        retract(msglay_answer(Socket,Answ)),!,
        ftp_process_answer(Socket,"control",Answ),
        !.
  ftp_event_eh(_Win,e_Native(ftp_socket,Socket,_LParam),0):-
        sock_acc(_,Socket,Kind),
        retract(msglay_answer(Socket,Answ)),!,
        ftp_process_answer(Socket,Kind,Answ),
        !.
  ftp_event_eh(_Win,e_Native(ftp_socket,Socket,_LParam),0):-    % connect isn't established
  	retract(msglay_answer(Socket,Answ)),!,
        ftp_process_answer(Socket,"connect",Answ),!.

  ftp_process_answer(S,"connect",Answ):-manage_hndl(S,Answ),!.
  ftp_process_answer(S,"control",Answ):-manage_hndl(S,Answ),!.
  ftp_process_answer(S,"1",Answ):-send_hndl(S,Answ),!.
  ftp_process_answer(S,"2",Answ):-recv_hndl(S,Answ),!.

%_____________________________________________________
%                Code_handler & Sequence handler
%_____________________________________________________
PREDICATES
  code_handler(SOCKET,INTEGER,STRING)
  determ test_sequence(SOCKET,ftp_sequence,INTEGER)
  determ is_abort_comm(SOCKET,ftp_sequence)
  determ is_stou_comm(SOCKET,ftp_sequence,STRING)
  procedure answer(SOCKET,ftplay_reply)
procedure test_is_conn(SOCKET)
CLAUSES
  code_handler(_,110,_):-!.
  code_handler(_,120,_):-!.
  code_handler(S,125,_):-
        ftp_sock_cond(S,_,Seq_state),
        test_sequence(S,Seq_state,125),!.
  code_handler(S,150,STR):-
        ftp_sock_cond(S,_,Seq_state),
        is_stou_comm(S,Seq_state,STR),!.
  code_handler(S,200,_):-
        ftp_sock_cond(S,_,Seq_state),
        test_sequence(S,Seq_state,200),!.
  code_handler(S,202,Str_answ):-answer(S,error_rep(202,Str_answ)),!.
  code_handler(S,211,STR):-answer(S,ok_str(STR)),!.
  code_handler(S,212,STR):-answer(S,ok_str(STR)),!.
  code_handler(S,213,STR):-answer(S,ok_str(STR)),!.
  code_handler(S,214,STR):-answer(S,ok_str(STR)),!.
  code_handler(S,215,STR):-answer(S,ok_str(STR)),!.
  code_handler(S,220,_):-
        ftp_sock_cond(S,_,Seq_state),
        test_sequence(S,Seq_state,220),!.
  code_handler(S,221,_):-answer(S,ok),!.
  code_handler(S,225,_):-answer(S,ok),!.
  code_handler(S,226,_):-
        ftp_sock_cond(S,_,Seq_state),
        test_sequence(S,Seq_state,226),!.
  code_handler(S,227,STR):-
  	investig_pasv_answ(S,STR),
  	ftp_sock_cond(S,_,Seq_state),
  	test_sequence(S,Seq_state,227),!.
  code_handler(S,230,_):-answer(S,ok),!.
  code_handler(S,250,_):-
        ftp_sock_cond(S,_,Seq_state),
        test_sequence(S,Seq_state,250),!.
  code_handler(S,257,STR):-is_mkd_dir(S,257,STR),!.
  code_handler(S,331,_):-
        ftp_sock_cond(S,_,Seq_state),
        test_sequence(S,Seq_state,331),!.
  code_handler(S,332,_):-
        ftp_sock_cond(S,_,Seq_state),
        test_sequence(S,Seq_state,332),!.
  code_handler(S,350,_):-
        ftp_sock_cond(S,_,Seq_state),
        test_sequence(S,Seq_state,350),!.
  code_handler(S,425,Str_answ):-new_port(100,_),answer(S,error_rep(425,Str_answ)),!.
  code_handler(S,426,_):-
        ftp_sock_cond(S,_,Seq_state),
        is_abort_comm(S,Seq_state),!.
  code_handler(S,450,Str_answ):-
  	close_connections( S ),
        answer(S,error_rep(450,Str_answ)),!.
  code_handler(S,451,Str_answ):-
        close_connections( S ),
        answer(S,error_rep(451,Str_answ)),!.
  code_handler(S,452,Str_answ):-
        close_connections( S ),
        answer(S,error_rep(452,Str_answ)),!.
  code_handler(S,500,Str_answ):-answer(S,error_rep(500,Str_answ)),!.
  code_handler(S,501,Str_answ):-answer(S,error_rep(501,Str_answ)),!.
  code_handler(S,502,Str_answ):-answer(S,error_rep(502,Str_answ)),!.
  code_handler(S,503,Str_answ):-answer(S,error_rep(503,Str_answ)),!.
  code_handler(S,504,Str_answ):-answer(S,error_rep(504,Str_answ)),!.
  code_handler(S,530,Str_answ):-answer(S,error_rep(530,Str_answ)),!.
  code_handler(S,532,Str_answ):-answer(S,error_rep(532,Str_answ)),!.
  code_handler(S,550,Str_answ):-is_mkd_dir(S,550,Str_answ),!.
  code_handler(S,551,Str_answ):-
        close_connections( S ),
        answer(S,error_rep(551,Str_answ)),!.
  code_handler(S,552,Str_answ):-
        close_connections( S ),
        answer(S,error_rep(552,Str_answ)),!.
  code_handler(S,553,Str_answ):-is_mkd_dir(S,553,Str_answ),!.
  code_handler(S,421,Str_answ):-
        answer(S,error_rep(421,Str_answ)),
        answer(S,close),!.
  code_handler(S,Code,_):-
        answer(S,error_rep(Code,"FTPlayer >> Unrecognized code\n")),!.

  answer(S,Answ):-
        ftp_sock_cond(S,ftplay_win(UserWin,UserMes),_),
        assert(ftplay_answer(S,Answ)),
        win_PostEvent(UserWin,e_Native(UserMes,S,0)),
        !.
  answer( _, _ ).	%dummy

  investig_pasv_answ(S,Str):-
	searchchar(Str,'(',FoundPos),
	frontstr(FoundPos,Str,_,RestString),
	searchchar(RestString,')',FPos),
	FP = FPos - 1,
	frontstr(FP,RestString,HostPort,_),
	retractall(pasv_answer(S,_,_)),
	assert(pasv_answer(S,HostPort,Str)),!.
  investig_pasv_answ(S,Str):-
  	assert(pasv_answer(S,"",Str)),!.

  is_abort_comm( S, abor ):-
  	close_connections( S ).

  is_stou_comm(S,stor(_,"*stou"),STR):-
        assert(unique_file(S,STR)),
        ftp_sock_cond(S,_,Seq_state),
        test_sequence(S,Seq_state,150),!.
  is_stou_comm(S,_,_):-
        ftp_sock_cond(S,_,Seq_state),
        test_sequence(S,Seq_state,150),
        !.

  is_mkd_dir(S,550,STR):-
        not(mkd_dir(S,_,_,_,_,_)),
        close_connections( S ),
        answer(S,error_rep(550,STR)),!.
  is_mkd_dir(S,553,STR):-
        not(mkd_dir(S,_,_,_,_,_)),
        close_connections( S ),
        answer(S,error_rep(553,STR)),!.
  is_mkd_dir(S,257,STR):-
        not(mkd_dir(S,_,_,_,_,_)),
        answer(S,ok_str(STR)),!.
  is_mkd_dir(S,_,_):-
        retract(mkd_dir(S,LocalFileName,RemoteName,Prev,Next,Kind)),
        sear_slash(Next,First,Last),
        concat(Prev,First,PrevAll),
        assert(mkd_dir(S,LocalFileName,RemoteName,PrevAll,Last,Kind)),
        is_mkd(S,PrevAll,Last,Kind),!.

  test_sequence(S,stor(LocalFileName,"*stou"),200):-
	retract(pasv_answer(S,HostPort,_)),!,
  	make_port(Addr,Port,HostPort),
  	ftplay_SetDataSocketSendPasv(S,Addr,Port),
        ftplay_StouCommand(S,LocalFileName),!.
  test_sequence(S,stor(LocalFileName,"*stou"),200):-
	ftplay_StouCommand(S,LocalFileName),!.        
  test_sequence(S,listfile(ListFileName,RemoteName),200):-
	retract(pasv_answer(S,HostPort,_)),!,
  	make_port(Addr,Port,HostPort),
  	ftplay_SetDataSocketRecvPasv(S,Addr,Port),
        ftplay_ListCommand(S,ListFileName,RemoteName),!.
  test_sequence(S,listfile(ListFileName,RemoteName),200):-
  	ftplay_ListCommand(S,ListFileName,RemoteName),!.
  test_sequence(S,appendfile(LocalFileName,RemoteFileName),200):-
  	retract(pasv_answer(S,HostPort,_)),!,
  	make_port(Addr,Port,HostPort),
  	ftplay_SetDataSocketSendPasv(S,Addr,Port),
	check_RemDir( S, LocalFileName, RemoteFileName, "", RemoteFileName, "appe" ),!.
  test_sequence(S,appendfile(LocalFileName,RemoteFileName),200):-
        check_RemDir( S, LocalFileName, RemoteFileName, "", RemoteFileName, "appe" ),!.
  test_sequence(S,stor(LocalFileName,RemoteFileName),200):-
  	retract(pasv_answer(S,HostPort,_)),!,
  	make_port(Addr,Port,HostPort),
  	ftplay_SetDataSocketSendPasv(S,Addr,Port),
        check_RemDir( S, LocalFileName, RemoteFileName, "", RemoteFileName, "stor" ),!.
  test_sequence(S,stor(LocalFileName,RemoteFileName),200):-
        check_RemDir( S, LocalFileName, RemoteFileName, "", RemoteFileName, "stor" ),!.
  test_sequence(S,retr(LocalFileName,RemoteFile_name),200):-
  	retract(pasv_answer(S,HostPort,_)),!,
  	make_port(Addr,Port,HostPort),
  	data_recvfile(S,LocalFileName,FileLength),
        ftplay_SetDataSocketRecvPasv(S,Addr,Port),
        ftplay_RetrCommand(S,LocalFileName,RemoteFile_name,FileLength),!.
  test_sequence(S,retr(LocalFileName,RemoteFile_name),200):-
  	data_recvfile(S,LocalFileName,FileLength),
        ftplay_RetrCommand(S,LocalFileName,RemoteFile_name,FileLength),
        !.
  test_sequence(_,mkd,200):-!.
  test_sequence(S,ini(H,P),_):-answer(S,connect(H,P)),!.
  test_sequence(S,user,Cod):-answer(S,seq(Cod,"FTPlayer >> command USER successful, sequence must be continued")),!.
  test_sequence(S,pass,Cod):-answer(S,seq(Cod,"FTPlayer >> command PASS successful, sequence must be continued")),!.
  test_sequence(S,cdup,_):-answer(S,ok),!.
  test_sequence(S,pasv,227):-
  	retract(pasv_answer(S,_,STR)),
  	answer(S,ok_str(STR)),!.
  test_sequence(S,cwd,_):-answer(S,ok),!.
  test_sequence(S,type,_):-answer(S,ok),!.
  test_sequence(S,port,_):-answer(S,ok),!.
  test_sequence(S,mode,_):-answer(S,ok),!.
  test_sequence(S,stru,_):-answer(S,ok),!.
  test_sequence(S,rein,_):-answer(S,ok),!.
  test_sequence(S,smnt,_):-answer(S,ok),!.
  test_sequence(S,noop,_):-answer(S,ok),!.
  test_sequence(S,site,_):-answer(S,ok),!.
  
  test_sequence(S,stor(_,_),150):-
  	assert(data_open(S)),
  	sock_acc(S,Sd,"1"),
	test_is_conn(Sd),
  	test_beg_send(S),!.
  test_sequence(S,stor(_,_),125):-
  	assert(data_open(S)),
  	sock_acc(S,Sd,"1"),
	test_is_conn(Sd),
  	test_beg_send(S),!.
  test_sequence(S,stor(_,_),226):-
  	assert(data_close(S)),
  	test_end_send(S),!.
  test_sequence(_,stor(_,_),_):-!.
  
  test_sequence(S,retr(_,_),150):-
	assert(data_open(S)),
	sock_acc(S,Sd,"2"),
	test_is_conn(Sd),
	test_beg_recv(S),!.
  test_sequence(S,retr(_,_),125):-
	assert(data_open(S)),
	sock_acc(S,Sd,"2"),
	test_is_conn(Sd),
	test_beg_recv(S),!.
  test_sequence(S,retr(_,_),226):-
  	assert(data_close(S)),
  	test_end_recv(S),!.
  test_sequence(_,retr(_,_),_):-!.
  
  test_sequence(S,rnfr,Cod):-answer(S,seq(Cod,"FTPlayer >> command RNFR successful, sequence must be continued")),!.
  test_sequence(S,renamefile(FileNameNew),_):-ftplay_RntoCommand(S,FileNameNew),!.
  test_sequence(S,rest,Cod):-answer(S,seq(Cod,"FTPlayer >> command REST successful, sequence must be continued")),!.
  test_sequence(S,rnto,_):-answer(S,ok),!.
  test_sequence(S,dele,_):-answer(S,ok),!.
  test_sequence(S,rmd,_):-answer(S,ok),!.
  test_sequence(S,abor,_):-
        is_abort_comm(S,abor),
        answer(S,ok),!.
  test_sequence(S,allo,_):-answer(S,ok),!.
  
  test_sequence(S,login(UserPwd,_),331):-
        format(Str,"PASS %s\n",UserPwd),
        ftp_write_str(S,Str,"PASS *****\n"),!.
  test_sequence(S,login(_,UserAcct),332):-
        format(Str,"ACCT %s\n",UserAcct),
        ftp_write_str(S,Str,Str),!.
  test_sequence(S,prep_file_trans(Seq_state),_):-
        ftplay_TypeCommand(S,"I"),
        retract(ftp_sock_cond(S,User_hndl,_)),
        assert(ftp_sock_cond(S,User_hndl,Seq_state)),
        !.
  
  test_is_conn(Sd):-
  	sock_acc(Sc,Sd,_),
  	not(data_connect(Sc)), % connection is not established yet
  	nettime(Net),
  	set_ftp_accept_timer(Sc,Sd,Net),!.
  test_is_conn(_).

%____________________________________________________________
%         SERVER INITIAL - CONTROL CONNECTION PREDICATES
%____________________________________________________________
PREDICATES
  determ SLIST ftplayer_convert(SLIST)
  sock_manage(SOCKET,SLIST)
  determ filter(STRING,STRING,STRING)
  determ sear_hyp(SOCKET,STRING,STRING)
  	sear_code(SOCKET,STRING,STRING,STRING)
  	is_com(SOCKET,STRING)
  procedure is_ftp_connect_timer( FTPLAY_HNDL )		- (i)
  
CLAUSES
  manage_hndl(Sc,_):-
  	ftp_accept_timer(Sc,Sx,T_id,_),
 	data_open(Sc),
  	retractall(ftp_accept_timer(Sc,Sx,T_id,_)),
  	timer_Kill(T_id),
  	fail.
  manage_hndl(S,_):-
  	ftp_timer(S,T_id,_),
  	retractall(ftp_timer(S,T_id,_)),
  	timer_Kill(T_id),
  	fail.
  manage_hndl(S,e_Connect(S)):-
        retract(sock_acc(S,_,_)),
        assert(control_sock(S)),
%KI add begin 09.09.1998
        nettime(Net),
        set_ftp_timer1(S,Net),
%KI add end 09.09.1998        
        !.
  manage_hndl(S,e_ReadBin(B)):-
        Strlst=binary_to_strlist(B),
        Lst=ftplayer_convert(Strlst),
        sock_manage(S,Lst),
        !.
  manage_hndl(S,e_Error(msglay_errEvConnect)):-      % there is no connection established yet
  	retract(for_connect(S,ftplay_win(UserWin,UserMes),Port,Host)),
  	is_ftp_connect_timer( ftplay_win(UserWin,UserMes) ),
  	what_err_err(msglay_errEvConnect,Str),
  	msglay_LastError( Err ),
  	retractall(ftplay_LastErrorDB(_)),
	assert(ftplay_LastErrorDB( Err )),
  	assert(ftplay_answer(S,err_connect(Str,Host,Port))),
        win_PostEvent(UserWin,e_Native(UserMes,S,0)),
        !.
  manage_hndl(S,e_Error(msglay_errEventConnect( Err ))):-      % there is no connection established yet
  	retract(for_connect(S,ftplay_win(UserWin,UserMes),Port,Host)),
  	is_ftp_connect_timer( ftplay_win(UserWin,UserMes) ),
  	what_err_err(msglay_errEventConnect( Err ),Str),
  	retractall(ftplay_LastErrorDB(_)),
	assert(ftplay_LastErrorDB( Err )),
  	assert(ftplay_answer(S,err_connect(Str,Host,Port))),
        win_PostEvent(UserWin,e_Native(UserMes,S,0)),
        !.
  manage_hndl(S,e_Error(Err)):-
        ftp_sock_cond(S,ftplay_win(UserWin,UserMes),_),
        close_connections( S ),
        retractall(code_com(S,_)),
        what_err_err(Err,Str),
        msglay_LastError( ErrVal ),
  	retractall(ftplay_LastErrorDB(_)),
	assert(ftplay_LastErrorDB( ErrVal )),
        assert(ftplay_answer( S, ftplay_error( ErrVal, Str ))),
        win_PostEvent(UserWin,e_Native(UserMes,S,0)),
        !.
  manage_hndl(S,e_Close(msglay_incoming)):-
        ftp_sock_cond(S,ftplay_win(UserWin,UserMes),_),
        retractall(ftp_sock_cond(S,_,_)),
        close_connections( S ),
        retractall(code_com(S,_)),
        retractall(ftp_created_dirs(S,_)),
        isAnyTimer( S ),
        retract(control_sock(S)),
        assert(ftplay_answer(S,close)),
        win_PostEvent(UserWin,e_Native(UserMes,S,0)),
        !.
  manage_hndl(S,e_Close(msglay_error( SCK_EVENT, SCK_ERROR ))):-
        ftp_sock_cond(S,ftplay_win(UserWin,UserMes),_),
        close_connections( S ),
        retractall(code_com(S,_)),
        format( StrDesc, "Network event %d contains error", SCK_EVENT ),
  	retractall(ftplay_LastErrorDB(_)),
	assert(ftplay_LastErrorDB( SCK_ERROR )),
        assert(ftplay_answer( S, ftplay_error( SCK_ERROR, StrDesc ))),
        win_PostEvent(UserWin,e_Native(UserMes,S,0)),
        !.
  manage_hndl(_,_):-
	fail.


  ftplayer_convert([],[]):-!.
  ftplayer_convert([Str|L],[Element|Result]):-
        searchchar(Str,'\n',FoundPos),
        frontstr(FoundPos,Str,Element,RestString),!,
        Result=ftplayer_convert([RestString|L]).
  ftplayer_convert([""|L],Result):-Result=ftplayer_convert(L).

  sock_manage(_,[]):-!.
  sock_manage(S,[STR|Lst]):-  
        filter(STR,"",STR1),
        write_debug(STR1),
	STR1 <> "",
	STR1 <> "\n",
        substring(STR1,1,4,Code),        
        sear_hyp(S,Code,STR1),!,
        sock_manage(S,Lst).
  sock_manage(S,[_|Lst]):-
  	sock_manage(S,Lst).      
  	
  filter("",Result,Result):-
        !.
  filter("\\n",Start,Result):-
	concat(Start,"\n",Result),
        !.
  filter(STR,Start,Result):-
        char_int(Char1,0xd),
        frontchar(STR,Char1,RestString),
        char_int(Char2,0xa),
        frontchar(RestString,Char2,Rest),
        concat(Start,"\n",Start1),!,
        filter(Rest,Start1,Result).
  filter(STR,Start,Result):-
        frontchar(STR,Char,Rest),
        str_char(StrCh,Char),
        concat(Start,StrCh,Start1),!,
        filter(Rest,Start1,Result).

  sear_hyp(S,Code,Str):-
        is_com(S,Code),
        concat(_,"-",Code),!,
        substring(Code,1,3,Cod),
        str_int(Cod,_),
        format(Str_sear,"\n% ",Cod),
        sear_code(S,Str,Str_sear,Cod),
        !.
  sear_hyp(S,Cod,Str_full):-
        str_int(Cod,Cod_int),
        retract(code_com(S,_)),
        code_handler(S,Cod_int,Str_full),
        !.
  sear_hyp(S,_,Str):-
        code_com(S,Code),!,
        substring(Code,1,3,Cod),
        format(Str_sear,"\n% ",Cod),
        sear_code(S,Str,Str_sear,Cod),
        !.

  sear_code(S,Str_full,Str_sear,Cod):-
        searchstring(Str_full,Str_sear,_),
        str_int(Cod,Cod_int),
        retract(code_com(S,_)),
        code_handler(S,Cod_int,Str_full),
        !.
  sear_code(_,_,_,_).

  is_com(S,Code):-
        retract(code_com(S,_)),
        assert(code_com(S,Code)),!.
  is_com(S,Code):-assert(code_com(S,Code)),!.
  
  write_debug(STR):-
  	debug_file(U_hndl),
  	U_hndl(STR),
	!.
  write_debug(_).
  
  is_ftp_connect_timer( User_hndl ):-
    	ftp_connect_timer( User_hndl, T_id,_ ),
        retractall(ftp_connect_timer( User_hndl, T_id, _ ) ),
  	trap(timer_Kill( T_id ),_, true),
  	!.
  is_ftp_connect_timer( _ ).
  	
%____________________________________________________________
%              DATA CONNECTION PREDICATES
%____________________________________________________________
PREDICATES

determ	   read_from_file(SOCKET,BINARY)
determ	   BINARY size_read(SOCKET,LONG)
procedure  is_unique_file(SOCKET)
determ	   is_eof(SOCKET)
procedure  write_data(SOCKET,BINARY)
procedure  check_incoming(SOCKET)
procedure  test_data_conn(SOCKET,BINARY)
procedure  check_listfile( ULONG, UNSIGNED, ULONG )	- (i,i,o)
procedure  check_listfile1( SOCKET, STRING, UNSIGNED )	- (i,i,i)
procedure  sendProgressNotification( SOCKET, BOOLEAN, STRING, UNSIGNED ) - (i,i,i,i)
procedure  test_recvconn_timer( SOCKET )		- (i)
determ	   test_end_IsData_Close( SOCKET )		- (i)

CLAUSES
 %___Sending
 
  send_hndl(Sx,_):-
  	ftp_accept_timer(Sc,Sx,T_id,_),
  	retractall(ftp_accept_timer(Sc,Sx,T_id,_)),
 	timer_Kill(T_id),
  	fail.
  send_hndl(Sd,e_Connect(Sd)):- % passive mode
        sock_acc(Sc,Sd,"1"),
        msglay_sethandler(Sd,common_hndl,[msglay_RcvBuf(32767),msglay_SndBuf(32767),msglay_SndNotify(b_true)]),
	assert(data_connect(Sc)),
	test_beg_send(Sc),
        !.
  send_hndl(Sa,e_Connect(Sd)):-
        sock_acc(Sc,Sa,"1"),
        retract(sock_acc(Sc,Sa,"1")),
        assert(sock_acc(Sc,Sd,"1")),
        myCloseSocket( Sa ),
        msglay_sethandler(Sd,common_hndl,[msglay_RcvBuf(32767),msglay_SndBuf(32767),msglay_SndNotify(b_true)]),
	assert(data_connect(Sc)),
	test_beg_send(Sc),
        !.
  send_hndl(Sd, e_Notify( Size )):-
  	sock_acc( Sc, Sd, "1" ),
  	ftp_sock_cond( Sc, _, stor(LocalFileName, _ )),
        sendProgressNotification( Sc, ftplay_ActionSend, LocalFileName, Size ),
  	ftp_timer( Sc, T_id, Rest ),
  	retract( ftp_timer( Sc, T_id, Rest ) ),!,
  	timer_Kill(T_id),
  	nettime( Net ),
        set_ftp_timer1( Sc, Net ),
        !.
  send_hndl(Sx,e_Error(Err)):-
        sock_acc(Sc,Sx,"1"),
        ftp_sock_cond(Sc,ftplay_win(UserWin,UserMes),_),
        closefile(f_read),
        retractall(sock_acc(Sc,Sx,"1")),
        retractall(unique_file(Sc,_)),
        data_clear_flags(Sc),
        myCloseSocket( Sx ),
	what_err_err(Err,Str),
        msglay_LastError( ErrVal ),
  	retractall(ftplay_LastErrorDB(_)),
	assert(ftplay_LastErrorDB( ErrVal )),        
        assert(ftplay_answer( Sc, ftplay_error( ErrVal, Str ))),
        win_PostEvent(UserWin,e_Native(UserMes,Sc,0)),!.
  send_hndl(Sd,e_Close(msglay_incoming)):-
        sock_acc(Sc,Sd,"1"),
        ftp_sock_cond(Sc,ftplay_win(UserWin,UserMes),_),
        closefile(f_read),
        retractall(sock_acc(Sc,Sd,"1")),
        retractall(unique_file(Sc,_)),
        data_clear_flags(Sc),
        assert(ftplay_answer(Sc,error_rep(0,"Data connection for sending closed by server\n"))),
        win_PostEvent(UserWin,e_Native(UserMes,Sc,0)),
        !.
  send_hndl(Sx,e_Close(msglay_error( SCK_EVENT, SCK_ERROR ))):-
        sock_acc(Sc,Sx,"1"),
        ftp_sock_cond(Sc,ftplay_win(UserWin,UserMes),_),
        retractall(sock_acc(Sc,Sx,"1")),
        closefile(f_read),
        retractall(unique_file(Sc,_)),
        data_clear_flags(Sc),
        myCloseSocket( Sx ),
        format( StrDesc, "Network event %d contains error", SCK_EVENT ),
  	retractall(ftplay_LastErrorDB(_)),
	assert(ftplay_LastErrorDB( SCK_ERROR )),
        assert(ftplay_answer( Sc, ftplay_error( SCK_ERROR, StrDesc ))),
        win_PostEvent(UserWin,e_Native(UserMes,Sc,0)),
        !.

 
  test_beg_send(Sc):-
   	data_connect(Sc), % e_connect comes
   	data_open(Sc),	  % 150 or 125 comes
   	ftp_sock_cond(Sc,_,stor(LocalFileName,_)),
   	sock_acc(Sc,Sd,"1"),
        trap(openread(f_read,LocalFileName),Err,connection_err( Sd, Err, ftpl_ftpl_err )),
        is_eof(Sd),
        closefile(f_read),
        test_end_send(Sc),
        !.
  test_beg_send(_).
  	
  test_end_send(Sc):-
  	data_connect(Sc),
  	data_open(Sc),
  	data_sent(Sc), %data_sent
  	test_end_IsData_Close(Sc), %226 comes
  	retract(sock_acc(Sc,_,"1")),
  	is_unique_file(Sc),
  	!.
  test_end_send(_).
  
  test_end_IsData_Close( Sc ):-
  	data_close(Sc),
  	!.
  test_end_IsData_Close( Sc ):-
  	nettime( Net ),
        set_ftp_timer1( Sc, Net ),
  	fail.
  
  is_unique_file(S):-
        unique_file(S,STR),
        retract(unique_file(S,STR)),!,
        data_clear_flags(S),
        answer(S,ok_str(STR)).
  is_unique_file(S):-
        not(unique_file(S,_)),!,
        data_clear_flags(S),
        answer(S,ok).
  is_unique_file(_).
        
  is_eof(Sd):-
        filemode(f_read,0),
        not(eof(f_read)),!,
        read_from_file(Sd,Block),
        trap(msglay_WriteBin(Sd,Block),_Err,true),!,
        is_eof(Sd).
  is_eof(Sd):-
        filemode(f_read,0),
        eof(f_read),!,
        sock_acc(Sc,Sd,"1"),
        closefile(f_read),
        isAnyTimer( Sd ),
        trap( msglay_CloseSoft( Sd ), E, connection_err( Sd, E, ftpl_msgl_err )),
        assert(data_sent(Sc)), %data sent
        !.
  is_eof(_).  	
  	     
  read_from_file(Sd,Block):-
        filemode(f_read,0),
        filepos(f_read,CurPos,1),
        filepos(f_read,0,2),
        filepos(f_read,Wh_len,1),
        Rest=Wh_len-CurPos,
        filepos(f_read,CurPos,0),!,
        Block = size_read(Sd,Rest).

  size_read(Sd,Size,Result):-
        Size >= 1024,
        readdevice(Old),
        readdevice(f_read),
        filemode(f_read,0),
        trap(readblock(1024,Result),Err,connection_err( Sd, Err, ftpl_ftpl_err )),
        readdevice(Old),
        !.
  size_read(Sd,Size,Result):-
        Size < 1024,
        Size_u = val( UNSIGNED, Size ),
        readdevice(Old),
        readdevice(f_read),
        filemode(f_read,0),
        trap(readblock(Size_u,Result),Err,connection_err( Sd, Err, ftpl_ftpl_err )),
        readdevice(Old),
        !.
        
  %___Receiving
  recv_hndl(Sx,_):-
  	ftp_accept_timer(Sc,Sx,T_id,_),
  	retractall(ftp_accept_timer(Sc,Sx,T_id,_)),
 	timer_Kill(T_id),
  	fail.
  recv_hndl(Sd,_):-
  	ftp_connection_timer(Sd,T_id,_),
  	retractall(ftp_connection_timer(Sd,T_id,_)),
  	timer_Kill(T_id),
  	fail.
  recv_hndl(Sd,e_Connect(Sd)):- % passive
        sock_acc(Sc,Sd,"2"),
        msglay_sethandler(Sd,common_hndl,[msglay_RcvBuf(32767),msglay_SndBuf(32767)]),
        assert(data_connect(Sc)),
        test_beg_recv(Sc),
        !.
  recv_hndl(Sa,e_Connect(Sd)):-
        sock_acc(Sc,Sa,"2"),
        retract(sock_acc(Sc,Sa,"2")),
        assert(sock_acc(Sc,Sd,"2")),
        msglay_sethandler(Sd,common_hndl,[msglay_RcvBuf(32767),msglay_SndBuf(32767)]),
        myCloseSocket( Sa ),
        assert(data_connect(Sc)),
        test_beg_recv(Sc),
        !.
  recv_hndl(Sd,e_ReadBin(B)):-
  	sock_acc(Sc,Sd,"2"),
  	test_data_conn(Sc,B),
  	!.
  recv_hndl(Sx,e_Error(Err)):-
        sock_acc(Sc,Sx,"2"),
        ftp_sock_cond(Sc,ftplay_win(UserWin,UserMes),_),
        retractall(sock_acc(Sc,Sx,"2")),
        closefile(f_write),
        data_clear_flags(Sc),
        myCloseSocket( Sx ),   
        what_err_err(Err,Str),
        msglay_LastError( ErrVal ),
  	retractall(ftplay_LastErrorDB(_)),
	assert(ftplay_LastErrorDB( ErrVal )),        
        assert(ftplay_answer( Sc, ftplay_error( ErrVal, Str ))),
        win_PostEvent(UserWin,e_Native(UserMes,Sc,0)),
        !.
  recv_hndl(Sd,e_Close(msglay_incoming)):-
  	sock_acc(Sc,Sd,"2"),
  	assert(data_recvd(Sc)),
%KI add begin 02.09.1998
  	nettime( Net ),
  	set_ftp_connection_timer( Sd, Net ),
%KI add end 02.09.1998  	
  	test_end_recv(Sc),
        !.
  recv_hndl(Sx,e_Close(msglay_error( SCK_EVENT, SCK_ERROR ))):-
        sock_acc(Sc,Sx,"2"),
        ftp_sock_cond(Sc,ftplay_win(UserWin,UserMes),_),
        retractall(sock_acc(Sc,Sx,"2")),
        closefile(f_write),
        data_clear_flags(Sc),
        myCloseSocket( Sx ),
        format( StrDesc, "Network event %d contains error", SCK_EVENT ),
  	retractall(ftplay_LastErrorDB(_)),
	assert(ftplay_LastErrorDB( SCK_ERROR )),        
        assert(ftplay_answer( Sc, ftplay_error( SCK_ERROR, StrDesc ))),
        win_PostEvent(UserWin,e_Native(UserMes,Sc,0)),
        !.
  recv_hndl(_,_):-
	fail.
  	
  
  test_beg_recv(Sc):-
  	data_connect(Sc),
  	data_open(Sc),
  	sock_acc(Sc,Sd,"2"),
        nettime(Net),
  	set_ftp_connection_timer( Sd, Net ),
        ftp_sock_cond(Sc,_,retr(LocalFileName,_)),
        is_md1(LocalFileName),
        trap(openwrite(f_write,LocalFileName),Err,connection_err( Sd, Err, ftpl_ftpl_err )),
        closefile(f_write),
        check_incoming(Sc),
        !.
  test_beg_recv(_).
        
  check_incoming(Sc):-
  	retract(data_incoming(Sc,Block)),
  		write_data(Sc,Block),
  	fail.
  check_incoming(_).
  
  write_data(Sc,Block):-
  	data_recvfile(Sc,LocalFileName,_),
  	sock_acc(Sc,Sd,"2"),
  	trap(openappend( f_write,LocalFileName),Err,connection_err( Sd, Err, ftpl_ftpl_err )),
        writedevice(Old),
        writedevice(f_write),
        trap(writeblock(0,Block),Err1,connection_err( Sd, Err1, ftpl_ftpl_err )),
        writedevice(Old),
        closefile(f_write),
	Size = getbinarysize(Block),
	retract(data_recvfile(Sc,LocalFileName,FileLength)),
	check_listfile( FileLength, Size, NewSize ),
	assert(data_recvfile(Sc,LocalFileName,NewSize)),
	check_listfile1( Sc, LocalFileName, Size ),
        !.
  write_data(_,_). % impossible ?

  check_listfile( 0, _, 0 ):-!.
  check_listfile( FileLength, Size, NewSize ):- NewSize = FileLength - Size,!.
  
  check_listfile1( _, "fls.tmp", _ ):-!.
  check_listfile1( Sc, LocalFileName, Size ):-
  	sendProgressNotification( Sc, ftplay_ActionReceive, LocalFileName, Size ).

  test_data_conn(Sc,Block):-
  	data_connect(Sc),
  	data_open(Sc),
  	sock_acc( Sc, Sd, "2" ),
  	nettime( Net ),
  	set_ftp_connection_timer( Sd, Net ),
  	check_incoming(Sc),  % maybe superfluous
  	write_data(Sc,Block),
  	test_end_recv(Sc),
  	!.
  test_data_conn(Sc,Block):-
  	assertz(data_incoming(Sc,Block)),!.
  	
  test_end_recv(Sc):-
  	data_connect(Sc),
  	data_open(Sc),
  	data_close(Sc), %226 comes
  	data_recvd(Sc),	%fd_close comes
  	data_recvfile(Sc,_,Length),
  	Length <= 0,
  	retract(sock_acc(Sc,Sd,"2")),!,
  	test_recvconn_timer( Sd ),
  	isAnyTimer( Sd ),
  	data_clear_flags(Sc),
        answer(Sc,ok),!.
  test_end_recv(_).
  
  test_recvconn_timer( Sd ):-
  	ftp_connection_timer( Sd, T_id, _ ),
  	retractall(ftp_connection_timer( Sd, T_id, _ )),
  	timer_Kill( T_id ),
  	!.
  test_recvconn_timer( _ ).
  
  data_clear_flags(Sc):-
        retractall(data_connect(Sc)),
        retractall(data_open(Sc)),
        retractall(data_sent(Sc)),
        retractall(data_close(Sc)),
        retractall(data_recvd(Sc)),
        retractall(data_recvfile(Sc,_,_)),
        retractall(data_incoming(Sc,_)),
        !.

  sendProgressNotification( Sc, Type, FileName, Size ):-
  	ftp_sock_cond( Sc, User_hndl, _),
  	User_hndl = ftplay_win( UserWin, UserMes ),
  	assert(ftplay_answer( Sc, progress( Type, FileName, Size ))),
  	win_PostEvent( UserWin,e_Native( UserMes, Sc, 0)),!.
  sendProgressNotification( _, _, _, _ ).

%____________________________________________________________
%                   PORT predicates
%____________________________________________________________
CLAUSES
  make_port(Addr,Data_port,Whole_port):-
  	bound(Addr),
  	bound(Data_port),
  	free(Whole_port),
        bitright(Data_port,8,High),
        bitleft(High,8,Z),
        bitxor(Data_port,Z,Low),
        format(Whole_dot_port,"%s.%d.%d",Addr,High,Low),
        Whole_port = sc(Whole_dot_port,"",'.',','),
        !.
      
  make_port(Addr,Data_port,Whole_port):-
  	free(Addr),
  	free(Data_port),
  	bound(Whole_port),
  	HostPort = sc(Whole_port,"",',','.'),
	searchchar(HostPort,'.',FP1),
	frontstr(FP1,HostPort,H1,R1),
	searchchar(R1,'.',FP2),
	frontstr(FP2,R1,H2,R2),
	searchchar(R2,'.',FP3),
	frontstr(FP3,R2,H3,R3),
	searchchar(R3,'.',FP4_1),
	FP4 = FP4_1 - 1,
	frontstr(FP4,R3,H4,Port_1),
	frontchar(Port_1,_,Port),
  	format(Addr,"%s%s%s%s",H1,H2,H3,H4),
  	searchchar(Port,'.',FP11),
  	FP12 = FP11 - 1,
	frontstr(FP12,Port,P1_str,P2_1),
	frontchar(P2_1,_,P2_str),
	str_int(P1_str,P1),
	str_int(P2_str,P2),
	bitleft(P1,8,Z),
	bitxor(Z,P2,Data_port),
	!.

  sc(Str_dot,Beg,Symb1,Symb2,Result):-
        str_len(Str_dot,L),
        searchchar(Str_dot,Symb1,FoundPos),
        FP=FoundPos+1,
        FP1=FoundPos-1,
        NB=L-FoundPos,
        substring(Str_dot,FP,NB,Rest),
        substring(Str_dot,1,FP1,New),
        format(Res,"%s%s%c",Beg,New,Symb2),!,
        Result=sc(Rest,Res,Symb1,Symb2).
  sc(New,Beg,_,_,Result):-
        format(Result,"%s%s",Beg,New),!.

  new_port(Step,Result):-
        retract(busy_port(P)),
        Result = port_increment( P, Step ),
        assert(busy_port(Result)),
        !.

  was_busy_port(_):-
        retract(busy_port(P)),
        P1 = port_increment( P, 1 ),
% temprorary
        P1_us = val( USHORT, P1 ),
        assert(busy_port(P1_us)),!.
  was_busy_port(Port):-
        assert(busy_port(Port)),!.
        
  port_increment( Old, Value, New ):-
  	New = Old + Value,
  	New < 65535,
  	!.
  port_increment( _, _, 1025 ).
%____________________________________________________
%          Directory creating predicates
%____________________________________________________

  is_md1(FullLoc_file):-
        filenamepath(FullLoc_file,Path,_),
        is_md_int( Path, 0 ),
        !.
  is_md1(_).

  is_md_int(Path,Pos):-
	frontstr(Pos,Path,_,Pth),
	searchstring(Pth,"\\",FoundPos),
	FP = FoundPos - 1 + Pos,
	frontstr(FP,Path,PathN,_),
        md(PathN),
        P = FP + 2,!,
        is_md_int(Path,P).
  is_md_int(Path,_):-		% because incoming path to is_md1 does't contain a slash at the end so last dir will not be created
  	md(Path).
  
  md(Path):-trap(mkdir(Path),_,true),!.
  md(_).

  is_mkd(S,_,"","stor"):-
        retract(mkd_dir(S,LocalFileName,FullRemoteName,_,_,_)),!,
        ftplay_StorCommand(S,LocalFileName,FullRemoteName).
  is_mkd(S,_,"","appe"):-
        retract(mkd_dir(S,LocalFileName,FullRemoteName,_,_,_)),!,
        ftplay_AppeCommand(S,LocalFileName,FullRemoteName).
  is_mkd(S,Path,Rest,_):-
        not(Rest = ""),
        retract(mkd_dir(S,LocalFileName,FullRemoteName,_,_,Kind)),
        assert(mkd_dir(S,LocalFileName,FullRemoteName,Path,Rest,Kind)),
        ftplay_MkdCommand(S,Path),
        !.
  is_mkd(_,_,_,_).

  sear_slash(Input,First,Last):-
        searchchar(Input,'/',FoundPos),
        FoundPos=1,
        frontchar(Input,'/',Rest),!,
        sear_slash(Rest,First,Last).
  sear_slash(Input,First,Last):-
        searchchar(Input,'/',FoundPos),
        FoundPos<>1,
        NB=FoundPos-1,
        frontstr(NB,Input,Fir,Last),
        frontchar(First,'/',Fir),!.
  sear_slash(FileName,FileName,"").

  check_RemDir( S, L, R, C, D, Kind ):-
  	sear_slash( D, First, Last ),
  	concat( C, First, PrevAll ),
  	ftp_created_dirs( S, PrevAll ),!,
  	check_RemDir( S, L, R, PrevAll, Last, Kind ).
  check_RemDir( S, L, R, C, D, Kind ):-
  	retractall(mkd_dir(S,_,_,_,_,_)),
	sear_slash( D, First, Last ),
	concat( C, First, PrevAll ),
	assert(mkd_dir(S, L, R, PrevAll, Last, Kind )),
  	is_mkd( S, PrevAll, Last, Kind ),!.

%_________Miscellaneous_____________________________

PREDICATES
 determ what_mode(BOOLEAN,SOCKET,INTEGER) - (i,i,i)
CLAUSES

  what_mode(b_false,S,1):-
	new_port(1,Port_local),
        ftplay_SetDataSocketSend(S,Port_local),
        ftplay_PortCommand(S,Port_local),!.
  what_mode(b_false,S,2):-
	new_port(1,Port_local),
        ftplay_SetDataSocketRecv(S,Port_local),
        ftplay_PortCommand(S,Port_local),!.        
  what_mode(b_true,S,_):-
  	ftplay_PasvCommand(S),!.

%____________________________________________________
%        Error predicates
%____________________________________________________

  what_err_err(msglay_errEvConnect,	"Not able to connect to a target server"):-!.
  what_err_err(msglay_errEvAccept,	"Not able to accept a connection from a server"):-!.
  what_err_err(msglay_errEvRead,	"Not able to read data"):-!.
  what_err_err(msglay_errEvWrite,	"Not able to send data"):-!.
  what_err_err(msglay_errEvReadPacked,	"Not able to read packed data"):-!.
  what_err_err(msglay_errEventConnect( _Err ),"Not able to connect to a target server (fd_connect error)"):-!.
  what_err_err(Err,Str):-term_str(msglay_error_kind,Err,Str).

  what_err(msglay_errClose,	"Unable to close socket"):-!.
  what_err(msglay_errListen,	"Unable to set to Listen mode"):-!.
  what_err(msglay_errWrite,	"Unable to send information"):-!.
  what_err(msglay_errHost,	"Unable to resolve host name"):-!.
  what_err(msglay_errCreate,	"Unable to create socket"):-!.
  what_err(msglay_errConnect,	"Unable to connect to server"):-!.
  what_err(msglay_errInternal,	"There is an internal error in Message Layer"):-!.
  what_err(msglay_errSetOption,	"Unable to set option"):-!.
  what_err(net_timeout_err,	"Network timeout"):-!.
  what_err(Err,Str):-format(Str,"%U",Err),!.

  connection_err( Sd, Err, ftpl_ftpl_err ):-
  	connection_err(Sd, Err ),!.
  connection_err( Sd, _, ftpl_msgl_err ):-
  	msglay_LastError( Err ),
  	connection_err( Sd, Err ),!.
  
  connection_err(Sd, _ ):-
	myCloseSocket( Sd ),
	fail.
  connection_err(Sd, Err ):-
  	sock_acc( Sc, Sd, _ ),
  	close_connections( Sc ),
  	ftp_sock_cond(Sc,User_hndl,_),
        all_err(Sc,User_hndl,Err),
        !.
  connection_err( _, _ ).			% it should not to be called

  controlconn_err( S, Err, ftpl_ftpl_err ):-
  	ftp_sock_cond(S,User_hndl,_),
        all_err(S,User_hndl,Err),
        !.
  controlconn_err( S, _, ftpl_msgl_err ):-
 	msglay_LastError( Err ),
  	ftp_sock_cond( S, User_hndl, _ ),
        all_err( S, User_hndl, Err ),
        !.

  all_err(S,ftplay_win(UserWin,UserMes),Err):-
        what_err(Err,Text),
        retractall(ftplay_LastErrorDB(_)),
        assert(ftplay_LastErrorDB( Err )),
        assert(ftplay_answer(S,ftplay_error(Err,Text))),
        win_PostEvent(UserWin,e_Native(UserMes,S,0)),
        !.

  ini_err(ftplay_win(UserWin,UserMes),Err):-
        what_err(Err,Text),
        trap( S = sck_socket(af_inet,sock_Stream,ipproto_tcp), _, true ),!,
        retractall(ftplay_LastErrorDB(_)),
        assert(ftplay_LastErrorDB(Err)),
        assert(ftplay_answer(S,ftplay_error(Err,Text))),
        win_PostEvent(UserWin,e_Native(UserMes,S,0)),
        exit.
  ini_err(ftplay_win(UserWin,UserMes),Err):-
  	what_err(Err,Text),
  	NullSocket = cast( SOCKET, 0 ),
        retractall(ftplay_LastErrorDB(_)),
        assert(ftplay_LastErrorDB(Err)),
        assert(ftplay_answer(NullSocket,ftplay_error(Err,Text))),
        win_PostEvent(UserWin,e_Native(UserMes,NullSocket,0)),
        exit.

  ini_err2( S, Error ):-
        ftp_window(FTPwin),
        assert(msglay_answer(S,e_Error(msglay_errEventConnect( Error )))),
        win_PostEvent(FTPwin,e_Native(ftp_socket,S,0)),
	!.
	
%____________________________________________________
%                Write a string to a socket
%____________________________________________________
  ftp_write_str(S,StrUnix,StrP):-
	str_dosstr(StrUnix,Str),	
  	str_len(Str,L),
        Str_bin=composebinary(Str,L),
        trap(msglay_WriteBin(S,Str_bin),Err,controlconn_err( S, Err, ftpl_msgl_err )),
        write_debug(StrP),
        nettime(Net),
        set_ftp_timer1(S,Net),
        !.
  ftp_write_str(_,_,_).
  
  close_connections( Sc ):-
  	retract(sock_acc(Sc,Sd,_)),
  		myCloseSocket( Sd ),
  	fail.
  close_connections( Sc ):-
  	data_clear_flags(Sc),
  	retractall(unique_file(Sc,_)),
  	closefile( f_read ),
  	closefile( f_write ).
  
  check_OtherConnection():-
  	control_sock( Sc ),
  		ftplay_Close( Sc ),
  	fail.
  check_OtherConnection().
  	
%_____________________________________________________
%     GLOBAL PREDICATES
%_____________________________________________________
  ftplay_MiscOptions(_,_):-
	ftplayer_init(),fail.
  ftplay_MiscOptions(Hndl,Net):-
	NULL_ptr = cast( FTPLAY_DEBUG_HNDL, 0 ),
	NULL_ptr = Hndl,!,
	retractall(nettime(_)),
  	assert(nettime(Net)).
  ftplay_MiscOptions(Hndl,Net):-
	NULL_ptr = cast( FTPLAY_DEBUG_HNDL, 0 ),
	NULL_ptr <> Hndl,!,
  	retractall(debug_file(_)),
  	retractall(nettime(_)),
  	assert(nettime(Net)),
  	assert(debug_file(Hndl)).
  ftplay_MiscOptions(_,_).		%dummy
  
  ftplay_SetConnection(HostName,PortNo,Win,Mes):-
        ftplayer_init(),
        check_OtherConnection(),
        closefile(f_write), % only connection per time :(
        closefile(f_read),
        A = ftplay_win(Win,Mes),
	upper_lower(HostName,HostName_l),
        trap(S = msglay_connect(HostName_l,PortNo,common_hndl,[]),E,ini_err(A,E)),
        nettime(Net),
	set_ftp_timer0(ftplay_win(Win,Mes),Net),
        assert(for_connect(S,ftplay_win(Win,Mes),PortNo,HostName_l)),
        !.
  ftplay_SetConnection(_,_,_,_).
        
  ftplay_GetAnswer(S,Result):-retract(ftplay_answer(S,Result)),!.
  
  ftplay_Close(S):-
        ftp_sock_cond(S,_,_),!,
        close_connections(S),
        myCloseSocket( S ),
        retractall(msglay_answer(S,_)),
        retractall(ftplay_answer(S,_)),
        retractall(ftp_sock_cond(S,_,_)),
        retractall(ftp_created_dirs(S,_)),
        retractall(control_sock(S)),
        !.
  ftplay_Close(S):-
        not(ftp_sock_cond(S,_,_)),!,
        myCloseSocket( S ),
        retractall(msglay_answer(S,_)),
        retractall(ftplay_answer(S,_)),!.
  ftplay_Close(_).

  ftplay_LastError( Err, "" ):-
  	ftplay_LastErrorDB( Err ),!.
  ftplay_LastError( 0, "There is no errors" ).

  ftplay_CloseAll():-
  	retract( control_sock( Sc ) ),
	close_connections( Sc ),
        myCloseSocket( Sc ),
        msglay_CloseAll(),
        retractall(ftp_created_dirs(_,_)),
        retractall(code_com(_,_)),
        retractall(ftp_sock_cond(_,_,_)),
        !.
  ftplay_CloseAll():-
  	retractall(control_sock(_)),
        msglay_CloseAll(),
        retractall(code_com(_,_)),
        retractall(ftp_sock_cond(_,_,_)),
        retractall(sock_acc(_,_,_)),
        retractall(unique_file(_,_)),
        retractall(ftp_created_dirs(_,_)),
        !.
        
  ftplay_Bye():-
  	ftplay_CloseAll(),
	retractall(for_connect(_,_,_,_)),
        ftp_window(FTPwin),
        win_Destroy(FTPwin),
        retractall(ftp_window(_)),
        retractall(ftplay_LastErrorDB(_)),
        retractall(debug_file(_)),
        retractall(nettime(_)),
        !.
  ftplay_Bye().

  ftplay_SetDataSocketSend(S,LocalPort):-
  	trap(Sa = msglay_listen(LocalPort,common_hndl),Err,controlconn_err( S, Err, ftpl_msgl_err )),
  	close_connections( S ),
        assert(sock_acc(S,Sa,"1")),
  	!.
  ftplay_SetDataSocketSend(_,_).
  ftplay_SetDataSocketRecv(S,LocalPort):-
  	trap(Sa = msglay_listen(LocalPort,common_hndl),Err,controlconn_err( S, Err, ftpl_msgl_err )),
  	close_connections( S ),
        assert(sock_acc(S,Sa,"2")),
  	!.
  ftplay_SetDataSocketRecv(_,_).
  ftplay_SetDataSocketSendPasv(S,Host,LocalPort):-
  	trap(Sd=msglay_connect(Host,LocalPort,common_hndl,[msglay_SndBuf(32767)]),Err,controlconn_err( S, Err, ftpl_msgl_err )),
  	close_connections( S ),
        assert(sock_acc(S,Sd,"1")),
  	!.
  ftplay_SetDataSocketSendPasv(_,_,_).
  ftplay_SetDataSocketRecvPasv(S,Host,LocalPort):-
  	trap(Sd=msglay_connect(Host,LocalPort,common_hndl,[msglay_RcvBuf(32767)]),Err,controlconn_err( S, Err, ftpl_msgl_err )),
  	close_connections( S ),
        assert(sock_acc(S,Sd,"2")),
  	!.
  ftplay_SetDataSocketRecvPasv(_,_,_).
  	
  ftplay_UserCommand(S,UserId):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"USER %s\n",UserId),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,user)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_UserCommand(_,_).
  ftplay_PassCommand(S,UserPwd):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"PASS %s\n",UserPwd),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,pass)),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_PassCommand(_,_).
  ftplay_AcctCommand(S,UserAcct):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"ACCT %s\n",UserAcct),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,acct)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_AcctCommand(_,_).
  ftplay_CdupCommand(S):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"CDUP\n"),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,cdup)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_CdupCommand(_).
  ftplay_CwdCommand(S,Path):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"CWD %s\n",Path),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,cwd)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_CwdCommand(_,_).
  ftplay_SmntCommand(S,Path):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"SMNT %s\n",Path),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,smnt)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_SmntCommand(_,_).
  ftplay_QuitCommand(S):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"QUIT\n"),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,quit)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_QuitCommand(_).
  ftplay_ReinCommand(S):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"REIN\n"),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,rein)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_ReinCommand(_).
  ftplay_TypeCommand(S,Type_code):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"TYPE %s\n",Type_code),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,type)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_TypeCommand(_,_).
  ftplay_PortCommand(S,Port_local):-
        ftp_sock_cond(S,User_hndl,_),
        trap( Addr = sck_GetSockName(S), Err1, controlconn_err( S, Err1, ftpl_msgl_err ) ),
        sck_SplitAddress_IN(Addr,_,_,Host_l),
        trap( Addr_local = sck_InetNtoa(Host_l), Err2, controlconn_err( S, Err2, ftpl_msgl_err ) ),
        make_port(Addr_local,Port_local,Whole_comma_port),
        format(Str,"PORT %s\n",Whole_comma_port),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,port)),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_PortCommand(_,_).
  ftplay_ModeCommand(S,Mode_code):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"MODE %c\n",Mode_code),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,mode)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_ModeCommand(_,_).
  ftplay_StruCommand(S,Stru_code):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"STRU %c\n",Stru_code),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,stru)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_StruCommand(_,_).
  ftplay_PasvCommand(S):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"PASV\n"),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,pasv)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_PasvCommand(_).
  ftplay_StorCommand(S,LocalFileName,RemoteFile_name):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),!,
        assert(ftp_sock_cond(S,User_hndl,stor(LocalFileName,""))),
        format(Str,"STOR %s\n",RemoteFile_name),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_StorCommand(_,_,_).
  ftplay_AppeCommand(S,LocalFileName,RemoteFile_name):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,stor(LocalFileName,""))),
        format(Str,"APPE %s\n",RemoteFile_name),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_AppeCommand(_,_,_).
  ftplay_RetrCommand(S,LocalFileName,RemoteFile_name,FileLength):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,retr(LocalFileName,RemoteFile_name))),
        retractall(data_recvfile(S,_,_)),
        assert(data_recvfile(S,LocalFileName,FileLength)),
        format(Str,"RETR %s\n",RemoteFile_name),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_RetrCommand(_,_,_,_).
  ftplay_StouCommand(S,LocalFileName):-
  	ftp_sock_cond(S,User_hndl,_),
  	retract(ftp_sock_cond(S,_,_)),!,
        assert(ftp_sock_cond(S,User_hndl,stor(LocalFileName,"*stou"))),
        format(Str,"STOU\n"),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_StouCommand(_,_).
  ftplay_RnfrCommand(S,From_str):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,rnfr)),
        format(Str,"RNFR %s\n",From_str),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_RnfrCommand(_,_).
  ftplay_RntoCommand(S,To_str):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,rnto)),
        format(Str,"RNTO %s\n",To_str),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_RntoCommand(_,_).
  ftplay_DeleCommand(S,FileName):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,dele)),
        format(Str,"DELE %s\n",FileName),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_DeleCommand(_,_).
  ftplay_ListCommand(S,ListFileNameTmp,List_str):-
        ftp_sock_cond(S,User_hndl,_),
        retractall(data_recvfile(S,_,_)),
        assert(data_recvfile(S,ListFileNameTmp,0)),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,retr(ListFileNameTmp,""))),
        format(Str,"LIST %s\n",List_str),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_ListCommand(_,_,_).
  ftplay_NlstCommand(S,ListFileNameTmp,NList_str):-
        ftp_sock_cond(S,User_hndl,_),
        retractall(data_recvfile(S,_,_)),
        assert(data_recvfile(S,ListFileNameTmp,0)),        
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,retr(ListFileNameTmp,""))),
        format(Str,"NLST %s\n",NList_str),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_NlstCommand(_,_,_).
  ftplay_RestCommand(S,Rest_str):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,rest)),
        format(Str,"REST %s\n",Rest_str),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_RestCommand(_,_).
  ftplay_AlloCommand(S,Allo_int):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,allo)),
        format(Str,"ALLO %d\n",Allo_int),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_AlloCommand(_,_).
  ftplay_AlloCommand(S,Allo_int,Allo_int1):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,allo)),
        format(Str,"ALLO %d R %d\n",Allo_int,Allo_int1),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_AlloCommand(_,_,_).
  ftplay_AborCommand(S):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"ABOR\n"),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,abor)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_AborCommand(_).
  ftplay_RmdCommand(S,Path):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,rmd)),
        format(Str,"RMD %s\n",Path),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_RmdCommand(_,_).        
  ftplay_MkdCommand(S,Path):-
        ftp_sock_cond(S,User_hndl,_),
        assert( ftp_created_dirs( S, Path ) ),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,mkd)),
        format(Str,"MKD %s\n",Path),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_MkdCommand(_,_).
  ftplay_PwdCommand(S):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"PWD\n"),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,pwd)),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_PwdCommand(_).
  ftplay_SystCommand(S):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"SYST\n"),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,syst)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_SystCommand(_).
  ftplay_StatCommand(S):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"STAT\n"),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,stat)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_StatCommand(_).
  ftplay_StatCommand(S,Stat_str):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"STAT %s\n",Stat_str),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,stat)),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_StatCommand(_,_).
  ftplay_HelpCommand(S):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"HELP\n"),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,help)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_HelpCommand(_).
  ftplay_HelpCommand(S,Help_str):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"HELP %s\n",Help_str),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,help)),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_HelpCommand(_,_).
  ftplay_NoopCommand(S):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"NOOP\n"),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,noop)),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_NoopCommand(_).
  ftplay_SiteCommand(S,Str_site):-
        ftp_sock_cond(S,User_hndl,_),
        format(Str,"SITE %s\n",Str_site),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,site)),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_SiteCommand(_,_).
  
  ftplay_Login(S,UserId,UserPwd,UserAcct):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,login(UserPwd,UserAcct))),
        format(Str,"USER %s\n",UserId),
        ftp_write_str(S,Str,Str),        
        !.
  ftplay_Login(_,_,_,_).
  ftplay_Logout(S):-
        ftp_sock_cond(S,_,_),
        ftplay_QuitCommand(S),
        !.
  ftplay_Logout(_).
  ftplay_SendFile(S,LocalFileName,RemoteFile_name,ConnMode):-
        ftp_sock_cond(S,User_hndl,_),
        what_mode(ConnMode,S,1),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,prep_file_trans(stor(LocalFileName,RemoteFile_name)))),
        !.
  ftplay_SendFile(_,_,_,_).
  ftplay_RecvFile(S,LocalFileName,RemoteFile_name,FileLength,ConnMode):-
        ftp_sock_cond(S,User_hndl,_),
	what_mode(ConnMode,S,2),        
        retractall(data_recvfile(S,_,_)),
      	assert(data_recvfile(S,LocalFileName,FileLength)),        
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,prep_file_trans(retr(LocalFileName,RemoteFile_name)))),
        !.
  ftplay_RecvFile(_,_,_,_,_).
  ftplay_ListFile(S,ListFileName,RemoteName,ConnMode):-
        ftp_sock_cond(S,User_hndl,_),
	what_mode(ConnMode,S,2),
        retract(ftp_sock_cond(S,User_hndl,_)),
        assert(ftp_sock_cond(S,User_hndl,prep_file_trans(listfile(ListFileName,RemoteName)))),
        !.
  ftplay_ListFile(_,_,_,_).
  ftplay_SendUnFile(S,LocalFileName,ConnMode):-
        ftp_sock_cond(S,User_hndl,_),
	what_mode(ConnMode,S,1),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,prep_file_trans(stor(LocalFileName,"*stou")))),
        !.
  ftplay_SendUnFile(_,_,_).
  ftplay_AppendFile(S,LocalFileName,RemoteFileName,ConnMode):-
        ftp_sock_cond(S,User_hndl,_),
	what_mode(ConnMode,S,1),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,prep_file_trans(appendfile(LocalFileName,RemoteFileName)))),
        !.
  ftplay_AppendFile(_,_,_,_).
  ftplay_RenameFile(S,FileNameOld,FileNameNew):-
        ftp_sock_cond(S,User_hndl,_),
        retract(ftp_sock_cond(S,_,_)),
        assert(ftp_sock_cond(S,User_hndl,renamefile(FileNameNew))),
        format(Str,"RNFR %s\n",FileNameOld),
        ftp_write_str(S,Str,Str),
        !.
  ftplay_RenameFile(_,_,_).