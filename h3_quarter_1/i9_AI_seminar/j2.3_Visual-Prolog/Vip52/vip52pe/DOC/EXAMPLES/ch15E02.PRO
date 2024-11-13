/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH15E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: time doesn't return hundredths on UNIX
******************************************************************************/

goal
  time(H1,M1,S1,_),nl,
  write("Start time is: ",H1,":",M1,":",S1),nl,
/* This is the activity that is being timed */
  system("dir /s/b c:\\*.*"),
  time(H2,M2,S2,_),
  Time = S2-S1 + 60*(M2-M1 + 60*(H2-H1)),
  write("Elapsed time: ",Time," seconds"),nl,
  time(H3,M3,S3,_),
  write("The time now is: ",H3,":",M3,":",S3).