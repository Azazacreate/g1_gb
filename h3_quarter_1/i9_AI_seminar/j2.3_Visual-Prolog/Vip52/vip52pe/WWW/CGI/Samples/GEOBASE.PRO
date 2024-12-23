/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  GEOBASE
 FileName: GEOBASE.PRO

Geobase demonstrates a natural language interface to a database
on U.S. geography. Geobase allows you to query its database in
English rather than computerese.  For a more complete discussion 
of Geobase and its features please refer to Appendix F in the 
Reference Guide.

The database contains the following information:

Information about states:
  Area of the state in square kilometers
  Population of the state in citizens
  Capital of the state
  Which states border a given state
  Rivers in the state
  Cities in the state
  Highest and lowest point in the state in meters

Information about rivers:
  Length of river in kilometers

Information about cities:
  Population of the city in citizens


You can retrieve any or all of this information by asking questions
in normal English. Some sample queries:

   - states

   - give me the cities in california.

   - what is the biggest city in california ?

   - what is the longest river in the usa?

   - which rivers are longer than 1 thousand kilometers?

   - what is the name of the state with the lowest point ?

   - which states border alabama ?

   - which rivers do not run through texas

   - which rivers run through states that border the state
     with the capital austin?

You can modify Geobase as you work with it. If it doesn't
understand a word in one of your questions, you can add the word
to the language definition. The language is defined in a number
of relations, the most important one being the schema. A schema
is a description of the logical structure of a database. In
Geobase, the schema is the "entity network" for the language. A
schema entry follows the form: ENTITY ASSOCIATION ENTITY; this
signifies that the two entities are bound together by the given
association.

To display the relations and their schema, select View Language
from the Geobase main menu, then choose one of the items listed
below.

 1. Schema of relations
    The geographic data is stored in a number of relations. The
    schema for these relations is listed here.

 2. Schema of questions
    The schema for all possible questions that can be asked is listed
    here. For example, one possibility is:
    > population  of  city <
    That is, what is the population of a given city?

 3. Names of entities
    All known entities are listed here.

 4. Synonyms for entities
    Synonyms for entities are allowed. The previously defined
    synonyms are listed here; you can also add synonyms to the
    database dynamically.

 5. Synonyms for associations
    Synonyms for associations are allowed and can consist of
    more than one word.

 6. Words that are ignored
    Some words are simply ignored by the system since they are not
    directly relevant to the meaning of questions. Ignored words are
    listed here.

 7. Units for entities
    The units of measure for different entities are listed here. For
    instance, the unit for population is "number of citizens".

 8. Synonyms for relational operators
    There are several ways to say that a city is "bigger than" 1 million
    citizens or that a river is "shorter than" 1 thousand miles. These
    synonyms are listed here.

 9. Alternative ways to designate the minimum
    The different ways to designate adjectives for "minimum" are listed here.

10. Alternative ways to designate the maximum
    The different ways to designate adjectives for "maximum" are listed here.

******************************************************************************/
include "cgiexam.inc"

DOMAINS
  ENT	= STRING		% Names of entities
  ASSOC	= STRING		% Names of associations
  RELOP	= STRING		% gt, lt, eq for comparisons
  UNIT	= STRING		% kilometers, citizens etc.
  STRINGLIST = STRING*

/**********************************************************
 The Language Tables - These are the database predicates
 which define the language we will use to query Geobase.
***********************************************************/

DATABASE - language
  schema(ENT,ASSOC,ENT)		% Entity network: entity-assoc-entity
  entitysize(ENT,STRING)	% This attribute tells which words can be
				%   user to query the size of the entity
  relop(STRINGLIST,STRING)	% Example: relop([greater,than],gt]
  assoc(ASSOC,STRINGLIST)	% Alternative assoc names
  synonym(STRING,ENT)		% Synonyms for entities
  ignore(STRING)		% Words to be ignored
  minn(STRING)			% Words stating minimum
  maxx(STRING)			% Words stating maximum
  size(STRING,STRING)		% big, long, high ....
  unit(STRING,STRING)		% Units for population, area ...


