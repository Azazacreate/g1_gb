/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  SEN_AN
 FileName: SEN_AN.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/
include "cgiexam.inc"

DATABASE - sen
  det( STRING )
  noun( STRING )
  rel( STRING )
  verb( STRING )
  determ nocopy screen(integer,integer,string)

DOMAINS
  DETERM   = none ; determ( STRING )
  NOUNP    = nounp( DETERM, STRING, RELCL)
  RELCL    = none ; relcl( STRING, VERBP )
  SENTENCE = sent( NOUNP, VERBP )
  VERBP    = verb( STRING ) ; verbp( STRING, NOUNP )
  TOKL     = STRING*
  
  ROW = integer
  COL = integer
  ATTR = integer

% Domains for the tree with positions
  d_SENTENCE = sent( d_NOUNP, d_VERBP )
  d_NOUNP    = nounp( d_DETERM, COL, d_RELCL)
  d_DETERM   = none ; determ( COL )
  d_RELCL    = none ; relcl( COL, d_VERBP )
  d_VERBP    = verb( COL ) ; verbp( COL, d_NOUNP )

  COLL = COL*

PREDICATES
% Recognition of words in different forms
  is_det( STRING )
  is_noun( STRING )
  is_rel( STRING )
  is_verb( STRING )

% Parser
  nondeterm s_determ(   TOKL, TOKL, COLL, COLL, DETERM, d_DETERM )
  nondeterm s_nounp(    TOKL, TOKL, COLL, COLL, NOUNP, d_NOUNP )
  nondeterm s_relcl(    TOKL, TOKL, COLL, COLL, RELCL, d_RELCL )
  nondeterm s_sentence( TOKL, TOKL, COLL, COLL, SENTENCE, d_SENTENCE )
  nondeterm s_verbp(    TOKL, TOKL, COLL, COLL, VERBP, d_VERBP )

% Scanner
  check(STRING)
  tokl( COL, COLL, STRING, TOKL )
  tom(TOKL).


PREDICATES
  nondeterm member(parm,parmlist)
  runme(parmlist)
  plus_to_blank(string,string,string)

% draw a sentence tree
  draw_nounp( ROW, ROW, d_NOUNP, NOUNP, COL )
  draw_relcl( ROW, ROW, d_RELCL, RELCL, COL )
  draw_sentence( ROW, ROW, d_SENTENCE, SENTENCE )
  draw_verbp( ROW, ROW, d_VERBP, VERBP, COL )

% Miscellaneous drawing predicates
  lin(ROW,COL,ROW,COL)
  line_hor(COL,COL,ROW)
  line_ver(ROW,ROW,COL)
  mark(ROW,COL,STRING,ATTR)
  mark2(ROW,COL,STRING,ATTR)
  markfinal(ROW,COL,STRING,STRING)
  mk_ulin(STRING,STRING)
  scr_tegn(ROW,COL,CHAR)
  scr_char(ROW,COL,CHAR)
  assignNLs(string,integer,integer)
  writetext(ROW,COL,STRING,ATTR)
  
CLAUSES
  member (X,[X|_]).
  member (X,[_|Y]):-member(X,Y).
	
  runme(Parmlist) :-
	syspath(ExeStartupPath,_ProgName),
	filenamepath(FullName1,ExeStartupPath,"SEN_AN.DBA"), 
	consult(FullName1,sen),
  	member (parm("sent",STR),ParmList),
  	plus_to_blank (STR,"",STR1),
  	write ("<p><b>Source sentence:</b><br>\n",STR1),
	
	tokl(5,POSL,STR1,TOKL),
    	s_sentence( TOKL, _, POSL, _, SENT, POS ),

	write("<p><b>Parsed sentence:</b><br>\n"),
	write(SENT),!,
	write("<PRE>\n"),
	draw_sentence( 4, 0, POS, SENT ),
	screen(_,_,ScreenStr),
	write(ScreenStr),
	write("</PRE>").
  runme (_) :-
  	write ("<p>Error while executing Sen_an.exe\n").
  	
  plus_to_blank ("",STR,STR) :-!.
  plus_to_blank (STR,BUFF,STR1) :-
  	searchchar(STR,'+',POS),
  	P = POS-1,
  	frontstr(P,STR,FRONT,REST),
  	frontchar(REST,_,REST1),
  	concat (BUFF,FRONT,B1),
  	concat (B1," ",B2),!,
  	plus_to_blank (REST1,B2,STR1).
  plus_to_blank (STR,BUFF,STR1) :-!,
  	concat(BUFF,STR,STR1).

