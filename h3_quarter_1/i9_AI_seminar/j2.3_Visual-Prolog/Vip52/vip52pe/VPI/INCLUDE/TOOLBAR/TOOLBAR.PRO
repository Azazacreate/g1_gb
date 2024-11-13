/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

			 VISUAL Prolog

 FileName:   TOOLBAR.PRO
 PURPOSE:    Toolbar object
 Written by: Yuri Ilyin
 Revision:   LHJ/950224: Added toolbar_GetRect
 Comments:
 
******************************************************************************/
ifndef toolbar_pre_included
 #Error: this file requires include: toolbar.pre
enddef 

ifdef ws_win
global predicates
 ifdef os_nt
 procedure INTEGER GetSystemMetrics( INTEGER ) - (i) language stdcall
 elsedef
 procedure INTEGER GetSystemMetrics( INTEGER ) - (i) language pascal
 enddef
enddef

constants

	tbar_move = 52

/******************************************************************************
			MOUSE CAPTURE HANDLING
******************************************************************************/
database - toolbar_pro
  inside(MENU_TAG,LONG TimerId)
  chooseControl(MENU_TAG)

database - toolbar_mouse
determ 	flagMouseDown

predicates
procedure  toolbar_set_flagMouseDown
procedure  toolbar_release_flagMouseDown

clauses
  toolbar_set_flagMouseDown:-
   	flagMouseDown,!.
  toolbar_set_flagMouseDown:-
  	retractall(flagMouseDown),
  	assert(flagMouseDown).

  toolbar_release_flagMouseDown:-
   	retractall(flagMouseDown).

/******************************************************************************
			TOOLTIP HANDLING
******************************************************************************/
constants
	tooltip_first_time_delay   = 1000
	tooltip_show_delay         = 500
	tooltip_hide_delay         = 500

database - tooltip_base
determ  tooltip_current(WINDOW TB_Win,RCT ControlRCT,STRING Tip,PNT)
determ  tooltip_first_time_timer(LONG TimerId)
determ  tooltip_show_timer(LONG TimerId)
determ  tooltip_hide_timer(LONG TimerId,INTEGER Counter)
determ  tooltip_win(WINDOW TipW,WINDOW FontW)
determ  tooltip_in_use
determ  tooltip_first_time
determ  tooltip_first_time_creating
determ  tooltip_mouse(WINDOW,PNT) %YF 01-08-96
	tooltip_info(WINDOW TB_Win,RCT ControlRCT,STRING Tip)

predicates

determ  test_leave_ctrl(WINDOW,MENU_TAG,PNT)
procedure  tooltip_create
procedure  tooltip_register(WINDOW,RCT,STRING)
procedure  tooltip_clean_up(WINDOW TB_Win)
procedure  tooltip_validate_rect(RCT,RCT,RCT)
procedure  tooltip_validate(INTEGER,INTEGER,INTEGER)
procedure  tooltip_set_usage
procedure  tooltip_stop_usage
procedure  tooltip_check_mousemove(WINDOW,PNT) %YF 01-08-96
procedure  tooltip_check_mousetimer %YF 01-08-96
determ tooltip_mouse_in_TB(WINDOW,PNT) % -(o,o)
determ tooltip_change_if_not_current
determ tooltip_change_if_not_current(WINDOW TB_Win,RCT ControlRCT,STRING Tip,PNT)
determ  tooltip_check_first_time
determ  tooltip_check_first_time(WINDOW)
procedure  tooltip_set_first_time_timer(WINDOW)
procedure  tooltip_kill_first_time_timer
procedure  tooltip_set_show_timer(WINDOW)
procedure  tooltip_kill_show_timer
procedure  tooltip_set_hide_timer(WINDOW)
procedure  tooltip_kill_hide_timer
procedure  tooltip_get_color(COLOR,COLOR)
procedure  tooltip_try_show()
tooltip_handler : EHANDLER
tooltip_child_handler : EHANDLER

clauses
  tooltip_create:-
    tooltip_win(_,_),!.
  tooltip_create:-
    retractall(_,tooltip_base),
    Task = cast(WINDOW,vpi_GetAttrVal(attr_task_window)),
    TipW = win_CreateDynDialog(Task,
      [
        dlg(wdef(wd_Modeless,rct(0,0,0,0),"",u_Pixels),[wsf_Disabled])
      ],tooltip_handler,0),
    win_Move(TipW,rct(0,0,0,0)),
    ChW = win_Create(w_Child,rct(0,0,0,0),"",no_menu,TipW,[],tooltip_child_handler,0),
    assert(tooltip_win(TipW,ChW)).

  tooltip_register(_,_,""):- !.
  tooltip_register(TB_Win,RCT,Tip):-
    retractall(tooltip_info(TB_Win,RCT,_)),
    assert(tooltip_info(TB_Win,RCT,Tip)).

  tooltip_clean_up(TB_Win):-
    retractall(tooltip_mouse(TB_Win,_)),%YF 02-10-96
    retractall(tooltip_info(TB_Win,_,_)).

  tooltip_validate_rect(rct(_,_,R0,B0),rct(L1,T1,R1,B1),rct(L,T,R,B)):-
    tooltip_validate(R0,R1,DiffH),
    tooltip_validate(B0,B1,DiffV),
    L = L1 - DiffH,
    T = T1 - DiffV,
    R = R1 - DiffH,
    B = B1 - DiffV.

  tooltip_validate(X0,X1,0):-
    X0 >= X1,!.
  tooltip_validate(X0,X1,Diff):-
    Diff = X1 - X0.

  tooltip_set_usage:-
    tooltip_in_use,!.
  tooltip_set_usage:-
    assert(tooltip_in_use),
    assert(tooltip_first_time).

  tooltip_stop_usage:-
    retractall(tooltip_in_use),
    retractall(tooltip_first_time),
    retractall(tooltip_current(_,_,_,_)).

  tooltip_check_first_time:-
    tooltip_first_time_creating,!,% hidden during first time creating
    retractall(tooltip_first_time_creating),
    retractall(tooltip_first_time),
    assert(tooltip_first_time).
  tooltip_check_first_time.

  tooltip_check_first_time(_):-
    tooltip_check_first_time,fail.
  tooltip_check_first_time(TipW):-
    tooltip_first_time,!,
    retractall(tooltip_first_time),
    retractall(tooltip_first_time_creating),
    assert(tooltip_first_time_creating),
    tooltip_set_first_time_timer(TipW),
    fail.
  tooltip_check_first_time(_).

  tooltip_check_mousemove(TB_Win,PNT):- %YF 01-08-96
    tooltip_mouse(TB_Win,PNT),!.
  tooltip_check_mousemove(TB_Win,PNT):-
    retractall(tooltip_mouse(_,_)),
    assert(tooltip_mouse(TB_Win,PNT)).
  
  tooltip_check_mousetimer:- %YF 01-08-96
    tooltip_mouse(TB_Win,_),
    RCT = win_GetClientRect(TB_Win),
    PNT = cursor_GetPos(TB_Win),
    not(rect_PntInside(RCT,PNT)),!,
    retractall(tooltip_mouse(_,_)).
  tooltip_check_mousetimer:-
    tooltip_mouse(TB_Win,pnt(X0,Y0)),
    PNT = cursor_GetPos(TB_Win),
    PNT = pnt(X1,Y1),
    abs(X0 - X1) < 5,
    abs(Y0 - Y1) < 5,!.
  tooltip_check_mousetimer:-
    retractall(tooltip_mouse(_,_)).
  
  tooltip_mouse_in_TB(TB_Win,PNT):-
    tooltip_info(TB_Win,_,_),
    RCT = win_GetClientRect(TB_Win),
    PNT = cursor_GetPos(TB_Win),
    rect_PntInside(RCT,PNT),!,
    tooltip_set_usage.
  tooltip_mouse_in_TB(_,_):- !,
    tooltip_kill_show_timer,
    tooltip_stop_usage,
    fail.

  tooltip_change_if_not_current:-
    tooltip_mouse_in_TB(TB_Win,PNT),
    tooltip_info(TB_Win,ControlRCT,Tip),
    rect_PntInside(ControlRCT,PNT),!,
    tooltip_change_if_not_current(TB_Win,ControlRCT,Tip,PNT).
  tooltip_change_if_not_current:-
    tooltip_kill_show_timer,
    tooltip_kill_hide_timer,
    tooltip_win(TipW,_),
    win_Move(TipW,rct(0,0,0,0)),
    retractall(tooltip_current(_,_,_,_)).

  tooltip_change_if_not_current(TB_Win,ControlRCT,Tip,PNT):-
    tooltip_current(TB_Win,ControlRCT,Tip,PNT),!,
    fail.
  tooltip_change_if_not_current(TB_Win,ControlRCT,Tip,PNT):-
    tooltip_kill_show_timer,
    tooltip_kill_hide_timer,
    tooltip_win(TipW,_),
    win_Move(TipW,rct(0,0,0,0)),
    retractall(tooltip_current(_,_,_,_)),
    assert(tooltip_current(TB_Win,ControlRCT,Tip,PNT)).

  tooltip_set_first_time_timer(TipW):-
    tooltip_kill_first_time_timer,
    TimerId = timer_Set(TipW,tooltip_first_time_delay),
    assert(tooltip_first_time_timer(TimerId)).

  tooltip_kill_first_time_timer:-
    retract(tooltip_first_time_timer(TimerId)),
    timer_Kill(TimerId),
    fail.
  tooltip_kill_first_time_timer.

  tooltip_set_show_timer(TipW):-
    tooltip_kill_show_timer,
    TimerId = timer_Set(TipW,tooltip_show_delay),
    assert(tooltip_show_timer(TimerId)).

  tooltip_try_show():- %YI 002
    tooltip_win(TipW,_),
    tooltip_check_mousetimer,
    tooltip_change_if_not_current,
    tooltip_check_first_time(TipW),
    tooltip_set_show_timer(TipW),!.
  tooltip_try_show().

  tooltip_kill_show_timer:-
    retract(tooltip_show_timer(TimerId)),
    timer_Kill(TimerId),
    fail.
  tooltip_kill_show_timer.

  tooltip_set_hide_timer(TipW):-
    tooltip_kill_hide_timer,
    TimerId = timer_Set(TipW,tooltip_hide_delay),
    assert(tooltip_hide_timer(TimerId,0)).

  tooltip_kill_hide_timer:-
    retract(tooltip_hide_timer(TimerId,_)),
    timer_Kill(TimerId),
    fail.
  tooltip_kill_hide_timer.

  tooltip_get_color(FC,BC):-
    BC = vpi_GetAttrVal(attr_color_tooltipback),
    BC <> 0,!,
    FC = vpi_GetAttrVal(attr_color_tooltiptext).
  tooltip_get_color(color_Black,color_Yellow).

  tooltip_child_handler(Win,e_Create(_),0):- !,
    win_SetBackMode(Win,bk_Transparent),
    trap(Font = font_Create(ff_Helvetica,[],8),_,fail),
    win_SetFont(Win,Font).
  tooltip_child_handler(Win,e_Update(_),0):- !,
    tooltip_get_color(FC,BC),
    win_SetBrush(Win,brush(pat_Solid,BC)),
    win_SetPen(Win,pen(1,ps_Solid,BC)),
    win_SetBackColor(Win,BC),
    win_SetForeColor(Win,FC),
    RCT = win_GetClientRect(Win),
    draw_rect(Win,RCT),
    tooltip_current(_,_,Tip,_),
    draw_TextInRect(Win,RCT,Tip,-1,[ dtext_center,dtext_vcenter,dtext_noprefix ]).

  tooltip_handler(TipW,e_Timer(TimerId),0):-
    tooltip_first_time_timer(TimerId),!,
    tooltip_kill_first_time_timer,
    tooltip_set_show_timer(TipW),
    retractall(tooltip_first_time_creating).
  tooltip_handler(TipW,e_Timer(TimerId),0):-
    tooltip_show_timer(TimerId),!,
    tooltip_kill_show_timer,
    tooltip_win(TipW,ChW),
    tooltip_current(TB_Win,_,Tip,_PNT),
