/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  NQUEEN
 FileName: NQUEEN.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/
include "cgiexam.inc"

DOMAINS
  queen    = q(integer, integer)
  queens   = queen*
  freelist = integer*
  board    = board(queens, freelist, freelist, freelist, freelist)

PREDICATES
  nondeterm placeN(integer, board, board)
  nondeterm place_a_queen(integer, board, board)
  nondeterm nqueens(integer)
  nondeterm makelist(integer, freelist)
  nondeterm findandremove(integer, freelist, freelist)
  nextrow(integer, freelist, freelist)
  make_HTML_ChessBoard (integer,board)
CLAUSES
  nqueens(N):-
  	N<=0,!,
  	write("<p>You must enter positive number\n").
  nqueens(N):-
  	N>1,N<4,!,
  	write("<p>It is impossible to place ",N," queens onto ",N,"x",N," board:\n<p>").
  nqueens(N):-
	makelist(N,L),
	Diagonal=N*2-1,
	makelist(Diagonal,LL),
	placeN(N,board([],L,L,LL,LL),Final),
	write("<p>This is solution how to place ",N," queens onto ",N,"x",N," board:\n<p>"),
	make_HTML_ChessBoard (N,Final).
	
  placeN(_,board(D,[],[],D1,D2),board(D,[],[],D1,D2)):-!.
  placeN(N,Board1,Result):-
	place_a_queen(N,Board1,Board2),
	placeN(N,Board2,Result).

  place_a_queen(N,
		board(Queens,Rows,Columns,Diag1,Diag2),
		board([q(R,C)|Queens],NewR,NewC,NewD1,NewD2)):-
	nextrow(R,Rows,NewR),
	findandremove(C,Columns,NewC),
	D1=N+C-R,findandremove(D1,Diag1,NewD1),
	D2=R+C-1,findandremove(D2,Diag2,NewD2).

  findandremove(X,[X|Rest],Rest).
  findandremove(X,[Y|Rest],[Y|Tail]):-
	findandremove(X,Rest,Tail).

  makelist(1,[1]).
  makelist(N,[N|Rest]) :-
	N1=N-1,makelist(N1,Rest).

  nextrow(Row,[Row|Rest],Rest).
/******************************************************
   Render the Solution as HTML table
******************************************************/
PREDICATES  
  render_Board(queens,integer)
  letter(integer,char)
  cell_color(integer,integer,string,string)
  render_DigRow(integer,integer)
  render_BoardRow(integer,integer,integer)
  render_Cells(integer,integer,integer,integer)
CLAUSES
  make_HTML_ChessBoard (N,Solution) :-
  	Solution = board(Queens,_,_,_,_),
  	write ("<table>\n<tr><td> "),
  	render_DigRow (1,N),
  	render_Board (Queens,N),
  	write ("</table>\n").
  %  render digital marks
  render_DigRow (N,N) :- !,write ("<td>",N).
  render_DigRow (X,N) :- write ("<td>",X),
  	X1=X+1,
  	render_DigRow(X1,N).
  %  render chess board
  render_Board ([],_).
  render_Board ([q(Row,Col)|Rest],N) :-
  	render_BoardRow (Row,Col,N),
  	render_Board (Rest,N).
  %  render single row
  render_BoardRow (Row,Col,N) :-
  	letter(Row,Letter),
  	write("<tr><td>",Letter),
  	render_Cells(Row,1,Col,N).
  	
  letter (R,L) :- char_int('a',A),AA=A+R-1,char_int(L,AA).

  cell_color (R,C,"#800000","#FFFFFF") :-
  	M=R+C,
  	Rem = M mod 2,
  	Rem <> 0,!.
  cell_color (_,_,"#FFFFFF","#800000").
  	
  
  render_Cells (Row,Col,Col,Col) :-!,
  	cell_color(Row,Col,B,F),
  	write ("<td bgcolor=",B,"><font color=",F,"><b>Q</b></font></tr>").
  render_Cells (Row,N,_Col,N) :-!,
  	cell_color(Row,N,B,_F),
  	write ("<td bgcolor=",B,"><font color=",B,">&nbsp;</font></tr>").
  render_Cells (Row,X,Col,N) :-
  	X=Col,
  	cell_color(Row,X,B,F),
  	write ("<td bgcolor=",B,"><font color=",F,"><b>Q</b></font>"),
  	X1=X+1,!,
  	render_Cells (Row,X1,Col,N).
  render_Cells (Row,X,Col,N) :-
  	cell_color(Row,X,B,_F),
  	write ("<td bgcolor=",B,"><font color=",B,">&nbsp;</font>"),
  	X1=X+1,!,
  	render_Cells (Row,X1,Col,N).
  	
  
PREDICATES
  nondeterm member(parm,parmlist)
  runme(parmlist)
CLAUSES
  member (X,[X|_]).
  member (X,[_|Y]):-member(X,Y).
  
  runme (Parmlist) :-
  	member(parm("nq",NQS),Parmlist),
	trap(str_int(NQS,NQ),_,fail),!,
	nqueens(NQ),!.
  runme (_) :-
  	write ("<p>This is not a number\n").
  	
GOAL	
	write("Content-type: text/html\n\n"),
        write("<html>\n"),
        write("<body>\n"),
	ParmList = cgi_GetParmList(),   
	runme(Parmlist),
	write("</body>\n"),
	write("</html>\n").

