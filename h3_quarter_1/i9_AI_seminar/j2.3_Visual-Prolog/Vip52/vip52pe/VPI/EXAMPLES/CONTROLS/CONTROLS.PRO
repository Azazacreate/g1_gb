/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  CONTROLS
 FileName: CONTROLS.PRO
 Purpose: Controls handling
 Written by: Illin Yuri
 Comments:
******************************************************************************/

include "controls.inc"
include "controls.con"
include "hlptopic.con"

/***************************************************************************
	 CONSTANTS
***************************************************************************/

CONSTANTS
  gap1          =       20
  gap2          =       30

  ctl1_top1     =       14
  ctl1_top2     =       34
  ctl1_lft1     =       10
  ctl1_lft2     =       30
  ctl1_rgt1     =       80
  ctl1_rgt2     =       300
  ctl1_bot1     =       34
  ctl1_bot2     =       64

  ctl2_top1     =       50
  ctl2_top2     =       70
  ctl2_bot1     =       70
  ctl2_bot2     =       100
  ctl2_lft1     =       10
  ctl2_lft2     =       30
  ctl2_rgt1     =       150
  ctl2_rgt2     =       170

  ctl3_top1     =       70
  ctl3_top2     =       100
  ctl3_bot1     =       90
  ctl3_bot2     =       130

  ctl4_top1     =       90
  ctl4_top2     =       130
  ctl4_bot1     =       110
  ctl4_bot2     =       160

  ctl5_top1     =       50
  ctl5_top2     =       70
  ctl5_bot1     =       70
  ctl5_bot2     =       100
  ctl5_lft1     =       160
  ctl5_lft2     =       180
  ctl5_rgt1     =       290
  ctl5_rgt2     =       310

  ctl6_top1     =       70
  ctl6_top2     =       100
  ctl6_bot1     =       90
  ctl6_bot2     =       130

  ctl7_top1     =       14
  ctl7_top2     =       24
  ctl7_bot1     =       104
  ctl7_bot2     =       200
  ctl7_lft1     =       325
  ctl7_lft2     =       400
  ctl7_rgt1     =       341
  ctl7_rgt2     =       440

  ctl8_top1     =       150
  ctl8_top2     =       175
  ctl8_bot1     =       166
  ctl8_bot2     =       200
  ctl8_lft1     =       250
  ctl8_lft2     =       10
  ctl8_rgt1     =       350
  ctl8_rgt2     =       300

  oper_y        =       222
  oper_x        =       30
  oper_w        =       75
  oper_h        =       20
  oper_hgap     =       85
  oper_vgap     =       30

  oper_yh      = 242
  oper_xw      = 105
  oper_yvgap   = 252
  oper_yvgaph  = 272
  oper_xhgap   = 115
  oper_xhgapw  = 190
  oper_x2hgap  = 200
  oper_x2hgapw = 275
  oper_x3hgap  = 285
  oper_x3hgapw = 355
  oper_x4hgap  = 365
  oper_x4hgapw = 440

  rleft         =       4
  rtop          =       4
  rright        =       467
  rbottom       =       216

  vscroll_label_x =     350
  vscroll_label_y =     50

  hscroll_label_x =     310
  hscroll_label_y =     190


  test_button   =       101
  test_radio1   =       102
  test_radio2   =       103
  test_radio3   =       104
  test_check1   =       105
  test_check2   =       106
  test_vscroll  =       107
  test_hscroll  =       108

  oper_create   =       151
  oper_destroy  =       152
  oper_show     =       153
  oper_hide     =       154
  oper_move     =       155
  oper_restore  =       156
  oper_gettext  =       157
  oper_settext  =       158
  oper_enable   =       159
  oper_disable  =       160

  scroll_min    =       0
  scroll_max    =       100
  scroll_line   =       2
  scroll_page   =       25

DATABASE - db
  scroll_range(integer)
  
