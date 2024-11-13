/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH14E08.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

facts - indexes
  determ lockindex(bt_selector)
  determ index(bt_selector)
  determ mark(real)

domains
  my_dom = f(string)
  db_selector = dba

predicates
  repeat - nondeterm ()
  wr_err(integer) - determ (i)
 
 % List texts and their status
  list
  list_texts(bt_selector,bt_selector)
  show_textname(string,bt_selector)

clauses
  show_textname(Key,LockIndex):-
	key_search(dba,LockIndex,Key,_),!,
	write("\n*",Key).
  show_textname(Key,_):-
	write("\n ",Key).
  
  list_texts(Index,LockIndex) :-
	key_current(dba,Index,Key,_),
	show_textname(Key,LockIndex),
	key_next(dba,Index,_),!,
	list_texts(Index,LockIndex).
  list_texts(_,_).
  
  list:-nl,
	write("***************** TEXTS (*=Locked) *******************"),nl,
	index(Index),
	lockindex(LockIndex),		
	key_first(dba,Index,_),!,
	list_texts(Index, LockIndex),nl,
	write("******************************************************"),nl.
  list.

  repeat.
  repeat:-repeat.

  wr_err(E):-
	errormsg("prolog.err",E,Errormsg,_),
	write(Errormsg),
	readchar(_).

predicates
 %Logical locking of files
  lock(string,bt_selector,bt_selector) - determ (i,i,i)

clauses
  lock(Name,Index,LockIndex):-
	not(key_search(dba,LockIndex,Name,_)),!,
	key_search(dba,Index,Name,Ref),
	key_insert(dba, LockIndex, Name, Ref).
  lock(Name,_,_):-
	db_endtransaction(dba),
	write(Name," is being updated by another user.\n Access denied"),
	fail.

predicates
  ed(db_selector,bt_selector,bt_selector,string) - procedure (i,i,i,i)
  ed1(db_selector,bt_selector,bt_selector,string) - determ (i,i,i,i)

clauses
 % The ed predicates ensure that the edition will never fail. 
  ed(dba,Index,LockIndex,Name):-
	ed1(dba,Index,LockIndex,Name),!.
  ed(_,_,_,_).

  /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  * There are two choices:                                     *
  *                                                            *
  * 1) The name already exists - modify the contents of the    *
  *  file                                                      *
  * 2) The name is a new name - create a new file              *
  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 %Old file
  ed1(dba,Index,LockIndex,Name):-
	db_begintransaction(dba,readwrite),
	key_search(dba,Index,Name,Ref),!,
	ref_term(dba,string,Ref,Str),
	lock(Name,Index,LockIndex),
	list,
	db_endtransaction(dba),nl,
	write("******************************************************"),nl,
	write("*  EDIT               ",Name,"                     *"),nl,
	write("******************************************************"),nl,
	write(Str),nl,
	write("< Press 'r' to replace this string ; else any key >"),nl,
	readchar(X),X='r',nl,
	write("Enter string and press <ENTER>"),nl,
	readln(Str1),nl,
	db_begintransaction(dba,readwrite),
	term_replace(dba,string,Ref,Str1),
	key_delete(dba,LockIndex,Name,Ref), %unlock
	list,
	db_endtransaction(dba).

 %New file
  ed1(dba,Index,LockIndex,Name):-
	chain_insertz(dba,"file_chain",string,"",Ref),
	key_insert(dba,Index,Name,Ref),
	list,
	db_endtransaction(dba),
	ed1(dba,Index,LockIndex,Name).

predicates
  main(db_selector,bt_selector,bt_selector) - procedure (i,i,i)
  interpret(char,bt_selector,bt_selector) - determ (i,i,i)
  check_update_view - procedure ()
  update_view - procedure ()
  get_command(char) - procedure (o)

clauses
 % Loop until 'Q' is pressed
  main(dba,Index,LockIndex) :-
	check_update_view,
	get_command(Command),
	trap(interpret(Command,Index,LockIndex),E,wr_err(E)),!,
	main(dba,Index,LockIndex).
  main(_,_,_).

  check_update_view:-
	mark(T),timeout(T),!,
	db_begintransaction(dba,read),
	update_view,
	db_endtransaction(dba),
	marktime(100,Mark),
	retractall(mark(_)),
	assert(mark(Mark)).
  check_update_view.

  update_view:-nl,
	write("******* COMMANDS E:Edit V:View D:Delete Q:Quit *******"),nl,
	write("COMMAND>"),
	db_updated(dba),!,
	list.
  update_view.
  
  get_command(Command):-
	readchar(C),!,
	upper_lower(Command,C),
	write(Command),nl.
  get_command(' ').
   
 %interpret commandlineinput
  interpret(' ',_,_):-!.
  interpret('Q',_,_):-!,fail.
  interpret('E',Index,LockIndex):-!,
	write("\nFile Name: "),
	readln(Name),nl,
	ed(dba,Index,LockIndex,Name).
  interpret('V',Index,_):-
	write("\nFile Name: "),
	readln(Name),nl,
	db_begintransaction(dba,read),
	key_search(dba,Index,Name,Ref),!,
	ref_term(dba,string,Ref,Str),
	db_endtransaction(dba),
	write("******************************************************"),nl,
	write("*      VIEW            ",Name,"                      "),nl,
	write("******************************************************"),nl,
	write(Str),nl.

  interpret('V',_,_):-!,
	db_endtransaction(dba).
  interpret('D',Index,_):-
	write("\nDelete file: "),
	readln(Name),nl,
	db_begintransaction(dba,readwrite),
	key_search(dba,Index,Name,Ref),!,
%	not(key_search(dba,LockIndex,Name,_)),!,
	key_delete(dba,Index,Name,Ref),
	term_delete(dba,"file_chain",Ref),
	list,
	db_endtransaction(dba).
  interpret('D',_,_):-!,
	db_endtransaction(dba).
  interpret(_,_,_):-beep.

predicates
  open_dbase(bt_selector,bt_selector) - procedure (o,o)

clauses
  open_dbase(INDEX,LOCKINDEX):-
	existfile("share.dba"),!,
	db_open(dba,"share.dba",readwrite,denynone),
	db_begintransaction(dba,readwrite),
	bt_open(dba,"locks",LOCKINDEX),
	bt_open(dba,"ndx",INDEX),
	db_endtransaction(dba).

  open_dbase(INDEX,LOCKINDEX):-
	db_create(dba,"share.dba",in_file),
	bt_create(dba,"locks",TEMPLOCKINDEX,20,4),
	bt_create(dba,"ndx",TEMPINDEX,20,4),
	bt_close(dba,TEMPINDEX),
	bt_close(dba,TEMPLOCKINDEX),
	db_close(dba),
	open_dbase(INDEX,LOCKINDEX).

goal
  write("******* COMMANDS E:Edit V:View D:Delete Q:Quit *******"),nl,
  open_dbase(INDEX,LOCKINDEX),
  assert(index(INDEX)),
  assert(lockindex(LOCKINDEX)),
  marktime(10,Mark),
  assert(mark(Mark)),
  db_setretry(dba,5,20),
  db_begintransaction(dba,read),
  list,nl,
  db_endtransaction(dba),
  main(dba, INDEX,LOCKINDEX),
  db_begintransaction(dba,read),
  bt_close(dba, INDEX),
  bt_close(dba, LOCKINDEX),
  db_endtransaction(dba),
  db_close(dba).
