/*****************************************************************************

                Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  CGITEST
 FileName: CGITEST.PRO
 Purpose: The CGI Interface testing
 Written by: Serge Verkhovtsev
 Comments:
   You can use GET or POST interface methods
   Look at cgitest.htm for calling form.
   For NT and Windows 95 the program should be built for Win32 Console Mode.
******************************************************************************/

constants
/*
   The value of the following constant defines our action when
  the user will forget to  fill out the "Name" field of the main HTML-form
*/
%       anonymous_enabled       =    1
        anonymous_enabled       =    0


GLOBAL PREDICATES
 memcpy(binary,string,integer) - (i,i,i) language c as "_MEM_MovMem"


/*=============================================================================
                        start_page
        Starts formatting Web page to be displayed when this program is done.
=============================================================================*/
PREDICATES
  start_page

CLAUSES
  start_page :-
        % The Content-Type specifies what type of data the browser should expect.
        % This Content-Type must be compatible MIME type, followed by a blank line.
        write("Content-type: text/html\n\n"),

        % Starts the HTML code for the results page.
        write("<HTML>\n"),
        write("<HEAD>\n"),
        write("<TITLE>\n"),
        write("The CGI Interface Testing\n"),
        write("</TITLE>\n"),
        write("</HEAD>\n"),
        write("<BODY>\n"),
        write("<BR>\n"),
        write("<FONT SIZE=+2 COLOR=400080><I><B>The </FONT>\n"),
        write("<FONT SIZE=+4 COLOR=000080>CGI Interface Testing</I></B></FONT><BR>\n"),
        write("<H1><FONT COLOR=0000A0>Submit Result</FONT></H1><BR>\n"),
        write("<HR>\n").


/*=============================================================================
                        end_page
        Finishes up the HTML document for the results page.
=============================================================================*/
PREDICATES
  end_page

CLAUSES
  end_page :-
        write("</BODY>\n"),
        write("</HTML>\n").


/*=============================================================================
                        client_info
      Tries to retrieve and show some client information
=============================================================================*/
PREDICATES
  client_info

CLAUSES
  client_info :-
        envsymbol("REMOTE_ADDR",AddrStr),
        writef("Your IP Address : <B>%s</B><BR>\n",AddrStr),
        envsymbol("REMOTE_HOST",HostStr),!,
                writef("Your Hostname : <B>%s</B><BR>\n",HostStr).
  client_info :-
        write("Server has no information about your Hostname<BR>\n").


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
        str_int(LenStr,Len),
        trap(readblock(Len,PasteBlock),_,true),
          convert_to_string(Len,PasteBlock,CGI_String).


  /* Creates the string with given length from given binary */
  convert_to_string(Len,Bin,Str) :-
        str_len(Str,Len),
        memcpy(Bin,Str,Len).


/*=============================================================================
                        retrieve_GET_string(CGI_String)
      Retrieves the query string sent by the server with "GET" request method .
=============================================================================*/
PREDICATES
  retrieve_GET_string( string )

CLAUSES
  /*
        If request is made with "GET" method the data is placed
     in the "QUERY_STRING" environment variable
  */
  retrieve_GET_string( CGI_String ) :-
        envsymbol("QUERY_STRING",CGI_String),!.


/*=============================================================================
                        get_CGI_string(CGI_String)
      Retrieves the query string sent by the server .
=============================================================================*/
PREDICATES
  get_CGI_string( string )

  get_CGI_string_by_method(string,string)

CLAUSES
  get_CGI_string( CGI_String ) :-
        % Detecting submit method  ("GET" or "POST")
        envsymbol("REQUEST_METHOD",Method),
        % Getting the string
        get_CGI_string_by_method(Method,CGI_String),
        writef("Server Request Method : <B>%s</B><BR>\n",Method),
        writef("Server Query String : <B>%s</B><BR>\n",CGI_String).


  get_CGI_string_by_method("POST",CGI_String) :-!,
        retrieve_POST_string(CGI_String).
  get_CGI_string_by_method("GET",CGI_String) :-!,
        retrieve_GET_string(CGI_String).


