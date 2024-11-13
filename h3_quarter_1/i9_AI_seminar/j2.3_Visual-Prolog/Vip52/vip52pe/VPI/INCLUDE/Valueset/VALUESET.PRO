/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

			VISUAL Prpolog

 FileName: VALUESET.PRO
 PURPOSE: Valueset object
 Written by: Yuri Illin
 Comments:

******************************************************************************/
ifndef error_con_included
 #Error: this file requires include: error.con
enddef
ifndef valueset_con_included 
 #Error: this file requires include: valueset.con
enddef 
ifndef valueset_pre_included
 #Error: this file requires include: valueset.pre
enddef 

database - valueset_db

  vs_info( WINDOW, 
           INTEGER Row,% number of rows
           INTEGER Col,% number of columns
           INTEGER Dx, % horizontal space between items 
           INTEGER Dy, % vertical space between items 
           INTEGER,    % horizontal size of items 
           INTEGER,    % vertical size of items 
           EHANDLER )

  vs_selected( WINDOW,
    	   INTEGER Id) % identifier of selected item

  vs_items( WINDOW,
    	   INTEGER Row,        % row number of selected item
    	   INTEGER Col,        % column number of selected item
    	   INTEGER Id,         % identifier of item
    	   VALSET_VALUE,       % value of item  
    	   VALSET_PAINT_INFO)  % how need to paint
    	  
determ  vs_focus( Window )
determ  vs_index( INTEGER, INTEGER )

predicates
  valueset_eh : EHANDLER