GOAL
        write("Content-type: text/html\n\n"),
        write("<html>\n"),
        write("<body>\n"),
	ParmList = cgi_GetParmList(),   
	runme(ParmList),
	write("</body>\n"),
	write("</html>\n").

CLAUSES

tokl(POS,[POS1|POSL],STR,[TOK|TOKL]) :-
    fronttoken(STR,TOK,STR1),
    check(TOK),!,
    str_len(TOK,LEN),
    POS1=POS+(LEN+1) div 2,
    POS2=POS+5+LEN,
    tokl(POS2,POSL,STR1,TOKL).
tokl(_,[],_,[]).

s_sentence(TOKL,TOKL2,COLL,COLL2,sent(NOUNP,VERBP),
 sent(D_NOUNP,D_VERBP)):-
    s_nounp(TOKL,TOKL1,COLL,COLL1,NOUNP,D_NOUNP),
    s_verbp(TOKL1,TOKL2,COLL1,COLL2,VERBP,D_VERBP),
    tom(TOKL2),!.
s_sentence(_,_,_,_,_,_):-
    write(">> Sentence not recognized (Use F8 to get the old line)\n"),fail.

tom([]).

s_nounp(TOKL,TOKL2,COLL,COLL2,nounp(DETERM,NOUN,RELCL),
 nounp(D_DETERM,COL,D_RELCL)):-
    s_determ(TOKL,[NOUN|TOKL1],COLL,[COL|COLL1],DETERM,D_DETERM),
    is_noun(NOUN),
    s_relcl(TOKL1,TOKL2,COLL1,COLL2,RELCL,D_RELCL).

s_determ([DETERM|TOKL],TOKL,[COL|COLL],COLL,determ(DETERM),
 determ(COL)):-
    is_det(DETERM).
s_determ(TOKL,TOKL,COLL,COLL,none,none).

s_relcl([REL|TOKL],TOKL1,[COL|COLL],COLL1,relcl(REL,VERBP),
 relcl(COL,D_VERBP) ):-
    is_rel(REL),
    s_verbp(TOKL,TOKL1,COLL,COLL1,VERBP,D_VERBP).
s_relcl(TOKL,TOKL,COLL,COLL,none,none).

s_verbp([VERB|TOKL],TOKL1,[COL|COLL],COLL1,verbp(VERB,NOUNP),
 verbp(COL,D_NOUNP)):-
    is_verb(VERB),
    s_nounp(TOKL,TOKL1,COLL,COLL1,NOUNP,D_NOUNP).
s_verbp([VERB|TOKL],TOKL,[COL|COLL],COLL,verb(VERB),verb(COL)):-
    is_verb(VERB).

check(WORD):-is_noun(WORD),!.
check(WORD):-is_det(WORD),!.
check(WORD):-is_rel(WORD),!.
check(WORD):-is_verb(WORD),!.
check(WORD):- write(">> Unknown word: ",WORD),
              nl, readchar(_).

is_noun(X):-noun(X),!.
is_noun(X):-noun(Y),concat(Y,"s",X),!.

is_det(X):-det(X),!.

is_rel(X):-rel(X),!.

is_verb(X):-verb(X),!.
is_verb(X):-verb(Y),concat(Y,"s",X),!.
is_verb(X):-verb(Y),concat(Y,"ed",X),!.
is_verb(X):-verb(Y),concat(Y,"es",X),!.
is_verb(X):-verb(Y),concat(Y,"ing",X),!.

% * * * * * * * * * * * * * * * * * * * * * * * *
%  Draw the sentence
% * * * * * * * * * * * * * * * * * * * * * * * *

