/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	Palette.PRO
 Purpose:	Palette Dialog object
 Written by:	Written by: Andrey Skobelev
 Build:		008.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	
******************************************************************************/

ifndef palette_pre_included
 #Error: this file requires include: palette.pre
enddef 

constants
  palette_con_resize = 2345

  % Constants bellow define buttons layout inside Palette window
  palette_con_PosPrev = pnt(5,3)
  palette_con_DeltaPosPrev = pnt(45,42)
  palette_con_PosPAT = pnt(60,5)
  palette_con_DeltaPosPAT = pnt(20,20)
  palette_con_PosColors = pnt(150,5)
  palette_con_DeltaPosColors = pnt(20,20)
  palette_con_PosPen = pnt(330,5)
  palette_con_DeltaPosPen = pnt(35,20)
  palette_WindowHeight = 50

  % Scrollbar control Id
  palette_idc_scroll = 3419

  % Default COLOR constants
  palette_Col_White	= 0xFFFFFF
  palette_Col_Black	= 0x000000
  palette_Col_Gray	= 0x808080
  palette_Col_LtGray	= 0xC0C0C0
  palette_Col_Red	= 0x0000FF
  palette_Col_DkRed	= 0x000080
  palette_Col_Green	= 0x00FF00
  palette_Col_DkGreen	= 0x008000
  palette_Col_Blue	= 0xFF0000
  palette_Col_DkBlue	= 0x800000
  palette_Col_Cyan	= 0xFFFF00
  palette_Col_DkCyan	= 0x808000
  palette_Col_Magenta	= 0xFF00FF
  palette_Col_DkMagenta	= 0x800080
  palette_Col_Yellow	= 0x00FFFF
  palette_Col_DkYellow	= 0x008080
  palette_DefaultNcolors = 8

% Palette object database
database - palette_db
  palette_db_Colors(WINDOW,RCT,COLOR)
  palette_db_Fill(WINDOW,RCT,PATSTYLE)
  palette_db_Pen(WINDOW,RCT,PENSTYLE,PENWIDTH)
  palette_db_MouseRect(WINDOW,BOOLEAN Press,INTEGER Button,RCT)
  palette_db_Prev(WINDOW,COLOR PenColor,COLOR FillColor,PATSTYLE,PENSTYLE,PENWIDTH)
  palette_db_ColorInfo(WINDOW,INTEGER NColors,ColorList,
  	PNT PosPen,INTEGER SrollColor,Palette_Callback Callback)
  palette_db_SetInfo(WINDOW,PALETTE_SET,PNT Delta_W_H)
  palette_db_WinWin(WINDOW,WINDOW)
  palette_db_InitMode(WINDOW,BOOLEAN InitModeDlg)
  palette_db_ScrollWin(WINDOW,WINDOW)

predicates
  palette_eh   : EHANDLER 	  % Palette child window event handler
  dlg_palette_eh : EHANDLER	  % Dialog event handler
procedure  palette_draw_color_sels(WINDOW)
determ palette_Update_colorList(WINDOW)
determ palette_Create_ColorsDefault(WINDOW)
procedure  palette_draw_Pat_sels(WINDOW)
procedure  palette_Init_PatDefault(WINDOW)
procedure  palette_draw_Pen_sels(WINDOW)
determ palette_Init_PenDefault(WINDOW)
determ palette_MouseInRect(WINDOW,PNT,RCT)
determ palette_MouseInRectColor(WINDOW,PNT,RCT)
procedure  palette_draw_button_frame(WINDOW,RCT,BOOLEAN PUSH)
procedure  palette_send_notification(WINDOW,RCT,INTEGER MouseB)
determ palette_draw_prev(WINDOW)
procedure  palette_CalcSizes(INTEGER,RCT,PNT)
determ palette_ScrollingRctColor(WINDOW,RCT,RCT)
procedure  palette_draw_sel(WINDOW,RCT,BOOLEAN PUSH)
determ palette_CalcScrollRange(WINDOW,INTEGER Range)
determ palette_CalcScrollPos(INTEGER Range,INTEGER InValue,INTEGER OutValue)
procedure palette_ChkNColor(INTEGER NColors,INTEGER NColorsOut)
procedure palette_InitFlags(BOOLEAN Title,BOOLEAN ClosebButton,WSFLAGS)
procedure palette_InitWinForMode(WINDOW)
procedure palette_AssertDefault(WINDOW,PNT PosPen)
procedure palette_DelScroll(WINDOW)
procedure palette_ChangeSet(WINDOW,PALETTE_SET)

clauses
/**** global ***************************************************************
  palette_Create\6 - creates palette dialog with 16 default colors
  RETURN 	Palette window
  ERRORS	No errors
  FAIL		Never fails
***************************************************************************/
  palette_Create(ParentWin,Pnt,Callback,Title,TitleAble,Close,DlgWin):-
	palette_InitFlags(TitleAble,Close,FLAGS),
	palette_CalcSizes(palette_DefaultNcolors,RCT,PosPen),
	RCT = rct(X,Y,X1,Y1), PNT = pnt(Xp,Yp),
	Xd = X + Xp, Yd = Y + Yp, Xd1 = X1 + Xp, Yd1 = Y1 + Yp,
	RCTD = rct(Xd,Yd,Xd1,Yd1),
	trap(DlgWin = win_CreateDynDialog(ParentWin,
	[dlg(wdef(wd_ModeLess,RCTD,Title,u_Pixels),FLAGS)],
	  dlg_palette_eh,0),_,/*error*/errorexit(error_vpi_package_bad_window)),
	assert(palette_db_ColorInfo(DlgWin,palette_DefaultNcolors,[],PosPen,0,Callback)),
	palette_Create_ColorsDefault(DlgWin),
	RctDia = win_GetClientRect(DlgWin),
	assert(palette_db_InitMode(DlgWin,b_true)),
	assert(palette_db_WinWin(DlgWin,DlgWin)),
	win_Create(w_Child,RctDia,"",no_menu,
	  DlgWin,[wsf_ClipSiblings,wsf_ClipChildren],palette_eh,0),
	!.
  palette_Create(_,_,_,_,_,_,NullWin):- NullWin=cast(WINDOW,0),!.

