/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_290.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  name,address,city,
  company,mail_stop = string
  state,zip         = symbol
  file = printer

facts
  address(name,company,mail_stop,address,city,state,zip)

predicates
  print_em(char) - determ (i)
  print_labels - procedure ()
  print_company(string) - procedure (i)
  print_stop(string) - procedure (i)
  repeat - nondeterm ()

clauses
  print_em('s'):-!,
	print_labels.
  print_em('p'):-!,
	write("\n\n  Printing..."),
	openwrite(printer,"dd.txt"),
	writedevice(printer),
	print_labels,
	nl,
	closefile(printer),
	writedevice(screen),
	nl,
	nl.
  print_em(_):-
	beep,
	write("\n\n  Not a valid resopnse...press a key to continue: ") ,
	readchar(_),
	nl,
	fail.

  print_labels:-
	address(Name,Co,Stop,Add,City,State,Zip),
	print_company(Co),
	write(Name),
	nl,
	print_stop(Stop),
	write(Add),
	nl,
	writef("%, %  %",City,State,Zip),
	nl,nl,nl,		% adjust new lines to fit your lables
	fail;
	true.
  	
  print_company(""):-!.	% if company is blank, do nothing
  print_company(Co):-
	write(Co),
	nl.
  	
  print_stop(""):-!.  	% if stop is blank, do nothing
  print_stop(Stop):-
	write(Stop),
	nl.
  	
  repeat:-
	true;
	repeat.
  	
  address("Alice Brown","","","23 N. Western Ave.",
          "Calamazo","TN","32917-7098").
  address("Charles B. Knorthrop","Maxin Corp.","","2000 Main St.",
          "San Francisco","CA","94928").
  address("Maxine Wilson","Bendix Ltd.","Mail Stop 269",
          "3100 E Madison Ave.","New York","NY","10001").
  
GOAL
  write("******************** Print Labels ***********************"),
  nl,
%	repeat,
  write("Do you want to print to the screen or the printer (S/P): "),
  readchar(Where),
  upper_lower(Where,There),
  print_em(There),
  write("  Done."),
  readchar(_),
  nl.
