/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E18.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/
ifdef os_unix
  include "/usr/local/PDCProlog/include/iodecl.con"
  include "/usr/local/PDCProlog/include/error.con"
elsedef
  ifdef os_os2
    include "C:\\VIP52\\Include\\Iodecl.con"
    include "C:\\VIP52\\Include\\Error.con"
  elsedef
    include "C:\\Program Files\\VIP52\\Include\\Iodecl.con"
    include "C:\\Program Files\\VIP52\\Include\\Error.con"
  enddef
enddef

constants
  fa_setuid = 0o4000
  fa_setgid = 0o2000
  fa_anyexec = 0o111

predicates
  nogo(integer,string) - procedure (i,i)
  findsetuid(string,string) - procedure (i,i)
  hasguid(integer) - determ (i)
  wrattr(integer) - procedure (i)

clauses
  nogo(7013,_):-!.	% eacces defined in error.pre
  nogo(Ecode,Where):-
	write("Error ",Ecode," trying to access ",Where,'\n').

  hasguid(A):-
	bitand(A,fa_setgid,HasGid), HasGid <> 0, !;
	bitand(A,fa_setuid,HasUid),
	HasUid <> 0.

  wrattr(A):-
	bitand(A,fa_setuid,AA),
	AA<>0,write('U'),fail.
  wrattr(A):-
	bitand(A,fa_setgid,AA),
	AA<>0,write('G'),fail.
  wrattr(_).

  findsetuid(CurrPath,Wild):-
	write(CurrPath,":\n"),
	filenamepath(FileSpec,CurrPath,Wild),
	FMode = fa_normal + fa_anyexec,
	trap(dirfiles(FileSpec,FMode,FileName,RetAttr,_,_,_,_,_,_,_),
							E,nogo(E,FileSpec)),
	hasguid(RetAttr),
	wrattr(RetAttr),
	write('\t',FileName,'\n'),
	fail.
  findsetuid(CurrPath,Wild):-
	filenamepath(DirSpec,CurrPath,"*"),
	FMode = fa_subdir + 0o666,	% Subdirs where we can go
	trap(dirfiles(DirSpec,FMode,Name,_,_,_,_,_,_,_,_),
							E,nogo(E,DirSpec)),
	Name <> ".", Name <> "..",
	filenamepath(DirName,CurrPath,Name),
	findsetuid(DirName,Wild),
	fail.
  findsetuid(_,_).

goal
  findsetuid("/","*").
