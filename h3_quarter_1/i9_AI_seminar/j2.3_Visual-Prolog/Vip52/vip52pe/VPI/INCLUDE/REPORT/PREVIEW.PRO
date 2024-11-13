/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	PREVIEW.PRO
 Purpose:	Preview Window Handler
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
*****************************************************************************/
database - preview
determ prevwin(WINDOW)
determ sheet(INTEGER)
determ max_Y(INTEGER,BOOLEAN)
determ origin_XY(INTEGER,INTEGER)
determ scaling(INTEGER,INTEGER,INTEGER,INTEGER,INTEGER)
determ creation(REPORT,PROCESS_PRED)
determ printing_in_progress
determ dynamical_printing(STRING,INTEGER,INTEGER,INTEGER)
determ re_page_in_process(INTEGER)
	timerId(WINDOW Win,LONG Id,INTEGER)
	printDlgParam(INTEGER,INTEGER,INTEGER)
determ save_path(STRING) 

constants
  win_report_out_WinType = w_TopLevel
  win_report_out_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  win_report_out_Menu = no_menu

  control_Height	= 24
	c_VScroll 	= 3
	c_HScroll 	= 4
	c_Home		= 5
	c_PageUp	= 6
	c_PageDown 	= 7
	c_End		= 8
	idst_vol	= 9
	idst_page 	= 10
	c_Exit		= 11
	c_Print 	= 12
	c_Zoom		= 13
	c_Save		= 14
	c_reBar		= 15

ifdef use_rtf_converter
        re_ButtonsWidth = 303
elsedef
        re_ButtonsWidth = 278
enddef
	c_C		= 67
	c_P		= 80
	c_Z		= 90
	
ifndef win_report_Page
  win_report_Page = "Page"
enddef
ifndef start_job_Label
  start_job_Label = "Printing current document page ..."
enddef


/*
*
*	OWNER DRAW Buttons Control, Drawing
*
\****************************************************************************/
predicates
procedure re_ownerdraw_CreateControl(WINTYPE,UNSIGNED,RCT,STRING,WINDOW)
procedure re_ownerdraw_DrawButton(OD_ITEMACTION,OD_ITEMSTATE,RCT,WINDOW,RESID)
procedure re_draw_up_push_button(WINDOW,RCT,RESID)
procedure re_draw_down_push_button(WINDOW,RCT,RESID)
determ re_own_member(OD_ITEMSTATE,OD_STATE)
determ re_own_member(OD_ITEMACTION,OD_ACTION)
clauses
  re_ownerdraw_CreateControl(wc_PushButton,CtlId,OwnRCT,Title,ParentWin):-
	win_CreateDynControl([ctl(wdef(wc_PushButton,OwnRCT,Title,u_Pixels),
        	CtlId,[ctl_OwnerDraw,ctl_AlignCenter])],ParentWin),!.

  re_ownerdraw_CreateControl(_,_,_,_,_).

  re_ownerdraw_DrawButton(ACTIONLIST,_,RECT,W,ICON_ID):- 
	re_own_member(ACTIONLIST,odact_DrawEntire),
 	re_draw_up_push_button(W,RECT,ICON_ID),!.

  re_ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,W,ICON_ID):- 
	re_own_member(ACTIONLIST,odact_Select),
	re_own_member(STATELIST,odstate_Focus),
	re_own_member(STATELIST,odstate_Selected),
	re_draw_down_push_button(W,RECT,ICON_ID),!.
	
  re_ownerdraw_DrawButton(_,STATELIST,RECT,W,ICON_ID):- 
	re_own_member(STATELIST,odstate_Focus),
 	re_draw_up_push_button(W,RECT,ICON_ID),
	!.
	
  re_ownerdraw_DrawButton(_,_,_,_,_).

 re_draw_up_push_button(W,RECT,ICON_ID):-
	Rect = rct(_,_,Wid,Hei),
	BACK = win_GetAttrVal(W,attr_color_btnface),
	win_SetBrush(W,brush(pat_Solid,BACK)),
	draw_Rect(W,Rect),
ifdef os_os2
	draw_Icon(W,-2,-2,ICON_ID),
elsedef
	draw_Icon(W,0,0,ICON_ID),
enddef
	win_SetPen(W,pen(2,ps_solid,color_White)),
	RT = Wid - 2, LB = Hei - 2,
	draw_PolyLine(W,[pnt(RT,2),pnt(2,2),pnt(2,LB)]),
	win_SetPen(W,pen(1,ps_solid,color_Gray)),
	draw_PolyLine(W,[pnt(3,LB),pnt(RT,LB),pnt(RT,3)]),
	win_SetPen(W,pen(1,ps_solid,color_Black)),
	win_SetBrush(W,brush(pat_Hollow,color_LtGray)),
	draw_Rect(W,rct(0,0,WID,HEI)).

 re_draw_down_push_button(W,RECT,ICON_ID):-
	win_SetPen(W,pen(1,ps_solid,color_Black)),
	BACK = win_GetAttrVal(W,attr_color_btnface),
	win_SetBrush(W,brush(pat_Solid,BACK)),
	draw_Rect(W,RECT),
ifdef os_os2
	draw_Icon(W,0,0,ICON_ID),
elsedef
	draw_Icon(W,2,2,ICON_ID),
enddef
  	!.
  	

  re_own_member([X|_],X):-!.
  re_own_member([_|T],X):-re_own_member(T,X).

database - d_zoom
  zoom_exists(WINDOW)
predicates
determ	add_Y(INTEGER,INTEGER,INTEGER)
procedure set_max_Y(INTEGER,INTEGER)
procedure correct_Y(INTEGER,INTEGER,INTEGER,INTEGER)
procedure proc_HScroll(INTEGER,INTEGER)
procedure change_origin_X(INTEGER,INTEGER)
procedure change_origin_Y(INTEGER,INTEGER)
ifndef  rep_avoid_mousedown
procedure change_origin_Y1(INTEGER)
procedure change_origin_XY(WINDOW,PNT)
enddef
procedure write_Page(WINDOW)
procedure code_position(BOOLEAN VertHor,SCROLLCODE,INTEGER,INTEGER)
procedure process_key(WINDOW,INTEGER,INTEGER)
procedure errors_reflect(ERR_IDENT)
clauses
  add_Y(-1,_,0):-
  	prevwin(WIN),
  	win_PostEvent(WIN,e_CloseRequest),
	retractall(_,keep),
	retractall(_,temporary),
	!,fail.
  	
  add_Y(0,_,0):-
  	page(PAGE,_),
  	retract(sheet(_)),
  	assert(sheet(PAGE)),
  	!.
  add_Y(Y,Z,RET):-
  	RET = abs(Y) + Z.
  set_max_Y(_,_):-
	retract(max_Y(_,_)),
	fail.
  set_max_Y(MAX_Y,S):-
  	S > 0,
  	assert(max_Y(MAX_Y,b_false)),
  	!.
  set_max_Y(MAX_Y,_):-
  	assert(max_Y(MAX_Y,b_true)),
  	!.
  correct_Y(H,MAX_Y,Y,Y):-
  	Y <= MAX_Y-trunc(0.8*H), !.
  correct_Y(H,MAX_Y,_,Y):-
  	Y = MAX_Y - trunc(0.8*H),
  	Y >= 0, !.
  correct_Y(_,_,_,0):-!.
  
  proc_HScroll(X,DELTA):-
 	X < 0,
        retract(origin_XY(OLD,Y)),
        assert(origin_XY(0,Y)),
        DELTA = - OLD,
        !.
  proc_HScroll(X,DELTA):-
	X > 600,
        retract(origin_XY(OLD,Y)),
        assert(origin_XY(600,Y)),
	DELTA = 600 - OLD,
	!.
  proc_HScroll(X,DELTA):-
        retract(origin_XY(OLD,Y)),
        assert(origin_XY(X,Y)),
	DELTA = X - OLD,
	!.
  proc_HScroll(_,0).

  change_origin_X(Delta_X,DELTA):-
        origin_XY(X,_),
  	NEW_X = X + Delta_X,
  	proc_HScroll(NEW_X,DELTA),
        origin_XY(XX,_),
	prevwin(WIN),
	POS = val(INTEGER,(100.0*XX/600)),
	trap(W_HS =win_GetCtlHandle(WIN, c_HScroll),_,fail),
	win_SetScrollPos(W_HS,sb_Ctl, POS),
	!.
  change_origin_X(_,0).

  change_origin_Y(_,0):-
  	zoom_exists(_), !.
  change_origin_Y(Delta_Y,DY):-
        origin_XY(_,Y),
        NEW_Y = Y + Delta_Y,
        NEW_Y >= 0,
	max_Y(MAX_Y,_),
	prevwin(WIN),
	RCT=win_GetClientRect(WIN),
	RCT = rct(_,_,_,H), HH = H - control_Height,
	correct_Y(HH,MAX_Y,NEW_Y,Y_Y),
	DY = Y_Y - Y,
        retract(origin_XY(X,_)),
        assert(origin_XY(X,Y_Y)),
	POS = val(INTEGER,(100.0*Y_Y/(MAX_Y-0.8*HH))),             
	W_VS =win_GetCtlHandle(WIN, c_VScroll),
	win_SetScrollPos(W_VS,sb_Ctl, POS),
        !.
  change_origin_Y(_,YY):-
        retract(origin_XY(X,Y)),
        assert(origin_XY(X,0)),
	YY = -Y,
	prevwin(WIN),
	W_VS =win_GetCtlHandle(WIN, c_VScroll),
	win_SetScrollPos(W_VS,sb_Ctl, 0),
	!.

  change_origin_Y(_,0).
  
