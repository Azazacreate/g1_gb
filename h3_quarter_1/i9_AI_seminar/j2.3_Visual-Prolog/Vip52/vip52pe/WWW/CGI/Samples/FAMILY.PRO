/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  FAMILY
 FileName: FAMILY.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "cgiexam.inc"

DATABASE - tmp
  son(STRING,STRING)
  sister(STRING,STRING)
  brother(STRING,STRING)
  married(STRING,STRING)

CLAUSES
  son("John", "Dan").
  sister("Mary","Suzan").
  brother("Harold", "Larry").
  married("John", "Mary").
  married("Larry", "Sue").

PREDICATES
  father(STRING father,STRING child)
  grandfather(STRING grandfather,STRING grandchild)
  sister_in_law(STRING,STRING)

CLAUSES
  father(A,B):-son(B,A).

  grandfather(A,B):-father(A,C), father(C,B).

  sister_in_law(A,B):-married(A,C), sister(C,B).
  sister_in_law(A,B):-brother(A,C), married(C,B).

PREDICATES
  runme (PARMLIST)
  show_relatives(string,string)
  show_rel_list (string,string,slist)
  nondeterm member (PARM,PARMLIST)
  
CLAUSES

  member (X,[X|_]).
  member (X,[_|Y]):-member(X,Y).
  
  runme (ParmList) :-
  	member (parm("Relationship",Rel),ParmList),
  	member (parm("name",Name),ParmList),!,
  	show_relatives (Rel,Name).
  	
  show_relatives ("sister",Name) :-
  	findall(Name_1,sister(Name,Name_1),Namelist),
  	show_rel_list ("sister",Name,Namelist).
  show_relatives ("brother",Name) :-
  	findall(Name_1,brother(Name,Name_1),Namelist),
  	show_rel_list ("brother",Name,Namelist).
  show_relatives ("father",Name) :-
  	findall(Name_1,father(Name,Name_1),Namelist),
  	show_rel_list ("father",Name,Namelist).
  show_relatives ("grandfather",Name) :-
  	findall(Name_1,grandfather(Name,Name_1),Namelist),
  	show_rel_list ("grandfather",Name,Namelist).
  show_relatives ("son",Name) :-
  	findall(Name_1,son(Name,Name_1),Namelist),
  	show_rel_list ("sons",Name,Namelist).
  show_relatives ("sister_in_law",Name) :-
  	findall(Name_1,sister_in_law(Name,Name_1),Namelist),
  	show_rel_list ("sister in law",Name,Namelist).

  show_rel_list (Rel,Name,[]) :-!,
  	write ("<p>Sorry, I know nothing about ",Rel," of ",Name,".\n"). 
  show_rel_list (Rel,Name,[NameList]) :-
  	frontchar(Rel,C,R),
  	upper_lower(UC,C),
  	write ("<p>",UC,R," of ",Name," is ",NameList,".\n").
  show_rel_list (Rel,Name,NameList) :-
  	frontchar(Rel,C,R),
  	upper_lower(UC,C),
  	write ("<p>",UC,R,"s of ",Name," are ",NameList,".\n").
  	
GOAL 
        write("Content-type: text/html\n\n"),
        write("<html>\n"),
        write("<body>\n"),
	ParmList = cgi_GetParmList(),   
	runme(ParmList),
	write("</body>\n"),
	write("</html>\n").