/**************************************************************
  The real database - These are the database predicates which
  actually  maintain the information we will access.
****************************************************************/

DATABASE - data
  state(STRING name,STRING abbreviation,STRING capital,REAL area,REAL admit,
  	INTEGER population,STRING city,STRING city,STRING city,STRING city)
  city(STRING state,STRING abbreviation,STRING name,REAL population)
  river(STRING name,INTEGER length,STRINGLIST statelist)
  border(STRING state,STRING abbreviation,STRINGLIST statelist)
  highlow(STRING state,STRING abbreviation,STRING point,INTEGER height,STRING point,INTEGER height)
  mountain(STRING state,STRING abbreviation,STRING name,REAL height)
  lake(STRING name,REAL area,STRINGLIST statelist)
  road(STRING number,STRINGLIST statelist)


/**************************************************************
	Access to the database
****************************************************************/

PREDICATES
  nondeterm member(STRING,STRINGLIST)
  nondeterm member(parm,parmlist)

CLAUSES
  member(X,[X|_]).
  member(X,[_|L]):-member(X,L).

PREDICATES
  nondeterm db(ENT,ASSOC,ENT,STRING,STRING)
  nondeterm ent(ENT,STRING)

CLAUSES
%  ent returns values for a given entity name. Ex. if called by
%  ent(city,X)  X  is instantiated to cities.
  ent(continent,usa).
  ent(city,NAME):-	city(_,_,NAME,_).
  ent(state,NAME):-	state(NAME,_,_,_,_,_,_,_,_,_).
  ent(capital,NAME):-	state(_,_,NAME,_,_,_,_,_,_,_).
  ent(river,NAME):-	river(NAME,_,_).
  ent(point,POINT):-	highlow(_,_,_,_,POINT,_).
  ent(point,POINT):-	highlow(_,_,POINT,_,_,_).
  ent(mountain,M):-	mountain(_,_,M,_).
  ent(lake,LAKE):-	lake(LAKE,_,_).
  ent(road,NUMBER):-	road(NUMBER,_).
  ent(population,POPUL):-city(_,_,_,POPUL1),str_real(POPUL,POPUL1).
  ent(population,S):-state(_,_,_,POPUL,_,_,_,_,_,_),str_real(S,POPUL).

