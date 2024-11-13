/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_157_3.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
	Since PDC Prolog does not contain a power function,
	one can be modeled with the following equation:
	M^n = exp( n * ln(M) )
	where ln is the Logarithm to base e.
******************************************************************************/

predicates
  power_of_two(integer) - procedure (i)

clauses
  power_of_two(10):-!. 	% stop after 2^10 is processed
  power_of_two(Expon):-
	Exp1 = Expon + 1 ,
  	Num = exp(Exp1*ln(2)),
  	write("\t   ",Exp1,"\t\t   ",Num,"\n"),
  	power_of_two(Exp1).
  	
goal
  write("\n\tExponent\t\tResult\n",
  "\t========\t======\n"),
  power_of_two(0),
  nl.

