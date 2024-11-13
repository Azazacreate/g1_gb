/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	TEMPORAR.PRO
 Purpose:	Temporary Buffer Handle
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
*****************************************************************************/
constants
	re_all_values	= 101
	re_except_left	= 102
	re_except_right_bottom = 103
domains
	BLOCK_DOM = block_dom(INTEGER,OUT_PARAM,FONT)
	BLOCK_DOMLIST = BLOCK_DOM*
predicates
procedure	find_out_min1(INTEGER)
procedure	find_out_min2(INTEGER)
procedure	find_out_max1(INTEGER)
procedure	find_out_max2(INTEGER)
procedure	clear_most_extrem(INTEGER)
procedure	prefind_outmin(INTEGER,BLOCK_DOMLIST,RCT)
procedure	get_most_top(INTEGER)
procedure	get_most_left(INTEGER)
procedure	get_most_bottom(INTEGER)
procedure	get_most_right(INTEGER)
procedure	imax(INTEGER,INTEGER,INTEGER)
procedure	get_last_succeded(INTEGER)
procedure	change_succeded(INTEGER)
procedure	store_block_width(INTEGER,INTEGER,INTEGER)
determ		find_out_min(INTEGER,BLOCK_DOMLIST,INTEGER,RCT)
determ		find_outer_level(INTEGER,INTEGER)
determ		find_keep_level(INTEGER)
determ		find_keep_level1(INTEGER,ILIST)

clauses
   find_out_min1(I):-
   	the_most_top(X),
   	X <= I, !.
   find_out_min1(_):-
   	retract(the_most_top(_)),
   	fail.
   find_out_min1(I):-
   	assert(the_most_top(I)),
   	!. 
   	
   find_out_min2(I):-
   	the_most_left(X),
   	X <= I, !.
   find_out_min2(_):-
   	retract(the_most_left(_)),
   	fail.
   find_out_min2(I):-
   	assert(the_most_left(I)),
   	!. 
   	
   find_out_max1(I):-
   	the_most_right(X),
   	X >= I, !.
   find_out_max1(_):-
   	retract(the_most_right(_)),
   	fail.
   find_out_max1(I):-
   	assert(the_most_right(I)),
   	!. 
   	
   find_out_max2(I):-
   	the_most_bottom(X),
   	X >= I, !.
   find_out_max2(_):-
   	retract(the_most_bottom(_)),
   	fail.
   find_out_max2(I):-
   	assert(the_most_bottom(I)),
   	!. 
   	
  clear_most_extrem(re_except_left):-
  	retractall(the_most_top(_)),
	retractall(the_most_bottom(_)),
	retractall(the_most_right(_)),
	!.

  clear_most_extrem(re_all_values):-
not(outer_left_top(_,_)),
  	retractall(the_most_top(_)),
	retractall(the_most_left(_)),
	retractall(the_most_bottom(_)),
	retractall(the_most_right(_)),
	!.

  clear_most_extrem(re_except_right_bottom):-
  	retractall(the_most_top(_)),
	retractall(the_most_left(_)),
	!.
  clear_most_extrem(_).
  
   get_most_top(Top):-
   	the_most_top(Top), !.
   get_most_top(0).
   	
   get_most_left(Left):-
   	the_most_left(Left), !.
   get_most_left(0).

   get_most_bottom(Bottom):-
   	the_most_bottom(Bottom), !.
   get_most_bottom(0).

   get_most_right(Right):-
   	the_most_right(Right), !.
   get_most_right(0).

  find_outer_level(LEVEL,LEVEL):-
	a_block(LEVEL,_,Outer,_,_,_,_),
	Outer = 1, !.

  find_outer_level(LEVEL,Find):-
	a_block(LEVEL,_,_,_,_,_,Parent),!,
	find_outer_level(Parent,Find).
	
  find_keep_level(LEVEL):-
	findall(L,block(L,_,_),LIST),
	find_keep_level1(LEVEL,LIST).

  find_keep_level1(_,[]):-!.
  find_keep_level1(LEVEL,[L|REST]):-
  	L >= LEVEL,!,
  	a_block(L,_,_,_,_,_,_),!,
  	find_keep_level1(LEVEL,REST).
  find_keep_level1(LEVEL,[_|REST]):-!,
  	find_keep_level1(LEVEL,REST).

  imax(L,H,H):-
  	H > L, !.
  imax(H,_,H).
  
  change_succeded(I):-
  	the_last_succeded(L),
  	L > I, !.
  change_succeded(_):-
  	retract(the_last_succeded(_)),
  	fail.
  change_succeded(I):-
  	assert(the_last_succeded(I)), !.

  get_last_succeded(LAST):-
  	the_last_succeded(LAST), !.
  	
  get_last_succeded(0).

  store_block_width(LEVEL,WIDTH,_):-
	a_block(LEVEL,_,_,_,_,W,_),
	W >= WIDTH, !.
  store_block_width(LEVEL,WIDTH,TYPE):-
	TYPE >< accessory,
  	retract(a_block(LEVEL,K,O,D,T,_,P)),
  	assert(a_block(LEVEL,K,O,D,T,WIDTH,P)), !.

  store_block_width(_,_,_).

