/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName: CGITOOLS.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/


/******************************************************
	String -> List by a separator
 Ex. str2list("aa,bb,cc",',',List)
******************************************************/

PREDICATES
  procedure str2list(STRING,CHAR Seperator,SLIST)

CLAUSES
  str2list(Str,Seperator,[First|RestList]):-
	searchchar(Str,Seperator,Pos),
	Len = Pos-1,
	frontstr(Len,Str,First,RestStr0),
	frontchar(RestStr0,_,RestStr),!,
	str2list(RestStr,Seperator,RestList).
  str2list(Str,_,[Str]).

/*=============================================================================
                        decode_CGI_value(EncodedString,DecodedString)
        Decodes URL-encoded CGI string value
=============================================================================*/
PREDICATES
  procedure cgi_DecodeString(STRING EncodedString,STRING DecodedString)
  procedure cgi_DecodeString1(STRING EncodedString,STRING DecodedString)
  procedure decodelist(SLIST EncodedList,SLIST DecodedList)
  procedure char_hex(char,integer)

CLAUSES
  cgi_DecodeString(EncodedString,DecodedString):-
	str2list(EncodedString,'+',SLIST),
	list_to_string(SLIST," ",StringWithPlusConverted),
	cgi_DecodeString1(StringWithPlusConverted,DecodedString).

  cgi_DecodeString1("",""):-!.
  cgi_DecodeString1(EncodedString,DecodedString):-
	str2list(EncodedString,'%',SLIST),
	SLIST = [H|T],!,
	decodelist(T,DecodedList),
	list_to_string([H|DecodedList],"",DecodedString).
  cgi_DecodeString1(_,_):-errorexit.

  decodelist([],[]):-!.
  decodelist([H|T],[DecodedH|DecodedT]):-
        frontchar(H,C0,Rest1),
        frontchar(Rest1,C1,Rest),!,
        char_hex(C0,HighQu),
        char_hex(C1,LowQu),
        AsciiCode = HighQu*16 + LowQu,
        char_int(Symb,AsciiCode),
        frontchar(DecodedH,Symb,Rest),
	decodelist(T,DecodedT).
  decodelist(_,_):-errorexit.

  % Primitive char_to_hex convertion
  char_hex(C,HV) :-
	'0' <= C , C <= '9' ,!,
	HV = C - '0' .
  char_hex(C,HV) :-
	'A' <= C , C <= 'F' ,!,
	HV = C - 'A' + 10.
  char_hex(C,HV) :-
	'a' <= C , C <= 'f' ,!,
	HV = C - 'a' + 10.
  char_hex(_,_) :-
	errorexit().


/*=============================================================================
	str_namelist
=============================================================================*/

PREDICATES
  procedure str_namelist(STRING STR,PARMLIST)-(i,o)
  procedure PARM getparm(STRING Str,STRING RestStr)-(i,o)
  procedure str_parm(STRING Str,PARM)-(i,o)

CLAUSES
  str_namelist("",[]):-!.
  str_namelist(STR,[PARM|RestList]):-
	PARM = getparm(STR,RestStr),
	str_namelist(RestStr,RestList).

  getparm(Str,RestStr,Parm):-
	searchchar(Str,'&',Pos),
	Len = Pos-1,
	frontstr(Len,Str,ParmStr,RestStr0),
	frontchar(RestStr0,_,RestStr),!, % Ignore the '&'
	str_parm(ParmStr,Parm).
  getparm(Str,"",Parm):-!,
	str_parm(Str,Parm).
  getparm(_,_,_):-errorexit.

  str_parm(Str,parm(Name,Val)):-
	searchchar(Str,'=',Pos),
	Len = Pos-1,
	frontstr(Len,Str,EncodedName,RestStr0),
	frontchar(RestStr0,_,EncodedVal),!, % Ignore the '='
	cgi_DecodeString(EncodedName,Name),
	cgi_DecodeString(EncodedVal,Val).
  str_parm(_,_):-errorexit.
	
