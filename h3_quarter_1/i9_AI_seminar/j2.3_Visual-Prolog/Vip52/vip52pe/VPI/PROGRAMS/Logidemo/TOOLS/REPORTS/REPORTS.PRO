/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	REPORTS.PRO
 Purpose:	User Defined Callbacks for Report Engine
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		018.981112
 Tested with:	Visual Prolog v. 5.1 build 555a
 Comments:
*****************************************************************************/

database	- report_db
 
determ  rp_p1(SLIST)
determ  rp_p2(SLIST)
determ  rp_p3(SLIST)
determ  rp_header(SLIST)
determ  rp_tonns(LLIST)
determ  rp_costs(LLIST)
determ  sum_line(LLIST)
determ  sum_line1(RLIST)
determ	outline1(STRING)
determ  prgrs_table(INTEGER,INTEGER)  

/**************************************************************************************************
*		
*		R E P O R T' s   A u x i l a r y   P r e d i c a t e s
*		
***************************************************************************************************/
predicates
procedure  rp_sort_list(BOOLEAN Ascending,SLIST Input,SLIST Current,SLIST Output)
procedure  rp_sort_list1(BOOLEAN Ascending,STRING,SLIST Input,SLIST Current,SLIST Output)
procedure  rp_sort_list2(SLIST Input1,SLIST Input2,SLIST Current,SLIST Output)
procedure  rp_reverse_list(SLIST,SLIST,SLIST)
procedure  rp_remove_duplicates(LLIST,LLIST)
procedure  rp_remove_dup1(LONG,LLIST,LLIST)
determ  rp_member(LONG,LLIST)
determ  rp_listlength(SLIST,INTEGER)
clauses
  rp_sort_list(_,[],Output,Output):-!.
  rp_sort_list(Ascending,[Str|Rest],Current,Output):-
	rp_sort_list1(Ascending,Str,Current,[],Out),!,
	rp_sort_list(Ascending,Rest,Out,Output).

  rp_sort_list(_,_,Output,Output):-errorexit().

  rp_sort_list1(_,Str,[],Current,Output):-
	rp_reverse_list([Str|Current],[],Output),!.
  rp_sort_list1(b_true,Str,[Str1|Rest],Current,Output):-
	Str1 > Str,
	rp_reverse_list([Str|Current],[],Curr),
	rp_sort_list2(Curr,[Str1|Rest],[],Output),!.
  rp_sort_list1(b_false,Str,[Str1|Rest],Current,Output):-
	Str > Str1,
	rp_reverse_list([Str|Current],[],Curr),
	rp_sort_list2(Curr,[Str1|Rest],[],Output),!.
  rp_sort_list1(b_true,Str,[Str1|Rest],Current,Output):-!,
	rp_sort_list1(b_true,Str,Rest,[Str1|Current],Output).
  rp_sort_list1(_,_,_,Output,Output):-errorexit().

  rp_sort_list2([],[],Current,Output):-
	rp_reverse_list(Current,[],Output),!.
  rp_sort_list2([],[Str|Rest],Current,Output):-!,
	rp_sort_list2([],Rest,[Str|Current],Output).
  rp_sort_list2([Str|Rest],List,Current,Output):-!,
	rp_sort_list2(Rest,List,[Str|Current],Output).
  rp_sort_list2(_,_,Output,Output):-errorexit().

  rp_reverse_list([],O,O):-!.
  rp_reverse_list([H|R],C,O):-!,
	rp_reverse_list(R,[H|C],O).
  rp_reverse_list(_,O,O):-errorexit().
  rp_remove_duplicates([],[]):-!.
  rp_remove_duplicates([H|T],OUT):-
	rp_remove_duplicates(T,LIST),!,
	rp_remove_dup1(H,LIST,OUT).
  rp_remove_duplicates(_,[]):-errorexit().

  rp_remove_dup1(H,LIST,LIST):-
	rp_member(H,LIST), !.

  rp_remove_dup1(H,LIST,[H|LIST]):-!.
  
  rp_listlength([],0):-!.
  rp_listlength([_|LIST],N):-!,
  	rp_listlength(LIST,LEN),
  	N = LEN + 1.

  rp_member(H,[H|_]):- !.
  rp_member(H,[_|REST]):-
  	rp_member(H,REST).
  	
