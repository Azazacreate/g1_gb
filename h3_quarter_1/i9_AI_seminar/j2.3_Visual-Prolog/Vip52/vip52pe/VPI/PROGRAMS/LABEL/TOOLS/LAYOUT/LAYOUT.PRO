/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	LAYOUT.PRO
 Purpose:	Layout object
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
constants
  layout_rect_size	= 4
  layout_shadow_width	= 5

  layout_corner_lt	= 1
  layout_corner_t	= 2
  layout_corner_rt	= 3
  layout_corner_l	= 4
  layout_corner_r	= 5
  layout_corner_lb	= 6
  layout_corner_b	= 7
  layout_corner_rb	= 8

  layout_copy_menu	= 1
  layout_move_menu	= 2
  layout_cancel_menu	= 3

database - layout_db
  layout_start(WINDOW Win)
  layout_page_info(WINDOW ParentWin,WINDOW Win,LAYOUT_PAGE,LAYOUT_CALLBACK,LAYOUT_MODE)
  layout_word_info(WINDOW Win,STRING Copy,STRING Move,STRING Cancel)
  layout_grid_info(WINDOW Win,INTEGER GridHorStep,INTEGER GridVerStep,LAYOUT_GRID Visible,
	BOOLEAN SnapToGrid)
  layout_pict_info(WINDOW Win,PICTURE)
  layout_info(INTEGER LayoutId,WINDOW Win,RCT,LAYOUT_FIELD_TYPE)
  layout_info_tmp(INTEGER LayoutId,WINDOW Win,RCT,LAYOUT_FIELD_TYPE)
  layout_draw_list(WINDOW Win,ILIST LayoutIdList)

  layout_sized(WINDOW Win,RCT,INTEGER Corner,BOOLEAN Active)
  layout_moved(WINDOW OldWin,WINDOW NewWin,ILIST,RCT,INTEGER DX,INTEGER DY,BOOLEAN Active)
  layout_grouped(WINDOW Win,RCT)

  layout_selection(WINDOW Win,ILIST IdList,RCT)
  layout_xorRectType(LAYOUT_FIELD_TYPE)

  determ layout_mouse_pos(INTEGER X,INTEGER Y)
  determ layout_right_move(INTEGER X,INTEGER Y)

/*************************************************************************
			     LAYOUT_TOOLS
*************************************************************************/
predicates
  layout_max(INTEGER,INTEGER,INTEGER)
  layout_min(INTEGER,INTEGER,INTEGER)
clauses
  layout_max(A,B,A):-
	A > B,!.
  layout_max(_,B,B).
  layout_min(A,B,A):-
	A < B,!.
  layout_min(_,B,B).

predicates
  layout_reverse(ILIST,ILIST,ILIST)
clauses
  layout_reverse([],IdList,IdList):-!.
  layout_reverse([Id|Rest],IL,IdList):-!,
     layout_reverse(Rest,[Id|IL],IdList).

predicates
  layout_hsort(WINDOW,ILIST,ILIST,ILIST)
  layout_hsort1(WINDOW,INTEGER,ILIST,ILIST,ILIST)
  layout_hsort2(ILIST,ILIST,ILIST,ILIST)
  layout_vsort(WINDOW,ILIST,ILIST,ILIST)
  layout_vsort1(WINDOW,INTEGER,ILIST,ILIST,ILIST)
  layout_vsort2(ILIST,ILIST,ILIST,ILIST)
clauses
  layout_hsort(_,[],List,List):-!.
  layout_hsort(Win,[Id|Rest],IdList,List):-
	layout_hsort1(Win,Id,IdList,[],IdList1),!,
	layout_hsort(Win,Rest,IdList1,List).

  layout_hsort1(_,Id,[],List,IdList):-
	layout_reverse([Id|List],[],IdList),!.
  layout_hsort1(Win,Id,[I|Rest],IdList,List):-
	layout_info(Id,Win,rct(L,_,R,_),_),
	layout_min(L,R,L1),
	layout_info(I,Win,rct(L2,_,R2,_),_),
	layout_min(L2,R2,L3),
	L3 > L1,
	layout_reverse([Id|IdList],[],IdList1),
	layout_hsort2(IdList1,[I|Rest],[],List),!.
  layout_hsort1(Win,Id,[I|Rest],IdList,List):-!,
	layout_hsort1(Win,Id,Rest,[I|IdList],List).

  layout_hsort2([],[],IdList,List):-
	layout_reverse(IdList,[],List),!.
  layout_hsort2([],[Id|Rest],IdList,List):-!,
	layout_hsort2([],Rest,[Id|IdList],List).
  layout_hsort2([Id|Rest],IdList1,IdList,List):-!,
	layout_hsort2(Rest,IdList1,[Id|IdList],List).

  layout_vsort(_,[],List,List):-!.
  layout_vsort(Win,[Id|Rest],IdList,List):-
	layout_vsort1(Win,Id,IdList,[],IdList1),!,
	layout_vsort(Win,Rest,IdList1,List).

  layout_vsort1(_,Id,[],List,IdList):-
	layout_reverse([Id|List],[],IdList),!.
  layout_vsort1(Win,Id,[I|Rest],IdList,List):-
	layout_info(Id,Win,rct(_,T,_,B),_),
	layout_min(T,B,T1),
	layout_info(I,Win,rct(_,T2,_,B2),_),
	layout_min(T2,B2,T3),
	T3 > T1,
	layout_reverse([Id|IdList],[],IdList1),
	layout_vsort2(IdList1,[I|Rest],[],List),!.
  layout_vsort1(Win,Id,[I|Rest],IdList,List):-!,
	layout_vsort1(Win,Id,Rest,[I|IdList],List).

  layout_vsort2([],[],IdList,List):-
	layout_reverse(IdList,[],List),!.
  layout_vsort2([],[Id|Rest],IdList,List):-!,
	layout_vsort2([],Rest,[Id|IdList],List).
  layout_vsort2([Id|Rest],IdList1,IdList,List):-!,
	layout_vsort2(Rest,IdList1,[Id|IdList],List).

predicates
  layout_invalidate(WINDOW Win,RCT)
clauses
  layout_invalidate(Win,rct(L,T,R,B)):-
	layout_min(L,R,L1),
	layout_min(T,B,T1),
	layout_max(L,R,R1),
	layout_max(T,B,B1),
	L2 = L1 - 5, T2 = T1 - 5, R2 = R1 + 5, B2 = B1 + 5,
	win_Invalidate(Win,rct(L2,T2,R2,B2)),!.

predicates
  layout_rct(LAYOUT_PAGE,RCT)
clauses
  layout_rct(rectangle(Rect,_,_,b_false),Rect):-!.
  layout_rct(rectangle(rct(L,T,R,B),_,_,_),rct(L,T,R1,B1)):-
	R1 = R + layout_shadow_width, B1 = B + layout_shadow_width,!.
  layout_rct(roundrect(Rect,_,_,_,b_false),Rect):-!.
  layout_rct(roundrect(rct(L,T,R,B),_,_,_,_),rct(L,T,R1,B1)):-
	R1 = R + layout_shadow_width, B1 = B + layout_shadow_width,!.
  layout_rct(ellipse(Rect,_,_,b_false),Rect):-!.
  layout_rct(ellipse(rct(L,T,R,B),_,_,_),rct(L,T,R1,B1)):-
	R1 = R + layout_shadow_width, B1 = B + layout_shadow_width,!.

predicates
  layout_change_rct(RCT InRct,INTEGER X,INTEGER Y,INTEGER Corner,RCT OutRct)
  layout_change_rct(RCT InRct,INTEGER X,INTEGER Y,INTEGER Dx,INTEGER Dy,RCT OutRct)
clauses
  layout_change_rct(rct(_,_,R,B),L,T,layout_corner_lt,rct(L,T,R,B)):-!.
  layout_change_rct(rct(L,_,R,B),_,T,layout_corner_t,rct(L,T,R,B)):-!.
  layout_change_rct(rct(L,_,_,B),R,T,layout_corner_rt,rct(L,T,R,B)):-!.
  layout_change_rct(rct(_,T,R,B),L,_,layout_corner_l,rct(L,T,R,B)):-!.
  layout_change_rct(rct(L,T,_,B),R,_,layout_corner_r,rct(L,T,R,B)):-!.
  layout_change_rct(rct(_,T,R,_),L,B,layout_corner_lb,rct(L,T,R,B)):-!.
  layout_change_rct(rct(L,T,R,_),_,B,layout_corner_b,rct(L,T,R,B)):-!.
  layout_change_rct(rct(L,T,_,_),R,B,layout_corner_rb,rct(L,T,R,B)):-!.

  layout_change_rct(rct(L,T,R,B),X,Y,Dx,Dy,rct(L1,T1,R1,B1)):-
	L1 = X - Dx, T1 = Y - Dy, R1 = L1 + (R - L), B1 = T1 + (B - T),!.

predicates
  layout_Insaid(RCT GlobalRect,RCT LocalRect)
  layout_Insaid1(RCT GlobalRect,PNT LocalPoint)
  layout_Insaid2(RCT GlobalRect,PNT LocalPoint)
clauses
  layout_Insaid(rct(L1,T1,R1,B1),rct(L,T,R,B)):-
	layout_min(L,R,L2),
	layout_max(L,R,R2),
	layout_min(T,B,T2),
	layout_max(T,B,B2),
	layout_min(L1,R1,L3),
	layout_max(L1,R1,R3),
	layout_min(T1,B1,T3),
	layout_max(T1,B1,B3),
	L3 <= L2, R2 <= R3,
	T3 <= T2, B2 <= B3,!.

  layout_Insaid1(rct(L,T,R,B),pnt(X,Y)):-
	T = B, L <= X, X <= R,!,
	Y >= T - layout_rect_size,
	Y <= B + layout_rect_size,!.
  layout_Insaid1(rct(L,T,R,B),pnt(X,Y)):-
	L = R, T <= Y, Y <= B,!,
	X >= L - layout_rect_size,
	X <= R + layout_rect_size,!.
  layout_Insaid1(rct(L,T,R,B),pnt(X,Y)):-
	layout_Insaid(rct(L,T,R,B),rct(X,Y,X,Y)),
	X1 = R - ((R - L) * (B - Y)) div (B - T),
	L1 = X1 - layout_rect_size,
	T1 = Y - layout_rect_size,
	R1 = X1 + layout_rect_size,
	B1 = Y + layout_rect_size,
	layout_Insaid(rct(L1,T1,R1,B1),rct(X,Y,X,Y)),!.

  layout_Insaid2(rct(L,T,R,B),pnt(X,Y)):-
	L <= X, X <= R,
	T <= Y, Y <= B,!.

predicates
  layout_rct1(LAYOUT_PAGE,RCT)
clauses
  layout_rct1(rectangle(rct(L,T,R,B),_,_,_),rct(0,0,R1,B1)):-
	R1 = R - L + 1, B1 = B - T + 1,!.
  layout_rct1(roundrect(rct(L,T,R,B),_,_,_,_),rct(0,0,R1,B1)):-
	R1 = R - L + 1, B1 = B - T + 1,!.
  layout_rct1(ellipse(rct(L,T,R,B),_,_,_),rct(0,0,R1,B1)):-
	R1 = R - L + 1, B1 = B - T + 1,!.

