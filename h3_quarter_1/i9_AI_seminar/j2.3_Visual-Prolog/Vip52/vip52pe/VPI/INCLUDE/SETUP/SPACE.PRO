/*****************************************************************************

	(c) Copyright 1984 - 2000 Prolog Development Center A/S

 Project:  SETUP
 FileName: SPACE.PRO
 Purpose: Setup Program
 Written by: Zaichenko Michael
 Comments:
******************************************************************************/
%os2 start 06.09.96
constants
%space_debug_HorBar		=1	%uncomment for debug

  space_idc_ind_req = 108
  space_idct_required2 = 109
  space_idct_required = 110
  space_idct_progresstitle = 111
  space_idct_free = 112
  space_idct_free_val = 113
  space_idc_groupbox = 114
  space_idct_totval = 115
  space_idc_space_indicator_9 = 116


  background_color	= color_black
  normal_color		= color_green
  overflow_color	= color_Red
  procent_color		= color_Red
  procent_over		= color_Black

database - space
  ctrl_space(window Window,integer Id)
  ctrl_val(integer Id,integer Value,string Percent)
  clrl_color(integer Id,COLOR)

  determ full_bar(integer XMAX,integer YMAX)
  determ drive_avail(dword AV,dword TOTAL) 
  determ drive_req(dword)
  determ dlg_space_win(window Dlg,window Req)

%BEGIN_DLG space indicator
/**************************************************************************
	Creation and event handling for dialog: space indicator
**************************************************************************/

constants

%BEGIN space indicator, CreateParms, 18:49:06-28111995, Code automatically updated!
  dlg_space_indicator_DlgType = wd_Modeless
  dlg_space_indicator_Title = ""
ifdef ws_win
  dlg_space_indicator_RCT = rct(100,100,202,170)	% for windows
  dlg_space_indicator_Flags = [wsf_TitleBar,wsf_ClipSiblings,wsf_Invisible]
elsedef
  dlg_space_indicator_Flags = [wsf_TitleBar,wsf_ClipSiblings]
  dlg_space_indicator_RCT = rct(100,100,225,170)	% for os/2
enddef


  dlg_space_indicator_Help = idh_contents
%END space indicator, CreateParms

predicates

  dlg_space_indicator_eh : ehandler
  determ space_setControlId(window,integer) - (i,i)
  determ dlg_space_Create(window) 
clauses
  dlg_space_indicator_Create(_):-
	dlg_space_win(_,_),!,
	dlg_note("DlgSpace already exist!").
ifdef ws_win
  dlg_space_indicator_Create(Parent):-
  	dlg_space_Create(Parent).
elsedef
  dlg_space_indicator_Create(Parent):-
	assert(dlg_space_win(Parent,Parent)).
enddef

  dlg_space_Create(Parent):-
  	
ifdef space_debug_HorBar
	dlg_note("dlg_Space_Indicator_Create!"),
enddef


%MARK space indicator, new variables
	CRCT= dlg_space_indicator_RCT,
	CRCT = rct(DX0,DY0,DX1,DY1),
	X1=DX1-DX0,Y1=DY1-DY0,
  ifdef setup_use_screen
	P1 = cast(window,vpi_getAttrVal(attr_screen_window)),
	PWRC = win_GetOuterRect(P1),
  	PRCT= rect_GetClient([],b_false,PWRC),
  elsedef
	PRCT = win_GetClientRect(Parent),
  enddef
	PRCT = rct(_,_,PX1,_),
	X=PX1-X1,%PY1=Y1,		%aligin window right/top+48
	DRCT=rct(X,0,PX1,Y1),
	dialog_Create(Parent,
		[
%BEGIN space indicator, WinDefList, 18:49:06-28111995, Code automatically updated!
		 dlg(wdef(dlg_space_indicator_DlgType,DRCT,dlg_space_indicator_Title,u_DlgBase),dlg_space_indicator_Flags),
ifdef ws_win
		 customctl(wdef(wc_Custom,rct(11,55,94,65),"",u_DlgBase),"HORITZBAR",space_idc_ind_req,[]),
		 ctl(wdef(wc_Text,rct(10,30,46,38),"Required",u_DlgBase),space_idct_required2,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(48,30,93,38),"Req.Val",u_DlgBase),space_idct_required,[wsf_AlignRight]),
		 ctl(wdef(wc_Text,rct(10,45,94,53),"Percentage of Free Space",u_DlgBase),space_idct_progresstitle,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(10,20,25,28),"Free",u_DlgBase),space_idct_free,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(48,20,93,28),"Free Val",u_DlgBase),space_idct_free_val,[wsf_AlignRight]),
		 ctl(wdef(wc_Text,rct(47,10,93,18),"TotVal",u_DlgBase),space_idct_totval,[wsf_AlignRight]),
		 ctl(wdef(wc_Text,rct(10,10,26,17),"Total",u_DlgBase),space_idc_space_indicator_9,[wsf_AlignLeft]),
		 ctl(wdef(wc_GroupBox,rct(3,0,98,43),"Disk Space",u_DlgBase),space_idc_groupbox,[])
