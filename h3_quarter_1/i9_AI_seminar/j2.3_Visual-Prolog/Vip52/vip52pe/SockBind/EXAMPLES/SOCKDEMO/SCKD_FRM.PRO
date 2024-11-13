/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  SCKD_FRM
 FileName: SCKD_FRM.PRO
 Purpose: No description
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/
PREDICATES
  form_case(WINDOW,INTEGER) - (i,i)
  
CLAUSES

  form_case(Win,id_sck_aselecttimeout1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_ASelectTimeOut( SCK_SELECT_TIMEVAL TimeOut ) - (i),(o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(5,50,70,60),"TimeOut - seconds",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(5,70,85,80),"TimeOut - microseconds",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_asetnotifyfns1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_NOTIFY_FNS sck_ASetNotifyFNS( SCK_NOTIFY_FNS NotifyFNS ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(10,50,70,60),"NotifyFNS",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(10,70,70,80),"SCK_NOTIFY_FNS",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"app_notifyFNS",u_DlgBase),control1,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_cancelblockingcall0):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_CancelBlockingCall()"),
  	!.
  form_case(Win,id_sck_unhookblockinghook0):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_UnhookBlockingHook()"),
  	!.
  form_case(Win,id_sck_isblocking0):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"BOOLEAN sck_IsBlocking()"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"BOOLEAN",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_setblockinghook1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_BLOCKFUNC sck_SetBlockingHook( SCK_BLOCKFUNC BlockingFunction ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(10,50,70,60),"BlockingFunction",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(10,70,70,80),"SCK_BLOCKFUNC",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"app_hook",u_DlgBase),control1,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_cancelasyncrequest1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_CancelAsyncRequest( SCK_HANDLE Handle ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Handle",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_getasynchostent1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_HOSTENT sck_GetAsyncHostent( SCK_HANDLE Handle ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Handle",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_getasyncprotoent1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_PROTOENT sck_GetAsyncProtoent( SCK_HANDLE Handle ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Handle",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_getasyncservent1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_SERVENT sck_GetAsyncServent( SCK_HANDLE Handle ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Handle",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_getasyncerror1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_ERROR sck_GetAsyncError( LONG LParam ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"LParam",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"SCK_ERROR",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_getasyncbuflen1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"UNSIGNED sck_GetAsyncBuflen( LONG LParam ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"LParam",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"UNSIGNED",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_asyncgethostbyname4):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	PWin = vpi_GetTaskWin(),
	Win_uns = cast(UNSIGNED,PWin),
	term_str(UNSIGNED,Win_uns,Win_str),
  	term_str(UNSIGNED,app_AHByName,Mes_str),
  	win_SetText(CtrlWin,"SCK_HANDLE sck_AsyncGetHostByName(SCK_HWND Window, UNSIGNED Msg, STRING HostName, INTEGER Buflen) - (i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Window",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Msg",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"HostName",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,70,120),"Buflen",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"SCK_HANDLE",u_DlgBase),control5_t,[]),		 
		 ctl(wdef(wc_Edit,rct(90,50,170,60),Win_str,u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),Mes_str,u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control5,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_asyncgethostbyaddr5):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	PWin = vpi_GetTaskWin(),
	Win_uns = cast(UNSIGNED,PWin),
	term_str(UNSIGNED,Win_uns,Win_str),
  	term_str(UNSIGNED,app_AHByAddr,Mes_str),
  	win_SetText(CtrlWin,"SCK_HANDLE sck_AsyncGetHostByAddr(SCK_HWND Window, UNSIGNED Msg, SCK_IN_ADDR Address, INTEGER Type, INTEGER Buflen) - (i,i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Window",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Msg",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"Address",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"Type",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,70,240,80),"Buflen",u_DlgBase),control5_t,[]),
		 ctl(wdef(wc_Text,rct(190,90,240,100),"SCK_HANDLE",u_DlgBase),control6_t,[]),		 
		 ctl(wdef(wc_Edit,rct(90,50,170,60),Win_str,u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),Mes_str,u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control4,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,70,340,80),"",u_DlgBase),control5,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,90,340,100),"",u_DlgBase),control6,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_asyncgetprotobyname4):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	PWin = vpi_GetTaskWin(),
	Win_uns = cast(UNSIGNED,PWin),
	term_str(UNSIGNED,Win_uns,Win_str),
  	term_str(UNSIGNED,app_APByName,Mes_str),
  	win_SetText(CtrlWin,"SCK_HANDLE sck_AsyncGetProtoByName(SCK_HWND Window, UNSIGNED Msg, STRING ProtoName, INTEGER Buflen) - (i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Window",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Msg",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"ProtoName",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,70,120),"Buflen",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"SCK_HANDLE",u_DlgBase),control5_t,[]),		 
		 ctl(wdef(wc_Edit,rct(90,50,170,60),Win_str,u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),Mes_str,u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control5,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_asyncgetprotobynumber4):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	PWin = vpi_GetTaskWin(),
	Win_uns = cast(UNSIGNED,PWin),
	term_str(UNSIGNED,Win_uns,Win_str),
  	term_str(UNSIGNED,app_APByNumber,Mes_str),
  	win_SetText(CtrlWin,"SCK_HANDLE sck_AsyncGetProtoByNumber(SCK_HWND Window, UNSIGNED Msg, INTEGER ProtoNumber, INTEGER Buflen) - (i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Window",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Msg",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"ProtoNumber",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,70,120),"Buflen",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"SCK_HANDLE",u_DlgBase),control5_t,[]),		 
		 ctl(wdef(wc_Edit,rct(90,50,170,60),Win_str,u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),Mes_str,u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control5,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_asyncgetservbyname4):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	PWin = vpi_GetTaskWin(),
	Win_uns = cast(UNSIGNED,PWin),
	term_str(UNSIGNED,Win_uns,Win_str),
  	term_str(UNSIGNED,app_ASByName4,Mes_str),
  	win_SetText(CtrlWin,"SCK_HANDLE sck_AsyncGetServByName(SCK_HWND Window, UNSIGNED Msg, STRING ServName, INTEGER Buflen) - (i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Window",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Msg",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"ServName",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,70,120),"Buflen",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"SCK_HANDLE",u_DlgBase),control5_t,[]),		 
		 ctl(wdef(wc_Edit,rct(90,50,170,60),Win_str,u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),Mes_str,u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control5,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_asyncgetservbyname5):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	PWin = vpi_GetTaskWin(),
	Win_uns = cast(UNSIGNED,PWin),
	term_str(UNSIGNED,Win_uns,Win_str),
  	term_str(UNSIGNED,app_ASByName5,Mes_str),
  	win_SetText(CtrlWin,"SCK_HANDLE sck_AsyncGetServByName(SCK_HWND Window, UNSIGNED Msg, STRING ServName, STRING ProtoName, INTEGER Buflen) - (i,i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Window",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Msg",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"ServName",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"ProtoName",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,70,240,80),"Buflen",u_DlgBase),control5_t,[]),
		 ctl(wdef(wc_Text,rct(190,90,240,100),"SCK_HANDLE",u_DlgBase),control6_t,[]),		 
		 ctl(wdef(wc_Edit,rct(90,50,170,60),Win_str,u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),Mes_str,u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control4,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,70,340,80),"",u_DlgBase),control5,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,90,340,100),"",u_DlgBase),control6,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_asyncgetservbyport4):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	PWin = vpi_GetTaskWin(),
	Win_uns = cast(UNSIGNED,PWin),
	term_str(UNSIGNED,Win_uns,Win_str),
  	term_str(UNSIGNED,app_ASByPort4,Mes_str),
  	win_SetText(CtrlWin,"SCK_HANDLE sck_AsyncGetServByPort(SCK_HWND Window, UNSIGNED Msg, INTEGER ServPort, INTEGER Buflen) - (i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Window",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Msg",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"ServPort",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,70,120),"Buflen",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"SCK_HANDLE",u_DlgBase),control5_t,[]),		 
		 ctl(wdef(wc_Edit,rct(90,50,170,60),Win_str,u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),Mes_str,u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control5,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_asyncgetservbyport5):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	PWin = vpi_GetTaskWin(),
	Win_uns = cast(UNSIGNED,PWin),
	term_str(UNSIGNED,Win_uns,Win_str),
  	term_str(UNSIGNED,app_ASByPort5,Mes_str),
  	win_SetText(CtrlWin,"SCK_HANDLE sck_AsyncGetServByPort(SCK_HWND Window, UNSIGNED Msg, INTEGER ServPort, STRING ProtoName, INTEGER Buflen) - (i,i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Window",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Msg",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"ServPort",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"ProtoName",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,70,240,80),"Buflen",u_DlgBase),control5_t,[]),
		 ctl(wdef(wc_Text,rct(190,90,240,100),"SCK_HANDLE",u_DlgBase),control6_t,[]),		 
		 ctl(wdef(wc_Edit,rct(90,50,170,60),Win_str,u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),Mes_str,u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control4,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,70,340,80),"",u_DlgBase),control5,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,90,340,100),"",u_DlgBase),control6,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_accept1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SOCKET sck_Accept( SOCKET	ListenSocket ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"ListenSocket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"SOCKET",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_accept2):-
	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SOCKET sck_Accept( SOCKET ListenSocket, SCK_ADDRESS AcceptAddr ) - (i,o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"ListenSocket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"SOCKET",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"AcceptAddr",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,90,160,100),"",u_DlgBase),control3,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_splitaddress_in4):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_SplitAddress_IN( SCK_ADDRESS Address, SCK_FAMILY Sin_Family, SCK_PORT Sin_Port, SCK_IN_ADDR Sin_Addr ) - (i,o,o,o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"SCK_ADDRESS",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Sin_Family",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"Sin_Port",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,70,120),"Sin_Addr",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,90,160,100),"",u_DlgBase),control3,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,110,160,120),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_mergeaddress_in3):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_ADDRESS sck_MergeAddress_IN( SCK_FAMILY  Sin_Family, SCK_PORT Sin_Port, SCK_IN_ADDR Sin_Addr ) - (i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Sin_Family",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Sin_Port",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"Sin_Addr",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,70,120),"SCK_ADDRESS",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,90,160,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,110,160,120),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_splitaddress3):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_SplitAddress( SCK_ADDRESS Address, SCK_FAMILY Sa_Family, BINARY Sa_Data ) - (i,o,o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Address",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Sa_Family",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"Sa_Data",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,90,160,100),"",u_DlgBase),control3,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_mergeaddress2):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_ADDRESS sck_MergeAddress( SCK_FAMILY Sa_Family, BINARY Sa_Data ) - (i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Sa_Family",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Sa_data",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"SCK_ADDRESS",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,90,160,100),"",u_DlgBase),control3,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_asyncselect4):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	PWin = vpi_GetTaskWin(),
	Win_uns = cast(UNSIGNED,PWin),
	term_str(UNSIGNED,Win_uns,Win_str),
  	term_str(UNSIGNED,app_mes,Mes_str),
	win_SetText(CtrlWin,"sck_AsyncSelect( SOCKET Socket, SCK_HWND Window, UNSIGNED Msg, SCK_EVENTS_LIST EventsList ) - (i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Window",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"Msg",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,90,120),"SCK_EVENTS_LIST",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),Win_str,u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),Mes_Str,u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_inetaddr1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_IN_ADDR sck_InetAddr( STRING DottedAddr ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"DottedAddr",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"SCK_IN_ADDR",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_inetntoa1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"STRING sck_InetNtoa( SCK_IN_ADDR AddrIN ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"AddrIN",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"STRING",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_bind2):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_Bind( SOCKET UnboundSocket, SCK_ADDRESS Name )	- (i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"UnboundSocket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Name",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_cleanup0):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_Cleanup()"),
  	!.
  form_case(Win,id_sck_closesocket1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_CloseSocket( SOCKET Socket ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_connect2):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_Connect( SOCKET Socket, SCK_ADDRESS Name ) - (i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Name",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_gethostbyaddr2):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_HOSTENT sck_GetHostByAddr( SCK_IN_ADDR Address, INTEGER Type ) - (i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Address",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Type",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_gethostbyname1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_HOSTENT sck_GetHostByName( STRING HostName ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"HostName",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_gethostname1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"STRING sck_GetHostName( INTEGER ReqNameLen ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"ReqNameLen",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"STRING",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),  	
  	!.
  form_case(Win,id_sck_getlastnetdberror0):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_ERROR sck_GetLastNetDbError()"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"SCK_ERROR",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_getlasterror0):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_ERROR sck_GetLastError()"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"SCK_ERROR",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_getpeername1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_ADDRESS sck_GetPeerName( SOCKET Socket ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"SCK_ADDRESS",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),  	
  	!.
  form_case(Win,id_sck_getprotobyname1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_PROTOENT sck_GetProtoByName( STRING ProtoName ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"ProtoName",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_getprotobynumber1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_PROTOENT sck_GetProtoByNumber( INTEGER ProtoNumber ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"ProtoNumber",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_getselecterror1):-
	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_ERROR sck_GetSelectError( LONG LParam ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"LParam",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"SCK_ERROR",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_getselectevent1):-
	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_EVENT sck_GetSelectEvent( LONG LParam ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"LParam",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"SCK_EVENT",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),  
	!.
  form_case(Win,id_sck_getservbyname1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_SERVENT sck_GetServByName( STRING ServiceName ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"ServiceName",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),  
  	!.
  form_case(Win,id_sck_getservbyname2):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_SERVENT sck_GetServByName( STRING ServiceName, STRING ProtocolName ) - (i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"ServiceName",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"ProtocolName",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),  	
  	!.
  form_case(Win,id_sck_getservbyport1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_SERVENT sck_GetServByPort( INTEGER Port ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Port",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_getservbyport2):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_SERVENT sck_GetServByPort( INTEGER Port, STRING  ProtocolName) - (i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Port",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"ProtocolName",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_getsockname1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_ADDRESS sck_GetSockName( SOCKET Socket ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"SCK_ADDRESS",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_getsockopt3):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SCK_OPTION sck_GetSockOpt( SOCKET Socket, SCK_OPTION_LEVEL OptionLevel, SCK_OPTION_NAME OptionName ) - (i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"OptionLevel",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"OptionName",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,90,120),"SCK_OPTION",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_htonl1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"ULONG sck_Htonl( ULONG HostLong ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"HostLong",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"ULONG",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_htons1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"USHORT sck_Htons( USHORT HostShort ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"HostShort",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"USHORT",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_ntohl1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"ULONG sck_Ntohl( ULONG NetLong ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"NetLong",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"ULONG",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_ntohs1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"USHORT sck_Ntohs( USHORT NetShort ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"NetShort",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"USHORT",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.  	  	  	
  form_case(Win,id_sck_ioctlset3):-
    	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_IoctlSet( SOCKET Socket, SCK_IOCTL_COMMAND Command, ULONG Argument ) - (i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Command",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"Argument",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,90,160,100),"",u_DlgBase),control3,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_ioctlget2):-
    	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"ULONG sck_IoCtlGet( SOCKET Socket, SCK_IOCTL_COMMAND Command ) - (i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Command",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"ULONG",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,90,160,100),"",u_DlgBase),control3,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_listen2):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_Listen( SOCKET Socket, INTEGER BackLog ) - (i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"BackLog",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_recv4):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_Recv( SOCKET Socket, INTEGER RecvLength, SCK_FLAGS_LIST RecvFlags, BINARY RecvBuffer ) - (i,i,i,o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"RecvLength",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"RecvFlags",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,90,120),"RecvBuffer",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_recv_dg4):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_Recv_DG( SOCKET Socket, INTEGER RecvLength, SCK_FLAGS_LIST RecvFlags, BINARY RecvBuffer ) - (i,i,i,o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"RecvLength",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"RecvFlags",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,90,120),"RecvBuffer",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_recvfrom5):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_RecvFrom( SOCKET Socket, INTEGER RecvLength, SCK_FLAGS_LIST RecvFlags, SCK_ADDRESS FromAddr, BINARY RecvBuffer) - (i,i,i,o,o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"RecvLength",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"RecvFlags",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"FromAddr",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,70,240,80),"RecvBuffer",u_DlgBase),control5_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,70,340,80),"",u_DlgBase),control5,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_recvfrom_dg5):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_RecvFrom_DG( SOCKET Socket, INTEGER RecvLength, SCK_FLAGS_LIST RecvFlags, SCK_ADDRESS FromAddr, BINARY RecvBuffer) - (i,i,i,o,o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"RecvLength",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"RecvFlags",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"FromAddr",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,70,240,80),"RecvBuffer",u_DlgBase),control5_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,70,340,80),"",u_DlgBase),control5,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.  	
  form_case(Win,id_sck_select6):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_Select(SOCKETS_LIST In_ReadFds, SOCKETS_LIST In_WriteFds, SOCKETS_LIST In_ExceptFds, SOCKETS_LIST Out_ReadFds, SOCKETS_LIST Out_WriteFds, SOCKETS_LIST Out_ExceptFds ) - (i,i,i,o,o,o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"In_ReadFds",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"In_WriteFds",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"In_ExceptFds",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"Out_ReadFds",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,70,240,80),"Out_WriteFds",u_DlgBase),control5_t,[]),
		 ctl(wdef(wc_Text,rct(190,90,240,100),"Out_ExceptFds",u_DlgBase),control6_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,70,340,80),"",u_DlgBase),control5,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,90,340,100),"",u_DlgBase),control6,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.  	
  form_case(Win,id_sck_select7):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_Select(SOCKETS_LIST In_ReadFds, SOCKETS_LIST In_WriteFds, SOCKETS_LIST In_ExceptFds, SCK_SELECT_TIMEVAL TimeOut, SOCKETS_LIST Out_ReadFds, SOCKETS_LIST Out_WriteFds, SOCKETS_LIST Out_ExceptFds ) - (i,i,i,i,o,o,o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"In_ReadFds",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"In_WriteFds",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"In_ExceptFds",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,90,120),"TimeOut - seconds",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(180,50,260,60),"TimeOut - microseconds",u_DlgBase),control5_t,[]),
		 ctl(wdef(wc_Text,rct(190,70,240,80),"Out_ReadFds",u_DlgBase),control6_t,[]),
		 ctl(wdef(wc_Text,rct(190,90,240,100),"Out_WriteFds",u_DlgBase),control7_t,[]),
		 ctl(wdef(wc_Text,rct(190,110,240,120),"Out_ExceptFds",u_DlgBase),control8_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control5,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,70,340,80),"",u_DlgBase),control6,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,90,340,100),"",u_DlgBase),control7,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,110,340,120),"",u_DlgBase),control8,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_send3):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"INTEGER sck_Send( SOCKET Socket, BINARY DataToSend, SCK_FLAGS_LIST SendFlags ) - (i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"DataToSend",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"SendFlags",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,90,120),"INTEGER",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),	
  	!.
  form_case(Win,id_sck_sendto4):-
    	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"INTEGER sck_SendTo( SOCKET Socket, BINARY DataToSend, SCK_FLAGS_LIST SendFlags, SCK_ADDRESS ToAddress ) - (i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"DataToSend",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"SendFlags",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,90,120),"ToAddress",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"INTEGER",u_DlgBase),control5_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control5,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_setlasterror1):-
	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_SetLastError( SCK_ERROR ErrorCode ) - (i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,80,60),"ErrorCode",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),  	
  	!.
  form_case(Win,id_sck_setsockopt4):-
    	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_SetSockOpt( SOCKET Socket, SCK_OPTION_LEVEL OptionLevel, SCK_OPTION_NAME OptionName, SCK_OPTION OptionValue ) - (i,i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"OptionLevel",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"OptionName",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,90,120),"OptionValue",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_shutdown2):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_ShutDown( SOCKET Socket, INTEGER How ) - (i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"Socket",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"How",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Edit,rct(80,50,160,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(80,70,160,80),"",u_DlgBase),control2,[wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
  form_case(Win,id_sck_socket3):-
    	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"SOCKET sck_Socket( INTEGER AddrFamily, INTEGER Type, INTEGER Protocol ) - (i,i,i)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,70,60),"AddrFamily",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Type",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"Protocol",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,90,120),"SOCKET",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
	!.
  form_case(Win,id_sck_startup0):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_Startup()"),
  	!.
  form_case(Win,id_sck_startup1):-
  	CtrlWin = win_GetCtlHandle(Win,idct_descr),
	win_SetText(CtrlWin,"sck_Startup( WORD VersionRequested, SCK_WSA_DATA WSA_Data, INTEGER RetCode) - (i,o,o)"),
	CNTLIST=[ctl(wdef(wc_Text,rct(20,50,80,60),"VersionRequested",u_DlgBase),control1_t,[]),
		 ctl(wdef(wc_Text,rct(20,70,70,80),"Version",u_DlgBase),control2_t,[]),
		 ctl(wdef(wc_Text,rct(20,90,70,100),"HighVersion",u_DlgBase),control3_t,[]),
		 ctl(wdef(wc_Text,rct(20,110,70,120),"Description",u_DlgBase),control4_t,[]),
		 ctl(wdef(wc_Text,rct(190,50,240,60),"SystemStatus",u_DlgBase),control5_t,[]),
		 ctl(wdef(wc_Text,rct(190,70,240,80),"MaxSockets",u_DlgBase),control6_t,[]),
		 ctl(wdef(wc_Text,rct(190,90,240,100),"MaxUdpDg",u_DlgBase),control7_t,[]),
		 ctl(wdef(wc_Text,rct(190,110,240,120),"VendorInfo",u_DlgBase),control8_t,[]),
		 ctl(wdef(wc_Edit,rct(90,50,170,60),"",u_DlgBase),control1,[wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,70,170,80),"",u_DlgBase),control2,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,90,170,100),"",u_DlgBase),control3,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(90,110,170,120),"",u_DlgBase),control4,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,50,340,60),"",u_DlgBase),control5,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,70,340,80),"",u_DlgBase),control6,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,90,340,100),"",u_DlgBase),control7,[wsf_ReadOnly,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,rct(260,110,340,120),"",u_DlgBase),control8,[wsf_ReadOnly,wsf_AutoHScroll])
		],
	win_CreateDynControl(CNTLIST,Win),
  	!.