/**** global ***************************************************************
  palette_Create\8 - creates palette dialog with user defined colors
  RETURN 	Palette window
  ERRORS	Bad parent window
  FAIL		Never fails
***************************************************************************/
  palette_Create(ParentWin,Pnt,Callback,Title,TitleAble,Close,NColors,ColList,DlgWin):-
	palette_InitFlags(TitleAble,Close,FLAGS),
	palette_CalcSizes(NColors,RCT,PosPen),
	RCT = rct(X,Y,X1,Y1), PNT = pnt(Xp,Yp),
	Xd = X + Xp, Yd = Y + Yp, Xd1 = X1 + Xp, Yd1 = Y1 + Yp,
	RCTD = rct(Xd,Yd,Xd1,Yd1),
	trap(DlgWin = win_CreateDynDialog(ParentWin,
	[dlg(wdef(wd_ModeLess,RCTD,Title,u_Pixels),FLAGS)],
	  dlg_palette_eh,0),_,/*error*/errorexit(error_vpi_package_bad_window)),
	palette_ChkNColor(NColors,NColorsOut),
	assert(palette_db_ColorInfo(DlgWin,NColorsOut,ColList,PosPen,0,Callback)),
	assert(palette_db_InitMode(DlgWin,b_true)),
	assert(palette_db_WinWin(DlgWin,DlgWin)),
	RctDia = win_GetClientRect(DlgWin),
	win_Create(w_Child,RctDia,"",no_menu,
	  DlgWin,[wsf_ClipSiblings,wsf_ClipChildren],palette_eh,0),
	!.
  palette_Create(_,_,_,_,_,_,_,_,NullWin):- NullWin=cast(WINDOW,0),!.

/**** global ***************************************************************
  palette_SetPreviewPen(DlgWin,Pen)
  ERRORS	Bad parent window
  FAIL		Never fails
***************************************************************************/
  palette_SetPreviewPen(DlgWin,Pen):-
	palette_db_WinWin(DlgWin,Win),
	Pen = pen(PENWIDTH, PENSTYLE, COLOR),
	retract(palette_db_Prev(Win,_,ColorFill,Pat,_,_)),
	assert(palette_db_Prev(Win,COLOR,ColorFill,Pat,PENSTYLE,PENWIDTH)),
	palette_draw_prev(Win),!.
  palette_SetPreviewPen(_,_):-errorexit(error_vpi_package_bad_window).

/**** global ***************************************************************
  palette_SetPreviewBrush(DlgWin,Brush)
  ERRORS	Bad parent window
  FAIL		Never fails
***************************************************************************/
  palette_SetPreviewBrush(DlgWin,Brush):-
	palette_db_WinWin(DlgWin,Win),
	Brush = brush(PAT, COLOR),
	retract(palette_db_Prev(Win,PenColor,_,_,PENSTL,PENW)),
	assert(palette_db_Prev(Win,PenColor,COLOR,PAT,PENSTL,PENW)),
	palette_draw_prev(Win),
	!.
  palette_SetPreviewBrush(_,_):-errorexit(error_vpi_package_bad_window).

/**** global ***************************************************************
  palette_GetPreview(DlgWin,PEN,BRUSH)
  ERRORS	Bad parent window
  FAIL		Never fails
***************************************************************************/
  palette_GetPreview(DlgWin,pen(PENWIDTH,PENSTYLE,PenColor),brush(Pat,ColorFill)):-
	palette_db_WinWin(DlgWin,Win),
	palette_db_Prev(Win,PenColor,ColorFill,Pat,PENSTYLE,PENWIDTH),
	!.
  palette_GetPreview(_,NullPen,NullBrush):-
	NullPen = cast(PEN,0),
	NullBrush = cast(BRUSH,0),
	errorexit(error_vpi_package_bad_window).

/**** global ***************************************************************
  palette_SetPreview(DlgWin,PEN,BRUSH)
  ERRORS	Bad parent window
  FAIL		Never fails
***************************************************************************/
  palette_SetPreview(DlgWin,pen(PENW,PENSTL,PenColor),brush(Pat,ColorFill)):-
	palette_db_WinWin(DlgWin,Win),
	retract(palette_db_Prev(Win,_,_,_,_,_)),
	assert(palette_db_Prev(Win,PenColor,ColorFill,Pat,PENSTL,PENW)),
	palette_draw_prev(Win),
	!.
  palette_SetPreview(_,_,_):-errorexit(error_vpi_package_bad_window).

/**** global ***************************************************************
  palette_Setup(WINDOW,PALETTE_SET)
  ERRORS	Bad parent window
  FAIL		Never fails
***************************************************************************/
  palette_Setup(DlgWin,Set):-
	palette_ChangeSet(DlgWin,Set),
	fail.
  palette_Setup(DlgWin,_):-
	palette_db_WinWin(DlgWin,Win),
	palette_DelScroll(Win),
	retractAll(palette_db_colors(Win,_,_)),
	retractAll(palette_db_Fill(Win,_,_)),
	retractAll(palette_db_Pen(Win,_,_,_)),
	palette_Init_PatDefault(Win),
	palette_Update_colorList(Win),
	palette_Init_PenDefault(Win),
	win_PostEvent(Win,e_menu(palette_con_resize,c_Nothing)),
	win_Invalidate(Win),
	!.
  palette_Setup(_,_):-errorexit(error_vpi_package_bad_window).

