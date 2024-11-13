/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E11.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  likes_shopping(symbol) - nondeterm (o)
  has_credit_card(symbol,symbol) - nondeterm (o,o)
  bottomed_out(symbol,symbol) - nondeterm (i,i)

clauses
  likes_shopping(Who):-
	has_credit_card(Who,Card),
	not(bottomed_out(Who,Card)),
	write(Who," can shop with the ",Card, " credit card.\n").

  has_credit_card(chris,visa).
  has_credit_card(chris,diners).
  has_credit_card(joe,shell).
  has_credit_card(sam,mastercard).
  has_credit_card(sam,citibank).

  bottomed_out(chris,diners).
  bottomed_out(sam,mastercard).
  bottomed_out(chris,visa).

goal
  likes_shopping(Who).
