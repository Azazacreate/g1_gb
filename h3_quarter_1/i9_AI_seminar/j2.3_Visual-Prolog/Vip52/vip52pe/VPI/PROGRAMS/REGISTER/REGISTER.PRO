/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  REGISTER
 FileName: REGISTER.PRO
 Purpose: Demo a register database system using an external database
 Written by: Eugene Akimov
 Comments:

******************************************************************************/

include "register.inc"
include "register.con"

GLOBAL PREDICATES
  editor_eh : EHANDLER

FACTS - recordbrowser
  currentrel(RELATION)
  currentindex(BT_SELECTOR)
  searchfields(FNAMELIST,VALUELIST)

FACTS - w
  determ left_Print(real)
  determ top_Print(real)
  determ pagelength_Print(real)
  determ savefile_Print(string)

PREDICATES
  open_dba(WINDOW,string)
  writescr
  open_indexes
  search_proces
  changerec
  firstmatch  
  change_currentrel(RELATION)
  determ clear_value
  change_index(BT_SELECTOR)
  nondeterm repeat
  assert_in_value(FNAMELIST,VALUELIST)
  nondeterm screen(RELATION,GLOBSCRHND)	
  current_to_value
  determ conv(TYPE,STRING,VALUE)
  current_recno(REF)
  describe(RELATION,FNAMELIST)
  dbconv(RELATION,dbdom,VALUELIST)
  determ shiftscreen(RELATION)
  determ field_value(FNAME,STRING)
  s_info(ROW,COL,STRING)
  mykey_next(DB_SELECTOR,BT_SELECTOR,REF)
  mykey_prev(DB_SELECTOR,BT_SELECTOR,REF)
  search_proces_21
  searchnext(RELATION)
  searchprev(RELATION)
  change_searchfields(FNAMELIST,VALUELIST)
  searchforward(RELATION,BT_SELECTOR,REF,FNAMELIST,FNAMELIST,VALUELIST,REF)
  searchbackward(RELATION,BT_SELECTOR,REF,FNAMELIST,FNAMELIST,VALUELIST,REF)
  determ dba_insert(RELATION) 
  dba_erase(RELATION,REF)
  dba_replace(RELATION,DBDOM,REF)
%  logdbchange(LOGDOM)
  nondeterm newrec
  xname(STRING,STRING,STRING)
  mykey_search(DB_SELECTOR,BT_SELECTOR,STRING,REF)
  collect_known(FNAMELIST,FNAMELIST,VALUELIST)
  collect(FNAMELIST,VALUELIST)
  match(FNAMELIST,VALUELIST,FNAMELIST,VALUELIST)
  match_value(VALUE,VALUE)
  match_substring(INTEGER,INTEGER,STRING,STRING)
  determ make_header
  saveterm(DBDOM)
  getcityname(CITYNO,CITYNAME)
  labels
  labels_1
  labels_loop(BT_SELECTOR,REF)
  close_printer
  setwritedevice
  write_Top(real)
  write_Left(real)
  check_Page
  check_Page1(integer)
  open_file(WINDOW,STRING,BOOLEAN)
  editor_Create(WINDOW,STRING,BOOLEAN)
  WINDOW editor_Create1(WINDOW,STRING,STRING)
  get_file_data(STRING,STRING,BOOLEAN)
  error_handler(STRING,INTEGER)
  get_title(STRING,STRING)

CLAUSES
  open_indexes:-
	bt_open(dba,person_name,I1),
	bt_open(dba,person_adr,I2),
	bt_open(dba,city_no,I3),
	assert(indexes(person_name,I1)),
	assert(indexes(person_adr,I2)),
	assert(indexes(city_no,I3)).

  open_dba(_,FileName):-
	flag_open_dba(FileName),!,
	Title="Error",
	dlg_Note(Title," The Database already open. "),
	!.
  open_dba(TaskWin,FileName):-
%	db_open(logdba,"register.log",in_file),
	existfile(FileName),
	trap(db_open(dba,FileName,in_file),_,fail),!,
	db_close(dba), 