/*YI 002*/
    inside(CtrlId,_),!,
    CurMousePNT = cursor_GetPos(TB_Win),
    test_leave_ctrl(TB_Win,CtrlId,CurMousePNT),
/*YI 002*/
    !,tooltip_mouse(TB_Win,pnt(L,T)),!,
    win_GetTextExtent(ChW,Tip,-1,Wid,_),
    win_GetFontMetrics(ChW,_,Ascent,Descent),
    Width = Wid + 4,
    Height = Ascent + Descent + 2,
    SCRW = cast(window,vpi_GetAttrVal(attr_screen_window)),
    List = win_MapPoints(TB_Win,SCRW,[ pnt(L,T) ]),
    List = [ pnt(X,Y) ],
    SCRC = win_GetClientRect(SCRW),
    L_ = X,
ifdef ws_win
    T_ = Y + GetSystemMetrics(14),
elsedef
    T_ = Y + 16,
enddef
    R_ = L_ + Width,
    B_ = T_ + Height,
    tooltip_validate_rect(SCRC,rct(L_,T_,R_,B_),RCT),
    win_Move(TipW,RCT),
    win_Move(ChW,rct(0,0,Width,Height)),
    tooltip_set_hide_timer(TipW).
  tooltip_handler(TipW,e_Timer(TimerId),0):-
    tooltip_hide_timer(TimerId,N),
    N >= 10,!,
    tooltip_kill_hide_timer,
    win_Move(TipW,rct(0,0,0,0)).
  tooltip_handler(_,e_Timer(TimerId),0):- % YI 002
    retract(tooltip_hide_timer(TimerId,I)),!,
    Inew = I + 1,
    assert(tooltip_hide_timer(TimerId,Inew)),
    tooltip_current(TB_Win,_,_,_),!,
    inside(CtrlId,_),!,
    PNT = cursor_GetPos(TB_Win),
    test_leave_ctrl(TB_Win,CtrlId,Pnt).

database - toolbar