/**************************************************************************************************
*		
*		R E P O R T' s   O r d e r e d  R o w   E x t r a c t i o n
*		
***************************************************************************************************/

predicates
determ	move_line0(STRING)
determ  move_line(STRING,STRING,STRING)
determ  move_line1(STRING,STRING,STRING)
determ  move_line2(STRING,STRING,STRING,SLIST,LONG,REAL,LLIST,RLIST,STRING,STRING)
determ  move_line3(STRING,STRING)
determ  move_line4(STRING,INTEGER)
determ  header_line(SLIST,STRING)

determ  obtain_parameter_list(STRING,LLIST,SLIST)
determ  obtain_producer_list(LLIST,SLIST)
determ  obtain_customer_list(LLIST,SLIST)
determ  obtain_sort_list(LLIST,SLIST)

procedure  rp_change_p2(SLIST)
procedure  rp_change_p1(SLIST)

nondeterm  get_movep2(STRING,STRING,LONG)

determ	   add_sum(LLIST,LLIST,LLIST)
determ	   add_sum(RLIST,RLIST,RLIST)
determ     add_sumLine(LLIST)
determ     add_sumLine1(RLIST)
determ     get_sum_line(LLIST,STRING)
determ     get_sum_line1(RLIST,STRING)
determ	   store_outline(STRING)
determ	   plan_overview(STRING,STRING,STRING,STRING,STRING,STRING,STRING)
clauses
  move_line0(Out):-
	retract(outline1(Out)),
  	!.

  move_line(Key,P20,OutList):-
  	rp_p2(Param2),
  	Param2 = [_|Rest],
  	Rest = [P20|_],
  	rp_p1(Param1),
  	Param1 = [P1|_],
  	rp_change_p2(Rest),
  	rp_header(Header),
  	move_line2(Key,P1,P20,Header,0,0,Sum,Sum1,OutList,OutList1),
	store_outline(OutList1),
  	add_sumLine(Sum),
  	add_sumLine1(Sum1),
  	!.
  
  move_line1(Key,P10,OutList):-
  	rp_p1(Param1),
  	Param1 = [_|Rest],
  	Rest = [P10|_],
  	rp_change_p1(Rest),
  	move_line3(Key,P10),
  	rp_header(Header), !,
	header_line(Header,OutList).
  	
  move_line2(_,_,_,[],S1,S2,[S1],[S2],Out,Out1):-
  	format(Out,"%D	",S1),
  	format(Out1,"%f	",S2),
  	!.
  move_line2("by producer",P1,P2,[H|Rest],S10,S20,[LN|Sum],[LC|Sum1],Out,Out1):-
  	tr_db_producer(I1,P1,_,_,_),
  	tr_db_customer(I2,P2,_,_,_),
  	tr_db_sort(I3,H,_,_,_),
  	move(I3,I1,I2,N),
	tr_db_distance(I1,I2,C),
  	LN = val(LONG,trunc(N)),
  	LC = N * C,
  	S1 = S10 + LN, S2 = S20 + LC, !,
  	move_line2("by producer",P1,P2,Rest,S1,S2,Sum,Sum1,S,Ss),
  	format(Out,"%D	%s",LN,S),
  	format(Out1,"%f	%s",LC,Ss).
  	
  move_line2("by customer",P1,P2,[H|Rest],S10,S20,[LN|Sum],[LC|Sum1],Out,Out1):-
  	tr_db_customer(I1,P1,_,_,_),
  	tr_db_producer(I2,P2,_,_,_),
  	tr_db_sort(I3,H,_,_,_),
  	move(I3,I2,I1,N),
	tr_db_distance(I2,I1,C),
  	LN = val(LONG,trunc(N)),
  	LC = N * C,
  	S1 = S10 + LN, S2 = S20 + LC, !,
  	move_line2("by customer",P1,P2,Rest,S1,S2,Sum,Sum1,S,Ss),
  	format(Out,"%D	%s",LN,S),
  	format(Out1,"%f	%s",LC,Ss).
  
  move_line2("by sort",P1,P2,[H|Rest],S10,S20,[LN|Sum],[Lc|Sum1],Out,Out1):-
  	tr_db_sort(I1,P1,_,_,_),
  	tr_db_producer(I2,P2,_,_,_),
  	tr_db_customer(I3,H,_,_,_),
  	move(I1,I2,I3,N),
  	tr_db_distance(I2,I3,C),
  	LN = val(LONG,trunc(N)),
  	LC = N * C,
  	S1 = S10 + LN, S2 = S20 + LC, !,
  	move_line2("by sort",P1,P2,Rest,S1,S2,Sum,Sum1,S,Ss),
  	format(Out,"%D	%s",LN,S),
  	format(Out1,"%f	%s",LC,Ss).

  move_line2(Key,P1,P2,[_|Rest],S1,S2,[0|Sum],[0|Sum1],Out,Out1):-
  	move_line2(Key,P1,P2,Rest,S1,S2,Sum,Sum1,S,Ss),
  	format(Out,"-	%s",S),
  	format(Out1,"-	%s",Ss).

  move_line3(Key,P10):-
  	findall(P2,get_movep2(Key,P10,P2),P2List),
	rp_remove_duplicates(P2List,POnceList),
	obtain_parameter_list(Key,POnceList,PList),
	rp_sort_list(b_true,PList,[],SortedList),
	SortedList = [E1|Rest],
	SortedList1 = [E1,E1|Rest],
  	rp_change_p2(SortedList1).
  	
  move_line4("by producer",Length):-
	findall(I1,move(_,I1,_,_),P1List),
	rp_remove_duplicates(P1List,POnceList),
	obtain_producer_list(POnceList,PList),
	rp_listlength(PList,Length),
	rp_sort_list(b_true,PList,[],SortedList),
	SortedList = [E1|Rest],
	SortedList1 = [E1,E1|Rest],
	assert(rp_p1(SortedList1)),
	findall(Sort,tr_db_sort(_,Sort,_,_,_),SortList),
	rp_sort_list(b_true,SortList,[],SortSortedList),
	assert(rp_header(SortSortedList)),	
	!.
  	
  move_line4("by customer",Length):-
	findall(I1,move(_,_,I1,_),P1List),
	rp_remove_duplicates(P1List,POnceList),
	obtain_customer_list(POnceList,PList),
	rp_listlength(PList,Length),
	rp_sort_list(b_true,PList,[],SortedList),
	SortedList = [E1|Rest],
	SortedList1 = [E1,E1|Rest],
	assert(rp_p1(SortedList1)),
	findall(Sort,tr_db_sort(_,Sort,_,_,_),SortList),
	rp_sort_list(b_true,SortList,[],SortSortedList),
	assert(rp_header(SortSortedList)),	
	!.
  move_line4("by sort",Length):-
	findall(I1,move(I1,_,_,_),P1List),
	rp_remove_duplicates(P1List,POnceList),
	obtain_sort_list(POnceList,PList),
	rp_listlength(PList,Length),
	rp_sort_list(b_true,PList,[],SortedList),
	SortedList = [E1|Rest],
	SortedList1 = [E1,E1|Rest],
	assert(rp_p1(SortedList1)),
	findall(Cust,tr_db_customer(_,Cust,_,_,_),CustList),
	rp_sort_list(b_true,CustList,[],CustSortedList),
	assert(rp_header(CustSortedList)),	
	!.

  move_line4("supply",Length):-
	findall(I1,tr_db_producer(I1,_,_,_,_),P1List),
	obtain_producer_list(P1List,PList),
	rp_listlength(PList,Length),
	rp_sort_list(b_true,PList,[],SortedList),
	SortedList = [E1|Rest],
	SortedList1 = [E1,E1|Rest],
	assert(rp_p1(SortedList1)),
	findall(Sort,tr_db_sort(_,Sort,_,_,_),SortList),
	rp_sort_list(b_true,SortList,[],SortSortedList),
	assert(rp_header(SortSortedList)),	
	!.
  	
  move_line4("custom",Length):-
	findall(I1,tr_db_customer(I1,_,_,_,_),P1List),
	obtain_customer_list(P1List,PList),
	rp_listlength(PList,Length),
	rp_sort_list(b_true,PList,[],SortedList),
	SortedList = [E1|Rest],
	SortedList1 = [E1,E1|Rest],
	assert(rp_p1(SortedList1)),
	findall(Sort,tr_db_sort(_,Sort,_,_,_),SortList),
	rp_sort_list(b_true,SortList,[],SortSortedList),
	assert(rp_header(SortSortedList)),	
	!.

  header_line([],"Total	"):-!.
  header_line([E|Rest],Out):- !,
  	header_line(Rest,S),
  	format(Out,"%s	%s",E,S).

  obtain_parameter_list("by producer",P1,P2):-
	obtain_customer_list(P1,P2), !.

  obtain_parameter_list("by customer",P1,P2):-
	obtain_producer_list(P1,P2), !.
	
  obtain_parameter_list("by sort",P1,P2):-
	obtain_producer_list(P1,P2), !.

  obtain_producer_list([],[]):-!.
  obtain_producer_list([I|IList],[P|PList]):-
  	tr_db_producer(I,P,_,_,_), !,
  	obtain_producer_list(IList,PList).

  obtain_customer_list([],[]):-!.
  obtain_customer_list([I|IList],[P|PList]):-
  	tr_db_customer(I,P,_,_,_), !,
  	obtain_customer_list(IList,PList).
  	
  obtain_sort_list([],[]):-!.
  obtain_sort_list([I|IList],[P|PList]):-
  	tr_db_sort(I,P,_,_,_), !,
  	obtain_sort_list(IList,PList).

  rp_change_p2(_):-
  	retract(rp_p2(_)),
  	fail.
  rp_change_p2(S):-
  	assert(rp_p2(S)),
  	!.
  rp_change_p1(_):-
  	retract(rp_p1(_)),
  	fail.
  rp_change_p1(S):-
  	assert(rp_p1(S)),
  	!.

  get_movep2("by producer",SP1,I2):-
	tr_db_producer(I1,SP1,_,_,_),
  	move(_,I1,I2,_).

  get_movep2("by customer",SP1,I2):-
	tr_db_customer(I1,SP1,_,_,_),
  	move(_,I2,I1,_).

  get_movep2("by sort",SP1,I2):-
	tr_db_sort(I1,SP1,_,_,_),
  	move(I1,I2,_,_).

  add_sum([],_,[]):-!.
  add_sum([S1|R1],[S2|R2],[S|R]):-
  	S = S1 + S2, !,
  	add_sum(R1,R2,R).
 
  add_sumLine(Sum):-
	retract(sum_line(L)),
	add_sum(Sum,L,Out),
	assert(sum_line(Out)),
	!.
  add_sumLine(Sum):-
	assert(sum_line(Sum)),
	!.
	
  add_sumLine1(Sum):-
	retract(sum_line1(L)),
	add_sum(Sum,L,Out),
	assert(sum_line1(Out)),
	!.
  add_sumLine1(Sum):-
	assert(sum_line1(Sum)),
	!.
	
  get_sum_line([],""):-!.

  get_sum_line([E|Sum],Out):-
	get_sum_line(Sum,S), !,
	format(Out,"%D	%s",E,S).
  	
  get_sum_line1([],""):-!.

  get_sum_line1([E|Sum],Out):-
	get_sum_line1(Sum,S), !,
	format(Out,"%f	%s",E,S).

  store_outline(_):-
  	retract(outline1(_)),
  	fail.
  store_outline(OutList1):-
  	assert(outline1(OutList1)),
  	!.  	

  plan_overview(Retries,Conflicts,Prod,Order,Trans,Unplaced,Backlog):-
	genStatus(Ret,ConflictsSolved,Production,Ordr,Transportation,Unplcd,Bcklg),
	str_real(Retries,Ret),
	str_real(Conflicts,ConflictsSolved),
	str_real(Prod,Production),
	str_real(Order,Ordr),
	str_real(Trans,Transportation),
	str_real(Unplaced,Unplcd),
	str_real(Backlog,Bcklg),
	!.
  	