%	copyfile(FileName,"register.old"),
	db_open(dba,FileName,in_file),
	open_indexes,
	format(Msg,"Database % has been loaded\n",FileName),
	msg_AppendStr(Msg),
	menu_Enable(TaskWin,id_file_close,b_true),
	menu_Enable(TaskWin,id_file_page_setup,b_true),
	menu_Enable(TaskWin,id_file_print_preview,b_true),
	menu_Enable(TaskWin,id_file_print,b_true),
	menu_Enable(TaskWin,"Update",b_true),
	menu_Enable(TaskWin,id_file_new,b_false),
	menu_Enable(TaskWin,id_file_open,b_false),
	menu_Enable(TaskWin,id_file_delete,b_false),
	menu_Update(TaskWin),
	format(Title,"Register - %",FileName),
	win_SetText(TaskWin,Title),
	asserta(flag_open_dba(FileName)).
  open_dba(TaskWin,FileName):-
	format(Msg,"File %\nnot fond or invalid",FileName),
	dlg_Note(Msg),
	menu_Enable(TaskWin,id_file_close,b_false),
	menu_Enable(TaskWin,id_file_page_setup,b_false),
	menu_Enable(TaskWin,id_file_print_preview,b_false),
	menu_Enable(TaskWin,id_file_print,b_false),
	menu_Enable(TaskWin,"Update",b_false),
	menu_Update(TaskWin).

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Browse <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
  browse(RELATION):-
	shiftscreen(RELATION),
	change_currentrel(RELATION),
	currentindex(I),
	asserta(arch1(I),db),
	repeat,!,
	current_to_value,
	writescr.

  shiftscreen(_):-retract(field(_,_,_,_,_)),fail.
  shiftscreen(NAME):-screen(NAME,TERM),assert(TERM),fail.
  shiftscreen(_).

  change_currentrel(_):-retract(currentrel(_)),fail.
  change_currentrel(person):-
	clear_value,
	assert(currentrel(person)),
	indexes(person_name,I),
	change_index(I),
	key_first(dba,I,_),
	current_to_value,!.
  change_currentrel(city):-
	clear_value,
	assert(currentrel(city)),
	indexes(city_no,I),
	change_index(I),
	key_first(dba,I,_),
	current_to_value,!.
  change_currentrel(_).

  clear_value:-retract(value(_,_)),fail.
  clear_value.

  change_index(_):-retract(currentindex(_)),fail.
  change_index(BT_SELECTOR):-assert(currentindex(BT_SELECTOR)).

  repeat.
  repeat:-repeat.

  assert_in_value([],[]).
  assert_in_value([FNAME|R1],[VALUE|R2]):-
	field(FNAME,TYPE,_,_,_),!,
	conv(TYPE,STR,VALUE),
	assert(value(FNAME,STR)),
	assert_in_value(R1,R2).

  current_to_value:-
	clear_value,
	currentrel(RELNAME),
	current_recno(REF),
	describe(RELNAME,FNAMES),!,
	ref_term(dba,dbdom,REF,TERM),!,
	dbconv(RELNAME,TERM,VALUES),
	assert_in_value(FNAMES,VALUES).
  current_to_value.

  conv(str,STR,str(STR)).
  conv(int,STR,int(INT)):-str_int(STR,INT).
  conv(real,STR,real(REAL)):-str_real(STR,REAL).

  current_recno(REF):-
	currentindex(I),
	key_current(dba,I,_,REF),!.

  describe(person,["fname","lname","street","cityno","code"]).
  describe(city,["cityno","cityname"]).

  dbconv(person,person(P1,P2,P3,P4,P5),[str(PP1),str(PP2),str(PP3),str(PP4),str(PP5)]):-
	P1=PP1,P2=PP2,P3=PP3,P4=PP4,P5=PP5.
  dbconv(city,city(P1,P2),[str(PP1),str(PP2)]):-
	P1=PP1,P2=PP2.

  writescr:-
	field(FNAME,_,ROW,COL,_),
	field_value(FNAME,STR),
	s_info(ROW,COL,STR),
	fail.
  writescr.

  field_value(cityname,VAL):-
	currentrel(person),
	value(cityno,CITYNO),
	indexes(city_no,I),
	key_search(dba,I,CITYNO,REF),
	ref_term(dba,dbdom,REF,city(_,CITYNAME)),
	VAL=CITYNAME,!.
  field_value(FNAME,VAL):-value(FNAME,VAL),!.
  field_value(_,"").

  s_info(6,16,STR):-asserta(first_Name(STR),db1).
  s_info(8,15,STR):-asserta(last_Name(STR),db1).
  s_info(10,12,STR):-asserta(street(STR),db1).
  s_info(12,14,STR):-asserta(zip_Code(STR),db1). 
  s_info(12,33,STR):-asserta(city_Name(STR),db1).
  s_info(15,17,STR):-asserta(person_Code(STR),db1).
  s_info(8,16,STR):-asserta(cityno(STR),db1).
  s_info(11,18,STR):-asserta(cityname(STR),db1).

  proces_d(I):-
	mykey_next(dba,I,_).

  mykey_next(DBA,BT_SELECTOR,REF):-
	key_next(DBA,BT_SELECTOR,REF),
	current_to_value,
	writescr,
	!.
  mykey_next(DBA,BT_SELECTOR,REF):-
	key_prev(DBA,BT_SELECTOR,REF),
	current_to_value,
	writescr,
	fail.

  proces_u(I):-
	mykey_prev(dba,I,_).

  mykey_prev(DBA,BT_SELECTOR,REF):-
	key_prev(DBA,BT_SELECTOR,REF),
	current_to_value,
	writescr,
	!.
  mykey_prev(DBA,BT_SELECTOR,REF):-
	key_next(DBA,BT_SELECTOR,REF),
	current_to_value,
	writescr,
	fail.

  proces_nr(I):-			
	clear_value,
	repeat,
	clear_value,!,
	newrec,
	key_last(dba,I,_).

  newrec:-
	currentrel(REL),
	dba_insert(REL).

  dba_insert(person):-!,
	break(OLDBREAK),
	break(off),
	indexes(person_name,I1),
	indexes(person_adr,I2),!,
	first_Name(A),
	last_Name(B),
	street(C), 
	zip_Code(D),
	person_Code(E),!, 
	TERM=person(A,B,C,D,E), 
	xname(A,B,XNAME),
	chain_insertz(dba,person,dbdom,TERM,REF),
	key_insert(dba,I1,XNAME,REF),
	key_insert(dba,I2,C,REF),
	db_flush(dba),
%	logdbchange(insert(person,TERM,REF)), 
	break(OLDBREAK).
  dba_insert(city):-
	break(OLDBREAK),
	break(off),
	indexes(city_no,I),
	cityno(A),
	cityname(B),!,
	TERM=city(A,B),
	chain_insertz(dba,city,dbdom,TERM,REF),
	key_insert(dba,I,A,REF),
	db_flush(dba),
%	logdbchange(insert(city,TERM,REF)),
	break(OLDBREAK).

