/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E17.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

constants
  fa_hidden = $02    /* Hidden file          */
  fa_system = $04    /* System file          */
  fa_subdir = $10    /* Subdirectory         */

  fa_hidsys = $06    /* hidden + system */

predicates
  findhidden(string,string)
  wrattr(integer)

clauses
  wrattr(A):-
	bitand(A,fa_hidden,AA),
	AA<>0,write('H'),fail.
  wrattr(A):-bitand(A,fa_system,AA),
	AA<>0,write('S'),fail.
  wrattr(A):-
	bitand(A,fa_subdir,AA),
	AA<>0,write('D'),fail.
  wrattr(_).

  findhidden(CurrPath,Wild):-
	write(CurrPath,":\n"),
	filenamepath(FileSpec,CurrPath,Wild),
	dirfiles(FileSpec,fa_hidsys,FileName,RetAttr,_,_,_,_,_,_,_),
	wrattr(RetAttr),
	write('\t',FileName,'\n'),
	fail.
  findhidden(CurrPath,Wild):-
	filenamepath(DirSpec,CurrPath,"*.*"),
	dirfiles(DirSpec,fa_subdir,Name,_,_,_,_,_,_,_,_),
	not(frontchar(Name,'.',_)),
	filenamepath(DirName,CurrPath,Name),
	findhidden(DirName,Wild),
	fail.
  findhidden(_,_).

goal
ifdef os_unix
  findhidden("/usr/local/PDCProlog/","*.*").
elsedef
  findhidden("C:\\","*.*").
enddef
