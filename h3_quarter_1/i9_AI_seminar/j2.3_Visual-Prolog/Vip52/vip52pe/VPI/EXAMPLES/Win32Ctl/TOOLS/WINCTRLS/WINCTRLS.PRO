/******************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	WINCTRLS.PRO
 Purpose:	Common part for use Windows custom control objects
 Written by:	Sergey Alexeev
 Version:	1.0
 Build:		002.000316
 Tested with:   Visual Prolog v.5.0 build 533
 Comments:
******************************************************************************/
ifndef winctrls_pre_included
 #Error: this file requires include: winctrls.pre
enddef 

ifdef use_winctrl_common

GLOBAL PREDICATES
  procedure WINDOW /*WTVWin*/ _wcc_create(WCC_POINT Hinst,WINDOW Parent,STRING ClassName,STRING WinName,INTEGER Flags) - (i,i,i,i,i) language C
  procedure WCC_POINT /*Himage*/ _wcc_bitmap_create(INTEGER Width,INTEGER Height,INTEGER Num) - (i,i,i) language C
  procedure INTEGER /*BitmapIndex*/ _wcc_bitmap_add(WCC_POINT Hinst,WCC_POINT Himage,RESID BitmapId) - (i,i,i) language C
  procedure _wcc_bitmap_destroy(WCC_POINT Himage) - (i) language C

CONSTANTS
wm_notify		= 78

nm_outofmemory		= 0xffffffff
nm_click		= 0xfffffffe
nm_dblclk		= 0xfffffffd
nm_return		= 0xfffffffc
nm_rclick		= 0xfffffffb
nm_rdblclk		= 0xfffffffa
nm_setfocus		= 0xfffffff9
nm_killfocus		= 0xfffffff8
nm_customdraw		= 0xfffffff4
nm_hover		= 0xfffffff3

PREDICATES
  procedure wcc_del_from_list(ILIST In,INTEGER Item,ILIST,ILIST Out)
CLAUSES
  wcc_del_from_list([],_,Out,Out):-!.
  wcc_del_from_list([Item|Rest],Item,Curr,Out):-!,
	wcc_del_from_list(Rest,Item,Curr,Out).
  wcc_del_from_list([I|Rest],Item,Curr,Out):-!,
	wcc_del_from_list(Rest,Item,[I|Curr],Out).
  wcc_del_from_list(_,_,_,[]):-
	errorexit(),!.

PREDICATES
  procedure wcc_max(INTEGER,INTEGER,INTEGER)
CLAUSES
  wcc_max(A,B,A):-
	A > B,!.
  wcc_max(_,B,B).

PREDICATES
  procedure wcc_min(INTEGER,INTEGER,INTEGER)
CLAUSES
  wcc_min(A,B,A):-
	A < B,!.
  wcc_min(_,B,B).

PREDICATES
  determ wcc_member(INTEGER,ILIST)
CLAUSES
  wcc_member(S,[S|_]):-!.
  wcc_member(S,[_|L]):-
	wcc_member(S,L).

PREDICATES
  determ wcc_member_index(INTEGER,ILIST,UNSIGNED)
CLAUSES
  wcc_member_index(S,[S|_],1):-!.
  wcc_member_index(S,[_|L],M):-
	bound(M),!,
	N = M - 1,
	wcc_member_index(S,L,N),!.
  wcc_member_index(S,[_|L],M):-
	bound(S),
	wcc_member_index(S,L,N),!,
	M = N + 1.

PREDICATES
  procedure wcc_del_equal(ILIST,ILIST,ILIST)
CLAUSES
  wcc_del_equal([],O,O):-!.
  wcc_del_equal([A|R],C,O):-
	wcc_member(A,C),!,
	wcc_del_equal(R,C,O).
  wcc_del_equal([A|R],C,O):-!,
	wcc_del_equal(R,[A|C],O).
  wcc_del_equal(_,_,[]):-
	errorexit(),!.