determ  RCT get_item_rct( WINDOW, INTEGER Id )
procedure  get_size_xy( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER ) % (i,i,i,i,i,o,o)
procedure  create_ctrls( WINDOW, INTEGER, INTEGER, VALSET_CTRL_LIST)
procedure  get_new_index( INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
procedure  draw_selected( Window, RCT, BOOLEAN IsSelected )
procedure  draw_focus( Window, RCT, BOOLEAN IsFocus )
procedure  redraw_selection(Window,RCT Old, RCT New)
procedure  update(Window,RCT)
determ  INTEGER get_item_id_by_pnt( Window, PNT )
determ  draw_item(WINDOW,INTEGER,RCT,VALSET_VALUE,VALSET_PAINT_INFO)
determ  is_char_activate(INTEGER)
procedure  vs_bound_free(VALSET_VALUE)
procedure  vs_bound_free1(INTEGER)

clauses

  valueset_CreateSubClass( Win, Row, Col, VALSET_CTRL_LIST ):-
	Eh = win_GetHandler( Win ),
        get_size_xy( WIN, Row, Col, 0, 0, Sx, Sy ),
	assert(vs_info( WIN, Row, Col, 0, 0, Sx, Sy, Eh )),
	win_SetHandler( Win, valueset_eh ),
	assert( vs_index( 1, 1 )),
	create_ctrls( WIN, Row, Col, VALSET_CTRL_LIST),
	retractall( vs_index( _, _ )),
	!.
  
  valueset_Item( WIN, Id, Val ):-
  	bound(Val),
  	retract(vs_items( WIN, X, Y, Id, _, Pi)),
  	assert(vs_items( WIN, X, Y, Id, Val, Pi )),
  	RCT = get_item_rct( WIN, Id ),
	win_Invalidate(Win,RCT),!. 
  valueset_Item( WIN, Id, Val ):-
  	free(Val),
  	vs_items( WIN, _, _, Id, Val, _ ),
  	!. 
  valueset_Item( WIN, _, Val ):-
  	vs_bound_free(Val),
  	vs_items( WIN, _, _, _, _, _),
  	!,
  	errorexit( error_vpi_package_bad_identifier ).
  valueset_Item( _, _, Val ):-
  	vs_bound_free(Val),
  	errorexit( error_vpi_package_bad_window ).
  	
  valueset_SetItem( WIN, Row, Col, Id, Val, Pi ):-
  	retractall(vs_items( WIN, Row, Col, _, _, _)),
  	assert(vs_items( WIN, Row, Col, Id, Val, Pi )),
  	RCT = get_item_rct( WIN, Id ),
	win_Invalidate(Win,RCT),
	!. 
  valueset_SetItem( _, _, _, _, _, _):-
  	errorexit( ). %internal error. 

  valueset_SelectItem( WIN, Id ):-
  	bound(Id),
        valueset_SelectItem( WIN, OldId ),
        OldId = Id, 
        !.
  valueset_SelectItem( WIN, Id ):-
  	bound(Id), 
  	vs_items( WIN, _, _, Id, _, _ ),
        valueset_SelectItem( WIN, OldId ),
  	OldRCT = get_item_rct( WIN, OldId ),
  	RCT = get_item_rct( WIN, Id ),
  	retractall(vs_selected( Win, _ )),
  	assert(vs_selected( Win, Id )),
	redraw_selection( Win, OldRCT, RCT ),
	DlgWin = win_GetParent( Win ),
	win_SendEvent( DlgWin, e_Control( Id, wc_Custom, Win, selchanged() )),
	!.
  valueset_SelectItem( WIN, Id ):-
  	free(Id),
  	vs_selected( Win, Id ),
  	!.
  valueset_SelectItem( WIN, Id ):-
  	free(Id),
  	vs_items( WIN, 1, 1, Id, _, _ ),
  	!. 
  valueset_SelectItem( WIN, Id ):-
  	bound(Id), 
  	not(vs_items( WIN, _, _, Id, _, _ )),
  	!,
  	errorexit( error_vpi_package_bad_identifier ). 
  valueset_SelectItem( _, Id ):-
  	vs_bound_free1(Id),
  	errorexit( error_vpi_package_bad_window ). 

  valueset_SetPaint( WIN, Id, Pi ):-
  	retract(vs_items( WIN, X, Y, Id, Val, _ )),
  	!,
  	assert(vs_items( WIN, X, Y, Id, Val, Pi )). 
  valueset_SetPaint( WIN, _, _ ):-
  	vs_items( WIN, _, _, _, _, _ ),!,
  	errorexit( error_vpi_package_bad_identifier ).
  valueset_SetPaint( _, _, _ ):-
  	errorexit( error_vpi_package_bad_window ).
  	

  valueset_Attributes( WIN, Row, Col, Dx, Dy ):-
  	bound(Row), bound(Col), bound(Dx), bound(Dy), 
        get_size_xy( WIN, Row, Col, Dx, Dy, Sx, Sy ),
	retract(vs_info( WIN, _, _, _, _, _, _, Eh )),
	assert(vs_info( WIN, Row, Col, Dx, Dy, Sx, Sy, Eh )),
	win_Invalidate(Win),
	!.
  valueset_Attributes( WIN, Row, Col, Dx, Dy):-
  	free(Row), free(Col), free(Dx), free(Dy), 
	vs_info( WIN, Row, Col, Dx, Dy, _, _, _ ),
	!.
  valueset_Attributes( _, Row, Col, Dx, Dy):-
  	vs_bound_free1(Row),
  	vs_bound_free1(Col),
  	vs_bound_free1(Dx),
  	vs_bound_free1(Dy),
  	errorexit( error_vpi_package_bad_window ).
             
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%+++++++++ clauses for local predicates +++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%++ event handler for valueset subclass
  valueset_eh(Win,e_destroy,0):-
  	!,
	vs_info( WIN, _, _, _, _, _, _, Eh ),
	retractall( vs_info( WIN, _, _, _, _, _, _, _ )),
	retractall( vs_selected( WIN, _ )),
	retractall( vs_items( WIN, _, _, _, _, _ )),
	Eh( Win, e_destroy ),
	!.

  valueset_eh(Win,e_update(Rct),0):-
  	!,
  	update(Win,RCT),
	!.
  valueset_eh(Win,Event,Val):-
	vs_info( WIN, _, _, _, _, _, _, Eh ),
	Val = Eh( Win, Event ),
	!.
  valueset_eh(Win,e_MouseDown(PNT,_,0),0):-
  	!,
	Id = get_item_id_by_pnt( Win, PNT ),
        valueset_SelectItem( WIN, Id ),
        !.
  valueset_eh(Win,e_MouseDbl(PNT,_,0),0):-
  	!,
	Id = get_item_id_by_pnt( Win, PNT ),
	DlgWin = win_GetParent( Win ),
	win_SendEvent( DlgWin, e_Control( Id, wc_Custom, Win, activated() )),
	!.
  valueset_eh(Win, e_Char( Ch, _ ), 0):-
  	is_char_activate(Ch),
  	!,
        valueset_SelectItem( WIN, Id ),
	DlgWin = win_GetParent( Win ),
	win_SendEvent( DlgWin, e_Control( Id, wc_Custom, Win, activated() )),
	!.
  valueset_eh(Win, e_Char( k_left, _ ),0):-
	vs_info( WIN, 1, 1, _, _, _, _, _ ), 
	!.
  valueset_eh(Win, e_Char( k_right, _ ),0):-
	vs_info( WIN, 1, 1, _, _, _, _, _ ), 
	!.
  valueset_eh(Win, e_Char( k_up, _ ),0):-
	vs_info( WIN, 1, 1, _, _, _, _, _ ), 
	!.
  valueset_eh(Win, e_Char( k_down, _ ),0):-
	vs_info( WIN, 1, 1, _, _, _, _, _ ), 
	!.

  valueset_eh(Win, e_Char( k_left, SCA ),0):-
	vs_info( WIN, _, 1, _, _, _, _, _ ), 
	!,
        valueset_eh( Win, e_Char( k_up, SCA )), 
        !.
  valueset_eh(Win, e_Char( k_right, SCA ),0):-
	vs_info( WIN, _, 1, _, _, _, _, _ ), 
	!,
        valueset_eh( Win, e_Char( k_down, SCA )), 
        !.
  valueset_eh(Win, e_Char( k_up, SCA ),0):-
	vs_info( WIN, 1, _, _, _, _, _, _ ), 
	!,
        valueset_eh( Win, e_Char( k_left, SCA )), 
        !.
  valueset_eh(Win, e_Char( k_down, SCA ),0):-
	vs_info( WIN, 1, _, _, _, _, _, _ ), 
	!,
        valueset_eh( Win, e_Char( k_right, SCA )), 
        !.
  valueset_eh(Win,e_Char( k_left, _ ),0):-
  	!,
        valueset_SelectItem( WIN, Id ),
  	vs_items( WIN, Row, Col, Id, _, _ ), 
  	!,
  	Col > 1, 
  	!,
  	NewCol = Col - 1,
  	vs_items( WIN, Row, NewCol, NewId, _, _ ), 
  	!,
        valueset_SelectItem( WIN, NewId ), 
        !.
  valueset_eh(Win,e_Char( k_right, _ ),0):-
  	!,
        valueset_SelectItem( WIN, Id ),
  	vs_items( WIN, Row, Col, Id, _, _ ), 
  	!,
	vs_info( WIN, _, ColMax, _, _, _, _, _ ), 
	!,
  	Col < ColMax, 
  	!,
  	NewCol = Col + 1,
  	vs_items( WIN, Row, NewCol, NewId, _, _ ), 
  	!,
        valueset_SelectItem( WIN, NewId ), 
        !.
  valueset_eh(Win,e_Char( k_up, _ ),0):-
  	!,
        valueset_SelectItem( WIN, Id ),
  	vs_items( WIN, Row, Col, Id, _, _ ), 
  	!,
  	Row > 1, 
  	!,
  	NewRow = Row - 1,
  	vs_items( WIN, NewRow, Col, NewId, _, _ ), 
  	!,
        valueset_SelectItem( WIN, NewId ), 
        !.
  valueset_eh(Win,e_Char( k_down, _ ),0):-
  	!,
        valueset_SelectItem( WIN, Id ),
  	vs_items( WIN, Row, Col, Id, _, _ ), 
  	!,
	vs_info( WIN, RowMax, _, _, _, _, _, _ ), 
	!,
  	Row < RowMax, 
  	!,
  	NewRow = Row + 1,
  	vs_items( WIN, NewRow, Col, NewId, _, _ ), 
  	!,
        valueset_SelectItem( WIN, NewId ), 
        !.
  valueset_eh(Win,e_losefocus,0):-
        retractall(vs_focus( _ )),
        valueset_SelectItem( WIN, Id ),
  	RCT = get_item_rct( WIN, Id ),
	draw_focus(Win,RCT,0),
        !.
  valueset_eh(Win,e_getfocus,0):-
        assert(vs_focus( Win )),
        valueset_SelectItem( WIN, Id ),
  	RCT = get_item_rct( WIN, Id ),
	draw_focus(Win,RCT,1),
        !.

%++ drawing predicates
  redraw_selection(Win,OldRCT,RCT):-
	draw_selected(Win,OldRCT,0),
	draw_selected(Win,RCT,1),
	fail.
  redraw_selection(Win,OldRCT,RCT):-
        vs_focus( Win ),
	draw_focus(Win,OldRCT,0),
	draw_focus(Win,RCT,1),
	fail.
  redraw_selection(_,_,_).
  
  draw_selected(Win,_,1):-
	Value=vpi_GetAttrVal(attr_color_menutext),
	win_SetPen(Win,pen(1,ps_Solid,Value)),
  	fail.
  draw_selected(Win,_,0):-
	Value=vpi_GetAttrVal(attr_color_btnface),
	win_SetPen(Win,pen(1,ps_Solid,Value)),
  	fail.
  draw_selected(Win,RCT,_):-
	RCT1=rect_Inflate(RCT, -1, -1),
	RCT1= rct(L,T,R,B),
	draw_Polyline(Win, [pnt(L,T),pnt(R,T),pnt(R,B),pnt(L,B),pnt(L,T)]),
	!.
	
  draw_focus(Win,_,1):-
	Value=vpi_GetAttrVal(attr_color_menutext),
	win_SetPen(Win,pen(1,ps_Dot,Value)),
  	fail.
  draw_focus(Win,_,0):-
	Value=vpi_GetAttrVal(attr_color_btnface),
	win_SetPen(Win,pen(1,ps_Solid,Value)),
  	fail.
  draw_focus(Win,RCT,_):-
	RCT1=rect_Inflate(RCT, -2, -2),
	RCT1= rct(L,T,R,B),
	draw_Polyline(Win, [pnt(L,T),pnt(R,T),pnt(R,B),pnt(L,B),pnt(L,T)]),
	!.
	
%++ internal calculations
  get_item_rct( WIN, Id, rct(L,T,R,B) ):-
  	vs_items( WIN, Row, Col, Id, _, _ ),
  	!,
	vs_info( WIN, _, _, Dx, Dy, Sx, Sy, _ ),
	!,
	L = ( Col - 1 ) * ( Sx + Dx ),
	T = ( Row - 1 ) * ( Sy + Dy ),
	R = L + Sx,
	B = T + Sy,
	!.
	
  get_size_xy( WIN, Row, Col, Dx, Dy, Sx, Sy ):-
	RCT=win_GetClientRect(Win),
	RCT=rct(_,_,W,H),
	W1 = W - 2,
	H1 = H - 2,
	Sx = ( W1 + Dx ) / Col - Dx,
	Sy = ( H1 + Dy ) / Row - Dy,
	!.

  get_item_id_by_pnt( Win, PNT, Id ):-
  	vs_items( WIN, _, _, Id, _, _ ),
  	  RCT = get_item_rct( WIN, Id ),
	rect_PntInside(RCT,PNT),
	!.

  get_new_index( CurRow, Col, Row, Col, NewCurRow, 1 ):-
        NewCurRow = CurRow + 1,
        NewCurRow <= Row, 
        !.
  get_new_index( CurRow, CurCol, _, _, CurRow, NewCurCol ):-
        NewCurCol = CurCol + 1,
        !.
  
%++ main update
  update(Win,RCT):-
	Value=vpi_GetAttrVal(attr_color_btnface),
	win_Clear( Win, RCT, Value ),
  	fail.
  update(Win,_):-
  	vs_items( WIN, _, _, Id, Val, Pi ),
  	  ItemRCT = get_item_rct( WIN, Id ),
	  RCT=rect_Inflate(ItemRCT, -3, -3),
	  draw_item(WIN,Id,RCT,Val,Pi),
	fail.  
  update(Win,_):-
        valueset_SelectItem( WIN, ID ),
  	RCT = get_item_rct( WIN, Id ),
	win_NeedsUpdate(Win,RCT),
	draw_selected(Win,RCT,1),
        vs_focus( Win ),
	draw_focus(Win,RCT,1),
	fail.  
  update(_,_).

%++ draw single item
  draw_item(WIN,_Id,RCT,Val,p(VS_Paint)):-
  	!,
  	VS_Paint(WIN,RCT,Val),
  	!.
  draw_item(WIN,_Id,RCT,text(Str),dummy):-
  	!,
	draw_TextInRect(Win,RCT, Str, -1,[dtext_center,dtext_Wordbreak]).
  draw_item(WIN,_Id,rct(L,T,R,B),bitmap(ResId),dummy):-
  	!,
	Picture =pict_GetFromRes(ResId),
	pict_GetSize(Picture, W, H, _),
	X = ( R + L ) div 2 - ( W div 2 ),
	Y = ( B + T ) div 2 - ( H div 2 ),
	win_SetClip(Win,rct(L,T,R,B)),
	pict_Draw(Win,Picture,pnt(X,Y),rop_SrcCopy),
	pict_Destroy(Picture),
	ClRCT=win_GetClientRect(Win),
	win_SetClip(Win,ClRCT),
	!.
  draw_item(WIN,_Id,rct(L,T,R,B),icon(ResId),dummy):-
  	!,
	X = ( R + L ) div 2 - 16,
	Y = ( B + T ) div 2 - 16,
	win_SetClip(Win,rct(L,T,R,B)),
	draw_Icon(Win, X, Y,ResId),
	ClRCT=win_GetClientRect(Win),
	win_SetClip(Win,ClRCT),!.
  draw_item(_WIN,_Id,_RCT,empty,dummy):-!.
  	
%++ create value set controls
  create_ctrls( _, _, _, []):-!.
  create_ctrls( WIN, Row, Col, [ c( Id, Val ) | VALSET_CTRL_LIST ]):-
	retract( vs_index( CurRow, CurCol )),
  	assert( vs_items( WIN, CurRow, CurCol, Id, Val, dummy )),
	get_new_index( CurRow, CurCol, Row, Col, NewCurRow, NewCurCol ),
	assert( vs_index( NewCurRow, NewCurCol )),
        create_ctrls( WIN, Row, Col, VALSET_CTRL_LIST ),
        !.
  create_ctrls( _, _, _, _ ):-!.

%++ check for activate chars
  is_char_activate(' '):-!. % SpaceBar
  is_char_activate(13):-!.  % Enter 
  
  vs_bound_free(VAL):-
  	free(VAL),
  	VAL = empty,!.
  vs_bound_free(VAL):-
  	bound(VAL),!.

  vs_bound_free1(VAL):-
  	free(VAL),
  	VAL = 0,!.
  vs_bound_free1(VAL):-
  	bound(VAL),!.