ifndef  rep_avoid_mousedown
  change_origin_Y1(Delta_Y):-
        origin_XY(_,Y),
        NEW_Y = Y + Delta_Y,
        NEW_Y >= 0,
	max_Y(MAX_Y,_),
	prevwin(WIN),
	RCT=win_GetClientRect(WIN),
	RCT = rct(_,_,_,H), HH = H - control_Height,
	correct_Y(HH,MAX_Y,NEW_Y,Y_Y),
        retract(origin_XY(X,_)),
        assert(origin_XY(X,Y_Y)),
        !.
  change_origin_Y1(_):-
        retract(origin_XY(X,_)),
        assert(origin_XY(X,0)),
	!.

  change_origin_Y1(_).

  change_origin_XY(Win,pnt(X,Y)):-
	zoom_exists(_),
	RCT = win_GetClientRect(Win),
	RCT = rct(_,_,R,B),
	origin_XY(X0,Y0),
	max_Y(MAX_Y,_),
%	DeltaX = X0 - val(INTEGER,(X * (R + 600) / R - R/2)),
%	DeltaY = Y0 - val(INTEGER,(Y *MAX_Y / B - B/2)),
	DeltaX = X0 - val(INTEGER,(X * (1 + 600/R) - R/2)),
	DeltaY = Y0 - val(INTEGER,(Y *(MAX_Y / B) - B/2)),
	NewX = 0 - DeltaX,
	NewY = 0 - DeltaY,
	change_origin_X(NewX,_),
	change_origin_Y1(NewY),
	!.

  change_origin_XY(_,_).
enddef
  write_Page(_):-
  	max_Y(MAX,_),
  	MAX = 0,!.
  write_Page(Win):-
	sheet(PAGE),
	str_int(S_P,PAGE),
	concat("  ",S_P,S_PAGE),
	CTL_EDIT = win_GetCtlHandle(Win,idst_page),
	Font=font_Create(ff_Helvetica, [], 8),
	win_SetFont(CTL_EDIT,Font),
	win_SetText(CTL_EDIT,S_PAGE),
	!.

  write_Page(_).

  code_position(_,sc_LineUp,_,-30):-!.
  code_position(_,sc_LineDown,_,30):-!.
  code_position(_,sc_PageUp,_,-300):-!.
  code_position(_,sc_PageDown,_,300):-!.
  code_position(b_true,sc_Thumb,POS,DELTA):-
  	origin_XY(_,Y),
  	max_Y(MAXY,_),
	prevwin(WIN),
	RCT=win_GetClientRect(WIN),
	RCT = rct(_,_,_,H),
	HH = H - control_Height,
  	NEW_Y = trunc((MAXY-0.8*HH)/100.0* POS),
	DELTA = NEW_Y - Y,
  	!.
  code_position(b_false,sc_Thumb,POS,DELTA):-
  	origin_XY(X,_),
  	NEW_X = trunc(600/100.0* POS),
	DELTA = NEW_X - X,
  	!.
  code_position(_,_,_,0).

  process_key(WIN,k_up,_):-
	not(zoom_exists(_)),
	W =win_GetCtlHandle(WIN, c_VScroll),
  	win_SendEvent(WIN,e_Control(c_VScroll,wc_VScroll,W,scroll(sc_LineUp,0))),
  	!.
  process_key(WIN,k_down,_):-
	not(zoom_exists(_)),
	W =win_GetCtlHandle(WIN, c_VScroll),
  	win_SendEvent(WIN,e_Control(c_VScroll,wc_VScroll,W,scroll(sc_LineDown,0))),
  	!.
  process_key(WIN,k_right,_):-
	not(zoom_exists(_)),
	W =win_GetCtlHandle(WIN, c_HScroll),
  	win_SendEvent(WIN,e_Control(c_HScroll,wc_HScroll,W,scroll(sc_LineDown,0))),
  	!.
  process_key(WIN,k_left,_):-
	not(zoom_exists(_)),
	W =win_GetCtlHandle(WIN, c_HScroll),
  	win_SendEvent(WIN,e_Control(c_HScroll,wc_HScroll,W,scroll(sc_LineUp,0))),
  	!.
  process_key(WIN,k_prev,_):-
	not(zoom_exists(_)),
	W =win_GetCtlHandle(WIN, c_VScroll),
	ScrollPos=win_GetScrollPos(W,sb_Ctl),
	ScrollPos > 0,
  	win_SendEvent(WIN,e_Control(c_VScroll,wc_VScroll,W,scroll(sc_PageUp,0))),
  	!.
  process_key(WIN,k_prev,_):-
	W =win_GetCtlHandle(WIN, c_PageUp),
  	win_SendEvent(WIN,e_Control(c_PageUp,wc_PushButton,W,activated)),
  	!.
  process_key(WIN,k_next,_):-
	not(zoom_exists(_)),
	W =win_GetCtlHandle(WIN, c_VScroll),
	ScrollPos=win_GetScrollPos(W,sb_Ctl),
	ScrollPos < 99,
  	win_SendEvent(WIN,e_Control(c_VScroll,wc_VScroll,W,scroll(sc_PageDown,0))),
  	!.
  process_key(WIN,k_next,_):-
	W =win_GetCtlHandle(WIN, c_PageDown),
  	win_SendEvent(WIN,e_Control(c_PageDown,wc_PushButton,W,activated)),
  	!.
  process_key(WIN,k_lhome,_):-
	W =win_GetCtlHandle(WIN, c_Home),
  	win_SendEvent(WIN,e_Control(c_Home,wc_PushButton,W,activated)),
  	!.
  process_key(WIN,k_lend,_):-
	W =win_GetCtlHandle(WIN, c_End),
  	win_SendEvent(WIN,e_Control(c_End,wc_PushButton,W,activated)),
	!.
  process_key(WIN,c_C,c_Shift):-!,
	W =win_GetCtlHandle(WIN, c_Exit),
  	win_SendEvent(WIN,e_Control(c_Exit,wc_PushButton,W,activated)).
  process_key(WIN,c_P,c_Shift):-!,
	W =win_GetCtlHandle(WIN, c_Print),
  	win_SendEvent(WIN,e_Control(c_Print,wc_PushButton,W,activated)).
  process_key(WIN,c_C,c_Shift):-!,
	W =win_GetCtlHandle(WIN, c_Zoom),
  	win_SendEvent(WIN,e_Control(c_Zoom,wc_PushButton,W,activated)).
  	  	
  process_key(_,_,_).
predicates
	dd_eh 		: EHANDLER
	repaint_bar_he	: EHANDLER