/**************************************************************************
	Palette parent window (DlgWin) event handler
***************************************************************************/
  dlg_palette_eh(DlgWin,e_CloseRequest(),0):-
	palette_db_WinWin(DlgWin,Win),
	palette_db_ColorInfo(Win,_,_,_,_,Callback),
	Callback(DlgWin,is_ToBeDestroyed),
	!.
  dlg_palette_eh(DlgWin,e_Size(_,_),0):-
	palette_db_WinWin(DlgWin,Win), not(Win = DlgWin),
	win_PostEvent(Win,e_menu(palette_con_resize,c_Nothing)),
	!.
  dlg_palette_eh(_,_,0):- fail.

  palette_DelScroll(Win):-
	retract(palette_db_ScrollWin(Win,WinCtrl)),
	trap(win_Destroy(WinCtrl),_,fail),!.
  palette_DelScroll(_):-!.

  palette_ChangeSet(DlgWin,preview(OnOff)):-
	palette_db_WinWin(DlgWin,Win),
	retract(palette_db_SetInfo(Win,preview(_),Delta_W_H)),
	assert(palette_db_SetInfo(Win,preview(OnOff),Delta_W_H)),
	!.
  palette_ChangeSet(DlgWin,pen(OnOff)):-
	palette_db_WinWin(DlgWin,Win),
	retract(palette_db_SetInfo(Win,pen(_),Delta_W_H)),
	assert(palette_db_SetInfo(Win,pen(OnOff),Delta_W_H)),
	!.
  palette_ChangeSet(DlgWin,pattern(OnOff)):-
	palette_db_WinWin(DlgWin,Win),
	retract(palette_db_SetInfo(Win,pattern(_),Delta_W_H)),
	assert(palette_db_SetInfo(Win,pattern(OnOff),Delta_W_H)),
	!.
  palette_ChangeSet(DlgWin,color(OnOff)):-
	palette_db_WinWin(DlgWin,Win),
	retract(palette_db_SetInfo(Win,color(_),Delta_W_H)),
	assert(palette_db_SetInfo(Win,color(OnOff),Delta_W_H)),
	!.
  palette_ChangeSet(_,_):-!.