predicates
procedure	appendH(BLOCK_DOMLIST,BLOCK_DOMLIST,BLOCK_DOMLIST)
procedure	appendH(HEADER_WITHP_LIST,HEADER_WITHP_LIST,HEADER_WITHP_LIST)
procedure	appendH(PNTLIST,PNTLIST,PNTLIST)
procedure	recursively_collect(INTEGER,BLOCK_DOMLIST)
procedure	recurs_collect1(INTEGER,BLOCK_DOMLIST)
procedure	collect_out(INTEGER,BLOCK_DOMLIST)
procedure	put_level(BLOCK_DOMLIST)
procedure	recovery_corner(ILIST,ILIST,INTEGER,INTEGER)

procedure	split_outers(INTEGER)
procedure	split_outers1(INTEGER,INTEGER,BLOCK_DOMLIST,BLOCK_DOMLIST)

clauses
   appendh([],L,L):-!.
   appendh([N|L1],L2,[N|L3]) :-!,
   	appendh(L1,L2,L3).
   appendh(_,_,[]):-errorexit().

  recursively_collect(1,[block_dom(L,OUT,FONT)|REST]):-
  	retract(block(L,OUT,FONT)),!,	% Collect all the blocks
	recursively_collect(1,REST).	% to process by split funct
  recursively_collect(LEVEL,RESULT):-  % Collect lower
  	collect_out(LEVEL,LIST),!,
	recurs_collect1(LEVEL,PREV),
	appendh(LIST,PREV,RESULT).
  recursively_collect(_,[]).
  
  recurs_collect1(LEVEL,PREV):-
  	block(NUM,_,_),
  	NUM > LEVEL,!,
	recursively_collect(NUM,PREV).
  recurs_collect1(_,[]).  	

  collect_out(L,[block_dom(L,OUT,FONT)|REST]):-  	
  	retract(block(L,OUT,FONT)),!,
	collect_out(L,REST).
  collect_out(_,[]):-!.
  
