/******************************************************
	Example of a compiled Rulebase

  In many applications like planning and scheduling, it
  is an advantage to let the user be able to type in rules
  for validating, priority etc.

  The main program calls in to some static predicates,
  which then ex. check that an allocation are valid,
  return the priority of a Job etc. The Entry points are
  fixed, but the Rules can be as advanced as needed.
  
  In Visual Prolog, the rules can be handled in many ways,
  either by a special purpose rule interpreter, or maybe by
  including PIE (The Prolog Inference Engine) in the application.
  
  This example illustrate a very powerfull way to compile
  the rules to native machine code by including the PDC
  Prolog Compiler into the application, and handling the rulebase
  into a .DLL which dynamically can be changed.
  
  Note: In the Current version there is no PROLOG.DLL, this
  means that the .DLL and the main program will each have their
  own GSTACK and Backtrack chain. For this reason it is very
  important to surround calls to the .DLL by MarkGstack and
  ReleaseGstack calls to free the memory after the Call. And
  it is also important that the exported predicate in the .DLL
  are sorrounded by a wrapped as shown in the example, so a fail
  or an exit will be catched by the wrapper.

  This example is of cause fully artificial. The intention here
  could maybe to point out which cars to look closer into from a big
  database of car advertisements.

******************************************************/

% Declarations needed to create the dll_MarkGStack and dll_ReleaseGStack preds
include "..\\..\\..\\..\\INCLUDE\\TYPES.DOM"
include "..\\..\\..\\..\\INCLUDE\\PDCRUNT.DOM"
include "..\\..\\..\\..\\INCLUDE\\PDCRUNT.PRE"

GLOBAL PREDICATES
  
  % Entry predicate to Call; here to find an interesting car !
  procedure check_car(STRING carName, INTEGER ageLimit, ULONG priceLimit, ULONG milesLimit,INTEGER Result)
      - (i,i,i,i,o) language pascal

  % Predicates to free memory after returning from the .DLL
  dll_MarkGStack(ULONG) - (o) language pascal
  dll_ReleaseGStack(ULONG) - (i) language pascal


/*************************************************************
  Predicates so the Main Program can release memory in the .DLL
*************************************************************/
CLAUSES
  dll_MarkGStack(GTOP):-GTOP = mem_MarkGstack().
  dll_ReleaseGStack(GTOP):-mem_ReleaseGstack(GTOP).


/******************************************************
  Local Predicates To check wether Car is interesting
  Success means Yes, Failure means No
******************************************************/
PREDICATES
  determ interesting_car(STRING carName,INTEGER age,ULONG price, ULONG miles)

CLAUSES
  % The Main entry predicate
  check_car(CarName, Year, Price, Miles, 1 ):-
	trap(interesting_car(CarName, Year, Price, Miles),_E,fail),!.
  check_car(_CarName, _Year, _Price, _Miles, 0 ). % Fail Means not interesting


  % I like Porche's, any Porche is interesting
  interesting_car("Porche", _Year, _Price, _Miles):-!.

  % I prefer a new car; and if there is a Cheap one, I want to
  % take a closer look
  interesting_car(_, Year, Price, Miles):-
		Year >1995 and Miles <5000 and Price< 5000, !.

  % If I should have a Volvo; It should be a good bargain
  interesting_car("Volvo", Year, Price, Miles):-
		Year >1990 and Price< 10000 and Miles < 10000, !.


% Just a Dummy Goal in the .DLL
GOAL true.
