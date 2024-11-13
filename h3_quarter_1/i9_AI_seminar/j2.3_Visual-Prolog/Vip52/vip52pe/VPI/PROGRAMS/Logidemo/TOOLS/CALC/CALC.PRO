/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  trans
 FileName: calc.pro
 Purpose:  
 Written by: Sergey Alexeev
 Comments:
*****************************************************************************/

database - calc_dataset_db
  calc_active
  calc_callback(CALC_CALLBACK,INTEGER Details)

  calc_source(ULONG FromId,REAL MaxQuantity)
  calc_target(ULONG ToId,REAL NeedQuantity)
  calc_cost(ULONG FromId,ULONG ToId,Real TonCost)

  calc_real_buffer(REAL)
  calc_real_buffer1(REAL)
  calc_ullist_buffer(ULLIST)
  calc_rlist_buffer(RLIST)
  calc_unload(ULLIST FromIdList)
  calc_way(RLIST CostList,ULLIST IdList)

  calc_move(ULONG FromId,ULONG ToId,REAL Quantity)
  calc_move_tmp(ULONG FromId,ULONG ToId,REAL Quantity)

  calc_finish
/*************************************************************************
			COMMON predicates
*************************************************************************/
predicates
  calc_min(REAL,REAL,REAL)
clauses
  calc_min(A,B,A):-
	A < B,!.
  calc_min(_,B,B).

predicates
  calc_member(ULONG,ULLIST)
clauses
  calc_member(S,[S|_]):-!.
  calc_member(S,[_|L]):-
	calc_member(S,L).

predicates
  calc_member_2(ULONG,ULLIST)
clauses
  calc_member_2(_,[]):-!,fail.
  calc_member_2(_,[_|[]]):-!,fail.
  calc_member_2(S,[_,S|_]):-!.
  calc_member_2(S,[_,_|L]):-!,
	calc_member_2(S,L).

predicates
  calc_summ_rlist(RLIST,REAL,REAL)
clauses
  calc_summ_rlist([],Out,Out):-!.
  calc_summ_rlist([R|Rest],Curr,Out):-
	C = Curr + R,!,
	calc_summ_rlist(Rest,C,Out).

predicates
  calc_get_min_from_list(RLIST,REAL,REAL)
clauses
  calc_get_min_from_list([],Curr,Out):-
	Curr < 1e300,
	Out = Curr,!.
  calc_get_min_from_list([R|Rest],Curr,Out):-
	R < Curr,!,
	calc_get_min_from_list(Rest,R,Out).
  calc_get_min_from_list([_|Rest],Curr,Out):-
	calc_get_min_from_list(Rest,Curr,Out).

predicates
  calc_reverse_list1(ULLIST,ULLIST,ULLIST)
clauses
  calc_reverse_list1([],IdList,IdList):-!.
  calc_reverse_list1([Id|Rest],IL,IdList):-!,
     calc_reverse_list1(Rest,[Id|IL],IdList).

predicates
  calc_reverse_list(ULLIST,ULLIST)
clauses
  calc_reverse_list(Input,Output):-
	calc_reverse_list1(Input,[],Output),!.

/*************************************************************************
			SPECIAL predicates
*************************************************************************/
/*************************************************************************
			SEND CALLBACK
*************************************************************************/
predicates
  calc_get_unplaced(REAL Unplaced)
  calc_get_needed(REAL Unplaced)
  calc_send_callback(CALC_EVENT)
clauses
  calc_send_callback(Event):-
	calc_callback(CallBackFunc,_),
	CallBackFunc(Event),
	fail.
  calc_send_callback(_).

/*************************************************************************
	     convert dataset from external to internal and back
*************************************************************************/
predicates
  calc_build_source_base1(CALC_ITEMLIST)
clauses
  calc_build_source_base1([]):-!.
  calc_build_source_base1([i(FromId,Have)|Rest]):-
	assert(calc_source(FromId,Have)),
	calc_build_source_base1(Rest).

predicates
  calc_build_source_base(CALC_ITEMLIST)