/***************************************************************************
	Misc utility predicates
***************************************************************************/

PREDICATES
  strlist_str(SLIST,STRING)
  max(INTEGER,INTEGER,INTEGER)
  min(INTEGER,INTEGER,INTEGER)

CLAUSES
  strlist_str([],"").
  strlist_str([H|T],Result):-
	strlist_str(T,Tmp),
	concat(H,Tmp,Result).

  max(F,L,F):-L<=F,!.
  max(_,L,L).

  min(F,L,F):-L>=F,!.
  min(_,L,L).

/***************************************************************************
	Control's information
***************************************************************************/
DATABASE - windows
  main_window(WINDOW)

PREDICATES
nondeterm  test_ctls(WINTYPE,RCT,RCT,INTEGER,STRING)
nondeterm  oper_ctls(WINTYPE,RCT,RCT,INTEGER,STRING)
nondeterm  checkbox(INTEGER)
nondeterm  radio(INTEGER)
nondeterm  scrollbar(INTEGER)

CLAUSES
  test_ctls(wc_pushbutton, rct(ctl1_lft1,ctl1_top1, ctl1_rgt1, ctl1_bot1 ), rct(ctl1_lft2,ctl1_top2,ctl1_rgt2 , ctl1_bot2 ), test_button, "Push Me").
  test_ctls(wc_radiobutton, rct(ctl2_lft1,ctl2_top1,ctl2_rgt1 , ctl2_bot1 ), rct(ctl2_lft2,ctl2_top2,ctl2_rgt2 , ctl2_bot2 ), test_radio1, "Click Me (1)").
  test_ctls(wc_radiobutton, rct(ctl2_lft1,ctl3_top1,ctl2_rgt1 , ctl3_bot1 ), rct(ctl2_lft2,ctl3_top2, ctl2_rgt2, ctl3_bot2 ), test_radio2, "Click Me (2)").
  test_ctls(wc_radiobutton, rct(ctl2_lft1,ctl4_top1, ctl2_rgt1, ctl4_bot1 ), rct(ctl2_lft2, ctl4_top2, ctl2_rgt2, ctl4_bot2 ), test_radio3, "Click Me (3)").
  test_ctls(wc_checkbox, rct(ctl5_lft1,ctl5_top1,ctl5_rgt1 , ctl5_bot1 ), rct(ctl5_lft2,ctl5_top2,ctl5_rgt2 , ctl5_bot2 ), test_check1, "Check Me (1)").
  test_ctls(wc_checkbox, rct(ctl5_lft1,ctl6_top1, ctl5_rgt1, ctl6_bot1 ), rct(ctl5_lft2,ctl6_top2, ctl5_rgt2, ctl6_bot2 ), test_check2, "Check Me (2)").
  test_ctls(wc_vscroll, rct(ctl7_lft1,ctl7_top1, ctl7_rgt1, ctl7_bot1 ), rct(ctl7_lft2,ctl7_top2, ctl7_rgt2, ctl7_bot2 ), test_vscroll, "").
  test_ctls(wc_hscroll, rct(ctl8_lft1,ctl8_top1, ctl8_rgt1, ctl8_bot1), rct(ctl8_lft2,ctl8_top2,ctl8_rgt2 , ctl8_bot2 ), test_hscroll, "").

  oper_ctls(wc_pushbutton, rct(oper_x,oper_y,oper_xw , oper_yh ), rct(0,0,0,0), oper_create, "Create").
  oper_ctls(wc_pushbutton, rct(oper_x,oper_yvgap, oper_xw, oper_yvgaph ), rct(0,0,0,0), oper_destroy, "Destroy").
  oper_ctls(wc_pushbutton, rct(oper_xhgap,oper_y,oper_xhgapw , oper_yh ), rct(0,0,0,0), oper_show, "Show").
  oper_ctls(wc_pushbutton, rct(oper_xhgap,oper_yvgap, oper_xhgapw, oper_yvgaph ), rct(0,0,0,0), oper_hide, "Hide").
  oper_ctls(wc_pushbutton, rct(oper_x2hgap,oper_y, oper_x2hgapw, oper_yh ), rct(0,0,0,0), oper_move, "Move").
  oper_ctls(wc_pushbutton, rct(oper_x2hgap,oper_yvgap, oper_x2hgapw, oper_yvgaph ), rct(0,0,0,0), oper_restore, "Restore").
  oper_ctls(wc_pushbutton, rct(oper_x3hgap,oper_y,oper_x3hgapw , oper_yh ), rct(0,0,0,0), oper_gettext, "Get Text").
  oper_ctls(wc_pushbutton, rct(oper_x3hgap,oper_yvgap, oper_x3hgapw, oper_yvgaph ), rct(0,0,0,0), oper_settext, "Set Text").
  oper_ctls(wc_pushbutton, rct(oper_x4hgap,oper_y, oper_x4hgapw, oper_yh ), rct(0,0,0,0), oper_enable, "Enable").
  oper_ctls(wc_pushbutton, rct(oper_x4hgap,oper_yvgap, oper_x4hgapw, oper_yvgaph), rct(0,0,0,0), oper_disable, "Disable").

  checkbox(test_check1).
  checkbox(test_check2).

  radio(test_radio1).
  radio(test_radio2).
  radio(test_radio3).

  scrollbar(test_vscroll).
  scrollbar(test_hscroll).