predicates
  supply_line(STRING,STRING,STRING)
  supply_line2(STRING,SLIST,LONG,STRING)
  custom_line(STRING,STRING,STRING)
  custom_line2(STRING,SLIST,LONG,STRING)
clauses

  supply_line(HeaderLine,P0,OutList):-
  	rp_p1(Param),
  	Param = [_|Rest],
  	Rest = [P0|_],
  	rp_change_p1(Rest),
  	rp_header(Header),
	header_line(Header,HeaderLine),
  	supply_line2(P0,Header,0,OutList),
  	!.

  supply_line2(_,[],S,OutList):-
  	format(OutList,"%D	",S), !.

  supply_line2(P0,[H|Rest],S,OutList):-
	tr_db_producer(I0,P0,_,_,_),
	tr_db_sort(I1,H,_,_,_),
	tr_db_production(I0,I1,Q),
	QL = val(LONG,Q),
	Sum = S + QL,
	supply_line2(P0,Rest,Sum,Str), !,
	format(OutList,"%D	%s",QL,Str).
  
  supply_line2(P0,[_|Rest],S,OutList):-
	supply_line2(P0,Rest,S,Str), !,
	format(OutList,"-	%s",Str).

  custom_line(HeaderLine,P0,OutList):-
  	rp_p1(Param),
  	Param = [_|Rest],
  	Rest = [P0|_],
  	rp_change_p1(Rest),
  	rp_header(Header),
	header_line(Header,HeaderLine),
  	custom_line2(P0,Header,0,OutList),
  	!.

  custom_line2(_,[],S,OutList):-
  	format(OutList,"%D	",S), !.

  custom_line2(P0,[H|Rest],S,OutList):-
	tr_db_customer(I0,P0,_,_,_),
	tr_db_sort(I1,H,_,_,_),
	tr_db_custom(I0,I1,Q),
	QL = val(LONG,Q),
	Sum = S + QL,
	custom_line2(P0,Rest,Sum,Str), !,
	format(OutList,"%D	%s",QL,Str).
  
  custom_line2(P0,[_|Rest],S,OutList):-
	custom_line2(P0,Rest,S,Str), !,
	format(OutList,"-	%s",Str).