clauses
  calc_build_source_base(SourceList):-
	retractall(calc_source(_,_)),
	calc_build_source_base1(SourceList),!.

predicates
  calc_build_target_base1(CALC_ITEMLIST)
clauses
  calc_build_target_base1([]):-!.
  calc_build_target_base1([i(ToId,Need)|Rest]):-
	assert(calc_target(ToId,Need)),
	calc_build_target_base1(Rest).

predicates
  calc_build_target_base(CALC_ITEMLIST)
clauses
  calc_build_target_base(TargetList):-
	retractall(calc_target(_,_)),
	calc_build_target_base1(TargetList),!.

predicates
  calc_build_distance_base1(CALC_COSTLIST)
clauses
  calc_build_distance_base1([]):-!.
  calc_build_distance_base1([c(FromId,ToId,Cost)|Rest]):-
	calc_source(FromId,_),
	calc_target(ToId,_),
	assert(calc_cost(FromId,ToId,Cost)),!,
	calc_build_distance_base1(Rest).
  calc_build_distance_base1([_|Rest]):-!,
	calc_build_distance_base1(Rest).

predicates
  calc_build_distance_base(CALC_COSTLIST)
clauses
  calc_build_distance_base(CostList):-
	retractall(calc_cost(_,_,_)),
	calc_build_distance_base1(CostList),!.

predicates
  nondeterm calc_get_move_fact(CALC_MOVE)
clauses
  calc_get_move_fact(Out):-
	calc_move(FromId,ToId,Quantity),
	Out = m(FromId,ToId,Quantity).

predicates
  nondeterm calc_get_unplaced_fact(CALC_ITEM)
  calc_get_source_need(ULONG FromId,REAL SummNeed)
clauses
  calc_get_unplaced_fact(Out):-
	calc_source(FromId,MaxQuantity),
	calc_get_source_need(FromId,SummNeed),
	MaxQuantity > SummNeed,
	Delta = MaxQuantity - SummNeed,
	Out = i(FromId,Delta).

predicates
  nondeterm calc_get_needed_fact(CALC_ITEM)
  calc_get_target_have(ULONG ToId,REAL SummHave)
clauses
  calc_get_needed_fact(Out):-
	calc_target(ToId,MaxQuantity),
	calc_get_target_have(ToId,SummHave),
	MaxQuantity > SummHave,
	Delta = MaxQuantity - SummHave,
	Out = i(ToId,Delta).

predicates
  nondeterm calc_get_moved_cost(REAL Cost)
clauses
  calc_get_moved_cost(Out):-
	calc_move(FromId,ToId,Quantity),
	calc_cost(FromId,ToId,TonCost),
	Out = Quantity * TonCost.

predicates
  calc_adjust_move()
clauses
  calc_adjust_move():-
	calc_move(FromId,ToId,_),
	findall(Quantity,calc_move(FromId,ToId,Quantity),QuantityList),
	calc_summ_rlist(QuantityList,0,SummQuantity),
	retractall(calc_move(FromId,ToId,_)),
	assert(calc_move_tmp(FromId,ToId,SummQuantity)),
	fail.
  calc_adjust_move():-
	retract(calc_move_tmp(FromId,ToId,Quantity)),
	assert(calc_move(FromId,ToId,Quantity)),
	fail.
  calc_adjust_move().

predicates
  calc_get_cost(REAL Cost)
clauses
  calc_get_cost(SummCost):-
	findall(Cost,calc_get_moved_cost(Cost),CostList),
	calc_summ_rlist(CostList,0,SummCost),!.

predicates
  calc_get_rezult(CALC_MOVELIST,CALC_ITEMLIST,CALC_ITEMLIST)
clauses
  calc_get_rezult(MoveList,UnPlacedList,NeededList):-
	calc_adjust_move(),
	findall(Move,calc_get_move_fact(Move),MoveList),
	findall(UnPlaced,calc_get_unplaced_fact(UnPlaced),UnPlacedList),
	findall(Needed,calc_get_needed_fact(Needed),NeededList),!.