procedure set_scrollRange(WINDOW)
procedure hscroll_spot(WINDOW,RCT,SYMBOL)
procedure zoom_proc(WINDOW)
procedure zoom_proc1(WINDOW)
procedure hScroll_move(WINDOW,INTEGER,INTEGER)
procedure vScroll_move(WINDOW,INTEGER,INTEGER)
procedure adjust_maximum(LONG,LONG,INTEGER,INTEGER,INTEGER,INTEGER)
procedure update_out_window(WINDOW,INTEGER,INTEGER,INTEGER)
procedure end_proc(WINDOW,INTEGER)
clauses

  dd_eh(W,e_Update(_),0):-
	BACK = win_GetAttrVal(W,attr_color_btnface),
  	win_Clear(W,BACK),
  	win_SetPen(W,pen(1,ps_Solid,color_Black)),
	RCT=win_GetClientRect(W),
	RCT = rct(_,_,R,B), B1 = B - 1, R1 = R - 1,
  	draw_PolyLine(W,[pnt(0,B1),pnt(0,0),pnt(R1,0)]),
  	!.

  repaint_bar_he(_,e_EraseBackGround,0):-!.
    
  repaint_bar_he(_,e_Update(_),0):-
  	zoom_exists(_),	!.
  
  repaint_bar_he(WIN,e_Update(_),0):-
	RCT=win_GetClientRect(WIN),
	win_SetPen(Win,pen(1,ps_Hollow,color_Black)),
	BACK = win_GetAttrVal(WIN,attr_color_btnface),
	win_SetBrush(Win,brush(pat_Solid,BACK)),
	draw_Rect(WIN,RCT).

   set_ScrollRange(_):-
  	zoom_exists(_), !.
   set_ScrollRange(WIN):-
	RCT = win_GetClientRect(WIN),
	RCT = rct(_X,_Y,W,H),
        T = H - control_Height,WW = W - control_Height,
        RRR = rct(re_ButtonsWidth,T,WW,H),
	trap(W_VS =win_GetCtlHandle(WIN, c_VScroll),_V,
	  hscroll_spot(Win,RRR,"create_event")),
	win_SetScrollPos(W_VS,sb_Ctl, 0),
	W_HS =win_GetCtlHandle(WIN, c_HScroll),
	win_SetScrollPos(W_HS,sb_Ctl, 0),
	W_PBAR = win_GetCtlHandle(Win,c_reBar),
	win_SetState(W_PBAR,[wsf_Visible]),
	!.
  set_ScrollRange(_).
	
  hscroll_spot(Win,RCT,"check_event"):-
  	zoom_exists(W),
  	NULL = cast(WINDOW,0),
  	W = NULL,
	retract(zoom_exists(_)),
	RCT = rct(L,T,WIDTH,HEIGHT),LL = L + 1, TT = T + 1,
	RRR = rct(LL,TT,WIDTH,HEIGHT),
	BGROUND = win_Create(w_Child,RRR,"",no_Menu,Win,[wsf_Border],dd_eh,0),	
  	assert(zoom_exists(BGROUND)),
  	CW = win_getCtlHandle(Win,c_HScroll),
  	win_Destroy(CW),
  	CV = win_getCtlHandle(Win,c_VScroll),
  	win_Destroy(CV),
	W_PBAR = win_GetCtlHandle(Win,c_reBar),
	win_SetState(W_PBAR,[wsf_Invisible]),
  	!.
  hscroll_spot(Win,RCT,_):-
  	zoom_exists(W),
  	NULL = cast(WINDOW,0),
  	W = NULL,
	retract(zoom_exists(_)),
	RCT = rct(L,T,R,B),LL = L + 1,TT = T + 1,
	RR = R + control_Height, RRR = rct(LL,TT,RR,B),
	BGROUND = win_Create(w_Child,RRR,"",no_Menu,Win,[wsf_Border],dd_eh,0),	
  	assert(zoom_exists(BGROUND)),
  	cursor_Set(Win,idc_zoomin,b_false),
	W_PBAR = win_GetCtlHandle(Win,c_reBar),
	win_SetState(W_PBAR,[wsf_Invisible]),
  	!.
  	
  hscroll_spot(_,_,_):-
	zoom_exists(_),
  	!.
  hscroll_spot(Win,RCT,"create_event"):-
  	cursor_Set(Win,idc_zoomout,b_false),
	win_CreateControl(wc_HScroll,RCT,"",Win,[],c_HScroll),
	HS = win_GetCtlHandle(Win,c_HScroll),
	win_SetScrollRange(HS,sb_Ctl, 0, 100),
	RCT = rct(_L,_T,R,B),
	BB = B - control_Height, RR = R + control_Height,
	RRR = rct(R,0,RR,BB),
	win_CreateControl(wc_VScroll,RRR,"",Win,[],c_VScroll),
	VS = win_GetCtlHandle(Win,c_VScroll),
	win_SetScrollRange(VS,sb_Ctl, 0, 100),
	W_PBAR = win_GetCtlHandle(Win,c_reBar),
	win_SetState(W_PBAR,[wsf_Visible]),
	!.
  hscroll_spot(_,_,_):- !.
  	
  zoom_proc1(BackGround):-
  	trap(win_Destroy(BackGround),_,fail), !.
  zoom_proc1(_).
  
  zoom_proc(Win):-
  	retract(zoom_exists(BGROUND)),
  	cursor_Set(Win,idc_zoomout,b_false),
	zoom_proc1(BGROUND),
	RCT = win_GetClientRect(Win),
	RCT = rct(_X,_Y,W,H),
        T = H - control_Height, L = W - control_Height,
        HH = H - control_Height,
	win_CreateControl(wc_HScroll,rct(re_ButtonsWidth,T,L,H),"",Win,[],c_HScroll),
	HS = win_GetCtlHandle(Win,c_HScroll),
	win_SetScrollRange(HS,sb_Ctl, 0, 100),
	win_CreateControl(wc_VScroll,rct(L,0,W,HH),"",Win,[],c_VScroll),
	VS = win_GetCtlHandle(Win,c_VScroll),
	win_SetScrollRange(VS,sb_Ctl, 0, 100),
	change_origin_X(0,_),
	change_origin_Y(0,_),
	W_PBAR = win_GetCtlHandle(Win,c_reBar),
	RCT_PBAR = win_GetClientRect(W_PBAR),	
	win_SetState(W_PBAR,[wsf_Visible]),
	win_PostEvent(W_PBAR,e_Update(RCT_PBAR)),
	!.
  zoom_proc(Win):-
  	cursor_Set(Win,idc_zoomin,b_false),
	trap(HS = win_GetCtlHandle(Win,c_HScroll),_,fail),
	RCT = win_GetClientRect(Win),
	RCT = rct(_X,_Y,W,H), T = H - control_Height+1,
	Left = re_ButtonsWidth + 1,
	RRR = rct(Left,T,W,H),
	win_Destroy(HS),
	VS = win_GetCtlHandle(Win,c_VScroll),
	win_Destroy(VS),
	W_PBAR = win_GetCtlHandle(Win,c_reBar),
	win_SetState(W_PBAR,[wsf_Invisible]),
	BGROUND = win_Create(w_Child,RRR,"",no_Menu,Win,[wsf_Border],dd_eh,0),	
  	assert(zoom_exists(BGROUND)),
  	!.

  zoom_proc(Win):-
	W_PBAR = win_GetCtlHandle(Win,c_reBar),
	win_SetState(W_PBAR,[wsf_Invisible]),
	RCT = win_GetClientRect(Win),
	RCT = rct(_X,_Y,W,H), T = H - control_Height+1,
	Left = re_ButtonsWidth + 1,
	RRR = rct(Left,T,W,H),
	BGROUND = win_Create(w_Child,RRR,"",no_Menu,Win,[wsf_Border],dd_eh,0),	
  	assert(zoom_exists(BGROUND)),
  	!.

  hScroll_move(Win,Width,Height):-
  	zoom_exists(W), T = Height - control_Height + 1,
  	win_Move(W,rct(re_ButtonsWidth,T,Width,Height)),
	win_Invalidate(Win),
  	!.
  hScroll_move(Win,Width,Height):-
	T_HS = Height - control_Height, R_HS = Width - control_Height,
	RCT_HS = rct(re_ButtonsWidth,T_HS,R_HS,Height),
	trap(W_HS =win_GetCtlHandle(Win,c_HScroll),_,win_CreateControl(wc_HScroll,RCT_HS,"",Win,[],c_HScroll)),
	!,
	win_Move(W_HS,RCT_HS).
  hScroll_move(_,_,_).

  vScroll_move(_,_,_):-
  	zoom_exists(_),
  	!.
  vScroll_move(Win,Width,Height):-
	L = Width - control_Height, H = Height - control_Height,
	RCT_VS = rct(L,0,Width,H),
	trap(VS =win_GetCtlHandle(Win,c_VScroll),_,win_CreateControl(wc_VScroll,RCT_VS,"",Win,[],c_VScroll)),
	!,
	win_Move(VS,RCT_VS).
  vScroll_move(_,_,_).

  adjust_maximum(PRINTER_HEIGHT,PRINTER_WIDTH,W,H,V,H0):-
	V_float=0.96 * (H - control_Height),
	H0=trunc(PRINTER_WIDTH*V_float/PRINTER_HEIGHT),
	V = trunc(V_float),
	H0 < W,
	!.

  adjust_maximum(PRINTER_HEIGHT,PRINTER_WIDTH,W,_H,V,H0):-
	H_float = 0.9 * W,
	V = trunc(PRINTER_HEIGHT*H_float/PRINTER_WIDTH),
	H0 = trunc(H_float).
	
  update_out_window(WINDOW,_,_,Z):-
	zoom_exists(_),
	BACK = win_GetAttrVal(WINDOW,attr_color_appworkspace),
	drv_metrics(_,_,_,_,PRINTER_HEIGHT,PRINTER_WIDTH,_,_),
	scaling(X,Y,Z,HRES,VRES),
	RCT=win_GetClientRect(WINDOW),
	RCT = rct(_L,_T,W,H),
	adjust_maximum(PRINTER_HEIGHT,PRINTER_WIDTH,W,H,V,H0),
	X1=val(INTEGER,(W-H0)/2), Y1 = val(INTEGER,0.02*H),
	X2 = X1 + H0, Y2 = Y1 + V,
	X3 = 0 - X, Y3 = 0 - Y,
	Hc = H - control_Height,
	win_SetMapMode(WINDOW,mm_Arbitrary),
	win_SetMapScale(WINDOW,pnt(0,0),pnt(W,H),pnt(0,0),pnt(W,H)),
	win_SetPen(WINDOW,pen(1,ps_Solid,BACK)),
	win_SetBrush(WINDOW,brush(pat_Solid,BACK)),
	draw_Rect(WINDOW,rct(0,0,X1,Hc)), draw_Rect(WINDOW,rct(X2,0,W,Hc)),
	draw_Rect(WINDOW,rct(X1,0,X2,Y1)), draw_Rect(WINDOW,rct(X1,Y2,X2,Hc)),
	win_SetBrush(WINDOW,brush(pat_Solid,color_White)),
	draw_Rect(WINDOW,rct(X1,Y1,X2,Y2)),
	win_SetMapMode(WINDOW,mm_Arbitrary),
	win_SetMapScale(WINDOW, pnt(X3,Y3), pnt(HRES,VRES), pnt(X1,Y1), pnt(H0,V)),
	!.

  update_out_window(WINDOW,XORG,YORG,Z):-
	scaling(X,Y,Z,_,_),
	RCT=win_GetClientRect(WINDOW),
	RCT = rct(L,T,W,H),
	Hc = H - control_Height,
	Wc = W - control_Height,
	RCTctl = rct(L,T,Wc,Hc),
	win_SetMapMode(WINDOW,mm_Arbitrary),
	win_SetMapScale(WINDOW,pnt(0,0),pnt(W,H),pnt(0,0),pnt(W,H)),
	win_Clear(WINDOW,RCTctl,color_white),
	win_SetMapMode(WINDOW,mm_Arbitrary),
	win_SetMapScale(WINDOW, pnt(XORG,YORG), pnt(W,H), pnt(X,Y), pnt(W,H)),
	!.
	
  update_out_window(_,_,_,0).
  
  end_proc(Win,PAGE):-
	retract(sheet(_)),
	assert(sheet(PAGE)),
	RCT=win_GetClientRect(Win),
	win_SendEvent(Win,e_Update(RCT)),
	!.
  end_proc(_,_).

%*******	Direct Report Generation to RT Format		********
ifdef use_rtf_converter
predicates
determ  generate_to_rtf(REPORT,PROCESS_PRED,STRING)
  dd_rtfhandler : EHANDLER
