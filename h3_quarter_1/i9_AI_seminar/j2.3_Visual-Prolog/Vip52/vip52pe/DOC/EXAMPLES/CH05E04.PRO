/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH05E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  articles            = book(title, author) ;
			horse(name) ; boat ;
			bankbook(balance)
  title, author, name = symbol
  balance             = real

predicates
  owns(name,articles) - nondeterm (i,o)

clauses
  owns(john,book("A friend of the family","Irwin Shaw")).
  owns(john,horse(blacky)).
  owns(john,boat).
  owns(john,bankbook(1000.0)).


goal
  owns(john,Thing).
	