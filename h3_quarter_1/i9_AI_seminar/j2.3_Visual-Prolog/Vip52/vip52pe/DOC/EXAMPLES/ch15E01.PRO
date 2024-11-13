/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH15E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  file = infile; outfile

predicates
  run - nondeterm ()
  s(string,string) - nondeterm (i,i)
  exist_original(string) - determ (i)
  exist_copy(string) - nondeterm (i)
  process_ans(char,string) - determ (i,i)
  get_filename(string,string) - determ (i,o)
  copy_file - nondeterm ()
  repeat - nondeterm ()
	
clauses
  run:-	
	write("********************** Source **************************"),nl,
	write("Which file do you want to copy ?"),
	readln(X),nl,
	write("\n\n\******************************************************"),nl,
	write("********************** Destination ************************"),nl,
	write("What is the name of the new copy ?"),
	readln(Y),nl,
	write("\n\n\******************************************************"),nl,
%	concat(X," ",X1),concat(X1,Y,Z),
ifdef os_unix
	%concat("cp ",Z,W), /* creates the string W */
elsedef
	%concat("copy ",Z,W), /* creates the string W */
enddef
	write("********************** Process *************************"),nl,
	write(" Copying ",X," to ",Y),nl,
	s(X,Y). /* invokes the OS with the string W */

  s(X,Y):-
%	repeat,
	exist_original(X),
	repeat,
	exist_copy(Y),
    	openread(infile,X),
    	openwrite(outfile,Y),
    	readdevice(infile),
    	writedevice(outfile),
    	copy_file,
    	closefile(infile),
    	closefile(outfile),
    	readdevice(keyboard),
    	writedevice(screen),
    	readchar(_),nl.

  repeat.
  repeat:-repeat.

  exist_original(File):-
	existfile(File),!.
  exist_original(_):-
  	beep,
  	write("\n  The file you wish to copy does not exist!\n",
  	      "  Press any key "),
  	readchar(Ans),
  	write(Ans),nl,
  	exit.

  exist_copy(File):-
	not(existfile(File)),!.
  exist_copy(File):-
  	beep ,
  	write("  The file you wish to copy to already exists.\n") ,
  	repeat,
  	write("  Do you wish to Erase it or Copy it to a .BAK file?\n" ,
  	      "   (E\\C) : ") ,
  	readchar(Ans),
  	upper_lower(Ans1,Ans),
  	write(Ans1),nl,
  	process_ans(Ans1,File).

  copy_file:-
	repeat,
	readchar(C),
  	write(C),
  	eof(infile).
  	
  process_ans('E',File):-
  	deletefile(File),!.
  process_ans('C',File):-
  	get_filename(File,Filename),
  	concat(Filename,".BAK",Filename1),
  	renamefile(File,Filename1),!.
  process_ans(_,_):-
  	write("  Not a valid response!\n\n"),
  	fail.

  get_filename(File,File):-
  	fronttoken(File,_,""),!.
  get_filename(File,Filename):-
  	fronttoken(File,FileName,Rest),
  	fronttoken(Rest,".",_),!.
  get_filename(File,Filename):-
  	fronttoken(File,_,F1) ,
  	get_filename(F1,Filename).

goal
  run.