%  The db predicate is used to establish relationships between
%  entities. The first three parameters should always be instantiated
%  to entity_name - assoc_name - entity_name. The last two parameters
%  return the values corresponding to the two entity names.

  % Relationships about cities
  db(city,in,state,CITY,STATE):-	city(STATE,_,CITY,_).
  db(state,with,city,STATE,CITY):-	city(STATE,_,CITY,_).
  db(population,of,city,POPUL,CITY):-	city(_,_,CITY,POPUL1),str_real(POPUL,POPUL1).
  db(population,of,capital,POPUL,CITY):-city(_,_,CITY,POPUL1),str_real(POPUL,POPUL1).

  % Relationships about states
  db(abbreviation,of,state,ABBREVIATION,STATE):-	state(STATE,ABBREVIATION,_,_,_,_,_,_,_,_).
  db(state,with,abbreviation,STATE,ABBREVIATION):-state(STATE,ABBREVIATION,_,_,_,_,_,_,_,_).
  db(area,of,state,AREA,STATE):-	state(STATE,_,_,_,AREA1,_,_,_,_,_),str_real(AREA,AREA1).
  db(capital,of,state,CAPITAL,STATE):-	state(STATE,_,CAPITAL,_,_,_,_,_,_,_).
  db(state,with,capital,STATE,CAPITAL):-state(STATE,_,CAPITAL,_,_,_,_,_,_,_).
  db(population,of,state,POPULATION,STATE):-state(STATE,_,_,POPUL,_,_,_,_,_,_),str_real(POPULATION,POPUL).
  db(state,border,state,STATE1,STATE2):-border(STATE2,_,LIST),member(STATE1,LIST).

  % Relationships about rivers
  db(length,of,river,LENGTH,RIVER):-	river(RIVER,LENGTH1,_),str_real(LENGTH,LENGTH1).
  db(state,with,river,STATE,RIVER):-	river(RIVER,_,LIST),member(STATE,LIST).
  db(river,in,state,RIVER,STATE):-	river(RIVER,_,LIST),member(STATE,LIST).

  % Relationships about points
  db(point,in,state,POINT,STATE):-	highlow(STATE,_,POINT,_,_,_).
  db(point,in,state,POINT,STATE):-	highlow(STATE,_,_,_,POINT,_).
  db(state,with,point,STATE,POINT):-	highlow(STATE,_,POINT,_,_,_).
  db(state,with,point,STATE,POINT):-	highlow(STATE,_,_,_,POINT,_).
  db(height,of,point,HEIGHT,POINT):-	highlow(_,_,_,_,POINT,H),str_int(HEIGHT,H),!.
  db(height,of,point,HEIGHT,POINT):-	highlow(_,_,POINT,H,_,_),str_int(HEIGHT,H),!.

  % Relationships about mountains
  db(mountain,in,state,MOUNT,STATE):-	mountain(STATE,_,MOUNT,_).
  db(state,with,mountain,STATE,MOUNT):-	mountain(STATE,_,MOUNT,_).
  db(height,of,mountain,HEIGHT,MOUNT):-	mountain(_,_,MOUNT,H1),str_int(HEIGHT,H1).

  % Relationships about lakes
  db(lake,in,state,LAKE,STATE):-	lake(LAKE,_,LIST),member(STATE,LIST).
  db(state,with,lake,STATE,LAKE):-	lake(LAKE,_,LIST),member(STATE,LIST).
  db(area,of,lake,AREA,LAKE):-		lake(LAKE,A1,_),str_real(AREA,A1).

  % Relationships about roads
  db(road,in,state,ROAD,STATE):-	road(ROAD,LIST),member(STATE,LIST).
  db(state,with,road,STATE,ROAD):-	road(ROAD,LIST),member(STATE,LIST).

  db(E,in,continent,VAL,usa):-		ent(E,VAL).
  db(name,of,_,X,X):-			bound(X).


PREDICATES
  write_list(INTEGER,STRINGLIST)
  write_list2(STRINGLIST)
  nondeterm append(STRINGLIST,STRINGLIST,STRINGLIST)
  unik(STRINGLIST,STRINGLIST)
  index(STRINGLIST,INTEGER,STRING)

CLAUSES
  index([X|_],1,X):- !.
  index([_|L],N,X):- N>1,N1=N-1,index(L,N1,X).

  unik([],[]).
  unik([H|T],L):-member(H,T),!,unik(T,L).
  unik([H|T],[H|L]):-unik(T,L).

  append([],L,L).
  append([Ah|At],B,[Ah|C]):-append(At,B,C).

  write_list(_,[]).
  write_list(_,[X]):-!,write(X).
  write_list(4,[H|T]):-!,write(H),nl,write_list(0,T).
  write_list(3,[H|T]):-str_len(H,LEN),LEN>13,!,write(H),nl,write_list(0,T).
  write_list(N,[H|T]):-str_len(H,LEN),LEN>13,!,N1=N+2,writef("%-27 ",H),write_list(N1,T).
  write_list(N,[H|T]):-N1=N+1,writef("%-13 ",H),write_list(N1,T).

  write_list2([]).
  write_list2([H|T]):-write(H,' '),write_list2(T).


/*************************************************************************
  Evaluating queries - This is the mechanism which reads a query, scans
  the string and removes punctuation, parses the query and evaluates
  it.  The number of solutions are also reported here.
*************************************************************************/

DOMAINS
  % Nine types of questions are recognized by the evaluator
  QUERY	=	q_e(ENT) ;
		q_eaec(ENT,ASSOC,ENT,STRING) ;
		q_eaq(ENT,ASSOC,ENT,QUERY) ;
		q_sel(ENT,RELOP,ENT,REAL);
		q_min(ENT,QUERY);
		q_max(ENT,QUERY);
		q_not(ENT,QUERY) ;
		q_or(QUERY,QUERY) ;
		q_and(QUERY,QUERY)

