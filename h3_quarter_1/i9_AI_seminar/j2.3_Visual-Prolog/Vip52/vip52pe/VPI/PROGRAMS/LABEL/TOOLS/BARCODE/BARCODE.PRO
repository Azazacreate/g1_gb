/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	BARCODE.PRO
 Purpose:	Barcode drawing object
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
database - barcode_db
  barcode_natural_size(WINDOW,PNT DevOrg,PNT DevExt,PNT LogOrg,PNT LogExt)
predicates
  barcode_upc_data(ILIST)
clauses
  barcode_upc_data([3,2,1,1,	% 0
		   2,2,2,1,	% 1
		   2,1,2,2,	% 2
  		   1,4,1,1,	% 3
  		   1,1,3,2,	% 4
  		   1,2,3,1,	% 5
  		   1,1,1,4,	% 6
  		   1,3,1,2,	% 7
  		   1,2,1,3,	% 8
  		   3,1,1,2]).	% 9

predicates
  barcode_25_data(ILIST)
clauses
  barcode_25_data([1,1,2,2,1,	% 0
		  2,1,1,1,2,	% 1
		  1,2,1,1,2,	% 2
		  2,2,1,1,1,	% 3
		  1,1,2,1,2,	% 4
		  2,1,2,1,1,	% 5
		  1,2,2,1,1,	% 6
		  1,1,1,2,2,	% 7
		  2,1,1,2,1,	% 8
		  1,2,1,2,1]).	% 9

predicates
  barcode_39_data1(STRING)
clauses
  barcode_39_data1(" $%+-./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ").

predicates
  barcode_39_data(CHAR,ILIST)
clauses
  barcode_39_data(' ',[1,2,2,1,1,1,2,1,1]).
  barcode_39_data('$',[1,2,1,2,1,2,1,1,1]).
  barcode_39_data('%',[1,1,1,2,1,2,1,2,1]).
  barcode_39_data('+',[1,2,1,1,1,2,1,2,1]).
  barcode_39_data('-',[1,2,1,1,1,1,2,1,2]).
  barcode_39_data('.',[2,2,1,1,1,1,2,1,1]).
  barcode_39_data('/',[2,2,1,2,1,1,1,2,1]).	% ?????????
  barcode_39_data('0',[1,1,1,2,2,1,2,1,1]).
  barcode_39_data('1',[2,1,1,2,1,1,1,1,2]).
  barcode_39_data('2',[1,1,2,2,1,1,1,1,2]).
  barcode_39_data('3',[2,1,2,2,1,1,1,1,1]).
  barcode_39_data('4',[1,1,1,2,2,1,1,1,2]).
  barcode_39_data('5',[2,1,1,2,2,1,1,1,1]).
  barcode_39_data('6',[1,1,2,2,2,1,1,1,1]).
  barcode_39_data('7',[1,1,1,2,1,1,2,1,2]).
  barcode_39_data('8',[2,1,1,2,1,1,2,1,1]).
  barcode_39_data('9',[1,1,2,2,1,1,2,1,1]).
  barcode_39_data('A',[2,1,1,1,1,2,1,1,2]).
  barcode_39_data('B',[1,1,2,1,1,2,1,1,2]).
  barcode_39_data('C',[2,1,2,1,1,2,1,1,1]).
  barcode_39_data('D',[1,1,1,1,2,2,1,1,2]).
  barcode_39_data('E',[2,1,1,1,2,2,1,1,1]).
  barcode_39_data('F',[1,1,2,1,2,2,1,1,1]).
  barcode_39_data('G',[1,1,1,1,1,2,2,1,2]).
  barcode_39_data('H',[2,1,1,1,1,2,2,1,1]).
  barcode_39_data('I',[1,1,2,1,1,2,2,1,1]).
  barcode_39_data('J',[1,1,1,1,2,2,2,1,1]).
  barcode_39_data('K',[2,1,1,1,1,1,1,2,2]).
  barcode_39_data('L',[1,1,2,1,1,1,1,2,2]).
  barcode_39_data('M',[2,1,2,1,1,1,1,2,1]).
  barcode_39_data('N',[1,1,1,1,2,1,1,2,2]).
  barcode_39_data('O',[2,1,1,1,2,1,1,2,1]).
  barcode_39_data('P',[1,1,2,1,2,1,1,2,1]).
  barcode_39_data('Q',[1,1,1,1,1,1,2,2,2]).
  barcode_39_data('R',[2,1,1,1,1,1,2,2,1]).
  barcode_39_data('S',[1,1,2,1,1,1,2,2,1]).
  barcode_39_data('T',[1,1,1,1,2,1,2,2,1]).
  barcode_39_data('U',[2,2,1,1,1,1,1,1,2]).
  barcode_39_data('V',[1,2,2,1,1,1,1,1,2]).
  barcode_39_data('W',[2,2,2,1,1,1,1,1,1]).
  barcode_39_data('X',[1,2,1,1,2,1,1,1,2]).
  barcode_39_data('Y',[2,2,1,1,2,1,1,1,1]).
  barcode_39_data('Z',[1,2,2,1,2,1,1,1,1]).