%===	Put Blocks Back to its Place		===
  put_level([]):-!.
  put_level([block_dom(LEVEL,OUT,FONT)|REST]):-
  	assert(block(LEVEL,OUT,FONT)),!,
	put_level(REST).

  put_level(_):-errorexit().
  recovery_corner([X0|XREST],[Y|YREST],DD,POS):-
	Y0 = Y - DD,
	imax(Y0,POS,YZ),
  	assertz(outer_left_top(X0,YZ)), !,
	recovery_corner(XREST,YREST,DD,POS).

  recovery_corner(_,_,_,_).

  split_outers(PARENT):-
  	recursively_collect(1,RESULT),
  	retractall(the_most_bottom(_)),
	get_last_succeded(LAST),
  	footers(Height,Res),
	LIMIT = Res - Height,!,
	prefind_outmin(LIMIT,RESULT,rct(_,_,_,B)),
	imax(LAST,B,MAX),
  	split_outers1(MAX,PARENT,RESULT,PROCD),
	retractall(the_last_succeded(_)),
	put_level(PROCD).  	
  split_outers(_).

   split_outers1(_,_,[],[]):-!.

   split_outers1(MAX,PARENT,[block_dom(_,OUT,_)|REST],XREST):-
	OUT = param(RCT,_,STR,_,_,_,_,_,_,_,_),
	STR = "\\p\\e",
	RCT = rct(_,T,_,_),
	T >= MAX, !,
	split_outers1(MAX,PARENT,REST,XREST).
   split_outers1(MAX,PARENT,[block_dom(_,OUT,FONT)|REST],
		[block_dom(PARENT,OUT1,FONT)|XREST]):-
	OUT = param(RCT,BORDER,STR,ILIST,FORE,BACK,LIND,TIND,FF,FSTYLE,FSIZE),
	STR = "\\p\\e",
	RCT = rct(L,T,R,B),
	B > MAX,!,
	RBT = rct(L,T,R,MAX),
	OUT1 = param(RBT,BORDER,"\p",ILIST,FORE,BACK,LIND,TIND,FF,FSTYLE,FSIZE),
	split_outers1(MAX,PARENT,REST,XREST).
	
   split_outers1(MAX,PARENT,[A|REST],[A|XREST]):-!,
	split_outers1(MAX,PARENT,REST,XREST).
   split_outers1(_,_,_,[]):-errorexit().
	
predicates
procedure	properties_check(PROPERTIES)
procedure	c_active_block(INTEGER)
procedure	create_block(INTEGER)
procedure	generate_int(INTEGER,INTEGER,INTEGER)  
procedure	retrieve_block_prop(PROPERTIES)
procedure	get_direction(INTEGER)
procedure	on_beginning(PROPERTIES,INTEGER)   
procedure	on_exit(process_pred,HEADER_WITHP_LIST,INTEGER)
procedure	put_older1(INTEGER)
procedure	put_older11(INTEGER)
procedure	put_older2(INTEGER)
procedure	put_older
procedure	count_over_again(INTEGER)
procedure	together_perform(INTEGER)
procedure	outer_perform(INTEGER)
procedure	outer_perform1(INTEGER,RCT)
procedure	correct_out(INTEGER,INTEGER,BLOCK_DOMLIST,BLOCK_DOMLIST)
procedure	put_footer(INTEGER)
procedure	put_footer1(INTEGER,OUT_PARAM,FONT)
procedure	put_parent(INTEGER)
procedure	put_parent1(INTEGER)
procedure	put_blocks(BLOCK_DOMLIST)
procedure	popup_level
procedure	enlarge_border
procedure	enlarge_border1(INTEGER,BLOCK_DOMLIST)