%  logdbchange(LOGTERM):-
%	chain_insertz(logdba,logs,logdom,LOGTERM,_),
%	db_flush(logdba).

  xname(F,L,S):-
	str_len(L,LEN),LEN>20,!,
	frontstr(20,L,L1,_),
	format(S,"%-20%",L1,F).
  xname(F,L,S):-
	format(S,"%-20%",L,F).

  proces_rr(I):-			
	b_false = dlg_Ask("ASK"," Are you sure ? ",["Yes","No",""]),
	key_current(dba,I,OLDKEY,REF),
	currentrel(REL),!,
	dba_erase(REL,REF),
	mykey_search(dba,I,OLDKEY,_).
  proces_rr(_).

  dba_erase(person,REF):-!,
	break(OLDBREAK),
	break(off),
	indexes(person_name,I1),
	indexes(person_adr,I2),!,
	ref_term(dba,dbdom,REF,OLDTERM),
	OLDTERM=person(OLDFNAME,OLDLNAME,OLDADR,_,_),
	xname(OLDFNAME,OLDLNAME,OLDXNAME),
	key_delete(dba,I1,OLDXNAME,REF),
	key_delete(dba,I2,OLDADR,REF),
	term_delete(dba,person,REF),
	db_flush(dba),
%	logdbchange(erase(person,REF,OLDTERM)),
	break(OLDBREAK).

  dba_erase(city,REF):-
	break(OLDBREAK),
	break(off),
	indexes(city_no,I),!,
	ref_term(dba,dbdom,REF,OLDTERM),
	OLDTERM=city(OLDCITYNO,_),
	key_delete(dba,I,OLDCITYNO,REF),
	term_delete(dba,city,REF),
	db_flush(dba),
%	logdbchange(erase(city,REF,OLDTERM)),
	break(OLDBREAK).

  mykey_search(DBA,BT_SELECTOR,KEY,REF):-
	key_search(DBA,BT_SELECTOR,KEY,REF),!.
  mykey_search(DBA,BT_SELECTOR,_,REF):-
	key_current(DBA,BT_SELECTOR,_,REF),!.
  mykey_search(DBA,BT_SELECTOR,_,REF):-
	key_last(DBA,BT_SELECTOR,REF).

  proces_s:-			
	clear_value,
	first_Name(X1),asserta(value(fname,X1),globscrhnd),
	last_Name(X2),asserta(value(lname,X2),globscrhnd),
	street(X3),asserta(value(street,X3),globscrhnd),
	zip_Code(X4),asserta(value(cityno,X4),globscrhnd),
	person_Code(X5),asserta(value(code,X5),globscrhnd),
	search_proces,
	asserta(search_flag).
  proces_s:-
	beep,
	Title="Error",
	dlg_Note(Title,"Search string not found"),
	browse(person).

  proces_cs:-
	clear_value,
	cityno(Y1),asserta(value(cityno,Y1),globscrhnd),
	cityname(Y2),asserta(value(cityname,Y2),globscrhnd),
	search_proces.
	
  proces_cs:-
	beep,
	Title="Error",
	dlg_Note(Title,"Search string not found"),
	browse(city).

  search_proces:-
	firstmatch,
	repeat,!,
	current_to_value,
	writescr.

  firstmatch:-
  	currentindex(I),
  	currentrel(REL),
	describe(REL,Totfields),!,
	collect_known(Totfields,Sfields,Svalues),
	change_searchfields(Sfields,Svalues),
	key_first(dba,I,Ref),
	searchforward(REL,I,Ref,Totfields,Sfields,Svalues,_).
  firstmatch:-
	currentindex(I),
	key_last(dba,I,_),
	key_next(dba,I,_),
	fail.
  firstmatch.

  collect_known([],[],[]).
  collect_known([FNAME|R1],[FNAME|R2],[VALUE|R3]):-
	field(FNAME,TYPE,_,_,_),
	value(FNAME,STR),
	conv(TYPE,STR,VALUE),!,
	collect_known(R1,R2,R3).
  collect_known([_|R1],R2,R3):-
	collect_known(R1,R2,R3).

  searchforward(PID,_,REF,TOTFIELDS,SEARCHFIELDS,SEARCHVALUES,REF):-
	ref_term(dba,dbdom,REF,TERM),
	dbconv(PID,TERM,VALUES),
	match(SEARCHFIELDS,SEARCHVALUES,TOTFIELDS,VALUES),!.
  searchforward(PID,I,_,TOTFIELDS,SEARCHFIELDS,SEARCHVALUES,NEXTMATCH):-
	key_next(dba,I,NEXT),
	searchforward(PID,I,NEXT,TOTFIELDS,SEARCHFIELDS,SEARCHVALUES,NEXTMATCH).

  match([],[],_,_):-!.
  match([F|R1],[V1|R2],[F|R3],[V2|R4]):-
	match_value(V1,V2),!,
	match(R1,R2,R3,R4).
  match(FELTL,VALL,[_|R1],[_|R2]):-match(FELTL,VALL,R1,R2).

  match_value(V,V):-!.
  match_value(str(V1),str(V2)):-!,
	str_len(V1,LEN1),
	str_len(V2,LEN2),
	upper_lower(V1,V11),
	upper_lower(V2,V22),
	match_substring(LEN1,LEN2,V11,V22).
  match_value(int(V),int(V)):-!.
  match_value(real(V),real(V)):-!.

  match_substring(LEN1,_,V1,V2):-
	frontstr(LEN1,V2,V22,_),
	V1=V22,!.
  match_substring(LEN1,LEN2,V1,V2):-
	LEN2>LEN1,LEN22=LEN2-1,
	frontchar(V2,_,V22),
	match_substring(LEN1,LEN22,V1,V22).

  search_proces2_up:-
	currentrel(REL),!,
	searchprev(REL),
	search_proces_21.
  search_proces_21:-stop,!,retractall(stop).	
  search_proces_21:-
	current_to_value,
	writescr.

  search_proces2_down:-
	currentrel(REL),!,
	searchnext(REL),
	search_proces_21.

  searchprev(PID):-
	currentindex(I),
	searchfields(SEARCHFIELDS,SEARCHVALUES),
	describe(PID,TOTFIELDS),
	key_prev(dba,I,PREV),
	searchbackward(PID,I,PREV,TOTFIELDS,SEARCHFIELDS,SEARCHVALUES,_),!.
  searchprev(_):-
	Title="Warning",
	dlg_Note(Title,"E N D  SEARCH  LIST !"),
	asserta(stop,db),!.
	
  searchbackward(PID,_,REF,TOTFIELDS,SEARCHFIELDS,SEARCHVALUES,REF):-
	ref_term(dba,dbdom,REF,TERM),
	dbconv(PID,TERM,VALUES),
	match(SEARCHFIELDS,SEARCHVALUES,TOTFIELDS,VALUES),!.
  searchbackward(PID,I,_,TOTFIELDS,SEARCHFIELDS,SEARCHVALUES,NEXTMATCH):-
	key_prev(dba,I,PREV),
	searchbackward(PID,I,PREV,TOTFIELDS,SEARCHFIELDS,SEARCHVALUES,NEXTMATCH).
	

  searchnext(PID):-
	currentindex(I),
	searchfields(SEARCHFIELDS,SEARCHVALUES),
	describe(PID,TOTFIELDS),
	key_next(dba,I,NEXT),
	searchforward(PID,I,NEXT,TOTFIELDS,SEARCHFIELDS,SEARCHVALUES,_),
	!.
  searchnext(_):-
	Title="Warning",
	dlg_Note(Title,"E N D  SEARCH  LIST  !"),
	asserta(stop,db),!.

  change_searchfields(_,_):-
	retract(searchfields(_,_)),
	fail.
  change_searchfields(SEARCHFIELDS,SEARCHVALUES):-
	assert(searchfields(SEARCHFIELDS,SEARCHVALUES)).

  proces_rp(I):-			
	key_current(dba,I,OLDKEY,_),
	repeat,
	changerec,
	mykey_search(dba,I,OLDKEY,_),!.

  changerec:-
	currentrel(REL),
	describe(REL,FIELDNAMES),
	collect(FIELDNAMES,VALL),
	current_recno(REF),
	dbconv(REL,TERM,VALL),
	dba_replace(REL,TERM,REF),!.

  collect([],[]).
  collect([FNAME|R1],[VALUE|R2]):-
	field(FNAME,TYPE,_,_,_),
	value(FNAME,STR),
	conv(TYPE,STR,VALUE),!,
	collect(R1,R2).
	
  dba_replace(person,NEWTERM,REF):-!,
	break(OLDBREAK),
	break(off),
	indexes(person_name,I1),
	indexes(person_adr,I2),!,
	ref_term(dba,dbdom,REF,OLDTERM),
	OLDTERM=person(OLDFNAME,OLDLNAME,OLDADR,_,_),
	xname(OLDFNAME,OLDLNAME,OLDXNAME),
	key_delete(dba,I1,OLDXNAME,REF),
	key_delete(dba,I2,OLDADR,REF),
	NEWTERM=person(NEWFNAME,NEWLNAME,NEWADR,_,_),
	xname(NEWFNAME,NEWLNAME,NEWXNAME),
	term_replace(dba,dbdom,REF,NEWTERM),
	key_insert(dba,I1,NEWXNAME,REF),
	key_insert(dba,I2,NEWADR,REF),
	db_flush(dba),