procedure   get_save_path(STRING)   
procedure   check_SavePath(STRING)  
procedure   pathCallBack(STRING)
clauses
  generate_to_rtf(REPORT,CCB,FILE):-
  	NULLWIN=cast(window,0),
	TMP=win_GetAttrVal(NULLWIN,attr_task_window),
	TASK_WIN=cast(window,TMP),
	retractall(convert_rtf(_)),
	assert(convert_rtf(FILE)),
	win_Create(w_TopLevel,rct(0,0,100,100),"",
		   no_Menu,TASK_WIN,dummy_Flags,dd_rtfhandler,0),
	executePrint(REPORT,CCB),
	!.
  
   dd_rtfhandler(Win,e_Create(_),0):-
   	timer_Set(Win,100), !.
   dd_rtfhandler(Win,e_Timer(ID),0):-
  	not(generation_in_progress(_)),
   	timer_Kill(ID),
	convert_rtf(FILE),
	re_RTFConvert(FILE),
	re_delete_temp_file,
	expands_dbdelete,
	win_Destroy(Win),
	!.
enddef
/****************************************************************************************
*		Time Resources Consumption Checking Predicates
*
\***************************************************************************************/
ifdef time_consumption_check
predicates
procedure INTEGER time_spent(INTEGER,INTEGER,INTEGER,INTEGER)
procedure INTEGER time_SumSpent(INTEGER,INTEGER,INTEGER)
procedure time_spentinside_application(INTEGER,INTEGER,INTEGER)
procedure time_retrieve_passingEnd(INTEGER,INTEGER,INTEGER)
procedure check_timefacttype(INTEGER)
procedure time_storeinside_application(INTEGER,INTEGER,INTEGER)
clauses
  time_spent(D,S1,S0,Vrema,1):-
	S0 > S1,
	Vrema = S1 + D - S0, !.

  time_spent(_,S1,S0,Vrema,0):-
	Vrema = S1 - S0.

  time_SumSpent(D,V,Real,1):-
	V >= D, !,
	Real = V - D.
  time_SumSpent(_,V,V,0).
	
  time_spentinside_application(_,_,_):-
	retract(time_fact(Type,StartMin,StartS,StartM)),
	Type = 3,
	time_retrieve_passingEnd(EndMin,EndS,EndM),
	Z = time_spent(100,EndM,StartM,MSecs),
	ZZ = EndS - Z,
	Y = time_spent(60,ZZ,StartS,Vrema),
	YY = EndMin - Y,
	time_Spent(60,YY,StartMin,Minutes),
	time_storeinside_application(Minutes,Vrema,MSecs),
	fail.

  time_spentinside_application(Minuts,Secs,Msecs):-
	retract(time_spentCB(Minuts,Secs,Msecs)), !.

  time_spentinside_application(0,0,0):-!.

  time_retrieve_passingEnd(Mins,Secs,MSs):-
	time_fact(Type,Mins,Secs,MSs), !,
	check_timefactType(Type).

  check_timefactType(4):-!.
	
  time_storeinside_application(Minutes,Vrema,MSecs):-
	retract(time_spentCB(MS1,SS1,MsecS1)),
	MSum = MS1 + Minutes,
	SSum = SS1 + Vrema,
	MSecSum = MSecS1 + MSecs,	
	R1 = time_SumSpent(100,MSecSum,MSecSum0),
	SSum1 = SSum + R1,
	R2 = time_SumSpent(60,SSum1,SSum0),
	MSum1 = MSum + R2,
	time_SumSpent(60,MSum1,MSum0),
	assert(time_spentCB(MSum0,SSum0,MSecSum0)), !.
  time_storeinside_application(Minutes,Vrema,MSecs):-
	assert(time_spentCB(Minutes,Vrema,MSecs)), !.
	
enddef
/****************************************************************************************
*		Printing Predicates
*
\***************************************************************************************/

predicates
		dd_handler : EHANDLER
		win_report_out_eh : EHANDLER
procedure	regenerate_report(WINDOW)
procedure	insert_cbf(PROGRESS_PRED,ILIST,ERR_IDENT)
procedure	ask_drv_metrics
procedure	if_exist(PAGE_DEF,INTEGER,INTEGER)
procedure	ask_report_name(PROCESS_PRED,STRING)
procedure	call_pages_to_printer(INTEGER,INTEGER,INTEGER)
procedure	pages_to_printer(STRING,INTEGER,INTEGER,INTEGER)
procedure	pages_to_printer1(WINDOW,INTEGER,INTEGER,INTEGER)
procedure	check_metrics
procedure	WINDOW win_report_Out_Create(REPORT,PROCESS_PRED,STRING,RCT,ERR_IDENT)
procedure	re_add_pw_flags(WSFLAGS,ILIST,WSFLAGS)
procedure	set_prev_Scaling
procedure	insert_margins(PAGEPROPERTIES,ERR_IDENT)
procedure	re_shutdown_ReportPrint(WINDOW)
determ		is_pw_zoomed(ILIST)
determ		re_init_ReportPrint(STRING,WINDOW)
determ		print_Pages(WINDOW,INTEGER,INTEGER,INTEGER)
determ		inside_Page1(INTEGER,WINDOW,INTEGER,INTEGER,INTEGER)
determ		re_reportPrint(REPORT,PROCESS_PRED,INTEGER,INTEGER,INTEGER)
determ		pages_to_printer2(WINDOW,INTEGER,INTEGER,INTEGER)

clauses
   regenerate_report(WIN):-
	progress_cbf(PBF,FLAGS),
	tree(REPORT,CONTROL_CALLBACK),
	insert_cbf(PBF,FLAGS,no_errors),
	ask_drv_metrics,
	set_ScrollRange(Win),
	set_Prev_Scaling,
	retract(sheet(_)),
	assert(sheet(1)),
	retractall(updating(outpage(_)),preview_update),
	win_report_out_Create(REPORT,CONTROL_CALLBACK,"",rct(0,0,0,0),no_errors),
	!.
   regenerate_report(_).
	   
   is_pw_Zoomed([repw_Zoomed|_]):- !.
   is_pw_Zoomed([_|Rest]):- !,
   	is_pw_Zoomed(Rest).
   
   insert_cbf(_,_,error_at(_,_)):-!.
   insert_cbf(_,FLAG,_):-
   	not(is_pw_Zoomed(FLAG)),
   	retract(zoom_exists(W)),
   	win_Destroy(W),
   	fail.
   insert_cbf(_,_,_):-
   	retract(progress_cbf(_,_)),
   	fail.
   insert_cbf(PBF,FLAG,_):-
	is_pw_Zoomed(FLAG),
	not(zoom_exists(_)),
	NULL = cast(WINDOW,0),
	assert(progress_cbf(PBF,FLAG)),
   	assert(zoom_exists(NULL)),
   	!.
   insert_cbf(PBF,FL,_):-
	assert(progress_cbf(PBF,FL)),
   	!.

  ask_drv_metrics:-
  	regen_is_needed,
  	retract(drv_metrics(_,_,_,_,_,_,_,_)),
  	fail.
  ask_drv_metrics:-
  	drv_metrics(_,_,_,_,_,_,_,_),
  	!.
  ask_drv_metrics:-
	NW=cast(window,0),
	Screen_HEIGHT = win_GetAttrVal(NW, attr_screen_height),
	Screen_WIDTH = win_GetAttrVal(NW, attr_screen_width),
	Screen_HRES = win_GetAttrVal(NW, attr_screen_hres),
	Screen_VRES = win_GetAttrVal(NW, attr_screen_vres),
	Printer_HEIGHT = win_GetAttrVal(NW, attr_printer_height),
	not(Printer_HEIGHT = 0),
	Printer_WIDTH = win_GetAttrVal(NW, attr_printer_width),
	Printer_HRES = win_GetAttrVal(NW, attr_printer_hres),
	Printer_VRES = win_GetAttrVal(NW, attr_printer_vres),
	assert(drv_metrics(Screen_HEIGHT,Screen_WIDTH,Screen_HRES,Screen_VRES,
	Printer_HEIGHT,Printer_WIDTH,Printer_HRES,Printer_VRES)),
	!.
  ask_drv_metrics:-
	NW=cast(window,0),
	Screen_HEIGHT = win_GetAttrVal(NW, attr_screen_height),
	Screen_WIDTH = win_GetAttrVal(NW, attr_screen_width),
	Screen_HRES = win_GetAttrVal(NW, attr_screen_hres),
	Screen_VRES = win_GetAttrVal(NW, attr_screen_vres),
ifdef os_os2	
	assert(drv_metrics(Screen_HEIGHT,Screen_WIDTH,Screen_HRES,Screen_VRES,
	3305,2400,300,300)),
elsedef   
	assert(drv_metrics(Screen_HEIGHT,Screen_WIDTH,Screen_HRES,Screen_VRES,
	3075,2400,300,300)),
