/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 Project:  Progress bar
 FileName: PROGRESS.PRO
 Purpose: Setup Program
 Written by: Leo Jensen and Lars Juul
 Modified by: Zaichenko Michael (removed all flickering)
 Comments:
******************************************************************************/
ifndef progress_pre_included
 #Error: this file requires include: progress.pre
enddef 

database - progress
  progress_bar_status(WINDOW,ULONG MaxSize,ULONG SizeLeft)
  progress_bar_colors(WINDOW,COLOR fColor,COLOR bColor,PATSTYLE)
  progress_bar_value(WINDOW,INTEGER,STRING procent)

constants
ifndef progressBar_FillColor
  progressBar_FillColor = color_Red
enddef
ifndef progressBar_BackColor
  progressBar_BackColor = color_White
enddef
ifndef progressBar_PatStyle
  progressBar_PatStyle  = pat_Hollow
enddef


predicates
%  progress_register()-()
%  progress_bar_set_colors(WINDOW,COLOR fColor,COLOR bColor,PATSTYLE) - (i,i,i,i)
   progress_bar_get_colors(WINDOW, COLOR fColor,COLOR bColor,PATSTYLE) - procedure(i,o,o,o)
%  progress_bar_set_value(WINDOW,ULONG MaxSize,ULONG SizeLeft)

   procedure draw_progress_frame(WINDOW)
   
clauses
  progress_bar_set_colors(Win,FColor,BColor,pat_Solid):-
  	!,
	progress_bar_set_colors(Win,FColor,BColor,pat_Hollow).
  progress_bar_set_colors(Win,FColor,BColor,Patstyle):-
  	retractall(progress_bar_colors(Win,_,_,_)),
  	assert(progress_bar_colors(Win,FColor,BColor,Patstyle)),
	win_invalidate(WIN).

  progress_bar_get_colors(Win, FColor,BColor,Patstyle):-
  	progress_bar_colors(Win, FColor,BColor,Patstyle),
  	!.
  progress_bar_get_colors(_,progressBar_FillColor,progressBar_BackColor,progressBar_PatStyle).



predicates
  progress_min(INTEGER,INTEGER,INTEGER)	- procedure(i,i,o)
  progress_max(INTEGER,INTEGER,INTEGER)	- procedure(i,i,o)

clauses

  progress_min(A,B,A) :- A<=B, !.
  progress_min(_,B,B).

  progress_max(A,B,A) :- A>=B, !.
  progress_max(_,B,B).

predicates
  procedure progress_SetInvalidT(Window,STRING old,STRING new)
  progress_GetInvalidB(INTEGER old,INTEGER new,INTEGER l,INTEGER r) - procedure(i,i,o,o)
clauses

  progress_SetInvalidT(_,STR,Str):-!.
  progress_SetInvalidT(Win,Str2,Str1):-!,
	Rct=win_getClientRect(Win),
	RCT=rct(_,_,X,Y),
	win_GetTextExtent(WIN,Str1,-1,W1,H1),
	win_GetTextExtent(WIN,Str2,-1,W2,_),
	progress_max(W1,W2,WM),
	HX=X div 2,HY=Y div 2,
	Hw1=WM div 2,HH1=H1 div 2,
	Nx1=Hx-Hw1-2,Ny1=Hy-HH1-1,
	Nx2=Hx+Hw1+2,Ny2=Hy+HH1+1,
	win_Invalidate(Win,rct(Nx1,Ny1,Nx2,Ny2)).

  progress_GetInvalidB(X,X,0,0):-!.
  progress_GetInvalidB(X1,X2,L,T):-
	X1<X2,!,L=X1-1,T=X2+1.
  progress_GetInvalidB(X1,X2,L,T):-
	L=X2-1,T=X1+1.
  	
  progress_bar_set_value(Win,0,_):-!,		%\ MZ 12.09.96
	progress_bar_set_value(Win,10000,0).	%/

  progress_bar_set_value(Win,IMaxSize,ISizeLeft):-
	RCT1 = win_GetClientRect(Win),
	RCT1 = rct(Lb,Tb,Rb,Bb),
	Rb >= Bb,!,			% Window is horizontal
	retract(progress_bar_status(Win,_,_)),
	assert(progress_bar_status(Win,IMaxSize, ISizeLeft)),
	L=Lb+2,R=Rb-2,
	RMaxSize = cast(real,IMaxSize),
	RSizeLeft = cast(real,ISizeLeft),
	RR1 = (((R-L)*RSizeLeft) / RMaxSize),
	R1 = cast(integer,RR1) + L,
	progress_min(R1,R,Rc),
	progress_max(Rc,L,NRc),
	Procent = val(ulong,(RSizeLeft*100)/RMaxSize),
	format(NPTxt,"%d %%",Procent),
	retract(progress_bar_value(Win,ORc,OPTxt)),
	assert (progress_bar_value(Win,NRc,NPTxt)),
	progress_SetInvalidT(Win,OPtxt,NPTxt),
	progress_GetInvalidB(ORC,NRC,IL,IR),
	win_Invalidate(Win,rct(IL,Tb,IR,Rb)),!.

  progress_bar_set_value(Win,IMaxSize,ISizeLeft):-
	RCT1 = win_GetClientRect(Win),
	retract(progress_bar_status(Win,_,_)),
	assert(progress_bar_status(Win,IMaxSize, ISizeLeft)),

	RCT1 = rct(Lb,Tb,X,Bb),	% Window is vertical
	T=Tb+2,
	Y=Bb-2,
	
	RMaxSize = cast(real,IMaxSize),
	RSizeLeft = cast(real,ISizeLeft),
	RY1 = (((Y-T)*RSizeLeft) / RMaxSize),
	Y1 = Y - cast(integer,RY1),
	progress_max(Y1,T,Yc),
	progress_min(Yc,Y,NYc),
	Procent = val(ulong,(RSizeLeft*100)/RMaxSize),
	format(NPTxt,"%d %%",Procent),
	retract(progress_bar_value(Win,OYc,OPTxt)),
	assert (progress_bar_value(Win,NYc,NPTxt)),
	progress_SetInvalidT(Win,OPtxt,NPTxt),
	progress_GetInvalidB(OYC,NYC,IT,IB),
	win_Invalidate(Win,rct(LB,IT,X,IB)),!.
  progress_bar_set_value(_,_,_).


  draw_progress_frame(WIN):-
	RCT = win_GetClientRect(Win),
	RCT = rct(_,_,R,B),
	R1 = R - 1,B1 = B - 1,
	R2 = R - 2,B2 = B - 2,
	win_SetPen(Win,pen(1,ps_Solid,color_DkGray)),
	draw_Line(Win,pnt(0,0),pnt(R1,0)),
	draw_Line(Win,pnt(0,B2),pnt(0,0)),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	draw_Line(Win,pnt(1,1),pnt(R2,1)),
	draw_Line(Win,pnt(1,B2),pnt(1,1)),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_Line(Win,pnt(0,B1),pnt(R1,B1)),
	draw_Line(Win,pnt(R1,0),pnt(R1,B )),
	win_SetPen(Win,pen(1,ps_Solid,color_LtGray)),
	draw_Line(Win,pnt(R2,1),pnt(R2,B2)),
	draw_Line(Win,pnt(0,B2),pnt(R2,B2)).