predicates
  layout_correct_pnt(WINDOW Win,PNT,PNT)
  layout_correct_pnt1(INTEGER,INTEGER,INTEGER,INTEGER)
  layout_correct_pnt2(WINDOW Win,PNT,PNT)
clauses
  layout_correct_pnt(Win,Pnt,Pnt1):-
	layout_correct_pnt2(Win,Pnt,Pnt1),
	layout_grid_info(Win,_,_,_,b_false),!.
  layout_correct_pnt(Win,pnt(X0,Y0),pnt(X1,Y1)):-
	layout_correct_pnt2(Win,pnt(X0,Y0),pnt(X,Y)),
	layout_grid_info(Win,GridHorStep,GridVerStep,_,_),
	X2 = (X div GridHorStep) * GridHorStep,
	Y2 = (Y div GridVerStep) * GridVerStep,
	X3 = X2 + GridHorStep, Y3 = Y2 + GridVerStep,
	layout_correct_pnt1(X,X2,X3,X1),
	layout_correct_pnt1(Y,Y2,Y3,Y1),!.

  layout_correct_pnt1(X,X2,X3,X2):-
	DX1 = X - X2, DX2 = X3 - X,
	DX1 < DX2,!.
  layout_correct_pnt1(_,_,X3,X3).

predicates
  layout_correct_pnt3(RCT,RCT,INTEGER X,INTEGER Y,INTEGER X1,INTEGER Y1)
clauses
  layout_correct_pnt2(Win,pnt(X,Y),pnt(X1,Y1)):-
	layout_moved(_,Win,_,Rect,DX,DY,b_true),
	layout_change_rct(Rect,X,Y,Dx,Dy,Rect1),
	Rect1 = rct(L1,T1,R1,B1),
	layout_page_info(_,Win,Page,_,_),
	layout_rct1(Page,rct(L,T,R,B)),
	layout_correct_pnt3(rct(L,T,R,B),rct(L1,T1,R1,B1),X,Y,X1,Y1),!.
  layout_correct_pnt2(Win,pnt(X,Y),pnt(X2,Y2)):-
	layout_page_info(_,Win,Page,_,_),
	layout_rct1(Page,rct(L,T,R,B)),
	layout_max(L,X,X1), layout_max(T,Y,Y1),
	layout_min(R,X1,X2), layout_min(B,Y1,Y2),!.

predicates
  layout_correct_pnt4(INTEGER Lower,INTEGER Upper,INTEGER X,INTEGER X1)
  layout_correct_pnt5(INTEGER Lower,INTEGER Upper,INTEGER X,INTEGER X1)
clauses
  layout_correct_pnt3(rct(L,T,R,B),rct(L1,T1,R1,B1),X,Y,X2,Y2):-
	layout_correct_pnt4(L,L1,X,X1),
	layout_correct_pnt5(R1,R,X1,X2),
	layout_correct_pnt4(T,T1,Y,Y1),
	layout_correct_pnt5(B1,B,Y1,Y2),!.

  layout_correct_pnt4(Lower,Upper,X,X):-
	Lower <= Upper,!.
  layout_correct_pnt4(Lower,Upper,X,X1):-
	X1 = X + (Lower - Upper),!.

  layout_correct_pnt5(Lower,Upper,X,X):-
	Lower <= Upper,!.
  layout_correct_pnt5(Lower,Upper,X,X1):-
	X1 = X - (Lower - Upper),!.

predicates
  layout_lenght(ILIST,INTEGER,INTEGER)
clauses
  layout_lenght([],Out,Out):-!.
  layout_lenght([_|Rest],O,Out):-
	O1 = O + 1,!,
	layout_lenght(Rest,O1,Out).

predicates
  layout_add_id(WINDOW Win,INTEGER Id)
  layout_add_id1(ILIST,INTEGER,ILIST)
clauses
  layout_add_id(Win,Id):-
	retract(layout_draw_list(Win,LayoutIdList)),
	layout_add_id1(LayoutIdList,Id,LayoutIdList1),
	assert(layout_draw_list(Win,LayoutIdList1)),!.

  layout_add_id1([],YS,[YS]):-!.
  layout_add_id1([X|XS],YS,[X|ZS]):-
     layout_add_id1(XS,YS,ZS).

predicates
  layout_del_id(WINDOW Win,INTEGER Id)
  layout_del_id1(ILIST,INTEGER,ILIST)
clauses
  layout_del_id(Win,Id):-
	retract(layout_draw_list(Win,LayoutIdList)),
	layout_del_id1(LayoutIdList,Id,LayoutIdList1),
	assert(layout_draw_list(Win,LayoutIdList1)),!.

  layout_del_id1([YS|XS],YS,XS):-!.
  layout_del_id1([X|XS],YS,[X|ZS]):-
     layout_del_id1(XS,YS,ZS).

predicates
  layout_id_to_first(WINDOW Win,INTEGER Id)
  layout_id_to_first1(ILIST,INTEGER,ILIST)
clauses
  layout_id_to_first(Win,Id):-
	retract(layout_draw_list(Win,LayoutIdList)),
	layout_id_to_first1(LayoutIdList,Id,LayoutIdList1),
	LayoutIdList2 = [Id|LayoutIdList1],
	assert(layout_draw_list(Win,LayoutIdList2)),!.

  layout_id_to_first1([YS|XS],YS,XS):-!.
  layout_id_to_first1([X|XS],YS,[X|ZS]):-
     layout_id_to_first1(XS,YS,ZS).

predicates
  layout_id_to_last(WINDOW Win,INTEGER Id)
  layout_id_to_last1(ILIST,INTEGER,ILIST)
clauses
  layout_id_to_last(Win,Id):-
	retract(layout_draw_list(Win,LayoutIdList)),
	layout_id_to_last1(LayoutIdList,Id,LayoutIdList1),
	assert(layout_draw_list(Win,LayoutIdList1)),!.

  layout_id_to_last1([],YS,[YS]):-!.
  layout_id_to_last1([YS|XS],YS,ZS):-
     layout_id_to_last1(XS,YS,ZS),!.
  layout_id_to_last1([X|XS],YS,[X|ZS]):-
     layout_id_to_last1(XS,YS,ZS).

predicates
  layout_check_line(WINDOW Win,ILIST IdList)
clauses
  layout_check_line(Win,[Id|[]]):-
	layout_info(Id,Win,_,line),!.

predicates
  layout_check_ellipse(WINDOW Win,ILIST IdList)
clauses
  layout_check_ellipse(Win,[Id|[]]):-
	layout_info(Id,Win,_,ellipse),!.

predicates
  layout_getrct(WINDOW,ILIST,RCT)
clauses
  layout_getrct(Win,[],Rect):-
	retract(layout_grouped(Win,Rect)),!.
  layout_getrct(Win,[Id|Rest],Rect):-
	retract(layout_grouped(Win,rct(L,T,R,B))),
	layout_info(Id,Win,rct(L1,T1,R1,B1),_),
	layout_min(L,L1,L2),
	layout_min(L2,R1,L3),
	layout_min(L3,R,L4),
	layout_min(T,T1,T2),
	layout_min(T2,B1,T3),
	layout_min(T3,B,T4),
	layout_max(R,R1,R2),
	layout_max(R2,L1,R3),
	layout_max(R3,L,R4),
	layout_max(B,B1,B2),
	layout_max(B2,T1,B3),
	layout_max(B3,T,B4),
	assert(layout_grouped(Win,rct(L4,T4,R4,B4))),!,
	layout_getrct(Win,Rest,Rect).
  layout_getrct(Win,[Id|Rest],Rect):-
	layout_info(Id,Win,Rect1,_),
	assert(layout_grouped(Win,Rect1)),!,
	layout_getrct(Win,Rest,Rect).

predicates
  layout_add_list(WINDOW Win,INTEGER Id)
clauses
  layout_add_list(Win,Id):-
	retract(layout_selection(Win,IdList,rct(L,T,R,B))),
	layout_info(Id,Win,rct(L1,T1,R1,B1),_),
	layout_min(L,L1,L2),
	layout_min(L2,R1,L3),
	layout_min(L3,R,L4),
	layout_min(T,T1,T2),
	layout_min(T2,B1,T3),
	layout_min(T3,B,T4),
	layout_max(R,R1,R2),
	layout_max(R2,L1,R3),
	layout_max(R3,L,R4),
	layout_max(B,B1,B2),
	layout_max(B2,T1,B3),
	layout_max(B3,T,B4),
	assert(layout_selection(Win,[Id|IdList],rct(L4,T4,R4,B4))),!.
  layout_add_list(Win,Id):-
	layout_info(Id,Win,Rect,_),
	assert(layout_selection(Win,[Id],Rect)),!.

predicates
  layout_check_callback(WINDOW Win,LAYOUT_MESSAGE)
  layout_off(WINDOW)
  layout_Update1(WINDOW Win,ILIST)
clauses
  layout_off(Win):-
	retract(layout_selection(Win,IdList,Rect)),
	cursor_Set(Win,cursor_Arrow),
	layout_check_callback(Win,user_action(unSelect(IdList))),
	layout_invalidate(Win,Rect),!.
  layout_off(_).

predicates
  layout_on(WINDOW,ILIST)
  layout_on1(WINDOW,ILIST)
  layout_draw_border(WINDOW)
clauses
  layout_on(Win,IdList1):-
	layout_reverse(IdList1,[],IdList),
	layout_off(Win),
	layout_check_callback(Win,user_action(select(IdList))),
	layout_on1(Win,IdList),
	layout_draw_border(Win),!.
  layout_on(_,_).

  layout_on1(_,[]):-!.
  layout_on1(Win,[0|Rest]):-!,
	layout_on1(Win,Rest).
  layout_on1(Win,[Id|Rest]):-
	layout_add_list(Win,Id),!,
	layout_on1(Win,Rest).

predicates
  layout_get_matr(RCT,INTEGER X1,INTEGER X2,INTEGER X3,INTEGER X4,INTEGER X5,INTEGER X6,
	INTEGER Y1,INTEGER Y2,INTEGER Y3,INTEGER Y4,INTEGER Y5,INTEGER Y6)
  layout_get_matr(RCT,INTEGER X1,INTEGER X2,INTEGER X5,INTEGER X6,
	INTEGER Y1,INTEGER Y2,INTEGER Y5,INTEGER Y6)
  layout_det_matr1(INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER)