predicates
  nondeterm calc_get_first_move(CALC_MOVE)
clauses
  calc_get_first_move(Out):-
	calc_move(FromId,ToId,Quantity),
	Out = m(FromId,ToId,Quantity).

predicates
  calc_get_source_status(ULLIST FromIdList,REAL,REAL OverchargeSources,REAL,REAL UnderchargeSources)
clauses
  calc_get_source_status([],OverchargeSources,OverchargeSources,UnderchargeSources,UnderchargeSources):-!.
  calc_get_source_status([FromId|Rest],O,OverchargeSources,U,UnderchargeSources):-
	calc_source(FromId,MaxQuantity),
	calc_get_source_need(FromId,SummNeed),
	SummNeed > MaxQuantity,
	Delta = SummNeed - MaxQuantity,
	O1 = O + Delta,!,
	calc_get_source_status(Rest,O1,OverchargeSources,U,UnderchargeSources).
  calc_get_source_status([FromId|Rest],O,OverchargeSources,U,UnderchargeSources):-
	calc_source(FromId,MaxQuantity),
	calc_get_source_need(FromId,SummNeed),
	Delta = MaxQuantity - SummNeed,
	U1 = U + Delta,!,
	calc_get_source_status(Rest,O,OverchargeSources,U1,UnderchargeSources).

predicates
  calc_get_target_status(ULLIST ToIdList,REAL,REAL UnsatisfiedTarget)
clauses
  calc_get_target_status([],UnsatisfiedTarget,UnsatisfiedTarget):-!.
  calc_get_target_status([ToId|Rest],U,UnsatisfiedTarget):-
	calc_target(ToId,MaxQuantity),
	calc_get_target_have(ToId,SummHave),
	U1 = U + (MaxQuantity - SummHave),!,
	calc_get_target_status(Rest,U1,UnsatisfiedTarget).

predicates
  calc_send_status()
clauses
  calc_send_status():-
	calc_callback(_,_),
	findall(Moved,calc_get_first_move(Moved),MovedList),
	findall(FromId,calc_source(FromId,_),FromIdList),
	calc_get_source_status(FromIdList,0,OverchargeSources,0,UnderchargeSources),
	findall(ToId,calc_target(ToId,_),ToIdList),
	calc_get_target_status(ToIdList,0,UnsatisfiedTarget),
	calc_send_callback(status(OverchargeSources,UnderchargeSources,UnsatisfiedTarget,MovedList)),!.
  calc_send_status().

/*************************************************************************
			     manipulate with internal base
*************************************************************************/
predicates
  calc_add_ullist(ULONG)
clauses
  calc_add_ullist(R):-
	retract(calc_ullist_buffer(R1)),
	assert(calc_ullist_buffer([R|R1])),!.
  calc_add_ullist(R):-
	retractall(calc_ullist_buffer(_)),
	assert(calc_ullist_buffer([R])),!.

predicates
  calc_sub_ullist(ULONG)
clauses
  calc_sub_ullist(R):-
	retract(calc_ullist_buffer(R1)),
	R1 = [R|Rest],
	assert(calc_ullist_buffer(Rest)),!.

predicates
  calc_add_rlist(REAL)
clauses
  calc_add_rlist(R):-
	retract(calc_rlist_buffer(R1)),
	assert(calc_rlist_buffer([R|R1])),!.
  calc_add_rlist(R):-
	retractall(calc_rlist_buffer(_)),
	assert(calc_rlist_buffer([R])),!.

predicates
  calc_sub_rlist(REAL)
clauses
  calc_sub_rlist(R):-
	retract(calc_rlist_buffer(R1)),
	R1 = [R|Rest],
	assert(calc_rlist_buffer(Rest)),!.

predicates
  calc_add_real(REAL)
clauses
  calc_add_real(R):-
	retract(calc_real_buffer(R1)),
	R2 = R1 + R,
	assert(calc_real_buffer(R2)),!.
  calc_add_real(R):-
	retractall(calc_real_buffer(_)),
	assert(calc_real_buffer(R)),!.