/***************************************************************************
	Storing window ID's for controls
***************************************************************************/

DATABASE - control_windows
  control_window(INTEGER,WINDOW).


/***************************************************************************
	Checkbox state handling
***************************************************************************/
PREDICATES
  flip_checkbox(INTEGER)

CLAUSES
  flip_checkbox(INTEGER):-
	control_window(INTEGER,WINDOW),
	B = win_IsChecked(WINDOW),
	B = checkbox_on,!,
	win_check(WINDOW,0).

  flip_checkbox(INTEGER):-
	control_window(INTEGER,WINDOW),!,
	win_check(WINDOW,1).


/***************************************************************************
	Radio button handling
***************************************************************************/

PREDICATES
  flip_radio(INTEGER)

CLAUSES
  flip_radio(INTEGER):-
	control_window(INTEGER,W),
	control_window(test_radio1,W1),
	control_window(test_radio2,W2),
	control_window(test_radio3,W3),!,
	win_checkradiobutton(W,[W1,W2,W3]).


/***************************************************************************
	Scrollbar handling
***************************************************************************/

DATABASE - scrollbars
  sc_value(INTEGER,INTEGER)

PREDICATES
  show_scroll_values(WINDOW)
  changescrollbar(INTEGER,ScrollCode,INTEGER)
  change_scroll_values(INTEGER,ScrollCode,INTEGER)
  get_sc_value(INTEGER,INTEGER)
  update_sc_value(INTEGER)

