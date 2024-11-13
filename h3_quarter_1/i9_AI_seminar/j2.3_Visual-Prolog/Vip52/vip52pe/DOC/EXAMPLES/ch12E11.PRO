/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E11.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  file = input; output

predicates
  convert_file - procedure ()
  repfile(FILE) - nondeterm (i)
  run - determ ()

clauses
  convert_file :-
	repfile(input),
	readln(Ln),
	upper_lower(LnInUpper,Ln),          /* converts the string to uppercase */
	write(LnInUpper),nl,
	fail.
  convert_file.

  repfile(_).
  repfile(F):-
	not(eof(F)),
	repfile(F).

  run:-
	write("Which file do you want convert ?"),
	readln(InputFileName),nl,
	write("What is the name of the output file ?"),
	readln(OutputFileName),nl,
	openread(input, InputFileName),
	readdevice(input),
	openwrite(output, OutputFileName),
	writedevice(output),
	convert_file,
	closefile(input),
	closefile(output).

goal
  run.