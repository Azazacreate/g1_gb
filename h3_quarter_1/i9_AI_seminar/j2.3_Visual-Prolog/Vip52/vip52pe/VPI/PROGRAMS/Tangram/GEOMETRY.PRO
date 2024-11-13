/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  TANGRAM
 FileName: GEOMETRY.PRO
 Purpose: Tangram puzzle game
 Written by: Hans Dybkjær
 Comments:
******************************************************************************/

include "tangram.inc"

constants 
	realerror = 0.001
	
/****************************************************************************
NUMBERS
****************************************************************************/
predicates 
	deg2rad(REAL,REAL)
	min(REAL,REAL,REAL)
	max(REAL,REAL,REAL)

clauses

deg2rad(D,R) :- R=3.141592653*D/180.	
min(A,B,A) :- A <= B, !.
min(_,B,B).
max(A,B,B) :- A <= B, !.
max(A,_,A).


/****************************************************************************
VECTORS
****************************************************************************/
clauses
vectorLength(vector(X,Y),R) :- 
	XXplusYY=X*X+Y*Y,R = sqrt(XXplusYY),!.
vectorNormal(vector(X1,Y1),vector(X2,Y2)) :- X2 = -Y1, Y2 = X1.
vectorOrthogonal(vector(X1,Y1),vector(X2,Y2)) :-
	X2=-Y1,Y2=X1.
vectorDot(vector(X1,Y1),vector(X2,Y2),R) :- R = X1*X2+Y1*Y2.
vectorAdd(vector(X1,Y1),vector(X2,Y2),vector(X3,Y3)) :- 
	X3=X1+X2,Y3=Y1+Y2.
vectorSub(vector(X1,Y1),vector(X2,Y2),vector(X3,Y3)) :- 
	X3=X1-X2,Y3=Y1-Y2.
vectorMultiply(vector(X1,Y1),R,vector(X2,Y2)) :- X2=X1*R, Y2=Y1*R.
vectorNormalise(V,vector(X2,Y2)) :- 
	vectorLength(V,R), V = vector(X1,Y1), X2=X1/R, Y2=Y1/R.
	
vectorProject(V1,V2,V3) :- % Project V1 on V2
	vectorDot(V1,V2,D12), vectorDot(V2,V2,D22),
	M=D12/D22, vectorMultiply(V2,M,V3).
	
/****************************************************************************
POINTS LINES ETC
****************************************************************************/
predicates
	% local line predicates
	pt2line(PT,PT,LINE)

clauses
pt2line(pt(X1,Y1),pt(X2,Y2),line(V,pt(X1,Y1))) :- 
	Dx=X2-X1, Dy=Y1-Y2, V=vector(Dy,Dx).	% positive to the right
						% in coordinate system 
						% with y-axis going down!
	
pt2vec(pt(X1,Y1),pt(X2,Y2),vector(Dx,Dy)) :- 
	Dx=X2-X1, Dy=Y2-Y1.
	
ptDist(P1,P2,D) :-
	pt2vec(P1,P2,V),vectorLength(V,D).
	

ptsReverse([],[]).
PtsReverse([H|L],L2) :-
	ptsReverse(L,L3), ptsAppend(L3,[H],L2).
ptsAppend([],L,L).
ptsAppend([H|L1],L2,[H|L3]) :-
	ptsAppend(L1,L2,L3).
	
turn(angle(Angle),pt(X0,Y0),pt(X1,Y1),pt(X2,Y2)) :-
	deg2rad(Angle,Rads),
	P=X1-X0, Q=Y1-Y0, C=cos(Rads), S=sin(Rads),
	X2=P*C-Q*S+X0, Y2=P*S+Q*C+Y0, !.
	
slide(vector(Dx,Dy),pt(X,Y),pt(X2,Y2)) :- 
	X2=X+Dx, Y2=Y+Dy.
	