draw_sentence(STEP,DEPT,sent(D_NOUNP,D_VERBP),sent(NOUNP,VERBP)):-
    
    NoOfLines = 80,
    LineLen = 80,
    StrLen = NoOfLines * (LineLen+1),
    str_len(ScreenStr,StrLen),
    assignNLs(ScreenStr,NoOfLines,LineLen),
    assert(screen(NoOfLines,LineLen,ScreenStr)),
    
    DEPT1=DEPT+STEP,
    draw_nounp(STEP,DEPT1,D_NOUNP,NOUNP,COL1),
    draw_verbp(STEP,DEPT1,D_VERBP,VERBP,COL2),
    COL=(COL1+COL2) div 2,
    lin(DEPT,COL,DEPT1,COL1),
    lin(DEPT,COL,DEPT1,COL2),
    mark(DEPT,COL,"SENTENCE",33).

draw_nounp(STEP,DEPT,nounp(none,COL,none),nounp(_,NOUN,_),COL):-
    DEPT1=DEPT+STEP div 2,
    lin(DEPT1,COL,DEPT,COL),
    markfinal(DEPT1,COL,"NOUN",NOUN),
    mark(DEPT,COL,"NOUNP",33).
draw_nounp(STEP,DEPT,nounp(determ(COL1),COL2,none),
 nounp(determ(DET),NOUN,_),COL):-
    DEPT1=DEPT+STEP,
    COL=(COL1+COL2) div 2,
    lin(DEPT1,COL1,DEPT,COL),
    lin(DEPT1,COL2,DEPT,COL),
    markfinal(DEPT1,COL1,"DETERM",DET),
    markfinal(DEPT1,COL2,"NOUN",NOUN),
    mark(DEPT,COl,"NOUNP",33).
draw_nounp(STEP,DEPT,nounp(none,COL1,relcl(REL,VERBP)),
 nounp(none,NOUN,RELCL),COL):-
    DEPT1=DEPT+STEP,
    draw_relcl(STEP,DEPT1,relcl(REL,VERBP),RELCL,COL2),
    COL=(COL1+COL2) div 2,
    lin(DEPT1,COL1,DEPT,COL),
    lin(DEPT1,COL2,DEPT,COL),
    markfinal(DEPT1,COL1,"NOUN",NOUN),
    mark(DEPT,COL,"NOUNP",33).
draw_nounp(STEP,DEPT,nounp(determ(COL1),COL2,relcl(REL,VERBP)),
 nounp(determ(DET),NOUN,RELCL),COL):-
    DEPT1=DEPT+STEP,
    draw_relcl(STEP,DEPT1,relcl(REL,VERBP),RELCL,COL3),
    COL=(COL1+COL2+COL3) div 3,
    lin(DEPT1,COL1,DEPT,COL),
    lin(DEPT1,COL2,DEPT,COL),
    lin(DEPT1,COL3,DEPT,COL),
    markfinal(DEPT1,COL1,"DETERM",DET),
    markfinal(DEPT1,COL2,"NOUN",NOUN),
    mark(DEPT,COL,"NOUNP",33).

draw_verbp(STEP,DEPT,verb(COL),verb(VERB),COL):-
    DEPT1=DEPT+STEP div 2,
    lin(DEPT1,COL,DEPT,COL),
    markfinal(DEPT1,COL,"VERB",VERB),
    mark(DEPT,COL,"VERBP",33).
draw_verbp(STEP,DEPT,verbp(COL1,D_NOUNP),verbp(VERB,NOUNP),COL):-
    DEPT1=DEPT+STEP,
    draw_nounp(STEP,DEPT1,D_NOUNP,NOUNP,COL2),
    COL=(COL1+COL2) div 2,
    lin(DEPT1,COL1,DEPT,COL),
    lin(DEPT1,COL2,DEPT,COL),
    markfinal(DEPT1,COL1,"VERB",VERB),
    mark(DEPT,COL,"VERBP",33).

draw_relcl(STEP,DEPT,relcl(COL1,D_VERBP),relcl(REL,VERBP),COL):-
    DEPT1=DEPT+STEP,
    draw_verbp(STEP,DEPT1,D_VERBP,VERBP,COL2),
    COL=(COL1+COL2) div 2,
    lin(DEPT1,COL1,DEPT,COL),
    lin(DEPT1,COL2,DEPT,COL),
    markfinal(DEPT1,COL1,"REL",REL),
    mark(DEPT,COL,"RELCL",33).