/*=============================================================================
 Retrieves the query string sent by the server with "POST" request method .
    If request is made with "POST" method we are to read the data from standard input.
    The data size we need to read from standard input
    is located by WEB-server in ENV variable "CONTENT_LENGTH"
=============================================================================*/
PREDICATES
  retrieve_POST_string(STRING)-(o)
  convert_to_string(INTEGER,BINARY,STRING)-(i,i,o)

CLAUSES
  retrieve_POST_string(CGI_String) :-
        envsymbol("CONTENT_LENGTH",LenStr),
        str_int(LenStr,Len),!,
        readblock(Len,PasteBlock),
	convert_to_string(Len,PasteBlock,CGI_String).
  retrieve_POST_string(_) :-
	errorexit().

  % Creates the string with given length from given binary
  convert_to_string(Len,Bin,Str) :-
        str_len(Str,Len),
        Src=cast(ULONG,Bin),
        Dst=cast(ULONG,Str),
        movmem(Src,Dst,Len).


/*=============================================================================
      Retrieves the query string sent by the server with "GET" request method .
 If request is made with "GET" method the data is placed
 in the "QUERY_STRING" environment variable
=============================================================================*/
PREDICATES
  retrieve_GET_string( string )

CLAUSES
  retrieve_GET_string( CGI_String ) :-
        envsymbol("QUERY_STRING",CGI_String),!.
  retrieve_GET_string("").


/*=============================================================================
                        get_CGI_string(CGI_String)
      Retrieves the query string sent by the server .
=============================================================================*/
PREDICATES
  procedure get_CGI_string_by_method(STRING method,STRING cgiString)

CLAUSES
  get_CGI_string_by_method("POST",CGI_String) :-
        retrieve_POST_string(CGI_String),!.
  get_CGI_string_by_method("GET",CGI_String) :-
        retrieve_GET_string(CGI_String),!.
  get_CGI_string_by_method(_,_) :- 
	errorexit().

  cgi_GetString( CGI_String ) :-
        envsymbol("REQUEST_METHOD",Method),!,
        get_CGI_string_by_method(Method,CGI_String).
  cgi_GetString("").


  cgi_GetParmList( ParmList ) :-
	CGI_String = cgi_GetString(),
	str_namelist(CGI_String,ParmList).

/*=============================================================================
	Return HTML from the <BODY> Section in a file
=============================================================================*/

  gethtmlfromfile(FileName,BODY):-
	syspath(ExeStartupPath,_ProgName),
	filenamepath(FullName,ExeStartupPath,FileName),
	file_str(FullName,TEXT),
  	upper_lower(TEXT,LOWERTEXT),
	searchstring(LOWERTEXT,"<body",LEN1),
	frontstr(LEN1,LOWERTEXT,_,TXT1),
	searchchar(TXT1,'>',BODY_TAG_LEN),
	STARTPOS = LEN1+BODY_TAG_LEN+1,
	searchstring(LOWERTEXT,"</body>",ENDPOS),!,
	LEN = ENDPOS-STARTPOS,
	substring(TEXT,STARTPOS,LEN,BODY).
  gethtmlfromfile(_,_):-
	errorexit.


/*=============================================================================
	Lookup parameter in a parameterlist; if not found return default value
=============================================================================*/

  lookupParm(_,[],Default,Default).
  lookupParm(ParmName,[parm(ParmName,Value)|_],_,Value):-!.
  lookupParm(ParmName,[_|List],Default,Value):-
	lookupParm(ParmName,List,Default,Value).


/*=============================================================================
	Remove empty parameter values
=============================================================================*/

  remove_empty_params([],[]).
  remove_empty_params([parm(_,"")|Rest],Filtered):-!,
	remove_empty_params(Rest,Filtered).
  remove_empty_params([H|Rest],[H|Filtered]):-
	remove_empty_params(Rest,Filtered).