PREDICATES
  write_unit(STRING)			% Write the unit for an entity
  write_solutions(INTEGER)		% Write the number of solutions

  scan(STRING,STRINGLIST)		% Convert a string to a list of words
  filter(STRINGLIST,STRINGLIST)		% Eliminate commas and periods
  pars(STRINGLIST,STRING,QUERY)
  nondeterm eval(QUERY,STRING)

  listlen(STRINGLIST,INTEGER)

  
PREDICATES
  runme(parmlist)
  plus_to_blank(string,string,string)
CLAUSES
	
  runme(Parmlist) :-
	syspath(ExeStartupPath,_ProgName),
	filenamepath(FullName1,ExeStartupPath,"GEOBASE.DBA"), 
  	consult(FullName1,data),
	filenamepath(FullName2,ExeStartupPath,"GEOBASE.LAN"), 
  	consult(FullName2,language),
    	member (parm("query",STR),ParmList),
  	plus_to_blank(STR,"",STR1),
	write("<p><b>Query:</b>",STR1,"<br>\n"),
	STR1 >< "",
 	scan(STR1,LIST),           	% Returns a list of words(symbols)
	filter(LIST,LIST1),		% Removes punctuation and words to be ignored
	pars(LIST1,E,Q),		% Parses queries
	findall(A,eval(Q,A),L),
	unik(L,L1),
	write("<p><b>Answer:</b>\n"),
	write_list(0,L1),
	write_unit(E),
	listlen(L1,N),
	write_solutions(N),!.
  runme (_) :-
  	write ("<p>Error while executing Geobase.exe\n").
  	
  plus_to_blank ("",STR,STR) :-!.
  plus_to_blank (STR,BUFF,STR1) :-
  	searchchar(STR,'+',POS),
  	P = POS-1,
  	frontstr(P,STR,FRONT,REST),
  	frontchar(REST,_,REST1),
  	concat (BUFF,FRONT,B1),
  	concat (B1," ",B2),!,
  	plus_to_blank (REST1,B2,STR1).
  plus_to_blank (STR,BUFF,STR1) :-!,
  	concat(BUFF,STR,STR1).

GOAL
        write("Content-type: text/html\n\n"),
        write("<html>\n"),
        write("<body>\n"),
	ParmList = cgi_GetParmList(),   
	runme(ParmList),
	write("</body>\n"),
	write("</html>\n").

CLAUSES
  scan(STR,[TOK|LIST]):-
		fronttoken(STR,SYMB,STR1),!,
		upper_lower(SYMB,TOK),
		scan(STR1,LIST).
  scan(_,[]).

  filter(["."|T],L):-	!,filter(T,L).
  filter([","|T],L):-	!,filter(T,L).
  filter(["?"|T],L):-	!,filter(T,L).
  filter([H|T],L):-	ignore(H),!,filter(T,L).
  filter([H|T],[H|L]):-	filter(T,L).
  filter([],[]).

  write_unit(E):-unit(E,UNIT),!,write(' ',UNIT).
  write_unit(_).

  write_solutions(0):-!,write("<p><b>No solutions</b>\n").
  write_solutions(1):-!,nl.
  write_solutions(N):-!,writef("<p><b>% Solutions</b>\n",N).

  listlen([],0).
  listlen([_|T],N):-
	listlen(T,X),
	N=X+1.

/*************************************************************************
  ENTITY NAMES
*************************************************************************/

PREDICATES
  nondeterm entn(STRING,STRING)		/* Convert an entity to singular form */
  nondeterm entity(STRING)		/* Get all entities */
  nondeterm ent_synonym(STRING,STRING)	/* Synonyms for entities */
  nondeterm ent_name(STRING,STRING)	/* Convert between an entity
				   name and an internal entity name */

