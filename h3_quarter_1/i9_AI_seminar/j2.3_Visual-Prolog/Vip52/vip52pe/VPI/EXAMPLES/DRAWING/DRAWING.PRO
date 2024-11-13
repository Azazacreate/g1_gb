/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  DRAWING
 FileName: DRAWING.PRO
 Purpose: Various drawing
 Written by: Illin Yuri
 Comments:
******************************************************************************/

include "drawing.inc"
include "drawing.con"
include "hlptopic.con"

/***************************************************************************
	Layout constants
***************************************************************************/

CONSTANTS
  n_color_choices       = 4

  x_color               = 262
  x_color_label         = 362  /* (x_color + 100) */
  y_color               = 35

  x_width               = 342
  x_width_label         = 375
  y_width               = 260

  x_style               = 262
  x_style_label         = 295
  y_style               = 260

  x_pat                 = 420
  x_pat_label           = 453
  y_pat                 = 10

  x_draw_mode           = 505
  x_draw_mode_label     = 548
  y_draw_mode           = 10

  x_shape               = 20
  y_shape               = 180

  x_bk_mode             = 20
  x_bk_mode_label       = 53
  y_bk_mode             = 300

  obj_width             = 16
  obj_gap1              = 3
  obj_gap2              = 10
  shape_gap             = 6
  shape_gap2            = 12

  types = [t_back_clr, t_fore_clr, t_pen_clr, t_brush_clr, t_brush_pat, t_pen_width, t_pen_style, t_draw_mode, t_bk_mode, t_shape]

  frm_width             = 2

  win_width             = 500
  win_height            = 325

  % view rectangle in which to see sample shape, and rectangle for its frame.
  view = rct(frm_width, frm_width,250, 168 )

  view_frame = rct(0, 0,252, 170 )


/***************************************************************************
	Some overall domain definitions
***************************************************************************/

DOMAINS
  % Types of objects
  Obj_Type =    t_back_clr; t_fore_clr; t_pen_clr; t_brush_clr;
		t_brush_pat; t_pen_width; t_pen_style; t_draw_mode; t_bk_mode; t_shape
  Obj_Types =   Obj_Type*

  % Types of shapes to draw in the view vindow
  Share_Type =  s_line; s_polyline; s_polygon; s_rect; s_roundrect;
		s_oval; s_arc; s_pie; s_text; s_icon
  Shape_Types = Share_Type*

  % Value associated with an object
  Obj_Val =     color(Color); pat(PatStyle);
		width(integer); style(PenStyle); draw_mode(DrawMode); bk_mode(Bk_Mode); shape(Share_Type)

/***************************************************************************
	Definition of database of objects
***************************************************************************/

DATABASE - objects

  % Define all active objects on the screen
  nocopy obj(Obj_Type,RCT,Obj_Val)

  % Contain selected objects
  % Note: does always contain exactly on object of each Obj_Type
  nocopy selected(Obj_Type,RCT,Obj_Val)
  determ user_font(FONT)

/***************************************************************************
	Help function to index in a list
***************************************************************************/
PREDICATES
 index(integer,Shape_Types,Share_Type)

CLAUSES
 index(0,[Shape|_],Shape):-!.
 index(N,[_|R],Shape):-
	N1=N-1,
	index(N1,R,Shape).

/***************************************************************************
	good old 'for' predicate
***************************************************************************/

PREDICATES
  nondeterm for(integer,integer,integer)

CLAUSES
  for(N,N,_).
  for(N,First,Last):-
	Last>First,
	Next=First+1,
	for(N,Next,Last).

/***************************************************************************
	Traditional member predicate
***************************************************************************/

DOMAINS
  Color_List = Color*

PREDICATES
  nondeterm member(integer,ILIST)
  nondeterm member(Color,Color_List)
  nondeterm member(Obj_Type,Obj_Types)

CLAUSES
  member(X,[X|_]).
  member(X,[_|R]):-
	member(X,R).

/***************************************************************************
	Get/Set variable
***************************************************************************/

PREDICATES
  new_var(string)
  get_var(string,integer)
  set_var(string,integer)

CLAUSES
  new_var(Var):-
	str_len(Var,2),
	set_var(Var,0).

  get_var(Var,Val):-
	ptr_dword(Var,Seg,Off),
	memword(Seg,Off,Val).

  set_var(Var,Val):-
	ptr_dword(Var,Seg,Off),
	memword(Seg,Off,Val).

/***************************************************************************
	Function to initialize icon objects.
***************************************************************************/

PREDICATES
  build_objs()
  init_obj(Obj_Type,Obj_Val)

