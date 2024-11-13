/*****************************************************************************
 
  Copyright (c) 1984 - 2000 Prolog Development Center A/S
 
 Project:  ROUTE
 FileName: ROUTE.PRO
 Purpose: A simple demo about recursion
 
******************************************************************************/
 
domains
  town     = symbol
  townlist = town*
  distance = integer
 
/******************************************************************************
 A database of the roads
******************************************************************************/
predicates
  nondeterm road(town,town,distance)
clauses
  road("houston","gordon",100).
  road("houston","kansas_city",120).
  road("tampa","kansas_city",80).
 
/******************************************************************************
 Note that if there is a road from TOwn1 to Town2, then you can
 also come from Town2 to Town1
******************************************************************************/
predicates
  nondeterm connected(town,town,distance)
clauses
  connected(X,Y,Dist):-
    road(X,Y,Dist).
  connected(X,Y,Dist):-
    road(Y,X,Dist).
 
/******************************************************************************
 The traditional member predicate. Will succed if the element exists in
 the list, otherwise fail.
******************************************************************************/
predicates
  determ member(town,townlist)
clauses
  member(X,[X|_]):-!.
  member(X,[_|L]):-
    member(X,L).
 
/******************************************************************************
 There is a route from Town1 to Town2 if they are directly connectted
 by a road. Otherwise pick an arbitrary town X which is connected with
	 Town1 and see whether you can come from X to Town2 - and check that
 X is not part of the towns we have already visited ! (Otherwise the
 recursion will run into an endless loop !
******************************************************************************/
predicates
  nondeterm route(town,town,townList,townList,distance)
clauses
  route(Town,Town,VisitedTowns, VisitedTowns, 0) :-
    !.
  route(Town1,Town2,VisitedTowns,ResultVisitedTowns,Distance):-
    connected(Town1,X,Dist1),
    not(member(X,VisitedTowns)),
    route(X,Town2,[X|VisitedTowns],ResultVisitedTowns,Dist2),
    Distance=Dist1+Dist2.

/******************************************************************************
 Backtrack all solutions to see the possible routes.
******************************************************************************/
predicates
  procedure showAllRoutes(town,town)-(i,i)
  procedure write_rote(town FirstTown,townList,distance)
  procedure reverse_list(townList InList, townList Tmp, townList Reversed)

clauses
  showAllRoutes(Town1,Town2):-
    write("All routes from ",Town1," to ",Town2," are:\n"),
    route(Town1,Town2, [Town1] ,VisitedTowns, Dist),
    write_rote(Town1,VisitedTowns,Dist),nl,
    fail.
  showAllRoutes(_,_).

  write_rote(Town1,[Town1|VisitedTowns],Dist):-
    !,
    Towns = [Town1|VisitedTowns],
    write("  ",Towns," --> ",Dist),nl.
  write_rote(_,VisitedTowns,Dist):-
    reverse_list(VisitedTowns, [], VisitedTowns_Reversed),
    write("  ",VisitedTowns_Reversed," --> ",Dist),nl.

  reverse_List([],LIST,LIST):-!.
  reverse_List([H|SeenListRest],Interm,SeenList):-
	reverse_List(SeenListRest,[H|Interm],SeenList).
    
 
/******************************************************************************
 Display the shortest Routes
******************************************************************************/
predicates
  procedure showShortestRoutes(town,town)-(i,i)
  determ shorterRouteExist(town,town,distance)-(i,i,i)
 
clauses
  showShortestRoutes(Town1,Town2):-
    write("Shortest routes between ",Town1," to ",Town2," is:\n"),
    route(Town1,Town2, [Town1] ,VisitedTowns, Dist),
    not(shorterRouteExist(Town1,Town2,Dist)),
    write_rote(Town1,VisitedTowns,Dist),nl,
    fail.
  showShortestRoutes(_,_).
 
  shorterRouteExist(Town1,Town2,Dist):-
    route(Town1,Town2, [Town1] ,_, Dist1),
    Dist1<Dist,!.
 
/******************************************************************************
 Starting the program
******************************************************************************/
goal
  showAllRoutes("gordon", "tampa"),nl,
  showShortestRoutes("gordon", "tampa").
