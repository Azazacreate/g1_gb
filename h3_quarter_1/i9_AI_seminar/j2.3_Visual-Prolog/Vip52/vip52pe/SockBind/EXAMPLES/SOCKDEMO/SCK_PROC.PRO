/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  SCK_PROC
 FileName: SCK_PROC.PRO
 Purpose: No description
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/
PREDICATES
  test_case(WINDOW,INTEGER) - (i,i)
  err_proc(STRING,UNSIGNED) - (i,i)
  
IFDEF ws_win  
  app_hook : SCK_BLOCKFUNC
  
ELSEDEF
  app_notifyFNS : SCK_NOTIFY_FNS
  
ENDDEF

CLAUSES

IFDEF os_os2
  app_notifyFNS(Win,Mes,Socket,Params):-
  	write("app_notifyFNS Event!!!: Window: ",Win," Message: ",Mes," Socket: ",Socket," Error+Event: ",Params),nl.
  	
ELSEDEF

  app_hook(0):-
  	write("app_hook is called\n"),
  	vpi_ProcessEvents().
ENDDEF

  err_proc(Str_pred,Err):-
  	L_err = sck_GetLastError(),
IFDEF os_os2  	
  	L_Dberr = sck_GetLastNetDbError(),
  	format(S,"Predicate %s exits with an error %U, last error %U, last Db error %U",Str_pred,Err,L_err,L_Dberr),
ELSEDEF
  	format(S,"Predicate %s exits with an error %U, last error %U",Str_pred,Err,L_err),
ENDDEF
  	dlg_note(Str_pred,S),!.

%______________________Address routines_______________________
  test_case(Win,id_sck_splitaddress_in4):- 
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
  	Addr_str=win_GetText(CtrlWin1),
  	term_str(SCK_ADDRESS,Addr,Addr_str),
  	trap(sck_SplitAddress_IN(Addr,Sin_Family,Sin_Port,Sin_Addr),E,err_proc("sck_SplitAddress/4",E)),
	term_str(SCK_FAMILY,Sin_Family,Sin_Family_str),
	term_str(SCK_PORT,Sin_Port,Sin_Port_str),
	term_str(SCK_IN_ADDR,Sin_Addr,Sin_Addr_str),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	win_SetText(CtrlWin2,Sin_Family_str),
	win_SetText(CtrlWin3,Sin_Port_str),
	win_SetText(CtrlWin4,Sin_Addr_str),
  	!.
  test_case(Win,id_sck_mergeaddress_in3):- 
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	Sin_Family_str=win_GetText(CtrlWin1),
	Sin_Port_str=win_GetText(CtrlWin2),
	Sin_Addr_str=win_GetText(CtrlWin3),
	term_str(SCK_FAMILY,Sin_Family,Sin_Family_str),
	term_str(SCK_PORT,Sin_Port,Sin_Port_str),
	term_str(SCK_IN_ADDR,Sin_Addr,Sin_Addr_str),
	trap(Addr = sck_mergeaddress_in(Sin_Family,Sin_Port,Sin_Addr),E,err_proc("sck_MergeAddress_in/3",E)),
  	term_str(SCK_ADDRESS,Addr,Addr_str),
  	win_SetText(CtrlWin4,Addr_str),
	!.
  test_case(Win,id_sck_mergeaddress2):- 
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	Sa_Family_str = win_GetText(CtrlWin1),
	Sa_Data_str = win_GetText(CtrlWin2),
	term_str(SCK_FAMILY,Sa_Family,Sa_Family_str),
	term_str(BINARY,Sa_Data,Sa_Data_str),
	trap(Addr = sck_mergeaddress(Sa_Family,Sa_Data),E,err_proc("sck_MergeAddress/2",E)),
  	term_str(SCK_ADDRESS,Addr,Addr_str),
  	win_SetText(CtrlWin3,Addr_str),
  	!.
  test_case(Win,id_sck_splitaddress3):- 
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
  	Addr_str=win_GetText(CtrlWin1),
  	term_str(SCK_ADDRESS,Addr,Addr_str),
  	trap(sck_SplitAddress(Addr,Sa_Family,Sa_Data),E,err_proc("sck_SplitAddress/3",E)),
	term_str(SCK_FAMILY,Sa_Family,Sa_Family_str),
	term_str(BINARY,Sa_Data,Sa_Data_str),
  	win_SetText(CtrlWin2,Sa_Family_str),
  	win_SetText(CtrlWin3,Sa_Data_str),
  	!.
  	