%	logdbchange(replace(person,NEWTERM,REF,OLDTERM)),
	break(OLDBREAK).

  dba_replace(city,NEWTERM,REF):-!,
	break(OLDBREAK),
	break(off),
	indexes(city_no,I),!,
	ref_term(dba,dbdom,REF,OLDTERM),
	OLDTERM=city(OLDCITYNO,_),
	key_delete(dba,I,OLDCITYNO,REF),
	NEWTERM=city(CITYNO,_),
	term_replace(dba,dbdom,REF,NEWTERM),
	key_insert(dba,I,CITYNO,REF),
	db_flush(dba),
%	logdbchange(replace(city,NEWTERM,REF,OLDTERM)),
	break(OLDBREAK).

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Print text <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
DOMAINS
  PRINTRESOLUTION = res(LONG HDPI,LONG VPIE,LONG Hres,LONG VRes)

PREDICATES
  get_line(STRING Input,CHAR NewLineChar,STRING Line,STRING Rest)

CLAUSES
  get_line(Str,Char,StartStr,Rest1):-
  	searchchar(Str,Char,Pos),!,
  	Len = Pos - 1,
  	frontstr(Len,Str,StartStr,Rest),
	frontchar(Rest,_,Rest1).
  get_line(Str,_,Str,"").

PREDICATES
  expand_tabs(INTEGER TabSize,STRING StrWithTabs,STRING Expanded)
  expand_tabs(INTEGER TabSize,INTEGER CurOffset,STRING StrWithTabs,STRING Expanded)

