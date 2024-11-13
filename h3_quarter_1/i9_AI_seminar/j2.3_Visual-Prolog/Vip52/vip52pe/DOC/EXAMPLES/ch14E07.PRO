/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH14E07.PRO
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
    filename = "c:\\Program Files\\Vip52\\vpi\\programs\\register\\exe\\register.bin"
  enddef
enddef

domains
  Db_selector = myDba
  chainterm  = chain(string, mydom)
  file = outfile
  mydom = city(zipcode, cityname);
  person(firstname, lastname, street, zipcode, code)
  zipcode, cityname, firstname, lastname = string
  street, code = string

predicates
  wr(chainterm)
  dumpDba(string,string)

clauses
  wr(X):-
	write(X),nl.

  dumpDba(Db_selector,OutFile):-
	db_open(myDba,Db_selector,in_file),
	openwrite(outfile,OutFile),
	writedevice(outfile),
	db_chains(myDba,Chain),
	chain_terms(myDba,Chain,mydom,Term,_),
	wr(chain(Chain,Term)),
	fail.

  dumpDba(_,_):-
	closefile(outfile),
	db_close(myDba).

goal
  dumpDba(filename,"register.txt").