%______________________Sockets routines____________________________
  test_case(Win,id_sck_accept1):- 
	CtrlWin = win_GetCtlHandle(Win,control1),
	CtrlWin_res = win_GetCtlHandle(Win,control2),
	Sock_str=win_GetText(CtrlWin),
	term_str(SOCKET,Sock,Sock_str),
	trap(S_res = sck_accept(Sock),E,err_proc("sck_accept/1",E)),
	term_str(SOCKET,S_res,S_res_str),
	win_SetText(CtrlWin_res,S_res_str),
  	!.
  test_case(Win,id_sck_accept2):- 
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin_res1 = win_GetCtlHandle(Win,control2),
	CtrlWin_res2 = win_GetCtlHandle(Win,control3),
	Sock_str=win_GetText(CtrlWin1),
	term_str(SOCKET,Sock,Sock_str),
	trap(S_res = sck_accept(Sock,Addr),E,err_proc("sck_accept/2",E)),
	term_str(SOCKET,S_res,S_res_str),
	term_str(SCK_ADDRESS,Addr,Addr_str),
	win_SetText(CtrlWin_res1,S_res_str),
	win_SetText(CtrlWin_res2,Addr_str),
  	!.
  test_case(Win,id_sck_bind2):- 
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Sock_str = win_GetText(CtrlWin1),
	Addr_str = win_GetText(CtrlWin2),
	term_str(SOCKET,S,Sock_str),
	term_str(SCK_ADDRESS,Addr,Addr_str),
	trap(sck_Bind(S,Addr),E,err_proc("sck_bind/2",E)),
	!.
  test_case(Win,id_sck_closesocket1):- %ok
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
  	Sock_str = win_GetText(CtrlWin1),
  	term_str(SOCKET,S,Sock_str),
  	trap(sck_closesocket(S),E,err_proc("sck_CloseSocket/1",E)),
  	!.	
  test_case(Win,id_sck_connect2):- %ok
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Sock_str = win_GetText(CtrlWin1),
	Addr_str = win_GetText(CtrlWin2),
	term_str(SOCKET,S,Sock_str),
	term_str(SCK_ADDRESS,Addr,Addr_str),
	trap(sck_connect(S,Addr),E,err_proc("sck_Connect/2",E)),
  	!.
  test_case(Win,id_sck_getpeername1):- %ok
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Sock_str = win_GetText(CtrlWin1),
	term_str(SOCKET,S,Sock_str),
	trap(Addr = sck_GetPeerName(S),E,err_proc("sck_GetPeerName/1",E)),
	term_str(SCK_ADDRESS,Addr,Addr_str),
	win_SetText(CtrlWin2,Addr_str),
  	!.
  test_case(Win,id_sck_getsockname1):- %ok
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Sock_str = win_GetText(CtrlWin1),
	term_str(SOCKET,S,Sock_str),
	trap(Addr = sck_GetSockName(S),E,err_proc("sck_GetSockName/1",E)),
	term_str(SCK_ADDRESS,Addr,Addr_str),
	win_SetText(CtrlWin2,Addr_str),
  	!.
  test_case(Win,id_sck_getsockopt3):- %ok
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	Sock_str = win_GetText(CtrlWin1),
	Opt_lvl_str = win_GetText(CtrlWin2),
	Opt_name_str = win_GetText(CtrlWin3),
	term_str(SOCKET,S,Sock_str),
IFDEF platform_32bit
	term_str(SCK_OPTION_LEVEL,Opt_lvl,Opt_lvl_str),
	term_str(SCK_OPTION_NAME,Opt_name,Opt_name_str),
ELSEDEF
	term_str(UNSIGNED,Opt_lvl,Opt_lvl_str),
	term_str(UNSIGNED,Opt_name,Opt_name_str),
ENDDEF	
	trap(Opt = sck_GetSockOpt(S,Opt_lvl,Opt_name),E,err_proc("sck_GetSockOpt/3",E)),
	term_str(SCK_OPTION,Opt,Opt_str),
	win_SetText(CtrlWin4,Opt_str),
  	!.
  test_case(Win,id_sck_ioctlget2):- %ok
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	Sock_str = win_GetText(CtrlWin1),
	Com_str = win_GetText(CtrlWin2),
	term_str(SOCKET,S,Sock_str),
	term_str(SCK_IOCTL_COMMAND,Com,Com_str),
	trap(Res = sck_IoCtlGet(S,Com),E,err_proc("sck_IoCtlGet/2",E)),
	term_str(ULONG,Res,Res_str),
	win_SetText(CtrlWin3,Res_str),
  	!.
  test_case(Win,id_sck_ioctlset3):- %ok
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	Sock_str = win_GetText(CtrlWin1),
	Com_str = win_GetText(CtrlWin2),
	Arg_str = win_GetText(CtrlWin3),
	term_str(SOCKET,S,Sock_str),
	term_str(ULONG,Com,Com_str),
