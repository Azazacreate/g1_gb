/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E13.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

goal
ifdef os_unix
  QualName="/usr/local/PDCProlog/prolog.err",
elsedef
  ifdef os_os2
    QualName="C:\\VIP52\\bin\\prolog.err",
  elsedef
    QualName="C:\\Program Files\\VIP52\\Bin\\Prolog.err",
  enddef
enddef
  filenamepath(QualName,Path,Name),
  write("\nQualName=",QualName),
  write("\nPath=",Path),
  write("\nName=",Name),
  filenamepath(NewName,Path,Name),
  write("\nConverted back: ",NewName),nl.