predicates
  calc_add_real1(REAL)
clauses
  calc_add_real1(R):-
	retract(calc_real_buffer1(R1)),
	R2 = R1 + R,
	assert(calc_real_buffer1(R2)),!.
  calc_add_real1(R):-
	retractall(calc_real_buffer1(_)),
	assert(calc_real_buffer1(R)),!.

predicates
  calc_sub_real(REAL)
clauses
  calc_sub_real(R):-
	retract(calc_real_buffer(R1)),
	R2 = R1 - R,
	assert(calc_real_buffer(R2)),!.
  calc_sub_real(R):-
	retractall(calc_real_buffer(_)),
	R2 = 0 - R,
	assert(calc_real_buffer(R2)),!.

/*************************************************************************
			     move predicates
*************************************************************************/
predicates
  calc_near_move(ULONG ToId,REAL Cost,REAL Need)
clauses
/*  calc_near_move(ToId,Cost,Need):-
	calc_cost(FromId,ToId,Cost),
	calc_source(FromId,MaxQuantity),
	calc_get_source_need(FromId,SummNeed),
	MaxQuantity > SummNeed,
	Delta = MaxQuantity - SummNeed,
	Delta >= Need,
	assert(calc_move(FromId,ToId,Need)),!.
  calc_near_move(ToId,Cost,Need):-
	calc_cost(FromId,ToId,Cost),
	calc_source(FromId,MaxQuantity),
	calc_get_source_need(FromId,SummNeed),
	MaxQuantity > SummNeed,
	Delta = MaxQuantity - SummNeed,
	Delta < Need,
	assert(calc_move(FromId,ToId,Delta)),
	Need1 = Need - Delta,!,
	calc_near_move(ToId,Cost,Need1). */
  calc_near_move(ToId,Cost,Need):-
	calc_cost(FromId,ToId,Cost),
	assert(calc_move(FromId,ToId,Need)),!.

predicates
  calc_first_move()
clauses
  calc_first_move():-
	calc_target(ToId,Need),
	findall(C,calc_cost(_,ToId,C),CostList),
	calc_get_min_from_list(CostList,1e300,Cost),
	Cost < 1e300,
	calc_near_move(ToId,Cost,Need),
	fail.
  calc_first_move():-
	calc_send_status(),!.

predicates
  calc_move_product(ULONG ToId,ULONG OldFromId,ULONG NewFromId,REAL Quantity)
clauses
  calc_move_product(ToId,OldFromId,NewFromId,Quantity):-
	retract(calc_move(OldFromId,ToId,Quantity)),
	assert(calc_move(NewFromId,ToId,Quantity)),!.
  calc_move_product(ToId,OldFromId,NewFromId,Quantity):-
	retract(calc_move(OldFromId,ToId,FullQuantity)),
	DiffQuantity = FullQuantity - Quantity,
	assert(calc_move(OldFromId,ToId,DiffQuantity)),
	assert(calc_move(NewFromId,ToId,Quantity)),!.

predicates
  calc_move_product_list(ULLIST IdList,REAL Quantity)
clauses
  calc_move_product_list([NewFromId,ToId,OldFromId|[]],Quantity):-
	calc_move_product(ToId,OldFromId,NewFromId,Quantity),!.
  calc_move_product_list([NewFromId,ToId,OldFromId|Rest],Quantity):-
	calc_move_product(ToId,OldFromId,NewFromId,Quantity),!,
	calc_move_product_list([OldFromId|Rest],Quantity).

