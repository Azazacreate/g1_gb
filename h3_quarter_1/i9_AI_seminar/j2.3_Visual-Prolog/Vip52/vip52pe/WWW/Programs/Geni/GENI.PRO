/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  GENI
 FileName: GENI.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "geni.inc"
include "cgitools.pre"

DOMAINS
  CONDITIONS = CNO*
  HISTORY = RNO*
  RNO, CNO, FNO = INTEGER
  CATEGORY = STRING

DATABASE - geni
  rule(RNO,CATEGORY,CATEGORY,CONDITIONS,STRING)
  cond(CNO,STRING,STRING OPTIONS) 
  topic(STRING maingoal,STRING purpose)
  head(STRING headline, STRING helptopic) 
  default_startpage(STRING FILENAME)

DATABASE - tmp
  determ kb(STRING)
  yes(CNO)
  no(CNO)
  fact(FNO,CATEGORY,CATEGORY)
  whymeet

DATABASE - htmltekst
 tekstblok(STRING)

PREDICATES
  % Inferences engine
  infer()
  nondeterm go(HISTORY,CATEGORY,STRING ruleExplanation)
  determ check(RNO,HISTORY,CONDITIONS)
  determ notest(CNO)
  inpq(HISTORY,RNO,CNO,STRING,STRING OPTIONS)

 % Answer the WHY Question
  gen_why(HISTORY,RNO,STRING,CNO)
  
  % Explanations
  sub_cat(CATEGORY,CATEGORY,CATEGORY)
  show_conditions(CONDITIONS,string)
  show_rule(RNO,string)
  report(HISTORY,string)
%  evalans(string) 
  reverse(CONDITIONS,CONDITIONS)
  reverse1(CONDITIONS,CONDITIONS,CONDITIONS)
  determ is_htmlfile(STRING)
  consult_htm(STRING FileName,STRING HtmlContent)-(i,o)
  gethtmlbody(STRING InputHtml,STRING TheBody)

  endpage(string)
  endpage_Why()