CLAUSES
  ent_synonym(E,ENT):-synonym(E,ENT).
  ent_synonym(E,E).

  ent_name(ENT,NAVN):-entn(E,NAVN),ent_synonym(E,ENT),entity(ENT).

  entn(E,N):-concat(E,"s",N).
  entn(E,N):-free(E),bound(N),concat(X,"ies",N),concat(X,"y",E).
  entn(E,E).

  entity(name):-!.
  entity(continent):-!.
  entity(X):-schema(X,_,_).


/*************************************************************************
  ERROR DETECTION -
  Once the string has been converted to a list of words, the word
  list can be checked against the language database to see if it
  is a known word. Words which are not known are collected into a
  list which the system reports on.
*************************************************************************/

PREDICATES
  error(STRINGLIST)
  nondeterm known_word(STRING)

CLAUSES
  error(LIST):-	write(">> "),member(Y,LIST),not(known_word(Y)),!,
		write("Unknown word: ",Y),nl.

  error(_):-	write("Sorry, the sentence can't be recognized").

  known_word(X):-str_real(X,_),!.
  known_word("and"):-!.
  known_word("or"):-!.
  known_word("not"):-!.
  known_word("all"):-!.
  known_word("thousand"):-!.
  known_word("million"):-!.
  known_word(X):-minn(X),!.     /*  If not a special case word, check the */
  known_word(X):-maxx(X),!.     /*  dynamic database for known words      */
  known_word(X):-size(_,X),!.   /*  additional words.                     */
  known_word(X):-ignore(X),!.
  known_word(X):-unit(_,X),!.
  known_word(X):-assoc(_,AL),member(X,AL),!.
  known_word(X):-ent_name(_,X),!.
  known_word(X):-entity(X),!.
  known_word(X):-relop(L,_),member(X,L),!.
  known_word(X):-entity(E),not(unit(E,_)),ent(E,X).

/*************************************************************************
		PARSER

   PARSER SUPPORT -  Compound entities:
   This is used by the parser to handle a compound entity (e.g.
   New York).
*************************************************************************/

PREDICATES		
  nondeterm get_ent(STRINGLIST,STRINGLIST,STRING)
  nondeterm get_cmpent(STRINGLIST,STRINGLIST,STRING,STRING)
  ent_end(STRINGLIST)

CLAUSES
  get_ent([E|S],S,E):-ent_end(S),!.
  get_ent(S1,S2,ENT):-get_cmpent(S1,S2," ",E1),frontchar(E1,_,E),ENT=E.

  get_cmpent([E|S],S,IND,ENT):-ent_end(S),concat(IND,E,ENT).
  get_cmpent([E|S1],S2,IND,ENT):-
		concat(IND,E,II),concat(II," ",III),
		get_cmpent(S1,S2,III,ENT).

  ent_end([]).
  ent_end(["and"|_]).
  ent_end(["or"|_]).

/********************************************************************
  Here begins the parser. The first two parameters for the parsing
  predicates are the inputlist and what remains of the list
  after a part of a query is stripped off. In the last parameter, a
  structure for the query is built up.

  This method is called "parsing by difference lists." Once you
  understand how it works, you can easily add new sentence
  constructions to the language.
********************************************************************/

PREDICATES
  nondeterm s_rel(STRINGLIST,STRINGLIST,STRING)
  s_unit(STRINGLIST,STRINGLIST,STRING)
  s_val(STRINGLIST,STRINGLIST,REAL)

CLAUSES
  s_rel(S1,S2,REL):-relop(RLIST,REL),append(RLIST,S2,S1).

  s_unit([UNIT|S],S,UNIT).
  s_val([X,thousand|S],S,VAL):-	!,str_real(X,XX),VAL=1000*XX.
  s_val([X,million|S],S,VAL):-	!,str_real(X,XX),VAL=1000000*XX.
  s_val([X|S],S,VAL):-		str_real(X,VAL).