CLAUSES
  build_objs():-
	Colors = [ color_red, color_green, color_blue, color_cyan,
		color_magenta, color_yellow, color_black, color_dkgray,
		color_gray, color_ltgray, color_white],

	new_var(X_Var),
	member(Obj_Type,types),
	  get_var(X_Var,X),X1=X+1, set_var(X_Var,X1),
	  X<4,
	  new_var(Y_Var),
	  member(Color,Colors),
	    get_var(Y_Var,Y),Y1=Y+1, set_var(Y_Var,Y1),
	    Left = x_color + (obj_width + obj_gap2) * X,
	    Top = y_color + (obj_width + obj_gap1) * Y,
	    Right = Left + obj_width,
	    Bottom = Top + obj_width,
	    assert(obj(Obj_Type,rct(Left,Top,Right,Bottom),color(Color))),
	    fail.

  build_objs():-
	new_var(Y_Var),
	member(PAT,[ pat_hollow, pat_solid, pat_horz, pat_vert,
		pat_fdiag, pat_bdiag, pat_cross, pat_diagcross ]),
	  get_var(Y_Var,Y),Y1=Y+1, set_var(Y_Var,Y1),
	  Left = x_pat,
	  Top = y_pat + (obj_width + obj_gap1) * Y,
	  Right = Left + obj_width + obj_gap2,
	  Bottom = Top + obj_width,
	  assert(obj(t_brush_pat,rct(Left,Top,Right,Bottom),pat(PAT))),
	fail.

  build_objs():-
	new_var(Y_Var),
	member(Width,[1, 3, 5, 7/*, -1*/]),
	  get_var(Y_Var,Y),Y1=Y+1, set_var(Y_Var,Y1),
	  Left = x_width,
	  Top = y_width + (obj_width + obj_gap1) * Y,
	  Right = Left + obj_width + obj_gap2,
	  Bottom = Top + obj_width,
	  assert(obj(t_pen_width,rct(Left,Top,Right,Bottom),width(Width))),
	fail.

  build_objs():-
	new_var(Y_Var),
	member(Style,[ ps_Hollow, ps_Solid, ps_Dash, ps_Dot, ps_DashDot, ps_DashDotDot]),
	  get_var(Y_Var,Y),Y1=Y+1, set_var(Y_Var,Y1),
	  Left = x_style,
	  Top = y_style + (obj_width + obj_gap1) * Y,
	  Right = Left + obj_width + obj_gap2,
	  Bottom = Top + obj_width,
	  assert(obj(t_pen_style,rct(Left,Top,Right,Bottom),style(Style))),
	fail.

  build_objs():-
	new_var(Y_Var),
	member(DrawMode,[ dm_Black, dm_NotMergePen, dm_MaskNotPen,
			  dm_NotCopyPen, dm_MaskPenNot, dm_Not,
			  dm_XorPen, dm_NotMaskPen, dm_MaskPen,
			  dm_NotXorPen, dm_Nop, dm_MergeNotPen,
			  dm_CopyPen, dm_MergePenNot, dm_MergePen,
			  dm_White ]),
	  get_var(Y_Var,Y),Y1=Y+1, set_var(Y_Var,Y1),
	  Left = x_draw_mode,
	  Top = y_draw_mode + (obj_width + obj_gap1) * Y,
	  Right = Left + obj_width + obj_gap2,
	  Bottom = Top + obj_width,
	  assert(obj(t_draw_mode,rct(Left,Top,Right,Bottom),draw_mode(DrawMode))),
	fail.

  build_objs():-
	new_var(Y_Var),
	member(Bk_Mode,[ bk_Transparent, bk_Opaque]),
	  get_var(Y_Var,Y),Y1=Y+1, set_var(Y_Var,Y1),
	  Left = x_bk_mode,
	  Top = y_bk_mode + (obj_width + obj_gap1) * Y,
	  Right = Left + obj_width + obj_gap2,
	  Bottom = Top + obj_width,
	  assert(obj(t_bk_mode,rct(Left,Top,Right,Bottom),bk_mode(Bk_Mode))),
	fail.

  build_objs():-
	for(X,0,4),
	  for(Y,0,1),
	    Left = x_shape + X * (2 * obj_width + obj_gap2),
	    Top = y_shape + Y * 2 * (obj_width + obj_gap2),
	    Right = Left + 2 * obj_width,
	    Bottom = Top + 2 * obj_width,
	    Index = X + 5 * Y,
	    index(Index,[ s_line, s_polyline, s_polygon, s_rect,
		s_roundrect, s_oval, s_arc, s_pie, s_text, s_icon],Shape),
	    assert(obj(t_shape,rct(Left,Top,Right,Bottom),shape(Shape))),
	    fail.

  build_objs() :-
	  init_obj(t_back_clr,color(color_Yellow)),
	  init_obj(t_fore_clr,color(color_Magenta)),
	  init_obj(t_pen_clr,color(color_Black)),
	  init_obj(t_brush_clr,color(color_Red)),
	  init_obj(t_brush_pat,pat(pat_Horz)),
	  init_obj(t_pen_width,width(1)),
	  init_obj(t_pen_style,style(ps_Dash)),
	  init_obj(t_draw_mode,draw_mode(dm_CopyPen)),
	  init_obj(t_bk_mode,bk_mode(bk_Opaque)),
	  init_obj(t_shape,shape(s_text)).

  init_obj(Obj_Type,Obj_Val) :-
	  obj(Obj_Type,Rct,Obj_Val),!,
	  assert(selected(Obj_Type,Rct,Obj_Val)).

