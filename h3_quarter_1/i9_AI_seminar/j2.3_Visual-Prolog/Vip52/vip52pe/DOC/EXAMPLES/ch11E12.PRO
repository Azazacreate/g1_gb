/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E12.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/
ifdef os_unix
  include "/usr/local/PDCProlog/include/error.con"
elsedef
  ifdef os_os2
    include "C:\\VIP52\\Include\\Error.con"
  elsedef
    include "C:\\Program Files\\VIP52\\Include\\Error.con"
  enddef
enddef

domains
  file = inpfile

predicates
  ioehand(integer,file) - determ (i,i)
  getline(file,string) - nondeterm (i,o)
  run - nondeterm ()

clauses
  ioehand(err_notopen,File):-!,
	write(File," isn't open\n"),
	exit(1).
  ioehand(Err,File):-
	 write("Error ",Err," on ",File,'\n'),
	 exit(1).

  getline(File,Line):-
	readdevice(Old),
	readdevice(File),
	readln(Line),
	readdevice(Old).

  run:-
	trap(getline(inpfile,First),Err,ioehand(Err,inpfile)),
	write(First).
goal
  run.