CLAUSES
  expand_tabs(TabSize,Str,Expanded):-
	expand_tabs(TabSize,0,Str,Expanded).
  expand_tabs(TabSize,Offset,Str,NewExpanded):-
  	searchchar(Str,'\t',POS),!,
  	Len = Pos - 1,
	frontstr(Len,Str,Start,Rest),
	frontchar(Rest,_,Rest1),
	NoOfSpaces = TabSize - (Offset + Len) mod TabSize,
	Offset1 = Offset + Len + NoOfSpaces,
	expand_tabs(TabSize,Offset1,Rest1,RestExpanded),
  	str_len(Spaces,NoOfSpaces),
	format(NewExpanded,"%s%s%s",Start,Spaces,RestExpanded).
  expand_tabs(_,_,S,S).

PREDICATES
  print_line(WINDOW,INTEGER,INTEGER,INTEGER,STRING,INTEGER,INTEGER,INTEGER,INTEGER,STRING)

CLAUSES
  print_line(_,_,_,_,"",_,_,DELTA1,DELTA2,""):-!,					
  	DELTA2 = DELTA1 + 1.
  print_line(_,_,_,_,RestStrNEW,LineNo,LineNo,DELTA,DELTA,RestStrNEW):-!.	
  print_line(PW,SX,SY,LH,NEWStr,LineNo,MaxLineNo,DELTA1,DELTA,Rest):-		
  	str_len(NEWStr,LEN),
  	LEN>=80,!,
  	frontstr(80,NEWStr,StartStr,RestFROMNEW),
  	draw_Text(PW,SX,SY,StartStr),
  	DELTA2=DELTA1+1,
  	LineNo1=LineNo+1,
  	SYNEW=SY+LH,
	concat("==>",RestFROMNEW,RestFROMNEW1),
  	print_line(PW,SX,SYNEW,LH,RestFROMNEW1,LineNo1,MaxLineNo,DELTA2,DELTA,Rest).
  print_line(PW,SX,SY,LH,NEWStr,Line1,Lines,DELTA1,DELTA,Rest):-
  	draw_Text(PW,SX,SY,NEWStr),
  	print_line(PW,SX,SY,LH,"",Line1,Lines,DELTA1,DELTA,Rest).

PREDICATES
  print_PageLines(WINDOW,LONG StartX,LONG StartY,LONG LineW,LONG LineH,LONG NoOfLines,STRING Str,STRING Rest,INTEGER TabSize)
  print_PageLines(WINDOW,LONG StartX,LONG StartY,LONG LineW,LONG LineH,LONG CurrLine,LONG NoOfLines,STRING Str,STRING Rest,INTEGER TabSize)
  myconcat(STRING,STRING,STRING)

CLAUSES
  print_PageLines(PW,SX,SY,LW,LH,Lines,Str,Rest,TabSize):-
  	print_PageLines(PW,SX,SY,LW,LH,0,Lines,Str,Rest,TabSize).

  print_PageLines(_,_,_,_,_,_,_,"","",_):-!.				
  print_PageLines(_,_,_,_,_,MaxLineNo,MaxLineNo,Str,Str,_):-!.	
  print_PageLines(PW,SX,SY,LW,LH,LineNo,MaxLineNo,Str,Rest,TabSize):-
	get_line(Str,'\n',StartStr,RestStr2),
  	expand_tabs(TabSize,StartStr,NEWStr),
  	print_line(PW,SX,SY,LH,NEWStr,LineNo,MaxLineNo,0,DELTA,RestStr1),
	LineNo1 = LineNo + DELTA,
  	SYNEW = SY + LH * DELTA,
  	myconcat(RestStr1,RestStr2,RestStr),
  	print_PageLines(PW,SX,SYNEW,LW,LH,LineNo1,MaxLineNo,RestStr,Rest,TabSize).

  myconcat("",S,S):-!.
  myconcat(S,"",S):-!.
  myconcat(Str1,Str2,Result):-
	concat(Str1,Str2,Result).

PREDICATES
  print_Page(WINDOW,STRING,INTEGER PageNo,PRINTRESOLUTION,STRING Inp,STRING Rest,INTEGER TabSize)

CLAUSES

  print_Page(PW,FName,PageNo,res(HRes,VRes,_,Width),Str,RestStr,TabSize):-
	V_SCR_RES=vpi_GetAttrVal(attr_screen_vres),
	FSIZE=(10*VRes)/V_SCR_RES,
 	FONT=font_Create(ff_Fixed,[],FSIZE),
	win_SetFont(PW,FONT),
  	print_StartPage(PW),
	LineWidth = Width - HRes,
	StartX = HRes div 2,
	StartY = VRes div 2,
  	format(Header,"%s  Page -%d-",FName,PageNo),
	draw_Text(PW,StartX,StartY,Header),	
	LineHeight=(15*VRes)/V_SCR_RES,
	StartY1 = StartY + 2 * LineHeight,
	pagelength_Print(QQ),!,
  	print_PageLines(PW,StartX,StartY1,LineWidth,LineHeight,0,QQ,Str,RestStr,TabSize),
	print_EndPage(PW).

PREDICATES
  print_Pages(WINDOW,STRING FName,INTEGER PageNo,PRINTRESOLUTION,INTEGER TabSize,STRING)

CLAUSES
  print_Pages(_,_,_,_,_,""):-!.
  print_Pages(PW,FName,PageNo,PrintRes,TabSize,Str):-
  	print_Page(PW,FName,PageNo,PrintRes,Str,RestStr,TabSize),
  	PageNo1=PageNo+1,
  	print_Pages(PW,FName,PageNo1,PrintRes,TabSize,RestStr).

PREDICATES
  print_file(STRING FileName,INTEGER TabSize)