CLAUSES
  show_scroll_values(Win):-
	sc_value(test_vscroll,VVAL),
	sc_value(test_hscroll,HVAL),!,
	win_SetBackMode(Win,bk_Opaque),
	format(TXT1, " %      ", VVAL),
	FONT = font_Create(ff_helvetica,[], 12 ),
	win_setfont(Win,FONT),
	win_getfontmetrics(Win,_, ASCENT, DESCENT),
	win_gettextExtent(Win,"100",-1,Width,_),
	T1 = vscroll_label_x, B1 = T1 + Ascent + Descent + 1,
	L1 = vscroll_label_y, R1 = L1 + Width + 1,
	DrawTools = win_GetDrawTools ( Win ),
	win_SetPen ( Win, pen ( 1, ps_Solid, color_LtGray ) ),
	win_SetBrush ( Win, brush ( pat_Solid, color_LtGray ) ),
	draw_Rect ( Win, rct ( L1, T1, R1, B1 ) ),
	draw_text(Win,vscroll_label_x, vscroll_label_y, TXT1),
	format(TXT2, " %      ", HVAL),
	T2 = hscroll_label_x, B2 = T1 + Ascent + Descent + 1,
	L2 = hscroll_label_y, R2 = L1 + Width + 1,
	draw_Rect ( Win, rct ( L2, T2, R2, B2 ) ),
	win_SetDrawTools ( Win, DrawTools ),
	draw_Text(Win,hscroll_label_X, hscroll_label_y, TXT2).

  changescrollbar(C_ID,ScrollCode,Thumb_Pos) :-
	change_scroll_values(C_ID,ScrollCode,Thumb_Pos),
	C_ID = test_hscroll,
	  control_window(test_hscroll,HSW),
	  sc_value(test_hscroll,HVAL),!,
	  win_SetScrollPos(HSW,sb_Ctl,HVAL)
	;
	  control_window(test_vscroll,VSW),
	  sc_value(test_vscroll,VVAL),!,
	  win_SetScrollPos(VSW,sb_Ctl,VVAL).

  change_scroll_values(Control_ID,sc_lineup,_):-
	sc_value(Control_ID,OLDVAL),!,
	retractall(sc_value(Control_ID,_)),
	NEWVAL=OLDVAL-scroll_line,
	max(scroll_min,NEWVAL,NEWVAL1),
	assert(sc_value(Control_ID,NEWVAL1)).

  change_scroll_values(Control_ID,sc_linedown,_):-
	sc_value(Control_ID,OLDVAL),
	retractall(sc_value(Control_ID,_)),
	NEWVAL=OLDVAL+scroll_line,
	control_window(test_hscroll,HSW),!,
	win_GetScrollRange(HSW,sb_Ctl,_,M1),
	min(M1,NEWVAL,NEWVAL1),
	assert(sc_value(Control_ID,NEWVAL1)).

  change_scroll_values(Control_ID,sc_pageup,_):-
	sc_value(Control_ID,OLDVAL),!,
	retractall(sc_value(Control_ID,_)),
	NEWVAL=OLDVAL-scroll_page,
	max(scroll_min,NEWVAL,NEWVAL1),
	assert(sc_value(Control_ID,NEWVAL1)).

  change_scroll_values(Control_ID,sc_pagedown,_):-
	sc_value(Control_ID,OLDVAL),
	retractall(sc_value(Control_ID,_)),
	NEWVAL=OLDVAL+scroll_page,
	control_window(test_hscroll,HSW),!,
	win_GetScrollRange(HSW,sb_Ctl,_,M1),
	min(M1,NEWVAL,NEWVAL1),
	assert(sc_value(Control_ID,NEWVAL1)).


  change_scroll_values(Control_ID,sc_thumbtrack,NEWVAL):-!,
	retractall(sc_value(Control_ID,_)),
	assert(sc_value(Control_ID,NEWVAL)).

  change_scroll_values(Control_ID,sc_THUMB,NEWVAL):-!,
	retractall(sc_value(Control_ID,_)),
	assert(sc_value(Control_ID,NEWVAL)).

  change_scroll_values(_,_,_).

  get_sc_value(C_ID,VAL) :-
	sc_value(C_ID,VAL),!.
  get_sc_value(_,0).

  update_sc_value(C_ID) :-
	get_sc_value(C_ID,VAL),
	retractall(sc_value(C_ID,_)),
	control_window(C_ID,SW),!,
	win_GetScrollRange(SW,sb_Ctl,MinVal,MaxVal),
	max(MinVal,VAL,VAL1),
	min(MaxVal,VAL1,VAL2),
	assert(sc_value(C_ID,VAL2)),
	win_SetScrollPos(SW,sb_Ctl,VAL2).

/***************************************************************************
	Misc demo operations on controls
***************************************************************************/