/*=============================================================================
                        decode_CGI_value(EncodedString,DecodedString)
        Decodes URL-encoded CGI string value
=============================================================================*/
PREDICATES
  decode_CGI_value( string, string )

  decode_CGI_symbol(string,char,string)
  decode_CGI_symbol(char,string,char,string)
  char_hex(char,integer)

CLAUSES

  decode_CGI_value("",""):-!.
  decode_CGI_value(EncodedString,DecodedString) :-
        decode_CGI_symbol(EncodedString,FrontSymb,EncodedTail),
        decode_CGI_value(EncodedTail,DecodedTail),
        frontchar(DecodedString,FrontSymb,DecodedTail).

  % Retrieves the first decoded symbol from the CGI string
  decode_CGI_symbol(Str,Symb,RestStr) :-
        frontchar(Str,C0,Rest0),
        decode_CGI_symbol(C0,Rest0,Symb,RestStr).

  decode_CGI_symbol('+',Rest,' ',Rest):-!.
  decode_CGI_symbol('%',Rest0,Symb,Rest) :-!,
        frontchar(Rest0,C0,Rest1),
        frontchar(Rest1,C1,Rest),
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



/*=============================================================================
                        cgi_value(CGI_String,Name,Value)
        Scans the CGI string for the value of named parameter .
        Failes if parameter doesn't exist or the string has invalid format
=============================================================================*/
PREDICATES
  cgi_value(string,string,string)

  find_value_end(string,string)

CLAUSES
  cgi_value( CGI_String, Name, Value ) :-
        concat(Name,"=",ScanFor),
        searchstring(CGI_String,ScanFor,NamePos),
        str_len(ScanFor,Len),
        ValPos = NamePos + Len - 1 ,
        frontstr(ValPos,CGI_String,_,ValueString),
        find_value_end(ValueString,DecodedValue),
        decode_cgi_value(DecodedValue,Value).

  % Looks for the end of the current parameter value
  find_value_end(ValueString,Value) :-
        searchchar(ValueString,'&',ValEndPos),
        ValLen = ValEndPos-1,
        frontstr(ValLen,ValueString,Value,_),
        !.
  find_value_end(Value,Value).


/*=============================================================================
    get_name_and_language(CGI_String,Name,Lang,RetCode)
  Retrieves the value of two parameters : "NAME" and "LANGUAGE"
  Checks the "NAME" value to be filled out if anonymous_enabled == 0
=============================================================================*/
PREDICATES
  get_name_and_language(string,string,string,integer)

  check_anonymous(string,string)

CLAUSES
  get_name_and_language(CGI_String,Name,Lang,1) :-
        cgi_value(CGI_String,"NAME",Name0),
        check_anonymous(Name0,Name),
        cgi_value(CGI_String,"LANGUAGE",Lang),
        !.
  get_name_and_language(_,"","",0).


  check_anonymous("","Anonymous Person") :-
        1 = anonymous_enabled ,!.
  check_anonymous(Name,Name) :-
        Name <> "".


/*=============================================================================
    name_language_report(Flag,Name,Lang)
    Shows the results of retreiving Form values.
=============================================================================*/
PREDICATES
  name_language_report(integer,string,string)

CLAUSES

  name_language_report(1,Name,Lang) :-!,
        write("<B>Thank You!</B><BR>\n"),
        write("You have just <I>successfully</I> filled out the form! \n"),
        writef("Now we know that the favourite language of <B>%s</B> is <B>%s</B><BR>\n",
               Name,Lang).
  name_language_report(0,_,_) :-
        write("<B>WHOOPS!</B><BR>\n"),
        write("You forgot to fill out your name.  Please check it and resubmit.<P>\n").



/*=============================================================================
                        form_process
  Does all job with Server Query .
=============================================================================*/
PREDICATES
  form_process

CLAUSES

  form_process :-
                  get_CGI_string(CGI_String),
                  get_name_and_language(CGI_String,Name,Lang,RetCode),
                  name_language_report(RetCode,Name,Lang),
                !.
  form_process.



/******************************************************************************
                        GOAL
******************************************************************************/
GOAL
        start_page,
        client_info,
        form_process,
        end_page.

