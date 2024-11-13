/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  SOCKDEMO
 FileName: SOCKDEMO.PRO
 Purpose: No description
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/
ifdef platform_16bit
  code=5000
enddef

include "sockdemo.inc"
include "sockdemo.con"

CONSTANTS
  control1_t=301
  control1=302
  control2_t=303
  control2=304
  control3_t=305
  control3=306
  control4_t=307
  control4=308
  control5_t=309
  control5=310
  control6_t=311
  control6=312
  control7_t=313
  control7=314
  control8_t=315
  control8=316
  control9_t=317
  control9=318
  control10_t=317
  control10=318
  app_mes = 0xC420
  app_AHByAddr = 0xC421
  app_AHByName = 0xC422
  app_APByName = 0xC423
  app_APByNumber = 0xC424
  app_ASByName4 = 0xC425
  app_ASByName5 = 0xC426
  app_ASByPort4 = 0xC427
  app_ASByPort5 = 0xC428
  
DATABASE - ex_int
  test(WINDOW,INTEGER)
  async(SCK_HWND,UNSIGNED)

include "sck_proc.pro"
include "sckd_frm.pro"

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 12:09:48-26.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_Maximized]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "SockDemo"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 12:09:48-26.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 12:09:48-26.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
IFDEF os_os2
	
	menu_Enable(_Win,id_sck_startup0,b_true),
	menu_Enable(_Win,id_sck_getlastnetdberror0,b_true),
	menu_Enable(_Win,id_sck_aselecttimeout1,b_true),
	menu_Enable(_Win,id_sck_asetnotifyfns1,b_true),
	menu_Enable(_Win,id_sck_startup1,b_false),
	menu_Enable(_Win,id_windows_specific_routines,b_false),
