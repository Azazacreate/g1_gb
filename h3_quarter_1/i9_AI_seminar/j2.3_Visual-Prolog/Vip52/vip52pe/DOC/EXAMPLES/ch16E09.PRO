/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH16E09.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: For DOS platform only 
******************************************************************************/

ifdef os_unix
  include "/usr/local/PDCProlog/programs/readkey.pro"
elsedef
  ifdef os_os2
    include "C:\\VIP52\\Doc\\Examples\\readkey.pro"
  elsedef
    include "C:\\Program Files\\VIP52\\Doc\\Examples\\readkey.pro"
  enddef
enddef

domains
  row,col,length = integer
  field = f(row,col,length)
  position = pos(row,col)

predicates
  scr(field,position,key)
  run

clauses
  scr(_,_,esc):-!,fail.
  scr(_, _, fkey(10)) :- !.
  scr(f(Row,Col,L),pos(R,C),char(Ch)):-!,
	scr_char(R,C,Ch),
	C1=C+1,
	C1<Col+L,
	cursor(R, C1),
	readkey(Key),
	scr(f(Row,Col,L),pos(R,C1),Key).
  scr(f(Row,Col,L),pos(R,C),right_arrow):-
	C1=C+1,
	C1<Col+L,!,
	cursor(R,C1),
	readkey(Key),
	scr(f(Row,Col,L),pos(R,C1),Key).
  scr(f(Row,Col,L),pos(R,C),left_arrow):-
	C1=C-1,
	C1>=Col,!,
	cursor(R,C1),
	readkey(Key),
	scr(f(Row,Col,L),pos(R,C1),Key).
  scr(Field,Pos,_):-
	beep,
	readkey(Key),
	scr(Field,Pos,Key).

  run:-
ifdef os_unix
	wdinit,	% Must initialize for terminal interface
enddef
	Row=10,Col=10,
	Length=30,
	cursor(Row,Col),
	write("****************** Example Editor ********************"),nl,
	write("Edit the text. Use the arrow keys to move"),
	readkey(Key),
	field_attr(Row,Col,Length,0x70),
	scr(f(Row,Col,Length),pos(Row,Col),Key),nl,nl,
	field_str(Row, Col, Length, Contents),
	write("Edited contents: ",Contents).

goal
  run.