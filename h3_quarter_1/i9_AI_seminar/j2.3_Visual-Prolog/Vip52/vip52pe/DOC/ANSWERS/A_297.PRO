/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_297.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  sign = neg ; pos

predicates
  check_binary(integer,integer) - determ (i,o)
  write_answer(sign,real) - procedure (i,i)
  get_num(real,real) - determ (o,i)
  get_sign(sign) - procedure (o)
  power(real,real,real) - procedure (i,i,o)
  read_an_int(integer) - determ (o)
  readbnumb - determ ()
  repeat - nondeterm ()
  x_it - nondeterm ()

clauses
  readbnumb:-
	write("Please enter a 16 bit binary number.\n\n"),
	write("Example :\n\n"),
	write("   BIT: 15 ------------ 0\n"),
	write("         1101001010011010\n\n"),
	write("BINARY : "),

	get_sign(Sign),

	get_num(Answer,15.0),  /* 15 is the current power of 2 */

	write_answer(Sign, Answer).

  get_sign(Sign):-
	read_an_int(Bin),
	Bin = 0,
	!,
	Sign = pos;
	Sign = neg.

  get_num(1.0,0.0):-!.
  get_num(Answer,Power):-
	read_an_int(Bin),
	NewPower = Power - 1,
	power(2.0,NewPower,Result),
	get_num(NewAnswer,Newpower),
	Answer = (Bin * Result) + NewAnswer.

  power(Num,Power,Ans):-
	Ans = exp(Power*ln(Num)).
	write_answer(Sign,Answer):-
	Sign = neg,
	!,
	Signed = Answer * -1 + 1,
	Unsigned = Answer + 32767 ,
	write("\n\nINTEGER SIGNED   : ",Signed),
	write("\n\nINTEGER UNSIGNED : ",Unsigned),
	nl,
	nl
	;
	NewAnswer = Answer - 1,
	write("\n\nDECIMAL : ",NewAnswer),
	nl,
	nl.
  read_an_int(Bin):-
	readchar(Num),
	write(Num),
	check_binary(Num,Bin).
		
  check_binary(48,0):-!.
  check_binary(49,1):-!.
  check_binary(_,Bin):-
	beep,
	read_an_int(Bin).
	
  x_it:-
	write("Press X to exit..."),
	repeat,
	readchar(X),
	upper_lower(X,'x').
		
  repeat:-
	true
	;
	repeat.

goal
  write("******************* Binary - Decimal ********************"),
  nl,
  readbnumb,
  x_it.