clauses
  infer():-
	topic(Maingoal,_),
	go([],MainGoal,""),!.
  infer():-
	errorexit.

  go( _, Mygoal, Rulexpl ):-
  	is_htmlfile(Rulexpl),!,
	consult_htm(Rulexpl,HTMLtext),
	gethtmlbody(HTMLtext,Bodytext),
	not(rule(_,Mygoal,_,_,_)),!,nl,
	write("I think the answer is : ",Mygoal),nl,
	write(Bodytext),nl,
	endpage("").
  go( _, Mygoal, Rulexpl ):-
	not(rule(_,Mygoal,_,_,_)),!,nl,
	write("I think the answer is : ",Mygoal),nl,
	write(Rulexpl),nl,
	endpage("").
  go( HISTORY, Mygoal,_ ):-
	rule(RNO,Mygoal,NY,COND,Rulexpl),
	check(RNO,HISTORY, COND),
	go([RNO|HISTORY],NY,Rulexpl).
  go( _, Mygoal,_ ):-
	rule(_RNO,Mygoal,_NY,_COND,_Rulexpl),!,true,
	write("<H> Sorry, but I have no answer for this problem! </H>\n"),
	endpage("").

  check( RNO, HISTORY, [CNO|REST] ):-
	yes(CNO),!,
	check(RNO, HISTORY, REST).
  check( _, _, [CNO|_]):-
	no(CNO),
	!,fail.
  check( RNO, HISTORY, [CNO|REST]):-
	cond(CNO,NCOND,OPTIONS),
	fronttoken(NCOND,"not",_COND),
	frontchar(_COND,_,COND),
	cond(CNO1,COND,OPTIONS),
	notest(CNO1), !, 
	check(RNO, HISTORY, REST).
  check(_,_, [CNO|_] ):-
	cond(CNO,NCOND,OPTIONS),
	fronttoken(NCOND,"not",_COND),
	frontchar(_COND,_,COND),
	cond(CNO1,COND,OPTIONS),
	yes(CNO1),
	!,
	fail.
  check( RNO, HISTORY, [CNO|REST] ):-
	cond(CNO,TEXT,OPTIONS),!,
	inpq(HISTORY,RNO,CNO,TEXT,OPTIONS),
	check(RNO, HISTORY, REST).
  check( _, _, []).

  notest(CNO):-no(CNO),!.
  notest(CNO):-not(yes(CNO)),!.

  is_htmlfile(FILE):-
  	filenameext(File,_Name,Mask),
  	Mask = ".htm",!.
  is_htmlfile(FILE):-
  	filenameext(File,_Name,Mask),
  	Mask = ".html",!.

  consult_htm(FileName,HTMLTEKST):-
	syspath(ExeStartupPath,_ProgName),
	filenamepath(FullName,ExeStartupPath,FileName),
	trap(file_str(FullName,HTMLTEKST),_,writef("File % is not found! Correct problem!\n",FullName)),!.
  consult_htm(_,""):-
	errorexit.


  gethtmlbody(TEXT,BODY):-
  	upper_lower(TEXT,LOWERTEXT),
	searchstring(LOWERTEXT,"<body",LEN1),
	frontstr(LEN1,LOWERTEXT,_,TXT1),
	searchchar(TXT1,'>',BODY_TAG_LEN),
	STARTPOS = LEN1+BODY_TAG_LEN+1,
	searchstring(LOWERTEXT,"</body>",ENDPOS),
	LEN = ENDPOS-STARTPOS,
	substring(TEXT,STARTPOS,LEN,BODY),!.
  gethtmlbody(_,""):-
	errorexit.
 
  inpq(HISTORY,RNO,CNO,TEXT,_):- 
	whymeet,!,
	gen_why(HISTORY,RNO,TEXT,CNO),
	endpage_Why(),
	exit.
  inpq(_HISTORY,_RNO,CNO,TEXT,""):-!, 
	write("\nIs it true that: ",TEXT,"\n<BR>"),
	format(CONDSTR,"cond_%",CNO),
	endpage(CONDSTR),
	exit.
  inpq(_HISTORY,_RNO,CNO,TEXT,FILENAME):-
	is_htmlfile(FILENAME),!,
  	consult_htm(FILENAME,HtmlText),
        gethtmlbody(HtmlText,BodyText),
        write(BodyText),
	write("\nIs it true that: ",TEXT,"\n<BR>"),
	format(CONDSTR,"cond_%",CNO),
	endpage(CONDSTR),!,
	exit.
  inpq(_HISTORY,_RNO,CNO,TEXT,PICTURE):- 
	write("\nIs it true that: ",TEXT,"  ",PICTURE,"\n"),
	format(CONDSTR,"cond_%",CNO),
	endpage(CONDSTR),!,
	exit.

  gen_why(HISTORY,RNO,_TEXT,_CNO):-
	write("Why<BR>\n"),
	rule( RNO, Mygoal1, Mygoal2, _ ,_),!,
	sub_cat(Mygoal1,Mygoal2,Lstr),
	concat("I try to show that: ",Lstr,Lstr1),
	concat(Lstr1,"<BR>\nBy using rule number ",Ls1),
	str_int(Str_num,RNO),
	concat(Ls1,Str_num,Ans),
	show_rule(RNO,Lls1),
	concat(Ans,Lls1,Ans1),
	report(HISTORY,Sng),
	concat(Ans1,Sng,Answ),
	write(Answ),nl.
  gen_why(_HISTORY,_RNO,_TEXT,_CNO):-
	errorexit.

  show_rule(RNO,Strg):-
	rule( RNO, Mygoal1, Mygoal2, CONDINGELSER,_),!,
	str_int(RNO_str,RNO),
	concat("<BR>\n Rule ",RNO_str,Ans),
	concat(Ans,": ",Ans1),
	sub_cat(Mygoal1,Mygoal2,Lstr),
	concat(Ans1,Lstr,Ans2),
	concat(Ans2,"<BR>\n     if ",Ans3),
	reverse(CONDINGELSER,CONILS),
	show_conditions(CONILS,Con),
	concat(Ans3,Con,Strg).
  show_rule(_,""):-
	errorexit.

  show_conditions([],""):-!.
  show_conditions([COND],Ans):-
	cond(COND,Ans,_),!.
  show_conditions([COND|REST],Ans):-
	cond(COND,Text,_),!,
	concat("<BR>\n    and ",Text,Nstr),
	show_conditions(REST,Next_ans),
	concat(Next_ans,Nstr,Ans).
  show_conditions(_,""):-
	errorexit.

  sub_cat(Mygoal1,Mygoal2,Lstr):-
	format(LStr,"% is a %",MyGoal1,MyGoal2).

  report([],""):-!.
  report([RNO|REST],Strg) :-
	rule( RNO, Mygoal1, Mygoal2, _,_),!,
	sub_cat(Mygoal1,Mygoal2,Lstr),
	concat("\n<BR>I have shown that: ",Lstr,L1),
	concat(L1,"\n<BR>By using rule number ",L2),
	str_int(Str_RNO,RNO),
	concat(L2,Str_RNO,L3),
	concat(L3,":\n <BR>",L4),
	show_rule(RNO,Str),
	concat(L4,Str,L5),
	report(REST,Next_strg),
	concat(L5,Next_strg,Strg).
  report(_,""):-
	errorexit.

  reverse(X,Y):-
	reverse1([],X,Y).

  reverse1(Y,[],Y):-!.
  reverse1(X1,[U|X2],Y):-!,
	reverse1([U|X1],X2,Y).
  reverse1(_,_,_):-errorexit.

/*=============================================================================
        Finishes up the HTML document for the results page.
=============================================================================*/

PREDICATES
  write_conditions()
  write_kb()