clauses
  layout_get_matr(rct(L,T,R,B),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6):-
	DX = (L + R) div 2, DY = (T + B) div 2,
	X1 = L, X2 = L + layout_rect_size,
	X3 = DX - layout_rect_size div 2, X4 = DX + layout_rect_size div 2,
	X5 = R - layout_rect_size, X6 = R,
	Y1 = T, Y2 = T + layout_rect_size,
	Y3 = DY - layout_rect_size div 2, Y4 = DY + layout_rect_size div 2,
	Y5 = B - layout_rect_size, Y6 = B,!.
  layout_get_matr(rct(L,T,R,B),X1,X2,X5,X6,Y1,Y2,Y5,Y6):-
	layout_det_matr1(L,R,X1,X2,X5,X6),
	layout_det_matr1(T,B,Y1,Y2,Y5,Y6),!.

  layout_det_matr1(L,R,X1,X2,X5,X6):-
	R > L,
	X1 = L, X2 = L + layout_rect_size,
	X5 = R - layout_rect_size, X6 = R,!.
  layout_det_matr1(L,R,X1,X2,X5,X6):-
	X1 = L - layout_rect_size, X2 = L,
	X5 = R, X6 = R + layout_rect_size,!.

predicates
  INTEGER layout_get_corner(INTEGER X,INTEGER Y,INTEGER X1,INTEGER X2,INTEGER X3,INTEGER X4,INTEGER X5,INTEGER X6,
	INTEGER Y1,INTEGER Y2,INTEGER Y3,INTEGER Y4,INTEGER Y5,INTEGER Y6)
  INTEGER layout_get_corner(INTEGER X,INTEGER Y,INTEGER X1,INTEGER X2,INTEGER X5,INTEGER X6,
	INTEGER Y1,INTEGER Y2,INTEGER Y5,INTEGER Y6)
clauses
  layout_get_corner(X,Y,X1,X2,_,_,_,_,Y1,Y2,_,_,_,_,layout_corner_lt):-
	layout_Insaid(rct(X1,Y1,X2,Y2),rct(X,Y,X,Y)),!.
  layout_get_corner(X,Y,_,_,X3,X4,_,_,Y1,Y2,_,_,_,_,layout_corner_t):-
	layout_Insaid(rct(X3,Y1,X4,Y2),rct(X,Y,X,Y)),!.
  layout_get_corner(X,Y,_,_,_,_,X5,X6,Y1,Y2,_,_,_,_,layout_corner_rt):-
	layout_Insaid(rct(X5,Y1,X6,Y2),rct(X,Y,X,Y)),!.
  layout_get_corner(X,Y,X1,X2,_,_,_,_,_,_,Y3,Y4,_,_,layout_corner_l):-
	layout_Insaid(rct(X1,Y3,X2,Y4),rct(X,Y,X,Y)),!.
  layout_get_corner(X,Y,_,_,_,_,X5,X6,_,_,Y3,Y4,_,_,layout_corner_r):-
	layout_Insaid(rct(X5,Y3,X6,Y4),rct(X,Y,X,Y)),!.
  layout_get_corner(X,Y,X1,X2,_,_,_,_,_,_,_,_,Y5,Y6,layout_corner_lb):-
	layout_Insaid(rct(X1,Y5,X2,Y6),rct(X,Y,X,Y)),!.
  layout_get_corner(X,Y,_,_,X3,X4,_,_,_,_,_,_,Y5,Y6,layout_corner_b):-
	layout_Insaid(rct(X3,Y5,X4,Y6),rct(X,Y,X,Y)),!.
  layout_get_corner(X,Y,_,_,_,_,X5,X6,_,_,_,_,Y5,Y6,layout_corner_rb):-
	layout_Insaid(rct(X5,Y5,X6,Y6),rct(X,Y,X,Y)),!.

  layout_get_corner(X,Y,X1,X2,_,_,Y1,Y2,_,_,layout_corner_lt):-
	layout_Insaid(rct(X1,Y1,X2,Y2),rct(X,Y,X,Y)),!.
  layout_get_corner(X,Y,_,_,X5,X6,_,_,Y5,Y6,layout_corner_rb):-
	layout_Insaid(rct(X5,Y5,X6,Y6),rct(X,Y,X,Y)),!.

predicates
  layout_adjust_rct(WINDOW Win,RCT InRct,ILIST,RCT OutRct)
  layout_adjust_rct(RCT InRct,LAYOUT_FIELD_TYPE,RCT OutRct)
clauses
  layout_adjust_rct(Win,rct(L,T,R,B),IdList,rct(L,T,R,B)):-
	layout_check_line(Win,IdList),!.
  layout_adjust_rct(_,rct(L,T,R,B),_,rct(L1,T1,R1,B1)):-
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),!.

  layout_adjust_rct(Rect,line,Rect):-!.
  layout_adjust_rct(rct(L,T,R,B),_,rct(L1,T1,R1,B1)):-
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),!.

predicates
  layout_change_field(WINDOW Win,LAYOUT_PAGE,ILIST IdList,RCT OldRect,RCT NewRect)
  layout_move_field(WINDOW Win,LAYOUT_PAGE,ILIST IdList,INTEGER DX,INTEGER DY)
  layout_move_field1(WINDOW Win,LAYOUT_PAGE,ILIST IdList,INTEGER DX,INTEGER DY)
  layout_size_field(WINDOW Win,ILIST IdList,INTEGER R,INTEGER B)
  layout_size_field_x(WINDOW Win,ILIST IdList,INTEGER R,INTEGER T,REAL DY)
  layout_size_field_y(WINDOW Win,ILIST IdList,INTEGER L,INTEGER B,REAL DX)
  layout_size_field(WINDOW Win,ILIST IdList,INTEGER L,INTEGER T,REAL DX,REAL DY)
clauses
  layout_change_field(Win,Page,IdList,rct(L,T,R,B),rct(L1,T1,R1,B1)):-
	DL = L1 - L, DT = T1 - T, DR = R1 - R, DB = B1 - B,
	DL = DR, DT = DB,
	layout_move_field(Win,Page,IdList,DL,DT),!.
  layout_change_field(Win,Page,IdList,rct(L,T,R,B),rct(L1,T1,R1,B1)):-
	R = L, B = T,
	DL = L1 - L, DT = T1 - T,
	layout_move_field1(Win,Page,IdList,DL,DT),
	layout_size_field(Win,IdList,R1,B1),!.
  layout_change_field(Win,Page,IdList,rct(L,T,R,B),rct(L1,T1,R1,B1)):-
	R = L,
	DL = L1 - L, DT = T1 - T,
	DY = (B1 - T1) / (B - T),
	layout_move_field1(Win,Page,IdList,DL,DT),
	layout_size_field_x(Win,IdList,R1,T1,DY),!.
  layout_change_field(Win,Page,IdList,rct(L,T,R,B),rct(L1,T1,R1,B1)):-
	B = T,
	DL = L1 - L, DT = T1 - T,
	DX = (R1 - L1) / (R - L),
	layout_move_field1(Win,Page,IdList,DL,DT),
	layout_size_field_y(Win,IdList,L1,B1,DX),!.
  layout_change_field(Win,Page,IdList,rct(L,T,R,B),rct(L1,T1,R1,B1)):-
	DL = L1 - L, DT = T1 - T,
	DX = (R1 - L1) / (R - L), DY = (B1 - T1) / (B - T),
	layout_move_field1(Win,Page,IdList,DL,DT),
	layout_size_field(Win,IdList,L1,T1,DX,DY),!.

  layout_move_field(_,_,[],_,_):-!.
  layout_move_field(Win,Page,[Id|Rest],DX,DY):-
	retract(layout_info(Id,Win,rct(L,T,R,B),FieldType)),
	L1 = L + DX, T1 = T + DY, R1 = R + DX, B1 = B + DY,
	layout_rct1(Page,Rect),
	Rect = rct(L0,T0,R0,B0),
	layout_max(L0,L1,L2),
	R2 = L2 + (R1 - L1),
	layout_min(R0,R2,R3),
	L3 = R3 - (R1 - L1),
	layout_max(T0,T1,T2),
	B2 = T2 + (B1 - T1),
	layout_min(B0,B2,B3),
	T3 = B3 - (B1 - T1),
	assert(layout_info(Id,Win,rct(L3,T3,R3,B3),FieldType)),!,
	layout_invalidate(Win,rct(L,T,R,B)),
	layout_invalidate(Win,rct(L3,T3,R3,B3)),
	layout_move_field(Win,Page,Rest,DX,DY).

  layout_move_field1(_,_,[],_,_):-!.
  layout_move_field1(Win,Page,[Id|Rest],DX,DY):-
	retract(layout_info(Id,Win,rct(L,T,R,B),FieldType)),
	L1 = L + DX, T1 = T + DY, R1 = R + DX, B1 = B + DY,
	assert(layout_info(Id,Win,rct(L1,T1,R1,B1),FieldType)),!,
	layout_invalidate(Win,rct(L,T,R,B)),
	layout_invalidate(Win,rct(L1,T1,R1,B1)),
	layout_move_field1(Win,Page,Rest,DX,DY).

  layout_size_field(_,[],_,_):-!.
  layout_size_field(Win,[Id|Rest],R,B):-
	layout_check_line(Win,[Id]),
	retract(layout_info(Id,Win,rct(L,T,_,_),FieldType)),
	assert(layout_info(Id,Win,rct(L,T,R,B),FieldType)),!,
	layout_invalidate(Win,rct(L,T,R,B)),
	layout_size_field(Win,Rest,R,B).
  layout_size_field(Win,[Id|Rest],R,B):-
	retract(layout_info(Id,Win,rct(L,T,_,_),FieldType)),
	layout_min(L,R,L1), layout_min(T,B,T1),
	layout_max(L,R,R1), layout_max(T,B,B1),
	assert(layout_info(Id,Win,rct(L1,T1,R1,B1),FieldType)),!,
	layout_invalidate(Win,rct(L1,T1,R1,B1)),
	layout_size_field(Win,Rest,R,B).

  layout_size_field_x(_,[],_,_,_):-!.
  layout_size_field_x(Win,[Id|Rest],R2,T,DY):-
	layout_check_line(Win,[Id]),
	retract(layout_info(Id,Win,rct(L2,T1,_,B1),FieldType)),
	T2 = T + (T1 - T) * DY, B2 = T + (B1 - T) * DY,
	assert(layout_info(Id,Win,rct(L2,T2,R2,B2),FieldType)),!,
	layout_invalidate(Win,rct(L2,T2,R2,B2)),
	layout_size_field_x(Win,Rest,R2,T,DY).
  layout_size_field_x(Win,[Id|Rest],R2,T,DY):-
	retract(layout_info(Id,Win,rct(L2,T1,_,B1),FieldType)),
	T2 = T + (T1 - T) * DY, B2 = T + (B1 - T) * DY,
	layout_min(L2,R2,L3), layout_min(T2,B2,T3),
	layout_max(L2,R2,R3), layout_max(T2,B2,B3),
	assert(layout_info(Id,Win,rct(L3,T3,R3,B3),FieldType)),!,
	layout_invalidate(Win,rct(L3,T3,R3,B3)),
	layout_size_field_x(Win,Rest,R2,T,DY).

  layout_size_field_y(_,[],_,_,_):-!.
  layout_size_field_y(Win,[Id|Rest],L,B2,DX):-
	layout_check_line(Win,[Id]),
	retract(layout_info(Id,Win,rct(L1,T2,R1,_),FieldType)),
	L2 = L + (L1 - L) * DX, R2 = L + (R1 - L) * DX,
	assert(layout_info(Id,Win,rct(L2,T2,R2,B2),FieldType)),!,
	layout_invalidate(Win,rct(L2,T2,R2,B2)),
	layout_size_field_y(Win,Rest,L,B2,DX).
  layout_size_field_y(Win,[Id|Rest],L,B2,DX):-
	retract(layout_info(Id,Win,rct(L1,T2,R1,_),FieldType)),
	L2 = L + (L1 - L) * DX, R2 = L + (R1 - L) * DX,
	layout_min(L2,R2,L3), layout_min(T2,B2,T3),
	layout_max(L2,R2,R3), layout_max(T2,B2,B3),
	assert(layout_info(Id,Win,rct(L3,T3,R3,B3),FieldType)),!,
	layout_invalidate(Win,rct(L3,T3,R3,B3)),
	layout_size_field_y(Win,Rest,L,B2,DX).

  layout_size_field(_,[],_,_,_,_):-!.
  layout_size_field(Win,[Id|Rest],L,T,DX,DY):-
	layout_check_line(Win,[Id]),
	retract(layout_info(Id,Win,rct(L1,T1,R1,B1),FieldType)),
	L2 = L + (L1 - L) * DX, T2 = T + (T1 - T) * DY,
	R2 = L + (R1 - L) * DX, B2 = T + (B1 - T) * DY,
	assert(layout_info(Id,Win,rct(L2,T2,R2,B2),FieldType)),!,
	layout_invalidate(Win,rct(L1,T1,R1,B1)),
	layout_invalidate(Win,rct(L2,T2,R2,B2)),
	layout_size_field(Win,Rest,L,T,DX,DY).
  layout_size_field(Win,[Id|Rest],L,T,DX,DY):-
	retract(layout_info(Id,Win,rct(L1,T1,R1,B1),FieldType)),
	L2 = L + (L1 - L) * DX, T2 = T + (T1 - T) * DY,
	R2 = L + (R1 - L) * DX, B2 = T + (B1 - T) * DY,
	layout_min(L2,R2,L3), layout_min(T2,B2,T3),
	layout_max(L2,R2,R3), layout_max(T2,B2,B3),
	assert(layout_info(Id,Win,rct(L3,T3,R3,B3),FieldType)),!,
	layout_invalidate(Win,rct(L1,T1,R1,B1)),
	layout_invalidate(Win,rct(L3,T3,R3,B3)),
	layout_size_field(Win,Rest,L,T,DX,DY).