ELSEDEF
	menu_Enable(_Win,id_sck_startup0,b_false),
	menu_Enable(_Win,id_sck_getlastnetdberror0,b_false),
	menu_Enable(_Win,id_sck_aselecttimeout1,b_false),
	menu_Enable(_Win,id_sck_asetnotifyfns1,b_false),
	menu_Enable(_Win,id_sck_startup1,b_true),
	menu_Enable(_Win,id_windows_specific_routines,b_true),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_sck_asetnotifyns1
  task_win_eh(_Win,e_Menu(id_sck_asetnotifyfns1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_asetnotifyfns1),
	!.
%END Task Window, id_sck_asetnotifyns1

%BEGIN Task Window, id_sck_aselecttimeout1
  task_win_eh(_Win,e_Menu(id_sck_aselecttimeout1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_aselecttimeout1),
	!.
%END Task Window, id_sck_aselecttimeout1

%BEGIN Task Window, id_sck_unhookblockinghook0
  task_win_eh(_Win,e_Menu(id_sck_unhookblockinghook0,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_unhookblockinghook0),
	!.
%END Task Window, id_sck_unhookblockinghook0

%BEGIN Task Window, id_sck_setblockinghook1
  task_win_eh(_Win,e_Menu(id_sck_setblockinghook1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_setblockinghook1),
	!.
%END Task Window, id_sck_setblockinghook1

%BEGIN Task Window, id_sck_isblocking0
  task_win_eh(_Win,e_Menu(id_sck_isblocking0,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_isblocking0),
	!.
%END Task Window, id_sck_isblocking0

%BEGIN Task Window, id_sck_cancelblockingcall0
  task_win_eh(_Win,e_Menu(id_sck_cancelblockingcall0,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_cancelblockingcall0),
	!.
%END Task Window, id_sck_cancelblockingcall0

%BEGIN Task Window, id_sck_getasyncservent1
  task_win_eh(_Win,e_Menu(id_sck_getasyncservent1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_getasyncservent1),
	!.
%END Task Window, id_sck_getasyncservent1

%BEGIN Task Window, id_sck_getasyncprotoent1
  task_win_eh(_Win,e_Menu(id_sck_getasyncprotoent1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_getasyncprotoent1),
	!.
%END Task Window, id_sck_getasyncprotoent1

%BEGIN Task Window, id_sck_asyncgetservbyport5
  task_win_eh(_Win,e_Menu(id_sck_asyncgetservbyport5,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_asyncgetservbyport5),
	!.
%END Task Window, id_sck_asyncgetservbyport5

%BEGIN Task Window, id_sck_asyncgetservbyport4
  task_win_eh(_Win,e_Menu(id_sck_asyncgetservbyport4,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_asyncgetservbyport4),
	!.
%END Task Window, id_sck_asyncgetservbyport4

%BEGIN Task Window, id_sck_asyncgetservbyname5
  task_win_eh(_Win,e_Menu(id_sck_asyncgetservbyname5,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_asyncgetservbyname5),
	!.
%END Task Window, id_sck_asyncgetservbyname5

%BEGIN Task Window, id_sck_asyncgetservbyname4
  task_win_eh(_Win,e_Menu(id_sck_asyncgetservbyname4,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_asyncgetservbyname4),
	!.
%END Task Window, id_sck_asyncgetservbyname4

%BEGIN Task Window, id_sck_asyncgetprotobynumber4
  task_win_eh(_Win,e_Menu(id_sck_asyncgetprotobynumber4,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_asyncgetprotobynumber4),
	!.
%END Task Window, id_sck_asyncgetprotobynumber4

%BEGIN Task Window, id_sck_asyncgetprotobyname4
  task_win_eh(_Win,e_Menu(id_sck_asyncgetprotobyname4,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_asyncgetprotobyname4),
	!.
%END Task Window, id_sck_asyncgetprotobyname4

%BEGIN Task Window, id_sck_cancelasyncrequest1
  task_win_eh(_Win,e_Menu(id_sck_cancelasyncrequest1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_cancelasyncrequest1),
	!.
%END Task Window, id_sck_cancelasyncrequest1

%BEGIN Task Window, id_sck_getasynchostent1
  task_win_eh(_Win,e_Menu(id_sck_getasynchostent1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_getasynchostent1),
	!.
%END Task Window, id_sck_getasynchostent1

%BEGIN Task Window, id_sck_getasyncerror1
  task_win_eh(_Win,e_Menu(id_sck_getasyncerror1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_getasyncerror1),
	!.
%END Task Window, id_sck_getasyncerror1

%BEGIN Task Window, id_sck_getasyncbuflen1
  task_win_eh(_Win,e_Menu(id_sck_getasyncbuflen1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_getasyncbuflen1),
	!.
%END Task Window, id_sck_getasyncbuflen1

%BEGIN Task Window, id_sck_asyncgethostbyname4
  task_win_eh(_Win,e_Menu(id_sck_asyncgethostbyname4,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_asyncgethostbyname4),
	!.
%END Task Window, id_sck_asyncgethostbyname4

%BEGIN Task Window, id_sck_asyncgethostbyaddr5
  task_win_eh(_Win,e_Menu(id_sck_asyncgethostbyaddr5,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_asyncgethostbyaddr5),
	!.
%END Task Window, id_sck_asyncgethostbyaddr5

%BEGIN Task Window, e_Native
  task_win_eh(_Win,e_Native(app_mes,_WParam,_LParam),0):-!,
  	async(HWin,app_mes),
  	_Win = cast(WINDOW,HWin),
write("AsyncSelect Event!!! ",_WParam," - ",_LParam),nl,
	dlg_event_Create(_Win,app_mes,_WParam,_LParam),
	!.
  task_win_eh(_Win,e_Native(app_AHByAddr,_WParam,_LParam),0):-!,
  	async(HWin,app_AHByAddr),
  	_Win = cast(WINDOW,HWin),
write("AsyncGetHostByAddr Event!!! ",_WParam," - ",_LParam),nl,
	dlg_event_Create(_Win,app_AHByAddr,_WParam,_LParam),
	!.
  task_win_eh(_Win,e_Native(app_AHByName,_WParam,_LParam),0):-!,
  	async(HWin,app_AHByName),
  	_Win = cast(WINDOW,HWin),
write("AsyncGetHostByName Event!!! ",_WParam," - ",_LParam),nl,
	dlg_event_Create(_Win,app_AHByName,_WParam,_LParam),
	!.
  task_win_eh(_Win,e_Native(app_APByName,_WParam,_LParam),0):-!,
  	async(HWin,app_APByName),
  	_Win = cast(WINDOW,HWin),
write("AsyncGetProtoByName Event!!! ",_WParam," - ",_LParam),nl,
	dlg_event_Create(_Win,app_APByName,_WParam,_LParam),
	!.
  task_win_eh(_Win,e_Native(app_APByNumber,_WParam,_LParam),0):-!,
  	async(HWin,app_APByNumber),
  	_Win = cast(WINDOW,HWin),
write("AsyncGetProtoByNumber Event!!! ",_WParam," - ",_LParam),nl,
	dlg_event_Create(_Win,app_APByNumber,_WParam,_LParam),
	!.
  task_win_eh(_Win,e_Native(app_ASByName4,_WParam,_LParam),0):-!,
  	async(HWin,app_ASByName4),
  	_Win = cast(WINDOW,HWin),
write("AsyncGetServByName/4 Event!!! ",_WParam," - ",_LParam),nl,
	dlg_event_Create(_Win,app_ASByName4,_WParam,_LParam),
	!.
  task_win_eh(_Win,e_Native(app_ASByName5,_WParam,_LParam),0):-!,
  	async(HWin,app_ASByName5),
  	_Win = cast(WINDOW,HWin),
write("AsyncGetServByName/5 Event!!! ",_WParam," - ",_LParam),nl,
	dlg_event_Create(_Win,app_ASByName5,_WParam,_LParam),
	!.
  task_win_eh(_Win,e_Native(app_ASByPort4,_WParam,_LParam),0):-!,
  	async(HWin,app_ASByPort4),
  	_Win = cast(WINDOW,HWin),
write("AsyncGetServByPort/4 Event!!! ",_WParam," - ",_LParam),nl,
	dlg_event_Create(_Win,app_ASByPort4,_WParam,_LParam),
	!.
  task_win_eh(_Win,e_Native(app_ASByPort5,_WParam,_LParam),0):-!,
  	async(HWin,app_ASByPort5),
  	_Win = cast(WINDOW,HWin),
write("AsyncGetServByPort/5 Event!!! ",_WParam," - ",_LParam),nl,
	dlg_event_Create(_Win,app_ASByPort5,_WParam,_LParam),
	!.
%END Task Window, e_Native

%BEGIN Task Window, id_sck_getlastnetdberror0
  task_win_eh(_Win,e_Menu(id_sck_getlastnetdberror0,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getlastnetdberror0),
	!.
%END Task Window, id_sck_getlastnetdberror0

%BEGIN Task Window, id_sck_recvfrom_dg5
  task_win_eh(_Win,e_Menu(id_sck_recvfrom_dg5,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_recvfrom_dg5),  
	!.
%END Task Window, id_sck_recvfrom_dg5

%BEGIN Task Window, id_sck_recv_dg4
  task_win_eh(_Win,e_Menu(id_sck_recv_dg4,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_recv_dg4),  
	!.
%END Task Window, id_sck_recv_dg4

%BEGIN Task Window, id_sck_select6
  task_win_eh(_Win,e_Menu(id_sck_select6,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_select6),
	!.
%END Task Window, id_sck_select6

%BEGIN Task Window, id_sck_inetaddr1
  task_win_eh(_Win,e_Menu(id_sck_inetaddr1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_inetaddr1),
	!.
%END Task Window, id_sck_inetaddr1

%BEGIN Task Window, id_sck_mergeaddress_in3
  task_win_eh(_Win,e_Menu(id_sck_mergeaddress_in3,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_mergeaddress_in3),
	!.
%END Task Window, id_sck_mergeaddress_in3

%BEGIN Task Window, id_sck_mergeaddress2
  task_win_eh(_Win,e_Menu(id_sck_mergeaddress2,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_mergeaddress2),
	!.
%END Task Window, id_sck_mergeaddress2

%BEGIN Task Window, id_sck_splitaddress_in4
  task_win_eh(_Win,e_Menu(id_sck_splitaddress_in4,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_splitaddress_in4),
	!.
%END Task Window, id_sck_splitaddress_in4

%BEGIN Task Window, id_sck_splitaddress3
  task_win_eh(_Win,e_Menu(id_sck_splitaddress3,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_splitaddress3),
	!.
%END Task Window, id_sck_splitaddress3

%BEGIN Task Window, id_sck_ntohs1
  task_win_eh(_Win,e_Menu(id_sck_ntohs1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_ntohs1),
	!.
%END Task Window, id_sck_ntohs1

%BEGIN Task Window, id_sck_ntohl1
  task_win_eh(_Win,e_Menu(id_sck_ntohl1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_ntohl1),
	!.
%END Task Window, id_sck_ntohl1

%BEGIN Task Window, id_sck_inetntoa1
  task_win_eh(_Win,e_Menu(id_sck_inetntoa1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_inetntoa1),
	!.
%END Task Window, id_sck_inetntoa1

%BEGIN Task Window, id_sck_htons1
  task_win_eh(_Win,e_Menu(id_sck_htons1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_htons1),
	!.
%END Task Window, id_sck_htons1

%BEGIN Task Window, id_sck_htonl1
  task_win_eh(_Win,e_Menu(id_sck_htonl1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_htonl1),
	!.
%END Task Window, id_sck_htonl1

%BEGIN Task Window, id_sck_accept1
  task_win_eh(_Win,e_Menu(id_sck_accept1,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_accept1),
	!.
%END Task Window, id_sck_accept1

%BEGIN Task Window, id_sck_ioctlset3
  task_win_eh(_Win,e_Menu(id_sck_ioctlset3,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_ioctlset3),
	!.
%END Task Window, id_sck_ioctlset3

%BEGIN Task Window, id_sck_ioctlget2
  task_win_eh(_Win,e_Menu(id_sck_ioctlget2,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_ioctlget2),
	!.
%END Task Window, id_sck_ioctlget2

%BEGIN Task Window, id_sck_accept2
  task_win_eh(_Win,e_Menu(id_sck_accept2,_ShiftCtlAlt),0):-!,
  	dlg_test_Create(_Win,id_sck_accept2),
	!.
%END Task Window, id_sck_accept2


%BEGIN Task Window, id_sck_gethostbyaddr2
  task_win_eh(_Win,e_Menu(id_sck_gethostbyaddr2,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_gethostbyaddr2),
	!.
%END Task Window, id_sck_gethostbyaddr2

%BEGIN Task Window, id_sck_getlasterror0
  task_win_eh(_Win,e_Menu(id_sck_getlasterror0,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getlasterror0),
	!.
%END Task Window, id_sck_getlasterror0

%BEGIN Task Window, id_sck_startup1
  task_win_eh(_Win,e_Menu(id_sck_startup1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_startup1),
	!.
%END Task Window, id_sck_startup1

%BEGIN Task Window, id_sck_startup0
  task_win_eh(_Win,e_Menu(id_sck_startup0,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_startup0),
	!.
%END Task Window, id_sck_startup0

%BEGIN Task Window, id_sck_socket3
  task_win_eh(_Win,e_Menu(id_sck_socket3,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_socket3),
	!.
%END Task Window, id_sck_socket3

%BEGIN Task Window, id_sck_shutdown2
  task_win_eh(_Win,e_Menu(id_sck_shutdown2,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_shutdown2),
	!.
%END Task Window, id_sck_shutdown2

%BEGIN Task Window, id_sck_setsockopt4
  task_win_eh(_Win,e_Menu(id_sck_setsockopt4,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_setsockopt4),
	!.
%END Task Window, id_sck_setsockopt4

%BEGIN Task Window, id_sck_setlasterror1
  task_win_eh(_Win,e_Menu(id_sck_setlasterror1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_setlasterror1),
	!.
%END Task Window, id_sck_setlasterror1

%BEGIN Task Window, id_sck_sendto4
  task_win_eh(_Win,e_Menu(id_sck_sendto4,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_sendto4),
	!.
%END Task Window, id_sck_sendto4

%BEGIN Task Window, id_sck_send3
  task_win_eh(_Win,e_Menu(id_sck_send3,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_send3),
	!.
%END Task Window, id_sck_send3

%BEGIN Task Window, id_sck_select7
  task_win_eh(_Win,e_Menu(id_sck_select7,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_select7),
	!.
%END Task Window, id_sck_select7

%BEGIN Task Window, id_sck_recvfrom5
  task_win_eh(_Win,e_Menu(id_sck_recvfrom5,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_recvfrom5),
	!.
%END Task Window, id_sck_recvfrom5

%BEGIN Task Window, id_sck_recv4
  task_win_eh(_Win,e_Menu(id_sck_recv4,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_recv4),
	!.
%END Task Window, id_sck_recv4

%BEGIN Task Window, id_sck_listen2
  task_win_eh(_Win,e_Menu(id_sck_listen2,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_listen2),
	!.
%END Task Window, id_sck_listen2

%BEGIN Task Window, id_sck_getsockopt3
  task_win_eh(_Win,e_Menu(id_sck_getsockopt3,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getsockopt3),
	!.
%END Task Window, id_sck_getsockopt3

%BEGIN Task Window, id_sck_getsockname1
  task_win_eh(_Win,e_Menu(id_sck_getsockname1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getsockname1),
	!.
%END Task Window, id_sck_getsockname1

%BEGIN Task Window, id_sck_getservbyport2
  task_win_eh(_Win,e_Menu(id_sck_getservbyport2,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getservbyport2),
	!.
%END Task Window, id_sck_getservbyport2

%BEGIN Task Window, id_sck_getservbyport1
  task_win_eh(_Win,e_Menu(id_sck_getservbyport1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getservbyport1),
	!.
%END Task Window, id_sck_getservbyport1

%BEGIN Task Window, id_sck_getservbyname2
  task_win_eh(_Win,e_Menu(id_sck_getservbyname2,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getservbyname2),
	!.
%END Task Window, id_sck_getservbyname2

%BEGIN Task Window, id_sck_getservbyname1
  task_win_eh(_Win,e_Menu(id_sck_getservbyname1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getservbyname1),
	!.
%END Task Window, id_sck_getservbyname1

%BEGIN Task Window, id_sck_getselectevent1
  task_win_eh(_Win,e_Menu(id_sck_getselectevent1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getselectevent1),
	!.
%END Task Window, id_sck_getselectevent1

%BEGIN Task Window, id_sck_getselecterror1
  task_win_eh(_Win,e_Menu(id_sck_getselecterror1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getselecterror1),
	!.
%END Task Window, id_sck_getselecterror1

%BEGIN Task Window, id_sck_getprotobynumber1
  task_win_eh(_Win,e_Menu(id_sck_getprotobynumber1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getprotobynumber1),
	!.
%END Task Window, id_sck_getprotobynumber1

%BEGIN Task Window, id_sck_getprotobyname1
  task_win_eh(_Win,e_Menu(id_sck_getprotobyname1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getprotobyname1),
	!.
%END Task Window, id_sck_getprotobyname1

%BEGIN Task Window, id_sck_getpeername1
  task_win_eh(_Win,e_Menu(id_sck_getpeername1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_getpeername1),
	!.
%END Task Window, id_sck_getpeername1

%BEGIN Task Window, id_sck_gethostname1
  task_win_eh(_Win,e_Menu(id_sck_gethostname1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_gethostname1),
	!.
%END Task Window, id_sck_gethostname1

%BEGIN Task Window, id_sck_gethostbyname1
  task_win_eh(_Win,e_Menu(id_sck_gethostbyname1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_gethostbyname1),
	!.
%END Task Window, id_sck_gethostbyname1

%BEGIN Task Window, id_sck_connect2
  task_win_eh(_Win,e_Menu(id_sck_connect2,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_connect2),
	!.
%END Task Window, id_sck_connect2

%BEGIN Task Window, id_sck_closesocket1
  task_win_eh(_Win,e_Menu(id_sck_closesocket1,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_closesocket1),
	!.
%END Task Window, id_sck_closesocket1

%BEGIN Task Window, id_sck_cleanup0
  task_win_eh(_Win,e_Menu(id_sck_cleanup0,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_cleanup0),
	!.
%END Task Window, id_sck_cleanup0

%BEGIN Task Window, id_sck_bind2
  task_win_eh(_Win,e_Menu(id_sck_bind2,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_bind2),
	!.
%END Task Window, id_sck_bind2

%BEGIN Task Window, id_sck_asyncselect4
  task_win_eh(_Win,e_Menu(id_sck_asyncselect4,_ShiftCtlAlt),0):-!,
	dlg_test_Create(_Win,id_sck_asyncselect4),
	!.
%END Task Window, id_sck_asyncselect4



%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("sockdemo.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

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
  	vpi_ShowHelpContext("sockdemo.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF ws_win
  IFDEF use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  ENDDEF
ENDDEF  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"sockdemo",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 13:48:10-26.11.1999, Code automatically updated!
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

%BEGIN_DLG Test
/**************************************************************************
	Creation and event handling for dialog: Test
**************************************************************************/

CONSTANTS

%BEGIN Test, CreateParms, 12:09:34-26.11.1999, Code automatically updated!
  dlg_test_ResID = idd_test
  dlg_test_DlgType = wd_Modeless
  dlg_test_Help = idh_contents
%END Test, CreateParms

PREDICATES

  dlg_test_eh : EHANDLER

CLAUSES

  dlg_test_Create(Parent,Test):-
	win_CreateResDialog(Parent,dlg_test_DlgType,dlg_test_ResID,dlg_test_eh,Test),
	!.

%BEGIN Test, idc_ok _CtlInfo
  dlg_test_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-
	test(_Win,Test_pred),
	trap(test_case(_Win,Test_pred),_,fail),
	!.
  dlg_test_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	dlg_Note("Incorrect input data"),
	!.

  dlg_test_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
  	retract(test(_Win,_)),
	win_Destroy(_Win),
	!.	
%END Test, idc_ok _CtlInfo
%MARK Test, new events

%BEGIN Test, e_Create
  dlg_test_eh(_Win,e_Create(Test),0):-!,
  	assert(test(_Win,Test)),
  	form_case(_Win,Test),
	!.
%END Test, e_Create

  dlg_test_eh(_,_,_):-!,fail.

%END_DLG Test
%BEGIN_DLG Event
/**************************************************************************
	Creation and event handling for dialog: Event
**************************************************************************/

CONSTANTS

%BEGIN Event, CreateParms, 20:47:31-17.2.1997, Code automatically updated!
  dlg_event_ResID = idd_event
  dlg_event_DlgType = wd_Modeless
  dlg_event_Help = contents
%END Event, CreateParms

PREDICATES

  dlg_event_eh : EHANDLER
  dlg_event_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_event_Create(Parent,Msg,WP,LP):-
	term_str(WINDOW,Parent,P_str),
	term_str(LONG,LP,LP_str),
	term_str(UNSIGNED,WP,WP_str),
	term_str(UNSIGNED,Msg,Msg_str),
%MARK Event, new variables

	dialog_CreateModeless(Parent,dlg_event_ResID,"",
  		[
%BEGIN Event, ControlList, 20:47:31-17.2.1997, Code automatically updated!
		df(idc_w,editstr(P_str,[]),nopr),
		df(idc_m,editstr(Msg_str,[]),nopr),
		df(idc_wp,editstr(WP_Str,[]),nopr),
		df(idc_lp,editstr(LP_str,[]),nopr)
%END Event, ControlList
		],
		dlg_event_eh,0),!.

  dlg_event_Create(_,_,_,_):-
	dlg_Note("Error: Fail in dlg_event_Create").

  dlg_event_update(_VALLIST):-
%BEGIN Event, Update controls, 20:47:31-17.2.1997, Code automatically updated!
	_IDC_W_VALUE = dialog_VLGetstr(idc_w,_VALLIST),
	_IDC_M_VALUE = dialog_VLGetstr(idc_m,_VALLIST),
	_IDC_WP_VALUE = dialog_VLGetstr(idc_wp,_VALLIST),
	_IDC_LP_VALUE = dialog_VLGetstr(idc_lp,_VALLIST),
%END Event, Update controls
	!.
  dlg_event_update(_):-
	dlg_Note("Error: Fail in dlg_event_update").

%BEGIN Event, idc_ok _CtlInfo
  dlg_event_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	VALLIST = dialog_GetValues(_Win),
	dlg_event_update(VALLIST),
	!,fail.
%END Event, idc_ok _CtlInfo
%MARK Event, new events

  dlg_event_eh(_,_,_):-!,fail.

%END_DLG Event
%BEGIN_DLG Service
/**************************************************************************
	Creation and event handling for dialog: Service
**************************************************************************/

CONSTANTS

%BEGIN Service, CreateParms, 21:52:06-17.2.1997, Code automatically updated!
  dlg_service_DlgType = wd_Modeless
  dlg_service_Title = "Service"
  dlg_service_RCT = rct(50,40,235,122)
  dlg_service_Flags = [wsf_Close,wsf_TitleBar]
  dlg_service_Help = contents
  dlg_service_Font = "Arial"
  dlg_service_FSize = 8
%END Service, CreateParms

PREDICATES

  dlg_service_eh : EHANDLER

CLAUSES

  dlg_service_Create(Parent,S1,S2,S3,S4):-
  
	term_str(SCK_SLIST,S2,S2_str),
%term_str(STRING,S2,S2_str),
	term_str(SHORT,S3,S3_str),
  
	win_CreateDynDialog(Parent,
		[
%BEGIN Service, WinDefList, 21:52:06-17.2.1997, Code automatically updated!
		 dlg_font(wdef(dlg_service_DlgType,dlg_service_RCT,dlg_service_Title,u_DlgBase),
		 	  dlg_service_Font,dlg_service_FSize,dlg_service_Flags),
		 ctl(wdef(wc_PushButton,rct(140,6,180,18),"&OK",u_DlgBase),idc_ok,[wsf_ClipSiblings,wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Edit,rct(64,13,127,23),S1,u_DlgBase),idc_service_name,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Edit,rct(64,30,127,40),S2_str,u_DlgBase),idc_service_al,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Edit,rct(64,47,127,57),S3_str,u_DlgBase),idc_service_port,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Edit,rct(64,64,126,74),S4,u_DlgBase),idc_service_proto,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Text,rct(10,14,57,22),"Service name:",u_DlgBase),idct_service_name,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(10,31,63,39),"Service aliases:",u_DlgBase),idct_service_aliases,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(10,47,51,55),"Service port:",u_DlgBase),idct_service_port,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(10,64,55,72),"Service proto:",u_DlgBase),idct_service_proto,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_GroupBox,rct(4,3,133,79),"SCK_SERVENT",u_DlgBase),idc_sck_servent,[wsf_NoClipSiblings])
%END Service, WinDefList
		],dlg_service_eh,0),!.

%BEGIN Service, idc_ok _CtlInfo
  dlg_service_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Service, idc_ok _CtlInfo
%MARK Service, new events

  dlg_service_eh(_,_,_):-!,fail.

%END_DLG Service


%BEGIN_DLG Host
/**************************************************************************
	Creation and event handling for dialog: Host
**************************************************************************/

CONSTANTS

%BEGIN Host, CreateParms, 21:57:39-17.2.1997, Code automatically updated!
  dlg_host_DlgType = wd_Modeless
  dlg_host_Title = "Host"
  dlg_host_RCT = rct(50,40,250,127)
  dlg_host_Flags = [wsf_Close,wsf_TitleBar]
  dlg_host_Help = contents
  dlg_host_Font = "Arial"
  dlg_host_FSize = 8
%END Host, CreateParms

PREDICATES

  dlg_host_eh : EHANDLER

CLAUSES

  dlg_host_Create(Parent,H1,H2,H3,H4,H5):-
  
  	term_str(SCK_SLIST,H2,H2_str),
%term_str(STRING,H2,H2_str),
  	term_str(SHORT,H3,H3_str),
  	term_str(SHORT,H4,H4_str),
	term_str(SCK_ALIST,H5,H5_str),
%term_str(STRING,H5,H5_str),
  	
	win_CreateDynDialog(Parent,
		[
%BEGIN Host, WinDefList, 21:57:39-17.2.1997, Code automatically updated!
		 dlg_font(wdef(dlg_host_DlgType,dlg_host_RCT,dlg_host_Title,u_DlgBase),
		 	  dlg_host_Font,dlg_host_FSize,dlg_host_Flags),
		 ctl(wdef(wc_PushButton,rct(156,7,196,19),"&OK",u_DlgBase),idc_ok,[wsf_ClipSiblings,wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Edit,rct(75,10,140,20),H1,u_DlgBase),idc_host_name,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Edit,rct(75,25,140,35),H2_str,u_DlgBase),idc_host_al,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Edit,rct(75,40,140,50),H3_str,u_DlgBase),idc_host_type,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Edit,rct(75,55,140,65),H4_str,u_DlgBase),idc_host_len,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Edit,rct(75,70,140,80),H5_str,u_DlgBase),idc_host_adrs,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Text,rct(8,10,45,18),"Host name:",u_DlgBase),idct_host_name,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(8,26,51,34),"Host aliases:",u_DlgBase),idct_host_aliases,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(8,41,63,49),"Type of address:",u_DlgBase),idct_host_type_of_address,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(8,57,69,65),"Length of address:",u_DlgBase),idct_length_of_address,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(8,72,45,80),"Addresses:",u_DlgBase),idct_addresses,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_GroupBox,rct(4,1,146,85),"SCK_HOSTENT",u_DlgBase),idc_sck_hostent,[wsf_NoClipSiblings])
%END Host, WinDefList
		],dlg_host_eh,0),!.

%BEGIN Host, idc_ok _CtlInfo
  dlg_host_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Host, idc_ok _CtlInfo
%MARK Host, new events

  dlg_host_eh(_,_,_):-!,fail.

%END_DLG Host


%BEGIN_DLG Proto
/**************************************************************************
	Creation and event handling for dialog: Proto
**************************************************************************/

CONSTANTS

%BEGIN Proto, CreateParms, 21:55:17-17.2.1997, Code automatically updated!
  dlg_proto_DlgType = wd_Modeless
  dlg_proto_Title = "Proto"
  dlg_proto_RCT = rct(50,40,220,104)
  dlg_proto_Flags = [wsf_Close,wsf_TitleBar]
  dlg_proto_Help = contents
  dlg_proto_Font = "Arial"
  dlg_proto_FSize = 8
%END Proto, CreateParms

PREDICATES

  dlg_proto_eh : EHANDLER

CLAUSES

  dlg_proto_Create(Parent,P1,P2,P3):-
  
  	term_str(SCK_SLIST,P2,P2_str),
%term_str(STRING,P2,P2_str),
  	term_str(SHORT,P3,P3_str),
  	
	win_CreateDynDialog(Parent,
		[
%BEGIN Proto, WinDefList, 21:55:17-17.2.1997, Code automatically updated!
		 dlg_font(wdef(dlg_proto_DlgType,dlg_proto_RCT,dlg_proto_Title,u_DlgBase),
		 	  dlg_proto_Font,dlg_proto_FSize,dlg_proto_Flags),
		 ctl(wdef(wc_PushButton,rct(125,5,165,17),"&OK",u_DlgBase),idc_ok,[wsf_ClipSiblings,wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Edit,rct(54,12,113,22),P1,u_DlgBase),idc_proto_name,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Edit,rct(54,30,113,40),P2_str,u_DlgBase),idc_proto_al,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Edit,rct(54,47,113,57),P3_str,u_DlgBase),idc_edit_numb,[wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_ReadOnly]),
		 ctl(wdef(wc_Text,rct(6,14,45,22),"Proto name:",u_DlgBase),idct_proto_name,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(6,31,51,39),"Proto aliases:",u_DlgBase),idct_proto_aliases,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(6,48,52,56),"Proto number:",u_DlgBase),idct_proto_number,[wsf_ClipSiblings,wsf_AlignLeft]),
		 ctl(wdef(wc_GroupBox,rct(2,2,119,60),"SCK_PROTOENT",u_DlgBase),idc_sck_protoent,[wsf_NoClipSiblings])
%END Proto, WinDefList
		],dlg_proto_eh,0),!.

%BEGIN Proto, idc_ok _CtlInfo
  dlg_proto_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Proto, idc_ok _CtlInfo
%MARK Proto, new events

  dlg_proto_eh(_,_,_):-!,fail.

%END_DLG Proto