predicates
  check_invers(CHAR Simb,INTEGER Pos)
clauses
  check_invers('0',1):-!.
  check_invers('0',2):-!.
  check_invers('0',3):-!.
  check_invers('0',4):-!.
  check_invers('0',5):-!.

  check_invers('1',1):-!.
  check_invers('1',2):-!,fail.
  check_invers('1',3):-!.
  check_invers('1',4):-!,fail.
  check_invers('1',5):-!,fail.

  check_invers('2',1):-!.
  check_invers('2',2):-!,fail.
  check_invers('2',3):-!,fail.
  check_invers('2',4):-!.
  check_invers('2',5):-!,fail.

  check_invers('3',1):-!.
  check_invers('3',2):-!,fail.
  check_invers('3',3):-!,fail.
  check_invers('3',4):-!,fail.
  check_invers('3',5):-!.

  check_invers('4',1):-!,fail.
  check_invers('4',2):-!.
  check_invers('4',3):-!.
  check_invers('4',4):-!,fail.
  check_invers('4',5):-!,fail.

  check_invers('5',1):-!,fail.
  check_invers('5',2):-!,fail.
  check_invers('5',3):-!.
  check_invers('5',4):-!.
  check_invers('5',5):-!,fail.

  check_invers('6',1):-!,fail.
  check_invers('6',2):-!,fail.
  check_invers('6',3):-!,fail.
  check_invers('6',4):-!.
  check_invers('6',5):-!.

  check_invers('7',1):-!,fail.
  check_invers('7',2):-!.
  check_invers('7',3):-!,fail.
  check_invers('7',4):-!.
  check_invers('7',5):-!,fail.

  check_invers('8',1):-!,fail.
  check_invers('8',2):-!.
  check_invers('8',3):-!,fail.
  check_invers('8',4):-!,fail.
  check_invers('8',5):-!.

  check_invers('9',1):-!,fail.
  check_invers('9',2):-!,fail.
  check_invers('9',3):-!.
  check_invers('9',4):-!,fail.
  check_invers('9',5):-!.

  check_invers(_,_):-!.

predicates
  barcode_check_str(STRING)
  barcode_check_str(STRING,STRING)
clauses
  barcode_check_str(""):-!.
  barcode_check_str(String):-
	frontstr(1,String,SDig,Rest),
	str_int(SDig,_),!,
	barcode_check_str(Rest).

  barcode_check_str("",_):-!.
  barcode_check_str(Str,String):-
	frontchar(Str,Char,Rest),
	searchchar(String,Char,_),!,
	barcode_check_str(Rest,String).

predicates
  barcode_check_barcode(STRING,BARCODE_TYPE)
clauses
  barcode_check_barcode(_,none):-!.
  barcode_check_barcode(String,upc_a):-
	str_len(String,Length),
	Length = 12,
	barcode_check_str(String),!.
  barcode_check_barcode(String,ean_13):-
	str_len(String,Length),
	Length = 13,
	barcode_check_str(String),!.
  barcode_check_barcode(String,ean_8):-
	str_len(String,Length),
	Length = 8,
	barcode_check_str(String),!.
  barcode_check_barcode(String,s_2_5):-
	barcode_check_str(String),!.
  barcode_check_barcode(String,s_39):-
	barcode_39_data1(LegalStr),
	barcode_check_str(String,LegalStr),!.

predicates
  barcode_get_upc(INTEGER Dig,INTEGER X,INTEGER X1,INTEGER X2,INTEGER X3,INTEGER X0)
  barcode_get_upc1(ILIST,INTEGER Dig,INTEGER A1,INTEGER A2,INTEGER A3,INTEGER A4)
clauses
  barcode_get_upc(Dig,X,X1,X2,X3,X0):-
	barcode_upc_data(List),
	barcode_get_upc1(List,Dig,A1,A2,A3,A4),
	X1 = X + A1,
	X2 = X1 + A2,
	X3 = X2 + A3,
	X0 = X3 + A4,!.

  barcode_get_upc1([A1,A2,A3,A4|_],0,A1,A2,A3,A4):-!.
  barcode_get_upc1([_,_,_,_|Rest],Dig,A1,A2,A3,A4):-
	D = Dig - 1,
	barcode_get_upc1(Rest,D,A1,A2,A3,A4).

