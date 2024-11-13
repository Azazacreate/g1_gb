/*****************************************************************************

	(c) Copyright 1984 - 2000 Prolog Development Center A/S

 FileName: SLEEP.PRO
 Purpose:  DELAY with releasing time slice. (used by setup3.pro)
 Written by: Zaichenko Michael
 Comments:
******************************************************************************/
ifndef platform_16bit
 "need dos platform"
enddef
ifndef os_dos
 "need dos platform"
elsedef
 ifdef ws_win
  "need dos platform"
 enddef
 ifdef dosx286
  "need dos platform"
 enddef
constants
  secInOneDay	= 60*60*24

predicates

procedure  free_timeslice()
procedure  DWORD  getLongTime(DWORD,DWORD,DWORD,DWORD)
determ  delete_all

clauses
  getLongTime(Hour,Min,Sec,SecAdd,LT):-
	LT=((((Hour*60)+Min)*60+Sec)+SecAdd)/*mod(secInOneDay)*/.

  free_timeslice():-
	REG = reg($1680,0,0,0,0,0,0,0),
	bios($2f, REG ,_).%release 1 time slice under ANY! DPMI Host

predicates
 procedure  relese_slice_ByTime(ULONG time)
 procedure  sleep_with_release_slice(ULONG)
clauses
  relese_slice_ByTime(Def):-
  	free_timeslice(),
	time(H,M,S,_),
	Cur = getLongTime(H,M,S,0),
   	Cur<Def,!,
	relese_slice_ByTime(Def).
  relese_slice_ByTime(_).
  
  sleep_with_release_slice(SecDelay):-
	time(H,M,S,_),
	Next = getLongTime(H,M,S,SecDelay), % delay ,with releasing slice
 	relese_slice_ByTime(Next).
  
enddef