predicates
determ	rp_ownerdraw_DrawButton(OD_ITEMACTION,OD_ITEMSTATE,RCT,WINDOW,RESID)
determ	rp_draw_up_push_button(WINDOW,RCT,RESID)
determ	rp_draw_down_push_button(WINDOW,RCT,RESID)
determ  mmmember(OD_ITEMSTATE,OD_STATE)
determ  mmmember(OD_ITEMACTION,OD_ACTION)
clauses

  mmmember([X|_],X):-!.
  mmmember([_|T],X):-mmmember(T,X).

  rp_ownerdraw_DrawButton(ACTIONLIST,_,RECT,W,RESID):- 
	mmmember(ACTIONLIST,odact_DrawEntire),
 	rp_draw_up_push_button(W,RECT,RESID),!.

  rp_ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,W,RESID):- 
	mmmember(ACTIONLIST,odact_Select),
	mmmember(STATELIST,odstate_Focus),
	mmmember(STATELIST,odstate_Selected),
	rp_draw_down_push_button(W,RECT,RESID),!.
	
  rp_ownerdraw_DrawButton(_,STATELIST,RECT,W,RESID):- 
	mmmember(STATELIST,odstate_Focus),
 	rp_draw_up_push_button(W,RECT,RESID),
	!.
	
  rp_draw_up_push_button(W,RECT,RESID):-
	Client = win_GetClientRect(W),
	Client = rct(_,_,Wid,Hei),
	RECT = rct(IconLeft,IconRight,_,_),
	win_SetBrush(W,brush(pat_Hollow,color_White)),
	draw_Icon(W,IconLeft,IconRight,RESID),
	draw_Rect(W,Client),
	win_SetPen(W,pen(1,ps_solid,color_White)),
	LB1 = Hei - 1,
	RT = Wid - 2, LB = Hei - 2,
	draw_PolyLine(W,[pnt(RT,0),pnt(0,0),pnt(0,LB1)]),
	win_SetPen(W,pen(1,ps_solid,color_Gray)),
	draw_PolyLine(W,[pnt(1,LB),pnt(RT,LB),pnt(RT,0)]),
	!.
  rp_draw_down_push_button(W,RECT,RESID):-
	Client = win_GetClientRect(W),
	Client = rct(_,_,Wid,Hei),
	RECT = rct(IconLeft,IconRight,_,_),
	draw_Icon(W,IconLeft,IconRight,RESID),
	win_SetPen(W,pen(1,ps_solid,color_Black)),
	win_SetBrush(W,brush(pat_Hollow,color_Black)),
	draw_Rect(W,Client),
	win_SetPen(W,pen(1,ps_solid,color_White)),
	RT1 = Wid - 1, LB1 = Hei - 1,
	draw_PolyLine(W,[pnt(0,LB1),pnt(RT1,LB1),pnt(RT1,0)]),
	win_SetPen(W,pen(1,ps_solid,color_Gray)),
	RT = Wid - 2, LB = Hei - 3,
	draw_PolyLine(W,[pnt(1,LB),pnt(1,1),pnt(RT,1)]),
  	!.
  	