predicates
  barcode_get_25(INTEGER Dig,INTEGER X,INTEGER X1,INTEGER X2,INTEGER X3,INTEGER X4,INTEGER X5,
	INTEGER X6,INTEGER X7,INTEGER X8,INTEGER X9,INTEGER X0)
  barcode_get_25_1(ILIST,INTEGER Dig,INTEGER A1,INTEGER A2,INTEGER A3,INTEGER A4,INTEGER A5)
clauses
  barcode_get_25(Dig,X,X1,X2,X3,X4,X5,X6,X7,X8,X9,X0):-
	barcode_25_data(List),
	barcode_get_25_1(List,Dig,A1,A2,A3,A4,A5),
	X1 = X + A1,
	X2 = X1 + 1,
	X3 = X2 + A2,
	X4 = X3 + 1,
	X5 = X4 + A3,
	X6 = X5 + 1,
	X7 = X6 + A4,
	X8 = X7 + 1,
	X9 = X8 + A5,
	X0 = X9 + 1,!.

  barcode_get_25_1([A1,A2,A3,A4,A5|_],0,A1,A2,A3,A4,A5):-!.
  barcode_get_25_1([_,_,_,_,_|Rest],Dig,A1,A2,A3,A4,A5):-
	D = Dig - 1,
	barcode_get_25_1(Rest,D,A1,A2,A3,A4,A5).

predicates
  barcode_get_39(CHAR Sim,INTEGER X,INTEGER X1,INTEGER X2,INTEGER X3,INTEGER X4,INTEGER X5,
	INTEGER X6,INTEGER X7,INTEGER X8,INTEGER X9,INTEGER X0)
clauses
  barcode_get_39(Sim,X,X1,X2,X3,X4,X5,X6,X7,X8,X9,X0):-
	barcode_39_data(Sim,[A1,A2,A3,A4,A5,A6,A7,A8,A9]),
	X1 = X + A1,
	X2 = X1 + A2,
	X3 = X2 + A3,
	X4 = X3 + A4,
	X5 = X4 + A5,
	X6 = X5 + A6,
	X7 = X6 + A7,
	X8 = X7 + A8,
	X9 = X8 + A9,
	X0 = X9 + 1,!.

predicates
  barcode_draw_bar_right(WINDOW Win,INTEGER X,INTEGER T,INTEGER B,INTEGER Dig,INTEGER X1)
  barcode_draw_bar_left(WINDOW Win,INTEGER X,INTEGER T,INTEGER B,INTEGER Dig,INTEGER X1)
  barcode_draw_bar_left1(WINDOW Win,INTEGER X,INTEGER T,INTEGER B,INTEGER Dig,INTEGER X1)
clauses
  barcode_draw_bar_right(Win,X,T,B,-1,X0):-
	X1 = X + 1, X2 = X1 + 1, X3 = X2 + 1, X4 = X3 + 1, X0 = X4 + 1,
	draw_Rect(Win,rct(X1,T,X2,B)),
	draw_Rect(Win,rct(X3,T,X4,B)),!.
  barcode_draw_bar_right(Win,X,T,B,-2,X0):-
	X1 = X + 1, X2 = X1 + 1, X0 = X2 + 1,
	draw_Rect(Win,rct(X,T,X1,B)),
	draw_Rect(Win,rct(X2,T,X0,B)),!.

  barcode_draw_bar_right(Win,X,T,B,Dig,X0):-
	barcode_get_upc(Dig,X,X1,X2,X3,X0),
	draw_Rect(Win,rct(X,T,X1,B)),
	draw_Rect(Win,rct(X2,T,X3,B)),!.

  barcode_draw_bar_left(Win,X,T,B,Dig,X0):-
	barcode_get_upc(Dig,X,X1,X2,X3,X0),
	draw_Rect(Win,rct(X1,T,X2,B)),
	draw_Rect(Win,rct(X3,T,X0,B)),!.

  barcode_draw_bar_left1(Win,X,T,B,Dig,X0):-
	barcode_get_upc(Dig,X,X1,X2,X3,X0),
	X11 = X + (X0 - X3),
	X12 = X11 + (X3 - X2),
	X13 = X12 + (X2 - X1),
	X14 = X13 + (X1 - X),
	draw_Rect(Win,rct(X11,T,X12,B)),
	draw_Rect(Win,rct(X13,T,X14,B)),!.

predicates
  barcode_draw_bar_25(WINDOW Win,INTEGER X,INTEGER Dig,INTEGER X1)