enddef	
	!.


  re_reportPrint(REPORT,CCB,NCopies,FromP,ToP):-
  	NULLWIN=cast(window,0),
	TMP=win_GetAttrVal(NULLWIN,attr_task_window),
	TASK_WIN=cast(window,TMP),
	win_Create(w_TopLevel,rct(0,0,100,100),"",
		   no_Menu,TASK_WIN,dummy_Flags,dd_handler,0),
	executePrint(REPORT,CCB),
	ask_report_name(CCB,ReportName),
	assert(dynamical_printing(ReportName,NCopies,FromP,ToP)),
	!.
  
   dd_handler(Win,e_Create(_),0):-
   	timer_Set(Win,100), !.
   dd_handler(Win,e_Timer(ID),0):-
  	not(generation_in_progress(_)),
   	timer_Kill(ID),
	retract(dynamical_printing(NAME,NCopies,FromP,ToP)),	
	re_init_ReportPrint(NAME,PRINTWIN),
	pages_to_printer1(PRINTWIN,NCopies,FromP,ToP),
	win_PostEvent(Win,e_Destroy).	

    check_metrics:-
	drv_metrics(_,_,_,_,Printer_HEIGHT,Printer_WIDTH,_,_),
	NULL = cast(WINDOW,0),
	Printer_HEIGHT = win_GetAttrVal(NULL, attr_printer_height),
	Printer_WIDTH = win_GetAttrVal(NULL, attr_printer_width),
	!.

    check_metrics:-
	prevwin(WIN),
	assert(regen_is_needed),
	retractall(generation_in_progress(_)),
	regenerate_report(WIN),
	!.
    check_metrics.

    ask_report_name(CCB,ReportName):-
    	CCB("report_name",[],OUT),
    	OUT = [ReportName], !.

    ask_report_name(_,start_job_Label).
    
    call_pages_to_printer(NoOfCopies,FromP,ToP):-
    	tree(_,CCB),
    	CCB("report_name",[],OUT),
    	OUT = [Name], !,
	pages_to_printer(Name,NoOfCopies,FromP,ToP).

    call_pages_to_printer(NCopies,FromP,ToP):-
	pages_to_printer(start_job_Label,NCopies,FromP,ToP).

    pages_to_printer(_,0,_,_):- !.
    pages_to_printer(_,_,_,_):-
    	generation_canceled, !.

    pages_to_printer(NAME,NCopies,FromP,ToP):-
	check_metrics,
	re_init_ReportPrint(NAME,PRINTWIN),
	pages_to_printer1(PRINTWIN,NCopies,FromP,ToP),
	!.
	
    pages_to_printer(_,_,_,_).
    
    pages_to_printer1(PRINTWIN,0,_,_):-
	re_shutdown_ReportPrint(PRINTWIN), !.

    pages_to_printer1(PRINTWIN,NCopies,0,0):-
	assert(re_page_in_process(1)),
        if_exist(band(1,1000),FROM_P,TO_P),
	print_Pages(PRINTWIN,NCopies,FROM_P,TO_P),
        N1 = NCopies - 1,
        pages_to_printer2(PRINTWIN,N1,0,0),
        !.

    pages_to_printer1(PRINTWIN,NCopies,FromP,ToP):-
	FromP >< 0, ToP >< 0,
	assert(re_page_in_process(1)),
	print_Pages(PRINTWIN,NCopies,FromP,ToP),
        N1 = NCopies - 1,
        pages_to_printer2(PRINTWIN,N1,FromP,ToP),
	!.
        
   pages_to_printer1(PRNWIN,_,_,_):-
	re_shutdown_ReportPrint(PRNWIN), !.

   pages_to_printer2(PRINTWIN,N1,FromP,ToP):-
	retractall(re_page_in_process(_)),
	filepos(re_temp_file,0,0),
	readln(_),
        pages_to_printer1(PRINTWIN,N1,FromP,ToP),
	!.   

  win_report_Out_Create(REPORT,CCB,Title,_,_,WIN):-
        prevwin(WIN),
        win_SetText(WIN,Title),
        win_BringToTop(WIN),
        RCT = win_getClientREct(WIN),
	RCT = rct(_X,_Y,W,H),
        T = H - control_Height,
        RRR = rct(re_ButtonsWidth,T,W,H),
	hscroll_spot(Win,RRR,"check_event"),
        retractall(sheet(_)),
        retractall(origin_XY(_,_)),
        assert(sheet(1)),
        assert(origin_XY(0,0)),
	set_ScrollRange(WIN),
	win_Invalidate(WIN),
	executePrint(REPORT,CCB),
	!.

  win_report_Out_Create(REPORT,CCB,Title,RCT,no_errors,WIN_OUT):-
	NULLWIN=cast(window,0),
	TMP=win_GetAttrVal(NULLWIN,attr_task_window),
	TASK_WIN=cast(window,TMP),
	class_Create("REPaint_Bar",repaint_bar_he),
	progress_cbf(_,PW_FLAGS),
	re_add_pw_flags(win_report_out_Flags,PW_FLAGS,FLAGS),
	WIN_OUT = win_Create(win_report_out_WinType,RCT,Title,
		   win_report_out_Menu,TASK_WIN,FLAGS,win_report_out_eh,0),
	assert(prevwin(WIN_OUT)),
        assert(sheet(1)),
        assert(origin_XY(0,0)),
	assert(creation(REPORT,CCB)),
	!.

  win_report_Out_Create(_,_,_,_,_,WINNULL):-
  	WINNULL = cast(WINDOW,0).

  re_add_pw_flags(FLAGS,[],FLAGS):- !.
  re_add_pw_flags(Flag,[repw_Maximized|Rest],[wsf_Maximized|FLAGS]):- !,
  	re_add_pw_flags(Flag,Rest,FLAGS).
  re_add_pw_flags(Flag,[repw_Invisible|Rest],[wsf_Invisible|FLAGS]):- !,
  	re_add_pw_flags(Flag,Rest,FLAGS).
  re_add_pw_flags(Flag,[repw_Icon|Rest],[wsf_Minimized|FLAGS]):- !,
  	re_add_pw_flags(Flag,Rest,FLAGS).
  re_add_pw_flags(Flag,[_|Rest],FLAGS):- !,
  	re_add_pw_flags(Flag,Rest,FLAGS).
  re_add_pw_flags(_,_,[]).

ifdef os_os2
predicates
procedure invalidate_controls(WINDOW)
clauses
  invalidate_controls(Win):-
  	not(zoom_exists(_)),
  	Close = win_getCtlHandle(Win,c_Exit),
  	win_Invalidate(Close),
  	Home = win_getCtlHandle(Win,c_Home),
  	win_Invalidate(Home),
  	Prev = win_getCtlHandle(Win,c_PageUp),
  	win_Invalidate(Prev),
  	Next = win_getCtlHandle(Win,c_PageDown),
  	win_Invalidate(Next),
  	End = win_getCtlHandle(Win,c_End),
  	win_Invalidate(End),
  	Zoom = win_getCtlHandle(Win,c_Zoom),
  	win_Invalidate(Zoom),
  	Print = win_getCtlHandle(Win,c_Print),
  	win_Invalidate(Print),
ifdef use_rtf_converter
  	SV = win_getCtlHandle(Win,c_Save),
  	win_Invalidate(SV),
enddef
  	Hor = win_getCtlHandle(Win,c_HScroll),
  	win_Invalidate(Hor),
  	Ver = win_getCtlHandle(Win,c_VScroll),
  	win_Invalidate(Ver),
  	!.
  invalidate_controls(_).
enddef
/****************************************************************************************
*		Handler of the Preview Window
*
\***************************************************************************************/

  win_report_out_eh(Win,e_Create(_),0):-
	RCT = win_GetClientRect(Win),
	RCT = rct(_X,_Y,W,H),
        T = H - control_Height,WW = W - control_Height,
        RRR = rct(re_ButtonsWidth,T,WW,H),
	re_ownerdraw_CreateControl(wc_PushButton,c_Exit,rct(0,T,25,H),"",Win),
	re_ownerdraw_CreateControl(wc_PushButton,c_Home,rct(25,T,51,H),"",Win),
	re_ownerdraw_CreateControl(wc_PushButton,c_PageUp,rct(51,T,76,H),"",Win),
	re_ownerdraw_CreateControl(wc_PushButton,c_End,rct(202,T,228,H),"",Win),
	re_ownerdraw_CreateControl(wc_PushButton,c_PageDown,rct(177,T,202,H),"",Win),
	re_ownerdraw_CreateControl(wc_PushButton,c_Zoom,rct(228,T,253,H),"",Win),
	re_ownerdraw_CreateControl(wc_PushButton,c_Print,rct(253,T,278,H),"",Win),
ifdef use_rtf_converter
	re_ownerdraw_CreateControl(wc_PushButton,c_Save,rct(278,T,re_ButtonsWidth,H),"",Win),
enddef
ifdef os_os2
	Te = T - 2,
	He = H + 4,
	win_CreateControl(wc_Edit,rct(75,Te,130,He),"",Win,[],idst_vol),
	win_CreateControl(wc_Edit,rct(128,Te,178,He),"",Win,[],idst_page),
elsedef
	win_CreateControl(wc_Edit,rct(76,T,126,H),"",Win,[],idst_vol),
	win_CreateControl(wc_Edit,rct(126,T,177,H),"",Win,[],idst_page),
enddef
	win_CreateDynControl([customctl(wdef(wc_Custom,rct(0,0,1,1),"",u_Pixels),"REPaint_Bar",c_reBar,[])],Win),
	hscroll_spot(Win,RRR,"create_event"),
	!.

   win_report_out_eh(_Win,e_OwnerDraw(od_Button,c_Home,_,ACTIONLIST,STATELIST,LW,RECT,_),0):-
  	re_ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,LW,idi_od_Home),!.
   win_report_out_eh(_Win,e_OwnerDraw(od_Button,c_PageUp,_,ACTIONLIST,STATELIST,LW,RECT,_),0):-
  	re_ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,LW,idi_od_Prev),!.
   win_report_out_eh(_Win,e_OwnerDraw(od_Button,c_PageDown,_,ACTIONLIST,STATELIST,LW,RECT,_),0):-
  	re_ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,LW,idi_od_Next),!.
   win_report_out_eh(_Win,e_OwnerDraw(od_Button,c_End,_,ACTIONLIST,STATELIST,LW,RECT,_),0):-
  	re_ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,LW,idi_od_End),!.
   win_report_out_eh(_Win,e_OwnerDraw(od_Button,c_Exit,_,ACTIONLIST,STATELIST,LW,RECT,_),0):-
  	re_ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,LW,idi_od_Exit),!.
   win_report_out_eh(_Win,e_OwnerDraw(od_Button,c_Zoom,_,ACTIONLIST,STATELIST,LW,RECT,_),0):-
  	re_ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,LW,idi_od_Zoom),!.
   win_report_out_eh(_Win,e_OwnerDraw(od_Button,c_Print,_,ACTIONLIST,STATELIST,LW,RECT,_),0):-
  	re_ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,LW,idi_od_Print),!.

ifdef use_rtf_converter
   win_report_out_eh(_Win,e_OwnerDraw(od_Button,c_Save,_,ACTIONLIST,STATELIST,LW,RECT,_),0):-
  	re_ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,LW,idi_od_Save),!.