%--------- toolbar information ---------
  tb(WINDOW,		  % (Parent Window,
     WINDOW,		  %  Toolbar Window,
     TOOLBAR_STYLE,	  %  Toolbar Style,
     INTEGER,  	  %  Toolbar Width,
     INTEGER,	          %  Toolbar Height,
     COLOR,		  %  Background Color,
     TOOLBAR_ACTION_FUNC,%  User Action Callback,
     WINDOW)              %  Window that receives messages from toolbar

%--------- control information ---------
  ctrl(WINDOW,		% (Toolbar Window,
     MENU_TAG,         	%  Control Identifier,
     INTEGER,	        %  GroupNumber,
     TOOLBAR_CONTROL_STYLE, %  Control Style (Pushbutton or Checkbutton)
     RCT,		%  Control Rectangle,
     RESID,		%  BitMap Resource Id when released,	
     RESID,		%  BitMap Resource Id when pressed,	
     RESID,		%  BitMap Resource Id when grayed,	
     STRING,		%  Text for status bar,
     BOOLEAN,		%  Control status: true - enabled,false - disabled,
     BOOLEAN)		%  Control status: true - released,false - pressed)

%--------- listbutton information ----------
  lbut(WINDOW, 	% (Toolbar Window,
     MENU_TAG,		%  Control Identifier,
     RCT,		%  Location,
     SLIST,		%  Item list,
     BOOLEAN,		%  Control status: true - enabled,false - disabled,
     INTEGER)		%  Current position in Item list)

%--------- text information ---------
  text(WINDOW, 	% (Toolbar Window,
     MENU_TAG,		%  Control Identifier,
     TOOLBAR_TEXT_STYLE,	%  Text Style (static or context sensitive)
     RCT,		%  Text Rectangle,
     INTEGER,		%  Font style: Bold,Italic etc...
     INTEGER,		%  Font family: Times,Helvetica etc...
     SHORT,		%  Font size,
     COLOR,		%  Text color,
     STRING)		%  Initial text)

predicates
procedure  get_inits(WINDOW,TOOLBAR_STYLE,INTEGER,INTEGER,INTEGER,INTEGER)
procedure  build_control_database(TOOLBAR_STYLE,TOOLBAR_LIST,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER)
procedure  create_listcontrols(WINDOW)
procedure  RESID select_image(RESID,RESID,RESID,BOOLEAN,BOOLEAN)
procedure  show_toolbar_controls(WINDOW)
determ tb_rect(WINDOW,TOOLBAR_STYLE,INTEGER,INTEGER,RCT)
determ tbar_Invalidate(WINDOW,TOOLBAR_STYLE,INTEGER,INTEGER,RCT)
procedure  show_text1(WINDOW,RCT,INTEGER,INTEGER,SHORT,COLOR,COLOR,STRING)
determ get_flag(BOOLEAN,WSFLAG)
procedure  give_flags_and_title(TOOLBAR_STYLE,WSFLAGS,STRING)
procedure  drawImage(WINDOW,INTEGER,INTEGER,RESID)
procedure  get_width_height(WINDOW,TOOLBAR_LIST,INTEGER,INTEGER,INTEGER,INTEGER)
 send_message_to_parent_win : TOOLBAR_ACTION_FUNC
procedure  set_ctrl_to_tb_win(WINDOW,WINDOW)

tb_handler	: EHANDLER
no_handler   : EHANDLER

/*******************************************************************
	Global predicates (declared in GLOBDES.INC)
*******************************************************************/
predicates

procedure  remove_VPITBarAttr(TOOLBAR_STYLE,WINDOW)

clauses
  toolbar_create(Style,BckColor,ParentWin,TB_List,TB_Win):-
    TB_Win = toolbar_create(Style,BckColor,ParentWin,TB_List,
     send_message_to_parent_win).

  toolbar_create(Style,_BckColor,ParentWin,TB_List,ActionFunc,TB_Win):-
	ParentRCT = win_GetClientRect(ParentWin),
	ParentRCT = rct(_,_,Width,Height),
  	give_flags_and_title(Style,FLAGS,Title),
	UnKnown = cast(window,0),
        FontWin = win_Create(w_Child,rct(0,0,0,0),"",no_menu,ParentWin,[],no_handler,0),
	get_width_height(FontWin,TB_List,0,0,TOOLBAR_WIDTH,TOOLBAR_HEIGHT),
	win_Destroy(FontWin),
	BckColor = win_GetAttrVal(ParentWin,attr_color_btnface),	% 3.02.2000 BB!
	assert(tb(ParentWin,UnKnown,Style,TOOLBAR_WIDTH,TOOLBAR_HEIGHT,BckColor,ActionFunc,ParentWin)),
	get_inits(UnKnown,Style,Height,Width,T,L),
	tooltip_create,
	build_control_database(Style,TB_List,toolbar_margin,toolbar_margin,toolbar_margin,TB_Height,TB_Width),
	B = T + TB_Height,
	R = L + TB_Width,
	RCT = rct(L,T,R,B),
	TB_Win = win_CreateDyn(
	 [childwin(wdef(w_Child,RCT,Title,u_pixels),0,
         FLAGS)],ParentWin,tb_handler,0),
	set_ctrl_to_tb_win(UnKnown,TB_WIN),
	create_listcontrols(TB_Win),
	toolbar_resize(ParentWin).

predicates
procedure set_ctrl_to_tb_win1(WINDOW)
determ  split_control_text(STRING,STRING,STRING) %YF 12/04/96
clauses
  set_ctrl_to_tb_win1(TBWin):-
	ctrl(TBWin,_,_,_,rct(CurrentL,CurrentT,R,B),_,_,_,CtrlText,_,_),
	split_control_text(CtrlText,Tip,_),
	tooltip_register(TBWin,rct(CurrentL,CurrentT,R,B),Tip),
	fail.
  set_ctrl_to_tb_win1(_).

predicates
procedure build_control_database1(TOOLBAR_STYLE,WINDOW TBWin,TOOLBAR_LIST,SHORT,SHORT)
determ  horizontal(TOOLBAR_STYLE)

clauses

  build_control_database1(_,_,[],_,_):-!.
  %---- 1. Assert next control (pushbutton or checkbutton)
  build_control_database1(Style,TBWin,[C|Rest],CurrentT,CurrentL):-
	horizontal(Style),
	C=tb_ctrl(Id,CtrlStyle,Released,Pressed,Gray,CtrlText,Enabled,Rel),!,
	PICT = pict_GetFromRes(Released),
	pict_GetSize(PICT,X,Y,_Size),
	pict_Destroy(PICT),
	B = CurrentT + Y,
	RX = CurrentL + X,
	assert(ctrl(TBWin,Id,0,CtrlStyle,rct(CurrentL,CurrentT,RX,B),
			Released,Pressed,Gray,CtrlText,Enabled,Rel)),
	R = val(short,RX),
	build_control_database1(Style,TBWin,Rest,CurrentT,R).
  build_control_database1(Style,TBWin,[C|Rest],CurrentT,_):-
	C=tb_ctrl(Id,CtrlStyle,Released,Pressed,Gray,CtrlText,Enabled,Rel),!,
	PICT = pict_GetFromRes(Released),
	pict_GetSize(PICT,X,Y,_Size),
	pict_Destroy(PICT),
	BY = CurrentT + Y,
	R = toolbar_margin + X,
	assert(ctrl(TBWin,Id,0,CtrlStyle,rct(toolbar_margin,CurrentT,R,BY),
			Released,Pressed,Gray,CtrlText,Enabled,Rel)),
	B = val(short,BY),
	build_control_database1(Style,TBWin,Rest,B,0).
  %---- 2. Assert next text (static or context sensitive)
  build_control_database1(Style,TBWin,[C|Rest],CurrentT,CurrentL):-
	horizontal(Style),
	C=tb_text(Id,TextStyle,Width,FontStyle,FontFamily,FontSize,Color,Text),
	tb(_,TBWin,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	T = CurrentT,
	B = T + TOOLBAR_HEIGHT,
	RX = CurrentL + Width,
	assert(text(TBWin,Id,TextStyle,rct(CurrentL,T,RX,B),
				FontStyle,FontFamily,FontSize,Color,Text)),
	R = val(short,RX),
	build_control_database1(Style,TBWin,Rest,CurrentT,R).
  build_control_database1(Style,TBWin,[C|Rest],CurrentT,_):-
	C=tb_text(Id,TextStyle,Width,FontStyle,FontFamily,FontSize,Color,Text),
	tb(_,TBWin,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	B = CurrentT + TOOLBAR_HEIGHT,
	BY = toolbar_margin + B,
	R = toolbar_margin + Width,
	assert(text(TBWin,Id,TextStyle,rct(toolbar_margin,CurrentT,R,B),
				FontStyle,FontFamily,FontSize,Color,Text)),
	Bottom = val(short,BY),
	build_control_database1(Style,TBWin,Rest,Bottom,0).
  %---- 3. Assert next listbutton
  build_control_database1(Style,TBWin,[C|Rest],CurrentT,CurrentL):-
	horizontal(Style),
	C=tb_lbut(Id,Width,SList,Enabled,Pos),
	tb(_,TBWin,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	RX=CurrentL + Width,
	B=CurrentT + TOOLBAR_HEIGHT,
	assert(lbut(TBWin,Id,rcT(CurrentL,CurrentT,RX,B),SList,
		Enabled,Pos)),
	R = val(short,RX),
	build_control_database1(Style,TBWin,Rest,CurrentT,R).
  build_control_database1(Style,TBWin,[C|Rest],CurrentT,CurrentL):-
	C=tb_lbut(_,_,_,_,_),!,
	build_control_database1(Style,TBWin,Rest,CurrentT,CurrentL).
  %---- 4. Assert next separator - space between buttons
  build_control_database1(Style,TBWin,[C|Rest],CurrentT,CurrentL):-
	horizontal(Style),
	C = separator,!,
	RX = CurrentL + toolbar_separator_size,
	R = val(short,RX),
	build_control_database1(Style,TBWin,Rest,CurrentT,R).
  build_control_database1(Style,TBWin,[C|Rest],CurrentT,_):-
	C = separator,!,
	BY = CurrentT + toolbar_separator_size,
	B = val(short,BY),
	build_control_database1(Style,TBWin,Rest,B,0).
  build_control_database1(_,_,_,_,_).

predicates
procedure toolbar_retract_controls(WINDOW TBWin)
clauses
  toolbar_retract_controls(TBWin):-
	retract(lbut(TBWin,CtrlId,_,_,_,_)),
	CtrlWin = win_GetCtlHandle(TBWin,CtrlId),
	win_Destroy(CtrlWin),!.
  toolbar_retract_controls(_).


  toolbar_reload(TBWin,TB_List):-
	tb(_,TBWin,Style,_,_,_,_,_),!,
	retractall(ctrl(TBWin,_,_,_,_,_,_,_,_,_,_)),
	retractall(text(TBWin,_,_,_,_,_,_,_,_)),
	toolbar_retract_controls(TBWin),
	tooltip_create,
	tooltip_clean_up(TBWin),
	build_control_database1(Style,TBWin,TB_List,toolbar_margin,toolbar_margin),
	create_listcontrols(TBWin),
	set_ctrl_to_tb_win1(TBWin),
	win_Invalidate(TBWin).
  toolbar_reload(_,_).

  toolbar_resize(ParentWin):-
	tb(ParentWin,TB_Win,Style,_,_,_,_,_),
	  not(Style = tb_moveable(_,_)),
	  not(Style = tb_inside(_)),
	  win_PostEvent(TB_Win,e_User(tbar_move,0)),
	fail.
  toolbar_resize(_).

  toolbar_remove(TB_Win):-
	tb(ParentWin,TB_Win,Style,_,_,_,_,_),
	win_Destroy(TB_Win),
	remove_VPITBarAttr(Style,ParentWin),
	toolbar_resize(ParentWin),!.
  toolbar_remove(ParentWin):-
	tb(ParentWin,TB_Win,Style,_,_,_,_,_),
	  win_Destroy(TB_Win),
	  remove_VPITBarAttr(Style,ParentWin),
	fail.
  toolbar_remove(ParentWin):-
	toolbar_resize(ParentWin).

  toolbar_SetValue(ParentWin,CtrlId,text_value(Text)):-
	tb(ParentWin,TB_Win,_,_,_,BColor,_,_),
	retract(text(TB_Win,CtrlId,TextStyle,RCT,F1,F2,F3,FColor,_)),!,
	assert(text(TB_Win,CtrlId,TextStyle,RCT,F1,F2,F3,FColor,Text)),
	show_text1(TB_Win,RCT,F1,F2,F3,FColor,BColor,Text).
  toolbar_SetValue(ParentWin,CtrlId,ctrl_value(Enable,Rel)):-
	tb(ParentWin,TB_Win,_,_,_,_,_,_),
	retract(ctrl(TB_Win,CtrlId,Gr,Style,
		rct(L,T,R,B),Released,Pressed,Gray,Text,_,_)),!,
	assert(ctrl(TB_Win,CtrlId,Gr,Style,rct(L,T,R,B),Released,
		Pressed,Gray,Text,Enable,Rel)),
	Image = select_image(Released,Pressed,Gray,Enable,Rel),
	drawImage(TB_Win,L,T,Image).

  toolbar_SetValue(ParentWin,CtrlId,lbut_value(Enabled,Pos)):-
	tb(ParentWin,TB_Win,_,_,_,_,_,_),
	retract(lbut(TB_Win,CtrlId,RCT,SList,_,_)),
	assert(lbut(TB_Win,CtrlId,RCT,SList,Enabled,Pos)),
	LBW = win_GetCtlHandle(TB_Win,CtrlId),
	lbox_Suspend(LBW),
	lbox_SetSel(LBW,Pos,b_true),
	lbox_Resume(LBW),
	get_Flag(Enabled,FLAG),
	win_SetState(LBW,[FLAG]),!.
  toolbar_SetValue(_,_,_).
  
  toolbar_GetValue(ParentWin,CtrlId,ctrl_value(Enabled,Released)):-
	tb(ParentWin,TB_Win,_,_,_,_,_,_),
	ctrl(TB_Win,CtrlId,_,_,_,_,_,_,_,Enabled,Released),!.
  toolbar_GetValue(ParentWin,CtrlId,text_value(Text)):-
	tb(ParentWin,TB_Win,_,_,_,_,_,_),
	text(TB_Win,CtrlId,_,_,_,_,_,_,Text),!.
  toolbar_GetValue(ParentWin,CtrlId,lbut_value(Enabled,Pos)):-
	tb(ParentWin,TB_Win,_,_,_,_,_,_),
	lbut(TB_Win,CtrlId,_,_,Enabled,Pos),!.
  toolbar_GetValue(_,_,none).

  toolbar_GetRect(ParentWin,Style,RCT):-
	tb(ParentWin,TB_Win,Style,_,_,_,_,_),
	ParentRCT = win_GetClientRect(ParentWin),
	ParentRCT = rct(_,_,Width,Height),
	tb_rect(TB_Win,Style,Height,Width,RCT),!.	% calculate new rectangle

  toolbar_GroupControls(_,_,[]):-!.
  toolbar_GroupControls(ParentWin,Group,[CtrlId|ListId]):-
	tb(ParentWin,TB_Win,_,_,_,_,_,_),
	ctrl(TB_Win,CtrlId,OldGroup,_,_,_,_,_,_,_,_),
	OldGroup <> Group,
	retract(ctrl(TB_Win,CtrlId,_,Style,
		RCT,Released,Pressed,Gray,Text,EN,REL)),!,
	assert(ctrl(TB_Win,CtrlId,Group,Style,
		RCT,Released,Pressed,Gray,Text,EN,REL)),
	toolbar_GroupControls(ParentWin,Group,ListId).
  toolbar_GroupControls(ParentWin,Group,[_|ListId]):-!,
	toolbar_GroupControls(ParentWin,Group,ListId).
  toolbar_GroupControls(_,_,_):-errorexit(). % Should never be called !

  toolbar_GetPressedButton(ParentWin,Group,CtrlId):-
    tb(ParentWin,TB_Win,_,_,_,_,_,_),
    ctrl(TB_Win,CtrlId,Group,_,_,_,_,_,_,_,b_false),!.

  toolbar_SetPressedButton(_ParentWin,0,_NewCtrlId):-!.
  toolbar_SetPressedButton(ParentWin,Group,NewCtrlId):-
	tb(ParentWin,TB_Win,_,_,_,_,_,_),
	ctrl(TB_Win,CtrlId,Group,_,_,_,_,_,_,_,b_false),
	NewCtrlId <> CtrlId,
  	 toolbar_SetValue(ParentWin,CtrlId,
  	   ctrl_value(b_true,b_true)),
  	fail.
  toolbar_SetPressedButton(ParentWin,_,CtrlId):-
  	toolbar_SetValue(ParentWin,CtrlId,
  	   ctrl_value(b_true,b_false)),!.

  toolbar_MesRedirect(ParentWin,MesWin):-
	tb(ParentWin,TB_Win,_,_,_,_,_,OldMesWin),
	  OldMesWin <> MesWin,
	  retract(tb(ParentWin,TB_Win,Style,TB_WID,TB_HEI,Color,TB_List,OldMesWin)),
	  assert(tb(ParentWin,TB_Win,Style,TB_WID,TB_HEI,Color,TB_List,MesWin)),
	fail.
  toolbar_MesRedirect(_,_).

  %++++++ Dummy predicate +++++++

  toolbar_no_action(_,_,_).

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
determ  multiple_rows(TOOLBAR_STYLE)
procedure  set_new_VPITBarAttr(TOOLBAR_STYLE,INTEGER,WINDOW)

clauses
  split_control_text(CtrlText,Tip,Text):- %YF 12/04/96
	searchchar(CtrlText,';',Pos),!,
  	Length = Pos - 1,
	frontstr(Length,CtrlText,Tip ,Rest),
	frontchar(Rest,_,Text).
  split_control_text(Text,"",Text).

  multiple_rows(tb_moveable(_,_)):-!.
  multiple_rows(tb_inside(_)).

  horizontal(Style):-multiple_rows(Style),!.
  horizontal(tb_top):-!.
  horizontal(tb_bottom).

  set_new_VPITBarAttr(_,_,PW):-
	WinType = win_GetType(PW),
	WinType <> w_Task,!. 
%  set_new_VPITBarAttr(_,_,_):-			% BB! 7.08.96
%	MDI = vpi_GetAttrVal(attr_win_mdi),
%	MDI = 0,!.
  set_new_VPITBarAttr(tb_top,Height,_):-
	vpi_SetAttrVal(attr_win_tbar,Height),!.
  set_new_VPITBarAttr(tb_bottom,Height,_):-
	vpi_SetAttrVal(attr_win_sbar,Height),!.
  set_new_VPITBarAttr(tb_left,Width,_):-
	vpi_SetAttrVal(attr_win_lbar,Width),!.
  set_new_VPITBarAttr(tb_right,Width,_):-
	vpi_SetAttrVal(attr_win_rbar,Width),!.
  set_new_VPITBarAttr(_,_,_):-errorexit(). % Should never be called !

  remove_VPITBarAttr(_,PW):-
	WinType = win_GetType(PW),
	WinType <> w_Task,!. 
  remove_VPITBarAttr(_,_):-
	MDI = vpi_GetAttrVal(attr_win_mdi),
	MDI = 0,!.
  remove_VPITBarAttr(tb_top,_):-
	vpi_SetAttrVal(attr_win_tbar,0),!.
  remove_VPITBarAttr(tb_bottom,_):-
	vpi_SetAttrVal(attr_win_sbar,0),!.
  remove_VPITBarAttr(tb_left,_):-
	vpi_SetAttrVal(attr_win_lbar,0),!.
  remove_VPITBarAttr(tb_right,_):-
	vpi_SetAttrVal(attr_win_rbar,0),!.
  remove_VPITBarAttr(_AnyOther,_):-errorexit().
	
  give_flags_and_title(tb_moveable(Title,_),[wsf_TitleBar,wsf_ClipSiblings],Title):-!.
  give_flags_and_title(_,[wsf_ClipSiblings],""):-!.

  send_message_to_parent_win(ParentWin,CtrlId,ctrl_value(b_true,_)):-
	tb(ParentWin,TB_Win,_,_,_,_,_,MessWin),
	ctrl(TB_Win,CtrlId,_,pushb,_,_,_,_,_,_,_),!,
	win_PostEvent(MessWin,e_Menu(CtrlId,c_Nothing)).
  send_message_to_parent_win(ParentWin,CtrlId,ctrl_value(b_true,_)):-
	tb(ParentWin,TB_Win,_,_,_,_,_,MessWin),
	ctrl(TB_Win,CtrlId,_,checkb,_,_,_,_,_,_,_),!,
	UnKnown = cast(window,0),
	win_SendEvent(MessWin,e_Control(CtrlId,wc_CheckBox,UnKnown,
	  activated)).
  send_message_to_parent_win(ParentWin,CtrlId,lbut_value(b_true,_Pos)):-
	tb(ParentWin,TB_Win,_,_,_,_,_,MessWin),
	lbut(TB_Win,CtrlId,_,_,_,_),
	WIN  = win_GetCtlHandle(TB_Win,CtrlId),!,
	win_SendEvent(MessWin,e_Control(CtrlId,wc_LBoxButton,WIN,
	  selchanged())).
  send_message_to_parent_win(_ParentWin,_CtrlId,_).

/*******************************************************************
	set controls to toolbar window
*******************************************************************/

 set_ctrl_to_tb_win(UnKnown,TB_WIN):-
	retract(tb(ParentWin,UnKnown,Style,TOOLBAR_WIDTH,TOOLBAR_HEIGHT,
	 BckColor,ActionFunc,MesWin)),
	assert(tb(ParentWin,TB_WIN,Style,TOOLBAR_WIDTH,TOOLBAR_HEIGHT,
	 BckColor,ActionFunc,MesWin)),
	fail.
 set_ctrl_to_tb_win(UnKnown,TB_WIN):-
	retract(ctrl(UnKnown,Id,0,CtrlStyle,rct(CurrentL,CurrentT,R,B),
			Released,Pressed,Gray,CtrlText,Enabled,Rel)),
	split_control_text(CtrlText,Tip,Text),%YF 12/04/96
	assert(ctrl(TB_WIN,Id,0,CtrlStyle,rct(CurrentL,CurrentT,R,B),
			Released,Pressed,Gray,Text,Enabled,Rel)),
	tooltip_register(TB_WIN,rct(CurrentL,CurrentT,R,B),Tip),%YF 12/04/96
	fail.
 set_ctrl_to_tb_win(UnKnown,TB_WIN):-
	retract(text(UnKnown,Id,TextStyle,rct(CurrentL,T,R,B),
				FontStyle,FontFamily,FontSize,Color,Text)),
	assert(text(TB_WIN,Id,TextStyle,rct(CurrentL,T,R,B),
				FontStyle,FontFamily,FontSize,Color,Text)),
	fail.
 set_ctrl_to_tb_win(UnKnown,TB_WIN):-
	retract(lbut(UnKnown,Id,rct(CurrentL,T,R,B),SList,Enabled,Pos)),
	assert(lbut(TB_WIN,Id,rct(CurrentL,T,R,B),SList,Enabled,Pos)),
	fail.
 set_ctrl_to_tb_win(_,_).


/*******************************************************************
	Create listbuttons
*******************************************************************/

  create_listcontrols(TB_Win):-
	lbut(TB_Win,Id,rcT(L,T0,R,_),SList,Enabled,Pos),
	  T = T0 + 1,
	  B = T + toolbar_listbutton_height,
	  LBW = win_CreateControl(wc_LBoxButton,rcT(L,T,R,B),"",TB_Win,[],Id),
	  lbox_Suspend(LBW),
	  lbox_Add(LBW,-1,SList),
	  lbox_SetSel(LBW,Pos,b_true),
	  lbox_Resume(LBW),
	  get_Flag(Enabled,FLAG),
	  win_SetState(LBW,[FLAG]),
	fail.
  create_listcontrols(_).

/*******************************************************************
	Calculate toolbar's initial position and
	first pushbutton's initial position
*******************************************************************/
%
% get_inits(ToolbarWindow,		     i,
%	    Style,			     i,
%	    ParentHeight,ParentWidth,	     i,i,
%	    ToolbarTop,ToolbarLeft,	     o,o,  in Parent win
%	    FirstButtonTop)		     o      in Toolbar win
%

predicates

procedure  get_inits_for_twin(WINDOW,INTEGER,INTEGER,INTEGER,INTEGER)

clauses

  get_inits(_,tb_inside(pnT(L,T)),_,_,T,L):-!.
  get_inits(_,tb_moveable(_,pnT(L,T)),_,_,T,L):-!.
  get_inits(_,tb_top,_,_,0,0):-!.
  get_inits(W,tb_left,_,_,T,0):-
	tb(PW,W,_,_,_,_,_,_),!,
	get_inits_for_twin(PW,_,T,_,_),!.
  get_inits(W,tb_bottom,Height,_,T,0):-
	tb(_,W,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	T = Height - TOOLBAR_HEIGHT - toolbar_border_size.
  get_inits(W,tb_right,_,Width,T,L):-
	tb(PW,W,_,TOOLBAR_WIDTH,_,_,_,_),!,
	get_inits_for_twin(PW,_,T,_,_),
	L = Width - TOOLBAR_WIDTH - toolbar_border_size.
  get_inits(_,_,_,_,0,0):-!.

  get_inits_for_twin(PW,L,T,R,B):-
	WinType = win_GetType(PW),
	WinType = w_Task,
	L = vpi_GetAttrVal(attr_win_lbar),
	T = vpi_GetAttrVal(attr_win_tbar),
	R = vpi_GetAttrVal(attr_win_rbar),
	B = vpi_GetAttrVal(attr_win_sbar),
	!.
  get_inits_for_twin(_,0,0,0,0):-!.

/*******************************************************************
	Calculate new toolbar's size during ParentWin E_SIZE event
*******************************************************************/

% Horizontal toolbars have the same width as ParentWin

  tb_rect(TB_Win,tb_top,_,Width,rct(0,0,Width,HEIGHT)):-
    	tb(_,TB_Win,_,_,TOOLBAR_HEIGHT,_,_,_),!,
    	HEIGHT = TOOLBAR_HEIGHT + toolbar_border_size.
  tb_rect(TB_Win,tb_bottom,Height,Width,rct(0,T,Width,Height)):-
    	tb(_,TB_Win,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	T = Height - TOOLBAR_HEIGHT - toolbar_border_size.


% Vertical toolbars have the same height as ParentWin

  tb_rect(TB_Win,tb_left,TWHeight,_,rct(0,T,WIDTH,Height)):-
    	tb(PW,TB_Win,_,TOOLBAR_WIDTH,_,_,_,_),!,
	get_inits_for_twin(PW,_,T,_,B),
	Height = TWHeight - B,
    	WIDTH = TOOLBAR_WIDTH + toolbar_border_size.
  tb_rect(TB_Win,tb_right,TWHeight,Width,rct(L,T,Width,Height)):-
    	tb(PW,TB_Win,_,TOOLBAR_WIDTH,_,_,_,_),!,
	get_inits_for_twin(PW,_,T,_,B),
	Height = TWHeight - B,
	L = Width - TOOLBAR_WIDTH - toolbar_border_size.

/*******************************************************************
	Update old ornamitation field of toolbar
*******************************************************************/

  tbar_Invalidate(TB_Win,Style,_Height,Width,OldRCT):-
	horizontal(Style),
	!,
	OldRCT = rct(_,_,OldR,OldB),
	InvL = OldR - 2,
	win_Invalidate(TB_Win,rct(InvL,0,Width,OldB)).
  tbar_Invalidate(TB_Win,_,Height,_Width,OldRCT):-
	OldRCT = rct(_,_,OldR,OldB),
	InvT = OldB - 5,
	win_Invalidate(TB_Win,rct(0,InvT,OldR,Height)).

/*******************************************************************
	Translate TOOLBAR_LIST to database facts
*******************************************************************/

predicates
procedure  max_size(INTEGER,INTEGER,INTEGER)
procedure  FONT try_crt_tb_font(FontFamily,FontStyle,INTEGER) - (i,i,i)

clauses

%  build_control_database(Style,TB_List,i,i,
%			  CurrentT,		i,	Current vert pos
%			  CurrentL,		i,	Current horiz pos
%			  MaxL,			i,	Length of longest row
%			  Height,Width)		o,o	Toolbar size 

  %---- 1. End of recursion: returnes Height & Width

  build_control_database(tb_inside(_),[],CurrentT,_,MaxL,Height,Width):-
	UnKnown = cast(window,0),
	tb(_,UnKnown,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	Height = CurrentT + TOOLBAR_HEIGHT + toolbar_margin,
	Width = MaxL + toolbar_margin.

%strange VPI behavior
%begin
  build_control_database(tb_moveable(_,_),[],CurrentT,_,MaxL,Height,Width):-
  	trap(B = vpi_GetAttrVal(attr_win_mdi),_,fail),
  	B = b_true,
	TaskWin = cast(window,vpi_GetAttrVal(attr_task_window)),
	UnKnown = cast(window,0),
	tb(TaskWin,UnKnown,_,_,TOOLBAR_HEIGHT,_,_,_),!,
  	H1 = vpi_GetAttrVal(attr_title_height),
	Height = CurrentT + TOOLBAR_HEIGHT + toolbar_margin + H1 + 2,
	Width = MaxL + toolbar_margin + 2.
%end

  build_control_database(tb_moveable(_,_),[],CurrentT,_,MaxL,Height,Width):-
	UnKnown = cast(window,0),
	tb(_,UnKnown,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	Height = CurrentT + TOOLBAR_HEIGHT + toolbar_margin,
	Width = MaxL + toolbar_margin.
  build_control_database(Style,[],_,_,_,HEIGHT,Width):-
	UnKnown = cast(window,0),
	horizontal(Style),
	tb(ParentWin,UnKnown,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	HEIGHT = TOOLBAR_HEIGHT + toolbar_border_size,
	set_new_VPITBarAttr(Style,Height,ParentWin),
	RCT = win_GetClientRect(ParentWin),
	RCT = rct(_,_,Width,_).
  build_control_database(Style,[],_,_,_,Height,WIDTH):-
	UnKnown = cast(window,0),
	tb(ParentWin,UnKnown,_,TOOLBAR_WIDTH,_,_,_,_),!,
	WIDTH = TOOLBAR_WIDTH + toolbar_border_size,
	set_new_VPITBarAttr(Style,WIDTH,ParentWin),
	RCT = win_GetClientRect(ParentWin),
	RCT = rct(_,_,_,Height).

  %---- 2. Assert next control (pushbutton or checkbutton)

  build_control_database(Style,[C|Rest],CurrentT,CurrentL,MaxL,H,W):-
	UnKnown = cast(window,0),
	horizontal(Style),
	C=tb_ctrl(Id,CtrlStyle,Released,Pressed,Gray,CtrlText,Enabled,Rel),!,
	PICT = pict_GetFromRes(Released),
	pict_GetSize(PICT,X,Y,_Size),
	pict_Destroy(PICT),
	B = CurrentT + Y,
	R = CurrentL + X,
	assert(ctrl(UnKnown,Id,0,CtrlStyle,rct(CurrentL,CurrentT,R,B),
			Released,Pressed,Gray,CtrlText,Enabled,Rel)),
	max_size(MaxL,R,NewMaxL),
	build_control_database(Style,Rest,CurrentT,R,NewMaxL,H,W).

  build_control_database(Style,[C|Rest],CurrentT,_,_,H,W):-
	C=tb_ctrl(Id,CtrlStyle,Released,Pressed,Gray,CtrlText,Enabled,Rel),!,
	PICT = pict_GetFromRes(Released),
	pict_GetSize(PICT,X,Y,_Size),
	pict_Destroy(PICT),
	B = CurrentT + Y,
	R = toolbar_margin + X,
	UnKnown = cast(window,0),
	assert(ctrl(UnKnown,Id,0,CtrlStyle,rct(toolbar_margin,CurrentT,R,B),
			Released,Pressed,Gray,CtrlText,Enabled,Rel)),
	build_control_database(Style,Rest,B,0,0,H,W).

  %---- 3. Assert next text (static or context sensitive)

  build_control_database(Style,[C|Rest],CurrentT,CurrentL,MaxL,H,W):-
	horizontal(Style),
	C=tb_text(Id,TextStyle,Width,FontStyle,FontFamily,FontSize,Color,Text),
	UnKnown = cast(window,0),
	tb(_,UnKnown,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	T = CurrentT,
	B = T + TOOLBAR_HEIGHT,
	R = CurrentL + Width,
	assert(text(UnKnown,Id,TextStyle,rct(CurrentL,T,R,B),
				FontStyle,FontFamily,FontSize,Color,Text)),
	max_size(MaxL,R,NewMaxL),
	build_control_database(Style,Rest,CurrentT,R,NewMaxL,H,W).

  build_control_database(Style,[C|Rest],CurrentT,_,_,H,W):-
	C=tb_text(Id,TextStyle,Width,FontStyle,FontFamily,FontSize,Color,Text),
	UnKnown = cast(window,0),
	tb(_,UnKnown,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	B = CurrentT + TOOLBAR_HEIGHT,
	Bottom = toolbar_margin + B,
	R = toolbar_margin + Width,
	assert(text(UnKnown,Id,TextStyle,rct(toolbar_margin,CurrentT,R,B),
				FontStyle,FontFamily,FontSize,Color,Text)),
	build_control_database(Style,Rest,Bottom,0,0,H,W).

  %---- 4. Assert next listbutton

  build_control_database(Style,[C|Rest],CurrentT,CurrentL,MaxL,H,W):-
	horizontal(Style),
	C=tb_lbut(Id,Width,SList,Enabled,Pos),
	UnKnown = cast(window,0),
	tb(_,UnKnown,_,_,TOOLBAR_HEIGHT,_,_,_),!,
	R=CurrentL + Width,
	B=CurrentT + TOOLBAR_HEIGHT,
	assert(lbut(UnKnown,Id,rcT(CurrentL,CurrentT,R,B),SList,
		Enabled,Pos)),
	max_size(MaxL,R,NewMaxL),
	build_control_database(Style,Rest,CurrentT,R,NewMaxL,H,W).

  build_control_database(Style,[C|Rest],CurrentT,CurrentL,MaxL,H,W):-
	C=tb_lbut(_,_,_,_,_),!,
	build_control_database(Style,Rest,CurrentT,CurrentL,MaxL,H,W).

  %---- 5. Assert next separator - space between buttons

  build_control_database(Style,[C|Rest],CurrentT,CurrentL,MaxL,H,W):-
	horizontal(Style),
	C = separator,!,
	R = CurrentL + toolbar_separator_size,
	max_size(MaxL,R,NewMaxL),
	build_control_database(Style,Rest,CurrentT,R,NewMaxL,H,W).

  build_control_database(Style,[C|Rest],CurrentT,_,_,H,W):-
	C = separator,!,
	B = CurrentT + toolbar_separator_size,
	build_control_database(Style,Rest,B,0,0,H,W).

  %---- 6. Begin new row of controls (only in tb_moveable and tb_inside)

  build_control_database(Style,[C|Rest],CurrentT,_,MaxL,H,W):-
	multiple_rows(Style),
	C = new_row,
	UnKnown = cast(window,0),
	tb(_,UnKnown,_,_TOOLBAR_WIDTH,TOOLBAR_HEIGHT,_,_,_),!,
	NewT = CurrentT + TOOLBAR_HEIGHT,
	build_control_database(Style,Rest,NewT,toolbar_margin,MaxL,H,W).

  build_control_database(Style,[C|Rest],CurrentT,CurrentL,MaxL,H,W):-
	C=new_row,!,
	build_control_database(Style,Rest,CurrentT,CurrentL,MaxL,H,W).

  build_control_database(_,_,_,_,_,0,0):-!.%Error

  %------------------------------------------------------------

  max_size(X,Y,X):-X>=Y,!.
  max_size(_,Y,Y).

  %------------------------------------------------------------

  get_width_height(_FontWin,[],0,0,toolbar_height_text,toolbar_height_text):-!.
  get_width_height(_FontWin,[],W,H,W,H):-!.
  get_width_height(FontWin,[tb_ctrl(_ID,_STYLE,RESID,_,_,_,_,_)|T],
   WID,HEI,TOOLBAR_WIDTH,TOOLBAR_HEIGHT):-!,
	PICTURE  = pict_GetFromRes(RESID),
	pict_GetSize(PICTURE,WID1,HEI1,_Size),
	pict_Destroy(PICTURE),
	max_size(WID,WID1,WID2),
	max_size(HEI,HEI1,HEI2),
  	get_width_height(FontWin,T,WID2,HEI2,TOOLBAR_WIDTH,TOOLBAR_HEIGHT).
  get_width_height(FontWin,[tb_lbut(_ID,WID1,_,_,_)|T],
   WID,HEI,TOOLBAR_WIDTH,TOOLBAR_HEIGHT):-!,
	HEI1 = 24,
	max_size(WID,WID1,WID2),
	max_size(HEI,HEI1,HEI2),
  	get_width_height(FontWin,T,WID2,HEI2,TOOLBAR_WIDTH,TOOLBAR_HEIGHT).
  get_width_height(FontWin,[tb_text(_ID,_STYLE,WidthText,FontStyle,FontFamily,FontSize,_,_)|T],
   WID,HEI,TOOLBAR_WIDTH,TOOLBAR_HEIGHT):-!,
   	FONT = try_crt_tb_font(FontFamily,[FontStyle],FontSize),
   	win_SetFont(FontWin,Font),
   	win_GetTextExtent(FontWin,"Wy",-1,_,HeightText),
	max_size(WID,WidthText,WID2),
	max_size(HEI,HeightText,HEI2),
  	get_width_height(FontWin,T,WID2,HEI2,TOOLBAR_WIDTH,TOOLBAR_HEIGHT).
  get_width_height(FontWin,[_|T],WID2,HEI2,TOOLBAR_WIDTH,TOOLBAR_HEIGHT):-!,
  	get_width_height(FontWin,T,WID2,HEI2,TOOLBAR_WIDTH,TOOLBAR_HEIGHT).
  get_width_height(_,_,_,_,0,0):-errorexit(). % Should never be called !

  try_crt_tb_font(FontFamily,FontStyle,FontSize,FONT):-
   	trap(FONT = font_Create(FontFamily,FontStyle,FontSize),_,fail),!.
  try_crt_tb_font(_,_,_,FONT):-
   	FONT = font_Create(ff_System,[],10).

  drawImage(WIN,L,T,RESID):-
 	PICTURE  = pict_GetFromRes(RESID),
 	pict_DrawEx(WIN,PICTURE,pnt(L,T),rop_SrcCopy,b_false),
 	pict_Destroy(PICTURE).

/*******************************************************************
	Draw toolbar controls
*******************************************************************/

  %------ Pushbuttons & Checkbuttons --------
  show_toolbar_controls(TB_Win):-
	ctrl(TB_Win,_,_,_,rct(L,T,_,_),Released,Pressed,Gray,_,Enable,Rel),
	  Image = select_image(Released,Pressed,Gray,Enable,Rel),
	  drawImage(TB_Win,L,T,Image),
	fail.

  %------ Static Text & Context Sensitive Text -------
  show_toolbar_controls(TB_Win):-
	tb(_,TB_Win,_,_,_,BColor,_,_),
%	horizontal(TB_Style),
	text(TB_Win,_,_,RCT,Style,Family,Size,FColor,Text),
	  show_text1(TB_Win,RCT,Style,Family,Size,FColor,BColor,Text),
	fail.
  show_toolbar_controls(_).

  select_image(Image,_,_,b_true,b_true,Image):-!.
  select_image(_,Image,_,b_true,b_false,Image):-!.
  select_image(_,_,Image,_/*b_false*/,_,Image):-!.


/*******************************************************************
	Handling cursor entering or leaving controls.
*******************************************************************/

predicates

determ  test_enter_ctrl(WINDOW,PNT)
determ  show_status_text(WINDOW,STRING)
determ  restore_initial_status_text(WINDOW)
determ WINDOW get_win_with_context(WINDOW)
procedure  set_flagMouseDown(WINDOW,TOOLBAR_CONTROL_STYLE,INTEGER)
procedure  set_button_released(WINDOW)
procedure  restore_pressed_button(WINDOW,MENU_TAG,BOOLEAN,BOOLEAN)
procedure  INTEGER get_symbol_length(WINDOW,STRING,INTEGER)

clauses
  set_button_released(TB_Win):- %YF 25/07/95
	flagMouseDown,
	toolbar_release_flagMouseDown,
	chooseControl(CtrlId),!,
  	restore_pressed_button(TB_Win,CtrlId,b_false,b_true).
  set_button_released(_).

  %===== Cursor stays inside the same control: =======
  test_leave_ctrl(TB_Win,CtrlId,Point):-
	ctrl(TB_Win,CtrlId,_,_,RCT,_,_,_,_,_,_),
	 rect_PntInside(RCT,Point),!.

  %===== Cursor leaves the control: ========
  test_leave_ctrl(TB_Win,CtrlId,_):-
	inside(CtrlId,TimerId),!,
	timer_Kill(TimerId),
	retractall(inside(_,TimerId)),
	tooltip_try_show(),
	restore_initial_status_text(TB_Win),!,
	restore_pressed_button(TB_Win,CtrlId,b_false,b_true).
  test_leave_ctrl(_,_,_).

  %===== Cursor enters the control ========
  test_enter_ctrl(TB_Win,Point):-
	ctrl(TB_Win,CtrlId,_,_,RCT,_,_,_,Text,_,_),
	 rect_PntInside(RCT,Point),!,
	TimerId = timer_Set(TB_Win,2000),
	assert(inside(CtrlId,TimerId)),
	tooltip_try_show(),
	show_status_text(TB_Win,Text),
	restore_pressed_button(TB_Win,CtrlId,b_true,b_false).
  test_enter_ctrl(_,_).

  restore_pressed_button(TB_Win,CtrlId,FROM,TO):-
	chooseControl(CtrlId),
	retract(ctrl(TB_Win,CtrlId,Gr,pushb,
		RCT,Released,Pressed,Gray,Text,b_true,FROM)),!,
	assert(ctrl(TB_Win,CtrlId,Gr,pushb,
		RCT,Released,Pressed,Gray,Text,b_true,TO)),
	RCT = rct(L,T,_,_),
	Image = select_image(Released,Pressed,Gray,b_true,TO),
	drawImage(TB_Win,L,T,Image).
  restore_pressed_button(_,_,_,_).

/************************************************************
	Context sensitive text drawing
************************************************************/

  show_status_text(TB_Win,Text):-
	tb(ParentWin,TB_Win,_,_,_,_,_,_),
	ContextWin = get_win_with_context(ParentWin),!,
	text(ContextWin,_,tb_context,RCT,Style,
		Family,Size,FColor,_),!,
	tb(_,ContextWin,_,_,_,BColor,_,_),!,
	show_text1(ContextWin,RCT,Style,Family,Size,FColor,BColor,Text).
  show_status_text(_,_).

  show_text1(TB_Win,rcT(L,T,R,B),Style,Family,Size,FColor,BColor,Text):-
	Font = try_crt_tb_font(Family,[Style],Size),
	X = L + toolbar_margin,
	Y = (T+B+Size) div 2,

	%------ clear old text -------
	T1=T+1,L1=L+3,R1=R-3,
	win_SetDrawTools(TB_Win,draw_tools(pen(1,ps_Solid,BColor),
	  brush(pat_solid,BColor),dm_CopyPen,Font,BColor,BColor,b_true)),
	draw_Rect(TB_Win,rcT(L1,T1,R1,B)),

	%------ draw new text -------
	win_SetDrawTools(TB_Win,draw_tools(pen(1,ps_Solid,color_Gray),
	  brush(pat_solid,BColor),dm_CopyPen,Font,FColor,BColor,b_true)),
	LenPix = R - toolbar_margin - X,
	Len = get_symbol_length(TB_Win,Text,LenPix),
	draw_Text(TB_Win,X,Y,Text,Len)

	%------ draw ornamentation -------
ifdef toolbar_ornamentation
	,L2=L+2,R2=R-2,
	draw_PolyLine(TB_Win,[pnT(R2,T),pnT(L2,T),pnT(L2,B)]),
	win_SetPen(TB_Win,pen(1,ps_Solid,color_White)),
	draw_PolyLine(TB_Win,[pnT(L2,B),pnT(R2,B),pnT(R2,T)])
enddef
	.

  restore_initial_status_text(TB_win):-
	tb(ParentWin,TB_Win,_,_,_,_,_,_),
	ContextWin = get_win_with_context(ParentWin),!,
	text(ContextWin,_,tb_context,_,_,_,_,_,InitText),!,
	show_status_text(ContextWin,InitText).
  restore_initial_status_text(_).

  get_win_with_context(ParentWin,ContextWin):-
	tb(ParentWin,ContextWin,_TB_Style,_,_,_,_,_),
	text(ContextWin,_,tb_context,_,_,_,_,_,_),!.
  get_win_with_context(_,ContextWin):-
	UnKnown = cast(window,0),
	TW = win_GetAttrVal(UnKnown,attr_task_window),
	TaskWin = cast(window,TW),
	tb(TaskWin,ContextWin,_TB_Style,_,_,_,_,_),
	text(ContextWin,_,tb_context,_,_,_,_,_,_),!.

  set_flagMouseDown(_,pushb,0):- !,%YF 25/07/95 
  	toolbar_set_flagMouseDown.
  set_flagMouseDown(_,_,_).

  get_symbol_length(TB_Win,Text,LenPix,Len):-
	win_GetTextExtent(TB_Win,Text,-1,Width,_),
	Width <= LenPix,
	str_len(Text,Len),!.
  get_symbol_length(TB_Win,Text,LenPix,Len):-
	str_len(Text,LenT),
	LenT1 = LenT - 1,
	frontstr(LenT1,Text,Text1,_),
	Text1 <> "",!,
	Len = get_symbol_length(TB_Win,Text1,LenPix),!.
  get_symbol_length(_,_,_,0):-!.

/***************************************************************************
	Event handling for toolbar window
***************************************************************************/

predicates
procedure  call_user_func(WINDOW,MENU_TAG,BOOLEAN)
procedure  BOOLEAN is_call_user_func(INTEGER,TOOLBAR_CONTROL_STYLE)

clauses

  %+++++++++++ E_UPDATE ++++++++++++

  tb_handler(W,e_Update(RECT),0):-
	tb(_,W,_Style,_,_,_BColor,_,_),!,
	BColor = win_GetAttrVal(W,attr_color_btnface),
	win_SetPen(W,pen(1,ps_Solid,BColor)),
	win_SetBrush(W,brush(pat_Solid,BColor)),
	draw_Rect(W,RECT),
	show_toolbar_controls(W)
ifdef toolbar_ornamentation
     	,
	RCT = win_GetClientRect(W),
	RCT = rcT(_,_,R,B),
	B1=B-1,R1=R-1,
	win_SetPen(W,pen(1,ps_Solid,color_White)),
	draw_PolyLine(W,[pnT(1,B1),pnT(1,0),pnT(R1,0)]),
	win_SetPen(W,pen(1,ps_Solid,color_Gray)),
	draw_PolyLine(W,[pnT(1,B1),pnT(R1,B1),pnT(R1,0)])
enddef
     	.

  %+++++++++++ E_DESTROY ++++++++++++


  tb_handler(W,e_Destroy(),0):-
        tooltip_clean_up(W),%YF 15/04/96
        retract(inside(_,TimerId)),
        timer_Kill(TimerId),fail.
  tb_handler(W,e_Destroy(),0):-!,
	retractall(tb(_,W,_,_,_,_,_,_)),
	retractall(ctrl(W,_,_,_,_,_,_,_,_,_,_)),
	retractall(lbut(W,_,_,_,_,_)),
	retractall(text(W,_,_,_,_,_,_,_,_)).

  %+++++++++++ E_MOUSE_MOVE ++++++++++++

  tb_handler(W,e_MouseMove(PNT,_,_),0):- %YF 01-08-96
        tooltip_check_mousemove(W,PNT),fail.

  tb_handler(W,e_MouseMove(Pnt,_,_),0):-
	inside(CtrlId,_),!,		 % Cursor was inside control rectangle
	test_leave_ctrl(W,CtrlId,Pnt).   %  Test if cursor leaves it

  tb_handler(W,e_MouseMove(Pnt,_,_),0):- % Cursor was outside of controls
	test_enter_ctrl(W,Pnt). 	    %  Test if cursor enter it

  tb_handler(W,e_Timer(TimerId),0):-
	inside(CtrlId,TimerId),!,
	Pnt = cursor_GetPos(W),
	test_leave_ctrl(W,CtrlId,Pnt),!.   %  Test if cursor leaves it

  %++++++++++++++ E_MOUSE_DOWN ++++++++++++++
  %
  % 1.Normal toolbar drawn from resources
  %
  tb_handler(TB_Win,e_MouseDown(Point,_,_),0):-
	ctrl(TB_Win,CtrlId,Gr,CtrlStyle,RCT,Released,Pressed,Gray,
		Text,Enabled,Rel),
	  Enabled  = b_true,
	  Rel = b_true,	% On released PushButton or Checkbutton
	rect_PntInside(RCT,Point),!,
	set_flagMouseDown(TB_Win,CtrlStyle,Gr),
	retractall(chooseControl(_)),assert(chooseControl(CtrlId)),
	retractall(ctrl(TB_Win,CtrlId,_,_,_,_,_,_,_,_,_)),
	assert(ctrl(TB_Win,CtrlId,Gr,CtrlStyle,RCT,Released,Pressed,
		Gray,Text,b_true,b_false)),
	RCT = rct(L,T,_,_),
	drawImage(TB_Win,L,T,Pressed),
  	B1 = is_call_user_func(Gr,CtrlStyle),
	call_user_func(TB_Win,CtrlId,B1).

  tb_handler(TB_Win,e_MouseDown(Point,_,_),0):-
	ctrl(TB_Win,CtrlId,Gr,CtrlStyle,RCT,Released,Pressed,Gray,
		Text,Enabled,Rel),
	  Enabled   = b_true,
	  CtrlStyle = checkb,
	  Gr = 0,
   	  Rel = b_false,		% On pressed CheckButton
	rect_PntInside(RCT,Point),!,
	retractall(ctrl(TB_Win,CtrlId,_,_,_,_,_,_,_,_,_)),
	assert(ctrl(TB_Win,CtrlId,Gr,CtrlStyle,RCT,Released,Pressed,
		Gray,Text,b_true,b_true)),
	RCT = rct(L,T,_,_),
	drawImage(TB_Win,L,T,Released),
	call_user_func(TB_Win,CtrlId,b_true).

  %+++++++++++ E_MOUSE_UP ++++++++++++

  tb_handler(TB_Win,e_MouseUp(_,_,_),0):-
	tb(_ParentWin,TB_Win,_,_,_,_,_,MessWin),
  	set_button_released(TB_Win),
	trap(win_SetFocus(MessWin),_,fail),
	fail.
  tb_handler(TB_Win,e_MouseUp(Point,_,_),0):-
  	ctrl(TB_Win,CtrlId,Gr,CtrlStyle,RCT,Released,Pressed,Gray,
  		Text,Enabled,_),
	  Enabled = b_true,
	  Gr = 0,
	  CtrlStyle = pushb,
	chooseControl(CtrlId),
	rect_PntInside(RCT,Point),!,
	retractall(ctrl(TB_Win,CtrlId,_,_,_,_,_,_,_,_,_)),
	assert(ctrl(TB_Win,CtrlId,Gr,CtrlStyle,RCT,Released,Pressed,
		Gray,Text,b_true,b_true)),
	RCT = rct(L,T,_,_),
	drawImage(TB_Win,L,T,Released),
	call_user_func(TB_Win,CtrlId,b_true).
  tb_handler(_,e_MouseUp(_,_,_),0):-!,
	retractall(chooseControl(_)).

  %+++++++++++ E_COMMAND ++++++++++++

  tb_handler(TB_Win,e_Menu(CMD,X),0):-
	tb(ParentWin,TB_Win,_,_,_,_,_,_),!,
	win_SendEvent(ParentWin,e_Menu(CMD,X)).

  %+++++++++++ E_CONTROL ++++++++++++

  tb_handler(TB_Win,e_Control(CtrlId,_,_,_),0):-	% Item in listbutton is selected
	LBW = win_GetCtlHandle(TB_Win,CtrlId),
	Pos = lbox_GetSelIndex(LBW),
	retract(lbut(TB_Win,CtrlId,RCT,SList,Enabled,_)),
	assert(lbut(TB_Win,CtrlId,RCT,SList,Enabled,Pos)),
	call_user_func(TB_Win,CtrlId,b_true),!.

  %+++++++++++ E_FOCUS ++++++++++++
  tb_handler(TB_Win,e_LoseFocus,0):-
  	set_button_released(TB_Win),!.

  %+++++++ E_ERASEBACKGROUND +++++++
  tb_handler(_,e_EraseBackGround(),1):-!.

  %+++++++++++ E_USER +++++++++++++++++

  tb_handler(TB_Win,e_User(tbar_move,_),0):-
	tb(ParentWin,TB_Win,Style,_,_,_,_,_),!,
	OldRCT = win_GetClientRect(TB_Win),
	ParentRCT = win_GetClientRect(ParentWin),
	ParentRCT = rct(_,_,Width,Height),
	tb_rect(TB_Win,Style,Height,Width,NewRCT),   % calculate new rectangle
	win_Move(TB_Win,NewRCT),
	tbar_Invalidate(TB_Win,Style,Height,Width,OldRCT).

%+++++++++++++++++++++++++++++++++++++++++++++++++++

  is_call_user_func(0,pushb,b_false):-!.
  is_call_user_func(_,_,b_true):-!.

  %-------- User callback function call --------

  call_user_func(_,_,b_true):-
	retractall(flagMouseDown),
	retractall(chooseControl(_)),
	fail.
  call_user_func(TB_Win,CtrlId,b_true):-
	ctrl(TB_Win,CtrlId,G,_,_,_,_,_,_,Enabled,Released),
	tb(ParentWin,TB_Win,_,_,_,_,UserFunc,_),
	toolbar_SetPressedButton(ParentWin,G,CtrlId),
	UserFunc(ParentWin,CtrlId,ctrl_value(Enabled,Released)),!.
  call_user_func(TB_Win,CtrlId,b_true):-
	lbut(TB_Win,CtrlId,_,_,Enabled,Pos),
	tb(ParentWin,TB_Win,_,_,_,_,UserFunc,_),
	UserFunc(ParentWin,CtrlId,lbut_value(Enabled,Pos)),!.
  call_user_func(_,_,_).

	
  get_flag(b_true,wsf_Enabled).
  get_flag(b_false,wsf_Disabled).

  no_handler(_,_,0):-fail.