elsedef
		 customctl(wdef(wc_Custom,rct(11,55,117,65),"",u_DlgBase),"HORITZBAR",space_idc_ind_req,[]),
		 ctl(wdef(wc_Text,rct(10,30,46,38),"Required",u_DlgBase),space_idct_required2,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(10,45,120,53),"Percentage of Free Space",u_DlgBase),space_idct_progresstitle,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(10,20,40,28),"Free",u_DlgBase),space_idct_free,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(70,20,116,28),"Free Val",u_DlgBase),space_idct_free_val,[wsf_AlignRight]),
		 ctl(wdef(wc_Text,rct(70,30,116,38),"Req.Val",u_DlgBase),space_idct_required,[wsf_AlignRight]),
		 ctl(wdef(wc_Text,rct(70,10,116,18),"TotVal",u_DlgBase),space_idct_totval,[wsf_AlignRight]),
		 ctl(wdef(wc_Text,rct(10,10,40,17),"Total",u_DlgBase),space_idc_space_indicator_9,[wsf_AlignLeft]),
		 ctl(wdef(wc_GroupBox,rct(3,0,121,43),"Disk Space",u_DlgBase),space_idc_groupbox,[])
enddef	
%END space indicator, WinDefList
		],
  		[
%BEGIN space indicator, ControlList, 18:49:06-28111995, Code automatically updated!
%END space indicator, ControlList
		],
		dlg_space_indicator_eh,0,_,_),!.

/*
%BEGIN space indicator, Update controls, 18:49:06-28111995, Code automatically updated!
%END space indicator, Update controls
*/
%MARK space indicator, new events

%BEGIN space indicator, e_Update
  dlg_space_indicator_eh(_Wi,e_Update(_UpdateRct),0):-
	!,
	%write("spc update begin"),
	getPath(PATH),
	file_GetDiskFree(Path,_,FreeValKb,_),
	drive_Avail(Avail,TOTAL),
	Avail<>FreeValKB,
	space_setAvail(Total,FreeValKb).
%END space indicator, e_Update

%BEGIN space indicator, e_CloseRequest
  dlg_space_indicator_eh(_Win,e_CloseRequest,0):-
	!.
%END space indicator, e_CloseRequest

%BEGIN space indicator, e_Create
  dlg_space_indicator_eh(_Win,e_Create(_CreationData),0):-
	!,
	RWIN = win_GetCtlHandle(_Win, space_idc_ind_req),
	space_setControlId(RWin,2),
	RTWIN = win_GetCtlHandle(_Win,space_idct_required),	%static text
	retractall(dlg_space_win(_,_)),
	assert(dlg_space_win(_Win,RTWIN)),
	getPath(PATH),
	%dlg_note("hello from space: ecrate msg: try disk_space"),
	file_GetDiskFree(Path,_,FreeValKb,_),
	FreeValStr = numberFormat(FreeValKB),
	%term_str ( dword, FreeValKB, FreeValStr ),
	dialog_SetValues(_Win, [dv(space_idct_free_val,statictext(FreeValStr))]).
%dlg_note( "ecrate msg: was done").
%END space indicator, e_Create

  dlg_space_indicator_eh(_Win,e_Destroy(),0):-
	!,	% add by Mz 04.02.97
	retractall(dlg_space_win(_Win,_)).
	

%END_DLG space indicator


%BEGIN_WIN vert bar
constants
space_procent_flags = [dtext_center,dtext_singleline,dtext_vcenter]
space_procent_text_len = -1

predicates
  determ draw_bar(window,dword Val,string Perc)-(i,i,i)
  procedure  draw_bar2(window,integer Y,integer Val)-(i,i,i)
  determ integer get_ElementsCount(ulong Max,ulong Current)
  procedure integer aligin_val(integer Val1,integer Val2)  
  determ rct check_bar_color(ulong Requ,dword Avail,RCT)
  determ rct get_invalidateRect(integer ID ,integer NewVal)