predicates
  layout_stretch(WINDOW Win,LAYOUT_PAGE,BOOLEAN Stretch)
  layout_remove(WINDOW Win,RCT,ILIST IdList)
clauses
  layout_stretch(Win,_,b_false):-
	layout_unselect(Win),
	layout_draw_list(Win,IdList),
	layout_page_info(_,Win,Page,_,_),
	layout_rct1(Page,Rect),
	layout_remove(Win,Rect,IdList),!.
  layout_stretch(Win,Page0,b_true):-
	layout_unselect(Win),
	layout_draw_list(Win,IdList),
	layout_page_info(_,Win,Page,_,_),
	layout_rct1(Page,Rect),
	layout_rct1(Page0,Rect0),
	layout_change_field(Win,Page0,IdList,Rect0,Rect),!.

predicates
  layout_check_callback1(WINDOW Win,LAYOUT_MESSAGE)
clauses

  layout_remove(_,_,[]):-!.
  layout_remove(Win,Rect,[Id|Rest]):-
	layout_info(Id,Win,Rect1,_),
	layout_Insaid(Rect,Rect1),!,
	layout_remove(Win,Rect,Rest).
  layout_remove(Win,Rect,[Id|Rest]):-
	retract(layout_info(Id,Win,Rect1,_)),
	layout_check_callback1(Win,user_action(delete(Id,Rect1))),
	layout_del_id(Win,Id),!,
	layout_remove(Win,Rect,Rest).

predicates
  INTEGER layout_get(WINDOW Win,PNT)
  INTEGER layout_get(WINDOW Win,INTEGER Id,PNT)
  INTEGER layout_get1(WINDOW Win,ILIST,PNT)
  INTEGER layout_get1(WINDOW Win,ILIST,INTEGER Id,PNT)
clauses
  layout_get(Win,Pnt,Id):-
	layout_draw_list(Win,IdList),
	layout_reverse(IdList,[],IdList0),
	Id = layout_get1(Win,IdList0,Pnt),!.

  layout_get(Win,Id0,Pnt,Id):-
	layout_draw_list(Win,IdList),
	layout_reverse(IdList,[],IdList0),
	Id = layout_get1(Win,IdList0,Id0,Pnt),!.

  layout_get1(_,[],_,_):-!,fail.
  layout_get1(Win,[Id|_],Pnt,Id):-
	layout_info(Id,Win,Rect,_),
	layout_check_line(Win,[Id]),
	layout_Insaid1(Rect,Pnt),!.
  layout_get1(Win,[Id|_],pnt(X,Y),Id):-
	layout_info(Id,Win,Rect,_),
	not(layout_check_line(Win,[Id])),
	layout_Insaid(Rect,rct(X,Y,X,Y)),!.
  layout_get1(Win,[_|Rest],Pnt,Id):-!,
	Id = layout_get1(Win,Rest,Pnt).

  layout_get1(_,[],_,_,_):-!,fail.
  layout_get1(_,[Id0|_],Id0,_,_):-!,fail.
  layout_get1(Win,[Id|_],_,Pnt,Id):-
	layout_info(Id,Win,Rect,_),
	layout_check_line(Win,[Id]),
	layout_Insaid1(Rect,Pnt),!.
  layout_get1(Win,[Id|_],_,pnt(X,Y),Id):-
	layout_info(Id,Win,Rect,_),
	not(layout_check_line(Win,[Id])),
	layout_Insaid(Rect,rct(X,Y,X,Y)),!.
  layout_get1(Win,[_|Rest],Id0,Pnt,Id):-!,
	Id = layout_get1(Win,Rest,Id0,Pnt).

predicates
  layout_set_cursor1(WINDOW Win,INTEGER IdCursor)
clauses
  layout_set_cursor1(Win,Cursor):-
	Cursor = cursor_Get(Win),!.
ifdef idc_cursor_as
  layout_set_cursor1(Win,_):-
	Cursor = cursor_Get(Win),
	Cursor = idc_cursor_as,!.
enddef
ifdef os_nt
ifdef idc_cursor_move
  layout_set_cursor1(Win,cursor_Size):-
	Cursor = cursor_Get(Win),
	Cursor = idc_cursor_move,!.
  layout_set_cursor1(Win,cursor_Size):-
	cursor_Set(Win,idc_cursor_move),!.
enddef /* idc_cursor_move */
  layout_set_cursor1(Win,cursor_Size):-
	cursor_Set(Win,cursor_Cross),!.
enddef /* os_nt */
  layout_set_cursor1(Win,Cursor):-
	cursor_Set(Win,Cursor),!.

predicates
  layout_set_cursor(WINDOW Win,INTEGER Corner)
clauses
ifdef idc_cursor_as
  layout_set_cursor(Win,_):-
	Cursor = cursor_Get(Win),
	Cursor = idc_cursor_as,!.
enddef
  layout_set_cursor(Win,layout_corner_lt):-
	cursor_Set(Win,cursor_SizeNWSE),!.
  layout_set_cursor(Win,layout_corner_t):-
	cursor_Set(Win,cursor_SizeNS),!.
  layout_set_cursor(Win,layout_corner_rt):-
	cursor_Set(Win,cursor_SizeNESW),!.
  layout_set_cursor(Win,layout_corner_l):-
	cursor_Set(Win,cursor_SizeWE),!.
  layout_set_cursor(Win,layout_corner_r):-
	cursor_Set(Win,cursor_SizeWE),!.
  layout_set_cursor(Win,layout_corner_lb):-
	cursor_Set(Win,cursor_SizeNESW),!.
  layout_set_cursor(Win,layout_corner_b):-
	cursor_Set(Win,cursor_SizeNS),!.
  layout_set_cursor(Win,layout_corner_rb):-
	cursor_Set(Win,cursor_SizeNWSE),!.

predicates
  layout_group_select1(WINDOW Win,RCT,ILIST)
clauses
  layout_group_select1(_,_,[]):-!.
  layout_group_select1(Win,Rect,[Id|Rest]):-
	layout_info(Id,Win,Rect1,_),
	layout_Insaid(Rect,Rect1),
	layout_add_list(Win,Id),!,
	layout_group_select1(Win,Rect,Rest).
  layout_group_select1(Win,Rect,[_|Rest]):-!,
	layout_group_select1(Win,Rect,Rest).

predicates
  layout_group_select(WINDOW Win,RCT)
clauses
  layout_group_select(Win,Rect):-
	layout_draw_list(Win,IdList),
	layout_group_select1(Win,Rect,IdList),!.

predicates
  layout_member(INTEGER,ILIST)
clauses
  layout_member(S,[S|_]):-!.
  layout_member(S,[_|L]):-
    layout_member(S,L).

predicates
  layout_add_select(WINDOW Win,INTEGER Id)
clauses
  layout_add_select(Win,Id):-
	layout_selection(Win,IdList,_),
	layout_member(Id,IdList),!.
  layout_add_select(Win,Id):-
	layout_add_list(Win,Id),
	layout_selection(Win,_,Rect),
	layout_off(Win),
	layout_group_select(Win,Rect),!.

predicates
  layout_add_select1(WINDOW Win,INTEGER Id)
clauses
  layout_add_select1(Win,Id):-
	layout_selection(Win,IdList,_),
	layout_member(Id,IdList),
	layout_del_id1(IdList,Id,IdList1),
	layout_on(Win,IdList1),
	layout_selection(Win,_,Rect),
	win_Invalidate(Win,Rect),!.
  layout_add_select1(Win,Id):-
	layout_add_list(Win,Id),
	layout_selection(Win,_,Rect),
	win_Invalidate(Win,Rect),!.
predicates
  layout_NewId(WINDOW Win,INTEGER Start,INTEGER Id)
clauses

  layout_NewId(Win,Start,Start):-
	not(layout_info(Start,Win,_,_)),!.
  layout_NewId(Win,Start,Id):-
	S = Start + 1,!,
	layout_NewId(Win,S,Id).

predicates
  layout_createXorRectType(WINDOW Win,ILIST)
clauses
  layout_createXorRectType(Win,[Id|[]]):-
	layout_check_line(Win,[Id]),
	retractall(layout_xorRectType(_)),
	assert(layout_xorRectType(line)),!.
  layout_createXorRectType(Win,[Id|[]]):-
	layout_check_ellipse(Win,[Id]),
	retractall(layout_xorRectType(_)),
	assert(layout_xorRectType(ellipse)),!.
  layout_createXorRectType(_,_):-
	retractall(layout_xorRectType(_)),
	assert(layout_xorRectType(rectangle)),!.