%	term_str(SCK_IOCTL_COMMAND,Com,Com_str), % can't be converted - too large - Win32
	term_str(ULONG,Arg,Arg_str),
	trap(sck_IoCtlSet(S,Com,Arg),E,err_proc("sck_IoCtlSet/3",E)),
  	!.
  test_case(Win,id_sck_listen2):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Sock_str = win_GetText(CtrlWin1),
	BackLog_str = win_GetText(CtrlWin2),
	term_str(SOCKET,S,Sock_str),
	term_str(INTEGER,BackLog,BackLog_str),
	trap(sck_Listen(S,BackLog),E,err_proc("sck_Listen/2",E)),
  	!.
  test_case(Win,id_sck_recv4):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	Sock_str = win_GetText(CtrlWin1),
	RecvL_str = win_GetText(CtrlWin2),
	Flags_str = win_GetText(CtrlWin3),
	term_str(SOCKET,S,Sock_str),
	term_str(INTEGER,RecvL,RecvL_str),
	term_str(SCK_FLAGS_LIST,Flags,Flags_str),
	trap(sck_Recv(S,RecvL,Flags,RecvBuf),E,err_proc("sck_Recv/4",E)),
	term_str(BINARY,RecvBuf,RecvBuf_str),
	win_SetText(CtrlWin4,RecvBuf_str),
  	!.
  test_case(Win,id_sck_recv_dg4):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	Sock_str = win_GetText(CtrlWin1),
	RecvL_str = win_GetText(CtrlWin2),
	Flags_str = win_GetText(CtrlWin3),
	term_str(SOCKET,S,Sock_str),
	term_str(INTEGER,RecvL,RecvL_str),
	term_str(SCK_FLAGS_LIST,Flags,Flags_str),
	trap(sck_Recv_DG(S,RecvL,Flags,RecvBuf),E,err_proc("sck_Recv_DG/4",E)),
	term_str(BINARY,RecvBuf,RecvBuf_str),
	win_SetText(CtrlWin4,RecvBuf_str),
  	!.  	
  test_case(Win,id_sck_recvfrom5):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	Sock_str = win_GetText(CtrlWin1),
	RecvL_str = win_GetText(CtrlWin2),
	Flags_str = win_GetText(CtrlWin3),
	term_str(SOCKET,S,Sock_str),
	term_str(INTEGER,RecvL,RecvL_str),
	term_str(SCK_FLAGS_LIST,Flags,Flags_str),
	trap(sck_RecvFrom(S,RecvL,Flags,FromAddr,RecvBuf),E,err_proc("sck_RecvFrom/5",E)),
	term_str(SCK_ADDRESS,FromAddr,FromAddr_str),
	term_str(BINARY,RecvBuf,RecvBuf_str),
	win_SetText(CtrlWin5,RecvBuf_str),
	win_SetText(CtrlWin4,FromAddr_str),
  	!.
  test_case(Win,id_sck_recvfrom_dg5):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	Sock_str = win_GetText(CtrlWin1),
	RecvL_str = win_GetText(CtrlWin2),
	Flags_str = win_GetText(CtrlWin3),
	term_str(SOCKET,S,Sock_str),
	term_str(INTEGER,RecvL,RecvL_str),
	term_str(SCK_FLAGS_LIST,Flags,Flags_str),
	trap(sck_RecvFrom_DG(S,RecvL,Flags,FromAddr,RecvBuf),E,err_proc("sck_RecvFrom_DG/5",E)),
	term_str(SCK_ADDRESS,FromAddr,FromAddr_str),
	term_str(BINARY,RecvBuf,RecvBuf_str),
	win_SetText(CtrlWin5,RecvBuf_str),
	win_SetText(CtrlWin4,FromAddr_str),
  	!.  	
  test_case(Win,id_sck_select6):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	CtrlWin6 = win_GetCtlHandle(Win,control6),
	Rfds_str = win_GetText(CtrlWin1),
	Wfds_str = win_GetText(CtrlWin2),
	Efds_str = win_GetText(CtrlWin3),
	term_str(SOCKETS_LIST,Rfds,Rfds_str),
	term_str(SOCKETS_LIST,Wfds,Wfds_str),
	term_str(SOCKETS_LIST,Efds,Efds_str),
	trap(sck_Select(Rfds,Wfds,Efds,R_out,W_out,E_out),E,err_proc("sck_Select/6",E)),
	term_str(SOCKETS_LIST,R_out,R_str),
	term_str(SOCKETS_LIST,W_out,W_str),
	term_str(SOCKETS_LIST,E_out,E_str),
	win_SetText(CtrlWin4,R_str),
	win_SetText(CtrlWin5,W_str),
	win_SetText(CtrlWin6,E_str),
  	!.  	
  test_case(Win,id_sck_select7):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	CtrlWin6 = win_GetCtlHandle(Win,control6),
	CtrlWin7 = win_GetCtlHandle(Win,control7),
	CtrlWin8 = win_GetCtlHandle(Win,control8),
	Rfds_str = win_GetText(CtrlWin1),
	Wfds_str = win_GetText(CtrlWin2),
	Efds_str = win_GetText(CtrlWin3),
	T_sec_str = win_GetText(CtrlWin4),
	T_msec_str = win_GetText(CtrlWin5),
	term_str(SOCKETS_LIST,Rfds,Rfds_str),
	term_str(SOCKETS_LIST,Wfds,Wfds_str),
	term_str(SOCKETS_LIST,Efds,Efds_str),
	term_str(LONG,T_sec,T_sec_str),
	term_str(LONG,T_msec,T_msec_str),
	trap(sck_Select(Rfds,Wfds,Efds,sck_select_timeval(T_sec,T_msec),R_out,W_out,E_out),E,err_proc("sck_Select/7",E)),
	term_str(SOCKETS_LIST,R_out,R_str),
	term_str(SOCKETS_LIST,W_out,W_str),
	term_str(SOCKETS_LIST,E_out,E_str),
	win_SetText(CtrlWin6,R_str),
	win_SetText(CtrlWin7,W_str),
	win_SetText(CtrlWin8,E_str),
  	!.
  test_case(Win,id_sck_send3):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	Sock_str = win_GetText(CtrlWin1),
	Data_str = win_GetText(CtrlWin2),
	Flags_str = win_GetText(CtrlWin3),
	term_str(SOCKET,S,Sock_str),
	term_str(BINARY,Data,Data_str),
	term_str(SCK_FLAGS_LIST,Flags,Flags_str),
	trap(Res = sck_Send(S,Data,Flags),E,err_proc("sck_Send/3",E)),
	term_str(INTEGER,Res,Res_str),
	win_SetText(CtrlWin4,Res_str),
  	!.
  test_case(Win,id_sck_sendto4):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	Sock_str = win_GetText(CtrlWin1),
	Data_str = win_GetText(CtrlWin2),
	Flags_str = win_GetText(CtrlWin3),
	Addr_str = win_GetText(CtrlWin4),
	term_str(SOCKET,S,Sock_str),
	term_str(BINARY,Data,Data_str),
	term_str(SCK_FLAGS_LIST,Flags,Flags_str),
	term_str(SCK_ADDRESS,Addr,Addr_str),
	trap(Res = sck_SendTo(S,Data,Flags,Addr),E,err_proc("sck_SendTo/4",E)),
	term_str(INTEGER,Res,Res_str),
	win_SetText(CtrlWin5,Res_str),
  	!.
  test_case(Win,id_sck_setsockopt4):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	Sock_str = win_GetText(CtrlWin1),
	OptL_str = win_GetText(CtrlWin2),
	OptN_str = win_GetText(CtrlWin3),
	OptV_str = win_GetText(CtrlWin4),
	term_str(SOCKET,S,Sock_str),