clauses
  barcode_draw_bar_25(Win,X,-1,X0):-
	X1 = X + 2, X2 = X1 + 1, X3 = X2 + 2, X4 = X3 + 1, X5 = X4 + 1, X0 = X5 + 1,
	draw_Rect(Win,rct(X,0,X1,10)),
	draw_Rect(Win,rct(X2,0,X3,10)),
	draw_Rect(Win,rct(X4,0,X5,10)),!.
  barcode_draw_bar_25(Win,X,-2,X0):-
	X1 = X + 2, X2 = X1 + 1, X3 = X2 + 1, X4 = X3 + 1, X5 = X4 + 2, X0 = X5 + 1,
	draw_Rect(Win,rct(X,0,X1,10)),
	draw_Rect(Win,rct(X2,0,X3,10)),
	draw_Rect(Win,rct(X4,0,X5,10)),!.
  barcode_draw_bar_25(Win,X,Dig,X0):-
	barcode_get_25(Dig,X,X1,X2,X3,X4,X5,X6,X7,X8,X9,X0),
	draw_Rect(Win,rct(X,0,X1,10)),
	draw_Rect(Win,rct(X2,0,X3,10)),
	draw_Rect(Win,rct(X4,0,X5,10)),
	draw_Rect(Win,rct(X6,0,X7,10)),
	draw_Rect(Win,rct(X8,0,X9,10)),!.

predicates
  barcode_draw_bar_39(WINDOW Win,INTEGER X,CHAR Sim,INTEGER X1)
clauses
  barcode_draw_bar_39(Win,X,'!',X0):-
	X1 = X + 1, X2 = X1 + 2, X3 = X2 + 1, X4 = X3 + 1, X5 = X4 + 2, X6 = X5 + 1,
	X7 = X6 + 2, X8 = X7 + 1, X9 = X8 + 1, X0 = X9 + 1,
	draw_Rect(Win,rct(X,0,X1,10)),
	draw_Rect(Win,rct(X2,0,X3,10)),
	draw_Rect(Win,rct(X4,0,X5,10)),
	draw_Rect(Win,rct(X6,0,X7,10)),
	draw_Rect(Win,rct(X8,0,X9,10)),!.
  barcode_draw_bar_39(Win,X,Sim,X0):-
	barcode_get_39(Sim,X,X1,X2,X3,X4,X5,X6,X7,X8,X9,X0),
	draw_Rect(Win,rct(X,0,X1,10)),
	draw_Rect(Win,rct(X2,0,X3,10)),
	draw_Rect(Win,rct(X4,0,X5,10)),
	draw_Rect(Win,rct(X6,0,X7,10)),
	draw_Rect(Win,rct(X8,0,X9,10)),!.

predicates
  barcode_draw_bars(WINDOW Win,CHAR FirstSimb,INTEGER Num,BOOLEAN Long,INTEGER X,STRING)
clauses
  barcode_draw_bars(Win,Simb,Num,b_true,X,String):-
	str_len(String,Length),
	Length = Num,
	barcode_draw_bar_right(Win,X,0,10,-2,X1),
	frontstr(1,String,SDig,Rest),
	str_int(SDig,Dig),
	barcode_draw_bar_left(Win,X1,0,10,Dig,X2),!,
	barcode_draw_bars(Win,Simb,Num,b_true,X2,Rest).
  barcode_draw_bars(Win,Simb,Num,b_false,X,String):-
	str_len(String,Length),
	Length = Num,
	barcode_draw_bar_right(Win,X,0,10,-2,X1),
	frontstr(1,String,SDig,Rest),
	str_int(SDig,Dig),
	barcode_draw_bar_left(Win,X1,0,8,Dig,X2),!,
	barcode_draw_bars(Win,Simb,Num,b_false,X2,Rest).
  barcode_draw_bars(Win,Simb,Num,Long,X,String):-
	str_len(String,Length),
	Length = Num div 2,
	barcode_draw_bar_right(Win,X,0,10,-1,X1),
	frontstr(1,String,SDig,Rest),
	str_int(SDig,Dig),
	barcode_draw_bar_right(Win,X1,0,8,Dig,X2),!,
	barcode_draw_bars(Win,Simb,Num,Long,X2,Rest).
  barcode_draw_bars(Win,_,_,b_true,X,String):-
	str_len(String,Length),
	Length = 1,
	str_int(String,Dig),
	barcode_draw_bar_right(Win,X,0,10,Dig,X1),
	barcode_draw_bar_right(Win,X1,0,10,-2,_),!.
  barcode_draw_bars(Win,_,_,b_false,X,String):-
	str_len(String,Length),
	Length = 1,
	str_int(String,Dig),
	barcode_draw_bar_right(Win,X,0,8,Dig,X1),
	barcode_draw_bar_right(Win,X1,0,10,-2,_),!.
  barcode_draw_bars(Win,Simb,Num,Long,X,String):-
	str_len(String,Length),
	Length < Num div 2,
	frontstr(1,String,SDig,Rest),
	str_int(SDig,Dig),
	barcode_draw_bar_right(Win,X,0,8,Dig,X1),!,
	barcode_draw_bars(Win,Simb,Num,Long,X1,Rest).
  barcode_draw_bars(Win,Simb,Num,Long,X,String):-
	frontstr(1,String,SDig,Rest),
	str_int(SDig,Dig),
	str_len(String,Length),
	Pos = Num - Length,
	check_invers(Simb,Pos),
	barcode_draw_bar_left(Win,X,0,8,Dig,X1),!,
	barcode_draw_bars(Win,Simb,Num,Long,X1,Rest).
  barcode_draw_bars(Win,Simb,Num,Long,X,String):-
	frontstr(1,String,SDig,Rest),
	str_int(SDig,Dig),
	barcode_draw_bar_left1(Win,X,0,8,Dig,X1),
	barcode_draw_bars(Win,Simb,Num,Long,X1,Rest).