enddef 

   win_report_out_eh(Win,e_Control(_,_,_,getfocus),0):-
   	trap(win_setFocus(Win),_,fail),
   	!.
	
   win_report_out_eh(Win,e_Control(c_Home,_,_,_),0):-
	sheet(PAGE),
	PAGE >< 1,
  	change_origin_Y(-10000,_),
	retract(sheet(_)),
	assert(sheet(1)),
	write_page(WIN),
   	trap(win_setFocus(Win),_,fail),
	RCT=win_GetClientRect(Win),
	win_SendEvent(Win,e_Update(RCT)),
	!.    
	
  win_report_out_eh(Win,e_Control(c_PageDown,_,_,_),0):-
	max_y(_,b_false),
	page(_,LAST),
	sheet(PAGE),
	P = PAGE + 1,
	P <= LAST,
 	change_origin_Y(-10000,_),
	retract(sheet(PAGE)),
	assert(sheet(P)),
   	trap(win_setFocus(Win),_,fail),
	RCT=win_GetClientRect(Win),
	win_SendEvent(Win,e_Update(RCT)),
	write_page(WIN),
ifdef time_consumption_check
	retract(time_fact(2,M1,S1,MS1)),
	retract(time_fact(1,M0,S0,MS0)),
	Z = time_spent(100,MS1,MS0,MSecs),
	ZZ = S1 - Z,
	Y = time_spent(60,ZZ,S0,Vrema),
	YY = M1 - Y,
	time_Spent(60,YY,M0,Minutes),
	time_spentinside_application(CBMinutes,CBVr,CBMscs),
	format(OUT,"Total Time = %d min %d sec %d ms\nTime spent inside CallBacks = %d min %d sec %d ms",Minutes,Vrema,MSecs,CBMinutes,CBVr,CBMscs),
	dlg_Note(OUT),
enddef
	!.
  win_report_out_eh(Win,e_Control(c_PageUp,_,_,_),0):-
	sheet(PAGE),
	PAGE >< 1,
	P = PAGE - 1,
	retract(sheet(PAGE)),
	assert(sheet(P)),
	write_page(WIN),
   	trap(win_setFocus(Win),_,fail),
  	change_origin_Y(-10000,_),
	RCT=win_GetClientRect(Win),
	win_SendEvent(Win,e_Update(RCT)),
	!.
  win_report_out_eh(Win,e_Control(c_End,_,_,_),0):-
	max_y(_,b_false),
	page(_,PAGE),
	end_proc(Win,PAGE),
	write_page(WIN),
   	trap(win_setFocus(Win),_,true),
	!.
  win_report_out_eh(Win,e_Control(c_Exit,_,_,_),0):-
	win_PostEvent(Win,e_CloseRequest),
	!.

  win_report_out_eh(Win,e_Timer(Id),0):-
	not(generation_in_progress(_)),
	retract(timerId(Win,Id,1)),
  	timer_Kill(ID),
	retract(printDlgParam(NoOfCopies,FirstPage,LastPage)),
	call_pages_to_printer(NoOfCopies,FirstPage,LastPage),
	!.
  win_report_out_eh(Win,e_User(4321,1234),0):-
	Id = timer_Set(Win,300),
	assert(timerId(Win,Id,1)),
	!.
  win_report_out_eh(Win,e_Control(c_Print,_,_,_),0):-
	not(generation_in_progress(_)),
	dlg_PrintSetup(NoOfCopies,FirstPage,LastPage),
	check_metrics,
	assert(printDlgParam(NoOfCopies,FirstPage,LastPage)),
	win_PostEvent(Win,e_User(4321,1234)),
	!.
  win_report_out_eh(Win,e_Control(c_Print,_,_,_),0):-
	not(generation_in_progress(_)),
	check_metrics,
   	trap(win_setFocus(Win),_,fail),
	!.

  win_report_out_eh(Win,e_Control(c_Zoom,_,_,_),0):-
  	zoom_proc(Win),
	win_Invalidate(Win),
   	trap(win_setFocus(Win),_,fail),
  	!.
	
ifdef use_rtf_converter
  win_report_out_eh(_Win,e_Control(c_Save,_,_,_),0):-
	not(generation_in_progress(_)),
	get_save_path(InPath),
	SFile = dlg_GetFileName("*.rtf",["Rich Text Format (.rtf)","*.rtf","Tab separated file","*.*"],"Set File Name:",[dlgfn_Save],InPath,_,UsedFilter),
	filenamepath(SFile,NewPath,_Name),
	retractAll(save_path(_)),
	assert(save_path(NewPath)),
	pathCallBack(NewPath),
	choose_Convert_Type(SFile,UsedFilter),
	!.
  win_report_out_eh(_Win,e_Control(c_Save,_,_,_),0):-
	not(generation_in_progress(_)),!.

enddef

  win_report_out_eh(Win,e_Control(c_HScroll,_,_,scroll(CODE,POS)),0):-
  	code_position(b_false,CODE,Pos,Delta_X),
  	change_origin_X(Delta_X,Really_X),
	RCT = win_GetClientRect(WIN),
	RCT = rct(L,T,R,B),
	RR = R-control_Height,BB = B-control_Height,
	RRR = rct(L,T,RR,BB),
	D_X = -Really_X,
	win_Scroll(Win,RRR, D_X, 0),
  	!.
  win_report_out_eh(Win,e_Control(c_VScroll,_,_,scroll(CODE,POS)),0):-
  	code_position(b_true,CODE,POS,Delta_Y),
  	change_origin_Y(Delta_Y,Really_Y),
	RCT = win_GetClientRect(WIN),
	RCT = rct(L,T,R,B),
	RR = R-control_Height,BB = B-control_Height,
	RRR = rct(L,T,RR,BB),
	D_Y = -Really_Y,
	win_Scroll(Win,RRR, 0, D_Y),
  	!.

ifndef  rep_avoid_mousedown
  win_report_out_eh(Win,e_MouseDown(PNT,_,mouse_button_left),0):-
  	CTL = win_GetCtlHandle(Win,c_Zoom),
  	change_origin_XY(Win,PNT),
  	win_SendEvent(Win,e_Control(c_Zoom,wc_PushButton,CTL,activated())),
  	!.
enddef
  win_report_out_eh(Win,e_Timer(ID),0):-
	retract(timerId(Win,Id,0)),
  	timer_Kill(ID),
  	retract(creation(REPORT,CCB)),
  	win_Invalidate(Win),
	executePrint(REPORT,CCB),
	!.

  win_report_out_eh(Win,e_Update(_),0):-
	creation(_,_),
	Id = timer_Set(Win,2),
	assert(timerId(Win,Id,0)),
	!.

  win_report_out_eh(Win,e_Update(_RECT),0):-
  	sheet(PAGE),
	origin_XY(XORG,YORG),
	update_out_window(Win,XORG,YORG,Z),
	MAX_Y = displayPrint(Win,PAGE),
	add_Y(MAX_Y,Z,MAX_Z),
	set_max_Y(MAX_Z,MAX_Y),
	Font=font_Create(ff_Helvetica, [], 8),
	CTL_TEXT = win_GetCtlHandle(Win,idst_vol),
	win_SetFont(CTL_TEXT,Font),
	win_SetText(CTL_TEXT,win_report_Page),
	write_Page(Win),
ifdef os_os2
	invalidate_controls(Win),
enddef
  	!.

  win_report_out_eh(Win,e_Size(Width,Height),0):-
	W_PBAR = win_GetCtlHandle(Win,c_reBar),
	L_PBAR = Width - control_Height,W_PBAR1 = Width + 1,
	TOP = Height - control_Height,H_PBAR1 = Height + 1,
	R_PBAR = rct(L_PBAR,TOP,W_PBAR1,H_PBAR1),
	win_Move(W_PBAR,R_PBAR),
	W_EXIT =win_GetCtlHandle(Win, c_Exit),
	R_EXIT = rct(0,TOP,25,Height),
	win_Move(W_EXIT,R_EXIT),
	W_HOME =win_GetCtlHandle(Win, c_Home),
	R_HOME = rct(25,TOP,51,Height),
	win_Move(W_HOME,R_HOME),
	W_PAGEUP =win_GetCtlHandle(Win, c_PageUp),
	R_PAGEUP = rct(51,TOP,76,Height),
	win_Move(W_PAGEUP,R_PAGEUP),
	W_TEXT =win_GetCtlHandle(Win, idst_vol),
ifdef os_os2
	Te = TOP - 2,
	He = Height + 3,
	R_TEXT = rct(75,Te,130,He),
	R_EDIT = rct(128,Te,178,He),
elsedef
	R_TEXT = rct(76,TOP,126,Height),
	R_EDIT = rct(126,TOP,177,Height),
enddef
	win_Move(W_TEXT,R_TEXT),
	Font=font_Create(ff_Helvetica, [], 8),
	win_SetFont(W_TEXT,Font),
	win_SetText(W_TEXT,win_report_Page),
	W_EDIT =win_GetCtlHandle(Win, idst_page),
	win_Move(W_EDIT,R_EDIT),
	write_Page(Win),
	W_PAGEDN =win_GetCtlHandle(Win, c_PageDown),
	R_PAGEDN = rct(177,TOP,202,Height),
	win_Move(W_PAGEDN,R_PAGEDN),
	W_END =win_GetCtlHandle(Win, c_End),
	R_END = rct(202,TOP,228,Height),
	win_Move(W_END,R_END),
	W_ZOOM =win_GetCtlHandle(Win, c_Zoom),
	R_ZOOM = rct(228,TOP,253,Height),
	win_Move(W_ZOOM,R_ZOOM),
	W_PRINT =win_GetCtlHandle(Win, c_Print),
	R_PRINT = rct(253,TOP,278,Height),
	win_Move(W_PRINT,R_PRINT),