/***************************************************************************
	Function to draw a string below a rectangle. Used for shape-icon labels.
***************************************************************************/

PREDICATES
  draw_shape_label(WINDOW,RCT,string)

CLAUSES
  draw_shape_label(_Win,rct(Left,_,Right,Bottom),String):-
	Small_Font = font_Create(ff_helvetica,[],8),
	win_setfont(_Win,Small_Font),
	win_getfontmetrics(_Win,_, Ascent, _),
	win_GetTextExtent(_Win,String, -1,W,_),
	X = (Left + Right - W) div 2,
	Y = Bottom + Ascent,
	draw_text(_Win, X, Y, String, -1).

/***************************************************************************
	Function to draw a shape-choosing icon.
***************************************************************************/

PREDICATES
  draw_shape_icon(WINDOW,Share_Type,RCT)

CLAUSES
  draw_shape_icon(_Win,_,_):-
	win_setbrush(_Win,brush(pat_solid,color_ltgray)),
	fail.

  draw_shape_icon(_Win,s_line,Rct):-
	Rct = rct(Left,Top,Right,Bottom),
	H1 = Left + shape_gap,
	V1 = Bottom - shape_gap,
	H2 = Right - shape_gap,
	V2 = Top + shape_gap,
	draw_line(_Win,pnt(H1,V1),pnt(H2,V2)),
	draw_shape_label(_Win,Rct, "Line").

  draw_shape_icon(_Win,s_polyline,Rct):-
	Rct = rct(Left,Top,Right,Bottom),
	H1 = Left + shape_gap,
	V1 = Bottom - shape_gap,
	H2 = (Left + Right) div 2,
	V2 = Top + shape_gap,
	H3 = Right - shape_gap,
	V3 = (Top + Bottom) div 2,
	draw_polyline(_Win,[pnt(H1,V1),pnt(H2,V2),pnt(H3,V3)]),
	draw_shape_label(_Win,Rct, "Polyln").

  draw_shape_icon(_Win,s_polygon,Rct):-
	Rct = rct(Left,Top,Right,Bottom),
	H1 = Left + shape_gap,
	V1 = Bottom - shape_gap,
	H2 = (Left + Right) div 2,
	V2 = Top + shape_gap,
	H3 = Right - shape_gap,
	V3 = (Top + Bottom) div 2,
	draw_polygon(_Win,[pnt(H1,V1),pnt(H2,V2),pnt(H3,V3)]),
	draw_shape_label(_Win,Rct, "Polygn").

  draw_shape_icon(_Win,s_rect,Rct):-
	Rct = rct(Left,Top,Right,Bottom),
	Left1 = Left + shape_gap,
	Top1 = Top + shape_gap,
	Right1 = Right - shape_gap,
	Bottom1 = Bottom - shape_gap,
	draw_rect(_Win,rct(Left1,Top1,Right1,Bottom1)),
	draw_shape_label(_Win, Rct, "Rect"),
	X0 = ( 3 * Left1 + Right1 ) / 4,
	X1 = ( Left1 + 3 * Right1 ) / 4,
	Y0 = ( 7 * Top1 + Bottom1 ) / 8,
	Y1 = ( Top1 + Bottom1 ) / 2,
	Y2 = ( Top1 + 7 * Bottom1 ) / 8,
	draw_polyline(_Win,[pnt(X0,Y1),pnt(X1,Y0),pnt(X0,Y2),pnt(X1,Y1)]).

  draw_shape_icon(_Win,s_roundrect,Rct):-
	Rct = rct(Left,Top,Right,Bottom),
	Left1 = Left + shape_gap,
	Top1 = Top + shape_gap,
	Right1 = Right - shape_gap,
	Bottom1 = Bottom - shape_gap,
	Oval_Width  = 2 * shape_gap,
	Oval_Height = 2 * shape_gap,
	draw_roundrect(_Win,rct(Left1,Top1,Right1,Bottom1), Oval_Width, Oval_Height),
	draw_shape_label(_Win,Rct, "RndRct").

  draw_shape_icon(_Win,s_oval,Rct):-
	Rct = rct(Left,Top,Right,Bottom),
	Left1 = Left + shape_gap,
	Top1 = Top + shape_gap,
	Right1 = Right - shape_gap,
	Bottom1 = Bottom - shape_gap,
	draw_Ellipse(_Win,rct(Left1,Top1,Right1,Bottom1)),
	draw_shape_label(_Win, Rct, "Oval").

  draw_shape_icon(_Win,s_arc,Rct):-
	Rct = rct(Left,Top,Right,Bottom),
	Left1 = Left - shape_gap,
	Top1 = Top + shape_gap,
	Right1 = Right - shape_gap,
	Bottom1 = Bottom + shape_gap,
	Start_Y = (Top + Bottom) div 2,
	Stop_X = Left + shape_gap,
	draw_arc(_Win,rct(Left1,Top1,Right1,Bottom1), Right, Start_Y,Stop_X, Top),
	draw_shape_label(_Win,Rct, "Arc").

  draw_shape_icon(_Win,s_pie,Rct):-
	Rct = rct(Left,Top,Right,Bottom),
	Left1 = Left - shape_gap,
	Top1 = Top + shape_gap,
	Right1 = Right - shape_gap,
	Bottom1 = Bottom + shape_gap,
	Start_Y = (Top + Bottom) div 2,
	Stop_X = Left + shape_gap,
	draw_pie(_Win,rct(Left1,Top1,Right1,Bottom1), Right, Start_Y, Stop_X, Top),
	draw_shape_label(_Win,Rct, "Pie").

  draw_shape_icon(_Win,s_text,Rct):-
	Rct = rct(Left,Top,Right,Bottom),
	Normal_Font = font_Create(ff_helvetica,[],12),
	win_setfont(_Win,Normal_Font),
	win_getfontmetrics(_Win,_, _, Descent),
	win_GetTextExtent(_Win,"PDC", -1,W,_),
	X = (Left + Right - W) div 2,
	Y = (Top + Bottom) div 2 + Descent,
	draw_text(_Win, X, Y, "PDC", -1),
	draw_shape_label(_Win, Rct, "Text").

  draw_shape_icon(_Win,s_icon,Rct):-
	Rct = rct(Left,Top,_,_),
	draw_icon(_Win, Left, Top, 9012),
	draw_shape_label(_Win,Rct, "Icon").