IFDEF platform_32bit	
	term_str(SCK_OPTION_LEVEL,OptL,OptL_str),
	term_str(SCK_OPTION_NAME,OptN,OptN_str),
ELSEDEF
	term_str(UNSIGNED,OptL,OptL_str),
	term_str(UNSIGNED,OptN,OptN_str),
ENDDEF		
	term_str(SCK_OPTION,OptV,OptV_str),
	trap(sck_SetSockOpt(S,OptL,OptN,OptV),E,err_proc("sck_SetSockOpt/4",E)),
  	!.  	
  test_case(Win,id_sck_shutdown2):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Sock_str = win_GetText(CtrlWin1),
	How_str = win_GetText(CtrlWin2),
	term_str(SOCKET,S,Sock_str),
	term_str(INTEGER,How,How_str),
	trap(sck_ShutDown(S,How),E,err_proc("sck_ShutDown/2",E)),
  	!.
  test_case(Win,id_sck_socket3):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	AddrF_str = win_GetText(CtrlWin1),
	Type_str = win_GetText(CtrlWin2),
	Proto_str = win_GetText(CtrlWin3),
	term_str(INTEGER,AddrF,AddrF_str),
	term_str(INTEGER,Type,Type_str),
	term_str(INTEGER,Proto,Proto_str),
	trap(S = sck_Socket(AddrF,Type,Proto),E,err_proc("sck_Socket/3",E)),
	term_str(SOCKET,S,Sock_str),
	win_SetText(CtrlWin4,Sock_str),
	!.
%____________Asynchronous routines_____________________
  test_case(Win,id_sck_asyncselect4):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	Sock_str = win_GetText(CtrlWin1),
	Hwnd_str = win_GetText(CtrlWin2),
	Msg_str = win_GetText(CtrlWin3),
	Evs_str = win_GetText(CtrlWin4),
	term_str(SOCKET,S,Sock_str),
	term_str(SCK_HWND,Hwnd,Hwnd_str),
	term_str(UNSIGNED,Msg,Msg_str),
	term_str(SCK_EVENTS_LIST,Evs,Evs_str),
	assert(async(Hwnd,Msg)),
	trap(sck_AsyncSelect(S,Hwnd,Msg,Evs),E,err_proc("sck_AsyncSelect/4",E)),
  	!.
IFDEF os_os2
  test_case(Win,id_sck_aselecttimeout1):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Ts_str = win_GetText(CtrlWin1),
	Tmcs_str = win_GetText(CtrlWin2),
	Ts_str = "",
	Tmcs_str = "",
	trap(sck_ASelectTimeOut(TimeOut),E,err_proc("sck_ASelectTimeOut/1",E)),
	TimeOut = sck_select_timeval( T1, T2 ),
	term_str(LONG,T1,T1_str),
	term_str(LONG,T2,T2_str),
	win_SetText(CtrlWin1,T1_str),
	win_SetText(CtrlWin2,T2_str),
	!.
  test_case(Win,id_sck_aselecttimeout1):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Ts_str = win_GetText(CtrlWin1),
	Tmcs_str = win_GetText(CtrlWin2),
	Ts_str <> "",
	Tmcs_str <> "",
	term_str(LONG,Ts,Ts_str),
	term_str(LONG,Tmcs,Tmcs_str),
	TimeOut = sck_select_timeval( Ts, Tmcs ),
	trap(sck_ASelectTimeOut(TimeOut),E,err_proc("sck_ASelectTimeOut/1",E)),
	!.
  test_case(_Win,id_sck_aselecttimeout1):-
  	dlg_note("sck_ASelectTimeOut/1","Unrecognized flow pattern"),
  	!.
  test_case(Win,id_sck_asetnotifyfns1):-
  	CtrlWin2 = win_GetCtlHandle(Win,control2),
  	trap(PrevNotifyFNS = sck_ASetNotifyFNS( app_notifyFNS ),E,err_proc("sck_ASetNotifyFNS/1",E)),
  	term_str(SCK_NOTIFY_FNS,PrevNotifyFNS,PrevNotifyFNS_str),
	win_SetText(CtrlWin2,PrevNotifyFNS_str),
  	!.
