/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  GENI
 FileName: CGITOOLS.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "geni.inc"
include "cgitools.pre"
include "pdcrunt.pre"


/*=============================================================================
                        retrieve_POST_string(CGI_String)
      Retrieves the query string sent by the server with "POST" request method .
=============================================================================*/
PREDICATES
  retrieve_POST_string( string )

  convert_to_string(integer,binary,string)

CLAUSES
  /*
        If request is made with "POST" method we are to read the data
     from standard input.
        The data size we need to read from standard input
    is located by WEB-server in ENV variable "CONTENT_LENGTH"
  */
  retrieve_POST_string(CGI_String) :-
        envsymbol("CONTENT_LENGTH",LenStr),
        str_int(LenStr,Len),!,
        readblock(Len,PasteBlock),
	convert_to_string(Len,PasteBlock,CGI_String).
  retrieve_POST_string("") :-
	errorexit().

  /* Creates the string with given length from given binary */
  convert_to_string(Len,Bin,Str) :-
        str_len(Str,Len),
        Src=cast(ULONG,Bin),
        Dst=cast(ULONG,Str),
        movmem(Src,Dst,Len).


/*=============================================================================
                        retrieve_GET_string(CGI_String)
      Retrieves the query string sent by the server with "GET" request method .
=============================================================================*/
PREDICATES
  retrieve_GET_string( string )

CLAUSES
 % If request is made with "GET" method the data is placed
 % in the "QUERY_STRING" environment variable
  retrieve_GET_string( CGI_String ) :-
        envsymbol("QUERY_STRING",CGI_String),!.
  retrieve_GET_string( "" ) :-
	errorexit().

/*=============================================================================
                        get_CGI_string(CGI_String)
      Retrieves the query string sent by the server .
=============================================================================*/
PREDICATES
  get_CGI_string_by_method(string,string)

CLAUSES
  cgi_GetString( CGI_String ) :-
        envsymbol("REQUEST_METHOD",Method),!,
        get_CGI_string_by_method(Method,CGI_String).
  cgi_GetString("") :-
	errorexit().

  get_CGI_string_by_method("POST",CGI_String) :-!,
        retrieve_POST_string(CGI_String).
  get_CGI_string_by_method("GET",CGI_String) :-!,
        retrieve_GET_string(CGI_String).
  get_CGI_string_by_method(_,"") :-
	errorexit().

/*=============================================================================
                        decode_CGI_value(EncodedString,DecodedString)
        Decodes URL-encoded CGI string value
=============================================================================*/
PREDICATES
  %decode_CGI_value( string, string )
  decode_CGI_symbol(string,char,string)
  decode_CGI_symbol(char,string,char,string)
  char_hex(char,integer)

CLAUSES
  cgi_DecodeValue("",""):-!.
  cgi_DecodeValue(EncodedString,DecodedString) :-
        decode_CGI_symbol(EncodedString,FrontSymb,EncodedTail),
        DecodedTail = cgi_DecodeValue(EncodedTail),
        frontchar(DecodedString,FrontSymb,DecodedTail).

  % Retrieves the first decoded symbol from the CGI string
  decode_CGI_symbol(Str,Symb,RestStr) :-
        frontchar(Str,C0,Rest0),
        decode_CGI_symbol(C0,Rest0,Symb,RestStr).

  decode_CGI_symbol('+',Rest,' ',Rest):-!.
  decode_CGI_symbol('%',Rest0,Symb,Rest) :-
        frontchar(Rest0,C0,Rest1),
        frontchar(Rest1,C1,Rest),!,
        char_hex(C0,HighQu),
        char_hex(C1,LowQu),
        AsciiCode = HighQu*16 + LowQu,
        char_int(Symb,AsciiCode).
  decode_cgi_symbol(Symb,Str,Symb,Str).

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
  char_hex(_,0) :-
	errorexit().


/*=============================================================================
                        cgi_value(CGI_String,Name,Value)
        Scans the CGI string for the value of named parameter .
        Failes if parameter doesn't exist or the string has invalid format
=============================================================================*/
PREDICATES
  find_value_end(string,string)

CLAUSES
  cgi_TryGetvalue( CGI_String, Name, Value ) :-
        concat(Name,"=",ScanFor),
        searchstring(CGI_String,ScanFor,NamePos),
        str_len(ScanFor,Len),
        ValPos = NamePos + Len - 1 ,
        frontstr(ValPos,CGI_String,_,ValueString),
        find_value_end(ValueString,DecodedValue),
        Value = cgi_DecodeValue(DecodedValue).

  % Looks for the end of the current parameter value
  find_value_end(ValueString,Value) :-
        searchchar(ValueString,'&',ValEndPos),
        ValLen = ValEndPos-1,
        frontstr(ValLen,ValueString,Value,_),
        !.
  find_value_end(Value,Value).


/*=============================================================================
	str_namelist
=============================================================================*/
PREDICATES
  PARM getparm(STRING Str,STRING RestStr)
  str_parm(STRING Str,PARM)

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
	frontstr(Len,Str,Name,RestStr0),
	frontchar(RestStr0,_,Val),!. % Ignore the '='
  str_parm(_,parm("","")):-errorexit.
	



