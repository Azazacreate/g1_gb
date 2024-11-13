/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  WEBAGENT
 FileName: URI_PROC.PRO
 Purpose: Example of HTTP Layer
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/

include "webagent.inc"
include "webagent.con"
include "hlptopic.con"

PREDICATES
  parse_hostport(STRING,STRING,USHORT) - (i,o,o)
  parse_server_path(STRING,STRING,USHORT,STRING) - (i,o,o,o)
  parse_sep(STRING,CHAR,SLIST) - (i,i,o)
  parse_uri_pos(STRING,STRING,STRING,STRING,USHORT,STRING) - (i,i,o,o,o,o)  
  test_host(STRING) - (i)
  
CLAUSES
  
% parse uri into sheme, host, port, path
  parse_uri(In,Sheme,Host,Port,Path):-
	upper_lower(In,In_lower),
  	parse_uri_pos(In,In_lower,Sheme,Host,Port,Path),!,
  	test_host(Host).
  
% searches port number in hostport : spb_nt_server:80
  parse_hostport(In,In,80):-
  	not(searchchar(In,':',_)),!.
  parse_hostport(In,Host,Port):-
	searchchar(In,':',FoundPos),
	FP = FoundPos - 1,
	frontstr(FP,In,Host,RestString),
	frontchar(RestString,':',Port_str),
	term_str(USHORT,Port,Port_str),!.
  parse_hostport(_,"",80).

% seaches sheme http	
  parse_uri_pos(In,In_l,Sheme,Host,Port,Path):-
	frontstr(7,In_l,Start,_), %7 - length of "http://"
	Start = "http://",
	frontstr(4,In,Sheme,_),
	frontstr(7,In,_,Rest),!,
	parse_server_path(Rest,Host,Port,Path).
  parse_uri_pos(In,In_l,"http",Host,Port,Path):-
  	frontstr(2,In_l,Start,_), 
	Start = "//",
	frontstr(2,In,_,Rest),!,
	parse_server_path(Rest,Host,Port,Path).
  parse_uri_pos(In,In_l,"http",Host,Port,Path):-
	searchstring(In_l,"//",FoundPos),
	FP = FoundPos + 1,
	frontstr(FP,In,_,RestString),!,
	parse_server_path(RestString,Host,Port,Path).
  parse_uri_pos(In,_,"http",Host,Port,Path):-!,
	parse_server_path(In,Host,Port,Path).

% divides to path and hostport
  parse_server_path(In,"",80,In):-
	searchchar(In,'/',FoundPos),
	FoundPos = 1,!.
  parse_server_path(In,Host,Port,Path):-
  	searchchar(In,'/',FoundPos),
  	FoundPos <> 1,!,
  	FP = FoundPos - 1,
	frontstr(FP,In,HostPort,Path),
	parse_hostport(HostPort,Host,Port),
	!.
  parse_server_path(In,Host,Port,"/"):-!, % no slash
  	parse_hostport(In,Host,Port).

  test_host(""):-!,fail.
  test_host(_).

% parse path into path, parameters, query
  parse_path(In,Rel_path,Params,Query):-
	searchchar(In,'?',FoundPos),
	FP = FoundPos - 1,
	frontstr(FP,In,Rel_par,Query1),
	frontchar(Query1,_,Query),
  	parse_sep(Rel_par,';',Lst),
  	Lst = [Rel_path|Params],!.
  parse_path(In,Rel_path,Params,""):-
  	parse_sep(In,';',Lst),
  	Lst = [Rel_path|Params],!.
	
  parse_sep("",_,[]):-!.
  parse_sep(In,Sep,L1):-
  	frontchar(In,Sep,Rest),!,
  	parse_sep(Rest,Sep,L1).
  parse_sep(In,Sep,[El|L1]):-
  	searchchar(In,Sep,FoundPos),!,
  	FP = FoundPos - 1,
  	frontstr(FP,In,Ell,RestString),
  	wa_strip_leading_spaces(Ell,El),!,
  	parse_sep(Reststring,Sep,L1).
  parse_sep(In,Sep,[In]):-
	not(searchchar(In,Sep,_)),!.
	
  wa_strip_leading_spaces(STR,STR2):-
        frontchar(STR,' ',St1),!,
        wa_strip_leading_spaces(St1,STR2).
  wa_strip_leading_spaces(STR,STR).
	