PREDICATES
  nondeterm s_attr(STRINGLIST,STRINGLIST,STRING,QUERY)
  nondeterm s_minmax(STRINGLIST,STRINGLIST,STRING,QUERY)
  nondeterm s_rest(STRINGLIST,STRINGLIST,STRING,QUERY)
  nondeterm s_or(STRINGLIST,STRINGLIST,STRING,QUERY)
  nondeterm s_or1(STRINGLIST,STRINGLIST,STRING,QUERY,QUERY)
  nondeterm s_and(STRINGLIST,STRINGLIST,STRING,QUERY)
  nondeterm s_and1(STRINGLIST,STRINGLIST,STRING,QUERY,QUERY)
  nondeterm s_elem(STRINGLIST,STRINGLIST,STRING,QUERY)
  nondeterm s_assoc(STRINGLIST,STRINGLIST,STRING,QUERY)
  nondeterm s_assoc1(STRINGLIST,STRINGLIST,STRING,STRING,QUERY)
  nondeterm s_nest(STRINGLIST,STRINGLIST,STRING,QUERY)
  nondeterm get_assoc(STRINGLIST,STRINGLIST,STRING)

CLAUSES
  pars(LIST,E,Q):-s_attr(LIST,OL,E,Q),OL=[],!.
  pars(LIST,_,_):-error(LIST),fail.

  % How big is the city new york -- BIG ENTITY CONSTANT
  s_attr([BIG,ENAME|S1],S2,E1,q_eaec(E1,A,E2,X)):-
		ent_name(E2,ENAME),size(E2,BIG),
		entitysize(E2,E1),schema(E1,A,E2),
		get_ent(S1,S2,X),!.

  % How big is new york -- BIG CONSTANT
  s_attr([BIG|S1],S2,E1,q_eaec(E1,A,E2,X)):-
		get_ent(S1,S2,X),
		size(E2,BIG),entitysize(E2,E1),
		schema(E1,A,E2),ent(E2,X),!.

  % How big is the biggest city -- BIG QUERY
  s_attr([BIG|S1],S2,E1,q_eaq(E1,A,E2,Q)):-
		size(_,BIG),s_minmax(S1,S2,E2,Q),
		size(E2,BIG),entitysize(E2,E1),
		schema(E1,A,E2),!.

  s_attr(S1,S2,E,Q):-s_minmax(S1,S2,E,Q).

  % The smallest city -- MIN QUERY
  s_minmax([MIN|S1],S2,E,q_min(E,Q)):-minn(MIN),!,s_rest(S1,S2,E,Q).

  % The biggest city -- MAX QUERY
  s_minmax([MAX|S1],S2,E,q_max(E,Q)):-maxx(MAX),!,s_rest(S1,S2,E,Q).

  s_minmax(S1,S2,E,Q):-s_rest(S1,S2,E,Q).

  % give me cities -- ENTITY
  s_rest([ENAME],[],E,q_e(E)):-!,ent_name(E,ENAME).

  s_rest([ENAME|S1],S2,E,Q):-ent_name(E,ENAME),s_or(S1,S2,E,Q).

  % And has a higher priority than or
  s_or(S1,S2,E,Q):-s_and(S1,S3,E,Q1),s_or1(S3,S2,E,Q1,Q).
  s_or1(["or",ENT|S1],S2,E,Q1,q_or(Q1,Q2)):-ent_name(E,ENT),!,s_or(S1,S2,E,Q2).
  s_or1(["or"|S1],S2,E,Q1,q_or(Q1,Q2)):-!,s_or(S1,S2,E,Q2).
  s_or1(S,S,_,Q,Q).

  s_and(S1,S2,E,Q):-s_elem(S1,S3,E,Q1),s_and1(S3,S2,E,Q1,Q).
  s_and1(["and",ENT|S1],S2,E,Q1,q_and(Q1,Q2)):-ent_name(E,ENT),!,s_elem(S1,S2,E,Q2).
  s_and1(["and"|S1],S2,E,Q1,q_and(Q1,Q2)):-!,s_elem(S1,S2,E,Q2).
  s_and1(S,S,_,Q,Q).

  % not QUERY
  s_elem(["not"|S1],S2,E,q_not(E,Q)):-!,s_assoc(S1,S2,E,Q).
  s_elem(S1,S2,E,Q):-s_assoc(S1,S2,E,Q).

  % ... longer than 1 thousand miles -- REL VAL UNIT
  s_assoc(S1,S4,E,q_sel(E,REL,ATTR,VAL)):-
		s_rel(S1,S2,REL),s_val(S2,S3,VAL),
		s_unit(S3,S4,UNIT),!,unit(ATTR,UNIT).

  % ... longer than 1 thousand -- REL VAL
  s_assoc(S1,S3,E,q_sel(E,REL,ATTR,VAL)):-
		s_rel(S1,S2,REL),s_val(S2,S3,VAL),!,
		entitysize(E,ATTR).

  s_assoc(S1,S3,E,Q):-
		get_assoc(S1,S2,A),s_assoc1(S2,S3,E,A,Q).

  % Before s_assoc1 is called ENT ASSOC is met

  % ... the shortest river in texas -- MIN QUERY
  s_assoc1([MIN|S1],S2,E1,A,q_eaq(E1,A,E2,q_min(E2,Q))):-minn(MIN),!,
		s_nest(S1,S2,E2,Q),schema(E1,A,E2).

  % ... the longest river in texas -- MAX QUERY
  s_assoc1([MAX|S1],S2,E1,A,q_eaq(E1,A,E2,q_max(E2,Q))):-maxx(MAX),!,
		s_nest(S1,S2,E2,Q),schema(E1,A,E2).

  % ... with a population that is smaller than 1 million citizens -- NT REL VAL UNIT
  s_assoc1([ATTR|S1],S4,E,A,q_sel(E,REL,ATTR,VAL)):-
	s_rel(S1,S2,REL),s_val(S2,S3,VAL),s_unit(S3,S4,UNIT1),!,
	ent_name(E2,ATTR),schema(E,A,E2),unit(E2,UNIT),
	UNIT=UNIT1,!.

  % ... with a population that are smaller than 1 million -- ENT REL VAL
  s_assoc1([ATTR|S1],S3,E,A,q_sel(E,REL,ATTR,VAL)):-
	s_rel(S1,S2,REL),s_val(S2,S3,VAL),!,
	ent_name(E2,ATTR),schema(E,A,E2),unit(E2,_).

  % ... that is smaller than 1 million citizens -- REL VAL UNIT
  s_assoc1(S1,S4,E,A,q_sel(E,REL,E2,VAL)):-
	s_rel(S1,S2,REL),s_val(S2,S3,VAL),s_unit(S3,S4,UNIT1),!,
	schema(E,A,E2),unit(E2,UNIT),
	UNIT=UNIT1,!.

  % ... that is smaller than 1 million -- REL VAL
  s_assoc1(S1,S3,E,A,q_sel(E,REL,E2,VAL)):-
	s_rel(S1,S2,REL),s_val(S2,S3,VAL),!,
	schema(E,A,E2),unit(E2,_).

  % ... with a population on 1 million citizens -- ENT VAL UNIT
  s_assoc1([ATTR|S1],S3,E,A,q_sel(E,eq,ATTR,VAL)):-
	s_val(S1,S2,VAL),s_unit(S2,S3,UNIT1),!,
	ent_name(E2,ATTR),schema(E,A,E2),unit(E2,UNIT2),UNIT1=UNIT2,!.

  % ... with a population on 1 million -- ENT VAL
  s_assoc1([ATTR|S1],S2,E,A,q_sel(E,eq,ATTR,VAL)):-
	s_val(S1,S2,VAL),
	ent_name(E2,ATTR),schema(E,A,E2),unit(E2,_),!.

  % .. the state new york -- ENT CONST
  s_assoc1([ENAME|S1],S2,E1,A,q_eaec(E1,A,E2,X)):-
		get_ent(S1,S2,X),ent_name(E2,ENAME),
		not(unit(E2,_)),
		schema(E1,A,E2),
		ent(E2,X),!.

  s_assoc1(S1,S2,E1,A,q_eaq(E1,A,E2,Q)):-
		s_nest(S1,S2,E2,Q),schema(E1,A,E2),!.

  % .. new york -- CONST
  s_assoc1(S1,S2,E1,A,q_eaec(E1,A,E2,X)):-
		get_ent(S1,S2,X),schema(E1,A,E2),ent(E2,X),!.

  % Parse a nested query
  s_nest([ENAME|S1],S2,E,Q):-ent_name(E,ENAME),s_elem(S1,S2,E,Q).
  s_nest([ENAME|S],S,E,q_e(E)):-ent_name(E,ENAME).

  % ... runs through texas -- ASSOC REST
  get_assoc(IL,OL,A):-append(ASL,OL,IL),assoc(A,ASL).