/*************************************************************************
			     calculate predicates
*************************************************************************/
  calc_get_source_need(FromId,_):-
	retractall(calc_real_buffer(_)),
	calc_move(FromId,_,Quantity),
	calc_add_real(Quantity),
	fail.
  calc_get_source_need(_,SummNeed):-
	retract(calc_real_buffer(SummNeed)),!.
  calc_get_source_need(_,0).

  calc_get_target_have(ToId,_):-
	retractall(calc_real_buffer(_)),
	calc_move(_,ToId,Quantity),
	calc_add_real(Quantity),
	fail.
  calc_get_target_have(_,SummHave):-
	retract(calc_real_buffer(SummHave)),!.
  calc_get_target_have(_,0).

  calc_get_unplaced(_):-
	retractall(calc_real_buffer1(_)),
	calc_source(FromId,MaxQuantity),
	calc_get_source_need(FromId,SummNeed),
	SummNeed > MaxQuantity,
	Delta = SummNeed - MaxQuantity,
	calc_add_real1(Delta),
	fail.
  calc_get_unplaced(Unplaced):-
	retract(calc_real_buffer1(Unplaced)),!.
  calc_get_unplaced(0).

  calc_get_needed(_):-
	retractall(calc_real_buffer1(_)),
	calc_target(ToId,MaxQuantity),
	calc_get_target_have(ToId,SummHave),
	MaxQuantity > SummHave,
	Delta = MaxQuantity - SummHave,
	calc_add_real1(Delta),
	fail.
  calc_get_needed(Needed):-
	retract(calc_real_buffer1(Needed)),!.
  calc_get_needed(0).

predicates
  calc_get_source_overload(ULONG FromId)
clauses
  calc_get_source_overload(FromId):-
	calc_source(FromId,MaxQuantity),
	calc_get_source_need(FromId,SummNeed),
	SummNeed > MaxQuantity,!.

predicates
  calc_get_source_unload(ULLIST FromIdList)
clauses
  calc_get_source_unload(_):-
	retractall(calc_ullist_buffer(_)),
	fail.
  calc_get_source_unload(_):-
	calc_source(FromId,MaxQuantity),
	findall(Quantity,calc_move(FromId,_,Quantity),QuantityList),
	calc_summ_rlist(QuantityList,0,Need),
	MaxQuantity > Need,
	calc_add_ullist(FromId),
	fail.
  calc_get_source_unload(FromIdList):-
	retract(calc_ullist_buffer(FromIdList)),!.

/*************************************************************************
			     optimize predicates
*************************************************************************/
predicates
  calc_reduce_source(ULONG FromId)
clauses
  calc_reduce_source(FromId):-
	retractall(calc_move_tmp(_,_,_)),
	calc_get_source_need(FromId,UseQuantity),
	calc_source(FromId,MaxQuantity),
	Koef = MaxQuantity / UseQuantity,
	retract(calc_move(FromId,ToId,Quantity)),
	NewQuantity = Quantity * Koef,
	assert(calc_move_tmp(FromId,ToId,NewQuantity)),
	calc_send_callback(reduce(FromId,ToId,Quantity,NewQuantity)),
	fail.
  calc_reduce_source(_):-
	retract(calc_move_tmp(FromId,ToId,Quantity)),
	assert(calc_move(FromId,ToId,Quantity)),
	fail.
  calc_reduce_source(_).

predicates
  calc_save_way()
clauses
  calc_save_way():-
	calc_rlist_buffer(Cost),
	calc_ullist_buffer(IdList),
	retractall(calc_way(_,_)),
	assert(calc_way(Cost,IdList)),!.

predicates
  calc_check_point(ULONG Id,REAL Cost)
clauses
  calc_check_point(Id,_):-
	calc_ullist_buffer(IdList),
	calc_member_2(Id,IdList),!,
	fail.
  calc_check_point(_,Cost):-
	calc_way(CostList1,_),
	calc_rlist_buffer(CostList2),
	calc_summ_rlist(CostList1,0,Cost1),
	calc_summ_rlist(CostList2,0,Cost2),
	Cost3 = Cost2 + Cost,
	Cost3 >= Cost1,!,
	fail.
  calc_check_point(_,_).

predicates
  calc_send_way_callback(INTEGER Details)
  calc_send_way_callback(INTEGER Details,ULONG Id)