predicates
  layout_draw_xor_rect(WINDOW Win,RCT)
  layout_draw_xor_rect1(WINDOW Win,RCT,LAYOUT_FIELD_TYPE)
clauses
  layout_draw_xor_rect(Win,Rect):-
	layout_xorRectType(Type),
	layout_draw_xor_rect1(Win,Rect,Type),!.

  layout_draw_xor_rect1(Win,rct(L,T,R,B),line):-
	win_SetDrawMode(Win,dm_XorPen),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_line(Win,pnt(L,T),pnt(R,B)),
	win_SetDrawMode(Win,dm_CopyPen),!.
  layout_draw_xor_rect1(Win,Rect,ellipse):-
	win_SetDrawMode(Win,dm_XorPen),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	win_SetBrush(Win,brush(pat_Hollow,color_White)),
	draw_Ellipse(Win,Rect),
	win_SetDrawMode(Win,dm_CopyPen),!.
  layout_draw_xor_rect1(Win,Rect,_):-
	win_SetDrawMode(Win,dm_XorPen),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	win_SetBrush(Win,brush(pat_Hollow,color_White)),
	draw_Rect(Win,Rect),
	win_SetDrawMode(Win,dm_CopyPen),!.

predicates
  layout_draw_border1(WINDOW,ILIST)
clauses
  layout_draw_border(Win):-
	layout_selection(Win,IdList,Rect),
	layout_check_line(Win,IdList),
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_Black)),
	layout_get_matr(Rect,X1,X2,X5,X6,Y1,Y2,Y5,Y6),
	draw_Rect(Win,rct(X1,Y1,X2,Y2)),
	draw_Rect(Win,rct(X5,Y5,X6,Y6)),!.
  layout_draw_border(Win):-
	layout_selection(Win,[_|[]],Rect),
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Hollow,color_Black)),
	draw_Rect(Win,Rect),
	win_SetBrush(Win,brush(pat_Solid,color_Black)),
	layout_get_matr(Rect,X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6),
	draw_Rect(Win,rct(X1,Y1,X2,Y2)),
	draw_Rect(Win,rct(X3,Y1,X4,Y2)),
	draw_Rect(Win,rct(X5,Y1,X6,Y2)),
	draw_Rect(Win,rct(X1,Y3,X2,Y4)),
	draw_Rect(Win,rct(X5,Y3,X6,Y4)),
	draw_Rect(Win,rct(X1,Y5,X2,Y6)),
	draw_Rect(Win,rct(X3,Y5,X4,Y6)),
	draw_Rect(Win,rct(X5,Y5,X6,Y6)),!.
  layout_draw_border(Win):-
	layout_selection(Win,IdList,Rect),
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Hollow,color_Black)),
	draw_Rect(Win,Rect),
	win_SetBrush(Win,brush(pat_Solid,color_Black)),
	layout_get_matr(Rect,X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6),
	draw_Rect(Win,rct(X1,Y1,X2,Y2)),
	draw_Rect(Win,rct(X3,Y1,X4,Y2)),
	draw_Rect(Win,rct(X5,Y1,X6,Y2)),
	draw_Rect(Win,rct(X1,Y3,X2,Y4)),
	draw_Rect(Win,rct(X5,Y3,X6,Y4)),
	draw_Rect(Win,rct(X1,Y5,X2,Y6)),
	draw_Rect(Win,rct(X3,Y5,X4,Y6)),
	draw_Rect(Win,rct(X5,Y5,X6,Y6)),
	layout_draw_border1(Win,IdList),!.
  layout_draw_border(_).

  layout_draw_border1(_,[]):-!.
  layout_draw_border1(Win,[Id|Rest]):-
	layout_info(Id,Win,Rect,line),
	layout_get_matr(Rect,X1,X2,X5,X6,Y1,Y2,Y5,Y6),
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_Black)),
	draw_Rect(Win,rct(X1,Y1,X2,Y2)),
	draw_Rect(Win,rct(X5,Y5,X6,Y6)),!,
	layout_draw_border1(Win,Rest).
  layout_draw_border1(Win,[Id|Rest]):-
	layout_info(Id,Win,Rect,_),
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Hollow,color_Black)),
	draw_Rect(Win,Rect),
	win_SetBrush(Win,brush(pat_Solid,color_Black)),
	layout_get_matr(Rect,X1,X2,_,_,X5,X6,Y1,Y2,_,_,Y5,Y6),
	draw_Rect(Win,rct(X1,Y1,X6,Y2)),
	draw_Rect(Win,rct(X5,Y2,X6,Y6)),
	draw_Rect(Win,rct(X1,Y5,X6,Y6)),
	draw_Rect(Win,rct(X1,Y2,X2,Y5)),!,
	layout_draw_border1(Win,Rest).

predicates
  layout_Update(WINDOW Win)
clauses
  layout_Update(Win):-
	layout_draw_list(Win,IdList),
	layout_Update1(Win,IdList),!.

  layout_Update1(Win,[]):-
	layout_draw_border(Win),!.
  layout_Update1(Win,[Id|Rest]):-
	layout_info(Id,Win,Rect,_),
	layout_check_callback1(Win,user_action(draw(Id,Rect))),!,
	layout_Update1(Win,Rest).

predicates
  layout_draw_page(WINDOW Win)
  layout_draw_page1(WINDOW PictWin,WINDOW Win,LAYOUT_PAGE)
  layout_draw_grid(WINDOW PictWin,WINDOW Win,RCT)
  layout_draw_shadow(WINDOW PictWin,LAYOUT_PAGE,RCT PageRect1)
clauses
  layout_draw_page(Win):-
	layout_pict_info(Win,Picture),
	pict_Draw(Win,Picture,pnt(0,0),rop_SrcCopy),
	layout_Update(Win),!.

  layout_draw_page1(PictWin,Win,rectangle(_,brush(Pat,Color),BgColor,Shadow)):-
	PageRect = win_GetClientRect(PictWin),
	win_Clear(PictWin,BgColor),
	layout_draw_Shadow(PictWin,rectangle(PageRect,brush(Pat,Color),BgColor,Shadow),PageRect1),
	win_SetPen(PictWin,pen(1,ps_Solid,Color)),
	win_SetBrush(PictWin,brush(Pat,Color)),
	draw_Rect(PictWin,PageRect1),
	layout_draw_grid(PictWin,Win,PageRect1),!.
  layout_draw_page1(PictWin,Win,roundrect(_,brush(Pat,Color),CornerRad,BgColor,Shadow)):-
	PageRect = win_GetClientRect(PictWin),
	win_Clear(PictWin,BgColor),
	layout_draw_Shadow(PictWin,roundrect(PageRect,brush(Pat,Color),CornerRad,BgColor,Shadow),PageRect1),
	win_SetPen(PictWin,pen(1,ps_Solid,Color)),
	win_SetBrush(PictWin,brush(Pat,Color)),
	draw_RoundRect(PictWin,PageRect1,CornerRad,CornerRad),
	layout_draw_grid(PictWin,Win,PageRect1),!.
  layout_draw_page1(PictWin,Win,ellipse(_,brush(Pat,Color),BgColor,Shadow)):-
	PageRect = win_GetClientRect(PictWin),
	win_Clear(PictWin,BgColor),
	layout_draw_Shadow(PictWin,ellipse(PageRect,brush(Pat,Color),BgColor,Shadow),PageRect1),
	win_SetPen(PictWin,pen(1,ps_Solid,Color)),
	win_SetBrush(PictWin,brush(Pat,Color)),
	draw_Ellipse(PictWin,PageRect1),
	layout_draw_grid(PictWin,Win,PageRect1),!.

predicates
  layout_draw_grid1(WINDOW Win,COLOR,INTEGER HorStep,INTEGER VerStep,INTEGER X,INTEGER Y,RCT)
  layout_draw_grid2(WINDOW Win,COLOR,INTEGER VerStep,INTEGER X,INTEGER Y,RCT)
  layout_draw_grid3(WINDOW Win,INTEGER HorStep,RCT)
  layout_draw_grid4(WINDOW Win,INTEGER VerStep,RCT)
clauses
  layout_draw_grid(PictWin,Win,rct(L,T,R,B)):-
	layout_grid_info(Win,HorStep,VerStep,dot(Color),_),
	X = L + HorStep,
	Y = T + VerStep,
	layout_draw_grid1(PictWin,Color,HorStep,VerStep,X,Y,rct(L,T,R,B)),!.
  layout_draw_grid(PictWin,Win,rct(L,T,R,B)):-
	layout_grid_info(Win,HorStep,VerStep,line(Color),_),
	win_SetPen(PictWin,pen(1,ps_Solid,Color)),
	L1 = L + HorStep,
	T1 = T + VerStep,
	layout_draw_grid3(PictWin,HorStep,rct(L1,T,R,B)),
	layout_draw_grid4(PictWin,VerStep,rct(L,T1,R,B)),!.
  layout_draw_grid(_,_,_).

  layout_draw_grid1(_,_,_,_,X,_,rct(_,_,R,_)):-
	X >= R,!.
  layout_draw_grid1(Win,Color,HorStep,VerStep,X,Y,Rect):-
	layout_draw_grid2(Win,Color,VerStep,X,Y,Rect),
	X1 = X + HorStep,!,
	layout_draw_grid1(Win,Color,HorStep,VerStep,X1,Y,Rect).

  layout_draw_grid2(_,_,_,_,Y,rct(_,_,_,B)):-
	Y >= B,!.
  layout_draw_grid2(Win,Color,VerStep,X,Y,Rect):-
	draw_Pixel(Win,pnt(X,Y),Color),
	Y1 = Y + VerStep,!,
	layout_draw_grid2(Win,Color,VerStep,X,Y1,Rect).

  layout_draw_grid3(_,_,rct(L,_,R,_)):-
	L >= R,!.
  layout_draw_grid3(Win,HorStep,rct(L,T,R,B)):-
	draw_Line(Win,pnt(L,T),pnt(L,B)),
	L1 = L + HorStep,!,
	layout_draw_grid3(Win,HorStep,rct(L1,T,R,B)).

  layout_draw_grid4(_,_,rct(_,T,_,B)):-
	T >= B,!.
  layout_draw_grid4(Win,VerStep,rct(L,T,R,B)):-
	draw_Line(Win,pnt(L,T),pnt(R,T)),
	T1 = T + VerStep,!,
	layout_draw_grid4(Win,VerStep,rct(L,T1,R,B)).

  layout_draw_Shadow(Win,rectangle(rct(L,T,R,B),_,_,b_false),rct(L1,T1,R1,B1)):-
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Hollow,color_White)),
	R0 = R - 1, B0 = B - 1,
	L1 = L + 1, T1 = T + 1, R1 = R - 2, B1 = B - 2,
	draw_Rect(Win,rct(L,T,R0,B0)),!.
  layout_draw_Shadow(Win,roundrect(rct(L,T,R,B),_,CornerRad,_,b_false),rct(L1,T1,R1,B1)):-
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Hollow,color_White)),
	R0 = R - 1, B0 = B - 1,
	L1 = L + 1, T1 = T + 1, R1 = R - 2, B1 = B - 2,
	draw_RoundRect(Win,rct(L,T,R0,B0),CornerRad,CornerRad),!.
  layout_draw_Shadow(Win,ellipse(rct(L,T,R,B),_,_,b_false),rct(L1,T1,R1,B1)):-
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	R0 = R - 1, B0 = B - 1,
	L1 = L + 1, T1 = T + 1, R1 = R - 2, B1 = B - 2,
	draw_Ellipse(Win,rct(L,T,R0,B0)),!.
  layout_draw_Shadow(Win,rectangle(rct(L,T,R,B),_,_,_),rct(L,T,R1,B1)):-
	L1 = L + layout_shadow_width, T1 = T + layout_shadow_width,
	R1 = R - layout_shadow_width, B1 = B - layout_shadow_width,
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_Black)),
	draw_Rect(Win,rct(L1,T1,R,B)),!.
  layout_draw_Shadow(Win,roundrect(rct(L,T,R,B),_,CornerRad,_,_),rct(L,T,R1,B1)):-
	L1 = L + layout_shadow_width, T1 = T + layout_shadow_width,
	R1 = R - layout_shadow_width, B1 = B - layout_shadow_width,
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_Black)),
	draw_RoundRect(Win,rct(L1,T1,R,B),CornerRad,CornerRad),!.
  layout_draw_Shadow(Win,ellipse(rct(L,T,R,B),_,_,_),rct(L,T,R1,B1)):-
	L1 = L + layout_shadow_width, T1 = T + layout_shadow_width,
	R1 = R - layout_shadow_width, B1 = B - layout_shadow_width,
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_Black)),
	draw_Ellipse(Win,rct(L1,T1,R,B)),!.

  layout_check_callback(Win,Mess):-
	layout_page_info(_,Win,_,Callbackfunc,_),
	Callbackfunc(Win,Mess,Answer),!,
	Answer = event_answer(continue).
  layout_check_callback(_,_).