ifdef use_rtf_converter
	W_SAVE =win_GetCtlHandle(Win, c_Save),
	R_SAVE = rct(278,TOP,re_ButtonsWidth,Height),
	win_Move(W_SAVE,R_SAVE),
enddef
%---	Do not put some important below, would fail ...		---
	hScroll_move(Win,Width,Height),
	vScroll_move(Win,Width,Height),
	!.

  win_report_out_eh(_Win,e_EraseBackGround,0):-
	prevwin(_),
	zoom_exists(_),
  	!.
  win_report_out_eh(Win,e_KeyDown(KEY,Control),0):-
	process_key(Win,KEY,Control),
	!.

  win_report_out_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.

  win_report_out_eh(_Win,e_Destroy,0):-
	retractall(_,preview),
	retractall(_,paper),
        retractall(zoom_exists(_)),
	re_delete_temp_file,
	expands_dbdelete,
	!,fail.

  win_report_out_eh(_Win,e_CloseRequest,0):-
	retract(generation_canceled),
	retractall(generation_in_progress(_)),
	win_Destroy(_Win),
	class_Destroy("REpaint_Bar"),!,fail.
	
  win_report_out_eh(_Win,e_CloseRequest,0):-
	generation_in_progress(_),!,fail.
	
  win_report_out_eh(_Win,e_CloseRequest,0):-
	win_Destroy(_Win),
	class_Destroy("REpaint_Bar"),
	!,fail.

   errors_reflect(no_errors):-!.

   errors_reflect(ERR):-
        ERR=error_at(Pos,Mess),
	format(S,re_dlg_Note,Mess,Pos),
	dlg_Note(re_dlg_title,S),
        !.
   errors_reflect(_):-errorexit().
predicates
determ	  start_job_errhnd(INTEGER,STRING)
procedure proc_margins(PAGEPROPERTY)
procedure proc_orientation(PAGEPROPERTIES)
procedure find_out_ScrOrg(INTEGER,INTEGER,INTEGER,INTEGER,INTEGER)
procedure set_print_Scaling(WINDOW)

determ  check_orientation(PAGEPROPERTY)
determ	extract_margins(PAGEPROPERTIES)
determ	get_Current_orientation(BOOLEAN)
determ	re_process_fact(WINDOW,KEEP_DBA_DOM,INTEGER,INTEGER)
clauses
   insert_margins(_,no_errors):-
   	retract(margins(_,_,_,_)),
	fail.
   insert_margins(PAGEPROPLIST,no_errors):-
   	extract_margins(PAGEPROPLIST),
	!.
   insert_margins(_,_):-
   	not(margins(_,_,_,_)),
   	assert(margins(2.0,1.0,1.0,1.0)),
   	!.
   insert_margins(_,_).
   
   extract_margins([]):-
   	margins(_,_,_,_),!.
   extract_margins([F|REST]):-
   	proc_margins(F),
   	extract_margins(REST),!.
   proc_margins(margins(L,T,R,B)):-
   	assert(margins(L,T,R,B)),!.
   proc_margins(_).
   
   proc_orientation([]):-
   	ask_drv_metrics,
   	!.
   proc_orientation([P|_]):-
	check_orientation(P), !.
   proc_orientation([_|REST]):-
	proc_orientation(REST), !.
   proc_orientation(_):-errorexit().

  check_orientation(orientation(BOOL)):-
  	get_current_orientation(BOOL),!.	% Settings are correct
  check_orientation(orientation(_BOOL)):-
  	retractall(drv_metrics(_,_,_,_,_,_,_,_)),
ifndef os_os2
	print_SetOrientation(_BOOL),
enddef
	ask_drv_metrics,
	!.
  	
  get_current_orientation(b_false):-		% Portarit
	drv_metrics(_,_,_,_,Printer_HEIGHT,Printer_WIDTH,_,_),
	Printer_HEIGHT >= Printer_WIDTH, !.
  get_current_orientation(b_true):-		% Landscape
	drv_metrics(_,_,_,_,Printer_HEIGHT,Printer_WIDTH,_,_),
	Printer_HEIGHT < Printer_WIDTH, !.

  find_out_ScrOrg(ORG_X,ORG_Y,Z,HOR,VERT):-
	margins(LEFT,TOP,_,BOTTOM),
	drv_metrics(_,_,Screen_Hres,Screen_Vres,
	Printer_Height,Printer_Width,Printer_Hres,Printer_Vres),
	H_ORG = trunc(LEFT * Printer_HRES / 2.54),
	V_ORG = trunc(TOP * Printer_VRES / 2.54),
	ORG_X = trunc(H_ORG * Screen_HRES / Printer_HRES),
	ORG_Y = trunc(V_ORG * Screen_VRES / Printer_VRES),
	Z_ORG = trunc(BOTTOM * Printer_VRES / 2.54),
	Z = trunc(Z_ORG * Screen_VRES / Printer_VRES),
	HOR = trunc(Printer_WIDTH * Screen_HRES / Printer_HRES),
	VERT = trunc(Printer_HEIGHT * Screen_VRES / Printer_VRES),
	!.
  find_out_ScrOrg(0,0,0,0,0).

  set_prev_scaling:-
  	retract(scaling(_,_,_,_,_)),
  	fail.
  set_prev_scaling:-
	find_out_ScrOrg(ORG_X,ORG_Y,Z,HOR,VERT),
	assert(scaling(ORG_X,ORG_Y,Z,HOR,VERT)),
        !.

   start_job_errhnd(_,Mess):-
   	tree(_,CCB),
    	CCB("report_error",[Mess],_),
	!.
	   
   start_job_errhnd(_,"printing_in_progress"):-
	trap(run_Error(reperr_46),_,fail),
	!.

   start_job_errhnd(Code,_):-
	trap(run_Error(Code),_,fail),
	!.
   start_job_errhnd(_,_):-
	Msg="Cannot initialize a print job",
	dlg_Note(Msg),
   	trap(closefile(re_temp_file),_,fail),
   	fail.
   start_job_errhnd(_,_):-
	retract(printing_in_progress),
	!,
	retractall(re_page_in_process(_)).
   start_job_errhnd(_,_).

   re_init_ReportPrint(Name,PRINTWIN):-
	NW=cast(window,0),
	Printer_HEIGHT = win_GetAttrVal(NW, attr_printer_height),
	not(Printer_HEIGHT = 0),!,
	trap(assert(printing_in_progress),Code1,start_job_errhnd(Code1,"printing_in_progress")),
  	trap(openread(re_temp_file,re_temp_file_name),CODE,run_Error(CODE)),
  	readdevice(re_temp_file),
	readln(STR),
	term_str(KEEP_DBA_DOM,DBA,STR),
	not(DBA = outpage(0)),
	trap(PRINTWIN = print_StartJob(Name),Code2,start_job_errhnd(Code2,"printing_failed")),
	!.
   re_init_ReportPrint(_,_):-
	dlg_PrintSetup(_,_,_),!,
	fail.

  re_shutdown_ReportPrint(_):-
   	trap(closefile(re_temp_file),_,fail),
   	fail.
  re_shutdown_ReportPrint(Win):-
   	trap(print_EndJob(Win),_,fail),
	retract(printing_in_progress),
	retractall(re_page_in_process(_)), !.  

  re_shutdown_ReportPrint(_).
  
  set_print_Scaling(PRINTWIN):-
	margins(LEFT,TOP,_,_),
	drv_metrics(_,_,ScreenH,ScreenV,PrH,PrW,Pr_hres,Pr_vres),
	PrWInt = val(INTEGER,PrW),
	PrHInt = val(INTEGER,PrH),
	H_ORG = val(INTEGER,(LEFT * Pr_hres / 2.54)),
	V_ORG = val(INTEGER,(TOP * Pr_vres / 2.54)),
	VRES = val(INTEGER,(PrH * ScreenV / Pr_vres)),
	HRES = val(INTEGER,(PrW * ScreenH / Pr_hres)),
	win_SetMapMode(PRINTWIN,mm_Arbitrary),
	win_SetMapScale(PRINTWIN,pnt(0,0),pnt(HRES,VRES),pnt(H_ORG,V_ORG),pnt(PrWInt,PrHInt)),
	!.
  set_print_Scaling(_).

  re_process_fact(_,_,_,0):-
  	eof(re_temp_file), !.
  re_process_fact(_,outpage(0),_,0):- !.
  re_process_fact(_,outpage(PAGE),PAGE_REQ,1):-
	retractall(re_page_in_process(_)),
  	assert(re_page_in_process(PAGE)), !,
  	PAGE > PAGE_REQ.
  re_process_fact(PRINTWIN,DBA,PAGE,1):-
  	re_page_in_process(PAGE),
  	get_dbainfo(PRINTWIN,DBA,proceed).
  
   if_exist(page(PAGE),PAGE,PAGE):-!.
   if_exist(band(FROM,TO),FROM,TO):-!.
   if_exist(_,0,0):-errorexit().
   
  inside_Page1(RETURN,_,_,_,_):-
	RETURN <= 0,!.
  inside_Page1(_,PRNWIN,NCopies,PAGE,TO):-
        NEXT = PAGE + 1,
        print_Pages(PRNWIN,NCopies,NEXT,TO),!.

  print_Pages(_,_,N,M):-
	N > M,!.
  print_Pages(PRNWIN,NCopies,FROM,TO):-
        trap(ENABLE = print_StartPage(PRNWIN),_,fail),!,
        ENABLE = 1,
	set_print_Scaling(PRNWIN),
	vpi_ProcessEvents(b_true),
      re1_repeat,
  	readln(STR),
  	trap(term_str(KEEP_DBA_DOM,DBA,STR),_,write(STR)),
      re_process_fact(PRNWIN,DBA,FROM,RETURN),
	vpi_ProcessEvents(b_true),!,
        print_EndPage(PRNWIN),
	vpi_ProcessEvents(b_true),
	inside_Page1(RETURN,PRNWIN,NCopies,FROM,TO).