CLAUSES
  print_file(FName,TabSize):-
  	file_str(FName,Str),
	trap(PW = print_StartJob("File printing..."),_,fail),
	!,
  	Height = vpi_GetAttrVal(attr_printer_height),
  	Width = vpi_GetAttrVal(attr_printer_width),
  	HRes = vpi_GetAttrVal(attr_printer_hres),
  	VRes = vpi_GetAttrVal(attr_printer_vres),
	PageNo=1,
	print_Pages(PW,FName,PageNo,res(HRes,VRes,Height,Width),TabSize,Str),
	print_EndJob(PW).
  print_file(_,_):-
	Msg="Cannot initialize a print job",
	dlg_Note(Msg).

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Print Preview <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
  labels:-
	retractall(count(_)),
	asserta(count(0)),
	retractall(count_Page(_)),
	asserta(count_Page(1)),
	setwritedevice,
	trap(labels_1,_,true),
	fail.
  labels:-
	close_printer,
	fail.
  labels.

  labels_1:-
	indexes(person_name,I),!,
	key_first(dba,I,REF),
	top_Print(X),!,
	write_Top(X),
	make_header,
	labels_loop(I,REF).

  labels_loop(_,REF):-
	ref_term(dba,dbdom,REF,TERM),
	saveterm(TERM),
	fail.
  labels_loop(I,_):-
	key_next(dba,I,REF),!,
	labels_loop(I,REF).
  labels_loop(_,_).

  close_printer:-
	write('\012'),
	closefile(prn_file).

  setwritedevice:-
	savefile_Print(PRINTDEST),!,
	openwrite(prn_file,PRINTDEST),
	writedevice(prn_file).

  saveterm(person(FIRSTNAME,LASTNAME,STREET,CITYNO,CODE)):-
	getcityname(CITYNO,CITYNAME),
	format(Line1,"% %",FIRSTNAME,LASTNAME),
	format(Line2,"%-30 % %",STREET,CITYNO,CITYNAME),
	Line3=CODE,
	left_Print(X),
	check_Page,
	write_Left(X),
	write(Line1),nl,
	check_Page,
	write_Left(X),
	write(Line2),nl,
	check_Page,
	write_Left(X),
	write(Line3),nl,
	check_Page,
	nl.

  make_header:-
	date(Y,M,D),
  	format(HEADER,"Total listning  %25 Date: %.%.%\n","",D,M,Y),
	left_Print(X),
	check_Page,
	write_Left(X),
	write(HEADER),
	left_Print(X),
	check_Page,
	write_Left(X),
	write("----------------------------------------------------------"),
	nl.

  getcityname(CNO,CNAME):-
	indexes(city_no,I),
	key_search(dba,I,CNO,REF),
	ref_term(dba,dbdom,REF,city(_,CNAME)),!.
  getcityname(_,"").

  write_Left(0):-!.
  write_Left(X):-
	write(" "),
	X1=X-1,
	write_Left(X1).

  check_Page:-
	count(X),!,
	X1=X+1,
	retractall(count(X)),
	asserta(count(X1)),
	check_Page1(X1).
	
  check_Page1(X):-
	pagelength_Print(Y),
	X>=Y,!,
	count_Page(A),!,
	write("---------------------------------------------->>>Page "),
	write(A),
	nl,
	retractall(count(X)),
	asserta(count(1)),
	A1=A+1,
	retractall(count_Page(A)),
	asserta(count_Page(A1)),
	top_Print(Z),!,
	write_Top(Z),
	make_header.
	
  check_Page1(_).
		
  write_Top(0):-!.
  write_Top(X):-
	check_Page,
	nl, X1=X-1,
	write_Top(X1).
	
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Editor <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
%open_file(_Win,_,_):-
%	edit_flag,!,
%	Title="ERROR",
%	dlg_Note(Title," Editor already open").

  open_file(_Win,FileName,Prompt):-
	editor_Create(_Win,FileName,Prompt),
	asserta(edit_flag).

  editor_Create(W,FileName,Prompt):-
	get_file_data(FileName,Text,Prompt),
	editor_Create1(W,FileName,Text).

  editor_Create1(W,FileName,Text,EW):-
	CRCT = win_GetClientRect(W),
	CRCT = rct(L,T,R,B),
	L1 = L + 20,
	T1 = T + 35,
	R1 = R - 20,
	B1 = B - 20,
	FLAGS = [wsf_Close,wsf_SizeBorder,wsf_TitleBar,
		 wsf_ClipSiblings,wsf_ClipChildren,wsf_Minimize,wsf_Maximize],
	FONT = font_Create(ff_Fixed,[],10),
	ReadOnly = b_false,
	Indent = b_true,
	Pos = 1,
	get_title(FileName,Title),
	Menu=res_menu(id_editor),
	EW = edit_Create(w_TopLevel,rct(L1,T1,R1,B1),Title,
		Menu,W,FLAGS,FONT,
		ReadOnly,Indent,Text,Pos,editor_eh).

  error_handler(S,E):-
	format(STR,"% - Error code = %",S,E),
	dlg_Error(STR).

  get_file_data(FileName,Text,_):-
	existfile(FileName),!,
	format(ERROR_MSG, "Unable to load file %", FileName),
	trap(file_str(FileName,Text),E,error_handler(ERROR_MSG,E)).
  get_file_data(_,"",b_true):-!,
	Resp = dlg_Ask("","File does not exist. Create",["Yes", "No", ""]),
	Resp = resp_default.
  get_file_data(_,"",_).

  get_title(FileName,Title):-
	disk(Path),
	searchstring(FileName,Path,Pos),!,
	str_len(Path,Len),
	Pos1 = Pos + Len,
	frontstr(Pos1,FileName,_,Title).
  get_title(FileName,FileName).

  screen("person",field("fname",str,6,16,36)).
  screen("person",field("lname",str,8,15,37)).
  screen("person",field("street",str,10,12,40)).
  screen("person",field("cityno",str,12,14,7)).
  screen("person",field("cityname",str,12,33,19)).
  screen("person",field("code",str,15,17,35)).
  screen("city",field("cityno",str,8,16,7)).
  screen("city",field("cityname",str,11,18,43)).


  editor_eh(_Win,e_Create(_),0):-!,
	!.
  editor_eh(_Win,e_Menu(idr_page_setup,_ShiftCtlAlt),0):-!,
	dlg_page_setup_Create(_Win),
	!.
  editor_eh(_Win,e_Menu(idr_print,_ShiftCtlAlt),0):-!,
	FILENAME=dlg_GetOpenFileName("*.dat",["*.dat","*.dat","*.*","*.*"],"Select file to print"),
	FILENAME<>"",
	print_file(FILENAME,6),
	!.
  editor_eh(_Win,e_Menu(idr_close,_ShiftCtlAlt),0):-!,
	retractall(edit_flag,db1),
	win_Destroy(_Win),
	!.
  editor_eh(_Win,e_CloseRequest,0):-!,
	retractall(edit_flag,db1),
	win_Destroy(_Win),
	!.

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 19:32:30-2.12.1996, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Register"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-
	run,!,
