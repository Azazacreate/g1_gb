/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  title,author = symbol
  pages        = unsigned

predicates
  book(title,pages) - nondeterm (i,o)
  written_by(author,title) - nondeterm (o,o)
  long_novel(title) - nondeterm (o)

clauses
  written_by(fleming,"DR NO").
  written_by(melville,"MOBY DICK").

  book("MOBY DICK",250).
  book("DR NO",310).

  long_novel(Title):-
	written_by(_,Title),
	book(Title,Length),
	Length > 300.

goal
  long_novel(X).
