/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_136_2.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
	This program sets up a database of US Senators.  Compound
	objects are used in the Senators record whenever logically
	possible.  Data entry of the records is left to the user.

(Note: This program was apparently written by a student who
       peeked ahead in the manual.  However, the important
       thing to look at is how the user-defined domains
       are used in the predicate declarations.)
*****************************************************************************/

domains
  fname, lname,
  state, bill   =  string
  mon           =  symbol
  day, year     =  integer
  party         =  r ; d
  vote          =  y ; n ; a
  name          =  n ( lname, fname )
  affil         =  a ( state, party )
  constituency  =  real
  elec_date     =  d ( mon, day, year )
  record        =  r ( bill, vote )
  vote_record   =  record*	% Vote Record is a list of records

facts
  senator(name,affil,constituency,elec_date,vote_record)

/*
 * Example senator data record:
 *
 *   senator( n("Hows", "Sammy R.") ,
 *            a( "ca", D ) ,
 *            17484 ,
 *            d( "aug", 10, 1982 ) ,
 *            [ r( "SB 98-103", N) ,
 *              r( "SJ 98-104", N) ,
 *              r( "SB 98-105", A) ,
 *              r( "SB 98-106", Y) ,
 *              r( "SB 98-107", N) ,
 *              r( "SJ 98-108", A) ,
 *              r( "SB 98-109", A) ,
 *              r( "SB 98-110", Y) ,
 *              r( "SB 98-111", N) ,
 *              r( "SB 98-112", N)]).
 */

predicates
  add_a_senator - determ ()
  add_a_vote - procedure ()
  append(vote_record,vote_record,vote_record) - procedure (i,i,o)
  consult_file - determ ()
  convert_party(char,party) - determ (o,i), determ (i,o)
  convert_vote(char,vote) - determ (o,i), determ (i,o)
  get_con(constituency) - procedure (o)
  get_date(elec_date) - determ (o)
  get_day(day) - procedure (o)
  get_new_vote(bill,vote) - determ (o,o)
  get_party(party) - determ (o)
  get_senator(name,affil,constituency,elec_date,vote_record) - determ (i,o,o,o,o)
  get_vote(vote) - determ (o)
  get_vote_record(integer,vote_record) - determ (i,o)
  get_year(year) - procedure (o)
  list_senators - determ ()
  menu - nondeterm ()
  number_of_vote_records(vote_record,integer) - procedure (i,o)
  process_choice(char) - determ (i)
  process_vote(vote_record,integer,vote_record) - determ (i,i,o)
  read_file - determ ()
  repeat - nondeterm ()
  save_file - procedure ()
  write_votes(vote_record) - determ (i)
  write_votes1(vote_record) - determ (i)

clauses
/*
 *  Main Loop
 */
  menu:-
	repeat,
	write("************************* Menu *************************"),
	nl,
	write("1. (A)dd a new senator\n"),
	write("2. (U)pdate a senator's record\n"),
	write("3. (L)ist senators\n"),
	write("4. (S)ave new database\n"),
	write("5. (C)onsult senator database\n"),
	write("6. e(X)it\n\n"),
	write("Enter a Choice: "),
	readchar(Choice),
	nl,
	upper_lower(Ch,Choice),
	process_choice(Ch),
	Ch = 'X'.

  process_choice('A'):-!,
	add_a_senator.
  process_choice('U'):-!,
	add_a_vote.
  process_choice('L'):-!,
	list_senators.
  process_choice('S'):-!,
	save_file.
  process_choice('C'):-!,
	consult_file.
  process_choice('X').

/*
 * Add a New Senator
 */
  add_a_senator:-
	repeat,
	nl,
	write("******************* Add a New Senator *******************"),
	nl,
	write("First Name   :"),
	readln(Fname),
	nl,
	write("Last Name    :"),
	readln(Lname),
	nl,
	Name = n(Lname, Fname),
	write("State        :"),
	readln(State),
	nl,
	write("Party (D/R)  :"),
	get_party(Party),
	nl,
	write("Constituency :"),
	get_con(Con),
	nl,
	write("Date Elected  "),
	get_date(Date),
	nl,
	Afil = a(State,Party),
	write("Voting Record (10 bills Maximum):"),
	nl,
	write("(Maximum number of 10 votes or <ENTER> to stop."),
	nl,
	write(" Vote: Y, N or A)"),
	nl,
	get_vote_record(10,Record),
	assertz(senator(Name,Afil,Con,Date,Record)),
	nl,
	write("\nDo you wish to add another Senator? (Y/N): "),
	readchar(Ans),
	write(Ans),
	nl,
	upper_lower(Ans,'n'),
	!.

  get_party(Party):-
	repeat,
	readchar(C),
	upper_lower(C1,C),
	write(C1),
	convert_party(C1,Party),
	!.
  	
  convert_party('D',d):-!.
  convert_party('R',r):-!.  	
  convert_party(_,_):-
	beep,
	fail.  	

  get_con(Con):-	
	readreal(Con),
	!.
  get_con(Con):-
	beep,
	get_con(Con).  	
  	
  get_date(Date):-
	nl,
	write("   Month     :"),
	readln(Month),
	nl,
	get_day(Day),
	get_year(Year),
	Date = d(Month,Day,Year).
  	
  get_day(D):-  	
	write("   Day       :"),
	readint(D),
	!,
	nl.
  get_day(D):-
	beep,
	get_day(D).
    	
  get_year(Y):-	    	
	write("   Year      :"),
	readint(Y),
	!,
	nl.
  get_year(Y):-
	beep,
	get_year(Y).  	
  	
  get_vote_record(0,[]):-!.
  get_vote_record(Num,[H|T]):-
	Num1 = Num - 1,
	Num_in = abs(Num - 11),
	writef("%)  Bill Number:",Num_in),
	readln(Bill),nl,
	Bill <> "",!,		% Check for a <CR>
	get_vote(Vote),
	H = r(Bill,Vote),
	get_vote_record(Num1,T).
  get_vote_record(_,[]).   	%  This will succeed when a <CR> is hit

  get_vote(Vote):-
	repeat,
	write("Senator Vote: "),
	readchar(V),
	upper_lower(V1,V),
	write(V1),
	nl,
	convert_vote(V1,Vote),
	!.

  convert_vote('Y',y):-!.
  convert_vote('N',n):-!.
  convert_vote('A',a):-!.
  convert_vote(_,_):-
	beep,
	fail.