/***************************************************************************
	Function to show selected icon by inverting thick frame around it.
***************************************************************************/

PREDICATES
  invert_selection_frame(WINDOW,RCT)

CLAUSES
  invert_selection_frame(_Win,rct(Left,Top,Right,Bottom)):-
	Save_Tools = win_getdrawtools(_Win),
	Draw_CTools = win_GetDefaultDrawTools(),
	Draw_CTools = draw_tools(CPen,CBrush,_,Font,FCol,BCol,Text),
	CPen = pen(_,Pen_Style,Pen_Color),
	CBrush = brush(_,Brush_Color),

	win_setdrawtools(_Win,draw_tools(
		pen(frm_width,Pen_Style,Pen_Color),
		brush(pat_hollow,Brush_Color),
		dm_Not,Font,FCol, BCol, Text)),

	Left1 = Left -frm_width,
	Top1 = Top - frm_width,
	Right1 = Right + frm_width,
	Bottom1 = Bottom + frm_width,
	draw_rect(_Win,rct(Left1,Top1,Right1,Bottom1)),
	win_setdrawtools(_Win,Save_Tools).

/***************************************************************************
	Function to invert icon (vs. its frame, see previous function).
	Used to provide feedback while user is clicking mouse.
***************************************************************************/

PREDICATES
  invert_obj(WINDOW,RCT)

CLAUSES
  invert_obj(_Win,Rct):-
	Save_Tools = win_getdrawtools(_Win),
	Draw_CTools = win_GetDefaultDrawTools(),

	Draw_CTools = draw_tools(CPen,_,_,Font,FCol,BCol,Text),
	CPen = pen(Pen_Width,Pen_Style,Pen_Color),

	win_setdrawtools(_Win,draw_tools(
		pen(Pen_Width,Pen_Style,Pen_Color),
		brush(pat_solid,color_black),
		dm_XorPen,Font,FCol, BCol, Text)),

	draw_rect(_Win,Rct),
	win_setdrawtools(_Win,Save_Tools).

/***************************************************************************
	Function to draw all object icons. Called in response to update events.
***************************************************************************/

PREDICATES
  show_objs(WINDOW)
  show_obj(WINDOW,RCT,Obj_Val,PEN,BRUSH)
  mk_labels(WINDOW,SLIST, integer, integer, integer, integer)