predicates
  layout_align1(WINDOW Win,LAYOUT_PAGE,ILIST IdList,RCT Rect,LAYOUT_ALIGN)
  layout_hsumm(WINDOW Win,ILIST IdList,INTEGER,INTEGER Width)
  layout_vsumm(WINDOW Win,ILIST IdList,INTEGER,INTEGER Width)
  layout_halign2(WINDOW Win,LAYOUT_PAGE,ILIST IdList,INTEGER L,INTEGER D)
  layout_valign2(WINDOW Win,LAYOUT_PAGE,ILIST IdList,INTEGER T,INTEGER D)
clauses
  layout_hsumm(_,[],Width,Width):-!.
  layout_hsumm(Win,[Id|Rest],W,Width):-
	layout_info(Id,Win,rct(L,_,R,_),_),
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	W1 = W + (R1 - L1 + 1),!,
	layout_hsumm(Win,Rest,W1,Width).
  layout_vsumm(_,[],Width,Width):-!.
  layout_vsumm(Win,[Id|Rest],W,Width):-
	layout_info(Id,Win,rct(_,T,_,B),_),
	layout_max(T,B,B1),
	layout_min(T,B,T1),
	W1 = W + (B1 - T1 + 1),!,
	layout_hsumm(Win,Rest,W1,Width).

  layout_align1(_,_,[],_,_):-!.
  layout_align1(Win,Page,[Id|Rest],rct(L0,T0,R0,B0),left):-
	layout_info(Id,Win,rct(L,T,R,B),_),
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),
	D = L0 - L1, L2 = L1 + D, R2 = R1 + D,
	layout_check_callback(Win,user_action(size([Id],rct(L2,T1,R2,B1)))),
	layout_change_field(Win,Page,[Id],rct(L1,T1,R1,B1),rct(L2,T1,R2,B1)),!,
	layout_align1(Win,Page,Rest,rct(L0,T0,R0,B0),left).
  layout_align1(Win,Page,[Id|Rest],rct(L0,T0,R0,B0),right):-
	layout_info(Id,Win,rct(L,T,R,B),_),
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),
	D = R0 - R1, L2 = L1 + D, R2 = R1 + D,
	layout_check_callback(Win,user_action(size([Id],rct(L2,T1,R2,B1)))),
	layout_change_field(Win,Page,[Id],rct(L1,T1,R1,B1),rct(L2,T1,R2,B1)),!,
	layout_align1(Win,Page,Rest,rct(L0,T0,R0,B0),right).
  layout_align1(Win,Page,[Id|Rest],rct(L0,T0,R0,B0),top):-
	layout_info(Id,Win,rct(L,T,R,B),_),
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),
	D = T0 - T1, T2 = T1 + D, B2 = B1 + D,
	layout_check_callback(Win,user_action(size([Id],rct(L1,T2,R1,B2)))),
	layout_change_field(Win,Page,[Id],rct(L1,T1,R1,B1),rct(L1,T2,R1,B2)),!,
	layout_align1(Win,Page,Rest,rct(L0,T0,R0,B0),top).
  layout_align1(Win,Page,[Id|Rest],rct(L0,T0,R0,B0),bottom):-
	layout_info(Id,Win,rct(L,T,R,B),_),
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),
	D = B0 - B1, T2 = T1 + D, B2 = B1 + D,
	layout_check_callback(Win,user_action(size([Id],rct(L1,T2,R1,B2)))),
	layout_change_field(Win,Page,[Id],rct(L1,T1,R1,B1),rct(L1,T2,R1,B2)),!,
	layout_align1(Win,Page,Rest,rct(L0,T0,R0,B0),bottom).
  layout_align1(Win,Page,[Id|Rest],rct(L0,T0,R0,B0),center_hor):-
	layout_info(Id,Win,rct(L,T,R,B),_),
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),
	D = ((R0 - L0 + 1) - (R1 - L1 + 1)) div 2, L2 = L0 + D, R2 = R0 - D,
	layout_check_callback(Win,user_action(size([Id],rct(L2,T1,R2,B1)))),
	layout_change_field(Win,Page,[Id],rct(L1,T1,R1,B1),rct(L2,T1,R2,B1)),!,
	layout_align1(Win,Page,Rest,rct(L0,T0,R0,B0),center_hor).
  layout_align1(Win,Page,[Id|Rest],rct(L0,T0,R0,B0),center_ver):-
	layout_info(Id,Win,rct(L,T,R,B),_),
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),
	D = ((B0 - T0 + 1) - (B1 - T1 + 1)) div 2, T2 = T0 + D, B2 = B0 - D,
	layout_check_callback(Win,user_action(size([Id],rct(L1,T2,R1,B2)))),
	layout_change_field(Win,Page,[Id],rct(L1,T1,R1,B1),rct(L1,T2,R1,B2)),!,
	layout_align1(Win,Page,Rest,rct(L0,T0,R0,B0),center_ver).
  layout_align1(Win,Page,IdList,rct(L0,_,R0,_),divider_hor):-
	layout_hsumm(Win,IdList,0,Width),
	layout_lenght(IdList,0,Num),
	Num > 2,
	Num1 = Num - 1,
	D = ((R0 - L0 + 1) - Width) div Num1 + 1,
	layout_hsort(Win,IdList,[],IdList1),
	layout_halign2(Win,Page,IdList1,L0,D),!.
  layout_align1(Win,Page,IdList,rct(_,T0,_,B0),divider_ver):-
	layout_vsumm(Win,IdList,0,Width),
	layout_lenght(IdList,0,Num),
	Num > 2,
	Num1 = Num - 1,
	D = ((B0 - T0 + 1) - Width) div Num1 + 1,
	layout_vsort(Win,IdList,[],IdList1),
	layout_valign2(Win,Page,IdList1,T0,D),!.
  layout_align1(_,_,_,_,_).

  layout_halign2(_,_,[],_,_):-!.
  layout_halign2(Win,Page,[Id|Rest],L0,D):-
	layout_info(Id,Win,rct(L,T,R,B),_),
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),
	L2 = L0, R2 = L2 + (R1 - L1),
	layout_check_callback(Win,user_action(size([Id],rct(L2,T1,R2,B1)))),
	layout_change_field(Win,Page,[Id],rct(L1,T1,R1,B1),rct(L2,T1,R2,B1)),
	L00 = R2 + D,!,
	layout_halign2(Win,Page,Rest,L00,D).
  layout_valign2(_,_,[],_,_):-!.
  layout_valign2(Win,Page,[Id|Rest],T0,D):-
	layout_info(Id,Win,rct(L,T,R,B),_),
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),
	T2 = T0, B2 = T2 + (B1 - T1),
	layout_check_callback(Win,user_action(size([Id],rct(L1,T2,R1,B2)))),
	layout_change_field(Win,Page,[Id],rct(L1,T1,R1,B1),rct(L1,T2,R1,B2)),
	T00 = B2 + D,!,
	layout_valign2(Win,Page,Rest,T00,D).

predicates
  layout_reselect(WINDOW)
clauses
  layout_reselect(Win):-
	layout_selection(Win,IdList,_),
	layout_on(Win,IdList),!.
  layout_reselect(_).

predicates
  layout_change_win(WINDOW ActiveWin,WINDOW Win0,INTEGER X0,INTEGER Y0,
	WINDOW Win,INTEGER X,INTEGER Y)
clauses
  layout_change_win(Win0,Win0,X0,Y0,Win0,X0,Y0):-
	RectP = win_GetClientRect(Win0),
	layout_Insaid2(RectP,pnt(X0,Y0)),!.
  layout_change_win(Win,Win0,X0,Y0,Win,X,Y):-
	PntList = win_MapPoints(Win0,Win,[pnt(X0,Y0)]),
	PntList = [pnt(X,Y)],
	RectP = win_GetClientRect(Win),
	layout_Insaid2(RectP,pnt(X,Y)),
	win_ReleaseMouse(),
	win_CaptureMouse(Win),!.
  layout_change_win(_,Win0,X0,Y0,Win0,X0,Y0):-
	RectP = win_GetClientRect(Win0),
	layout_Insaid2(RectP,pnt(X0,Y0)),!.
  layout_change_win(_,Win0,X0,Y0,Win,X,Y):-
	layout_page_info(_,Win,_,_,_),
	PntList = win_MapPoints(Win0,Win,[pnt(X0,Y0)]),
	PntList = [pnt(X,Y)],
	RectP = win_GetClientRect(Win),
	layout_Insaid2(RectP,pnt(X,Y)),
	win_ReleaseMouse(),
	win_CaptureMouse(Win),!.
  layout_change_win(_,Win0,X0,Y0,Win0,X0,Y0).

predicates
  layout_copy_fields1(WINDOW OldWin,WINDOW NewWin,ILIST OldIdList,ILIST,ILIST NewIdList)
clauses
  layout_copy_fields1(_,_,[],NewIdList,NewIdList):-!.
  layout_copy_fields1(OldWin,NewWin,[OldId|Rest],NIL,NewIdList):-
	layout_info(OldId,OldWin,Rect,Type),
	layout_NewId(NewWin,1,NewId),
	assert(layout_info(NewId,NewWin,Rect,Type)),
	layout_add_id(NewWin,NewId),!,
	layout_copy_fields1(OldWin,NewWin,Rest,[NewId|NIL],NewIdList).