clauses
   properties_check([keep_together|REST]):-!,
   	c_active_block(1),
	properties_check(REST).
   properties_check([outer_rect|REST]):-!,
   	c_active_block(2),
	retractall(the_most_right(_)),
	properties_check(REST).
   properties_check([horizontal_block|REST]):-!,
   	c_active_block(3),
	properties_check(REST).
   properties_check([]):-!.
   properties_check([_|PROP]):-!,
	properties_check(PROP).
   properties_check(_):-errorexit().

   c_active_block(1):-
	active_block(Num),
   	retract(a_block(Num,_,Outer,Direct,Force,Width,Parent)),
   	assert(a_block(Num,0,Outer,Direct,Force,Width,Parent)), !.
   c_active_block(2):-
	active_block(Num),
   	retract(a_block(Num,Keep,_,Direct,Force,Width,Parent)),
   	assert(a_block(Num,Keep,1,Direct,Force,Width,Parent)), !.
   c_active_block(3):-
	active_block(Num),
   	retract(a_block(Num,Keep,Outer,_,Force,Width,Parent)),
   	assert(a_block(Num,Keep,Outer,1,Force,Width,Parent)), !.
   c_active_block(_).
   		
   retrieve_block_prop([]):-
	active_block(Num),
   	a_block(Num,1,0,_,_,_,_),
   	!.
   retrieve_block_prop([keep_together]):-
	active_block(Num),
   	a_block(Num,0,0,_,_,_,_),
   	!.
   retrieve_block_prop([outer_rect]):-
	active_block(Num),
   	a_block(Num,1,1,_,_,_,_),
   	!.
   retrieve_block_prop([keep_together,outer_rect]):-
	active_block(Num),
   	a_block(Num,0,1,_,_,_,_),
   	!.
   retrieve_block_prop([]).

   get_direction(Direction):-
   	active_block(Num),
   	a_block(Num,_,_,Direction,_,_,_),
   	!.
   get_direction(0).

   create_block(FLAG):-
   	retract(active_block(Num)),
   	a_block(Num,Keep,_,_,_,_,_),
   	generate_int(1,I,FLAG),
   	assert(a_block(I,Keep,0,0,FLAG,0,Num)),
   	assert(active_block(I)),
   	!.
   create_block(FLAG):-
   	assert(active_block(1)),
   	assert(a_block(1,1,0,0,FLAG,0,0)), !.
   	
  generate_int(I,J,FLAG):-
  	a_block(K,_,_,_,_,_,_),
  	K = I,!,
  	II = I + 1,
  	generate_int(II,J,FLAG).
  generate_int(I,J,FLAG):-
  	FLAG = accessory,
  	block(K,_,_),
  	K = I,!,
  	II = I + 1,
  	generate_int(II,J,FLAG).
  generate_int(I,I,_).

  on_beginning(PROP,FLAG):-
	create_block(FLAG),
  	properties_check(PROP),
  	!.

  on_exit(_,_,c_header):-
	enlarge_border,
  	popup_level,
  	!.
  on_exit(_,_,c_footer):-
	active_block(LEVEL),
	enlarge_border,
	put_footer(LEVEL),
	popup_level,
	!.
  on_exit(_,_,_):-
	active_block(LEVEL),
	a_block(LEVEL,Keep,_,_,_,_,_),
	Keep = 0,
	enlarge_border,
	outer_perform(LEVEL),
	popup_level,
	!.		% decreasing the Num of Active Block
  on_exit(CB,HEAD,FLAG):-
	enlarge_border,
	active_block(LEVEL),
	a_block(LEVEL,_,_,_,_,_,_),
  	proc_endofsheet(CB,HEAD,FLAG),
	outer_perform(LEVEL),
	together_perform(LEVEL),
	popup_level,
	!.

  on_exit(_,_,_):-!.
  
  count_over_again(MM):-
  	last_pos(POS),
  	recursively_collect(1,LIST),
  	retractall(the_most_top(_)),
  	find_out_min(31000,LIST,main,rct(_,MIN,_,MAX)),
  	MM = MIN - POS,DELTA = MAX - MIN,
  	correct_out(MM,DELTA,LIST,PROCD),
  	put_level(PROCD),
  	retract(listx_outers(LISTX,LISTY)),
  	recovery_corner(LISTX,LISTY,MM,POS),
	clear_most_extrem(re_except_left),
  	!.
  count_over_again(0).
  	
  together_perform(LEVEL):-
	a_block(LEVEL,Keep,_,_,_,_,_),
	Keep = 0,
	!.
  together_perform(LEVEL):-
  	recursively_collect(LEVEL,LIST),
  	put_blocks(LIST),
  	!.
  	
  outer_perform(L):-
	a_block(L,_,Outer,_,_,Right,_),
	Outer = 1,
  	retract(outer_left_top(X0,Y0)),
	recursively_collect(L,RESULT),
	clear_most_extrem(re_except_right_bottom),
	find_out_min(31000,RESULT,main,RCT),
	RCT = rct(_,_,_,Bott),
	RBT = rct(X0,Y0,Right,Bott),
	clear_most_extrem(re_all_values),
	put_level(RESULT),		
	outer_perform1(L,RBT),
	!.

  outer_perform(L):-
	find_outer_level(L,LEVEL),
	recursively_collect(LEVEL,RESULT),
	find_out_min(31000,RESULT,main,_RCT),
	put_level(RESULT),		
  	!.
  	
  outer_perform(_):-clear_most_extrem(re_all_values).

  outer_perform1(L,RBT):-
	RBT = rct(_,Y0,_,Bottom),
	Bottom >= Y0,
	active_prop(2,FONT,FF,FSTYLE,FSIZE,_,_,_,_,_,_,FORE,BACK,_,_,_,_),
	assert(block(L,param(RBT,re_border(1),"\p",[],FORE,BACK,0,0,FF,FSTYLE,FSIZE),FONT)),
	!.
  outer_perform1(_,_).	
  
  prefind_outmin(LIM,LIST,MIN):-
	find_out_min(LIM,LIST,main,MIN),
	!.
  prefind_outmin(LIM,LIST,MIN):-
  	retractall(the_most_bottom(_)),
	find_out_min(LIM,LIST,accessory,MIN),
	!.
  prefind_outmin(_,[],rct(0,0,0,0)):-!.
  prefind_outmin(_,_,rct(0,0,0,0)):-errorexit().
  
  find_out_min(_LIM,[],_,rct(L,T,R,B)):-
  	get_most_left(L),
  	get_most_top(T),
  	get_most_right(R),
  	get_most_bottom(B),
  	!.

  find_out_min(LIM,[block_dom(_,OUT,_FONT)|REST],main,MIN):-
	OUT = param(RCT,_,STR,_,_,_,_,_,_,_,_),
	not(STR = "\\p\\e"),
  	RCT = rct(L,T,R,B),
  	B < LIM,
  	find_out_min1(T),
  	find_out_min2(L),
  	find_out_max1(R),
  	find_out_max2(B),!,
  	find_out_min(LIM,REST,main,MIN).
  find_out_min(LIM,[block_dom(LEV,OUT,_FONT)|_],main,_):-
	OUT = param(RCT,_,STR,_,_,_,_,_,_,_,_),
	not(STR = "\\p\\e"),
  	RCT = rct(_,_,_,B),
  	B >= LIM,
	not(a_block(LEV,_,_,_,_,_,_)),!,
	fail.

  find_out_min(LIM,[block_dom(LEV,OUT,_FONT)|REST],accessory,MIN):-
	active_block(ACTIVE),
	LEV < ACTIVE,
	OUT = param(RCT,_,STR,_,_,_,_,_,_,_,_),
	not(STR = "\\p\\e"),
  	RCT = rct(L,T,R,B),
  	B < LIM,
  	find_out_min1(T),
  	find_out_min2(L),
  	find_out_max1(R),
  	find_out_max2(B),!,
  	find_out_min(LIM,REST,accessory,MIN).
	
  find_out_min(LIM,[_|REST],FLAG,MIN):-!,
  	find_out_min(LIM,REST,FLAG,MIN).
  	
  find_out_min(_,_,_,rct(0,0,0,0)).
  correct_out(Y,DELTA,[block_dom(LEV,OUT,FONT)|REST],[block_dom(LEV,OOO,FONT)|NEXT]):-
	OUT = param(RCT,BORDER,STR,ILIST,FORE,BACK,LIND,TIND,FF,FSTYLE,FSIZE),
	RCT = rct(L,T,R,B),TT = T - Y, BB = B - Y,
	RRR = rct(L,TT,R,BB),
	y_memory(BB), !,
	OOO = param(RRR,BORDER,STR,ILIST,FORE,BACK,LIND,TIND,FF,FSTYLE,FSIZE),
  	correct_out(Y,DELTA,REST,NEXT).
  correct_out(_,_,[],[]):-