PREDICATES
  procedure wcc_length_list(ILIST,INTEGER)
  procedure wcc_length_list1(ILIST,INTEGER,INTEGER)
  procedure wcc_length_list(LV_COLUMNLIST,INTEGER)
  procedure wcc_length_list1(LV_COLUMNLIST,INTEGER,INTEGER)
  procedure wcc_length_list(UD_ACCELERATORLIST,INTEGER)
  procedure wcc_length_list1(UD_ACCELERATORLIST,INTEGER,INTEGER)
CLAUSES
  wcc_length_list(InList,Out):-
	wcc_length_list1(InList,0,Out),!.

  wcc_length_list1([],Out,Out):-!.
  wcc_length_list1([_|Rest],O,Out):-
	O1 = O + 1,!,
	wcc_length_list1(Rest,O1,Out).
  wcc_length_list1(_,_,0):-
	errorexit(),!.

PREDICATES
  procedure wcc_summ_list(ILIST Flags,INTEGER,INTEGER SummFlags)
CLAUSES
  wcc_summ_list([],S,S):-!.
  wcc_summ_list([Flag|Rest],C,S):-
	C1 = C + Flag,!,
	wcc_summ_list(Rest,C1,S).
  wcc_summ_list(_,_,0):-
	errorexit(),!.

PREDICATES
  procedure wcc_get_state_list(INTEGER State,ILIST Flags,ILIST,ILIST StateList)
CLAUSES
  wcc_get_state_list(_,[],StateList,StateList):-!.
  wcc_get_state_list(State,[Flag|Rest],C,StateList):-
	bitand(State,Flag,Result),
	Result = Flag,!,
	wcc_get_state_list(State,Rest,[Flag|C],StateList).
  wcc_get_state_list(State,[_|Rest],C,StateList):-!,
	wcc_get_state_list(State,Rest,C,StateList).
  wcc_get_state_list(_,_,_,[]):-
	errorexit(),!.

PREDICATES
  determ wcc_get_from_list(SLIST In,UNSIGNED Position,STRING Value)
CLAUSES
  wcc_get_from_list([],_,_):-!,fail.
  wcc_get_from_list([Value|_],1,Value):-!.
  wcc_get_from_list([_|Rest],Position,Value):-
	P = Position - 1,!,
	wcc_get_from_list(Rest,P,Value).

PREDICATES
  procedure wcc_get_bitmap_size(ILIST BitmapIdList,INTEGER,INTEGER,INTEGER X,INTEGER Y)
CLAUSES
  wcc_get_bitmap_size([],X,Y,X,Y):-!.
  wcc_get_bitmap_size([BitmapId|Rest],CX,CY,X,Y):-
	Pict = pict_GetFromRes(BitmapId),
	pict_GetSize(Pict,Width,Height,_),
	pict_Destroy (Pict),
	wcc_max(CX,Width,CX1),
	wcc_max(CY,Height,CY1),!,
	wcc_get_bitmap_size(Rest,CX1,CY1,X,Y).
  wcc_get_bitmap_size(_,_,_,0,0):-
	errorexit(),!.

PREDICATES
  procedure wcc_reverse_list(ILIST,ILIST)
  procedure wcc_reverse_list(TV_TREELIST,TV_TREELIST)
  procedure wcc_reverse_list1(ILIST,ILIST,ILIST)
  procedure wcc_reverse_list1(TV_TREELIST,TV_TREELIST,TV_TREELIST)
CLAUSES
  wcc_reverse_list(Input,Output):-
	wcc_reverse_list1(Input,[],Output),!.

  wcc_reverse_list1([],IdList,IdList):-!.
  wcc_reverse_list1([Id|Rest],IL,IdList):-!,
	wcc_reverse_list1(Rest,[Id|IL],IdList).
  wcc_reverse_list1(_,_,[]):-
	errorexit(),!.

enddef /*** use_winctrl_common ***/