/*************************************************************************
  EVALUATION OF QUESTIONS
*************************************************************************/

PREDICATES
  sel_min(STRING,STRING,REAL,STRING,STRING,STRINGLIST)
  sel_max(STRING,STRING,REAL,STRING,STRING,STRINGLIST)

CLAUSES
  eval(q_min(ENT,TREE),ANS):-
		findall(X,eval(TREE,X),L),
		entitysize(ENT,ATTR),
		sel_min(ENT,ATTR,99e99,"",ANS,L).

  eval(q_max(ENT,TREE),ANS):-
		findall(X,eval(TREE,X),L),
		entitysize(ENT,ATTR),
		sel_max(ENT,ATTR,-1,"",ANS,L).

  eval(q_sel(E,gt,ATTR,VAL),ANS):-
		schema(ATTR,ASSOC,E),
		db(ATTR,ASSOC,E,SVAL2,ANS),
		str_real(SVAL2,VAL2),
		VAL2>VAL.

  eval(q_sel(E,lt,ATTR,VAL),ANS):-
		schema(ATTR,ASSOC,E),
		db(ATTR,ASSOC,E,SVAL2,ANS),
		str_real(SVAL2,VAL2),
		VAL2<VAL.

  eval(q_sel(E,eq,ATTR,VAL),ANS):-
		schema(ATTR,ASSOC,E),
		db(ATTR,ASSOC,E,SVAL,ANS),
		str_real(SVAL,VAL).

  eval(q_not(E,TREE),ANS):-
		findall(X,eval(TREE,X),L),
		ent(E,ANS),
		not(member(ANS,L)).

  eval(q_eaq(E1,A,E2,TREE),ANS):-
		eval(TREE,VAL),db(E1,A,E2,ANS,VAL).

  eval(q_eaec(E1,A,E2,C),ANS):-db(E1,A,E2,ANS,C).

  eval(q_e(E),ANS):-	ent(E,ANS).

  eval(q_or(TREE,_),ANS):- eval(TREE,ANS).

  eval(q_or(_,TREE),ANS):- eval(TREE,ANS).

  eval(q_and(T1,T2),ANS):- eval(T1,ANS1),eval(T2,ANS),ANS=ANS1.

  sel_min(_,_,_,RES,RES,[]).
  sel_min(ENT,ATTR,MIN,_,RES,[H|T]):-schema(ATTR,ASSOC,ENT),
	db(ATTR,ASSOC,ENT,VAL,H),
	str_real(VAL,HH),MIN>HH,!,
	sel_min(ENT,ATTR,HH,H,RES,T).
  sel_min(ENT,ATTR,MIN,NAME,RES,[_|T]):-sel_min(ENT,ATTR,MIN,NAME,RES,T).

  sel_max(_,_,_,RES,RES,[]).
  sel_max(ENT,ATTR,MAX,_,RES,[H|T]):-
	schema(ATTR,ASSOC,ENT),
	db(ATTR,ASSOC,ENT,VAL,H),
	str_real(VAL,HH),MAX<HH,!,
	sel_max(ENT,ATTR,HH,H,RES,T).
  sel_max(ENT,ATTR,MAX,NAME,RES,[_|T]):-sel_max(ENT,ATTR,MAX,NAME,RES,T).