clauses
  calc_send_way_callback(1):-
	calc_callback(_,D),
	D <> 1,!.
  calc_send_way_callback(Details):-
	calc_callback(_,D),
	Details <= D,
	calc_ullist_buffer(IdList),
	calc_reverse_list(IdList,IdList1),
	calc_send_callback(find_way(IdList1)),!.
  calc_send_way_callback(_).
  calc_send_way_callback(Details,Id):-
	calc_callback(_,D),
	Details <= D,
	calc_ullist_buffer(IdList),
	calc_reverse_list([Id|IdList],IdList1),
	calc_send_callback(find_way(IdList1)),!.
  calc_send_way_callback(_,_).

predicates
  calc_get_target(ULONG FromId)
  calc_get_source(ULONG ToId)
  calc_get_unload_source(ULONG ToId)
clauses
  calc_get_target(_):-
	calc_finish,!,
	fail.
  calc_get_target(FromId):-
	calc_unload(FromIdList),
	calc_member(FromId,FromIdList),
	calc_save_way(),
	calc_send_way_callback(1),
	calc_sub_rlist(_),
	calc_sub_ullist(_),!,
	fail.
  calc_get_target(FromId):-
	calc_move(FromId,ToId,_),
	calc_send_way_callback(3,ToId),
	calc_cost(FromId,ToId,TonCost),
	TonCost1 = 0 - TonCost,
	calc_check_point(ToId,TonCost1),
	calc_add_rlist(TonCost1),
	calc_add_ullist(ToId),
	calc_send_way_callback(2),
	calc_get_unload_source(ToId),
	fail.
  calc_get_target(FromId):-
	calc_move(FromId,ToId,_),
	calc_send_way_callback(3,ToId),
	calc_cost(FromId,ToId,TonCost),
	TonCost1 = 0 - TonCost,
	calc_check_point(ToId,TonCost1),
	calc_add_rlist(TonCost1),
	calc_add_ullist(ToId),
	calc_send_way_callback(2),
	calc_get_source(ToId),
	fail.
  calc_get_target(_):-
	calc_sub_rlist(_),
	calc_sub_ullist(_),
	calc_send_way_callback(2),!,
	fail.

  calc_get_unload_source(_):-
	calc_finish,!,
	fail.
  calc_get_unload_source(ToId):-
	calc_cost(FromId,ToId,TonCost),
	calc_send_way_callback(3,FromId),
	not(calc_move(FromId,ToId,_)),
	calc_unload(FromIdList),
	calc_member(FromId,FromIdList),
	calc_check_point(FromId,TonCost),
	calc_add_rlist(TonCost),
	calc_add_ullist(FromId),
	calc_send_way_callback(2),
	calc_get_target(FromId),
	fail.
  calc_get_unload_source(_):-
	calc_sub_rlist(_),
	calc_sub_ullist(_),
	calc_send_way_callback(2),!,
	fail.

  calc_get_source(_):-
	calc_finish,!,
	fail.
  calc_get_source(ToId):-
	calc_cost(FromId,ToId,TonCost),
	calc_send_way_callback(3,FromId),
	not(calc_move(FromId,ToId,_)),
	calc_check_point(FromId,TonCost),
	calc_add_rlist(TonCost),
	calc_add_ullist(FromId),
	calc_send_way_callback(2),
	calc_get_target(FromId),
	fail.
  calc_get_source(_):-
	calc_sub_rlist(_),
	calc_sub_ullist(_),
	calc_send_way_callback(2),!,
	fail.

predicates
  calc_get_move_quantity(ULLIST IdList,REAL Delta,REAL RealDelta)
clauses
  calc_get_move_quantity([ToId,FromId|[]],Delta,RealDelta):-
	calc_target(ToId,NeedQuantity),
	calc_min(Delta,NeedQuantity,Delta1),
	calc_get_source_need(FromId,UseQuantity),
	calc_source(FromId,MaxQuantity),
	Delta2 = UseQuantity - MaxQuantity,
	calc_min(Delta1,Delta2,RealDelta),!.
  calc_get_move_quantity([ToId,_|Rest],Delta,RealDelta):-
	calc_target(ToId,NeedQuantity),
	calc_min(Delta,NeedQuantity,Delta1),!,
	calc_get_move_quantity(Rest,Delta1,RealDelta).