/**************************************************************************
	Palette child window event handler
***************************************************************************/
  palette_eh(Win,e_Create(_),0):-
	palette_InitWinForMode(Win),
	palette_db_ColorInfo(Win,_NColors,_ColList,PosPen,_SrollPos,_Callback),
	palette_AssertDefault(Win,PosPen), % -
	palette_Init_PatDefault(Win), % +
	palette_Update_colorList(Win), % +
	palette_Init_PenDefault(Win), % +
	assert(palette_db_MouseRect(Win,b_false,c_Nothing,rct(0,0,0,0))),
	assert(palette_db_Prev(Win,color_Black,color_Gray,pat_Solid,ps_Solid,1)),
	!.

  palette_eh(Win,e_Destroy(),0):-
	retractAll(palette_db_colors(Win,_,_)),
	retractAll(palette_db_Fill(Win,_,_)),
	retractAll(palette_db_Pen(Win,_,_,_)),
	retractAll(palette_db_MouseRect(Win,_,_,_)),
	retractAll(palette_db_Prev(Win,_,_,_,_,_)),
	retractAll(palette_db_ColorInfo(Win,_,_,_,_,_)),
	retractAll(palette_db_WinWin(_,Win)),
	!.

  palette_eh(Win,e_menu(palette_con_resize,c_Nothing),0):-
	DlgWin = win_GetParent(Win),
	trap(RctDia = win_GetClientRect(DlgWin),_,fail),
	trap(win_Move(Win,RctDia),_,fail),
	!.

  palette_eh(_Win,e_EraseBackground(),0):-!.

  palette_eh(Win,e_Control(_Id,_CtrlType,WinCtrl,scroll(sc_LineDown,_SET)),0):- % LineDown event handling
	palette_db_ColorInfo(Win,NColors,ColorList,PosPen,Sroll,Callback),
	SrollNew = Sroll + 1, 
	palette_CalcScrollRange(Win,Range),
	palette_CalcScrollPos(Range,SrollNew,OutSroll),
	win_SetScrollPos(WinCtrl,sb_Ctl,OutSroll),
	retract(palette_db_ColorInfo(Win,NColors,ColorList,PosPen,_,Callback)),
	assert(palette_db_ColorInfo(Win,NColors,ColorList,PosPen,OutSroll,Callback)),
	palette_draw_color_sels(Win),
	!.
  palette_eh(Win,e_Control(_Id,_CtrlType,WinCtrl,scroll(sc_LineUp,_SET)),0):- % LineUp event handling
	palette_db_ColorInfo(Win,NColors,ColorList,PosPen,Sroll,Callback),
	SrollNew = Sroll - 1, 
	palette_CalcScrollRange(Win,Range),
	palette_CalcScrollPos(Range,SrollNew,OutSroll),
	win_SetScrollPos(WinCtrl,sb_Ctl,OutSroll),
	retract(palette_db_ColorInfo(Win,NColors,ColorList,PosPen,_,Callback)),
	assert(palette_db_ColorInfo(Win,NColors,ColorList,PosPen,OutSroll,Callback)),
	palette_draw_color_sels(Win),
	!.
  palette_eh(Win,e_Control(_Id,_CtrlType,WinCtrl,scroll(sc_PageDown,_SET)),0):- % PageDown event handling
	palette_db_ColorInfo(Win,NColors,ColorList,PosPen,Sroll,Callback),
	SrollNew = Sroll + NColors, 
	palette_CalcScrollRange(Win,Range),
	palette_CalcScrollPos(Range,SrollNew,OutSroll),
	win_SetScrollPos(WinCtrl,sb_Ctl,OutSroll),
	retract(palette_db_ColorInfo(Win,NColors,ColorList,PosPen,_,Callback)),
	assert(palette_db_ColorInfo(Win,NColors,ColorList,PosPen,OutSroll,Callback)),
	palette_draw_color_sels(Win),
	!.
  palette_eh(Win,e_Control(_Id,_CtrlType,WinCtrl,scroll(sc_PageUp,_SET)),0):- % PageUp event handling
	palette_db_ColorInfo(Win,NColors,ColorList,PosPen,Sroll,Callback),
	SrollNew = Sroll - NColors, 
	palette_CalcScrollRange(Win,Range),
	palette_CalcScrollPos(Range,SrollNew,OutSroll),
	win_SetScrollPos(WinCtrl,sb_Ctl,OutSroll),
	retract(palette_db_ColorInfo(Win,NColors,ColorList,PosPen,_,Callback)),
	assert(palette_db_ColorInfo(Win,NColors,ColorList,PosPen,OutSroll,Callback)),
	palette_draw_color_sels(Win),
	!.

  palette_eh(_Win,e_Control(_Id,_CtrlType,WinCtrl,scroll(sc_Thumb,SET)),0):- % Thumb event handling
	win_SetScrollPos(WinCtrl,sb_Ctl,Set),
	!.

  palette_eh(Win,e_Control(_Id,_CtrlType,_WinCtrl,scroll(sc_ThumbTrack,SET)),0):- % ThumbTrack event handling
	retract(palette_db_ColorInfo(Win,NColors,ColorList,PosPen,_,Callback)),
	assert(palette_db_ColorInfo(Win,NColors,ColorList,PosPen,Set,Callback)),
	palette_draw_color_sels(Win),
	!.

  palette_eh(Win,e_MouseMove(PNT,c_Nothing,_),0):- % The Mouse inside of same button
 	palette_db_MouseRect(Win,b_true,_MB,RctOld),
	palette_MouseInRect(Win,PNT,RCT), RCT = RctOld,
	palette_draw_sel(Win,RCT,b_true),
	!.
  palette_eh(Win,e_MouseMove(PNT,c_Nothing,_),0):- % The Left Mouse inside of other button
	palette_db_MouseRect(Win,b_true,mouse_button_left,RctOld),
	palette_MouseInRect(Win,PNT,RCT), not(RCT = RctOld),
	retractAll(palette_db_MouseRect(Win,_,_,_)),
	assert(palette_db_MouseRect(Win,b_true,mouse_button_left,RCT)),
	palette_draw_sel(Win,RCT,b_true),
	palette_draw_sel(Win,RctOld,b_false),
	!.
  palette_eh(Win,e_MouseMove(PNT,c_Nothing,_),0):- % The Right Mouse inside of other button
	palette_db_MouseRect(Win,b_true,mouse_button_right,RctOld),
	palette_MouseInRectColor(Win,PNT,RCT), not(RCT = RctOld),
	retractAll(palette_db_MouseRect(Win,_,_,_)),
	assert(palette_db_MouseRect(Win,b_true,mouse_button_right,RCT)),
	palette_draw_sel(Win,RCT,b_true),
	palette_draw_sel(Win,RctOld,b_false),
	!.
  palette_eh(Win,e_MouseMove(_PNT,c_Nothing,_),0):- % The Mouse outside of button
	palette_db_MouseRect(Win,b_true,_,RctOld),
	palette_draw_sel(Win,RCTOld,b_false),
	!.

  palette_eh(Win,e_MouseDown(PNT,c_Nothing,mouse_button_right),0):-
	win_CaptureMouse(Win), % The Right Mouse inside of color button
	palette_MouseInRectColor(Win,PNT,RCT),
	retractAll(palette_db_MouseRect(Win,_,_,_)),
	assert(palette_db_MouseRect(Win,b_true,mouse_button_right,RCT)),
	palette_draw_sel(Win,RCT,b_true),
	!.
  palette_eh(Win,e_MouseDown(PNT,c_Nothing,mouse_button_left),0):-
	win_CaptureMouse(Win), % The Left Mouse inside of button
	palette_MouseInRect(Win,PNT,RCT),
	retractAll(palette_db_MouseRect(Win,_,_,_)),
	assert(palette_db_MouseRect(Win,b_true,mouse_button_left,RCT)),
	palette_draw_sel(Win,RCT,b_true),
	!.
  palette_eh(Win,e_MouseDown(_PNT,c_Nothing,MB),0):-
	win_CaptureMouse(Win), % The Mouse outside of button
	retractAll(palette_db_MouseRect(Win,_,_,_)),
	assert(palette_db_MouseRect(Win,b_true,MB,rct(0,0,0,0))),
	!.

  palette_eh(Win,e_MouseUp(PNT,c_Nothing,mouse_button_left),0):-
	palette_MouseInRect(Win,PNT,RCT),% The left Mouse inside of button
	win_ReleaseMouse(),
	retractAll(palette_db_MouseRect(Win,_,_,_)),
	assert(palette_db_MouseRect(Win,b_false,mouse_button_left,RCT)),
	palette_draw_sel(Win,RCT,b_false),
	palette_send_notification(Win,RCT,mouse_button_left),
	!.
  palette_eh(Win,e_MouseUp(PNT,c_Nothing,mouse_button_right),0):-
	palette_MouseInRectColor(Win,PNT,RCT),% The right Mouse inside of color button
	win_ReleaseMouse(),
	retractAll(palette_db_MouseRect(Win,_,_,_)),
	assert(palette_db_MouseRect(Win,b_false,mouse_button_right,RCT)),
	palette_draw_sel(Win,RCT,b_false),
	palette_send_notification(Win,RCT,mouse_button_right),
	!.
  palette_eh(Win,e_MouseUp(_PNT,c_Nothing,_),0):-
	palette_db_MouseRect(Win,b_true,_MB,RctOld),
	win_ReleaseMouse(), % The Mouse outside of button
	retractAll(palette_db_MouseRect(Win,_,_,_)),
	assert(palette_db_MouseRect(Win,b_false,mouse_button_right,rct(0,0,0,0))),
	palette_draw_sel(Win,RctOld,b_false),
	!.

  palette_eh(Win,e_Update(_RCT),0):-
	win_Clear(Win,color_LtGray),
	palette_draw_Pen_sels(Win),
	palette_draw_Pat_sels(Win),
	palette_draw_color_sels(Win),
	palette_draw_prev(Win),
	!.
	
predicates
procedure  palette_draw_color_sel(WINDOW,COLOR,RCT,BOOLEAN PUSH)
procedure  palette_Init_Color(WINDOW,INTEGER,INTEGER,COLOR)