predicates
  layout_copy_fields(WINDOW OldWin,WINDOW NewWin,ILIST OldIdList,ILIST NewIdList)
clauses
  layout_copy_fields(OldWin,NewWin,OldIdList,NewIdList):-
	layout_reverse(OldIdList,[],OldIdList1),
	layout_copy_fields1(OldWin,NewWin,OldIdList1,[],NewIdList),!.

predicates
  layout_move_fields1(WINDOW OldWin,WINDOW NewWin,ILIST OldIdList,ILIST,ILIST NewIdList)
clauses
  layout_move_fields1(_,_,[],NewIdList,NewIdList):-!.
  layout_move_fields1(OldWin,NewWin,[OldId|Rest],NIL,NewIdList):-
	retract(layout_info(OldId,OldWin,Rect,Type)),
	layout_del_id(OldWin,OldId),
	layout_NewId(NewWin,1,NewId),
	assert(layout_info(NewId,NewWin,Rect,Type)),
	layout_add_id(NewWin,NewId),!,
	layout_move_fields1(OldWin,NewWin,Rest,[NewId|NIL],NewIdList).

predicates
  layout_move_fields(WINDOW OldWin,WINDOW NewWin,ILIST OldIdList,ILIST NewIdList)
clauses
  layout_move_fields(Win,Win,NewIdList,NewIdList):-!.
  layout_move_fields(OldWin,NewWin,OldIdList,NewIdList):-
	layout_reverse(OldIdList,[],OldIdList1),
	layout_move_fields1(OldWin,NewWin,OldIdList1,[],NewIdList),!.

predicates
  layout_assert_tmp_info(WINDOW,ILIST)
clauses
  layout_assert_tmp_info(_,[]):-!.
  layout_assert_tmp_info(Win,[Id|Rest]):-
	layout_info(Id,Win,Rect,Type),
	assert(layout_info_tmp(Id,Win,Rect,Type)),!,
	layout_assert_tmp_info(Win,Rest).

predicates
  layout_get_rct_list(WINDOW,ILIST,LAYOUT_RCTLIST,LAYOUT_RCTLIST)
clauses
  layout_get_rct_list(_,[],RctList,RctList):-!.
  layout_get_rct_list(Win,[Id|Rest],NIL,RctList):-
	layout_info(Id,Win,Rect,_),!,
	layout_get_rct_list(Win,Rest,[Rect|NIL],RctList).

predicates
  layout_get_rct_list1(WINDOW,ILIST,LAYOUT_RCTLIST,LAYOUT_RCTLIST)
clauses
  layout_get_rct_list1(_,[],RctList,RctList):-!.
  layout_get_rct_list1(Win,[Id|Rest],NIL,RctList):-
	layout_info_tmp(Id,Win,Rect,_),!,
	layout_get_rct_list1(Win,Rest,[Rect|NIL],RctList).

predicates
  layout_move_sendcallback(WINDOW WinOld,ILIST OldIdList,WINDOW NewWin,ILIST NewIdList)
clauses
  layout_move_sendcallback(OldWin,OldIdList,NewWin,NewIdList):-
	layout_reverse(OldIdList,[],OldIdList1),
	layout_reverse(NewIdList,[],NewIdList1),
	layout_get_rct_list1(OldWin,OldIdList1,[],OldRctList),
	layout_get_rct_list(NewWin,NewIdList1,[],NewRctList),
	layout_check_callback1(OldWin,user_action(move(OldIdList,OldRctList,NewWin,NewIdList,NewRctList))),!.

predicates
  layout_copy_sendcallback(WINDOW WinOld,ILIST OldIdList,WINDOW NewWin,ILIST NewIdList)
clauses
  layout_copy_sendcallback(OldWin,OldIdList,NewWin,NewIdList):-
	layout_reverse(OldIdList,[],OldIdList1),
	layout_reverse(NewIdList,[],NewIdList1),
	layout_get_rct_list1(OldWin,OldIdList1,[],OldRctList),
	layout_get_rct_list(NewWin,NewIdList1,[],NewRctList),
	layout_check_callback1(OldWin,user_action(copy(OldIdList,OldRctList,NewWin,NewIdList,NewRctList))),!.

/**global PREDICATE*******************************************************
			     LAYOUT_CREATEPAGE
*************************************************************************/
predicates
  win_layout_eh : EHANDLER
clauses
  layout_CreatePage(ParentWin,Page,CallBackFunc,Copy,Move,Cancel,Win):-
	layout_rct(Page,Rect),
	Win = win_Create(w_Child,Rect,"",no_menu,ParentWin,
			[wsf_ClipSiblings],win_layout_eh,0),
	win_SetMapMode(Win,mm_Arbitrary),
	assert(layout_start(Win)),
	assert(layout_page_info(ParentWin,Win,Page,CallBackFunc,edit_mode)),
	assert(layout_word_info(Win,Copy,Move,Cancel)),
	assert(layout_draw_list(Win,[])),
	assert(layout_grid_info(Win,1,1,invisible,b_false)),
	Rect = rct(L,T,R,B),
	L1 = 0, T1 = 0, R1 = R - L + 1, B1 = B - T + 1,
	PictWin = pict_Open(rct(L1,T1,R1,B1)),
	win_Clear(PictWin,color_White),
	layout_draw_page1(PictWin,Win,Page),
	Picture = pict_Close(PictWin),
	assert(layout_pict_info(Win,Picture)),
	layout_draw_page(Win),
	retract(layout_start(Win)),!.

/**global PREDICATE*******************************************************
			     LAYOUT_INITPAGE
*************************************************************************/
  layout_InitPage(Win,Page,Stretch):-
	assert(layout_start(Win)),
	retract(layout_page_info(ParentWin,Win,Page1,CallBackFunc,Mode)),
	assert(layout_page_info(ParentWin,Win,Page,CallBackFunc,Mode)),
	layout_rct(Page,Rect),
	win_Move(Win,Rect),
	Rect = rct(L,T,R,B),
	L1 = 0, T1 = 0, R1 = R - L + 1, B1 = B - T + 1,
	retract(layout_pict_info(Win,Picture)),
	pict_Destroy(Picture),
	PictWin = pict_Open(rct(L1,T1,R1,B1)),
	win_Clear(PictWin,color_White),
	layout_draw_page1(PictWin,Win,Page),
	Picture1 = pict_Close(PictWin),
	assert(layout_pict_info(Win,Picture1)),
	layout_draw_page(Win),
	layout_stretch(Win,Page1,Stretch),
	retract(layout_start(Win)),!.

/**global PREDICATE*******************************************************
			     LAYOUT_GRID
*************************************************************************/
  layout_grid(Win,GridHorStep,GridVerStep,Visible,SnapToGrid):-
	bound(GridHorStep), bound(GridVerStep), bound(Visible), bound(SnapToGrid),
	assert(layout_start(Win)),
	retract(layout_grid_info(Win,_,_,_,_)),
	assert(layout_grid_info(Win,GridHorStep,GridVerStep,Visible,SnapToGrid)),
	retract(layout_pict_info(Win,Picture1)),
	pict_Destroy(Picture1),
	layout_page_info(_,Win,Page,_,_),
	layout_rct(Page,rct(L,T,R,B)),
	L1 = 0, T1 = 0, R1 = R - L + 1, B1 = B - T + 1,
	PictWin = pict_Open(rct(L1,T1,R1,B1)),
	win_Clear(PictWin,color_White),
	layout_draw_page1(PictWin,Win,Page),
	Picture = pict_Close(PictWin),
	assert(layout_pict_info(Win,Picture)),
	retract(layout_start(Win)),
	win_Invalidate(Win),!.
  layout_grid(Win,GridHorStep,GridVerStep,Visible,SnapToGrid):-
	free(GridHorStep), free(GridVerStep), free(Visible), free(SnapToGrid),
	layout_grid_info(Win,GridHorStep,GridVerStep,Visible,SnapToGrid),!.

/**global PREDICATE*******************************************************
			     LAYOUT_SETMODE
*************************************************************************/
  layout_SetMode(Win,Edit_Create):-
	layout_off(Win),
	retract(layout_page_info(ParentWin,Win,Page,CallBackFunc,_)),
	assert(layout_page_info(ParentWin,Win,Page,CallBackFunc,Edit_Create)),!.

/**global PREDICATE*******************************************************
			     LAYOUT_CREATE
*************************************************************************/
  layout_check_callback1(Win,Message):-
	layout_check_callback(Win,Message),!.
  layout_check_callback1(_,_).

  layout_Create(Win,Rect,Type,Id):-
	free(Id),
	layout_NewId(Win,1,Id),
	assert(layout_info(Id,Win,Rect,Type)),
	layout_add_id(Win,Id),
	layout_Update1(Win,[Id]),
	layout_check_callback1(Win,user_action(modified([Id]))),!.
  layout_Create(Win,Rect,Type,Id):-
	bound(Id),
	assert(layout_info(Id,Win,Rect,Type)),
	layout_add_id(Win,Id),
	layout_Update1(Win,[Id]),
	layout_check_callback1(Win,user_action(modified([Id]))),!.

/**global PREDICATE*******************************************************
			     LAYOUT_FIELDS
*************************************************************************/
  layout_fields(Win,IdList):-
	free(IdList),
	layout_draw_list(Win,IdList),!.
  layout_fields(Win,IdList):-
	bound(IdList),
	retract(layout_draw_list(Win,_)),
	assert(layout_draw_list(Win,IdList)),!.

/**global PREDICATE*******************************************************
			     LAYOUT_DELETE
*************************************************************************/
  layout_delete(Win,[]):-
	layout_check_callback(Win,user_action(modified([]))),!.
  layout_delete(Win,[Id|Rest]):-
	layout_off(Win),
	layout_del_id(Win,Id),
	retract(layout_info(Id,Win,Rect,_)),
	layout_check_callback1(Win,user_action(delete(Id,Rect))),
	layout_invalidate(Win,Rect),!,
	layout_delete(Win,Rest).

/**global PREDICATE*******************************************************
			     LAYOUT_SELECT
*************************************************************************/
  layout_select(Win,IdList):-
	bound(IdList),
	layout_on(Win,IdList),!.
  layout_select(Win,IdList):-
	free(IdList),
	layout_selection(Win,IdList,_),!.
  layout_select(_,IdList):-
	free(IdList),
	IdList = [],!.

/**global PREDICATE*******************************************************
			     LAYOUT_UNSELECT
*************************************************************************/
  layout_unselect(Win):-
	layout_off(Win),!.

/**global PREDICATE*******************************************************
			     LAYOUT_GET_FIELD
*************************************************************************/
  layout_get_field(Win,Pnt,Id):-
	Id = layout_get(Win,Pnt),!.

