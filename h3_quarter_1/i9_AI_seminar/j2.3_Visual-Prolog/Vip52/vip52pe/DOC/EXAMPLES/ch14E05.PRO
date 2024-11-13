/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH14E05.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

constants 
ifdef os_unix
  filename = "/usr/local/PDCProlog/programs/register/register.bin"
elsedef
  ifdef os_os2
    filename = "c:\\vip52\\vpi\\programs\\register\\exe\\register.bin"
  elsedef
    filename = "c:\\Program Files\\vip52\\vpi\\programs\\register\\exe\\register.bin"
  enddef
enddef

domains
  db_selector = mydba
  mydom = city(zipcode, cityname);
        person(firstname, lastname, street, zipcode, code)
  zipcode, cityname, firstname, lastname, street, code  =  string

predicates
  listdba(db_selector) - procedure (i)
  bt_keys(db_selector,bt_selector,string,ref) - nondeterm (i,i,o,o)
  bt_keysloop(db_selector,bt_selector,string,ref) - nondeterm (i,i,o,o)

clauses
  listdba(Db_selector):-nl,
	write("********************************************"),nl,
	write("           DATABASE LISTING"),nl,
	write("********************************************"),
	db_statistics(Db_selector,NoOfTerms,MemSize,DbaSize,FreeSize),nl,nl,
	write("Total number of records in the database: ",NoOfTerms),nl,
	write("Number of bytes used in main memory: ",MemSize),nl,
	write("Number of bytes used by the database: ",DbaSize),nl,
	write("Number of bytes free on disk: ",FreeSize),nl,
	fail.

  listdba(Db_selector):-
	db_chains(Db_selector,Chain),nl,nl,nl,nl,
	write("******* Chain LISTING *************"),nl,nl,
	write("Name=",Chain),nl,nl,
	write("CONTENT OF: ",Chain),nl,
	write("------------------------------\n"),
	chain_terms(Db_selector, Chain, mydom,Term, Ref),
	write("\n", Ref, ": ",Term),
	fail.

  listdba(Db_selector):-
	db_btrees(Db_selector,Btree),             /* Returns each B+ tree name */
	bt_open(Db_selector,Btree,Bt_selector),
	bt_statistics(Db_selector,Bt_selector,NoOfKeys,
                      NoOfPages,Dept,KeyLen,Order,PageSize),nl,nl,nl,
	write("******** INDEX LISTING **************"),nl,nl,
	write("Name=     ", Btree),nl,
	write("NoOfKeys= ", NoOfKeys),nl,
	write("NoOfPages=", NoOfPages),nl,
	write("Dept=     ", Dept),nl,
	write("Order=    ", Order),nl,
	write("KeyLen=   ", KeyLen),nl,
	write("PageSize= ", PageSize), nl,
	write("CONTENT OF: ", Btree),nl,
	write("-----------------------------\n"),
	bt_keys(Db_selector,Bt_selector,Key,Ref),
	write("\n",Key, " - ",Ref),
	fail.
  listdba(_).

  bt_keys(Db_selector,Bt_selector,Key, Ref):-
	key_first(Db_selector,Bt_selector,_),
	bt_keysloop(Db_selector,Bt_selector,Key,Ref).

  bt_keysloop(Db_selector,Bt_selector,Key,Ref):-
	key_current(Db_selector,Bt_selector,Key,Ref).

  bt_keysloop(Db_selector,Bt_selector,Key,Ref):-
	key_next(Db_selector,Bt_selector,_),
  bt_keysloop(Db_selector,Bt_selector,Key,Ref).

goal
  db_open(mydba,filename,in_file),
  listdba(mydba).
