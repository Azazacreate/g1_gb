/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E15.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/
goal
ifdef os_unix
  Name="/usr/local/PDCProlog/prolog.err",
elsedef
  ifdef os_os2
    Name="C:\\VIP52\\bin\\prolog.err",
  elsedef
    Name="C:\\Program Files\\VIP52\\Bin\\Prolog.err",
  enddef
enddef
  filenameext(Name,BaseName,Ext),
  write("\nName=",Name),
  write("\nBaseName=",BaseName),
  write("\nExt=",Ext),
  filenameext(NewName,BaseName,Ext),
  write("\nConverted back: ",NewName),
  % Override the old extension
  filenameext(NewName1,"PDCProlog.cfg",".hlp"),
  write("\nNewName1=",NewName1),nl.