predicates
  calc_optimize_source(ULONG FromId)
clauses
  calc_optimize_source(FromId):-
	not(calc_finish),
	retractall(calc_way(_,_)),
	retractall(calc_ullist_buffer(_)),
	retractall(calc_rlist_buffer(_)),
	calc_get_source_unload(FromIdList),
	retractall(calc_unload(_)),
	assert(calc_unload(FromIdList)),
	calc_add_ullist(FromId),
	calc_get_target(FromId),!.
  calc_optimize_source(_):-
	not(calc_finish),
	retract(calc_way(_,IdList)),
	IdList = [UnLoadId|Rest],
	calc_get_source_need(UnLoadId,UseQuantity),
	calc_source(UnLoadId,MaxQuantity),
	Delta = MaxQuantity - UseQuantity,
	calc_get_move_quantity(Rest,Delta,RealDelta),
	calc_move_product_list(IdList,RealDelta),
	calc_reverse_list(IdList,IdList1),
	calc_send_callback(move(IdList1,RealDelta)),!.
  calc_optimize_source(FromId):-
	not(calc_finish),
	calc_reduce_source(FromId),!.

predicates
  calc_optimize()
clauses
  calc_optimize():-
	not(calc_finish),
	calc_get_source_overload(FromId),!,
	calc_optimize_source(FromId),
	calc_optimize().
  calc_optimize().

predicates
  calc_convert_details(CALC_MESSAGE_DETAILS,INTEGER)
clauses
  calc_convert_details(none,0):-!.
  calc_convert_details(minimum,1):-!.
  calc_convert_details(middle,2):-!.
  calc_convert_details(maximum,3):-!.

/**global PREDICATE*******************************************************
			     CALC_TRANS
*************************************************************************/
  calc_trans(FromList,ToList,CostList,CallBackFunc,Details,MoveList,UnPlacedList,NeededList):-
	retractall(calc_finish),
	not(calc_active),
	calc_convert_details(Details,DetailsI),
	retractall(calc_callback(CallBackFunc,DetailsI)),
	assert(calc_callback(CallBackFunc,DetailsI)),
	calc_trans(FromList,ToList,CostList,MoveList,UnPlacedList,NeededList),
	retract(calc_callback(_,_)),!.

  calc_trans(FromList,ToList,CostList,MoveList,UnPlacedList,NeededList):-
	retractall(calc_finish),
	not(calc_active),
	assert(calc_active),
	retractall(calc_source(_,_)),
	retractall(calc_target(_,_)),
	retractall(calc_cost(_,_,_)),
	retractall(calc_real_buffer(_)),
	retractall(calc_real_buffer1(_)),
	retractall(calc_ullist_buffer(_)),
	retractall(calc_rlist_buffer(_)),
	retractall(calc_unload(_)),
	retractall(calc_way(_,_)),
	retractall(calc_move(_,_,_)),
	retractall(calc_move_tmp(_,_,_)),
	time(Hours,Minutes,Seconds,Hundredths),
	Time = val(ulong,Hours) * 360000 + val(ulong,Minutes) * 6000 + val(ulong,Seconds) * 100 + Hundredths,
	calc_send_callback(begin_time(Time)),

	calc_build_source_base(FromList),
	calc_build_target_base(ToList),
	calc_build_distance_base(CostList),
	calc_first_move(),
	calc_optimize(),
	calc_get_rezult(MoveList,UnPlacedList,NeededList),

	time(Hours1,Minutes1,Seconds1,Hundredths1),
	Time1 = val(ulong,Hours1) * 360000 + val(ulong,Minutes1) * 6000 + val(ulong,Seconds1) * 100 + Hundredths1,
	calc_send_callback(end_time(Time1)),

	retract(calc_active),!.

/**global PREDICATE*******************************************************
			     CALC_BREAK
*************************************************************************/
  calc_break():-
	retractall(calc_finish),
	assert(calc_finish),
	retractall(calc_active),!.
