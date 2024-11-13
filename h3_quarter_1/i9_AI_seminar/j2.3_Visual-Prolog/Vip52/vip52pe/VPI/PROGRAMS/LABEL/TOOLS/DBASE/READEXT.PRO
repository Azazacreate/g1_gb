/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	READEXT.PRO
 Purpose:	Utility predicates for import routines
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/

domains
  ptrInt=struct ptrint(integer)
  ptrlong=struct ptrlong(long)
  ptrreal=struct ptrreal(real)
predicates
  read_char(Char)
  read_int(Integer)
  read_real(Real)

ifdef version_32x
  read_long(Real)
elsedef
  read_long(long)
enddef

  read_str(String)
  read_str2(String,String)
  read_strArr(Integer,String)
  read_strCtrlZ(String)
  read_str2CtrlZ(String,String)
ifndef version_32x
  blockNStr(binary, integer, string)
  make_safe(integer, string,string)
enddef

  ignore(Integer)

clauses
  read_char(X):-
	readchar(X).

  read_int(V) :-
ifdef version_32x
	readchar(Low), 
	readchar(High), 
	bitleft(High,8,Vh), 
	V = Low + Vh.
elsedef
	readblock(2, PIntBin),
	Pint=cast(ptrInt, PIntBin),
	Pint=ptrInt(V).
enddef

  read_real(Real) :-
ifdef version_32x
	read_int(V1), 
	read_int(V2), 
	read_int(V3), 
	read_int(V4),
	real_ints(Real,V1,V2,V3,V4).
elsedef
	readblock(8, PRealBin),
	PReal=cast(ptrReal, PRealBin),
	PReal=ptrReal(Real).
enddef

  read_long(Long) :-
ifdef version_32x  
	read_int(VLow), 
	read_int(_), 	%throw away high order byte???
	Long=Vlow.
elsedef
	readblock(4, PLongBin),
	PLong=cast(ptrLong, PLongBin),
	PLong=ptrLong(Long).
enddef

  read_str(Str) :- 
	read_str2("",Str).

  read_str2(Scur,Str) :-
	readchar(CH), 
	CH<>'\000', !,
	str_char(S1,CH), 
	concat(Scur,S1,Scur2),
	read_str2(Scur2,Str).
  read_str2(S,S).

  read_strArr(N,S) :-    
	readdevice(Device),
	filepos(Device,0,1),
ifdef version_32X
	readblock(N,S).
elsedef	
  	readblock(N,SBinary),  %readblock
	blockNStr(SBinary,N, S).  	
enddef

  read_strCtrlZ(Str) :- 
	read_str2CtrlZ("",Str).
  read_str2CtrlZ(Scur,Str) :-
	readchar(CH), 
	CH<>'\026', !, 	% CtrlZ => CP/M way signaling eof 
	str_char(S1,CH), 
	concat(Scur,S1,Scur2),
	read_str2CtrlZ(Scur2,Str).
  read_str2CtrlZ(S,S).

ifndef version_32x
 blockNStr(Bin,N,Str):-
 	StrUnsafe=cast(string,Bin),
 	make_safe(N, StrUnsafe, Str).
 
 make_safe(N,S,S2):- trap(substring(S,1,N,S2),_,true),!. 
 make_safe(_,S,S2):- concat(S,"",S2).  % str len < N
enddef
/*************************************************************
	Ignore Characters
*************************************************************/

  ignore(0) :- !.
  ignore(N) :- 
	readdevice(Device),
	filepos(Device, N, 1).


 