/**************************************************************************************************
*		R E P O R T   C a l l b a c k   F u n c t i o n s   and
*		P R O G R E S S   I n d i c a t o r
***************************************************************************************************/
database - progress_db
determ wd(WINDOW)
determ wd_stop

predicates
	control_callback : PROCESS_PRED
	progress_cb	 : PROGRESS_PRED
	wd_eh		 : EHANDLER
procedure progress_setval(INTEGER)
procedure change_prgrs_indicator
procedure prgrs_drawstripe(WINDOW,RCT,INTEGER)
procedure prgrs_scale(WINDOW,INTEGER,INTEGER,INTEGER,INTEGER,REAL,LONG)
procedure rp_drawscalemarker(WINDOW,INTEGER,INTEGER,INTEGER)
procedure clear_wd	
clauses
  progress_cb(starting,_,b_false):-
	clear_wd,
  	NULLWIN=cast(window,0),
	TMP=win_GetAttrVal(NULLWIN,attr_task_window),
	TASK_WIN=cast(window,TMP),
	WD = win_CreateResDialog(TASK_WIN,wd_modeless,idd_cancel_dialog,wd_eh,0),
	assert(wd(WD)),
	progress_setval(0),
	!.

  progress_cb(finish,_,b_false):-
	wd(WD),
	win_PostEvent(WD,e_User(100,100)),
  	!.

  progress_cb(_,_,b_true):-
  	retract(wd_stop),
  	!.
  	
  progress_cb(_,_,b_false).
	
  wd_eh(_Win,e_OwnerDraw(od_Button,idc_cancel_button,_,ACTIONLIST,STATELIST,LW,_RECT,_),0):-
  	rp_ownerdraw_DrawButton(ACTIONLIST,STATELIST,rct(15,0,0,0),LW,idi_Stop),!.
 
  wd_eh(Win,e_Control(idc_cancel_button,_,_,_),0):-
  	not(wd_stop),
  	assert(wd_stop),
	win_PostEvent(Win,e_User(100,100)),
  	!.
  
  wd_eh(_Win,e_User(100,_),0):-
	clear_wd,!.

  wd_eh(_Win,e_Destroy,0):-
  	retractall(prgrs_table(_,_)),
  	!.

  prgrs_eh(_Win,e_Create(_),0):-
  	FONT = font_Create(ff_Helvetica,[],6),
  	win_SetFont(_Win,FONT),
  	!.

  prgrs_eh(_Win,e_EraseBackGround,0):- !.
  
  prgrs_eh(Win,e_Update(_),0):-
	Text = win_GetText(Win),
	str_int(Text,Val),
	RCT = win_GetClientRect(Win),
	RCT = rct(L,T,R,B),
	NewT = B - trunc((B - T) / 3),
	RBT = rct(L,NewT,R,B),
	prgrs_drawstripe(Win,RBT,Val),
	!.
  	
  progress_setval(Val):-
  	wd(Dlg),
  	trap(Ctl = win_GetCtlHandle(Dlg,idc_rpprogress),_,fail),
  	str_int(Text,Val),
  	win_setText(Ctl,Text),
	win_Invalidate(Ctl),
  	vpi_Processevents(b_true),
  	!.
  	
  progress_setval(_).

  change_prgrs_indicator:-
  	retract(prgrs_table(Part,Total)),
  	NewPart = Part + 1,
	assert(prgrs_table(NewPart,Total)),
  	Val = 100.0 * Part / Total,
	ValInt = val(INTEGER,Val),  	
	progress_setval(ValInt),
	!.

  change_prgrs_indicator.

  clear_wd:-
  	retract(wd(WD)),
  	win_Destroy(WD),
  	!.
  clear_wd.
 
  prgrs_drawstripe(Win,RCT,Val):-
	RCT = rct(L,T,R,B),
	Increment = 5,
	Delta = Increment * (R - L) / 100,
	DkColor = vpi_GetAttrVal(attr_color_btnshadow),
	prgrs_scale(Win,0,Increment,L,T,Delta,DkColor),
	L1 = L + 1, T1 = T + 1, B1 = B - 1,R1 = R - 1,
	win_SetPen(Win,pen(1,ps_Solid,DkColor)),
	draw_PolyLine(Win,[pnt(L1,B1),pnt(R1,B1),pnt(R1,T1)]),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_PolyLine(Win,[pnt(L1,B1),pnt(L1,T1),pnt(R1,T1)]),
	win_SetPen(Win,pen(1,ps_Solid,color_Green)),
	win_SetBrush(Win,brush(pat_Solid,color_Green)),
	L2 = L1 + 1, T2 = T1 + 1,
	R20 = trunc((R1 - 1 - L1) * val(long,Val) / 100) + L1,
	R2 = val(integer,R20),
	draw_Rect(Win,rct(L2,T2,R2,B1)),
	!.

  prgrs_scale(_Win,N,S,_L,_T,_Delta,_):-
  	N * S > 100,
  	!.
  	
  prgrs_scale(Win,N,S,L,T,Delta,DkColor):-
  	Res = N * S,
  	Modulo = Res mod 10,
  	Modulo = 0,!,
	Pos = L + trunc(N * Delta),
	Top = T - 7,
	NewPos = Pos + 1,
	win_SetPen(Win,pen(1,ps_Solid,DkColor)),
	draw_Line(Win,pnt(Pos,Top),pnt(Pos,T)),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_Line(Win,pnt(NewPos,Top),pnt(NewPos,T)),
	rp_drawscalemarker(Win,Res,Pos,Top),
	NewN = N + 1,
	prgrs_scale(Win,NewN,S,L,T,Delta,DkColor).
	
  prgrs_scale(Win,N,S,L,T,Delta,DkColor):-
	Pos = L + trunc(N * Delta),
	Top = T - 4,
	NewPos = Pos + 1,
	win_SetPen(Win,pen(1,ps_Solid,DkColor)),
	draw_Line(Win,pnt(Pos,Top),pnt(Pos,T)),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_Line(Win,pnt(NewPos,Top),pnt(NewPos,T)),
	NewN = N + 1,
	prgrs_scale(Win,NewN,S,L,T,Delta,DkColor).
  	
  rp_drawscalemarker(Win,0,Pos,Top):-
	PosT = Pos + 1, TT = Top - 5,
	draw_Text(Win,PosT,TT,"0"), !.
  rp_drawscalemarker(Win,100,Pos,Top):-
	PosT = Pos - 20, TT = Top - 5,
	draw_Text(Win,PosT,TT,"100"), !.
  rp_drawscalemarker(Win,Res,Pos,Top):-
	str_int(Str,Res), PosT = Pos - 8, TT = Top - 5,
	draw_Text(Win,PosT,TT,Str).

  control_callback(ID,_,[Header,Supplier,Out]):-
  	upper_lower(ID,"get_next_supplier"), !,
	change_prgrs_indicator,
	supply_line(Header,Supplier,Out).

  control_callback(ID,_,[Header,Supplier,Out]):-
  	upper_lower(ID,"get_next_customer"), !,
	change_prgrs_indicator,
	custom_line(Header,Supplier,Out).

  control_callback(ID,_,[Out]):-
  	upper_lower(ID,"get_sum_line"), !,
	sum_line(Sum),
	get_sum_line(Sum,OUT).

  control_callback(ID,_,[Out]):-
  	upper_lower(ID,"get_sum_line1"), !,
	sum_line1(Sum),
	get_sum_line1(Sum,OUT).

  control_callback(ID,[Key],[P2,Out]):-
  	upper_lower(ID,"get_second_loop"),
  	move_line(Key,P2,Out),
  	!.

  control_callback(ID,_,[Out]):-
  	upper_lower(ID,"get_nested_loop"),
  	move_line0(Out),
  	!.

  control_callback(ID,[Key],[P1,Out]):-
  	upper_lower(ID,"get_first_loop"),
  	retractall(sum_line(_)),
  	retractall(sum_line1(_)),
  	move_line1(Key,P1,Out),
	change_prgrs_indicator,
  	!.
  
  control_callback(ID,[Key],[]):-
  	upper_lower(ID,"init_main"),
	retractall(_,report_db),
  	move_line4(Key,LEN),
  	assert(prgrs_table(0,LEN)),
  	!.

  control_callback(ID,_,[Retries,Conflicts,Prod,Order,Trans,Unplaced,Backlod]):-
  	upper_lower(ID,"get_plan_ovr"),
  	plan_overview(Retries,Conflicts,Prod,Order,Trans,Unplaced,Backlod),
  	!.