PREDICATES
  restore_controls()
  show_controls()
  hide_controls()
  move_controls()
  enable_controls()
  disable_controls()
  create_controls(WINDOW)
  destroy_controls(WINDOW)
  set_control_text()
  get_control_text()
  nondeterm titles(STRING)
  get_ctlflags_for_control(WINTYPE,CTL_FLAGS)

CLAUSES
  get_ctlflags_for_control(wc_pushbutton,[ctl_Default,ctl_AlignCenter]).
  get_ctlflags_for_control(wc_radiobutton,[ctl_Checked,ctl_Group,ctl_AlignLeft]).
  get_ctlflags_for_control(wc_checkbox,[ctl_Checked,ctl_AlignLeft]).
  get_ctlflags_for_control(wc_vscroll,[]).
  get_ctlflags_for_control(wc_hscroll,[]).

  create_controls(PARENT):-
	menu_Enable(PARENT,id_scroll,b_true),
	menu_Update(PARENT),
	test_ctls(WIN_TYPE,RCT1,_,Control_ID,TITLE),
	 get_ctlflags_for_control(WIN_TYPE,FLAGS),
	 WINDOW=win_CreateControl(WIN_TYPE,RCT1,TITLE,PARENT,FLAGS,Control_ID),
	 retractall(control_window(Control_ID,_)),
	 assert(control_window(Control_ID,WINDOW)),
	 draw_text(PARENT,vscroll_label_x, vscroll_label_y,"50       "), % EA
	 draw_Text(PARENT,hscroll_label_X, hscroll_label_y,"50       "), % EA 
	fail.

  create_controls(_):-
	control_window(test_hscroll,TEST_HSCROLL_WINDOW),
	sc_value(test_hscroll,HVAL),
	win_SetScrollRange(TEST_HSCROLL_WINDOW,sb_Ctl, 0, 100),
	win_SetScrollPos(TEST_HSCROLL_WINDOW,sb_Ctl,HVAL),
	control_window(test_vscroll,TEST_VSCROLL_WINDOW),
	sc_value(test_vscroll,VVAL),
	win_SetScrollRange(TEST_VSCROLL_WINDOW,sb_Ctl, 0, 100),
	win_SetScrollPos(TEST_VSCROLL_WINDOW,sb_Ctl,VVAL),
	flip_radio(test_radio1),
	control_window(oper_create,W1),  win_SetState(W1, [wsf_Disabled]),
	control_window(oper_destroy,W2), win_SetState(W2, [wsf_Enabled]),
	control_window(oper_show,W3),    win_SetState(W3, [wsf_Disabled]),
	control_window(oper_hide,W4),    win_SetState(W4, [wsf_Enabled]),
	control_window(oper_move,W5),    win_SetState(W5, [wsf_Enabled]),
	control_window(oper_restore,W6), win_SetState(W6, [wsf_Disabled]),
	control_window(oper_gettext,W7), win_SetState(W7, [wsf_Enabled]),
	control_window(oper_settext,W8), win_SetState(W8, [wsf_Enabled]),
	control_window(oper_enable,W9),  win_SetState(W9, [wsf_Disabled]),
	control_window(oper_disable,W0), win_SetState(W0, [wsf_Enabled]),
	!,
	flip_checkbox(test_check1),
	flip_checkbox(test_check1),
	flip_checkbox(test_check2).


  destroy_controls(TaskWin):-
	menu_Enable(TaskWin,id_scroll,b_false),
	menu_Update(TaskWin),
	control_window(oper_create,W1),  win_SetState(W1, [wsf_Enabled]),
	control_window(oper_destroy,W2), win_SetState(W2, [wsf_Disabled]),
	control_window(oper_show,W3),    win_SetState(W3, [wsf_Disabled]),
	control_window(oper_hide,W4),    win_SetState(W4, [wsf_Disabled]),
	control_window(oper_move,W5),    win_SetState(W5, [wsf_Disabled]),
	control_window(oper_restore,W6), win_SetState(W6, [wsf_Disabled]),
	control_window(oper_gettext,W7), win_SetState(W7, [wsf_Disabled]),
	control_window(oper_settext,W8), win_SetState(W8, [wsf_Disabled]),
	control_window(oper_enable,W9),  win_SetState(W9, [wsf_Disabled]),
	control_window(oper_disable,W0), win_SetState(W0, [wsf_Disabled]),
	retractall(sc_value(_,_)), % EA
	assert(sc_value(test_vscroll,50)), % EA
	assert(sc_value(test_hscroll,50)), % EA
	test_ctls(_,_,_,Control_ID,_),
	  retract(control_window(Control_ID,W)),
	  win_Destroy(W),
	fail.
  destroy_controls(_).

  show_controls:-
	control_window(oper_show,W3),    win_SetState(W3, [wsf_Disabled]),
	control_window(oper_hide,W4),    win_SetState(W4, [wsf_Enabled]),
	test_ctls(_,_,_,Control_ID,_),
	 control_window(Control_ID,W),
	 win_SetState(W, [wsf_Visible]),
	fail.
  show_controls.


  hide_controls:-
	control_window(oper_show,W3),    win_SetState(W3, [wsf_Enabled]),
	control_window(oper_hide,W4),    win_SetState(W4, [wsf_Disabled]),
	test_ctls(_,_,_,Control_ID,_),
	 control_window(Control_ID,W),
	 win_SetState(W,[wsf_Invisible]),
	fail.
  hide_controls.

  move_controls:-
	control_window(oper_move,W5),    win_SetState(W5, [wsf_Disabled]),
	control_window(oper_restore,W6), win_SetState(W6, [wsf_Enabled]),
	test_ctls(_,_,RCT2,Control_ID,_),
	  control_window(Control_ID,W),
	  win_Move(W,RCT2),
	fail.
  move_controls.


  restore_controls:-
	control_window(oper_move,W5),    win_SetState(W5, [wsf_Enabled]),
	control_window(oper_restore,W6), win_SetState(W6, [wsf_Disabled]),
	test_ctls(_,RCT1,_,Control_ID,_),
	  control_window(Control_ID,W),
	  win_Move(W,RCT1),
	fail.
  restore_controls.


  enable_controls:-
	control_window(oper_disable,W5), win_SetState(W5, [wsf_Enabled]),
	control_window(oper_enable,W6),  win_SetState(W6, [wsf_Disabled]),
	test_ctls(_,_,_,Control_ID,_),
	control_window(Control_ID,W),
	win_SetState(W,[wsf_Enabled]),
	fail.
  enable_controls:-
  	_Win=vpi_GetTaskWin(),
  	menu_Enable(_Win,id_scroll,b_true),
  	menu_Update(_Win).


  disable_controls:-
	control_window(oper_disable,W5), win_SetState(W5, [wsf_Disabled]),
	control_window(oper_enable,W6),  win_SetState(W6, [wsf_Enabled]),
	test_ctls(_,_,_,Control_ID,_),
	  control_window(Control_ID,W),
	  win_SetState(W,[wsf_Disabled]),
	fail.
  disable_controls:-
  	_Win=vpi_GetTaskWin(),
  	menu_Enable(_Win,id_scroll,b_false),
  	menu_Update(_Win).

  set_control_text:-
	control_window(test_button,WW),!,
	Title = win_GetText(WW),
	New = dlg_GetStr("Input string","Set new title:", Title),
	win_SetText(WW,New).
  set_control_text.

  get_control_text:-
	findall(X,titles(X),L),
	strlist_str(L,Result),
	dlg_Note("",Result).

  titles(Title):-
	test_ctls(_,_,_,Control_ID,_),
	control_window(Control_ID,W),
	Title = win_GetText(W).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 17:57:26-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Controls"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES
%BEGIN Task Window, e_Create
  task_win_eh(PARENT,e_Create(_),0):-
%BEGIN Task Window, InitControls, 17:57:26-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 17:57:26-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	assert(main_window(PARENT)),
	MID = round((scroll_min + scroll_max) / 2),
	assert(sc_value(test_vscroll,MID)),
	assert(sc_value(test_hscroll,MID)),
	oper_ctls(WIN_TYPE,RCT1,_RCT2,Control_ID,TITLE),
	 get_ctlflags_for_control(WIN_TYPE,FLAGS),
	 WINDOW=win_CreateControl(WIN_TYPE,RCT1,TITLE,PARENT,FLAGS,Control_ID),
	 retractall(control_window(Control_ID,_)),
	 assert(control_window(Control_ID,WINDOW)),
	fail;
	!, create_controls(PARENT),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, e_Update
  task_win_eh(Win,e_Update(_RECT),0):-!,
	DRAW_CTOOLS = win_getDrawTools(Win),
	DRAW_CTOOLS = draw_tools(_,_,DRAW_MODE,FONT,_,_,_),
	RCT = win_getClientRect(Win),
	win_SetPen ( Win, pen ( 1, ps_Solid, color_LtGray ) ),
	win_SetBrush ( Win, brush ( pat_Solid, color_LtGray ) ),
	draw_Rect ( Win, RCT ),
	win_setDrawTools(Win,
		draw_tools(
			pen(2,ps_solid,color_blue),
			brush(pat_hollow,color_LtGray),
			DRAW_MODE,FONT,color_red,color_LtGray,bk_Transparent)),
	draw_rect(Win,rct(rleft, rtop, rright, rbottom )),
	show_scroll_values(Win),
	!.
