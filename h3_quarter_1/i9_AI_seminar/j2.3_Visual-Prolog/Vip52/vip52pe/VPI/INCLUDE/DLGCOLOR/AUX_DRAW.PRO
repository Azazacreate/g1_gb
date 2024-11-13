/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 Project:  CHUTE
 FileName: AUX_DRAW.PRO
 Purpose: Chute Allocator
 Written by: Lars Henrik Jacobsen
 Comments: Version 1.01
******************************************************************************/
ifndef aux_draw_pre_included
 #Error: this file requires include: aux_draw.pre
enddef 

%predicates
%  centre_text_in_rct(WINDOW,STRING,RCT,INTEGER,INTEGER)
clauses
  centre_text_in_rct(W,TEXT,RCT,X,Y) :-
    RCT = rcT(L,T,R,B),
    WIDTH = R-L,
    HEIGHT = B-T,
    str_len(TEXT,LEN),
    win_GetTextExtent(W, TEXT, LEN, CX, _),
    win_GetFontMetrics(W, _, Ascent, Descent),	
    X = (WIDTH - CX) / 2 + L,
    Y = (HEIGHT + Ascent - Descent) / 2 + T.

%predicates
%  centre_rect_in_window(WINDOW,RCT,RCT)
clauses
  centre_rect_in_window(WIN,RCT,NEW_RCT) :-
	WINRCT = win_GetClientRect(WIN),
	WINRCT = rct(WL,WT,WR,WB),
	WIDTH = WR - WL,
	HEIGHT = WB - WT,
	RCT = rct(L,T,R,B),
	CX = R - L,
	CY = B - T,
	LEFT = (WIDTH - CX) div 2,
	TOP  = (HEIGHT - CY) div 2,
	BOTTOM = TOP + CY,
	RIGHT  = LEFT + CX,
	NEW_RCT = rct(LEFT,TOP,RIGHT,BOTTOM).

%predicates
%  RCT draw_3d_frame_in_rect(WINDOW,RCT,Boolean)	
clauses
  draw_3d_frame_in_rect(CtlW,RCT,b_true,RCT3) :- !,
	RCT = rct(L,T,Width,Height), R = Width - 1, B = Height - 1,
%	format(S10,"Orig rect: %,%,%,%",L,T,R0,B0),evt(S10),
	%---- Draw 3-D decorations for depressed button frame ----
	%  	 L_L1L2____________R2R1R_	
	%  T	|######################..|	
	%  T1	|##§§§§§§§§§§§§§§§§§§//..|	??  = not drawn
	%  T2	|##§§                //..|	§§  = color_Gray
	%  B2	|##§§                //..|	##  = color_Black
	%  B1	|##////////////////////..|	//  = color_LtGray
	%  B	|........................|	..  = color_White
	%  
	L1 = L + 1, T1 = T + 1, R1 = R - 1, B1 = B - 1,
	L2 = L1 + 1,T2 = T1 + 1,R2 = R1 - 1,_B2 = B1 - 1,
	win_SetPen(CtlW,pen(1,ps_Solid,color_Black)),
	draw_Line(CtlW,pnt(R1,T),pnt(L,T)),% Draw line from R1,T up to, but not including, L,T
	draw_Line(CtlW,pnt(L,T),pnt(L,B)),
	win_SetPen(CtlW,pen(1,ps_Solid,color_White)),
	draw_Line(CtlW,pnt(L,B),pnt(R,B)),
	draw_Line(CtlW,pnt(R,B),pnt(R,T)),
	draw_Line(CtlW,pnt(R,T),pnt(R,T2)),
	win_SetPen(CtlW,pen(1,ps_Solid,color_Gray)),
	draw_Line(CtlW,pnt(R2,T1),pnt(L1,T1)),
	draw_Line(CtlW,pnt(L1,T1),pnt(L1,B1)),
	win_SetPen(CtlW,pen(1,ps_Solid,color_LtGray)),
	draw_Line(CtlW,pnt(L1,B1),pnt(R1,B1)),
	draw_Line(CtlW,pnt(R1,B1),pnt(R1,T)),
	RCT3 = rct(L2,T2,R1,B1).	% If the pen was to be ps_Hollow, we should inflate the rect by a pixel
  draw_3d_frame_in_rect(CtlW,RCT,b_false,RCT3) :- !,
	RCT = rct(L,T,Width,Height), R = Width - 1, B = Height - 1,
	%---- Draw 3-D decorations for released button frame ----
	%  	 L_L1L2____________R2R1R_	
	%  T	|......................##|	
	%  T1	|..//////////////////§§##|	??  = not drawn
	%  T2	|..//                §§##|	§§  = color_Gray
	%  B2	|..//                §§##|	##  = color_Black
	%  B1	|..§§§§§§§§§§§§§§§§§§§§##|	//  = color_LtGray
	%  B	|########################|	..  = color_White
	%  
	L1 = L + 1, T1 = T + 1, R1 = R - 1, B1 = B - 1,
	L2 = L1 + 1,T2 = T1 + 1,R2 = R1 - 1,_B2 = B1 - 1,
	win_SetPen(CtlW,pen(1,ps_Solid,color_White)),
	draw_Line(CtlW,pnt(R1,T),pnt(L,T)),% Draw line from R1,T up to, but not including, L,T
	draw_Line(CtlW,pnt(L,T),pnt(L,B)),
	win_SetPen(CtlW,pen(1,ps_Solid,color_Black)),
	draw_Line(CtlW,pnt(L,B),pnt(R,B)),
	draw_Line(CtlW,pnt(R,B),pnt(R,T)),
	draw_Line(CtlW,pnt(R,T),pnt(R,T2)),
	win_SetPen(CtlW,pen(1,ps_Solid,color_LtGray)),
	draw_Line(CtlW,pnt(R2,T1),pnt(L1,T1)),
	draw_Line(CtlW,pnt(L1,T1),pnt(L1,B)),
	win_SetPen(CtlW,pen(1,ps_Solid,color_Gray)),
	draw_Line(CtlW,pnt(L1,B1),pnt(R1,B1)),
	draw_Line(CtlW,pnt(R1,B1),pnt(R1,T)),
	RCT3 = rct(L2,T2,R1,B1).	% If the pen was to be ps_Hollow, we should inflate the rect by a pixel
  draw_3d_frame_in_rect(_,RCT,_,RCT):-!,
	errorexit(). % Should never be called !

%predicates
%  draw_button(WINDOW,COLOR,Boolean)	
clauses
% Draw the color in the window _Win, pushed down ?
  draw_button(CtlW,COLOR,Down) :-
	RCT = win_GetClientRect(CtlW),
	RCT3 = draw_3d_frame_in_rect(CtlW,RCT,Down),
	%---- Draw coloured inner rectangle ----
	win_SetPen(CtlW,pen(1,ps_solid,COLOR)),
	win_SetBrush(CtlW,brush(pat_solid,COLOR)),
	draw_Rect(CtlW,RCT3).