IFDEF use_message
	msg_Create(100),
ENDDEF
	menu_Enable(_Win,id_file_new,b_false),
	menu_Enable(_Win,id_file_open,b_false),
	menu_Enable(_Win,id_file_close,b_false),
	menu_Enable(_Win,id_file_page_setup,b_false),
	menu_Enable(_Win,id_file_print_preview,b_false),
	menu_Enable(_Win,id_file_delete,b_false),
	!.
  task_win_eh(_Win,e_Create(_),0):-
%BEGIN Task Window, InitControls, 19:32:30-2.12.1996, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 19:32:30-2.12.1996, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	
	menu_Enable(_Win,id_file_close,b_false),
	menu_Enable(_Win,id_file_page_setup,b_false),
	menu_Enable(_Win,id_file_print_preview,b_false),
	menu_Enable(_Win,id_file_print,b_false),
	menu_Enable(_Win,"Update",b_false),
	menu_Update(_Win),
	asserta(run),
	!.
%END Task Window, e_Create

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("register.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	retractall(_,db1),
  	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-!,
	FILENAME=dlg_GetOpenFileName("*.bin",["*.bin","*.bin","*.*","*.*"],""),
	FILENAME<>"",
	open_dba(_Win,FILENAME),
	!.
%END Task Window, id_file_open
%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_Rct),0):-!,
	!.
%END Task Window, e_Update
%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest,0):-!,
	retract(edit_flag,db1),
	win_Destroy(_Win),
	!.
%END Task Window, e_CloseRequest
%BEGIN Task Window, id_file_print
  task_win_eh(_Win,e_Menu(id_file_print,_ShiftCtlAlt),0):-!,
	FILENAME=dlg_GetOpenFileName("*.dat",["*.dat","*.dat","*.*","*.*"],"Select file to print"),
	FILENAME<>"",
	print_file(FILENAME,6),
	!.
%END Task Window, id_file_print
%BEGIN Task Window, id_Update_person
  task_win_eh(_Win,e_Menu(id_Update_person,_ShiftCtlAlt),0):-!,
	browse(person),
	dlg_person_information_Create(_Win),
	!.
%END Task Window, id_Update_person
%BEGIN Task Window, id_Update_cities
  task_win_eh(_Win,e_Menu(id_Update_cities,_ShiftCtlAlt),0):-!,
	browse(city),
	dlg_city_information_Create(_Win),
	!.
%END Task Window, id_Update_cities
%BEGIN Task Window, id_file_page_setup
  task_win_eh(_Win,e_Menu(id_file_page_setup,_ShiftCtlAlt),0):-!,
	dlg_page_setup_Create(_Win),
	!.
  task_win_eh(_Win,e_Menu(id_file_page_setup,_ShiftCtlAlt),0):-!.
%END Task Window, id_file_page_setup
%BEGIN Task Window, id_file_print_preview
  task_win_eh(_Win,e_Menu(id_file_print_preview,_ShiftCtlAlt),0):-!,
	labels,
	savefile_Print(FileName),
	open_file(_Win,FileName,b_true),
	!.
%END Task Window, id_file_print_preview

%BEGIN Task Window, id_file_close
  task_win_eh(_Win,e_Menu(id_file_close,_ShiftCtlAlt),0):-
	flag_open_dba(FileName),!,
	db_close(dba),
%	db_close(logdba),
	retractall(_,db),
	menu_Enable(_Win,id_file_close,b_false),
	menu_Enable(_Win,id_file_page_setup,b_false),
	menu_Enable(_Win,id_file_print_preview,b_false),
	menu_Enable(_Win,id_file_print,b_false),
	menu_Enable(_Win,"Update",b_false),
	menu_Enable(_Win,id_file_new,b_true),
	menu_Enable(_Win,id_file_open,b_true),
	menu_Enable(_Win,id_file_delete,b_true),
	menu_Update(_Win),
	format(Msg,"Database % has been closed\n",FileName),
	msg_AppendStr(Msg),
	win_SetText(_Win,"Register"),
	!.