ENDDEF
  test_case(Win,id_sck_getselectevent1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	LP_str = win_GetText(CtrlWin1),
	term_str(LONG,LP,LP_str),
	trap(Ev = sck_GetSelectEvent(LP),E,err_proc("sck_GetSelectEvent/1",E)),
	term_str(SCK_EVENT,Ev,Ev_str),
	win_SetText(CtrlWin2,Ev_str),
	!.
  test_case(Win,id_sck_getselecterror1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	LP_str = win_GetText(CtrlWin1),
	term_str(LONG,LP,LP_str),
	trap(Err = sck_GetSelectError(LP),E,err_proc("sck_GetSelectError/1",E)),
	term_str(SCK_ERROR,Err,Err_str),
	win_SetText(CtrlWin2,Err_str),
  	!.
IFNDEF os_os2  	
  test_case(Win,id_sck_getasyncbuflen1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	LP_str = win_GetText(CtrlWin1),
	term_str(LONG,LP,LP_str),
	trap(Ev = sck_GetAsyncBuflen(LP),E,err_proc("sck_GetAsyncBuflen/1",E)),
	term_str(UNSIGNED,Ev,Ev_str),
	win_SetText(CtrlWin2,Ev_str),
	!.
  test_case(Win,id_sck_getasyncerror1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	LP_str = win_GetText(CtrlWin1),
	term_str(LONG,LP,LP_str),
	trap(Err = sck_GetAsyncError(LP),E,err_proc("sck_GetAsyncError/1",E)),
	term_str(SCK_ERROR,Err,Err_str),
	win_SetText(CtrlWin2,Err_str),
  	!.
  test_case(Win,id_sck_getasynchostent1):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	Handle_str = win_GetText(CtrlWin1),
	term_str(SCK_HANDLE,Handle,Handle_str),
	trap( Res = sck_GetAsyncHostent(Handle),E,err_proc("sck_GetAsyncHostent/1",E)),
	Res = sck_hostent(H_n,H_al,H_ad_t,H_ad_l,H_ads),
	dlg_host_Create(Win,H_n,H_al,H_ad_t,H_ad_l,H_ads),
  	!.
  test_case(Win,id_sck_getasyncprotoent1):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	Handle_str = win_GetText(CtrlWin1),
	term_str(SCK_HANDLE,Handle,Handle_str),
	trap( Res = sck_GetAsyncProtoent(Handle),E,err_proc("sck_GetAsyncProtoent/1",E)),
	Res = sck_protoent(P_n,P_al,P_numb),
	dlg_proto_Create(Win,P_n,P_al,P_numb),
  	!.
  test_case(Win,id_sck_getasyncservent1):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	Handle_str = win_GetText(CtrlWin1),
	term_str(SCK_HANDLE,Handle,Handle_str),
	trap( Res = sck_GetAsyncServent(Handle),E,err_proc("sck_GetAsyncServent/1",E)),
	Res = sck_servent(S_n,S_al,S_p,S_pr),
	dlg_service_Create(Win,S_n,S_al,S_p,S_pr),
  	!.
  test_case(Win,id_sck_cancelasyncrequest1):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
  	Handle_str = win_GetText(CtrlWin1),
	term_str(SCK_HANDLE,Handle,Handle_str),
	trap( sck_CancelAsyncRequest(Handle),E,err_proc("sck_CancelAsyncRequest/1",E)),
	!.
  test_case(Win,id_sck_asyncgethostbyaddr5):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	CtrlWin6 = win_GetCtlHandle(Win,control6),
	Hwnd_str = win_GetText(CtrlWin1),
	Msg_str = win_GetText(CtrlWin2),
	Addr_str = win_GetText(CtrlWin3),
	Type_str = win_GetText(CtrlWin4),
	Buflen_str = win_GetText(CtrlWin5),
	term_str(SCK_HWND,Hwnd,Hwnd_str),
	term_str(UNSIGNED,Msg,Msg_str),
	term_str(SCK_IN_ADDR,Addr,Addr_str),
	term_str(INTEGER,Type,Type_str),
	term_str(INTEGER,Buflen,Buflen_str),
	assert(async(Hwnd,Msg)),
	trap(Handle = sck_AsyncGetHostByAddr(Hwnd,Msg,Addr,Type,Buflen),E,err_proc("sck_AsyncGetHostByAddr/5",E)),
	term_str(SCK_HANDLE,Handle,Handle_str),
	win_SetText(CtrlWin6,Handle_str),
	!.
  test_case(Win,id_sck_asyncgethostbyname4):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	Hwnd_str = win_GetText(CtrlWin1),
	Msg_str = win_GetText(CtrlWin2),
	HostName = win_GetText(CtrlWin3),
	Buflen_str = win_GetText(CtrlWin4),
	term_str(SCK_HWND,Hwnd,Hwnd_str),
	term_str(UNSIGNED,Msg,Msg_str),
	term_str(INTEGER,Buflen,Buflen_str),
	assert(async(Hwnd,Msg)),
	trap(Handle = sck_AsyncGetHostByName(Hwnd,Msg,HostName,Buflen),E,err_proc("sck_AsyncGetHostByName/4",E)),
	term_str(SCK_HANDLE,Handle,Handle_str),
	win_SetText(CtrlWin5,Handle_str),
	!.	
  test_case(Win,id_sck_asyncgetprotobyname4):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	Hwnd_str = win_GetText(CtrlWin1),
	Msg_str = win_GetText(CtrlWin2),
	ProtoName = win_GetText(CtrlWin3),
	Buflen_str = win_GetText(CtrlWin4),
	term_str(SCK_HWND,Hwnd,Hwnd_str),
	term_str(UNSIGNED,Msg,Msg_str),
	term_str(INTEGER,Buflen,Buflen_str),
	assert(async(Hwnd,Msg)),
	trap(Handle = sck_AsyncGetProtoByName(Hwnd,Msg,ProtoName,Buflen),E,err_proc("sck_AsyncGetProtoByName/4",E)),
	term_str(SCK_HANDLE,Handle,Handle_str),
	win_SetText(CtrlWin5,Handle_str),
	!.
  test_case(Win,id_sck_asyncgetprotobynumber4):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	Hwnd_str = win_GetText(CtrlWin1),
	Msg_str = win_GetText(CtrlWin2),
	ProtoNumb_str = win_GetText(CtrlWin3),
	Buflen_str = win_GetText(CtrlWin4),
	term_str(SCK_HWND,Hwnd,Hwnd_str),
	term_str(UNSIGNED,Msg,Msg_str),
	term_str(INTEGER,ProtoNumb,ProtoNumb_str),
	term_str(INTEGER,Buflen,Buflen_str),
	assert(async(Hwnd,Msg)),
	trap(Handle = sck_AsyncGetProtoByNumber(Hwnd,Msg,ProtoNumb,Buflen),E,err_proc("sck_AsyncGetProtoByNumber/4",E)),
	term_str(SCK_HANDLE,Handle,Handle_str),
	win_SetText(CtrlWin5,Handle_str),
	!.
  test_case(Win,id_sck_asyncgetservbyname4):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	Hwnd_str = win_GetText(CtrlWin1),
	Msg_str = win_GetText(CtrlWin2),
	ServName = win_GetText(CtrlWin3),
	Buflen_str = win_GetText(CtrlWin4),
	term_str(SCK_HWND,Hwnd,Hwnd_str),
	term_str(UNSIGNED,Msg,Msg_str),
	term_str(INTEGER,Buflen,Buflen_str),
	assert(async(Hwnd,Msg)),
	trap(Handle = sck_AsyncGetServByName(Hwnd,Msg,ServName,Buflen),E,err_proc("sck_AsyncGetServByName/4",E)),
	term_str(SCK_HANDLE,Handle,Handle_str),
	win_SetText(CtrlWin5,Handle_str),
	!.
  test_case(Win,id_sck_asyncgetservbyname5):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	CtrlWin6 = win_GetCtlHandle(Win,control6),
	Hwnd_str = win_GetText(CtrlWin1),
	Msg_str = win_GetText(CtrlWin2),
	ServName = win_GetText(CtrlWin3),
	ProtoName = win_GetText(CtrlWin4),
	Buflen_str = win_GetText(CtrlWin5),
	term_str(SCK_HWND,Hwnd,Hwnd_str),
	term_str(UNSIGNED,Msg,Msg_str),
	term_str(INTEGER,Buflen,Buflen_str),
	assert(async(Hwnd,Msg)),
	trap(Handle = sck_AsyncGetServByName(Hwnd,Msg,ServName,ProtoName,Buflen),E,err_proc("sck_AsyncGetServByName/5",E)),
	term_str(SCK_HANDLE,Handle,Handle_str),
	win_SetText(CtrlWin6,Handle_str),
	!.
  test_case(Win,id_sck_asyncgetservbyport4):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	Hwnd_str = win_GetText(CtrlWin1),
	Msg_str = win_GetText(CtrlWin2),
	ServPort_str = win_GetText(CtrlWin3),
	Buflen_str = win_GetText(CtrlWin4),
	term_str(SCK_HWND,Hwnd,Hwnd_str),
	term_str(UNSIGNED,Msg,Msg_str),
	term_str(INTEGER,ServPort,ServPort_str),
	term_str(INTEGER,Buflen,Buflen_str),
	assert(async(Hwnd,Msg)),
	trap(Handle = sck_AsyncGetServByPort(Hwnd,Msg,ServPort,Buflen),E,err_proc("sck_AsyncGetServByPort/4",E)),
	term_str(SCK_HANDLE,Handle,Handle_str),
	win_SetText(CtrlWin5,Handle_str),
	!.
  test_case(Win,id_sck_asyncgetservbyport5):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	CtrlWin3 = win_GetCtlHandle(Win,control3),
	CtrlWin4 = win_GetCtlHandle(Win,control4),
	CtrlWin5 = win_GetCtlHandle(Win,control5),
	CtrlWin6 = win_GetCtlHandle(Win,control6),
	Hwnd_str = win_GetText(CtrlWin1),
	Msg_str = win_GetText(CtrlWin2),
	ServPort_str = win_GetText(CtrlWin3),
	ProtoName = win_GetText(CtrlWin4),
	Buflen_str = win_GetText(CtrlWin5),
	term_str(SCK_HWND,Hwnd,Hwnd_str),
	term_str(UNSIGNED,Msg,Msg_str),
	term_str(INTEGER,ServPort,ServPort_str),
	term_str(INTEGER,Buflen,Buflen_str),
	assert(async(Hwnd,Msg)),
	trap(Handle = sck_AsyncGetServByPort(Hwnd,Msg,ServPort,ProtoName,Buflen),E,err_proc("sck_AsyncGetServByPort/5",E)),
	term_str(SCK_HANDLE,Handle,Handle_str),
	win_SetText(CtrlWin6,Handle_str),
	!.
ENDDEF

%____________Conversion routines_____________________  	
  test_case(Win,id_sck_htonl1):- 
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	HL_str = win_GetText(CtrlWin1),
	term_str(ULONG,HL,HL_str),
	trap(Res = sck_Htonl(HL),E,err_proc("sck_Htonl/1",E)),
	term_str(ULONG,Res,Res_str),
	win_SetText(CtrlWin2,Res_str),
  	!.
  test_case(Win,id_sck_htons1):- 
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	HS_str = win_GetText(CtrlWin1),
	term_str(USHORT,HS,HS_str),
	trap(Res = sck_Htons(HS),E,err_proc("sck_Htons/1",E)),
	term_str(USHORT,Res,Res_str),
	win_SetText(CtrlWin2,Res_str),
  	!.
  test_case(Win,id_sck_ntohl1):- 
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	NL_str = win_GetText(CtrlWin1),
	term_str(ULONG,NL,NL_str),
	trap(Res = sck_Ntohl(NL),E,err_proc("sck_Ntohl/1",E)),
	term_str(ULONG,Res,Res_str),
	win_SetText(CtrlWin2,Res_str),
  	!.
  test_case(Win,id_sck_ntohs1):- 
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	NS_str = win_GetText(CtrlWin1),
	term_str(USHORT,NS,NS_str),
	trap(Res = sck_Ntohs(NS),E,err_proc("sck_Ntohs/1",E)),
	term_str(USHORT,Res,Res_str),
	win_SetText(CtrlWin2,Res_str),
  	!.
  test_case(Win,id_sck_inetaddr1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	DtA_str = win_GetText(CtrlWin1),
	trap(Addr = sck_InetAddr(DtA_str),E,err_proc("sck_InetAddr/1",E)),
	term_str(SCK_IN_ADDR,Addr,Addr_str),
	win_SetText(CtrlWin2,Addr_str),
  	!.
  test_case(Win,id_sck_inetntoa1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Addr_str = win_GetText(CtrlWin1),
	term_str(SCK_IN_ADDR,Addr,Addr_str),
	trap(Res = sck_InetNtoa(Addr),E,err_proc("sck_InetNtoa/1",E)),
	win_SetText(CtrlWin2,Res),
  	!.
  	
%____________Database routines_______________________________  	
  test_case(Win,id_sck_gethostbyaddr2):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Addr_str = win_GetText(CtrlWin1),
	Type_str = win_GetText(CtrlWin2),
	term_str(SCK_IN_ADDR,Addr,Addr_str),
	term_str(INTEGER,Type,Type_str),
	trap(Res = sck_GetHostByAddr(Addr,Type),E,err_proc("sck_GetHostByAddr/2",E)),
	Res = sck_hostent(H_n,H_al,H_ad_t,H_ad_l,H_ads),
	dlg_host_Create(Win,H_n,H_al,H_ad_t,H_ad_l,H_ads),
  	!.
  test_case(Win,id_sck_gethostbyname1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	Host = win_GetText(CtrlWin1),
	trap(Res = sck_GetHostByName(Host),E,err_proc("sck_GetHostByName/1",E)),
	Res = sck_hostent(H_n,H_al,H_ad_t,H_ad_l,H_ads),
	dlg_host_Create(Win,H_n,H_al,H_ad_t,H_ad_l,H_ads),
  	!.
  test_case(Win,id_sck_gethostname1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Len_str = win_GetText(CtrlWin1),
	term_str(INTEGER,Len,Len_str),
	trap(Host = sck_GetHostName(Len),E,err_proc("sck_GetHostName/1",E)),
	win_SetText(CtrlWin2,Host),
  	!.
  test_case(Win,id_sck_getprotobyname1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	Proto = win_GetText(CtrlWin1),
	trap(Res = sck_GetProtoByName(Proto),E,err_proc("sck_GetProtoByName/1",E)),
	Res = sck_protoent(P_n,P_al,P_numb),
	dlg_proto_Create(Win,P_n,P_al,P_numb),
  	!.
  test_case(Win,id_sck_getprotobynumber1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	Numb_str = win_GetText(CtrlWin1),
	term_str(INTEGER,Numb,Numb_str),
	trap(Res = sck_GetProtoByNumber(Numb),E,err_proc("sck_GetProtoByNumber/1",E)),
	Res = sck_protoent(P_n,P_al,P_numb),
	dlg_proto_Create(Win,P_n,P_al,P_numb),
  	!.
  test_case(Win,id_sck_getservbyname1):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	S_name = win_GetText(CtrlWin1),
	trap(Res = sck_GetServByName(S_name),E,err_proc("sck_GetServByName/1",E)),
	Res = sck_servent(S_n,S_al,S_p,S_pr),
	dlg_service_Create(Win,S_n,S_al,S_p,S_pr),
  	!.
  test_case(Win,id_sck_getservbyname2):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Serv = win_GetText(CtrlWin1),
	Proto = win_GetText(CtrlWin2),
	trap(Res = sck_GetServByName(Serv,Proto),E,err_proc("sck_GetServByName/2",E)),
	Res = sck_servent(S_n,S_al,S_p,S_pr),
	dlg_service_Create(Win,S_n,S_al,S_p,S_pr),
  	!.
  test_case(Win,id_sck_getservbyport1):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	Port_str = win_GetText(CtrlWin1),
	term_str(INTEGER,Port,Port_str),
	trap(Res = sck_GetServByPort(Port),E,err_proc("sck_GetServByPort/1",E)),
	Res = sck_servent(S_n,S_al,S_p,S_pr),
	dlg_service_Create(Win,S_n,S_al,S_p,S_pr),
  	!.
  test_case(Win,id_sck_getservbyport2):- 
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
	CtrlWin2 = win_GetCtlHandle(Win,control2),
	Port_str = win_GetText(CtrlWin1),
	Proto = win_GetText(CtrlWin2),
	term_str(INTEGER,Port,Port_str),
	trap(Res = sck_GetServByPort(Port,Proto),E,err_proc("sck_GetServByPort/2",E)),
	Res = sck_servent(S_n,S_al,S_p,S_pr),
	dlg_service_Create(Win,S_n,S_al,S_p,S_pr),
  	!.
  test_case(_Win,id_sck_getlastnetdberror0):-
IFDEF os_os2
	CtrlWin1 = win_GetCtlHandle(_Win,control1),
	trap(Err = sck_GetLastNetDbError(),E,err_proc("sck_GetLastNetDbError/0",E)),
	term_str(SCK_ERROR,Err,Err_str),
	win_SetText(CtrlWin1,Err_str),
ENDDEF	
  	!.

%_________Windows specific routines______________

IFNDEF os_os2
  test_case(_Win,id_sck_cancelblockingcall0):-
  	trap(sck_CancelBlockingCall(),E,err_proc("sck_CancelBlockingCall/0",E)),
  	!.
  test_case(_Win,id_sck_unhookblockinghook0):-
  	trap(sck_UnhookBlockingHook(),E,err_proc("sck_UnhookBlockingHook/0",E)),
  	!.
  test_case(Win,id_sck_isblocking0):-
  	CtrlWin1 = win_GetCtlHandle(Win,control1),
  	trap(Res = sck_IsBlocking(),E,err_proc("sck_IsBlocking/0",E)),
  	term_str(BOOLEAN,Res,Res_str),
	win_SetText(CtrlWin1,Res_str),
  	!.
  test_case(Win,id_sck_setblockinghook1):-
  	CtrlWin2 = win_GetCtlHandle(Win,control2),
  	trap(PrevBlFunc = sck_SetBlockingHook( app_hook ),E,err_proc("sck_SetBlockingHook/1",E)),
  	term_str(SCK_BLOCKFUNC,PrevBlFunc,PrevBlFunc_str),
	win_SetText(CtrlWin2,PrevBlFunc_str),
  	!.
  test_case(_Win,id_sck_setlasterror1):-
	CtrlWin1 = win_GetCtlHandle(_Win,control1),
	Err_str = win_GetText(CtrlWin1),
	term_str(SCK_ERROR,Err,Err_str),
	trap(sck_SetLastError(Err),E,err_proc("sck_SetLastError/1",E)),
  	!.
ENDDEF
  	  	
%_________Miscellanious predicates
  test_case(Win,id_sck_getlasterror0):-
	CtrlWin1 = win_GetCtlHandle(Win,control1),
	trap(Err = sck_GetLastError(),E,err_proc("sck_GetLastError",E)),
	term_str(SCK_ERROR,Err,Err_str),
	win_SetText(CtrlWin1,Err_str),
  	!.
  test_case(_Win,id_sck_startup0):-
IFDEF os_os2  
  	trap(sck_Startup(),E,err_proc("sck_Startup",E)),
ENDDEF
  	!.  	
  test_case(_Win,id_sck_startup1):-
IFNDEF os_os2  
	CtrlWin1 = win_GetCtlHandle(_Win,control1),
	CtrlWin2 = win_GetCtlHandle(_Win,control2),
	CtrlWin3 = win_GetCtlHandle(_Win,control3),
	CtrlWin4 = win_GetCtlHandle(_Win,control4),
	CtrlWin5 = win_GetCtlHandle(_Win,control5),
	CtrlWin6 = win_GetCtlHandle(_Win,control6),
	CtrlWin7 = win_GetCtlHandle(_Win,control7),
	CtrlWin8 = win_GetCtlHandle(_Win,control8),
	Ver_str = win_GetText(CtrlWin1),
	term_str(WORD,Ver,Ver_str),
	trap(sck_Startup(Ver, Data, ResCod),E,err_proc("sck_Startup/3",E)),
	Data = sck_wsa_data(V,HV,Des,Ss,Msck,Mudp,VI),
	term_str(WORD,V,V_str),
	term_str(WORD,HV,HV_str),
	term_str(USHORT,Msck,Msck_str),
	term_str(USHORT,Mudp,Mudp_str),
	term_str(VENDOR_INFO_PTR,VI,VI_str),
	term_str(INTEGER,ResCod,ResCod_str),
	win_SetText(CtrlWin2,V_str),
	win_SetText(CtrlWin3,HV_str),
	win_SetText(CtrlWin4,Des),
	win_SetText(CtrlWin5,Ss),
	win_SetText(CtrlWin6,Msck_str),
	win_SetText(CtrlWin7,Mudp_str),
	win_SetText(CtrlWin8,VI_str),
	dlg_note("Result code sck_Startup/2",ResCod_str),
ENDDEF	
  	!.
  test_case(_Win,id_sck_startup1):-
	dlg_note("sck_Startup/3","Conversion fails!"),
	!.
  test_case(_Win,id_sck_cleanup0):-
 	trap(sck_Cleanup(),E,err_proc("sck_Cleanup",E)),  
  	!.
  test_case(_Win,_).