/*
 *  Update a Senator's Vote Record
 */
  add_a_vote:-
	nl,
	write("************* Update a Senator's Vote Record *************"),
	nl,
	write("First Name : "),
	readln(Fname),nl,
	write("Last Name  : "),
	readln(Lname),nl,
	get_senator(n(Lname,Fname),_,_,_,_),	% see if name exists
	repeat,
	get_senator(n(Lname,Fname),_,_,_,Votes),
	number_of_vote_records(Votes,Num),
	process_vote(Votes,Num,New_votes),
	retract(senator(n(Lname,Fname),A,B,C,Votes)),
	assertz(senator(n(Lname,Fname),A,B,C,New_votes)),
	write("\n\nWould you like to add another ",
		"vote to this Senator? (Y/N): "),
	readchar(Ans),
	write(Ans),
	nl,
	upper_lower('N',Ans),
	!.
  add_a_vote.	
	
  process_vote([_|T],10,New_votes):-
	!,
	get_new_vote(Bill,Vote),
	append(T,[r(Bill,Vote)],New_votes).
  process_vote(Votes,_,New_votes):-
	get_new_vote(Bill,Vote),	
	append(Votes,[r(Bill,Vote)],New_votes).

  get_new_vote(Bill,Vote):-
	write("Bill Number: "),
	readln(Bill),
	nl,
	repeat,
	write("Senator's Vote: "),
	readchar(V),
	upper_lower(V1,V),
	write(V1),
	nl,
	convert_vote(V1,Vote),
	!.

  get_senator(Name,Affil,Constituency,Elec_date,Vote_record):-
	senator(Name,Affil,Constituency,Elec_date,Vote_record),
	!
	;
	write("Senator Name not found!\n" ,
		"Press a key to continue..."),
	readchar(_),
	nl,
	fail.

/*
 *  List Senators
 */
  list_senators:-
	nl,
	write("********************** List Senators *******************"),
	nl,
	write("Senators Name\tState  Party  Constituency  Date Elected  Voting Record\n" ,
	      "=============\t=====  =====  ============  ============  =============\n") ,
	senator(n(L,F),a(S,P),C,d(M,D,Y),R),
	convert_party(P1,P),
	str_int(Day,D),
	str_int(Year,Y),
	concat(M,"/",D1),
	concat(D1,Day,D2),
	concat(D2,"/",D3),
	concat(D3,Year,Date),
	concat(F," ",F1),
	concat(F1,L,FL),
	writef("\n%-10 \t %-2      %-1       %-9.0     %-8    ",
	       FL,S,P1,C,Date),
	write_votes(R),
	fail.
  list_senators:-  	
	write("\nPRESS a key..."),
	readchar(_),
	nl.

  write_votes([r(Bill,Vote)|T]):-
	convert_vote(V,Vote),
	writef("%s-%\n",Bill,V),
	write_votes1(T).
  write_votes1([]):-!.
  write_votes1([r(Bill,Vote)|T]):-
	convert_vote(V,Vote),
	write("                                                           ",Bill,"-",V),nl,
	write_votes1(T).

/*
 *  Save Senator's Database to Disk
 */
  save_file:-
	write("\nSaving Database...\n"),
	save("senators.dba").
/*
 * Consult Senator's Databse File
 */
  consult_file:-
	senator(_,_,_,_,_),
	!,
	nl,
	write("************ Consuit Senator's Database File ************"),
	nl,
	write("Database already in memory.\n",
		" Press any key to continue..."),
	readchar(_),
	nl.
  consult_file:-
	existfile("SENATORS.dba"),
	!,
	read_file.
  consult_file:-
	nl,
	write("************ Consuit Senator's Database File ************"),
	nl,
	write("Senators Database file not found!\n",
		" (You must create and save a database\n",
		"   before one can be consulted.)\n\n",
		"Press any key to continue..."),
	readchar(_),
	nl.
  	
  read_file:-  	
	write("\nConsulting Database...\n"),
	nl,
	consult("SENATORS.dba"),
	!
	;
	beep,
	write("ERROR in database!\n" ,
		"Press any key to continue..."),
	readchar(_),
	nl.

/*
 *  System Predicates
 */
  repeat:-
	true
	;
	repeat.

  append([],L,L).
  append([H|L1],L2,[H|L3]):-
	append(L1,L2,L3).

  number_of_vote_records([],0):-!.
  number_of_vote_records([_|T],N):-
	number_of_vote_records(T,N1),
	N = N1 + 1.

goal
  menu.