clauses
  aligin_val(Val1,0,Val1):-
	!.
  aligin_val(Val1,_,Val):-
  	Val=Val1+1.
  
  check_bar_color(Requ,Avail,RCT,RCT):-	%no change
		Requ>Avail,
		clrl_color(2,overflow_color),
		!.
		
  check_bar_color(Requ,Avail,RCT,RCT):- %no change
		Requ<=Avail,
		clrl_color(2,normal_color),
		!.
  check_bar_color(Requ,Avail,_,RCT):- %no change
  		Requ>Avail,
  		ctrl_space(Win,2),
  		!,
  		RCT= win_getClientRect(Win),
  		retractall(clrl_color(2,_)),
  		assert(clrl_color(2,overflow_color)),
  		win_setForeColor(Win,procent_over).
  check_bar_color(Requ,Avail,_,RCT):- %no change
  		Requ<=Avail,
  		ctrl_space(Win,2),
  		!,
  		RCT= win_getClientRect(Win),
  		retractall(clrl_color(2,_)),
  		assert(clrl_color(2,normal_color)),
  		win_SetForeColor(Win,procent_color).
 
  get_ElementsCount(0,_,0):-
 	!.	%trap for division by zero
  
  get_ElementsCount(Max,Cur,VAL):-
  	not(Max<Cur),
  	!,
	full_bar(X,_),
	Val1=(Cur*X) div Max,
	Val2=(Cur*X) mod Max,
	Val=aligin_val(Val1,Val2).
  get_ElementsCount(_,_,VAL):-
	full_bar(Val,_).
	
  get_invalidateRect(ID,X,rct(0,0,0,0)):-
	ctrl_val(ID,X,_),
	!,
	retractall(ctrl_val(ID,_,_)).

  get_invalidateRect(ID,_,RCT):-
	not(ctrl_val(ID,_,_)),
	ctrl_space(WIN,ID),
	!,
	RCT=win_GetClientRect(WIN).
  get_invalidateRect(ID,0,RCT):-
	ctrl_space(WIN,ID),
	!,
	RCT=win_GetClientRect(WIN),
	retractall(ctrl_val(ID,_,_)).
  get_invalidateRect(ID,XN,rct(X2,0,X1,Y)):-
  	ctrl_val(ID,XO,_),
	Xn>XO,
	!,
	X2=XO*4-1,X1=Xn*4+1,
	full_bar(_,Y),
	retractall(ctrl_val(ID,_,_)).
  get_invalidateRect(ID,XN,rct(X2,0,X1,Y)):-
	ctrl_val(ID,XO,_),
	Xn<XO,
	!,
  	X2=Xn*4-1,X1=XO*4+1,
	retractall(ctrl_val(ID,_,_)),
	full_bar(_,Y).

predicates		
 determ rct get_textInvalidate(window,integer Id,string NEW_text)
clauses	
  space_setAvail(Total,Avail):-
	retractall(drive_avail(_,_)),
	assert(drive_avail(Avail,TOTAL)),
	drive_req(Requ),
	TotalValStr = numberFormat(Total),
	FreeValStr  = numberFormat(Avail),
	dlg_space_win(_Win,_),
	dialog_SetValues(_Win, [
				dv(space_idct_free_val,statictext(FreeValStr)),
				dv(space_idct_TotVal,statictext(TotalValStr))
				]),
	space_setRequest(Requ).
predicates
  string trap_procent(dword,dword) -procedure(i,i)
clauses 
  trap_procent(Requ,Avail,ProcentTXT):-
	AVAIL>0,
	trap(Procent = val(integer,(Requ*100)/Avail),_,fail),
	Procent<10001,
	!,
	format(ProcentTxt,"% %%",Procent).
  trap_procent(_,_,">10000 %").

  space_setRequest(REQU):-
	dlg_space_win(_DialogWindow,WinR),
	%term_str ( dword, REQU, RqSTR ), %str_long(RqSTR,REQU),
	RqSTR = numberFormat(REQU),
	win_SetText(WinR,RqSTR),
	drive_avail(Avail,_TOTAL),
	retractall(drive_req(_)),
	assert(drive_req(Requ)),
	BAR=get_ElementsCount(AVAIL,REQU),
	ctrl_space(WIN,2),
	ProcentTxt =trap_procent(Requ,Avail),
	Trct=get_textInvalidate(Win,2,ProcentTxt),
	IRCT = get_invalidateRect(2,BAR),
	assert(ctrl_val(2,BAR,ProcentTxt)),
	!,
	RCTi= check_bar_color(Requ,Avail,IRCT),
	win_invalidate(Win,TRct),
	win_invalidate(Win,RCTi).
	
predicates
  integer max(integer,integer)-procedure(i,i)