predicates
  barcode_draw_bars_25_1(WINDOW Win,INTEGER X,STRING,INTEGER X1)
clauses
  barcode_draw_bars_25_1(_,X,"",X):-!.
  barcode_draw_bars_25_1(Win,X,String,X0):-
	frontstr(1,String,SDig,Rest),
	str_int(SDig,Dig),
	barcode_draw_bar_25(Win,X,Dig,X1),!,
	barcode_draw_bars_25_1(Win,X1,Rest,X0).

predicates
  barcode_draw_bars_39_1(WINDOW Win,INTEGER X,STRING,INTEGER X1)
clauses
  barcode_draw_bars_39_1(_,X,"",X):-!.
  barcode_draw_bars_39_1(Win,X,String,X0):-
	frontchar(String,Sim,Rest),
	barcode_draw_bar_39(Win,X,Sim,X1),!,
	barcode_draw_bars_39_1(Win,X1,Rest,X0).

predicates
  barcode_draw_bars_25(WINDOW Win,INTEGER X,STRING)
clauses
  barcode_draw_bars_25(Win,X,String):-
	barcode_draw_bar_25(Win,X,-1,X1),
	barcode_draw_bars_25_1(Win,X1,String,X2),
	barcode_draw_bar_25(Win,X2,-2,_),!.

predicates
  barcode_draw_bars_39(WINDOW Win,INTEGER X,STRING)
clauses
  barcode_draw_bars_39(Win,X,String):-
	barcode_draw_bar_39(Win,X,'!',X1),
	barcode_draw_bars_39_1(Win,X1,String,X2),
	barcode_draw_bar_39(Win,X2,'!',_),!.

predicates
  barcode_get_rb1(BOOLEAN Print,INTEGER Lb1,INTEGER Rb0,INTEGER WidthBars,INTEGER Rb1)
clauses
  barcode_get_rb1(b_false,_,Rb1,_,Rb1):-!.
  barcode_get_rb1(b_true,Lb1,Rb0,WidthBars,Rb1):-
	Step = (Rb0 - Lb1) div WidthBars,
	Step > 0,
	Rb1 = Lb1 + Step * WidthBars,!.
  barcode_get_rb1(_,_,Rb1,_,Rb1).

predicates
  barcode_set_natural_size(WINDOW,RCT,RCT)
clauses
  barcode_set_natural_size(Win,rct(L0,T0,R0,B0),rct(L1,T1,R1,B1)):-
	L = val(ulong,L0), T = val(ulong,T0), R = val(ulong,R0), B = val(ulong,B0),
	win_GetMapScale(Win,DevOrg,DevExt,LogOrg,LogExt),
	DevOrg = pnt(X11,Y11), DevExt = pnt(X12,Y12),
	LogOrg = pnt(X21,Y21), LogExt = pnt(X22,Y22),
	DX1 = X12 - X11, DY1 = Y12 - Y11,
	DX2 = X22 - X21, DY2 = Y22 - Y21,
	L1 = L * DX2 / DX1, T1 = T * DY2 / DY1,
	R1 = R * DX2 / DX1, B1 = B * DY2 / DY1,
	assert(barcode_natural_size(Win,DevOrg,DevExt,LogOrg,LogExt)),
	win_SetMapScale(Win,pnt(0,0),pnt(10,10),pnt(0,0),pnt(10,10)),!.
predicates
  barcode_set_previos_size(WINDOW)
clauses
  barcode_set_previos_size(Win):-
	retract(barcode_natural_size(Win,DevOrg,DevExt,LogOrg,LogExt)),
	win_SetMapScale(Win,DevOrg,DevExt,LogOrg,LogExt),!.

predicates
  PICTURE barcode_draw_lines(STRING,BARCODE_TYPE,INTEGER Width)
  PICTURE barcode_draw_texts(WINDOW,STRING)