flip(line(V,pt(X,Y)),pt(X1,Y1),pt(Xf,Yf)) :-
	V1=vector(X1,Y1),
	Dx=X1-X, Dy=Y1-Y, VD=vector(Dx,Dy),
	vectorOrthogonal(V,V2),
	vectorProject(VD,V2,V3),
	vectorSub(V3,VD,V4),
	vectorMultiply(V4,2,V5),
	vectorAdd(V1,V5,vector(Xf,Yf))
	.
	
/****************************************************************************
POLYGONS
****************************************************************************/
predicates
	polArity(POLYGON,INTEGER)
	
	% Auxiliary predicates, just forget them
	polArityAux(PTLIST,INTEGER,INTEGER)
	polCenterAux(PTLIST,REAL,REAL,REAL,REAL,REAL,REAL)
	polTurnAux(ANGLE,PT,PTLIST,PTLIST)
	polFlipAux(LINE,PTLIST,PTLIST)
	polSlideAux(VECTOR,PTLIST,PTLIST)
	polInsideAux1(ORIENTATION,POLYGON,PT)
	polInsideAux2(LINEPROCESS,PT,PT,PTLIST,PT)
	polCrossingAux(PT,PT,PTLIST,POLYGON)
	polCrossingAux2(PT,PT,PT,PT,PTLIST)
	polNearAux(PT,PTLIST,PTLIST,PTLIST,REAL)
	polNearAux2(PTLIST,PTLIST,REAL)
	polOrientationAux(ORIENTATION,REAL)
	
clauses
polOrientation(pol([P1|[P2|[P3|_]]]),O) :- 
	% right is clockwise, left counterclockwise
	% NOTE: convex polygons only, and at least 3 points
	pt2vec(P1,P2,U),vectorNormal(U,V),pt2vec(P2,P3,W),
	vectorDot(V,W,D),polOrientationAux(O,D).
polOrientationAux(right,D) :- D <= 0, !.
polOrientationAux(left,D) :- D > 0, !.
	
		
polArity(pol(L),N) :- polArityAux(L,0,N).
polArityAux([],N,N).
polArityAux([_|T],M,N) :- K=M+1, polArityAux(T,K,N).

polCenter(pol([pt(X1,Y1)|L]),pt(X,Y)) :- % center is mid of circumscribed rect.
	polCenterAux(L,X1,X1,Y1,Y1,X,Y).
polCenterAux([],Xmin,Xmax,Ymin,Ymax,X,Y) :-
	X=Xmin+(Xmax-Xmin)/2,
	Y=Ymin+(Ymax-Ymin)/2.
polCenterAux([pt(Xj,Yj)|T],Xmin,Xmax,Ymin,Ymax,X,Y) :-
	min(Xj,Xmin,NewXmin), min(Yj,Ymin,NewYmin),
	max(Xj,Xmax,NewXmax), max(Yj,Ymax,NewYmax),
	polCenterAux(T,NewXmin,NewXmax,NewYmin,NewYmax,X,Y).
	
polTurn(Ang,P,pol(Pts1),pol(Pts2)) :- 
	polTurnAux(Ang,P,Pts1,Pts2).
polTurnAux(_,_,[],[]).
polTurnAux(Ang,P,[P1|T1],[P2|T2]) :-
	turn(Ang,P,P1,P2), polTurnAux(Ang,P,T1,T2).

polFlip(L,pol(Pts1),pol(Pts2)) :- 
	polFlipAux(L,Pts1,Pts3),
	ptsReverse(Pts3,Pts2). % To keep orientation
polFlipAux(_,[],[]).
polFlipAux(L,[P1|T1],[P2|T2]) :-
	flip(L,P1,P2), polFlipAux(L,T1,T2).
	
polSlide(V,pol(Pts1),pol(Pts2)) :- 
	polSlideAux(V,Pts1,Pts2).
polSlideAux(_,[],[]).
polSlideAux(L,[P1|T1],[P2|T2]) :-
	slide(L,P1,P2), polSlideAux(L,T1,T2).
	
