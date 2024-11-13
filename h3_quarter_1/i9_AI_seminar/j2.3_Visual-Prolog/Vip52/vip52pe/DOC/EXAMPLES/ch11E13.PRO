/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E13.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

constants
ifdef os_unix
  errorfile="/usr/local/PDCProlog/prolog.err"
elsedef
  ifdef os_os2
    errorfile="C:\\VIP52\\Bin\\Prolog.err"
  elsedef
    errorfile="C:\\Program Files\\VIP52\\Bin\\Prolog.err"
  enddef
enddef

domains
  dom = f(integer)
  list = integer*

facts - mydba
  p1(integer,string,char,real,dom,list)

predicates
  handleconsulterr(string,integer) - procedure (i,i)
  run - determ ()

clauses
  handleconsulterr(File,Err):-
	Err>1400, Err<1410, !,
	retractall(_,mydba),
	consulterror(Line,LinePos,_),
	errormsg(errorfile,Err,Msg,_),
	str_len(Blanks,LinePos),
	write("Syntax error in ",File,'\n',Line,'\n',Blanks,"^\n",Msg,'\n'),
	exit(1).
  handleconsulterr(File,Err):-
	errormsg(errorfile,Err,Msg,_),
	write("Error while trying to consult ",File,":\n",Msg,'\n'),
	exit(2).

  run:-
	File="faulty.dba",
	trap(consult(File, mydba),Err,handleconsulterr(File,Err)),
	write("\nSUCCESS\n").
GOAL
  run.