%  	get_direction(DIR),
%  	get_X(X0),
%  	get_Y(Y0),
%  	y_set(DIR,X0,Y0),
  	!.

  correct_out(_,_,_,[]):-errorexit().
  put_older1(LEV):-
	find_outer_level(LEV,LEVEL),
%===	L < LEVEL exists and has block(_,_,_,_...)
	not(find_keep_level(LEVEL)),
  	a_block(LEVEL,_,_,_,_,_,PARENT),!,
	put_older2(LEVEL),
	split_outers(PARENT),
  	put_parent(PARENT).

  put_older1(LEV):-
  	put_older11(LEV),
	split_outers(LEV),
  	put_parent(LEV),
  	!.
  put_older1(_).
  	
  put_older11(LEV):-
	a_block(LEV,_,Outer,_,Type,Right,Parent),
	Outer = 1,
	last_pos(Bottom),
	retract(outer_left_top(X0,Y0)),
	RCT = rct(X0,Y0,Right,Bottom),	
	active_prop(2,FONT,FF,FSTYLE,FSIZE,_,_,_,_,_,_,FORE,BACK,_,_,_,_),
	assert(block(LEV,param(RCT,re_border(1),"\\p\\e",[],FORE,BACK,0,0,FF,FSTYLE,FSIZE),FONT)),
	store_block_width(Parent,Right,Type), !,
	put_older11(Parent).
	
  put_older11(LEV):-
	a_block(LEV,_,_,_,Type,Right,Parent),
	store_block_width(Parent,Right,Type),!,
  	put_older11(Parent).

  put_older11(_).

