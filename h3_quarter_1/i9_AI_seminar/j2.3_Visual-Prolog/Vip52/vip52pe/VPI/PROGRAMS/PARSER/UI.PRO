/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PARSER
 FileName: UI.PRO
 Purpose: User Interface
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "parser.inc"
include "parser.con"
include "hlptopic.con"
include "scan.pro"
include "parse.pro"

PREDICATES
	get_file_data(string,string,boolean)
	error_handler(string,integer)
	get_title(string,string)
	check_open_file(WINDOW,string,string,string)
	newext(string,string,string)
	prepare_to_generate_parser
	delete_parser_output_files
	write_domain_definitions
	write_parsing_predicates
	clear_db
	get_file_contents(string,string)
	write_error_message(WINDOW)

CLAUSES	
  write_error_message(_Win):-
  	error(Msg,Pos),
  	str_int(Str,Pos),
	concat(Msg,", Pos:",F1),
	concat(F1,Str,Error_Msg),
	resp_default = dlg_Ask("Error",Error_Msg,["Go to","Cancel"]),
  	!,
  	Position=Pos+1,
  	win_SetFocus(_Win),
	edit_GotoPos( _Win, Position ).
  write_error_message(_).
  
  error_handler(S,E) :-
	format(STR,"% - Error code = %",S,E),
	dlg_Error(STR).

  get_file_data(FileName,Text,_) :-
	FileName<>"",
	existfile(FileName),!,
	format(Error_Msg, "Unable to load file %", FileName),
	trap(file_str(FileName,Text),E,error_handler(Error_Msg,E)).
  get_file_data(_,"",b_true) :- !,
	Resp = dlg_Ask("","File does not exist. Create",["Yes", "No", ""]),
	Resp = resp_default.
  get_file_data(_,"",_).

  get_title(FileName,Title) :-
	disk(Path),
	searchstring(FileName,Path,Pos),!,
	str_len(Path,Len),
	Pos1 = Pos + Len,
	frontstr(Pos1,FileName,_,Title).
  get_title(FileName,FileName).

  newext(Filename, Ext, NewFilename) :-
	frontchar(Extent, '.', Ext),
	filenameext(Newfilename, Filename, Extent).

/*************************** Load Grammar *************************/
  load_grammar(_Win,FileName):-
	get_file_data(FileName,Text,b_true),
	get_title(FileName,Title),
	retractall(options(_,_,_)),
	assert(options(FileName,Text,Title)),
	win_editor_Create(_Win).
	
/*************************** New Grammar **************************/
  new_grammar(_Win):-
	Text="",
	Title="NONAME",
	FileName="NONAME.GRM",
	retractall(options(_,_,_)),
	assert(options(FileName,Text,Title)),
	win_editor_Create(_Win).

/***************** Display parsing predicates *******************/	
  display_parsing_predicates(_Win):-
	editwin(_,FileName,_),
	newext(FileName, "PAR", New_FileName),
	existfile(New_FileName),
	!,
	get_file_data(New_FileName,Text,b_true),
	format(Title, " Parsing Predicates (%) ", New_FileName),
	check_open_file(_Win,New_FileName,Text,Title).
  display_parsing_predicates(_Win):-
	Title="Error",
	String1="No parsing predicates \n",
	String2="(parser not generated).",
	concat(String1,String2,Text),
	dlg_Note(Title,Text).

/***************** Display domain definitions *******************/	
  display_domain_definftions(_Win):-
	editwin(_,FileName,_),
	newext(FileName, "DOM", New_FileName),
	existfile(New_FileName),
	!,
	get_file_data(New_FileName,Text,b_true),
	format(Title, " Domain Definitions (%) ", New_FileName),
	check_open_file(_Win,New_FileName,Text,Title).
  display_domain_definftions(_Win):-
	Title="Error",
	String1="No domain definitions \n",
	String2="(parser not generated).",
	concat(String1,String2,Text),
	dlg_Note(Title,Text).

