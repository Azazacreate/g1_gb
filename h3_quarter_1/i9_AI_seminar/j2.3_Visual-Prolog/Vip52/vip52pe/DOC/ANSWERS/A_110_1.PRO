/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_110_1.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

domains
  person = string

predicates
  special_taxpayer(person) - determ (i)
  average_taxpayer(person) - nondeterm (i)
  is_a_citizen(person) - nondeterm (i)
  married(person,person) - determ (i,o)
  has_kids(person,integer) - determ (i,o)
  has_two_kids(person,integer) - determ (i,o)
  makes_bucks(person,integer) - determ (i,o)
  right_income(person,integer) - determ (i,o)

clauses
  is_a_citizen("tom").
  is_a_citizen("albert").
  is_a_citizen("suzie").
  is_a_citizen("bonnie").
  is_a_citizen(Person):-
	married(Person,Spouse),
        is_a_citizen(Spouse),!.   /* The cut must be placed here to prevent
                                     unnecessary backtracking. To see this,
                                     trace thru the program, first with
                                     and then without the cut.
                                  */
  married("tom","chris").
  married("albert","rachel").
  married("fred","suzie").
  married("duke","joanne").

  has_kids("albert",3).
  has_kids("suzie",2).
  has_kids("fred",2).
  has_kids("bonnie",1).
  has_kids("tom",0).

  has_two_kids(Person,X):-
	has_kids(Person,X),
	X=2.

  makes_bucks("tom",250).
  makes_bucks("fred",3000).
  makes_bucks("albert",1500).
  makes_bucks("suzie",0).

  right_income(Person,N):-
	makes_bucks(Person,N),
	500 <= N,
	N <= 2000.

  average_taxpayer(Person):-
	is_a_citizen(Person),
	right_income(Person,_),
	has_two_kids(Person,_),
	married(Person,_),
	write(Person," is an average taxpayer").

  special_taxpayer(Person):-
	not(average_taxpayer(Person)),
	write(Person," is a special taxpayer").

goal
  special_taxpayer("fred"),
  nl.