%END Task Window, id_file_close	
%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
  	Title="Select new file name",
	FILENAME=dlg_GetOpenFileName("*.bin",["*.bin","*.bin","*.*","*.*"],Title),
	FILENAME<>"",
	db_create(dba,FILENAME,in_file),
	bt_create(dba,person_name,_,35,4),
	bt_create(dba,person_adr,_,25,4),
	bt_create(dba,city_no,_,6,4),
	db_close(dba),
	open_dba(_Win,FILENAME),
	!.
%END Task Window, id_file_new
%BEGIN Task Window, id_file_delete
  task_win_eh(_Win,e_Menu(id_file_delete,_ShiftCtlAlt),0):-!,
	Title="Select delete file name",
	FILENAME=dlg_GetOpenFileName("*.bin",["*.bin","*.bin","*.*","*.*"],Title),
	FILENAME<>"",
	db_delete(FILENAME,in_file),
	format(Msg,"Database % has been deleted\n",FileName),
	msg_AppendStr(Msg),
	!.
%END Task Window, id_file_delete	
%MARK Task Window, new events
%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
IFDEF use_message
	msg_Resize(_Win),
ENDDEF
	RCT=win_GetClientRect(_Win),
	win_Invalidate(_Win,RCT),
	!.
%END Task Window, e_Size


/***************************************************************************
			Main  Project
***************************************************************************/

GOAL


IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
ENDDEF
IFDEF use_tbar
  vpi_SetAttrVal(attr_win_tbar,use_tbar),
ENDDEF
IFDEF use_sbar
  vpi_SetAttrVal(attr_win_sbar,use_sbar),
ENDDEF
	retractall(_,w),
	asserta(left_Print(0),w),
	asserta(top_Print(0),w),
	asserta(pagelength_Print(60),w),
	A="dd.dat",
	asserta(savefile_Print(A),w),

  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"register",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
        Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 10:16:22-11.1.2000, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

%BEGIN About dialog, System handled events
%BEGIN About dialog, idc_help _CtlInfo
  dlg_about_dialog_eh(_,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
%	vpi_ShowHelpContext("register.hlp",dlg_about_dialog_Help),
	!.
%END About dialog, idc_help _CtlInfo

  dlg_about_dialog_eh(_,_,0):-!,fail.
%END About dialog, System handled events
%END_DLG About dialog





%BEGIN_DLG Page Setup
/**************************************************************************
        Creation and event handling for dialog: "Page Setup"
**************************************************************************/

CONSTANTS

%BEGIN Page Setup, CreateParms, 19:13:44-25.11.1999, Code automatically updated!
  dlg_page_setup_ResID = idd_page_setup
  dlg_page_setup_DlgType = wd_Modal
  dlg_page_setup_Help = idh_contents
%END Page Setup, CreateParms

PREDICATES

  dlg_page_setup_eh : EHANDLER
  dlg_page_setup_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_page_setup_Create(Parent):-
	left_Print(X1),
	top_Print(X2),
	pagelength_Print(X3),
	savefile_Print(X4),
%MARK Page Setup, new variables

	dialog_CreateModal(Parent,dlg_page_setup_ResID,"",
  		[
%BEGIN Page Setup, ControlList, 19:13:44-25.11.1999, Code automatically updated!
		df(idc_page_setup_1,editreal(r(X1),[range(0,20)]),nopr),
		df(idc_page_setup_2,editreal(r(X2),[minimum(0)]),nopr),
		df(idc_page_setup_3,editreal(r(X3),[range(0,64)]),nopr),
		df(idc_page_setup_4,editstr(X4,[]),nopr)
%END Page Setup, ControlList
		],
		dlg_page_setup_eh,0,_VALLIST,_ANSWER),
		_ANSWER = idc_ok,
		TaskTmp = vpi_GetAttrVal(attr_task_window),
		TaskWin=cast(window,TaskTmp),
		win_SendEvent(TaskWin,e_menu(id_file_print_preview,c_Nothing)).

  dlg_page_setup_update(_VALLIST):-!,
%BEGIN Page Setup, Update controls, 19:13:44-25.11.1999, Code automatically updated!
	_IDC_PAGE_SETUP_1_VALUE = dialog_VLGetreal(idc_page_setup_1,_VALLIST),
	_IDC_PAGE_SETUP_2_VALUE = dialog_VLGetreal(idc_page_setup_2,_VALLIST),
	_IDC_PAGE_SETUP_3_VALUE = dialog_VLGetreal(idc_page_setup_3,_VALLIST),
	_IDC_PAGE_SETUP_4_VALUE = dialog_VLGetstr(idc_page_setup_4,_VALLIST),
%END Page Setup, Update controls
	retractall(_,w),
	_IDC_PAGE_SETUP_1_VALUE=r(SET1),
	_IDC_PAGE_SETUP_2_VALUE=r(SET2),
	_IDC_PAGE_SETUP_3_VALUE=r(SET3),
	asserta(left_Print(SET1)),
	asserta(top_Print(SET2)),
	asserta(pagelength_Print(SET3)),
	asserta(savefile_Print(_IDC_PAGE_SETUP_4_VALUE)),
	!.

dlg_page_setup_update(_VALLIST).

%MARK Page Setup, new events

%BEGIN Page Setup, idc_ok _CtlInfo
  dlg_page_setup_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	_VALLIST = dialog_GetValues(_Win),
	dlg_page_setup_update(_VALLIST),
	!,fail.
%END Page Setup, idc_ok _CtlInfo

%BEGIN Page Setup, idc_help _CtlInfo
  dlg_page_setup_eh(_,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
%	project_ShowHelpContext(dlg_page_setup_Help),
	!.
%END Page Setup, idc_help _CtlInfo

  dlg_page_setup_eh(_,_,0):-!,fail.

%END_DLG Page Setup







