/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  XCALCULA
 FileName: XCALCULA.CS
 Purpose: Operations involving Calcula source
 Written by: Eugene Akimov
 Comments:
 	calcula_source_Load - 		Load source
 	calcula_source_Retrieve - 	Retrieve
******************************************************************************/

facts - calcula_source
  determ  calcula_source(SOURCE)

predicates
  calcula_source_Load(string FileName,string OutFileName) - procedure (i,o)
  calcula_source_Retrieve(SOURCE Text) - determ (o)

clauses
  calcula_source_Load("",OutFileName):-
  	existfile("xcalcula.db"),
	!,
  	consult("xcalcula.db",calcula_source),
  	syspath(Path,_),
  	concat(Path,"xcalcula.db",OutFileName).
  calcula_source_Load(FileName,FileName):-
	FileName<>"",
	trap(existfile(FileName),_,fail),
	!,
	consult(FileName,calcula_source).
  calcula_source_Load("",""):-
	!,
	assert(calcula_source("")).
  calcula_source_Load(FileName,""):-
	assert(calcula_source("")),
	format(Msg,"File % not found",FileName),
	dlg_Note(Msg).

  calcula_source_Retrieve(Source):-
  	calcula_source(Source).
  	