/**************************************************************************************************
*
*		G L O B A L   P R E D I C A T E S
*
***************************************************************************************************/
clauses

  report_troverview_producer(_Win):-
	file_str("transprd.rep",Script),
	report_Print(Script,control_callback,progress_cb,
        preview("Transportation overview grouped by producers",rct(30,30,640,520),[repw_Zoomed])),
        !.
  report_troverview_customer(_Win):-
  	file_str("transcus.rep",Script),
	report_Print(Script,control_callback,progress_cb,
        preview("Transportation overview grouped by customers",rct(30,30,640,520),[repw_Zoomed])),
        !.
  report_troverview_sort(_Win):-
  	file_str("transsrt.rep",Script),
	report_Print(Script,control_callback,progress_cb,
        preview("Transportation overview grouped by sorts",rct(30,30,640,520),[repw_Zoomed])),
        !.

  report_supply_overview(_Win):-
  	file_str("supply.rep",Script),
	report_Print(Script,control_callback,progress_cb,
        preview("Supply Overview Report",rct(30,30,640,520),[repw_Zoomed])),
        !.
  
  report_custom_overview(_Win):-
	file_str("custom.rep",Script),
	report_Print(Script,control_callback,progress_cb,
        preview("Custom Overview Report",rct(30,30,640,520),[repw_Zoomed])),
        !.

  report_plan_overview(_Win):-
	file_str("planovr.rep",Script),
	report_Print(Script,control_callback,progress_cb,
        preview("Plan Overview Report",rct(30,30,640,520),[repw_Zoomed])),
        !.
  
