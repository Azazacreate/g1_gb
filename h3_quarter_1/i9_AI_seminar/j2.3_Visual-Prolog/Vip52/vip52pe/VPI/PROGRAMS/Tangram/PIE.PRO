/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  TANGRAM
 FileName: PIE.PRO
 Purpose: Tangram puzzle game
 Written by: Hans Dybkjær
 Comments:
******************************************************************************/

include "tangram.inc"
include "tangram.con"
include "hlptopic.con"

/**********************************************************************
PIE
**********************************************************************/
database - pie
	pieLastId(PIEID)	
predicates
	% Auxiliary predicates, just forget them
	pieNextId(WINDOW,SET,PIEID) - (i,i,o)
	pieSty(MODE,PENSTYLE,COLOR,PATSTYLE,COLOR)
	pieSetDrawSty(PIEID)	
	
	pieIdGetWin(PIEID,WINDOW) 	- (i,o)
	pieIdGetSet(PIEID,SET) 		- (i,o)
	pieList(PIEID)			- (i)
	pieNewAux(POLYGON,ORIENTATION,POLYGON) - (i,i,o)
	
clauses
% pieIds
pieNextId(Win,Set,Id) :- 
	pieLastId(pieId(Win,Set,N)),!,M=N+1,Id=pieId(Win,Set,M),
	retractall(pieLastId(pieId(Win,Set,_))), assert(pieLastId(Id)).
pieIdGetWin(pieId(Win,_,_),Win).
pieIdGetSet(pieId(_,Set,_),Set).
	
% hiding representation of pieces here
pieNew(Win,Set,Mod,Pol,Id) :-
	pieNextId(Win,Set,Id),pieDelete(Id),
	polOrientation(Pol,O),pieNewAux(Pol,O,Pol2),
	assert(pie(Id,Pol2,Mod)).
pieNewAux(Pol,right,Pol).
pieNewAux(pol(L),left,pol(R)):- ptsReverse(L,R).

pieCopy(Win,Set,Id0,Id) :-
	pieNextId(Win,Set,Id),
	pie(Id0,Pol,Mod), !,pieDelete(Id),
	assert(pie(Id,Pol,Mod)).
pieCopy(Id1,Id2) :-
	pie(Id1,Pol,Mod),!,
	pieDelete(Id2),
	assert(pie(Id2,Pol,Mod)).
	
pieDelete(Id) :-
	retractall(pie(Id,_,_)).
	
pieGetPol(Id,Pol) :- pie(Id,Pol,_),!.
pieGetMod(Id,Mod) :- pie(Id,_,Mod),!.		
		
pieSetPol(Id,Pol) :- 
	pie(Id,_,Mod),
	retractall(pie(Id,_,_)),
	assert(pie(Id,Pol,Mod)),!.
pieSetMod(Id,Mod) :- 		
	pie(Id,Pol,_),
	retractall(pie(Id,_,_)),
	assert(pie(Id,Pol,Mod)),!.

pieFlip(Id) :-
	pieGetPol(Id,Pol),
	polCenter(Pol,Pt),
	polFlip(line(vector(1,0),Pt),Pol,Pol2),
	pieSetPol(Id,Pol2).
	
pieTurn(Id,Ang):-
	pieGetPol(Id,Pol),
	polCenter(Pol,Pt),
	polTurn(Ang,Pt,Pol,Pol2),
	pieSetPol(Id,Pol2).
	
pieSlide(Id,Vec) :-
	pieGetPol(Id,Pol),
	polSlide(Vec,Pol,Pol2),
	pieSetPol(Id,Pol2).
	

%      State	Pen style		Brush style
pieSty(normal,	ps_Solid, color_Blue,	pat_Solid, color_Blue).
pieSty(detail,	ps_Solid, color_White,	pat_Solid, color_Blue).
pieSty(selected,ps_Solid, color_Red,	pat_Solid, color_Red).
pieSty(moving,	ps_Solid, color_Black,	pat_Hollow,color_Blue).
pieSty(locked,	ps_Solid, color_White,	pat_Solid, color_Green).
pieSty(secret,	ps_Solid, color_Yellow,	pat_Solid, color_Yellow).

pieSetDrawSty(Id) :-
	pieGetMod(Id,Mod),
	!, not(Mod=hide),!,Id=pieId(Win,_,_),
	pieSty(Mod,PenSty,PenCol,BrushSty,BrushCol),
	% Pen
	win_SetPen(Win,pen(1,PenSty,PenCol)),
	% Brush
	win_SetBrush(Win,brush(BrushSty,BrushCol)).

pieDraw(Id) :-
	% Draw
	pieGetPol(Id,pol(LL)),pieIdGetWin(Id,Win),
	mapLL2DL(Win,LL,DL),
	pieSetDrawSty(Id),
	draw_Polygon(Win,DL).

pieWrite(Id) :-
	pie(Id,Pol,Col),!,
	write("pie(",Id,",",Pol,",",Col,")").

/**********************************************************************
PIE SET
***********************************************************************/

database - pieset
	pie_list(PIELIST)

predicates
	piesSetModAux(PIELIST,MODE)	- (i,i)
	piesList(WINDOW,SET)		- (i,i)

clauses
	
pieIter(Win,Set,pieId(Win,Set,N)) :- pie(pieId(Win,Set,N),_,_).

pieFind(Win,Set,Pt,Id) :- 
	pieIter(Win,Set,Id),
	pieGetPol(Id,Pol),polInside(Pol,Pt),!. 
	
pieList(Id) :-
	pie_list(L),!,LL=[Id|L],retractall(pie_list(_)),assert(pie_list(LL)).
piesList(Win,Set) :- 
	retractall(pie_list(_)),assert(pie_list([])),
	pieIter(Win,Set,Id),pieList(Id),fail.
piesList(_,_).
	
piesSetMod(Win,Set,Mod) :-  
	piesList(Win,Set),pie_list(L),!,piesSetModAux(L,Mod).
piesSetModAux([Id|L],Mod) :-
	pieSetMod(Id,Mod), piesSetModAux(L,Mod).
piesSetModAux([],_):-!.

piesDraw(Win,Set) :- 
	pieIter(Win,Set,Id), pieDraw(Id), fail.
piesDraw(_,_).

piesWrite(Win,Set) :- 
	pieIter(Win,Set,Id), pieWrite(Id), nl, fail.
piesWrite(_,_).

pieOverlap(Id1,Set,Id2) :-
	Id1=pieid(Win,_,_),
	pieIter(Win,Set,Id2),not(Id1=Id2),
  	pieGetPol(Id1,Pol1),pieGetPol(Id2,Pol2),
  	polOverlap(Pol1,Pol2),
  	!. % enough that one crosses
	
pieNear(Id1,Set,Epsilon,Id2) :-
	Id1=pieid(Win,_,_),
	pieIter(Win,Set,Id2),
  	pieGetPol(Id1,Pol1),pieGetPol(Id2,Pol2),
  	polNear(Pol1,Pol2,Epsilon),!,
  	!.  	
  	
  	
puzzleInit(Win,Set) :-
	retractall(pie(pieId(Win,Set,_),_,_)),
	retractall(pieLastId(pieId(Win,Set,_))),
	assert(pieLastId(pieId(Win,Set,0))).