CLAUSES
  mk_labels(_,[], _, _, _, _).
  mk_labels(_Win,[S|R], X_Pos, X_Step, Y_Pos, Y_Step):-
	draw_text(_Win,X_Pos, Y_Pos, S, -1 ),
	X_Pos1= X_Pos+X_Step,
	Y_Pos1= Y_Pos+Y_Step,
	mk_labels( _Win, R, X_Pos1, X_Step, Y_Pos1, Y_Step).


  show_objs(_Win):-
	Color_Labels = ["Red", "Green", "Blue", "Cyan", "Magnta", "Yellow", "Black", "DkGry", "Gray", "LtGry", "White"],

	Choice_Labels = ["Bak", "For", "Pen", "Brs"],

	Pat_Labels = ["Hollow", "Solid", "Horz", "Vert", "FDiag", "Bdiag", "Cross", "DgCrss"],

	Width_Labels = ["1 Pixl", "3 Pixls", "5 Pixls", "7 Pixls"],

	Style_Labels = [ "Hollow","Solid", "Dash", "Dot", "DashDot", "DashDotDot"],

	Draw_Mode_Labels = [ "Black", "NotMergePen", "MaskNotPen",
			  "NotCopyPen", "MaskPenNot", "Not",
			  "XorPen", "NotMaskPen", "MaskPen",
			  "NotXorPen", "Nop", "MergeNotPen",
			  "CopyPen", "MergePenNot", "MergePen",
			  "White" ],

	Bk_Mode_Labels = [ "Transparent", "Opaque"],

	Normal_CTools = win_GetDefaultDrawTools(),
	win_setdrawtools(_Win,Normal_CTools),

	Small_Font = font_Create(ff_helvetica,[],8),
	win_setfont(_Win,Small_Font),
	win_getfontmetrics(_Win,Leading, Ascent, Descent),

	Y1_Start = y_color + Leading + Ascent,
	Y1_Size = obj_width + obj_gap1,
	mk_labels(_Win,Color_Labels, x_color_label, 0, Y1_Start, Y1_Size),

	X2_Size = obj_width + obj_gap2,
	Y2_Start = y_color - obj_gap1 - Descent,
	mk_labels(_Win,Choice_Labels, x_color, X2_Size, Y2_Start, 0),

	Y3_Start = y_pat + Leading + Ascent,
	Y3_Size = obj_width + obj_gap1,
	mk_labels(_Win,Pat_Labels, x_pat_label, 0, Y3_Start, Y3_Size),

	Y4_Start = y_width + Leading + Ascent,
	Y4_Size = obj_width + obj_gap1,
	mk_labels(_Win,Width_Labels, x_width_label, 0, Y4_Start, Y4_Size),

	Y5_Start = y_style + Leading + Ascent,
	Y5_Size = obj_width + obj_gap1,
	mk_labels(_Win,Style_Labels, x_style_label, 0, Y5_Start, Y5_Size),

	Y6_Start = y_draw_mode + Leading + Ascent,
	Y6_Size = obj_width + obj_gap1,
	mk_labels(_Win,Draw_Mode_Labels, x_draw_mode_label, 0, Y6_Start, Y6_Size),

	Y7_Start = y_bk_mode + Leading + Ascent,
	Y7_Size = obj_width + obj_gap1,
	mk_labels(_Win,Bk_Mode_Labels, x_bk_mode_label, 0, Y7_Start, Y7_Size),
	fail.

  show_objs(_Win):-
	Normal_CTools = win_GetDefaultDrawTools(),
	Normal_CTools = draw_tools(CPen,CBrush,_,_,_,_,_),
	CPen = pen(_,Pen_Style,Pen_Color),

	obj(_,Rct,Obj_Val),
	  win_NeedsUpdate(_Win,Rct),
	  win_setdrawtools(_Win,Normal_CTools),
	  show_obj(_Win,Rct,Obj_Val,CPen,CBrush),
	  win_setpen(_Win,pen(1,Pen_Style,Pen_Color)),
	  draw_rect(_Win,Rct),
	fail.

  show_objs(_Win):-
	selected(_,Rct,_),
	invert_selection_frame(_Win,Rct),
	fail.

  show_objs(_).


  show_obj(_Win,_,color(Color),_,brush(Style,_)):-
	win_setbrush(_Win,brush(Style,Color)).

  show_obj(_Win,_,pat(Pat_Style),_,_):-
	win_setbrush(_Win,brush(Pat_Style,color_black)).

  show_obj(_Win,rct(Left,Top,Right,Bottom),width(Width),
		pen(_,Pen_Style,Pen_Color),brush(_,Brush_Color)):-
	win_setbrush(_Win,brush(pat_hollow,Brush_Color)),
	win_setpen(_Win,pen(Width,Pen_Style,Pen_Color)),
	H1 = Left + obj_gap1,
	V = (Top + Bottom) div 2,
	H2 = Right - obj_gap1,
	draw_line(_Win,pnt(H1,V),pnt(H2,V)).

  show_obj(_Win,rct(Left,Top,Right,Bottom),style(Pen_Style),
		pen(_,_,Pen_Color),brush(_,Brush_Color)):-
	win_setbrush(_Win,brush(pat_hollow,Brush_Color)),
	win_setpen(_Win,pen(1,Pen_Style,Pen_Color)),
	H1 = Left + obj_gap1,
	V = (Top + Bottom) div 2,
	H2 = Right - obj_gap1,
	draw_line(_Win,pnt(H1,V),pnt(H2,V)).

  show_obj(_Win,rct(L,T,R,B),draw_mode(DrawMode),_,_):-
	H = ( L + R ) / 2,
	H1 = L + obj_gap1,
	H2 = H - 1,
	H3 = H + 1,
	H4 = R - obj_gap1,
	V = ( T + B ) / 2,
	V1 = T + obj_gap1,
	V2 = V - 1,
	V3 = V + 1,
	V4 = B - obj_gap1,

	ColorA = color_Black,
	ColorB = color_White,

	win_SetPen(_Win,pen(1,ps_Solid,ColorA)),
	win_SetBrush(_Win,brush(pat_Solid,ColorA)),
	draw_rect(_Win,rct(H1,V1,H2,V2)),
	draw_rect(_Win,rct(H3,V1,H4,V2)),

	win_SetPen(_Win,pen(1,ps_Solid,ColorB)),
	win_SetBrush(_Win,brush(pat_Solid,ColorB)),
	draw_rect(_Win,rct(H1,V3,H2,V4)),
	draw_rect(_Win,rct(H3,V3,H4,V4)),

	Old_DrawMode = win_GetDrawMode(_Win),
	win_SetDrawMode(_Win,DrawMode),

	win_SetPen(_Win,pen(1,ps_Solid,ColorA)),
	win_SetBrush(_Win,brush(pat_Solid,ColorA)),
	draw_rect(_Win,rct(H1,V1,H2,V2)),
	draw_rect(_Win,rct(H1,V3,H2,V4)),

	win_SetPen(_Win,pen(1,ps_Solid,ColorB)),
	win_SetBrush(_Win,brush(pat_Solid,ColorB)),
	draw_rect(_Win,rct(H3,V1,H4,V2)),
	draw_rect(_Win,rct(H3,V3,H4,V4)),

	win_SetDrawMode(_Win,Old_DrawMode),
	win_SetPen(_Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(_Win,brush(pat_Hollow,color_White)).

  show_obj(_,_,bk_mode(_),_,_):- !.

  show_obj(_Win,Rct,shape(Share_Type),_,brush(_,Brush_Color)):-
	draw_shape_icon(_Win,Share_Type,Rct),
	win_setbrush(_Win,brush(pat_hollow,Brush_Color)).

/***************************************************************************
  Update view area
***************************************************************************/

PREDICATES
  show_view_shape(WINDOW,Share_Type,RCT)

CLAUSES
  show_view_shape(_Win,s_line,rct(V_Left,V_Top,V_Right,V_Bottom)):-
	Ver=V_Bottom-shape_gap2,
	Hor=V_Left + shape_gap2,
	Hor1=V_Right - shape_gap2,
	Ver1 = V_Top + shape_gap2,
	draw_line(_Win,pnt(Hor,Ver),pnt(Hor1,Ver1)).

  show_view_shape(_Win,s_polyline,rct(V_Left,V_Top,V_Right,V_Bottom)):-
	Hor0 = V_Left + shape_gap2,
	Ver0 = V_Bottom - shape_gap2,
	Hor1 = (V_Left + V_Right) div 2,
	Ver1 = V_Top + shape_gap2,
	Hor2 = V_Right - shape_gap2,
	Ver2 = (V_Top + V_Bottom) div 2,
	draw_polyline(_Win,[pnt(Hor0,Ver0),pnt(Hor1,Ver1),pnt(Hor2,Ver2)]).

  show_view_shape(_Win,s_polygon,rct(V_Left,V_Top,V_Right,V_Bottom)):-
	Hor0 = V_Left + shape_gap2,
	Ver0 = V_Bottom - shape_gap2,
	Hor1 = (V_Left + V_Right) div 2,
	Ver1 = V_Top + shape_gap2,
	Hor2 = V_Right - shape_gap2,
	Ver2 = (V_Top + V_Bottom) div 2,
	draw_polygon(_Win,[pnt(Hor0,Ver0),pnt(Hor1,Ver1),pnt(Hor2,Ver2)]).

  show_view_shape(_Win,s_rect,rct(V_Left,V_Top,V_Right,V_Bottom)):-
	R_Left = V_Left + shape_gap2,
	R_Top = V_Top + shape_gap2,
	R_Right = V_Right - shape_gap2,
	R_Bottom = V_Bottom - shape_gap2,
	draw_rect(_Win,rct(R_Left,R_Top,R_Right,R_Bottom)),
	Pen = win_GetPen(_Win),
	Pen = pen(_,Style,Color),
	win_SetPen(_Win,pen(3,Style,Color)),
	X0 = ( 3 * R_Left + R_Right ) / 4,
	X1 = ( R_Left + 3 * R_Right ) / 4,
	Y0 = ( 7 * R_Top + R_Bottom ) / 8,
	Y1 = ( R_Top + R_Bottom ) / 2,
	Y2 = ( R_Top + 7 * R_Bottom ) / 8,
	draw_polyline(_Win,[pnt(X0,Y1),pnt(X1,Y0),pnt(X0,Y2),pnt(X1,Y1)]).

  show_view_shape(_Win,s_roundrect,rct(V_Left,V_Top,V_Right,V_Bottom)):-
	R_Left = V_Left + shape_gap2,
	R_Top = V_Top + shape_gap2,
	R_Right = V_Right - shape_gap2,
	R_Bottom = V_Bottom - shape_gap2,
	Oval_Width = 2 * shape_gap2, Oval_Height = 2 * shape_gap2,
	draw_roundrect(_Win,rct(R_Left,R_Top,R_Right,R_Bottom),Oval_Width,Oval_Height).

  show_view_shape(_Win,s_oval,rct(V_Left,V_Top,V_Right,V_Bottom)):-
	R_Left = V_Left + shape_gap2,
	R_Top = V_Top + shape_gap2,
	R_Right = V_Right - shape_gap2,
	R_Bottom = V_Bottom - shape_gap2,
	draw_Ellipse(_Win,rct(R_Left,R_Top,R_Right,R_Bottom)).

  show_view_shape(_Win,s_arc,rct(V_Left,V_Top,V_Right,V_Bottom)):-
	R_Left = V_Left + shape_gap2,
	R_Top = V_Top + shape_gap2,
	R_Right = V_Right - shape_gap2,
	R_Bottom = V_Bottom - shape_gap2,
	Start_X = V_Right, Start_Y = (V_Top + V_Bottom) div 2,
	Stop_X = V_Left, Stop_Y = V_Top,
	draw_arc(_Win,rct(R_Left,R_Top,R_Right,R_Bottom),Start_X,Start_Y,Stop_X,Stop_Y).

  show_view_shape(_Win,s_pie,rct(V_Left,V_Top,V_Right,V_Bottom)):-
	R_Left = V_Left + shape_gap2,
	R_Top = V_Top + shape_gap2,
	R_Right = V_Right - shape_gap2,
	R_Bottom = V_Bottom - shape_gap2,
	Start_X = V_Right, Start_Y = (V_Top + V_Bottom) div 2,
	Stop_X = V_Left + shape_gap2, Stop_Y = V_Top,
	draw_pie(_Win,rct(R_Left,R_Top,R_Right,R_Bottom),Start_X,Start_Y,Stop_X,Stop_Y).

  show_view_shape(_Win,s_text,rct(V_Left,V_Top,V_Right,V_Bottom)):-
	user_font(User_Font),
	win_setfont(_Win,User_Font),
	win_getfontmetrics(_Win,_,_,Descent),
	win_GetTextExtent(_Win,"PDC",-1,W,H),
	X = (V_Left + V_Right - W) div 2,
	Y = (V_Top + V_Bottom) div 2 + Descent,
	L = (3 * V_Left + V_Right - W) div 4,
	R = (V_Left + 3 * V_Right + W) div 4,
	T = (3 * V_Top + V_Bottom - H) div 4,
	B = (V_Top + 3 * V_Bottom + H) div 4,
	draw_rect(_Win,rct(L,T,R,B)),
	draw_text(_Win,X,Y,"PDC",-1).

  show_view_shape(_Win,s_icon,rct(V_Left,V_Top,_,_)):-
	X = V_Left + 50, Y = V_Top + 50,
	draw_icon(_Win,X, Y, 9012).

/***************************************************************************
	Update view area
***************************************************************************/

PREDICATES
  show_view(WINDOW)

CLAUSES
  show_view(_Win):-
	Draw_CTools = win_GetDefaultDrawTools(),
	Draw_CTools = draw_tools(CPen,CBrush,Draw_Mode,Font,FCol,BCol,Opaque),
	CPen = pen(Pen_Width,Pen_Style,Pen_Color),
	CBrush = brush(Brush_Pat,Brush_Color),

	win_setdrawtools(_Win,draw_tools(
		pen(Pen_Width,Pen_Style,Pen_Color),
		brush(Brush_Pat,Brush_Color),
		Draw_Mode,Font,FCol,BCol,Opaque)),
	draw_rect(_Win,view),

	% Get actual selected values
	selected(t_back_clr,_,color(Sel_Back_Color)),
	selected(t_fore_clr,_,color(Sel_Fore_Color)),
	selected(t_pen_clr,_,color(Sel_Pen_Color)),
	selected(t_brush_clr,_,color(Sel_Brush_Color)),
	selected(t_brush_pat,_,pat(Sel_Brush_Pat)),
	selected(t_pen_width,_,width(Sel_Pen_Width)),
	selected(t_pen_style,_,style(Sel_Pen_Style)),
	selected(t_draw_mode,_,draw_mode(Sel_Draw_Mode)),
	selected(t_bk_mode,_,bk_mode(Sel_Bk_Mode)),
	selected(t_shape,_,shape(Sel_Share)),!,

	% Set new values
	win_setdrawtools(_Win,draw_tools(
		pen(Sel_Pen_Width,Sel_Pen_Style,Sel_Pen_Color),
		brush(Sel_Brush_Pat,Sel_Brush_Color),
		Sel_Draw_Mode,Font,Sel_Fore_Color,Sel_Back_Color,Sel_Bk_Mode)),

	% and now show the shape
	show_view_shape(_Win,Sel_Share,view).

/***************************************************************************
	Function to show new selection. Must invert current selection of object
	of same type (to restore appearance), and then invert new selection.
***************************************************************************/

PREDICATES
  new_selection(WINDOW,Obj_Type,RCT,Obj_Val)

CLAUSES
  new_selection(_Win,Obj_Type,New_Rct,NewVal):-
	selected(Obj_Type,Old_Rct,_),
	invert_selection_frame(_Win,Old_Rct),
	retract(selected(Obj_Type,_,_)),!,
	invert_selection_frame(_Win,New_Rct),
	assert(selected(Obj_Type,New_Rct,NewVal)),
	show_view(_Win).


/***************************************************************************
	Function to handle update events.
***************************************************************************/

PREDICATES
  do_update(WINDOW)

CLAUSES
  do_update(_Win):-
	Draw_CTools = win_GetDefaultDrawTools(),
	Draw_CTools = draw_tools(CPen,CBrush,Draw_Mode,Font,FCol,BCol,Opaque),
	CPen = pen(Pen_Width,Pen_Style,Pen_Color),
	CBrush = brush(Brush_Pat,Brush_Color),

	win_setdrawtools(_Win,draw_tools(
		pen(Pen_Width,Pen_Style,Pen_Color),
		brush(Brush_Pat,Brush_Color),
		Draw_Mode,Font,FCol, BCol, Opaque)),
	win_setpen(_Win,pen(2,Pen_Style,Pen_Color)),
	win_NeedsUpdate(_Win, view_frame),
	draw_Rect(_Win,view_frame),
	show_view(_Win),
	fail.

  do_update(_Win):-
	show_objs(_Win).


/***************************************************************************
	Function to find object where mouse is, if any.
***************************************************************************/

PREDICATES
  obj_hit(PNT,RCT)

CLAUSES
  obj_hit(Pnt,Rct):-
	obj(_,Rct,_),
	rect_PntInside(Rct,Pnt),!.


/***************************************************************************
	Event handling for the std window
***************************************************************************/

DATABASE - eventstate
  determ mouse_down
  nocopy determ inverted(RCT)

PREDICATES
  handle_down_event(WINDOW,PNT)

CLAUSES
  handle_down_event(_Win,Where):-
	win_CaptureMouse(_Win),
	obj_hit(Where,Rct),
	invert_obj(_Win,Rct),
	retractall(inverted(_)),
	retractall(mouse_down),
	assert(inverted(Rct)),
	assert(mouse_down).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:26:06-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_Maximized]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Drawing"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 18:26:06-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	build_objs(),
	Normal_Font = font_Create(ff_Helvetica,[],36),
	assert(user_font(Normal_Font)),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("drawing.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	win_Destroy(_Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, id_font
  task_win_eh(_Win,e_Menu(id_font,_ShiftCtlAlt),0):-
	user_font(Font), !,
	Fnt = dlg_ChooseFont(Font),
	win_SetFont(_Win,Fnt),
	retractall(user_font(_)),
	assert(user_font(Fnt)),
	show_view(_Win),
	!.
  task_win_eh(_Win,e_Menu(id_font,_ShiftCtlAlt),0):-!,
	Font = win_GetFont(_Win),
	Fnt = dlg_ChooseFont(Font),
	win_SetFont(_Win,Fnt),
	retractall(user_font(_)),
	assert(user_font(Fnt)),
	show_view(_Win),
	!.
%END Task Window, id_font
%BEGIN Task Window, e_MouseUp
  task_win_eh(_Win,e_MouseUp(_PNT,_ShiftCtlAlt,_Button),0):-!,
	win_ReleaseMouse(),
	inverted(Down_Rct),
	invert_obj(_Win,Down_Rct),
	obj(Obj_Type,Down_Rct,Val),
	new_selection(_Win,Obj_Type,Down_Rct,Val),
	fail
      ;
	retractall(_,eventstate),!.
%END Task Window, e_MouseUp
%BEGIN Task Window, e_MouseMove
  task_win_eh(_Win,e_MouseMove(Where,_ShiftCtlAlt,_Button),0):-!,
	mouse_down,
	not(inverted(_)),
	obj_hit(Where,New_Rct),
	assert(inverted(New_Rct)),
	invert_obj(_Win,New_Rct),!
      ;
	mouse_down,
	obj_hit(Where,Rct),
	inverted(Rct),!
      ;
	mouse_down,
	obj_hit(Where,New_Rct),
	inverted(Old_Rct),
	invert_obj(_Win,Old_Rct),
	retract(inverted(_)),
	assert(inverted(New_Rct)),
	invert_obj(_Win,New_Rct),!
      ;
	mouse_down,
	inverted(Old_Rct),
	invert_obj(_Win,Old_Rct),
	!,retract(inverted(_))
      ;
	mouse_down,
	!,retract(inverted(_)).
%END Task Window, e_MouseMove
%BEGIN Task Window, e_MouseDown
	task_win_eh(_Win,e_MouseDown(Where,_ShiftCtlAlt,_Button),0):-!,
	handle_down_event(_Win,Where),!.
%END Task Window, e_MouseDown
%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(UpdateRect),0):-!,
	DrawTools = win_GetDrawTools ( _Win ),
	win_SetPen ( _Win, pen ( 1, ps_Solid, color_White ) ),
	win_SetBrush ( _Win ,brush ( pat_Solid, color_White ) ),
	win_SetDrawMode(_Win,dm_CopyPen ),
	draw_Rect ( _Win, UpdateRect ),
	win_SetDrawTools ( _Win, DrawTools ),
	do_update(_Win).
%END Task Window, e_Update
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

  task_win_eh(_,_,0):-fail.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"drawing",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 18:26:02-23.11.1999, Code automatically updated!
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









