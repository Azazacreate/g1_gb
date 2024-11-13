/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH14E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
my_dom = f(string)
db_selector = my_dba

predicates
  write_dba(integer)
  read_dba - procedure ()
  rd(Ref) - procedure (i)
  count_dba(integer) - determ (o)
  count(Ref,integer,integer) - procedure (i,i,o)
  replace_dba - determ ()
  replace(Ref) - procedure (i)
  double_dba - determ ()
  double(Ref) - procedure (i)
  half_dba - determ ()
  half(Ref) - procedure (i)
  mixture - determ ()

clauses
  write_dba(0):-!.
  write_dba(N):-
	chain_inserta(my_dba,"my_chain",my_dom,f("Prolog system"),_),
	chain_insertz(my_dba,"my_chain",my_dom,f("Prolog Compiler"),_),
	N1=N-1,
	write_dba(N1).

  read_dba:-
	db_chains(my_dba,Chain),
	chain_terms(my_dba,Chain,my_dom,Term,Ref),
	nl,
	write("Ref=",Ref),
	write(", Term=",Term),
	fail.
  read_dba:-
	db_chains(my_dba,Chain),
	chain_first(my_dba,Chain, Ref),
	rd(Ref),
	fail.
	read_dba.

  rd(Ref):-
	ref_term(my_dba,my_dom,Ref,Term),
	nl,
	write(Term),
	fail.
  rd(Ref):-
	chain_next(my_dba,Ref,Next),
	!,
	rd(Next).
  rd(_).

  replace_dba:-
	chain_first(my_dba,"my_chain",Ref),
	replace(Ref).

  replace(Ref):-
	term_replace(my_dba,my_dom,Ref,f("Prolog Toolbox")),
	chain_next(my_dba,Ref,NN),
	chain_next(my_dba,NN,Next),!,
	replace(Next).
	replace(_).

  half_dba:-
	chain_last(my_dba,"my_chain",Ref),
	half(Ref).

  half(Ref):-
	chain_prev(my_dba,Ref,PP),
	chain_prev(my_dba,PP,Prev),!,
	term_delete(my_dba,"my_chain",Ref),
	half(Prev).
  half(_).

  double_dba:-
	chain_first(my_dba,"my_chain",Ref),
	double(Ref).

  double(Ref):-
	chain_next(my_dba,Ref,Next),!,
	chain_insertafter(my_dba,"my_chain",my_dom,Ref,f("Programmers Guide"),_),
	double(Next).
	double(_).

  count_dba(N):-
	chain_first(my_dba,"my_chain",Ref),
	count(Ref,1,N).

  count(Ref,N,N2):-
	chain_next(my_dba,Ref,Next),!,
	N1=N+1,
	count(Next,N1,N2).
  count(_,N,N).

  mixture:-
	nl,
	write("Replace every second term:"),
	replace_dba,nl,
	write("Double the number of terms:"),
	double_dba,nl,
	write("Erase every second term:"),
	half_dba,nl,
	write("Use ref_term for all terms:"),
	read_dba,
	count_dba(N),nl,
	write("There are now ",N," terms in the database"),
	db_statistics(my_dba,NoOfTerms,MemSize,DbaSize,FreSize),nl,
	writef("NoOfTerms=%, MemSize=%, DbaSize=%, FreeSize=%", NoOfTerms, MemSize,DbaSize,FreSize).
goal
  nl,nl,nl,
  write("\tTEST OF DATABASE SYSTEM\n\t***********************\n\n"),
  time(H1,M1,S1,D1),
  db_create(my_dba,"dd.dat",in_memory),nl,nl,
  write("Write some terms in the database:"),
  write_dba(50),
  read_dba,
  mixture,nl,nl,

  write("Copy to file"),
  db_copy(my_dba,"dd.dat",in_file),
  db_close(my_dba),
  db_delete("dd.dat",in_memory),
  db_open(my_dba,"dd.dat",in_file),
  mixture,
  db_close(my_dba),nl,nl,nl,

 write("Open the database on file"),
  db_open(my_dba,"dd.dat",in_file),
  mixture,
  db_close(my_dba),

  time(H2,M2,S2,D2),
  Time = (D2-D1)+100.0*((S2-S1)+60.0*((M2-M1)+ 60.0*(H2-H1))),nl,nl,
  write("Time = ",Time,"/100 Sec"),nl.