procedure  palette_draw_Pat_sel(WINDOW,PATSTYLE,RCT,BOOLEAN PUSH)
procedure  palette_Init_Fill(WINDOW,INTEGER,INTEGER,PATSTYLE)

procedure  palette_draw_Pen_sel(WINDOW,PENSTYLE,PENWIDTH,RCT,BOOLEAN PUSH)
determ palette_Init_Pen(WINDOW,INTEGER,INTEGER,PENSTYLE,PENWIDTH)

procedure  palette_Extract_ColorList1(WINDOW,ColorList,INTEGER)
procedure  palette_Extract_ColorList2(WINDOW,ColorList,INTEGER,INTEGER,INTEGER)
procedure  palette_CalcColorList(ColorList,INTEGER,INTEGER)
procedure  palette_draw_preview_frame(WINDOW,RCT)
clauses

  palette_InitWinForMode(Win):-
	retract(palette_db_InitMode(Win,b_false)),
	!.
  palette_InitWinForMode(Win):-
	DlgWin = win_GetParent(Win),
	retract(palette_db_InitMode(DlgWin,b_true)),
	retract(palette_db_WinWin(DlgWin,DlgWin)),
	assert(palette_db_WinWin(DlgWin,Win)),
	retract(palette_db_ColorInfo(DlgWin,NColors,ColList,PosPen,SrollPos,Callback)),
	assert(palette_db_ColorInfo(Win,NColors,ColList,PosPen,SrollPos,Callback)),
	!.
  palette_InitWinForMode(_):-errorexit(error_vpi_package_bad_window).

  palette_AssertDefault(Win,PosPen):-
	assert(palette_db_SetInfo(Win,preview(on(palette_con_PosPrev)),
		palette_con_DeltaPosPrev)),
	assert(palette_db_SetInfo(Win,pen(on(PosPen)),
		palette_con_DeltaPosPen)),
	assert(palette_db_SetInfo(Win,pattern(on(palette_con_PosPAT)),
		palette_con_DeltaPosPAT)),
	assert(palette_db_SetInfo(Win,color(on(palette_con_PosColors)),
		palette_con_DeltaPosColors)),
	!.

  palette_InitFlags(b_true,b_true,[wsf_TitleBar,wsf_Close]):-!.
  palette_InitFlags(b_true,b_false,[wsf_TitleBar]):-!.
  palette_InitFlags(_,_,[]):-!. % Init Dyalog flags

  palette_ChkNColor(NColors,NColors):-NColors >= 0,!.
  palette_ChkNColor(_,0):-!. % If number of colors < 0
  
  palette_Update_colorList(Win):- % Initialization of colour buttons in one line
	palette_db_SetInfo(Win,color(on(_PNTP)),_PNTD),
	palette_db_ColorInfo(Win,NColors,ColList,_,_,_),
  	palette_CalcColorList(ColList,0,M),
  	M <= NColors,
	palette_Extract_ColorList1(Win,ColList,0),
	!.
  palette_Update_colorList(Win):- % Initialization of colour buttons in two lines
	palette_db_SetInfo(Win,color(on(_PNTP)),_PNTD),
	palette_db_ColorInfo(Win,NColors,ColList,_,_,_),
  	palette_CalcColorList(ColList,0,M),
  	M <= NColors * 2,
	palette_Extract_ColorList2(Win,ColList,0,0,NColors),
	!.
  palette_Update_colorList(Win):-% Initialization of colour buttons in one line with scroll control
	palette_db_SetInfo(Win,color(on(PNTP)),PNTD),
	retract(palette_db_ColorInfo(Win,NColors,ColList,PosPen,_,Callback)),
	assert(palette_db_ColorInfo(Win,NColors,ColList,PosPen,0,Callback)),
	palette_Extract_ColorList1(Win,ColList,0),
	palette_CalcScrollRange(Win,Range),
	PNTP = pnt(PX,Py),
	PNTD = pnt(DX,DY),
	R = PX + DX * NColors, ST = PY + DY, SB = PY + DY * 2,
	WinCtrl = win_CreateControl(wc_HScroll,rct(PX,ST,R,SB),"",Win,[wsf_ClipSiblings,wsf_ClipChildren],palette_idc_scroll),
	assert(palette_db_ScrollWin(Win,WinCtrl)),
	win_SetScrollRange(WinCtrl,sb_Ctl,0,Range),
	win_SetScrollPos(WinCtrl,sb_Ctl,0),
	!.
  palette_Update_colorList(_):-!.

  palette_CalcScrollRange(Win,Range):- % Scroll range calculation
	palette_db_ColorInfo(Win,NColors,ColList,_,_,_),
  	palette_CalcColorList(ColList,0,M),
  	Range = M - NColors,
	!.

  palette_CalcScrollPos(Range,InPos,InPos):-InPos >= 0, InPos <= Range,!.
  palette_CalcScrollPos(Range,InPos,Range):- InPos > Range,!.
  palette_CalcScrollPos(_Range,InPos,0):- InPos < 0,!. % Scroll thumb position calculation

  palette_CalcColorList([],M,M):-!.
  palette_CalcColorList([_L1|L2],N1,N):-!,N2 = N1 + 1,palette_CalcColorList(L2,N2,N).
  palette_CalcColorList(_,M,M):-!.

  palette_Extract_ColorList1(_,[],_):-!.
  palette_Extract_ColorList1(Win,[L1|L2],N):-!,
	palette_Init_Color(Win,N,0,L1), % Initialization of colour buttons in one line
	N1 = N + 1,
	palette_Extract_ColorList1(Win,L2,N1).
  palette_Extract_ColorList1(_,_,_):-!.

  palette_Extract_ColorList2(_Win,[],_,_,_):- !.
  palette_Extract_ColorList2(Win,[L1|L2],NF,NS,NColors):-!,
	NFInit = NF mod NColors, % Initialization of colour buttons in two lines
	palette_Init_Color(Win,NFInit,NS,L1),
	NF1 = NF + 1, NS1 = NF1 div NColors,
	palette_Extract_ColorList2(Win,L2,NF1,NS1,NColors).
  palette_Extract_ColorList2(_,_,_,_,_):-!.

  palette_Create_ColorsDefault(DlgWin):- % Initialization of default color list
	retract(palette_db_ColorInfo(DlgWin,Ncol,_,PosPen,SrollPos,Callback)),
	assert(palette_db_ColorInfo(DlgWin,Ncol,[
  		palette_Col_White,
		palette_Col_LtGray,
		palette_Col_Red,
		palette_Col_Green,
		palette_Col_Blue,
		palette_Col_Cyan,
		palette_Col_Magenta,
		palette_Col_Yellow,
		palette_Col_Black,
		palette_Col_Gray,
		palette_Col_DkRed,
		palette_Col_DkGreen,
		palette_Col_DkBlue,
		palette_Col_DkCyan,
		palette_Col_DkMagenta,
		palette_Col_DkYellow
	],PosPen,SrollPos,Callback)),!.

  palette_Init_PatDefault(Win):- % Initialization of default Fills
	palette_Init_Fill(Win,0,0,pat_Solid),
	palette_Init_Fill(Win,1,0,pat_Horz),
	palette_Init_Fill(Win,2,0,pat_Vert),
	palette_Init_Fill(Win,3,0,pat_FDiag),
	palette_Init_Fill(Win,0,1,pat_BDiag),
	palette_Init_Fill(Win,1,1,pat_Cross),
	palette_Init_Fill(Win,2,1,pat_DiagCross),
	palette_Init_Fill(Win,3,1,pat_Hollow),
	!.

  palette_Init_PenDefault(Win):- % Initialization of default Pens
	palette_Init_Pen(Win,0,0,ps_Solid,1),
	palette_Init_Pen(Win,1,0,ps_Dash,1),
	palette_Init_Pen(Win,2,0,ps_Dot,1),
	palette_Init_Pen(Win,3,0,ps_DashDot,1),
	palette_Init_Pen(Win,4,0,ps_DashDotDot,1),
	palette_Init_Pen(Win,5,0,ps_Hollow,1),
	palette_Init_Pen(Win,0,1,ps_Solid,2),
	palette_Init_Pen(Win,1,1,ps_Solid,3),
	palette_Init_Pen(Win,2,1,ps_Solid,4),
	palette_Init_Pen(Win,3,1,ps_Solid,5),
	palette_Init_Pen(Win,4,1,ps_Solid,6),
	palette_Init_Pen(Win,5,1,ps_Solid,7),
	!.
  palette_Init_PenDefault(_):-!.

  palette_Init_Color(Win,Posx,Posy,Color):- % Initialization of Color rectangles
	palette_db_SetInfo(Win,color(on(PNTP)),PNTD),
	PNTP = pnt(PX,Py),
	PNTD = pnt(DX,DY),
	XColor = PX + DX * Posx, X1Color = PX + DX * (Posx + 1) -1,
	YColor = PY + DY * Posy, Y1Color = PY + DY * (Posy + 1) -1,
	assert(palette_db_colors(Win,rct(XColor,YColor,X1Color,Y1Color),Color)),
	!.
  palette_Init_Color(_,_,_,_):-!.

  palette_Init_Fill(Win,Posx,Posy,Pat):- % Initialization of Fill rectangles
	palette_db_SetInfo(Win,pattern(on(PNTP)),PNTD),
	PNTP = pnt(PX,Py),
	PNTD = pnt(DX,DY),
	XColor = PX + DX * Posx, X1Color = PX + DX * (Posx + 1) - 1,
	YColor = PY + DY * Posy, Y1Color = PY + DY * (Posy + 1) - 1,
	assert(palette_db_Fill(Win,rct(XColor,YColor,X1Color,Y1Color),Pat)),
	!.
  palette_Init_Fill(_,_,_,_):-!.

  palette_Init_Pen(Win,Posx,Posy,PSTYLE,PWIDTH):- % Initialization of Pen rectangles
	palette_db_ColorInfo(Win,_,_,_,_,_),
	palette_db_SetInfo(Win,pen(on(PNTP)),PNTD),
	PNTP = pnt(PX,Py),
	PNTD = pnt(DX,DY),
	XColor = PX + DX * Posx, X1Color = PX + DX * (Posx + 1) - 1,
	YColor = PY + DY * Posy, Y1Color = PY + DY * (Posy + 1) - 1,
	assert(palette_db_Pen(Win,rct(XColor,YColor,X1Color,Y1Color),PSTYLE,PWIDTH)),
	!.

  palette_ScrollingRctColor(Win,RCT,ScrollingRCT):- % Color button rectangle correction
	palette_db_SetInfo(Win,color(on(_)),PNTD),
	palette_db_ColorInfo(Win,_NColors,_,_,ScrollPos,_),
	PNTD = pnt(DX,_DY),
	RCT = rct(X,Y,X1,Y1), XS = X - DX * ScrollPos, XS1 = X1 - DX * ScrollPos,
	ScrollingRCT = rct(XS,Y,XS1,Y1),
	!.

  palette_draw_sel(Win,RCT,Push):- % Draw color button
	palette_db_colors(Win,RCT,COLOR),% if RCT = RCT of color button
	palette_ScrollingRctColor(Win,RCT,ScrolingRCT),
	palette_draw_color_sel(Win,COLOR,ScrolingRCT,Push),
	!.
  palette_draw_sel(Win,RCT,Push):- % Draw fill button
	palette_db_Fill(Win,RCT,Pat),% if RCT = RCT of Fill button
	palette_draw_Pat_sel(Win,Pat,RCT,Push),
	!.
  palette_draw_sel(Win,RCT,Push):- % Draw pen button
	palette_db_Pen(Win,RCT,PSTYLE,PWIDTH),% if RCT = RCT of Pen button
	palette_draw_Pen_sel(Win,PSTYLE,PWIDTH,RCT,Push),
	!.
  palette_draw_sel(_,_,_).

  palette_draw_color_sels(Win):- % Draw color buttons
	palette_db_colors(Win,RCT,COLOR),
	  palette_ScrollingRctColor(Win,RCT,ScrolingRCT),
	  palette_draw_color_sel(Win,COLOR,ScrolingRCT,b_false),
	fail.	
  palette_draw_color_sels(_):-!.

  palette_draw_Pat_sels(Win):- % Draw Fill buttons
	palette_db_Fill(Win,RCT,Pat),
	  palette_draw_Pat_sel(Win,Pat,RCT,b_false),
	fail.	
  palette_draw_Pat_sels(_):-!.

  palette_draw_Pen_sels(Win):- % Draw Pen buttons
	palette_db_Pen(Win,RCT,PSTYLE,PWIDTH),
	  palette_draw_Pen_sel(Win,PSTYLE,PWIDTH,RCT,b_false),
	fail.	
  palette_draw_Pen_sels(_):-!.

  palette_draw_color_sel(Win,Col,Rct,PUSH):- % Draw color button
	palette_db_SetInfo(Win,color(on(PNTP)),PNTD),
	Rct = rct(X,Y,X1,Y1),
	Xxx = X + 2, Yyy = Y + 2,
	PNTP = pnt(PX,_Py),
	PNTD = pnt(DX,_DY),
	palette_db_ColorInfo(Win,NColors,_,_,_ScrollPos,_),
	Xmin = PX - DX , Xmax = PX + DX * NColors,
	X < Xmax, X > Xmin, % Only visible
	palette_draw_button_frame(Win,Rct,PUSH),
	win_SetPen(Win,pen(1,ps_Hollow,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,Col)),
	draw_Rect(Win,rct(Xxx,Yyy,X1,Y1)),
	!.	
  palette_draw_color_sel(_,_,_,_):-!.

  palette_draw_Pat_sel(Win,Pat,Rct,PUSH):- % Draw fill button
	Rct = rct(X,Y,X1,Y1),
	Xxx = X + 2, Yyy = Y + 2,
	palette_draw_button_frame(Win,Rct,PUSH),
	win_SetPen(Win,pen(1,ps_Hollow,color_Black)),
	win_SetBrush(Win,brush(Pat,color_Black)),
	draw_Rect(Win,rct(Xxx,Yyy,X1,Y1)),
	!.	

  palette_draw_Pen_sel(Win,PSTYLE,PWIDTH,Rct,PUSH):- % Draw Pen button
	palette_db_SetInfo(Win,pen(on(_PNTP)),PntDelta),
	Rct = rct(X,Y,X1,Y1),
	PntDelta = pnt(_,YD),
	Xx = X + 2, Yy = Y + YD div 2,
	X1x = X1 - 1,
	RctWin = win_GetClientRect(Win),
	win_SetClip(Win,RctWin),
	palette_draw_button_frame(Win,Rct,PUSH),
	win_SetPen(Win,pen(PWIDTH,PSTYLE,color_Black)),
	win_SetClip(Win,rct(Xx,Y,X1x,Y1)),
	draw_Line(Win,pnt(X,Yy),pnt(X1,Yy)),
	win_SetClip(Win,RctWin),
	!.	
  palette_draw_Pen_sel(_,_,_,_,_):-!.

  palette_CalcSizes(NColors,RCT,PosPen):- % palette window size and first Pen button position calculation 
	PNTP = palette_con_PosColors, PNTP = pnt(PX,_Py),
	PNTD = palette_con_DeltaPosColors, PNTD = pnt(DX,_DY),
	PNTPen = palette_con_PosPen, PNTPen = pnt(_,YPen),
	PNTDeltaPen = palette_con_DeltaPosPen, PNTDeltaPen = pnt(XDp,_),
	XPen = PX + DX * NColors + DX div 2,
	PosPen = pnt(XPen,YPen),
	XSize = XPen + XDp * 6 + DX div 2,
	RCT = rct(0,0,XSize,palette_WindowHeight),
	!.
  
  palette_draw_button_frame(Win,Rct,Push):- % The image of the button frame
	Push = b_true,
	Rct = rct(X,Y,X1,Y1),
	Xx = X + 1, Xx1 = X1 -1, Yy = Y + 1, Yy1 = Y1 - 1,
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Hollow,color_Black)),
	YR = Y1 + 1, XR = X1 + 1, draw_Rect(Win,rct(X,Y,XR,YR)),
	draw_Line(Win,pnt(Xx,Yy),pnt(Xx,Yy1)),
	draw_Line(Win,pnt(Xx1,Yy),pnt(Xx,Yy)),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_Line(Win,pnt(Xx,Yy1),pnt(Xx1,Yy1)),
	draw_Line(Win,pnt(Xx1,Yy1),pnt(Xx1,Yy)),
	!.
  palette_draw_button_frame(Win,Rct,_Push):- 
	Rct = rct(X,Y,X1,Y1),
	Xx = X + 1, Xx1 = X1 -1, Yy = Y + 1, Yy1 = Y1 - 1,
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Hollow,color_Black)),
	YR = Y1 + 1, XR = X1 + 1, draw_Rect(Win,rct(X,Y,XR,YR)),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_Line(Win,pnt(Xx,Yy),pnt(Xx,Yy1)),
	draw_Line(Win,pnt(Xx1,Yy),pnt(Xx,Yy)),
	win_SetPen(Win,pen(1,ps_Solid,color_Gray)),
	draw_Line(Win,pnt(Xx,Yy1),pnt(Xx1,Yy1)),
	draw_Line(Win,pnt(Xx1,Yy1),pnt(Xx1,Yy)),
	!.

  palette_MouseInRect(Win,pnt(X,Y),RCT):- % Pnt in color button, return Rct
	palette_MouseInRectColor(Win,pnt(X,Y),RCT),
	!.
  palette_MouseInRect(Win,pnt(X,Y),RCT):- % Pnt in fill button, return Rct
	palette_db_Fill(Win,RCT,_Pat),
	RCT = rct(XR,YR,X1R,Y1R), X >= XR, Y >= YR, X <= X1R, Y <= Y1R,
	!.
  palette_MouseInRect(Win,pnt(X,Y),RCT):- % Pnt in pen button, return Rct
	palette_db_Pen(Win,RCT,_PSTYLE,_PWIDTH),
	RCT = rct(XR,YR,X1R,Y1R), X >= XR, Y >= YR, X <= X1R, Y <= Y1R,
	!.

  palette_MouseInRectColor(Win,pnt(X,Y),RCT):-% Pnt in color button, return Rct
	palette_db_SetInfo(Win,color(on(PNTP)),PNTD),
	palette_db_colors(Win,RCT,_COLOR),
	palette_ScrollingRctColor(Win,RCT,ScrolingRCT),
	ScrolingRCT = rct(XR,YR,X1R,Y1R), 
	X >= XR, Y >= YR, X <= X1R, Y <= Y1R,
	PNTP = pnt(PX,_Py),
	PNTD = pnt(DX,_DY),
	palette_db_ColorInfo(Win,NColors,_,_,_ScrollPos,_),
	Xmax = PX + DX * NColors, Xmin = PX,
	X < Xmax, X > Xmin,
	!.

  palette_send_notification(Win,RCT,mouse_button_right):- % change_PenColor notification
	palette_db_colors(Win,RCT,COLOR),		% on mouse_button_right
	palette_db_ColorInfo(Win,_,_,_,_,Callback),
	palette_db_WinWin(DlgWin,Win),
	not(Callback(DlgWin,change_PenColor(COLOR))),
	retract(palette_db_Prev(Win,_,FillColor,PATSTL,PENSTL,PENW)),
	assert(palette_db_Prev(Win,COLOR,FillColor,PATSTL,PENSTL,PENW)),
	palette_draw_prev(Win),
	!.
  palette_send_notification(Win,RCT,mouse_button_left):-% change_BrushColor notification
	palette_db_colors(Win,RCT,COLOR),		% on mouse_button_left 
	palette_db_ColorInfo(Win,_,_,_,_,Callback),
	palette_db_WinWin(DlgWin,Win),
	not(Callback(DlgWin,change_BrushColor(COLOR))),
	retract(palette_db_Prev(Win,PenColor,_,PATSTL,PENSTL,PENW)),
	assert(palette_db_Prev(Win,PenColor,COLOR,PATSTL,PENSTL,PENW)),
	palette_draw_prev(Win),
	!.
  palette_send_notification(Win,RCT,mouse_button_left):-% change_PEN notification
	palette_db_Pen(Win,RCT,PSTYLE,PWIDTH),
	palette_db_ColorInfo(Win,_,_,_,_,Callback),
	palette_db_WinWin(DlgWin,Win),
	not(Callback(DlgWin,change_PEN(PSTYLE,PWIDTH))),
	retract(palette_db_Prev(Win,PenColor,FillColor,PATSTL,_,_)),
	assert(palette_db_Prev(Win,PenColor,FillColor,PATSTL,PSTYLE,PWIDTH)),
	palette_draw_prev(Win),
	!.
  palette_send_notification(Win,RCT,mouse_button_left):-% change_PATSTYLE notification
	palette_db_Fill(Win,RCT,Pat),
	palette_db_ColorInfo(Win,_,_,_,_,Callback),
	palette_db_WinWin(DlgWin,Win),
	not(Callback(DlgWin,change_PATSTYLE(Pat))),
	retract(palette_db_Prev(Win,PenColor,FillColor,_,PENSTL,PENW)),
	assert(palette_db_Prev(Win,PenColor,FillColor,Pat,PENSTL,PENW)),
	palette_draw_prev(Win),
	!.
  palette_send_notification(_,_,_).

  palette_draw_prev(Win):- % draw preview window
	palette_db_Prev(Win,PenColor,FillColor,PATSTL,PENSTL,PENW),
	palette_db_SetInfo(Win,preview(on(PntPos)),PntDelta),
	PntDelta = pnt(Dx,Dy),
	PntPos = pnt(Px,Py),
	P1x = Px + Dx, P1y = Py + Dy, 
	RctRam = rct(Px,Py,P1x,P1y),
	XPrev = Px + 5 + PENW div 2, YPrev = Py + 5 + PENW div 2,
	X1Prev = P1x - PENW div 2 - PENW mod 2 - 4, Y1Prev = P1y - PENW div 2 - PENW mod 2 - 4, 
	Xc = Px + 5, Yc = Py + 5, Xc1 = P1x - 5, Yc1 = P1y - 5,
	win_Clear(Win,rct(Xc,Yc,Xc1,Yc1),color_White),
	win_SetPen(Win,pen(PENW,PENSTL,PenColor)),
	win_SetBrush(Win,brush(PATSTL,FillColor)),
	draw_Rect(Win,rct(XPrev,YPrev,X1Prev,Y1Prev)),
	palette_draw_preview_frame(Win,RctRam),
	!.
  palette_draw_prev(_):-!.


  palette_draw_preview_frame(Win,Rct):-
	Rct = rct(X,Y,X1,Y1),
	Xx = X + 1, Xx1 = X1 -1, Yy = Y + 1, Yy1 = Y1 - 1,
	win_SetPen(Win,pen(1,ps_Solid,color_Gray)),
	draw_Line(Win,pnt(X,Yy),pnt(X,Y1)),
	draw_Line(Win,pnt(X,Y1),pnt(X1,Y1)),
	draw_Line(Win,pnt(X1,Y1),pnt(X1,Y)),
	win_SetPen(Win,pen(2,ps_Solid,color_Black)),
	draw_Line(Win,pnt(Xx,Yy1),pnt(Xx,Yy)),
	draw_Line(Win,pnt(Xx,Yy),pnt(Xx1,Yy)),
	win_SetPen(Win,pen(2,ps_Solid,color_White)),
	draw_Line(Win,pnt(Xx,Yy1),pnt(Xx1,Yy1)),
	draw_Line(Win,pnt(Xx1,Yy1),pnt(Xx1,Yy)),!.