clauses
  max(A,B,A):-
  	A>B,!.
  max(_,B,B).

  get_textInvalidate(_,Id,_,rct(0,0,0,0)):-
	not(ctrl_val(Id,_,_)),
	!.
  get_textInvalidate(_,Id,Str,rct(0,0,0,0)):-
  	ctrl_Val(Id,_,Str),
  	!.
  get_textInvalidate(Win,Id,Str1,rct(Nx1,Ny1,Nx2,Ny2)):-
	ctrl_Val(Id,_,Str2),
	!,
	Rct=win_getClientRect(Win),
	RCT=rct(_,_,X,Y),
	win_GetTextExtent(WIN,Str1,-1,W1,H1),
	win_GetTextExtent(WIN,Str2,-1,W2,_),
	WM=max(W1,W2),
	HX=X div 2,HY=Y div 2,
	Hw1=WM div 2,HH1=H1 div 2,
	Nx1=Hx-Hw1-1,Ny1=Hy-HH1-1,
	Nx2=Hx+Hw1+1,Ny2=Hy+HH1+1.
	
  draw_bar(Win,Val,ProcentTxt):-
	ctrl_space(WIN,Id),
	RCT=win_getClientRect(Win),
	full_bar(_XM,YM),
	clrl_color(ID,COLOR),
	win_setDrawMode(WIN,dm_CopyPen),
	win_clear(Win,background_color),
	win_setPen(WIN,pen(1,ps_hollow,COLOR)),
	win_setBrush(WIN,brush(pat_solid,COLOR)),
	Y=Ym-1,
	draw_bar2(WIN,Y,VAL),
	draw_TextInRect(Win,RCT,ProcentTxt,-1,space_procent_flags),
	!.
 
  draw_bar2(Win,Y,X):-
	X>0,
	XD=X*4,XD2=XD-4,
  	draw_rect(Win,rct(XD2,1,XD,Y)),
  	Xn=X-1,
  	!,
	draw_bar2(Win,Y,Xn).
  draw_bar2(_,_,_).
/**************************************************************************
        Creation and event handling for window: vert bar
**************************************************************************/
predicates

 win_vert_bar_eh : ehandler

clauses
%BEGIN vert bar, e_Create
  win_vert_bar_eh(_Win,e_Create(_),0):-
	!,
	not(full_bar(_,_)),
	RCT=win_GetClientRect(_Win),
	RCT=rct(_,_,X,Y),
	XS=X div 4,		%one bar element have 4 pixels
	assert(full_Bar(XS,Y)),
	win_setForecolor(_Win,procent_color),
	win_setBackMode(_Win,bk_Transparent),
	win_invalidate(_Win).
%END vert bar, e_Create

%BEGIN vert bar, e_EraseBackGround
  win_vert_bar_eh(_Win,e_EraseBackGround,0):-
	!.
%END vert bar, e_EraseBackGround

%BEGIN vert bar, e_Update
  win_vert_bar_eh(_Win,e_Update(rct(0,0,0,0)),0):-
	!.
  win_vert_bar_eh(Win,e_Update(_),0):-
	!,
ifdef space_debug_HorBar
	dlg_note("horitzbar-space-update"),
	save("space_DB",space),
	term_str(window,Win,SW),
	file_STR("SPACE_w",SW),
enddef
	ctrl_space(WIN,Id),
	ctrl_val(Id,Val,Str),
	!,
ifdef space_debug_HorBar
	dlg_note("horitzbar-space-startdrawbar"),
enddef
	draw_bar(Win,Val,Str).
ifdef space_debug_HorBar
	dlg_note("horitzbar-space- enddrawbar"),
enddef
%END vert bar, e_Update

%BEGIN vert bar, e_Destroy
  win_vert_bar_eh(_Win,e_Destroy,0):-
	retractall(ctrl_space(_WIN,_)),
	!.
%END vert bar, e_Destroy


%END_WIN vert bar

clauses
  space_register:-
	class_Create("HORITZBAR",win_vert_bar_eh),
	assert(drive_req(1)),
	assert(drive_avail(3,4)),
	assert(clrl_color(2,normal_color)).
 
  space_unregister:-
	class_Destroy("HORITZBAR"),
	retractall(drive_req(_)),
	retractall(drive_avail(_,_)),
	retractall(full_bar(_,_)),
	retractall(clrl_color(_,_)).
	

  space_setControlId(Win,ID):-
	assert(ctrl_space(WIN,Id)).

  space_SetDialogVisible():-
	dlg_space_win(Parent,Parent2),
	Parent=Parent2,
	!,
  	dlg_space_Create(Parent).

  space_SetDialogVisible():-
	dlg_space_win(Win,_),
	!,
	win_SetState(Win,[wsf_Visible]).
  space_SetDialogVisible().

  space_removeDlg():-
	dlg_space_win(Win,_),
	win_Destroy(Win),
	!.
  space_removeDlg().	
