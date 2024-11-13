/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  Puzzle
 FileName: PUZZLES.PRO
 Purpose: Puzzle puzzle game
 Written by: Hans Dybkjær
 Comments:
******************************************************************************/

include "tangram.inc"
include "tangram.con"
include "hlptopic.con"
include "iodecl.con"

domains
	DBPIECE = dbpiece(PTLIST)
	DBPIEC = dbpiec(PTLIST)

predicates	
	puzzleConsult(WINDOW,SET,MODE,STRING)	- (i,i,i,i) % String is filename
	
	puzzleGetNames(SLIST)		- (o)

	piesAssert(WINDOW,SET,MODE,FILE)
	piesSave(WINDOW,SET)
	puzzleGetNamesAux()
	
database - puzzle
	puzzle_name(WINDOW,STRING)
	puzzle_file_names(SLIST)

clauses	
% Puzzles  	
	
puzzleLoad(Win,TangramName) :-
	concat(TangramName,".tan",Filename),
	puzzleConsult(Win,tangram,detail,"tangram.tgm"),
	puzzleConsult(Win,puzzle,secret,Filename),
	win_SetText(Win, Filename),
	win_Invalidate(Win),
	scoreReset(Win),
	!.
	
puzzleConsult(Win,Set,Mod,FileName) :-
	puzzleInit(Win,Set),
	openread(puzzlefile,FileName),
	readdevice(puzzlefile),
	scoreRead(Win),
	piesAssert(Win,Set,Mod,puzzlefile).
	
piesAssert(_,_,_,File) :-
	eof(File),closefile(File),!.
piesAssert(Win,Set,Mod,File) :-
	readterm(DBPIECE,dbpiece(L)),Pol=pol(L),
	pieNew(Win,Set,Mod,Pol,_), piesAssert(Win,Set,Mod,File),!.
	
% file format: dbpiece([pt(1,-1),pt(2,0),pt(2,-1)])
puzzleSave(Win,Set,TangramName,CreatorName) :-
  	scoreTheCreator(Win,CreatorName),
  	scoreResetHigh(Win),
	puzzleSave(Win,Set,TangramName).
	
puzzleSave(Win,Set,TangramName) :-
	concat(TangramName,".tan",Filename),
	openwrite(puzzlefile,FileName),
	writedevice(puzzlefile),
	scoreWrite(Win),nl,
	piesSave(Win,Set),
	closefile(puzzlefile),!.
	
piesSave(Win,Set) :-
	pieIter(Win,Set,Id), pieGetPol(Id,pol(L)),
	DBPie=dbpiece(L),write(DBPie),nl, fail.
piesSave(_,_).

puzzleGetNames(Names) :-
	puzzleGetNamesAux(),
	puzzle_file_names(Names),!.
puzzleGetNamesAux() :-
	retractall(puzzle_file_names(_)),
	assert(puzzle_file_names([])),
	SearchAttr=fa_normal,
	dirfiles("*.tan",SearchAttr,FName,_,_,_,_,_,_,_,_),
	filenameext(FName,BaseName,_Ext),
	puzzle_file_names(L),M=[BaseName|L],
	retractall(puzzle_file_names(_)),assert(puzzle_file_names(M)),fail.
puzzleGetNamesAux() :-!.

puzzleDlgLoadName(TangramName) :- 
	puzzleGetNames(Names),
	Title="Which tangram?",
	PreSel=0,
	dlg_ListSelect(Title,Names,PreSel,TangramName,_Index),
	concat(TangramName,".tan",Filename),
	existfile(Filename),
	!.
	
puzzleDlgSaveName(Name) :-
	Msg="Give a name for your new tangram. Max 8 letters or digits:",
	InitStr="name",
	Title="Name for new tangram",
	Name=dlg_GetStr(Title,Msg,InitStr),
	Name<>InitStr,!.
puzzleDlgSaveName("").
	
puzzleDlgCreatorName(Name) :-
	Msg="Your name:",
	InitStr="Name",
	Title="Creator",
	Name=dlg_GetStr(Title,Msg,InitStr),
	not(Name=InitStr).
	
	