/**global PREDICATE*******************************************************
			     LAYOUT_RECTANGLE
*************************************************************************/
  layout_rectangle(Win,IdList,Rect):-
	bound(Rect),
	layout_getrct(Win,IdList,Rect1),
	layout_page_info(_,Win,Page,_,_),
	layout_check_callback(Win,user_action(size(IdList,Rect))),
	layout_change_field(Win,Page,IdList,Rect1,Rect),
	layout_reselect(Win),!.
  layout_rectangle(Win,IdList,Rect):-
	free(Rect),
	layout_getrct(Win,IdList,Rect),!.

/**global PREDICATE*******************************************************
			     LAYOUT_BRINGTOFRONT
*************************************************************************/
  layout_BringToFront(Win,[]):-
	layout_Update(Win),
	layout_check_callback(Win,user_action(modified([]))),!.
  layout_BringToFront(Win,[Id|Rest]):-
	layout_id_to_last(Win,Id),!,
	layout_BringToFront(Win,Rest).

/**global PREDICATE*******************************************************
			     LAYOUT_SENDTOBACK
*************************************************************************/
  layout_SendToBack(Win,[]):-
	layout_Update(Win),
	layout_check_callback(Win,user_action(modified([]))),!.
  layout_SendToBack(Win,[Id|Rest]):-
	layout_id_to_first(Win,Id),!,
	layout_SendToBack(Win,Rest).

/**global PREDICATE*******************************************************
			     LAYOUT_SIZE
*************************************************************************/
predicates
  layout_size1(WINDOW Win,LAYOUT_PAGE,ILIST IdList,INTEGER Width,INTEGER Height)
clauses
  layout_size1(_,_,[],_,_):-!.
  layout_size1(Win,Page,[Id|Rest],Width,Height):-
	layout_info(Id,Win,rct(L,T,R,B),_),
	layout_max(L,R,R1),
	layout_min(L,R,L1),
	layout_max(T,B,B1),
	layout_min(T,B,T1),
	R2 = L1 + Width,
	B2 = T1 + Height,
	layout_check_callback(Win,user_action(size([Id],rct(L1,T1,R2,B2)))),
	layout_change_field(Win,Page,[Id],rct(L1,T1,R1,B1),rct(L1,T1,R2,B2)),!,
	layout_size1(Win,Page,Rest,Width,Height).

  layout_size(Win,IdList,Width,Height):-
	layout_page_info(_,Win,Page,_,_),
	layout_size1(Win,Page,IdList,Width,Height),
	layout_selection(Win,_,rct(L,T,R,B)),
	layout_reselect(Win),
	layout_selection(Win,_,rct(L1,T1,R1,B1)),
	layout_invalidate(Win,rct(L,T,R,B)),
	layout_invalidate(Win,rct(L1,T1,R1,B1)),!,
	layout_check_callback(Win,user_action(modified(IdList))),!.
  layout_size(_,_,_,_).
/**global PREDICATE*******************************************************
			     LAYOUT_MOVE
*************************************************************************/
  layout_move(Win,IdList,DX,DY):-
	retractall(layout_info_tmp(_,Win,_,_)),
	layout_assert_tmp_info(Win,IdList),
	layout_page_info(_,Win,Page,_,_),
	layout_move_field(Win,Page,IdList,DX,DY),
	layout_selection(Win,IdList,rct(L,T,R,B)),
	layout_reselect(Win),
	layout_selection(Win,IdList,rct(L1,T1,R1,B1)),
	layout_invalidate(Win,rct(L,T,R,B)),
	layout_invalidate(Win,rct(L1,T1,R1,B1)),!,
	layout_move_sendcallback(Win,IdList,Win,IdList),
	layout_check_callback(Win,user_action(modified(IdList))),!.
  layout_move(_,_,_,_).

/**global PREDICATE*******************************************************
			     LAYOUT_ALIGN
*************************************************************************/
  layout_align(Win,IdList,Align):-
	layout_page_info(_,Win,Page,_,_),
	retractall(layout_grouped(Win,_)),
	layout_getrct(Win,IdList,Rect),
	layout_align1(Win,Page,IdList,Rect,Align),
	layout_reselect(Win),
	layout_check_callback(Win,user_action(modified(IdList))),!.
/*************************************************************************
			     LAYOUT EVENT HANDLER
*************************************************************************/
predicates
  layout_MouseDown(WINDOW Win,PNT)
  layout_MouseUp(WINDOW Win,PNT)
  layout_MouseMove(WINDOW Win,PNT)
clauses
  win_layout_eh(Win,_,0):-
	layout_start(Win),!.

  win_layout_eh(Win,Event,0):-
	not(layout_check_callback(Win,event(Event))),!.

  win_layout_eh(_,e_EraseBackGround(),0):-!.

  win_layout_eh(Win,e_Update(_),0):-
	layout_draw_page(Win),!.

  win_layout_eh(Win,e_Destroy,0):-
	retract(layout_page_info(_,Win,_,_,_)),
	retractall(layout_word_info(Win,_,_,_)),
	retractall(layout_draw_list(Win,_)),
	retractall(layout_grid_info(Win,_,_,_,_)),
	retractall(layout_pict_info(Win,_)),
	retractall(layout_info(_,Win,_,_)),
	retractall(layout_sized(Win,_,_,_)),
	retractall(layout_moved(Win,_,_,_,_,_,_)),
	retractall(layout_moved(_,Win,_,_,_,_,_)),
	retractall(layout_grouped(Win,_)),
	retractall(layout_selection(Win,_,_)),
	retractall(layout_mouse_pos(_,_)),
	retractall(layout_right_move(_,_)),!.

  win_layout_eh(_,e_MouseDown(pnt(_,_),_,_),0):-
	retract(layout_right_move(_,_)),
	retract(layout_moved(OldWin,NewWin,_,Rect,_,_,b_true)),
	layout_set_cursor1(OldWin,cursor_Arrow),
	layout_set_cursor1(NewWin,cursor_Arrow),
	layout_draw_xor_rect(NewWin,Rect),
	fail.
  win_layout_eh(Win,e_MouseDown(pnt(X,Y),c_Shift,mouse_button_left),0):-
	Id = layout_get(Win,pnt(X,Y)),
	layout_add_select(Win,Id),
	layout_selection(Win,IdList,_),
	layout_check_callback(Win,user_action(select(IdList))),!.
  win_layout_eh(Win,e_MouseDown(pnt(X,Y),c_Control,mouse_button_left),0):-
	Id = layout_get(Win,pnt(X,Y)),
	layout_add_select1(Win,Id),
	layout_selection(Win,IdList,_),
	layout_check_callback(Win,user_action(select(IdList))),!.
  win_layout_eh(Win,e_MouseDown(pnt(X0,Y0),c_Nothing,mouse_button_left),0):-
	layout_correct_pnt(Win,pnt(X0,Y0),pnt(X,Y)),
	layout_MouseDown(Win,pnt(X,Y)),!.
  win_layout_eh(Win,e_MouseDown(pnt(X0,Y0),c_Nothing,mouse_button_right),0):-
	layout_moved(Win,_,_,_,_,_,b_false),
	retractall(layout_right_move(_,_)),
	assert(layout_right_move(X0,Y0)),
	layout_correct_pnt(Win,pnt(X0,Y0),pnt(X,Y)),
	layout_MouseDown(Win,pnt(X,Y)),!.

  win_layout_eh(Win,e_MouseUp(pnt(X0,Y0),_,mouse_button_right),0):-
	layout_moved(_,Win,_,_,_,_,b_true),
	retract(layout_right_move(X0,Y0)),
	retract(layout_moved(_,Win,_,Rect,_,_,b_true)),
	layout_draw_xor_rect(Win,Rect),!.
  win_layout_eh(Win,e_MouseUp(pnt(X0,Y0),_,mouse_button_right),0):-
	layout_moved(_,Win,_,_,_,_,b_true),
	retractall(layout_right_move(_,_)),
	assert(layout_right_move(X0,Y0)),
	win_ReleaseMouse(),
	layout_word_info(Win,Copy,Move,Cancel),
	Menu = dyn_menu([
	txt(layout_copy_menu,Copy,0,1,0,[]),
	txt(layout_move_menu,Move,0,1,0,[]),
	separator,
	txt(layout_cancel_menu,Cancel,0,1,0,[])
	]),
	menu_PopUp(Win,Menu,pnt(X0,Y0),align_left),!.
  win_layout_eh(Win,e_MouseUp(pnt(X0,Y0),_,mouse_button_left),0):-
	layout_correct_pnt(Win,pnt(X0,Y0),pnt(X,Y)),
	layout_MouseUp(Win,pnt(X,Y)),!.

  win_layout_eh(_,e_MouseMove(pnt(X,Y),_,_),0):-
	layout_mouse_pos(X,Y),!.
  win_layout_eh(Win,e_MouseMove(pnt(X,Y),_,_),0):-
	retractall(layout_mouse_pos(_,_)),
	assert(layout_mouse_pos(X,Y)),
	layout_MouseMove(Win,pnt(X,Y)),!.

  win_layout_eh(NewWin,e_Menu(layout_copy_menu,_),0):-
	retract(layout_right_move(X0,Y0)),
	retract(layout_moved(OldWin,NewWin,OldIdList,NewRect,Dx,Dy,b_true)),
	retractall(layout_info_tmp(_,OldWin,_,_)),
	layout_assert_tmp_info(OldWin,OldIdList),
	layout_correct_pnt(NewWin,pnt(X0,Y0),pnt(X,Y)),
	layout_copy_fields(OldWin,NewWin,OldIdList,NewIdList),
	layout_draw_xor_rect(NewWin,NewRect),
	layout_change_rct(NewRect,X,Y,Dx,Dy,NewRect1),
	layout_getrct(NewWin,NewIdList,OldRect),
	layout_page_info(_,NewWin,Page,_,_),
	layout_change_field(NewWin,Page,NewIdList,OldRect,NewRect1),
	assert(layout_moved(NewWin,NewWin,NewIdList,NewRect1,Dx,Dy,b_false)),
	layout_off(OldWin),
	layout_on(NewWin,NewIdList),
	win_SetFocus(NewWin),
	layout_copy_sendcallback(OldWin,OldIdList,NewWin,NewIdList),
	layout_check_callback(NewWin,user_action(modified(NewIdList))),!.
  win_layout_eh(Win,e_Menu(layout_move_menu,_),0):-
	retract(layout_right_move(X0,Y0)),
	layout_correct_pnt(Win,pnt(X0,Y0),pnt(X,Y)),
	layout_MouseUp(Win,pnt(X,Y)),!.
  win_layout_eh(_,e_Menu(layout_cancel_menu,_),0):-
	retract(layout_right_move(_,_)),
	retract(layout_moved(OldWin,NewWin,OldIdList,NewRect,_,_,b_true)),
	layout_set_cursor1(OldWin,cursor_Arrow),
	layout_set_cursor1(NewWin,cursor_Arrow),
	layout_draw_xor_rect(NewWin,NewRect),
	layout_on(OldWin,OldIdList),!.

  win_layout_eh(Win,e_Char(Key,CSA),0):-
	layout_page_info(ParentWin,Win,_,_,_),
	win_SendEvent(ParentWin,e_Char(Key,CSA)),!.

include "tools\\layout\\laymouse.pro"