%BEGIN_WIN Progress
/**************************************************************************
        Creation and event handling for window: Progress
**************************************************************************/
constants
progress_procent_flags = [dtext_center,dtext_singleline,dtext_vcenter]
progress_procent_text_len = -1

predicates
  win_progress_eh : EHANDLER

clauses

%BEGIN Progress, e_Create
  win_progress_eh(_Win,e_Create(_),0):-!,
	retractall(progress_bar_status(_Win,_,_)),
	assert(progress_bar_status(_Win,10,0)),
	assert(progress_bar_value(_WIN,15,"0%")),

	win_invalidate(_WIN),
	!.
%END Progress, e_Create

%BEGIN Progress, e_Destroy
  win_progress_eh(_Win,e_Destroy,0):-!,
	retractall(progress_bar_status(_Win,_,_)),
	retractall(progress_bar_colors(_Win,_,_,_)),
	retractall(progress_bar_value(_Win,_,_)),
	!.
%END Progress, e_Destroy

  win_progress_eh(_Win,e_EraseBackGround(),0):-!.

%BEGIN Progress, e_Update
  win_progress_eh(_Win,e_Update(_UpdateRct),0):-
	RCT1 = win_GetClientRect(_Win),
	RCT1 = rct(Lb,Tb,X,Y),
	X >= Y,	% Window is horizontal
	!,
	L=Lb+1,T=Tb+1,R=X-2,B=Y-2,
	progress_bar_value(_Win,Rc,ProcentTxt),
	progress_bar_get_colors(_Win, FColor,BColor,Patstyle),
	win_Clear(_Win,rct(Rc,T,R,B),BColor),
	win_Clear(_Win,rct(L,T,Rc,B),FColor),
	win_SetBrush(_Win,brush(Patstyle,BColor)),
	draw_progress_frame(_WIN),
	win_SetPen(_Win,pen(0,ps_Hollow,0)),
	draw_Rect(_Win,rct(L,T,R,B)),
	draw_TextInRect(_Win,RCT1, ProcentTxt, progress_procent_text_len,progress_procent_flags),
	!.
  win_progress_eh(_Win,e_Update(_UpdateRct),0):- !,
	RCT = win_GetClientRect(_Win),
	RCT = rct(Lb,Tb,X,Y),	% Window is vertical
	L=Lb+1,T=Tb+1,R=X-2,B=Y-2,
	progress_bar_value(_Win,YC,ProcentTxt),
	progress_bar_get_colors(_Win, FColor,BColor,Patstyle),
/* EA 23.09.96 */
	win_Clear(_Win,rct(L,T,X,Yc),BColor),

	win_SetBrush(_Win,brush(pat_Solid,color_White)),
	draw_Rect(_Win,rct(L,T,R,B)),

	win_SetBrush(_Win,brush(Patstyle,BColor)),
	draw_progress_frame(_WIN),
	win_SetPen(_Win,pen(0,ps_Hollow,0)),
	draw_Rect(_Win,rct(L,T,R,B)),
	win_Clear(_Win,rct(L,Yc,X,Y),FColor),
/* */
	draw_TextInRect(_Win,RCT, ProcentTxt, progress_procent_text_len,progress_procent_flags),
	!.
%END Progress, e_Update

/**************************************************************************
	Registering the bitmap control class
**************************************************************************/

clauses
  progress_register :-
	class_Create("PROGRESS",win_progress_eh).
	
  progress_unregister :-
	class_Destroy("PROGRESS").

%END_WIN Progress