%END Task Window, e_Update
%BEGIN Task Window, id_scroll
  task_win_eh(_Win,e_Menu(id_scroll,_ShiftCtlAlt),0):-
	control_window(test_hscroll,HSW),
	control_window(test_vscroll,VSW),
	win_GetScrollRange(HSW,sb_Ctl,_,M1),
	retractall(_,db),
	assert(scroll_range(M1)),
	dlg_scroll_set_range_Create(_Win),
	scroll_range(M2),!,
	win_SetScrollRange(HSW,sb_Ctl,0,M2),
	win_SetScrollRange(VSW,sb_Ctl,0,M2),
	update_sc_value(test_hscroll),
	update_sc_value(test_vscroll),
	show_scroll_values(_Win),
	!.
  task_win_eh(_Win,e_Menu(id_scroll,_ShiftCtlAlt),0):-!,
	!.
%END Task Window, id_scroll
%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	win_Destroy(_Win),
	!.
%END Task Window, id_file_exit
%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("controls.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents
%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
IFDEF use_message
	msg_Resize(_Win),
ENDDEF
	RCT=win_GetClientRect(_Win),
	win_Invalidate(_Win,RCT),
	!.
%END Task Window, e_Size

  task_win_eh(Win,e_control(oper_create,_,_,_),0) :-!,
	create_controls(Win),!,fail.

  task_win_eh(Win,e_control(oper_destroy,_,_,_),0) :-!,
	destroy_controls(Win),!,fail.

  task_win_eh(_,e_control(oper_show,_,_,_),0) :-!,
	show_controls(),!,fail.

  task_win_eh(_,e_control(oper_hide,_,_,_),0) :-!,
	hide_controls(),!,fail.

  task_win_eh(_,e_control(oper_move,_,_,_),0) :-!,
	move_controls(),!,fail.

  task_win_eh(_,e_control(oper_restore,_,_,_),0) :-!,
	restore_controls(),!,fail.

  task_win_eh(_,e_control(oper_gettext,_,_,_),0) :-!,
	get_control_text(),!,fail.

  task_win_eh(_,e_control(oper_settext,_,_,_),0) :-!,
	set_control_text(),!,fail.

  task_win_eh(_,e_control(oper_enable,_,_,_),0) :-!,
	enable_controls(),!,fail.

  task_win_eh(_,e_control(oper_disable,_,_,_),0) :-!,
	disable_controls(),!,fail.

  task_win_eh(_,e_control(Control_ID,_,_,_),0) :-
	checkbox(Control_ID),!,
	flip_checkbox(Control_ID),!,fail.

  task_win_eh(_,e_control(Control_ID,_,_,_),0) :-
	radio(Control_ID),!,
	flip_radio(Control_ID),!,fail.

  task_win_eh(Win,e_control(test_hscroll,_,_,Control_Info),0) :-
	Control_Info = scroll(ScrollCode,Thumb_Pos),
	ScrollCode >< 0,!,
	changescrollbar(test_hscroll,ScrollCode,Thumb_Pos),
	show_scroll_values(Win),!,fail.

  task_win_eh(Win,e_control(test_vscroll,_,_,Control_Info),0) :-
	Control_Info = scroll(ScrollCode,Thumb_Pos),
	ScrollCode >< 0,!,
	changescrollbar(test_vscroll,ScrollCode,Thumb_Pos),
	show_scroll_values(Win),!,fail.

/***************************************************************************
			Main Goal Project
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
ENDDEF
IFDEF use_tbar
  vpi_SetAttrVal(attr_win_tbar,use_tbar),
ENDDEF
IFDEF use_sbar
  vpi_SetAttrVal(attr_win_sbar,use_sbar),
ENDDEF
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"controls",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 17:57:22-23.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(_Win):-
	win_CreateResDialog(_Win,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,0) :- !,fail.
%END_DLG About dialog


%BEGIN_DLG Scroll Set Range
/**************************************************************************
	Creation and event handling for dialog: Scroll Set Range
**************************************************************************/

CONSTANTS

%BEGIN Scroll Set Range, CreateParms, 17:57:18-23.11.1999, Code automatically updated!
  dlg_scroll_set_range_ResID = idd_scroll_set_range
  dlg_scroll_set_range_DlgType = wd_Modal
  dlg_scroll_set_range_Help = idh_contents
%END Scroll Set Range, CreateParms

PREDICATES

  dlg_scroll_set_range_eh : EHANDLER
  dlg_scroll_set_range_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_scroll_set_range_Create(Parent):-

	scroll_range(SR),
	RANGE=i(SR),
%MARK Scroll Set Range, new variables

	dialog_CreateModal(Parent,dlg_scroll_set_range_ResID,"",
  		[
%BEGIN Scroll Set Range, ControlList, 17:57:18-23.11.1999, Code automatically updated!
		df(idc_scroll_set_range_1,editint(RANGE,[range(1,10000)]),str_prompt("MAX range"))
%END Scroll Set Range, ControlList
		],
		dlg_scroll_set_range_eh,0,VALLIST,ANSWER),!,
	ANSWER = idc_ok,
	dlg_scroll_set_range_update(VALLIST),!.

  dlg_scroll_set_range_Create(_):-
	dlg_Note("Error: Fail in dlg_scroll_set_range_Create").

  dlg_scroll_set_range_update(_VALLIST):-
%BEGIN Scroll Set Range, Update controls, 17:57:18-23.11.1999, Code automatically updated!
	_RANGE = dialog_VLGetint(idc_scroll_set_range_1,_VALLIST),
%END Scroll Set Range, Update controls
	_RANGE=i(Range),
	retractall(_,db),
	assert(scroll_range(Range)),
	!.
  dlg_scroll_set_range_update(_):-
	dlg_Note("Error: Fail in dlg_scroll_set_range_update").

%MARK Scroll Set Range, new events

  dlg_scroll_set_range_eh(_,_,_):-!,fail.

%END_DLG Scroll Set Range