lin(R1,C,R2,C):-!,
    line_ver(R1,R2,C).
lin(R1,C1,R2,C2):-
    RM=(R1+R2) div 2,
    line_ver(R1,RM,C1),
    line_hor(C1,C2,RM),
    line_ver(RM,R2,C2),
    scr_tegn(RM,C1,'+'),
    scr_tegn(RM,C2,'+').

line_ver(R,R,_):-!.
line_ver(R1,R2,C):-
    R2>R1,!,
    scr_tegn(R1,C,'|'),
    R=R1+1,
    line_ver(R,R2,C).
line_ver(R2,R1,C):-
    scr_tegn(R1,C,'|'),
    R=R1+1,
    line_ver(R,R2,C).

line_hor(C,C,_):-!.
line_hor(C1,C2,R):-
    C2>C1,!,
    scr_tegn(R,C1,'-'),
    C=C1+1,
    line_hor(C,C2,R).
line_hor(C2,C1,R):-
    scr_tegn(R,C1,'-'),
    C=C1+1,
    line_hor(C,C2,R).

mark(ROW,COL,TEXT,ATTR):-
    str_len(TEXT,LEN),
    C=COL-(LEN-1) div 2,
    writetext(ROW,C,TEXT,ATTR).

mark2(ROW,COL,TEXT,ATTR):-
    str_len(TEXT,LEN),
    C=COL-LEN div 2,
    writetext(ROW,C,TEXT,ATTR).

markfinal(ROW,COL,TEXT1,TEXT2):-
    str_len(TEXT1,L1),
    str_len(TEXT2,L2),
    L2>L1,!,
    R1=ROW+1, R2=ROW+2,
    mk_ulin(TEXT1,ULINE),
    mark2(ROW,COL,TEXT1,33),
    mark2(R1,COL,ULINE,7),
    mark(R2,COL,TEXT2,112).

markfinal(ROW,COL,TEXT1,TEXT2):-
    str_len(TEXT1,L),
    str_len(TEXT2,L),!,
    R1=ROW+1,
    R2=ROW+2,
    mk_ulin(TEXT1,ULINE),
    mark(ROW,COL,TEXT1,33),
    mark(R1,COL,ULINE,7),
    mark(R2,COL,TEXT2,112).

markfinal(ROW,COL,TEXT1,TEXT2):-
    R1=ROW+1,
    R2=ROW+2,
    mk_ulin(TEXT1,ULINE),
    mark(ROW,COL,TEXT1,33),
    mark(R1,COL,ULINE,7),
    mark2(R2,COL,TEXT2,112).

mk_ulin(STR1,STR2):-
    frontchar(STR1,_,REST),!,
    mk_ulin(REST,ULI1),
    concat(ULI1,"-",STR2).
mk_ulin("","").

scr_tegn(R,C,CH):-
    R<79,
    C<80,!,
    scr_char(R,C,CH).
scr_tegn(_,_,_).

writetext(ROW,COL,TEXT,_ATTR):-
    ROW<79,
    COL<80,
    frontchar(TEXT,CH,REST),!,
    scr_char(ROW,COL,CH),
  %  scr_attr(ROW,COL,ATTR),
    COL1=COL+1,
    writetext(ROW,COL1,REST,_ATTR).
writetext(_,_,_,_).

scr_char(Line,Col,Char):-
    screen(NoOfLines,LineLen,ScreenStr),
    Line<NoOfLines,
    Col<LineLen,
    Pos=Line*(LineLen+1)+Col,
    StrPos=cast(LONG,ScreenStr)+Pos,
    PSTR = cast(STRING,StrPos),
    membyte(PStr,Char).
    
assignNLs(_,0,_):-!.
assignNLs(Str,Line,LineLen) :-
	Pos=Line*(LineLen+1)+LineLen,
	StrPos=cast(LONG,Str)+Pos,
    	PSTR = cast(STRING,StrPos),
	membyte(PStr,'\n'),
	Line1=Line-1,
	assignNLs(Str,Line1,LineLen).