/************************ Generate Parser *************************/
  generate_parser(_Win,_) :-
	TB_VALUE=text_value("Initializing"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE),
	prepare_to_generate_parser,

	retractall(error(_, _)),	% Or deeper error may not be found.
	retractall(_, parse),
	TB_VALUE1=text_value("Scanning"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE1),
	scan(TOKENS),

	TB_VALUE2=text_value("Parsing"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE2),
	parse(TOKENS),
	!,

	TB_VALUE3=text_value("Writing Domain Definitions"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE3),
	write_domain_definitions,

	TB_VALUE4=text_value("Writing Parsing Predicates"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE4),
	write_parsing_predicates,
	TB_VALUE5=text_value(""),
	deletefile("PAR.OLD"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE5).

/* This fires if parsing errors occurred and user didn't fix them
   (escaped out of the editor). 					*/
  generate_parser(_Win,Window) :-
	TB_VALUE=text_value("Parsing aborted"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE),
	trap(copyfile("PAR.OLD","PARSER.PAR"),_,fail),
	trap(deletefile("PAR.OLD"),_,fail),!,
	write_error_message(Window).
  generate_parser(_Win,Window) :-
	write_error_message(Window).

/****************** prepare_to_generate_parser ********************/
  prepare_to_generate_parser :-
	delete_parser_output_files,
	clear_db.

/********************* delete_parser_output_files *****************/

/* Delete parsing predicates... 					*/

  delete_parser_output_files :-
	editwin(_,FileName,_),
	newext(FileName, "PAR", New_FileName),
	trap(existfile(New_FileName),_,fail),
	trap(copyfile(New_FileName,"PAR.OLD"),_,fail),
	trap(deletefile(New_FileName),_,fail),
	fail.

/* Delete domain definitions... 					*/

  delete_parser_output_files :-
	editwin(_,FileName,_),
	newext(FileName, "DOM", New_FileName),
	existfile(New_FileName),
	deletefile(New_FileName),
	fail.
  delete_parser_output_files.

/******************* write_domain_definitions ********************/

  write_domain_definitions :-
	editwin(_,Grammar_FileName,_),!,
	newext(Grammar_FileName, "DOM", Domain_FileName),
	openwrite(outfile, Domain_FileName),			
	writedevice(outfile),
	write_domain_definitions_aux,
	closefile(outfile).


/******************* write_parsing_predicates *********************/

  write_parsing_predicates :-	
	editwin(_,Grammar_FileName,_),!,
	newext(Grammar_FileName, "PAR", Predicates_FileName),
	openwrite(outfile, Predicates_FileName),
	writedevice(outfile),
	write_parsing_predicates_aux,
	closefile(outfile).

/*************************** clear_db ****************************/

  clear_db :-
	retractall(error(_, _)),
	retractall(_, parse).
/************************************************************************
 *	change/1							*
 *	Replace term in internal db.					*
 ************************************************************************/

  change_error(_, _) :-
	retract(error(_, _)),
	fail.
  change_error(X,Y):-
  	assert(error(X,Y)).

  change_grammar(_) :-
	retract(grammar(_)),
	fail.
  change_grammar(X):-
  	assert(grammar(X)).

/************************************************************************
 *	is_a_better_error/1						*
 ************************************************************************/

  is_a_better_error(Cursor) :-
	error(_, OldCursor),		% Get location of last error.
	OldCursor >= Cursor,
	!,
	fail.
  is_a_better_error(_).

/********************* get_file_contents/2 ************************/

  get_file_contents(FileName, Contents) :-
	existfile(FileName),
	!,
	file_str(FileName, Contents).

  get_file_contents(_, "").

  check_open_file(_Win,New_FileName,_,_):-
	editwin(Window,New_FileName,_),!,
	win_SetFocus(Window).
  check_open_file(_Win,New_FileName,Text,Title):-
	retractall(options(_,_,_)),
	assert(options(New_FileName,Text,Title)),
	win_editor_Create(_Win).
	