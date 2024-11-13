/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_190_3.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
	The flatten program for complex lists is an
	advanced technique.

	Complex lists are handled by the following domain
	declarations. A list must have a functor as shown
	and then must be declared recursively.
******************************************************************************/

domains
  element = l(list) ; s(symbol) ; i(integer) ; c(char) ; t(string) ; r(real)
  list = element*

predicates
  append(list,list,list) - procedure (i,i,o)
  flatten_list(list) - procedure (i)
  flatten(list,list) - nondeterm (i,o)
  run - determ ()

/*

  The trick is to write the list first, then add the functors:
    flatten_list( [ [ a ] , [ ] , [ [ [ b ] , c ] ] , [ d , e ] , f ]).

  Adding the functors gives the following PDC Prolog list:
   flatten_list([l([l([s(a)]) ,
                l([]) ,
                l([l([l([s(b)]),s(c)])]) ,
                l([s(d),s(e)]) ,
                s(f)])]).

*/
clauses
  flatten_list(List):-
	flatten(List,Flat_List),
	nl,
	write("The list flattened is:"),
	nl,
	nl,
	write(Flat_List,"\n\n"),
	fail
	;
	true.

  flatten([],[]).                  /* terminating clause */

  flatten([l(X)|X1],Y):-       /* if the head of the list is a list */
	flatten(X,Y1),           /* flatten the head of the list      */
	flatten(X1,Y2),          /* then flatten the tail             */
	append(Y1,Y2,Y).        /* append the flat head to the tail  */

  flatten([X|X1],[X|Y]):-         /* if the head is not a list, move   */
	not(X=l(_)),
	flatten(X1,Y).           /* it to the tail; flatten the tail  */

  append([],L,L).
  append([X|L1],L2,[X|L3]):-
	append(L1,L2,L3).
  
  run:-
	write("********************* Flatten **************************"),
	nl,
	List_to_flatten =[l([l([s(a)]),
			  l([]),
			  l([l([l([t("b")]),c('c')])]),
			  l([i(4),r(5.0001)]),s(f)])],
	write("Flatten the list:\n\n"),
	write(List_to_flatten),
	flatten_list( List_to_flatten ),
	nl,
	nl,
	write("Press any key..."),
	readchar(_).
	
GOAL
  run.