clauses
  barcode_draw(Win,Print,Rect,pen(Width,Style,Color),String,upc_a):-
	barcode_check_barcode(String,upc_a),
	barcode_set_natural_size(Win,Rect,rct(L,T,R,B)),
	D = Width div 2,
	Lb1 = L + D, Tb1 = T + D, Rb0 = R - D, Bb1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	draw_Rect(Win,rct(Lb1,Tb1,Rb0,Bb1)),
	frontstr(1,String,String1,Rest),
	frontstr(5,Rest,String2,Rest1),
	frontstr(5,Rest1,String3,String4),
	PictLine = barcode_draw_lines(String,upc_a,WidthBars),
	barcode_get_rb1(Print,Lb1,Rb0,WidthBars,Rb1),
	PictText1 = barcode_draw_texts(Win,String1),
	PictText2 = barcode_draw_texts(Win,String2),
	PictText3 = barcode_draw_texts(Win,String3),
	PictText4 = barcode_draw_texts(Win,String4),
	TextHeight = (Bb1 - Tb1) div 9,
	L1 = Lb1 + 5 + (Rb1 - Lb1) div 15, T1 = Tb1 + 5, R1 = Rb1 - 5 - (Rb1 - Lb1) div 15, B1 = Bb1 - 10 - TextHeight,
	pict_GetSize(PictLine,X1,Y1,_),
	pict_Draw(Win,PictLine,rct(L1,T1,R1,B1),rct(0,0,X1,Y1),rop_SrcCopy),
	pict_Destroy(PictLine),
	SimbLen0 = (Rb1 - Lb1 - 10) / 17,
	SimbLen = val(integer,SimbLen0),
	TextHeight1 = (Bb1 - Tb1) div 4, T2 = Bb1 - 7 - TextHeight1, B2 = Bb1 - 5,
	L21 = Lb1 + 5, R21 = L21 + SimbLen, 
	pict_GetSize(PictText1,X21,Y21,_),
	pict_Draw(Win,PictText1,rct(L21,T2,R21,B2),rct(0,0,X21,Y21),rop_SrcCopy),
	pict_Destroy(PictText1),
	DText1 = (Rb1 - Lb1 - 10) div 8,
	DText2 = (Rb1 - Lb1 - 10) div 25,
	SimbLen1 = SimbLen * 5,
	L22 = R21 + DText1, R22 = (Rb1 + Lb1) div 2 - Dtext2,
	pict_GetSize(PictText2,X22,Y22,_),
	pict_Draw(Win,PictText2,rct(L22,T2,R22,B2),rct(0,0,X22,Y22),rop_SrcCopy),
	pict_Destroy(PictText2),
	L23 = (Rb1 + Lb1) div 2 + Dtext2, R23 = L23 + SimbLen1,
	pict_GetSize(PictText3,X23,Y23,_),
	pict_Draw(Win,PictText3,rct(L23,T2,R23,B2),rct(0,0,X23,Y23),rop_SrcCopy),
	pict_Destroy(PictText3),
	R24 = Rb1 - 5, L24 = R24 - SimbLen,
	pict_GetSize(PictText4,X24,Y24,_),
	pict_Draw(Win,PictText4,rct(L24,T2,R24,B2),rct(0,0,X24,Y24),rop_SrcCopy),
	pict_Destroy(PictText4),
	barcode_set_previos_size(Win),!.
  barcode_draw(Win,Print,Rect,pen(Width,Style,Color),String,ean_13):-
	barcode_check_barcode(String,ean_13),
	barcode_set_natural_size(Win,Rect,rct(L,T,R,B)),
	D = Width div 2,
	Lb1 = L + D, Tb1 = T + D, Rb0 = R - D, Bb1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	draw_Rect(Win,rct(Lb1,Tb1,Rb0,Bb1)),
	frontstr(1,String,String1,Rest),
	frontstr(6,Rest,String2,String3),
	PictLine = barcode_draw_lines(String,ean_13,WidthBars),
	barcode_get_rb1(Print,Lb1,Rb0,WidthBars,Rb1),
	PictText1 = barcode_draw_texts(Win,String1),
	PictText2 = barcode_draw_texts(Win,String2),
	PictText3 = barcode_draw_texts(Win,String3),
	TextHeight = (Bb1 - Tb1) div 9,
	L1 = Lb1 + 5 + (Rb1 - Lb1) div 15, T1 = Tb1 + 5, R1 = Rb1 - 5,B1 = Bb1 - 10 - TextHeight,
	pict_GetSize(PictLine,X1,Y1,_),
	pict_Draw(Win,PictLine,rct(L1,T1,R1,B1),rct(0,0,X1,Y1),rop_SrcCopy),
	pict_Destroy(PictLine),
	SimbLen0 = (Rb1 - Lb1 - 10) / 15,
	SimbLen = val(integer,SimbLen0),
	TextHeight1 = (Bb1 - Tb1) div 4, T2 = Bb1 - 7 - TextHeight1, B2 = Bb1 - 5,
	L21 = Lb1 + 5, R21 = L21 + SimbLen, 
	pict_GetSize(PictText1,X21,Y21,_),
	pict_Draw(Win,PictText1,rct(L21,T2,R21,B2),rct(0,0,X21,Y21),rop_SrcCopy),
	pict_Destroy(PictText1),
	DText = (Rb1 - Lb1 - 10) div 19,
	SimbLen11 = (Rb1 - Lb1 - 10) * 0.4,
	SimbLen1 = val(integer,SimbLen11),
	L22 = R21 + DText, R22 = L22 + SimbLen1,
	pict_GetSize(PictText2,X22,Y22,_),
	pict_Draw(Win,PictText2,rct(L22,T2,R22,B2),rct(0,0,X22,Y22),rop_SrcCopy),
	pict_Destroy(PictText2),
	L23 = R22 + DText, R23 = L23 + SimbLen1,
	pict_GetSize(PictText3,X23,Y23,_),
	pict_Draw(Win,PictText3,rct(L23,T2,R23,B2),rct(0,0,X23,Y23),rop_SrcCopy),
	pict_Destroy(PictText3),
	barcode_set_previos_size(Win),!.
  barcode_draw(Win,Print,Rect,pen(Width,Style,Color),String,ean_8):-
	barcode_check_barcode(String,ean_8),
	barcode_set_natural_size(Win,Rect,rct(L,T,R,B)),
	D = Width div 2,
	Lb1 = L + D, Tb1 = T + D, Rb0 = R - D, Bb1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	draw_Rect(Win,rct(Lb1,Tb1,Rb0,Bb1)),
	PictLine = barcode_draw_lines(String,ean_8,WidthBars),
	barcode_get_rb1(Print,Lb1,Rb0,WidthBars,Rb1),
	frontstr(4,String,String1,String2),
	PictText1 = barcode_draw_texts(Win,String1),
	PictText2 = barcode_draw_texts(Win,String2),
	TextHeight = (Bb1 - Tb1) div 9,
	L1 = Lb1 + 5, T1 = Tb1 + 5, R1 = Rb1 - 5,B1 = Bb1 - 10 - TextHeight,
	pict_GetSize(PictLine,X1,Y1,_),
	pict_Draw(Win,PictLine,rct(L1,T1,R1,B1),rct(0,0,X1,Y1),rop_SrcCopy),
	pict_Destroy(PictLine),
	SimbLen = (Rb1 - Lb1 - 10) div 10,
	TextHeight1 = (Bb1 - Tb1) div 4, T2 = Bb1 - 7 - TextHeight1,
	L2 = Lb1 + SimbLen, R2 = Rb1 - SimbLen, B2 = Bb1 - 5,
	DText = (Rb1 - Lb1) div 20,
	L21 = (Rb1 + Lb1) div 2 - DText, R21 = (Rb1 + Lb1) div 2 + DText,
	pict_GetSize(PictText1,X21,Y21,_),
	pict_Draw(Win,PictText1,rct(L2,T2,L21,B2),rct(0,0,X21,Y21),rop_SrcCopy),
	pict_Destroy(PictText1),
	pict_GetSize(PictText2,X22,Y22,_),
	pict_Draw(Win,PictText2,rct(R21,T2,R2,B2),rct(0,0,X22,Y22),rop_SrcCopy),
	pict_Destroy(PictText2),
	barcode_set_previos_size(Win),!.
  barcode_draw(Win,Print,Rect,pen(Width,Style,Color),String,s_2_5):-
	barcode_check_barcode(String,s_2_5),
	barcode_set_natural_size(Win,Rect,rct(L,T,R,B)),
	D = Width div 2,
	Lb1 = L + D, Tb1 = T + D, Rb0 = R - D, Bb1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	draw_Rect(Win,rct(Lb1,Tb1,Rb0,Bb1)),
	PictLine = barcode_draw_lines(String,s_2_5,WidthBars),
	barcode_get_rb1(Print,Lb1,Rb0,WidthBars,Rb1),
	PictText = barcode_draw_texts(Win,String),
	TextHeight = (Bb1 - Tb1) div 4,
	L1 = Lb1 + 5, T1 = Tb1 + 5, R1 = Rb1 - 5,B1 = Bb1 - 10 - TextHeight,
	pict_GetSize(PictLine,X1,Y1,_),
	pict_Draw(Win,PictLine,rct(L1,T1,R1,B1),rct(0,0,X1,Y1),rop_SrcCopy),
	pict_Destroy(PictLine),
	str_len(String,Length1),
	Length = Length1 + 2,
	SimbLen = (Rb1 - Lb1 - 10) div Length,
	L2 = Lb1 + 5 + SimbLen, T2 = B1 + 3, R2 = Rb1 - 5 - SimbLen, B2 = Bb1 - 5,
	pict_GetSize(PictText,X2,Y2,_),
	pict_Draw(Win,PictText,rct(L2,T2,R2,B2),rct(0,0,X2,Y2),rop_SrcCopy),
	pict_Destroy(PictText),
	barcode_set_previos_size(Win),!.
  barcode_draw(Win,Print,Rect,pen(Width,Style,Color),String,s_39):-
	upper_lower(String1,String),
	barcode_check_barcode(String1,s_39),
	barcode_set_natural_size(Win,Rect,rct(L,T,R,B)),
	D = Width div 2,
	Lb1 = L + D, Tb1 = T + D, Rb0 = R - D, Bb1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	draw_Rect(Win,rct(Lb1,Tb1,Rb0,Bb1)),
	PictLine = barcode_draw_lines(String1,s_39,WidthBars),
	barcode_get_rb1(Print,Lb1,Rb0,WidthBars,Rb1),
	PictText = barcode_draw_texts(Win,String1),
	TextHeight = (Bb1 - Tb1) div 4,
	L1 = Lb1 + 5, T1 = Tb1 + 5, R1 = Rb1 - 5,B1 = Bb1 - 10 - TextHeight,
	pict_GetSize(PictLine,X1,Y1,_),
	pict_Draw(Win,PictLine,rct(L1,T1,R1,B1),rct(0,0,X1,Y1),rop_SrcCopy),
	pict_Destroy(PictLine),
	str_len(String1,Length1),
	Length = Length1 + 2,
	SimbLen = (Rb1 - Lb1 - 10) div Length,
	L2 = Lb1 + 5 + SimbLen, T2 = B1 + 3, R2 = Rb1 - 5 - SimbLen, B2 = Bb1 - 5,
	pict_GetSize(PictText,X2,Y2,_),
	pict_Draw(Win,PictText,rct(L2,T2,R2,B2),rct(0,0,X2,Y2),rop_SrcCopy),
	pict_Destroy(PictText),
	barcode_set_previos_size(Win),!.

  barcode_draw_lines(String,upc_a,95,Picture):-
	PictWin = pict_Open(rct(0,0,95,10)),
	win_Clear(PictWin,color_White),
	win_SetPen(PictWin,pen(1,ps_Solid,color_Black)),
	win_SetBrush(PictWin,brush(pat_Solid,color_Black)),
	barcode_draw_bars(PictWin,'A',12,b_true,0,String),
	Picture = pict_Close(PictWin),!.
  barcode_draw_lines(String,ean_13,95,Picture):-
	frontchar(String,Simb,Rest),
	PictWin = pict_Open(rct(0,0,95,10)),
	win_Clear(PictWin,color_White),
	win_SetPen(PictWin,pen(1,ps_Solid,color_Black)),
	win_SetBrush(PictWin,brush(pat_Solid,color_Black)),
	barcode_draw_bars(PictWin,Simb,12,b_false,0,Rest),
	Picture = pict_Close(PictWin),!.
  barcode_draw_lines(String,ean_8,67,Picture):-
	PictWin = pict_Open(rct(0,0,67,10)),
	win_Clear(PictWin,color_White),
	win_SetPen(PictWin,pen(1,ps_Solid,color_Black)),
	win_SetBrush(PictWin,brush(pat_Solid,color_Black)),
	barcode_draw_bars(PictWin,'A',8,b_false,0,String),
	Picture = pict_Close(PictWin),!.
  barcode_draw_lines(String,s_2_5,Width,Picture):-
	str_len(String,Length),
	Width = Length * 12 + 15,
	PictWin = pict_Open(rct(0,0,Width,10)),
	win_Clear(PictWin,color_White),
	win_SetPen(PictWin,pen(1,ps_Solid,color_Black)),
	win_SetBrush(PictWin,brush(pat_Solid,color_Black)),
	barcode_draw_bars_25(PictWin,0,String),
	Picture = pict_Close(PictWin),!.
  barcode_draw_lines(String,s_39,Width,Picture):-
	str_len(String,Length),
	Width = Length * 13 + 25,
	PictWin = pict_Open(rct(0,0,Width,10)),
	win_Clear(PictWin,color_White),
	win_SetPen(PictWin,pen(1,ps_Solid,color_Black)),
	win_SetBrush(PictWin,brush(pat_Solid,color_Black)),
	barcode_draw_bars_39(PictWin,0,String),
	Picture = pict_Close(PictWin),!.

  barcode_draw_texts(Win,String,Picture):-
	Font = font_Create(ff_Fixed,[fs_Bold],40),
	win_SetFont(Win,Font),
	win_GetTextExtent(Win,String,-1,Width,Height1),
	Height = Height1 - 31,
	PictWin = pict_Open(rct(0,0,Width,Height)),
	win_Clear(PictWin,color_White),
	win_SetForeColor(PictWin,color_Black),
	win_SetFont(PictWin,Font),
	draw_Text(PictWin,0,Height,String),
	Picture = pict_Close(PictWin),!.
