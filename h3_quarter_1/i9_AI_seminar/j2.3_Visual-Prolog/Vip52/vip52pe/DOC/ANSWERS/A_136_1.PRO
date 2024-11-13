/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_136_1.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

domains
  lyrics = lyrics(symbol,symbol)
  music  = music(symbol,symbol)
  name   = string

predicates
  show(name,lyrics,music) - nondeterm (o,lyrics(o,o),music(o,o))
  write_shows - procedure ()

clauses
  show("West Side Story",lyrics(stephen,sondheim),
          music(leonard,bernstein)).
  show("Repo Man", lyrics(iggy,pop),
          music(iggy,pop) ).
  show("Live and Let Die",lyrics(paul,mc_cartney),
          music("",wings)).
  show("Two Hundred Motels",lyrics(frank,zappa),
          music(mothers_of,invention)).
  show("The King and I",lyrics(rogers,hammerstein),
          music("","?")).
  show("Chess",lyrics("Andersson Rice","& Ulvaeus"),
          music(london,symphony)).
  show("Stop Making Sense",lyrics(talking,heads),
          music(talking,heads)).

  write_shows:-
	show(Show,lyrics(First,Last),music(M_first,M_last)),
	write("The show ",Show," has music written by ",
    	      First," ",Last),nl,
	write("The music is played by ",M_first," ",M_last,"."),nl,nl,
	fail.
  write_shows.

goal
  write_shows,
  write("Press any key..."),
  readchar(_).
