/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH14E03.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
	This example differs from the one in the book by generating significantly
	less screen output, as otherwise 90% of the time spent would be wasted
	in screen updating.  Even so, the true speed is only revealed if you
	disable all screen output.
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
	db_chains(my_dba, Chain),
	chain_terms(my_dba,Chain,my_dom,Term,Ref),nl,
	write("Ref=",Ref,",Term=",Term),
	fail.
  read_dba:-
	db_chains(my_dba,Chain),
	chain_first(my_dba,Chain,Ref),
	rd(Ref),
	fail.
  read_dba.

  rd(Ref):-
	%ref_term(my_dba, my_dom, Ref, Term), nl, write(Term), fail.
	ref_term(my_dba,my_dom,Ref,_),
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

  mixture:-nl,
	write("Replace every second term:"),
	replace_dba,nl,
	write("Double the number of terms:"),
	double_dba,nl,
	write("Erase every second term:"),
	half_dba,nl,
	write("Use ref_term for all terms:"),
	read_dba,
	count_dba(N),nl,
	write("There are now ", N, " terms in the database"),
	db_statistics(my_dba, NoOfTerms, MemSize, DbaSize, FreSize),nl,
	write("NoOfTerms=",NoOfTerms),nl,
	write("MemSize=",MemSize),nl,
	write("DbaSize=",DbaSize),nl,
	write("FreeSize=",FreSize),nl.

goal
  nl,nl,nl,
  write("\tTEST OF DATABASE SYSTEM\n\t***********************\n\n"),
  marktime(0,T1),
  db_create(my_dba,"dd.dat",in_memory),nl,nl,
  write("Write some terms in the database:"),
  write_dba(50),
  read_dba,
  mixture,nl,nl,nl,

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

  marktime(0,T2),
  Time=T1-T2,nl,nl,
  %difftime(T2,T1,Time),
  write("Time = ", Time, "/100 Sec" ),nl.