%---	Keep Together is set for some internal block	---
  put_older2(LEVEL):-
	recursively_collect(LEVEL,RESULT),
	find_out_min(31000,RESULT,main,RCT),
	RCT = rct(_,_,Right,Bott),
	put_level(RESULT),		
  	retract(outer_left_top(X0,Y0)),
	RBT = rct(X0,Y0,Right,Bott),
	retractall(the_most_right(_)),
	retractall(the_most_top(_)),
	active_prop(2,FONT,FF,FSTYLE,FSIZE,_,_,_,_,_,_,FORE,BACK,_,_,_,_),
	assert(block(LEVEL,param(RBT,re_border(1),"\p",[],FORE,BACK,0,0,FF,FSTYLE,FSIZE),FONT)), 
	LEV = LEVEL - 1,
	put_older11(LEV),
	!.
  put_older2(_).

  put_older:-
  	active_block(LEV),
  	findall(X,outer_left_top(X,_),LISTX),
  	findall(Y,outer_left_top(_,Y),LISTY),
  	assert(listx_outers(LISTX,LISTY)),!,
	put_older1(LEV).

  put_older.
  	  	
  put_footer(LEVEL):-
  	retract(block(LEVEL,OUT,FONT)),
	put_footer1(LEVEL,OUT,FONT),
	fail.
  put_footer(_).  

  put_footer1(LEVEL,OUT,_):-
  	OUT = param(RRR,_,STR,_,_,_,_,_,_,_,_),
  	block(L,param(RCT,_,STR,_,_,_,_,_,_,_,_),_),
  	L >< LEVEL,
	RRR = rct(X0,Y0,X1,Y1),
	RCT = rct(X0,Y2,X1,Y3),
	Y1 - Y0 = Y3 - Y2, !.

  put_footer1(_LEVEL,OUT,FONT):-
  	textout(OUT,FONT).

  put_parent1(LEVEL):-
  	a_block(LEVEL,_,_,_,_,_,PARENT),!,
  	put_parent(PARENT).
  put_parent1(_).

  put_parent(LEV):-
  	a_block(LEV,_,_,_,_,_,_),
  	footers(Height,Res),
  	block(LEV,OUT,FONT),
	OUT = param(RCT,_,_,_,_,_,_,_,_,_,_),
	RCT = rct(_,_,_,B),
	Res - Height >= B,
  	retract(block(LEV,OUT,FONT)),
  	textout(OUT,FONT),
  	fail.
  put_parent(LEV):-
  	put_parent1(LEV).
  	
  put_blocks([block_dom(_,OUT,FONT)|REST]):-
	OUT = param(RCT,_,_,_,_,_,_,_,_,_,_),
	RCT = rct(_,_,_,B),
  	textout(OUT,FONT),
	change_succeded(B),	!,
  	put_blocks(REST).
  put_blocks([]):-!.
  put_blocks(_):-errorexit().
  
  enlarge_border:-
	active_prop(2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,COMPLEX),
	bitand(COMPLEX,16,VAL),
	VAL = 16,
	active_block(LEVEL),
  	last_pos(POS), !,
  	recursively_collect(LEVEL,LIST),
	enlarge_border1(POS,LIST).
	
  enlarge_border.


  enlarge_border1(_,[]):-!.
  enlarge_border1(POS,[block_dom(LEVEL,OUT_PARAM,FONT)|LIST]):-
  	OUT_PARAM = param(RBT,re_border(1),"\p",FLS,FORE,BACK,LIND,TIND,FF,FSTYLE,FSIZE),
	RBT = rct(L,T,R,_B),
	RCT = rct(L,T,R,POS),
	assert(block(LEVEL,param(RCT,re_border(1),"\p",FLS,FORE,BACK,LIND,TIND,FF,FSTYLE,FSIZE),FONT)), !,
	enlarge_border1(POS,LIST).
	
  enlarge_border1(POS,[block_dom(LEVEL,OUT_PARAM,FONT)|LIST]):-
	assert(block(LEVEL,OUT_PARAM,FONT)), !,
	enlarge_border1(POS,LIST).
  enlarge_border1(_,_):-errorexit().
	
  popup_level:-
	retract(active_block(LEVEL)),	
	retract(a_block(LEVEL,_,_,_,TYPE,Width,NUM)),
	NUM >< 0,
	assert(active_block(NUM)),
	store_block_width(NUM,Width,TYPE),
	!.	
  popup_level.