planePos(line(V,P0),P) :- 	
% succeed if P in non-negative halfplane (V points to it)
	pt2vec(P0,P,U), vectorDot(V,U,D), D > realerror.
planeNeg(line(V,P0),P) :- 	
% succeed if P in non-negative halfplane (V points to it)
	pt2vec(P0,P,U), vectorDot(V,U,D), D < -realerror.
	
polInside(Pol,P) :- 
	polOrientation(Pol,O),
	polInsideAux1(O,Pol,P).
polInsideAux1(right,pol([P|T]),P0) :-
	polInsideAux2(planeNeg,P,P,T,P0).
polInsideAux1(left,pol([P|T]),P0) :-
	polInsideAux2(planePos,P,P,T,P0).
polInsideAux2(Plane,P,P1,[P2|T],P0) :-
	pt2line(P1,P2,L), 
	Plane(L,P0), polInsideAux2(Plane,P,P2,T,P0).
polInsideAux2(Plane,P1,PN,[],P0) :-
	pt2line(PN,P1,L),
	Plane(L,P0).
	
lpCrossing(P1,P2,Q1,Q2) :- 
	% succeed if (P1P2) crosses (Q1Q2)
	pt2vec(P1,P2,P),vectorNormal(P,NP),
	pt2vec(P1,Q1,U1),pt2Vec(P1,Q2,U2),
	vectorDot(NP,U1,A1),vectorDot(NP,U2,A2),
	A1*A2<0, % Q1 and Q2 are on each side of P1P2 if this is true
	pt2vec(Q1,Q2,Q),vectorNormal(Q,NQ),
	pt2vec(Q1,P1,V1),pt2vec(Q1,P2,V2),
	vectorDot(NQ,V1,B1),vectorDot(NQ,V2,B2),
	B1*B2<0. % P1 and P2 are on each side of Q1Q2 if this is true

polOverlap(pol([P|L]),Pol2) :-
	polCrossingAux(P,P,L,Pol2).

polCrossingAux(_,P,_,Pol2) :-  
	polInside(Pol2,P),!.
polCrossingAux(_,P1,[P2|_],pol([Q|L2])) :-
	polCrossingAux2(P1,P2,Q,Q,L2),!.
polCrossingAux(P1,PN,[],pol([Q|L])) :- !,% circularly closing polygon P
	polCrossingAux2(PN,P1,Q,Q,L),!.	
polCrossingAux(P,_,[P2|L],Pol2) :-
	polCrossingAux(P,P2,L,Pol2).
	
polCrossingAux2(P1,P2,_,Q1,[Q2|_]) :-
	lpCrossing(P1,P2,Q1,Q2),!.	
polCrossingAux2(P1,P2,Q1,QN,[]) :- !,% circularly closing polygon Q
	lpCrossing(P1,P2,QN,Q1),!. 
polCrossingAux2(P1,P2,Q,_,[Q2|L]) :-
	polCrossingAux2(P1,P2,Q,Q2,L).
	
polNear(pol([P1|L1]),pol(L2),Epsilon) :-
	% Take care that Pol1 and Pol2 may start theirs pts in different corners 
	polNearAux(P1,L1,L2,[],Epsilon).
	
polNearAux(P1,L1,[P2|L2],L3,Epsilon) :-
	% locate, if anywhere, where in pol2 the P1 is.
	ptDist(P1,P2,D), D <= Epsilon, !, 
	% Assume no two points in a polygon are closer than epsilon.
	ptsReverse(L3,R3),ptsAppend(L2,R3,L),polNearAux2(L1,L,Epsilon).
polNearAux(P1,L1,[P2|L2],L3,Epsilon) :-
	polNearAux(P1,L1,L2,[P2|L3],Epsilon).

polNearAux2([P1|L1],[P2|L2],Epsilon) :-
	ptDist(P1,P2,D), D <= Epsilon, !,
	polNearAux2(L1,L2,Epsilon).
polNearAux2([],[],_).