clauses   
  re_GetGenerationStatus(1):-
	generation_in_progress(_), !.
  
  re_GetGenerationStatus(0).
  
  re_GetPrintingStatus(1):-
	printing_in_progress, !.

  re_GetPrintingStatus(0).

%------------ ORDINARY PRINT PREVIEW IN THE GIVEN RECTANGLE -----------------
   report_Print(FILE,CCB,PCB,preview(Title,RCT,FLAGS)):-
ifdef no_scanner
	openread(re_temp_file,FILE),
	readdevice(re_temp_file),
	readblock(4,CRCBin),
	readblock(4,SizeBin),
	term_bin(DWORD,CRC,CRCBin),
	term_bin(UNSIGNED,Size,SizeBin),
	readblock(Size,Compress),
	closefile(re_temp_file),
	BIN = expandBinary(Compress),
	CRCCalc = crc32binary(BIN),
	CRCCalc = CRC,
	term_bin(REPORT,REP,BIN),
	ERRORS = no_errors(),
elsedef
        compilePrint(FILE,REP,ERRORS),
enddef
	retractall(drv_metrics(_,_,_,_,_,_,_,_)),
	retractall(generation_canceled),
	insert_cbf(PCB,FLAGS,ERRORS),
	REP = report(_,PAGEPROPLIST,_,_,_,_,_),
        insert_margins(PAGEPROPLIST,ERRORS),
	proc_orientation(PAGEPROPLIST),
	set_prev_scaling,
        win_report_Out_Create(REP,CCB,Title,RCT,ERRORS),
        errors_reflect(ERRORS),
        !.
        
%------------ TRANSFER TO RT FORMAT FOR MS WORD -----------------------------
ifdef use_rtf_converter
   report_Print(FILE,CCB,PCB,convert_rtf(FILE)):-
ifdef no_scanner
	openread(re_temp_file,FILE),
	readdevice(re_temp_file),
	readblock(4,CRCBin),
	readblock(4,SizeBin),
	term_bin(DWORD,CRC,CRCBin),
	term_bin(UNSIGNED,Size,SizeBin),
	readblock(Size,Compress),
	closefile(re_temp_file),
	BIN = expandBinary(Compress),
	CRCCalc = crc32binary(BIN),
	CRCCalc = CRC,
	term_bin(REPORT,REP,BIN),
	ERRORS = val(ERR_IDENT,no_errors()),
elsedef
        compilePrint(FILE,REP,ERRORS),
enddef
        ERRORS = no_errors(),
	REP = report(_,PAGEPROPLIST,_,_,_,_,_),
	retractall(drv_metrics(_,_,_,_,_,_,_,_)),
	retractall(generation_canceled),
        insert_margins(PAGEPROPLIST,ERRORS),
	proc_orientation(PAGEPROPLIST),
	insert_cbf(PCB,[],ERRORS),
	generate_to_rtf(REP,CCB,FILE),
        !.
enddef
%------------ REALLY PRINTING FROM THE DEFINED PAGE -------------------------
   report_Print(FILE,CCB,PCB,print(NCopies,PAGE)):-
ifdef no_scanner
	openread(re_temp_file,FILE),
	readdevice(re_temp_file),
	readblock(4,CRCBin),
	readblock(4,SizeBin),
	term_bin(DWORD,CRC,CRCBin),
	term_bin(UNSIGNED,Size,SizeBin),
	readblock(Size,Compress),
	closefile(re_temp_file),
	BIN = expandBinary(Compress),
	CRCCalc = crc32binary(BIN),
	CRCCalc = CRC,
	term_bin(REPORT,REP,BIN),
	ERRORS = val(ERR_IDENT,no_errors()),
elsedef
        compilePrint(FILE,REP,ERRORS),
enddef
        ERRORS = no_errors,
	REP = report(_,PAGEPROPLIST,_,_,_,_,_),
	retractall(drv_metrics(_,_,_,_,_,_,_,_)),
	retractall(generation_canceled),
        insert_margins(PAGEPROPLIST,ERRORS),
	proc_orientation(PAGEPROPLIST),
        if_exist(PAGE,FROM_P,TO_P),
	insert_cbf(PCB,[],ERRORS),
	re_reportPrint(REP,CCB,NCopies,FROM_P,TO_P),
        !.
   report_Print(_,_,_,_):-errorexit().
% This report_Print alows to set and get path for Saving RTF or
% Tab Separated file 
%------------ ORDINARY PRINT PREVIEW IN THE GIVEN RECTANGLE -----------------
   report_Print(FILE,CCB,PCB,preview(Title,RCT,FLAGS),_InPath):-
ifdef use_rtf_converter
   	check_SavePath(_InPath), 	
enddef   	
ifdef no_scanner
	openread(re_temp_file,FILE),
	readdevice(re_temp_file),
	readblock(4,CRCBin),
	readblock(4,SizeBin),
	term_bin(DWORD,CRC,CRCBin),
	term_bin(UNSIGNED,Size,SizeBin),
	readblock(Size,Compress),
	closefile(re_temp_file),
	BIN = expandBinary(Compress),
	CRCCalc = crc32binary(BIN),
	CRCCalc = CRC,
	term_bin(REPORT,REP,BIN),
	ERRORS = no_errors(),
elsedef
        compilePrint(FILE,REP,ERRORS),
enddef
	retractall(drv_metrics(_,_,_,_,_,_,_,_)),
	retractall(generation_canceled),
	insert_cbf(PCB,FLAGS,ERRORS),
	REP = report(_,PAGEPROPLIST,_,_,_,_,_),
        insert_margins(PAGEPROPLIST,ERRORS),
	proc_orientation(PAGEPROPLIST),
	set_prev_scaling,
        win_report_Out_Create(REP,CCB,Title,RCT,ERRORS),
        errors_reflect(ERRORS),
        !.
        
%------------ TRANSFER TO RT FORMAT FOR MS WORD -----------------------------
ifdef use_rtf_converter
   report_Print(FILE,CCB,PCB,convert_rtf(FILE),InPath):-
   	check_SavePAth(InPath), 	
ifdef no_scanner
	openread(re_temp_file,FILE),
	readdevice(re_temp_file),
	readblock(4,CRCBin),
	readblock(4,SizeBin),
	term_bin(DWORD,CRC,CRCBin),
	term_bin(UNSIGNED,Size,SizeBin),
	readblock(Size,Compress),
	closefile(re_temp_file),
	BIN = expandBinary(Compress),
	CRCCalc = crc32binary(BIN),
	CRCCalc = CRC,
	term_bin(REPORT,REP,BIN),
	ERRORS = val(ERR_IDENT,no_errors()),
elsedef
        compilePrint(FILE,REP,ERRORS),
enddef
        ERRORS = no_errors(),
	REP = report(_,PAGEPROPLIST,_,_,_,_,_),
	retractall(drv_metrics(_,_,_,_,_,_,_,_)),
	retractall(generation_canceled),
        insert_margins(PAGEPROPLIST,ERRORS),
	proc_orientation(PAGEPROPLIST),
	insert_cbf(PCB,[],ERRORS),
	generate_to_rtf(REP,CCB,FILE),
        !.
enddef
%------------ REALLY PRINTING FROM THE DEFINED PAGE -------------------------
   report_Print(FILE,CCB,PCB,print(NCopies,PAGE),_InPath):-
ifdef use_rtf_converter
   	check_SavePAth(_InPath), 	
enddef   	
ifdef no_scanner
	openread(re_temp_file,FILE),
	readdevice(re_temp_file),
	readblock(4,CRCBin),
	readblock(4,SizeBin),
	term_bin(DWORD,CRC,CRCBin),
	term_bin(UNSIGNED,Size,SizeBin),
	readblock(Size,Compress),
	closefile(re_temp_file),
	BIN = expandBinary(Compress),
	CRCCalc = crc32binary(BIN),
	CRCCalc = CRC,
	term_bin(REPORT,REP,BIN),
	ERRORS = val(ERR_IDENT,no_errors()),
elsedef
        compilePrint(FILE,REP,ERRORS),
enddef
        ERRORS = no_errors,
	REP = report(_,PAGEPROPLIST,_,_,_,_,_),
	retractall(drv_metrics(_,_,_,_,_,_,_,_)),
	retractall(generation_canceled),
        insert_margins(PAGEPROPLIST,ERRORS),
	proc_orientation(PAGEPROPLIST),
        if_exist(PAGE,FROM_P,TO_P),
	insert_cbf(PCB,[],ERRORS),
	re_reportPrint(REP,CCB,NCopies,FROM_P,TO_P),
        !.
   report_Print(_,_,_,_,_):-errorexit().

   report_Close:-
   	prevwin(WIN), !,
   	win_SendEvent(WIN,e_CloseRequest).
   report_Close.

   report_GetStatus(Generation,Printing):-
	re_GetGenerationStatus(Generation),
   	re_GetPrintingStatus(Printing), !.


ifdef use_rtf_converter

    get_save_path(InPath):-
            save_path(InPath),!.
    get_save_path(""):-!.
      
    check_SavePath(""):-
   	 save_path(_),
   	 !.
    check_SavePath(NewPath):-
   	 save_path(CurrentPath),
   	 NewPath <> CurrentPath,
   	 retractAll(save_path(_)),
   	 assert(save_path(NewPath)),!.
    check_SavePath(NewPath):-
   	 retractAll(save_path(_)),
   	 assert(save_path(NewPath)),!.
   	 
    pathCallBack(NewPath):-
  	progress_cbf(PBF,_),
	PBF(path(NewPath),100,_),!.
    pathCallBack(_):-!.

enddef
   	
   	