predicates
procedure	check_split(INTEGER,HEADER,HEADER_WITHP_LIST,PROCESS_PRED)
procedure	check_split1(INTEGER,INTEGER,HEADER,HEADER_WITHP_LIST,PROCESS_PRED)
procedure	split_it(INTEGER)
procedure	get_blocks_height(INTEGER)
procedure	change_blocks_top(INTEGER)
procedure	change_blocks_bottom(INTEGER)

clauses
  check_split(AVAIL,Header,HeaderList,CCB):-
  	retractall(blocks_mosttop(_)),
  	retractall(blocks_mostbottom(_)),
  	assert(blocks_mosttop(32000)),
  	assert(blocks_mostbottom(0)),!,
  	get_blocks_height(HEIGHT),
  	check_split1(AVAIL,HEIGHT,Header,HeaderList,CCB).
  check_split(_,_,_,_).
  
  check_split1(AVAIL,HEIGHT,_,_,_):-
  	AVAIL <= HEIGHT,!,
  	split_it(AVAIL).
  	
  check_split1(AVAIL,HEIGHT,Header,HeaderList,CCB):-
  	get_headers_height(CCB,Header,HeaderList,HeaderHeight),
  	AVAIL - HeaderHeight <= HEIGHT,!,
  	split_it(AVAIL).
  	
  check_split1(_,_,_,_,_).
    
  get_blocks_height(_):-
  	block(_,OUT,_),
	OUT = param(RCT,_,_,_,_,_,_,_,_,_,_),
	RCT = rct(_,T,_,B),
	change_blocks_top(T),
	change_blocks_bottom(B),
	fail.
  get_blocks_height(HEIGHT):-
  	retract(blocks_mostbottom(BOTTOM)),
  	retract(blocks_mosttop(TOP)),
  	HEIGHT = BOTTOM - TOP,
  	!.
  get_blocks_height(0).
  change_blocks_top(T):-
  	blocks_mosttop(TOP),
  	TOP > T,
  	retract(blocks_mosttop(TOP)),
  	assert(blocks_mosttop(T)),
	!.
  change_blocks_top(_).

  change_blocks_bottom(B):-
  	blocks_mostbottom(BOTTOM),
  	BOTTOM < B,
  	retract(blocks_mostbottom(BOTTOM)),
  	assert(blocks_mostbottom(B)),
	!.

  change_blocks_bottom(_).

  split_it(Y):-
  	block(LEV,OUT,FONT),
	OUT = param(RCT,_,_,_,_,_,_,_,_,_,_),
	RCT = rct(_,_,_,B),
	Y >= B,
  	retract(block(LEV,OUT,FONT)),
  	textout(OUT,FONT),
  	fail.
  split_it(_).
  	