CLAUSES
  endpage("") :-!,
	write_kb,
	write_conditions,
        write("<Center>"),
        write("<FONT SIZE=+6 ><I><B>"), 
	/*write("<p>\n"),
        writef("<Form> <a href=\"geni.htm\"><img src=\"/stop.gif\"></a>\n"),
        write("</p></form>\n"),*/
        write("</Center>"), 
        write("</FONT>\n"),
        write("</BODY>\n"), 
        write("</HTML>\n"). 

  endpage(CONDITION) :-
	write_kb,
	write_conditions,
	writef("<input type=\"hidden\" name=\"%s\"  value=\"yes\">\n",CONDITION),
       % write("<Center>"),
        write("<FONT SIZE=+6 ><I><B>"), 
        write("<input type=\"hidden\" name=\"answer\"  value=\"Yes\">\n"),
	write("<p><Input type=\"SUBMIT\" value=\"Yes\">\n"),
	writef("<Input type=\"BUTTON\" value=\"No\" onclick=\"form.%s.value='no';submit()\">\n",CONDITION),
	writef("<Input type=\"BUTTON\" value=\"Why\" onclick=\"form.%s.value='why';submit()\">\n",CONDITION),
        writef("</Form>\n"),%<Form action=\"/geni.htm\">\n"),
	%writef("<Input type=\"SUBMIT\" value=\"                         S T O P                       \">\n"),
        write("</p></form>\n"),
        %write("</Center>"), 
        write("</FONT>\n"),
        write("</BODY>\n"), 
        write("</HTML>\n"). 
 
  endpage_Why():-
	write_kb,
	write_conditions,
	write("<p><Input type=\"SUBMIT\" value=\"Continue\">\n"),
        write("</p></form>\n"),
        write("</FONT>\n"),
        write("</BODY>\n"),
        write("</HTML>\n"). 

  write_conditions:-
	yes(CNO),
	  format(CONDITION,"cond_%",CNO),
          writef("<input type=\"hidden\" name=\"%s\"  value=\"yes\">\n",CONDITION),
          fail.
  write_conditions:-
	no(CNO),
	  format(CONDITION,"cond_%",CNO),
          writef("<input type=\"hidden\" name=\"%s\"  value=\"no\">\n",CONDITION),
          fail.
  write_conditions.


  write_kb:-
	kb(KB),!,
	writef("<input type=\"hidden\" name=\"knowledgebase\"  value=\"%s\">\n",KB).
  write_kb:-
	errorexit().

/******************************************************
	Write StartPage
******************************************************/

PREDICATES
  startpage
  userdefined_startpage()
  write_startform()

CLAUSES
  startpage :-
        write("Content-type: text/html\n\n"),
        write("<HTML>\n"),
        write("<HEAD>\n"),
        write("<TITLE>\n"),
        write("Prolog Development Center A/S EXPERT SYSTEM\n"),
        write("</TITLE>\n"),
        write("</HEAD>\n"), 
        write("<BODY bgcolor=yellow>\n").

  write_startform():-
        write("<form action=\"geni.exe\" method=\"post\">\n").

  userdefined_startpage():-
	default_startpage(FILENAME),
  	consult_htm(FILENAME,HtmlText),!,
        gethtmlbody(HtmlText,BodyText),
        write(BodyText).
  userdefined_startpage():-
	kb(KB),!,
	write("<H1>Geni Expert system</H1>\n"),
	writef("<H2>Knowledgebase: %</H2><HR>",KB).
  userdefined_startpage():-
	errorexit.

/******************************************************
  Consult in the knowledgebase
******************************************************/

PREDICATES
  consult_kb(PARMLIST Inp,PARMLIST Rest)
CLAUSES
  consult_kb([parm("knowledgebase",KB)|Rest],Rest):-
	assert(kb(KB)), 
	filenameext(Name,KB,".gni"),
	syspath(ExeStartupPath,_ProgName),
	filenamepath(FullName,ExeStartupPath,Name),
	consult(FullName,geni),!.
  consult_kb(_,[]):- 
	errorexit.


/******************************************************
  Assert the Yes/No answers from the parameter string
******************************************************/

PREDICATES
  assert_conditions(PARMLIST)
  assert_cond(CNO,STRING Val)
CLAUSES
  assert_conditions([]):-!.
  assert_conditions([parm(Name,Val)|Rest]):-
	concat("cond_",CondNumberStr,Name),
	str_int(CondNumberStr,COND),!,
	assert_cond(COND,Val),
	assert_conditions(Rest).
  assert_conditions([_Parm|Rest]):-!,
	assert_conditions(Rest).
  assert_conditions(_):-
	errorexit.

  assert_cond(CNO,"yes"):-!,assert(yes(CNO)).
  assert_cond(CNO,"no"):-!,assert(no(CNO)).
  assert_cond(_CNO,"why"):-!,assert(whymeet).
  assert_cond(_,_):-errorexit.


/*********************************************************************************************/
/***********               M A I N G O A L                                            ********/
/*********************************************************************************************/

GOAL
	startpage,
	CGI_String = cgi_GetString(),		% Comment this out if you want to debug
%	file_str("c:\\dd.dat",CGI_String),	% To faciliate debugging
	str_namelist(CGI_String,ParmList),
	consult_kb(ParmList,ParmList1),
	userdefined_startpage(),
	write_startform(),
	assert_conditions(ParmList1),
        infer().
