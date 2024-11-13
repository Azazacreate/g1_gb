/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  ---
 FileName: ===
 Purpose: A file for HTTP layer
 Written by: Konstantin Ivanov
 Comments: Include it in your project!
******************************************************************************/

DOMAINS
  CLIST = CHAR*
  httplay_handler = httplay_win(WINDOW,UNSIGNED Message)
CONSTANTS
  http_socket 	= 0xC500
  int_ok 	= 0
  int_err 	= 1

DATABASE - httplay_internal
  determ http_window(WINDOW)
  
  httplay_msglay_answer(SOCKET,msglay_event)
  httplay_answer(HTTPLAY_ANSWERS)
  httplay_last_error(UNSIGNED)
  
  db_responses(UNSIGNED,HTTPLAY_RESPONSE,httplay_handler)
  db_temp(SOCKET,httplay_handler,HTTPLAY_REQUEST)
  nocopy db_temp_data( SOCKET, BINARY )
  db_temp_size( SOCKET, UNSIGNED )
  db_request(HTTPLAY_REQUEST,httplay_handler,SOCKET,STRING,UNSIGNED)
  to_do_db_requests(httplay_handler,STRING,USHORT,HTTPLAY_REQUEST_LIST)
  
  close_flag(SOCKET)
%_____________________________________________________
% PREDICATES for processing multiple and persistent connections
%_____________________________________________________   
PREDICATES
  procedure httpl_send_multi(INTEGER) - (i)
  determ check_rest_reqs(HTTPLAY_REQUEST_LIST) - (i)
  procedure run_rest_reqs()
  procedure run_rest_reqs_conn(httplay_handler,STRING,USHORT,HTTPLAY_REQUEST_LIST)	- (i,i,i,i)
%____________________________________________________________
%                          ERROR PREDICATES
%____________________________________________________________   
PREDICATES
  procedure err_proc(SOCKET,UNSIGNED)  				- (i,i)
  err_proc_ini(httplay_handler,HTTPLAY_REQUEST,UNSIGNED)
  
%____________________________________________________________
%                             Handlers for Msglayer
%____________________________________________________________
PREDICATES
  httplay_common_hndl : msglay_handler
%____________________________________________________________
%                            Handle Msglay events
%____________________________________________________________
CLAUSES
  httplay_common_hndl(_,e_Close(msglay_self)):-!.
  httplay_common_hndl(S,Ev):-
        http_window(HTTPwin),
        assert(httplay_msglay_answer(S,Ev)),
        win_PostEvent(HTTPwin,e_Native(http_socket,S,0)),!.
%____________________________________________________________
%             INITIAL OF WINDOW FOR MSGlay->HTTPlay WinMessages
%____________________________________________________________
PREDICATES
  procedure httplay_init()
  http_event_eh : ehandler
  http_process_answer(SOCKET,msglay_event)
  procedure test_result(BOOLEAN,WINDOW,UNSIGNED,HTTPLAY_REQUEST) - (i,i,i,i)
%  check_simple(SOCKET) - (i)
  test_closure(SOCKET) - (i)
  find_length(HEADERS_0,UNSIGNED,UNSIGNED) - (i,i,o)
  procedure mergeData( SOCKET, BINARY, UNSIGNED )	- (i,i,i)
CLAUSES
  httplay_init():-
        not(http_window(_)),
        ScreenWindow = cast(window,vpi_GetAttrVal(attr_screen_window)),
        WinDefs = [dlg(wdef(wd_ModeLess,rct(0,0,0,0),"",u_Pixels),[wsf_Invisible,wsf_Disabled])],
        CreateData = cast(long,0),
        win_CreateDynDialog(ScreenWindow,WinDefs,http_event_eh,CreateData),
        !.
  httplay_init().

  http_event_eh(Win,e_Create(_),0):-
  	assert(httplay_last_error(0)),
        assert(http_window(Win)),
        win_EnableHook(Win, b_true),
        !.
  http_event_eh(_Win,e_Native(http_socket,Socket,_LParam),0):-
        retract(httplay_msglay_answer(Socket,Answ)),!,
        http_process_answer(Socket,Answ),
        !.
%_____________________________________________________
%           Predicates for processing requests and responses
%_____________________________________________________ 
PREDICATES
  procedure format_write_req(SOCKET, HTTPLAY_REQUEST)
  procedure format_write_req_send( SOCKET, BINARY)			- (i,i)
  BOOLEAN parse_response(BINARY,HTTPLAY_REQUEST)
  find_termination(BINARY,UNSIGNED,UNSIGNED,BOOLEAN) - (i,i,o,o)
  find_body(BINARY,UNSIGNED,UNSIGNED,BOOLEAN) - (i,i,o,o)
  determ compare_FirstSymbols( UNSIGNED, BINARY, BINARY ) - (i,i,i)
%  BOOLEAN check_bytes(BYTE,BYTE,BINARY,UNSIGNED,UNSIGNED) - (i,i,i,i,o)
  determ BOOLEAN read_headers(BINARY,HEADERS_0)  
  
%_____________________________________________________
%                          Process Msglay events
%_____________________________________________________
CLAUSES
  http_process_answer(S,e_Connect(S)):-
  	retract(db_request(Request,User_hndl,S,_,_)),
	assert( db_temp( S, User_hndl, Request) ),
	assert( db_temp_size( S, 0 ) ),
        format_write_req(S,Request),
        !.
  http_process_answer(S,e_ReadBin(Block)):-
	Size = getbinarysize( Block ),
	retract( db_temp_size( S, OldSize ) ),
	NewSize = OldSize + Size,
	assert( db_temp_size ( S, NewSize ) ),
	assert( db_temp_data( S, Block ) ),
	test_closure( S ),
        !.
  http_process_answer(S,e_Error(msglay_errEvConnect)):-
  	retract(db_request(Request,User_hndl,S,_,_)),
  	User_hndl = httplay_win(UserWin,UserMes),
  	trap(msglay_Close(S),Err1,err_proc(S,Err1)),
  	retractall(close_flag(S)),
  	retractall(httplay_msglay_answer(S,_)),
  	msglay_LastError(Err),
  	retractall(httplay_last_error(_)),
	assert(httplay_last_error(Err)),
        assert(httplay_answer(httplay_error(Request,Err))),
        win_PostEvent(UserWin,e_Native(UserMes,0,0)),
        run_rest_reqs(),!.
  http_process_answer(S,e_Error(_)):-
  	db_temp(S,httplay_win(UserWin,UserMes),Request),
        trap(msglay_Close(S),Err1,err_proc(S,Err1)),
      	retract(db_temp(S,httplay_win(UserWin,UserMes),Request)),
      	retractall( db_temp_data( S, _ ) ),
      	retractall( db_temp_size( S, _ ) ),!,
      	retractall(close_flag(S)),
	retractall(httplay_msglay_answer(S,_)),
	msglay_LastError(Err),
	retractall(httplay_last_error(_)),
	assert(httplay_last_error(Err)),
        assert(httplay_answer(httplay_error(Request,Err))),
        win_PostEvent(UserWin,e_Native(UserMes,0,0)),
        run_rest_reqs(),
        !.
  http_process_answer(S,e_Close(msglay_incoming)):-
  	assert(close_flag(S)),
  	test_closure(S),
  	!.
  http_process_answer(_,_).	% dummy

  test_result(0,UserWin,UserMes,_):-
        win_PostEvent(UserWin,e_Native(UserMes,0,0)),
        run_rest_reqs(),!.
  test_result(1,UserWin,UserMes,Request):-
	httplay_last_error(Err),
  	assert(httplay_answer(httplay_error(Request,Err))),
        win_PostEvent(UserWin,e_Native(UserMes,0,0)),
        run_rest_reqs(),!.
  test_result(_,_,_,_).
 	
 	
  test_closure(S):-
 	close_flag(S),
% 	check_simple(S),!,
 	retract(close_flag(S)),
%        trap(msglay_Close(S),Err1,err_proc(S,Err1)),
        retract(db_temp(S,httplay_win(UserWin,UserMes),Request)),
	retractall( httplay_msglay_answer( S,_ ) ),
	retract( db_temp_size( S, WholeSize ) ),
	WholeBlock = makebinary( WholeSize ),
	mergeData( S, WholeBlock, 0 ),
	R = parse_response( WholeBlock, Request ),
	test_result(R,UserWin,UserMes,Request),
	!.
  test_closure(_).
 
/*  check_simple(S):-
 	db_temp(S,Bin,_,_),
	Size = getbinarysize(Bin),
	Size < 5,!,fail.
  check_simple(S):-
 	db_temp(S,Bin,_,_),
	str_len("HTTP/",L),	%rather simple - 2Do
	Head_full = composebinary("HTTP/",L),
  	trap(splitBinary(Bin,L,Head,_),_,dlg_error("HTTP: Check_simple1")),
  	Head_full <> Head,!.	%it is a simple response
  check_simple(S):-
 	db_temp(S,Bin,_,_),
 	find_termination(Bin,0,_,Res),
 	Res = int_err,!.	% in case when 0D0A is replaced with 0A - then ignore content
  check_simple(S):-
 	db_temp(S,Bin,_,_),
        find_termination(Bin,0,Index,RR),
        RR = int_ok,
	trap(splitBinary(Bin,Index,_,Rst),_,dlg_error("HTTP: Check_simple2")),
	read_headers(Rst,Headers,Body),
	Size_body = getbinarysize(Body),
	find_length(Headers,Size_body,Length),
	Size_body = Length,
	!. 			% required length received or there is no header Content-Length*/

  find_length([],S,S):-!.
  find_length([content_length(Len)|_],_,Len):-!.
  find_length([_|L],Sz_body,Leng):-!,
 	find_length(L,Sz_body,Leng).

  mergeData( S, _WholeBlock, _ ):-
  	not( db_temp_data( S, _ ) ),!.
  mergeData( S, WholeBlock, CurrentPos ):-
  	db_temp_data( S, Block ),
  	Block_size = getbinarysize( Block ),
  	Block_ptr = cast( ULONG, Block ),
  	WholeBlock_ptr = cast( ULONG, WholeBlock ),
  	Current_offset = WholeBlock_ptr + CurrentPos,
  	movmem( Block_ptr, Current_offset, Block_size ),
	NewPos = CurrentPos + Block_size,
  	retract( db_temp_data( S, Block ) ),!,
  	mergeData( S, WholeBlock, NewPos ).
  mergeData( _, _, _ ).	%dummy

%_____________________________________________________
%          Predicates for processing requests
%_____________________________________________________
PREDICATES
  add_product(STRING,product_version,STRING)
  prod_comm(STRING,product_ver,STRING)
  procedure add_params(STRING, STRING, SLIST, STRING)		 - (i,i,i,o)
  add_query(STRING,STRING,STRING)
  BOOLEAN add_headers(STRING,headers_0,STRING)
  BOOLEAN add_head(STRING,headers,STRING)
  procedure add_body(BINARY,entity_body_0,BINARY)
  add_uri(STRING,httplay_URI,STRING)
  BOOLEAN check_stamp(STRING,STRING,STRING,INTEGER,STRING,INTEGER,INTEGER,INTEGER,INTEGER,STRING)
  strad(STRING,STRING)
  determ verify_weekday(STRING)
  determ verify_month(STRING)
  determ verify_year(INTEGER)
  determ check_hour(INTEGER,STRING)
  determ check_min_sec(INTEGER,STRING)
  determ check_day(INTEGER,STRING)
  
CLAUSES
  check_stamp(Str_inp,Pre_str,WeekDay,Day,Month,Year,Hour,Minute,Second,Str_out,int_ok):-
    	verify_weekday(WeekDay),
  	check_day(Day,Day_r),
  	verify_month(Month),
  	verify_year(Year),
  	check_hour(Hour,Hour_r),
  	check_min_sec(Minute,Minute_r),
  	check_min_sec(Second,Second_r),
  	format(Str_out,"%s%s%s, %s %s %d %s:%s:%s GMT\n",Str_inp,Pre_str,WeekDay,Day_r,Month,Year,Hour_r,Minute_r,Second_r),!.
  check_stamp(_,_,_,_,_,_,_,_,_,"",int_err):-
  	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(httplay_errInvalidDate_or_Time)).
  	
  verify_weekday(Wday):-Wday="Mon",!;Wday="Tue",!;Wday="Wed",!;Wday="Thu",!;Wday="Fri",!;Wday="Sat",!;Wday="Sun",!.
  verify_month(Month):-Month="Jan",!;Month="Feb",!;Month="Mar",!;Month="Apr",!;Month="May",!;Month="Jun",!;Month="Jul",!;Month="Aug",!;Month="Sep",!;Month="Oct",!;Month="Nov",!;Month="Dec",!.
  verify_year(Year):-str_int(Year_str,Year),str_len(Year_str,4),!.
  check_hour(Hour,Result):-
  	Hour >= 0,
  	Hour <= 24,
  	str_int(Hour_str,Hour),
  	strad(Hour_str,Result),!.
  check_min_sec(Min_sec,Result):-
  	Min_sec >= 0,
  	Min_sec < 60,
  	str_int(Min_sec_str,Min_sec),
  	strad(Min_sec_str,Result),!.	
  check_day(Day,Result):-
  	Day > 0,
  	Day < 32,
  	str_int(Day_str,Day),
	strad(Day_str,Result),!.
  	
  strad(X,X):-
	str_len(X,2),!.
  strad(X,Y):-
	concat("0",X,Y),!.
  	
  add_product(Str_res,[],Str_res):-!.
  add_product(Str,[El|Lst],Str_res):-
  	prod_comm(Str,El,Str_tmp),!,
  	add_product(Str_tmp,Lst,Str_res).	
  	
  prod_comm(Str,prod(Str_prod),Str1):-
  	format(Str1,"%s %s",Str,Str_prod),!.
  prod_comm(Str,comm(Str_comm),Str1):-
  	format(Str1,"%s %s",Str,Str_comm),!.  	
  	
  add_params(Str,StrDev,[],Str1):-
  	str_len(Str,L), str_len(StrDev,Ld), L1=L-Ld,
	frontstr(L1,Str,Str_first,Str_last),
	StrDev = Str_last,!,
	Str1 = Str_first,
  	!.
  add_params(Str,StrDev,[],Str1):-
  	str_len(Str,L),	str_len(StrDev,Ld), L1=L-Ld,
	frontstr( L1, Str, _, Str_last ),
	StrDev <> Str_last,!,
	Str1 = Str,
  	!.
  add_params(_,_,[],"").			% dummy, not possible
  add_params(Str,StrDev,[El|List],Result):-   	% for first element of a list
  	str_len(Str,L),L1 = L - 2,
	frontstr(L1,Str,_,RestString),
	RestString = ": ",!,
	format(Str1,"%s%s",Str,El),
  	add_params(Str1,StrDev,List,Result).	
  add_params(Str,StrDev,[El|List],Result):-
  	format(Str1,"%s%s%s",Str,StrDev,El),!,
  	add_params(Str1,StrDev,List,Result).
  	
  add_query(Str_res,"",Str_send):-
  	format(Str_send,"%s",Str_res),!.
  add_query(Str_res,Query,Str_send):-
  	format(Str_send,"%s?%s",Str_res,Query),!.
  	
  add_headers(Str,[],Str,int_ok):-!.
  add_headers(Str,[El|List],Result,Rs):-
  	Rr1 = add_head(Str,El,Str1),!,
  	Rr2 = add_headers(Str1,List,Result),
	bitor(Rr1,Rr2,Rs).

%general headers
  add_head(Str,date_0(http_date(WeekDay,date(Day,Month,Year),time(Hour,Minute,Seconds))),Str1,R):-
  	R = check_stamp(Str,"Date: ",WeekDay,Day,Month,Year,Hour,Minute,Seconds,Str1),!.  
  add_head(Str,pragma(ListDirectives),Str1,int_ok):-
  	format(Str_tmp,"%sPragma: ",Str),
  	add_params(Str_tmp,",",ListDirectives,Str_tmp1),
  	format(Str1,"%s\n",Str_tmp1),!.
  
%entity headers   
  add_head(Str,allow(ListMethods),Str1,int_ok):-
  	format(Str_tmp,"%sAllow: ",Str),
  	add_params(Str_tmp,",",ListMethods,Str_tmp1),
  	format(Str1,"%s\n",Str_tmp1),!.
  add_head(Str,content_encoding(Coding),Str1,int_ok):-
  	format(Str1,"%sContent-Encoding: %s\n",Str,Coding),!.
  add_head(Str,content_length(Length),Str1,int_ok):-
  	format(Str1,"%sContent-Length: %U\n",Str,Length),!.
  add_head(Str,content_type(Type,SubType,ListParams),Str1,int_ok):-
  	format(Str_tmp,"%sContent-Type: %s/%s",Str,Type,SubType),
  	add_params(Str_tmp,";",ListParams,Str_tmp1),
  	format(Str1,"%s\n",Str_tmp1),!.
  add_head(Str,expires(http_date(WeekDay,date(Day,Month,Year),time(Hour,Minute,Seconds))),Str1,R):-
  	R = check_stamp(Str,"Expires: ",WeekDay,Day,Month,Year,Hour,Minute,Seconds,Str1),!.
  add_head(Str,last_modified(http_date(WeekDay,date(Day,Month,Year),time(Hour,Minute,Seconds))),Str1,R):-
  	R = check_stamp(Str,"Last-Modified: ",WeekDay,Day,Month,Year,Hour,Minute,Seconds,Str1),!.
  	  
%request headers
  add_head(Str,authorization(basic_credentials(Basic_cookie)),Str1,int_ok):-
  	format(Str1,"%sAuthorization: Basic %s\n",Str,Basic_cookie),!.
  add_head(Str,authorization(authoriz(Sheme,ListParams)),Str1,int_ok):-
  	format(Str_tmp,"%sAuthorization: %s ",Str,Sheme),
  	add_params(Str_tmp,",",ListParams,Str_tmp1),
  	format(Str1,"%s\n",Str_tmp1),!.
  add_head(Str,from(Mailbox),Str1,int_ok):-
  	format(Str1,"%sFrom: %s\n",Str,Mailbox),!.
  add_head(Str,if_modified_since(http_date(WeekDay,date(Day,Month,Year),time(Hour,Minute,Seconds))),Str1,R):-
  	R = check_stamp(Str,"If-Modified-Since: ",WeekDay,Day,Month,Year,Hour,Minute,Seconds,Str1),!.
  add_head(Str,referer(rel_path(Path,ListParams,Query)),Str1,int_ok):-
  	format(Str_tmp,"%sReferer: %s",Str,Path),
  	add_params(Str_tmp,";",ListParams,Str_tmp1),
  	add_query(Str_tmp1,Query,Str_tmp2),
  	format(Str1,"%s\n",Str_tmp2),!.
  add_head(Str,referer(absoluteURI(Sheme,LastUri)),Str1,int_ok):-
  	format(Str1,"%sReferer: %s:%s\n",Str,Sheme,LastUri),!.
  add_head(Str,user_agent(ListProgr),Str1,int_ok):-
  	format(Str_tmp,"%sUser-Agent:",Str),
  	add_product(Str_tmp,ListProgr,Str_tmp1),
  	format(Str1,"%s\n",Str_tmp1),!.
  
%response headers  
  add_head(_Str,location(_Sheme,_URI),"",int_err):-
  	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(httplay_errInvalidHeader)),!.
  add_head(_Str,server(_List),"",int_err):-
  	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(httplay_errInvalidHeader)),!.
  add_head(_Str,www_authenticate(_Auth_sheme,_Realm_value,_Auth_params),"",int_err):-
  	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(httplay_errInvalidHeader)),!.
  	
%undeclared in rfc 1945 header can be used:
  add_head(Str,unrecognized_header(Name,Value),Str1,int_ok):-
  	format(Str1,"%s%s: %s\n",Str,Name,Value),!.
  
  add_body(Bin,[],Bin):-!.
  add_body(Bin,[entity_body(El)|List],Result):-
  	Bn = mergeBinary(Bin,El),!,
  	add_body(Bn,List,Result).

  add_uri(Str,absoluteURI(Sheme,Rest),Out):-
  	format(Out,"%s%s://%s",Str,Sheme,Rest),!.
  add_uri(Str, rel_path(Path,LstParams,Query),Out):-	
   	format(S,"%s%s",Str,Path),
    	add_params(S,";",LstParams,Str_par),
  	add_query(Str_par,Query,Out),
  	!.
  	
  format_write_req(S,simple_req(Uri)):-
  	format(Str,"GET "),
  	add_uri(Str,Uri,Str_uri),
  	format(Str_send,"%s\n",Str_uri),
  	str_len(Str_send,L),
  	Str_bin = composebinary(Str_send,L),
        format_write_req_send( S, Str_bin ),
        !.
  format_write_req(S,full_req(req_line(Method,Uri,http_ver(Major,Minor)),Headers,Body)):-
  	format(Str,"%s ",Method),
  	add_uri(Str,Uri,Str_uri),
  	format(Str_ver,"%s HTTP/%d.%d\n",Str_uri,Major,Minor),
  	int_ok = add_headers(Str_ver,Headers,Str_head1),
  	!,
  	format(Str_head,"%s\n",Str_head1),
  	str_len(Str_head,L),
  	Str_bin_head = composebinary(Str_head,L),
  	add_body(Str_bin_head,Body,Str_bin),
  	format_write_req_send( S, Str_bin ),
    	!.
  format_write_req(S,_):-
  	db_temp(S,httplay_win(UserWin,UserMes),Request),
        trap(msglay_Close(S),Err1,err_proc(S,Err1)),
      	retract(db_temp(S,httplay_win(UserWin,UserMes),Request)),
      	retractall( db_temp_data( S, _ ) ),
      	retractall( db_temp_size( S, _ ) ),
	retractall(httplay_msglay_answer(S,_)),
	httplay_last_error(Err),
  	assert(httplay_answer(httplay_error(Request,Err))),
        win_PostEvent(UserWin,e_Native(UserMes,0,0)),
        run_rest_reqs(),!.
  format_write_req(_,_).		% dummy
        
  format_write_req_send( S, Str_bin ):-
          trap(msglay_writeBin(S,Str_bin),Err,err_proc(S,Err)),
          !.
  format_write_req_send( _, _ ).
  	  	
%_____________________________________________________
%          Predicates for processing responses
%_____________________________________________________
PREDICATES
  procedure strip_leading_spaces(STRING,STRING) - (i,o)
  procedure strip_last_spaces(STRING,STRING) - (i,o)
  procedure reverse(STRING,STRING) - (i,o)
  procedure trim(STRING,STRING)				- (i,o)
  determ BOOLEAN read_header(BINARY,HEADERS,BINARY) 	- (i,o,o)
  BOOLEAN what_header(STRING,STRING,HEADERS)
  determ format_status(BINARY,STATUS_LINE)
  determ delete_commas(SLIST,SLIST) - (i,o)
  determ BOOLEAN parse_date(STRING,HTTPLAY_DATE)
  determ parse_sep(STRING,CHAR,SLIST)
  determ BOOLEAN parse_comment(STRING,PRODUCT_VERSION) - (i,o)
  BOOLEAN parse_comm(STRING,CLIST,INTEGER,INTEGER)
  is_empty(CLIST,STRING,INTEGER)
  is_body_empty(BINARY,ENTITY_BODY_0)
CLAUSES

  strip_leading_spaces(STR,STR2):-
        frontchar(STR,' ',St1),!,
        strip_leading_spaces(St1,STR2).
  strip_leading_spaces(STR,STR).
  
  strip_last_spaces(Str,Str3):-
  	reverse(Str,Str1),
  	strip_leading_spaces(Str1,Str2),
  	reverse(Str2,Str3),!.
  
  reverse("",""):-!.
  reverse(Str,Str1):-
	frontstr(1,Str,StartString,RestString),
	reverse(RestString,Rest),!,
	concat(Rest,StartString,Str1).
  reverse(_,"").			% dummy, not possible
  	
  trim(Str,Str2):-
  	strip_leading_spaces(Str,Str1),
  	strip_last_spaces(Str1,Str2),!.
  
  parse_response($[],_,int_err):-
  	retractall(httplay_last_error(_)),
	assert(httplay_last_error(httplay_errInvalidResponse)),
	!.
  parse_response(Bin,_,int_err):-		% in case when 0D0A is replaced with 0A - then ignore content
  	find_termination(Bin,0,_,RR),
  	RR = int_err,
  	retractall(httplay_last_error(_)),
	assert(httplay_last_error(httplay_errInvalidResponse)),!.
  parse_response(Bin,_,int_err):-
	Size = getbinarysize(Bin),
	Size < 5,
	retractall(httplay_last_error(_)),
	assert(httplay_last_error(httplay_errInvalidResponse)),!.
  parse_response(Bin,Request,int_ok):-
  	str_len("HTTP/",L),			%rather simple - 2Do, better: HTTP/1*DIGIT.1*DIGIT SP 3DIGIT SP
	Head_full = composebinary("HTTP/",L),
	compare_FirstSymbols( 0, Head_full, Bin ),!,
        assert(httplay_answer(ok(Request,simple_resp([entity_body(Bin)])))),!.
  parse_response( WholeBlock ,Request, R ):-         % parse full response
  	%body block
  	find_body( WholeBlock, 0, BodyBegIndex, Reslt ),
  	Reslt = int_ok,
	WholeBlock_size = getbinarysize( WholeBlock ),
	Body_size = WholeBlock_size - BodyBegIndex,
	WholeBlock_ptr = cast( ULONG, WholeBlock ),
	Body_place = WholeBlock_ptr + BodyBegIndex,
	Body = makebinary( Body_size ),
	Body_ptr = cast( ULONG, Body ),
	movmem( Body_place, Body_ptr, Body_size ),
  	% status block
  	find_termination( WholeBlock, 0, HeaderBegIndex, RR ),
  	RR = int_ok,
  	Status_size = HeaderBegIndex - 2,
	Status = makebinary( Status_size ),
	Status_ptr = cast( ULONG, Status ),
	movmem( WholeBlock_ptr, Status_ptr, Status_size ),
	% headers block
	Headers_size = WholeBlock_size - Body_size - HeaderBegIndex,
	Headers_block = makebinary( Headers_size ),
	Headers_ptr = cast( ULONG, Headers_block ),
	HeadersPart_ptr = WholeBlock_ptr + HeaderBegIndex,
	movmem( HeadersPart_ptr, Headers_ptr, Headers_size ),
	format_status( Status, StatusLine ),
  	R = read_headers( Headers_block, Headers ),
  	R = int_ok,
  	is_body_empty(Body,Body_lst),
  	assert(httplay_answer(ok(Request,full_resp(StatusLine,Headers,Body_lst)))),
  	!.
  parse_response(_,_,int_err).
  	
  compare_FirstSymbols( 5, _, _ ):- !,fail.
  compare_FirstSymbols( Cnt, Test, In ):-
	ByteA = getbyteentry( Test, Cnt ),
	ByteB = getbyteentry( In, Cnt ),
	ByteA = ByteB,
	NewCnt = Cnt + 1,!,
	compare_FirstSymbols( NewCnt, Test, In ).
  compare_FirstSymbols( _, _, _ ):-!.	% first 5 bytes are not "HTTP/"
	
/*  check_bytes(0xd,0xa,_,Cnt,Cnt_res,int_ok):-
  	Cnt_res = Cnt + 2,!.
  check_bytes(_,_,In,Cnt,Cnt_res,Res):-
  	Cnt_n = Cnt + 1,!,
  	Res = find_termination(In,Cnt_n,Cnt_res).*/
  
  find_termination(In,Cnt,0,int_err):-
  	not(trap(getbyteentry(In,Cnt),_,true)),!.	%getbyteentry fails
  find_termination(In,Cnt,Cnt_res,int_ok):-
  	trap(Byte0 = getbyteentry(In,Cnt),_,true),
  	Cnt1 = Cnt + 1,
  	trap(Byte1 = getbyteentry(In,Cnt1),_,true),
  	Byte0 = 0xd,
  	Byte1 = 0xa,
  	Cnt_res = Cnt + 2,!.
  find_termination(In,Cnt,Cnt_res,Res):-
  	Cnt_n = Cnt + 1,!,
  	find_termination(In,Cnt_n,Cnt_res,Res).
  	
  find_body(In,Cnt,0,int_err):-
  	not(trap(getbyteentry(In,Cnt),_,true)),!.	%getbyteentry fails
  find_body(In,Cnt,Cnt_res,int_ok):-
	Cnt1 = Cnt + 1,
	Cnt2 = Cnt + 2,
	Cnt3 = Cnt + 3,
  	trap(Byte0 = getbyteentry(In,Cnt),_,true),
  	trap(Byte1 = getbyteentry(In,Cnt1),_,true),
  	trap(Byte2 = getbyteentry(In,Cnt2),_,true),
  	trap(Byte3 = getbyteentry(In,Cnt3),_,true),
  	Byte0 = 0xd,
  	Byte1 = 0xa,
  	Byte2 = 0xd,
  	Byte3 = 0xa,
  	Cnt_res = Cnt + 4,!.
  find_body(In,Cnt,Cnt_res,Res):-
  	Cnt_n = Cnt + 1,!,
  	find_body(In,Cnt_n,Cnt_res,Res).
  
  format_status(In,res_line(http_ver(Ver_major,Ver_minor),Code_int,Descr)):-
  	Lst = binary_to_strlist(In),
  	Lst = [F_str|_],
	searchstring(F_str," ",FoundPos),
	FP = FoundPos - 1,
	frontstr(FP,F_str,Version,Rest1),
	str_len("HTTP/",L),
	frontstr(L,Version,_,Vrs),
	searchstring(Vrs,".",FP_dot),
	Fd1 = FP_dot - 1,
	frontstr(Fd1,Vrs,Ver_major_str,_),
	frontstr(FP_dot,Vrs,_,Ver_minor_str),
	str_int(Ver_major_str,Ver_major),
	str_int(Ver_minor_str,Ver_minor),
	frontchar(Rest1,_,Rest2),
	searchstring(Rest2," ",FoundPos2),
	FP2 = FoundPos2 - 1,
	frontstr(FP2,Rest2,Code_str,Rest3),
	str_int(Code_str,Code_int),
	frontchar(Rest3,_,Descr),
	!.
	
  read_headers( In, [], int_ok ):-
  	Byte = getbyteentry(In,0),
	Byte = 0xd,
	Byte1 = getbyteentry(In,1),
	Byte1 = 0xa,
	!.
  read_headers( In, [H|Out], Rs):-
  	Rr1 = read_header( In, H, OutBlock ),!,
	Rr2 = read_headers( OutBlock, Out ),
	bitor(Rr1,Rr2,Rs).

  read_header( In, Header, OutBl, R ):-
  	find_termination( In, 0, Index, RR ),
  	RR = int_ok,
  	Ind = Index - 2,
	In_size = getbinarysize( In ),
	OutBl_size = In_size - Index,
	OutBl = makebinary( OutBl_size ),
	In_ptr = cast( ULONG, In ),
	OutBl_ptr = cast( ULONG, OutBl ),
	OutBl_place = In_ptr + Index,
	movmem( OutBl_place, OutBl_ptr, OutBl_size ),
	Head_bin = makebinary( Ind ),
	Head_bin_ptr = cast( ULONG, Head_bin ),
	movmem( In_ptr, Head_bin_ptr, Ind ),
	Lst = binary_to_strlist(Head_bin),
  	Lst = [F_str|_],
	searchstring(F_str,":",FoundPos),
	FP = FoundPos - 1,
	frontstr(FP,F_str,Head_name,Rest_head1),
	frontchar(Rest_head1,_,Rest_head),
	upper_lower(Head_name,Head_name_l),
	R = what_header(Head_name_l,Rest_head,Header),
	!.

  parse_comment("",[],int_ok):-!.
  parse_comment(In,[prod(In1)],int_ok):-
	not(searchchar(In,'(',_)),
	not(searchchar(In,' ',_)),
	trim(In,In1),!.
  parse_comment(Inn,[comm(Cm)|L],Rs):-
  	trim(Inn,In),
  	frontchar(In,'(',_),!,
  	int_ok = parse_comm(In,[],0,Len),
  	!,
  	frontstr(Len,In,Cm1,Rest),
  	trim(Cm1,Cm),!,
  	Rs = parse_comment(Rest,L).
  parse_comment(In,[prod(Pr)|L],R):-
  	searchchar(In,'(',FoundPos),
  	FP =FoundPos - 1,
	frontstr(FP,In,Pr1,Rest),
	trim(Pr1,Pr),!,
	R = parse_comment(Rest,L).
  parse_comment(In,[prod(Pr)|L],R):-
  	searchchar(In,' ',FoundPos),
  	FP =FoundPos - 1,
	frontstr(FP,In,Pr1,Rest),
	trim(Pr1,Pr),
	frontchar(Rest,_,Rst),!,
	R = parse_comment(Rst,L).
  parse_comment(_,[],1).
	
  parse_comm("",_,_,1,int_err):-
	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(httplay_errInvalidHeader)),!.
  parse_comm(In,L_char,L_b,L1,R):-
	frontchar(In,FrontChar,RestString),
	FrontChar = '(',
	R = parse_comm(RestString,['('|L_char],1,Res),
	R = int_ok,
	frontstr(Res,In,_,Rest),
	is_empty(L_char,Rest,Rs),
	L1 = Res + Rs + L_b,!.
  parse_comm(In,['('|_],Cnt,C,int_ok):-
  	frontchar(In,FrontChar,_),
  	FrontChar = ')',
  	C = Cnt + 1,!.
  parse_comm(In,L_char,Cn,C,R):-
  	frontchar(In,_,RestString),
  	Cnt = Cn + 1,!,
  	R = parse_comm(RestString,L_char,Cnt,C).
  parse_comm(_,_,_,0,int_err).	
  
  is_empty([],_,int_ok):-!.
  is_empty(L,Rest,Res):-
  	parse_comm(Rest,L,0,Res).
  
  parse_sep("",_,[]):-!.
  parse_sep(In,Sep,L1):-
  	frontchar(In,Sep,Rest),!,
  	parse_sep(Rest,Sep,L1).
  parse_sep(In,Sep,[El|L1]):-
  	searchchar(In,Sep,FoundPos),!,
  	FP = FoundPos - 1,
  	frontstr(FP,In,Ell,RestString),
  	strip_leading_spaces(Ell,El),!,
  	parse_sep(Reststring,Sep,L1).
  parse_sep(In,Sep,[In]):-
	not(searchchar(In,Sep,_)),!.
  	
  parse_date(In,http_date(WeekD,date(D,Month,Y),time(Hour,Min,Sec)),int_ok):-
  	parse_sep(In,' ',Lst),
  	Lst = [WeekDay,Day,Month,Year,Time,"GMT"],!,   %RFC 1123
  	delete_commas([WeekDay],Wd),
  	Wd = [WeekD],
  	str_int(Day,D),
  	str_int(Year,Y),
  	parse_sep(Time,':',Tm_lst),
  	Tm_lst = [Hr,Mn,Sc],
	str_int(Hr,Hour),
	str_int(Mn,Min),
	str_int(Sc,Sec),!.
  parse_date(In,http_date(WeekD,date(Day,Month,Year),time(Hour,Min,Sec)),int_ok):-
  	parse_sep(In,' ',Lst),
  	Lst = [WeekDay,Date,Time,"GMT"],!,   %RFC 850 obs by 1036
  	delete_commas([WeekDay],Wd),
  	Wd = [WeekD],
  	parse_sep(Date,'-',D_lst),
  	D_lst = [D,Month,Y],
  	str_int(D,Day),
	str_int(Y,Year),
	parse_sep(Time,':',Tm_lst),
  	Tm_lst = [Hr,Mn,Sc],
	str_int(Hr,Hour),
	str_int(Mn,Min),
	str_int(Sc,Sec),!.
  parse_date(In,http_date(WeekDay,date(Day,Month,Year),time(Hour,Min,Sec)),int_ok):-
	parse_sep(In,' ',Lst),
  	Lst = [WeekDay,Month,D,Time,Y],!,   %asctime() format
  	str_int(D,Day),
  	str_int(Y,Year),
	parse_sep(Time,':',Tm_lst),
  	Tm_lst = [Hr,Mn,Sc],
	str_int(Hr,Hour),
	str_int(Mn,Min),
	str_int(Sc,Sec),!.
  parse_date(_,http_date("",date(0,"",0),time(0,0,0)),int_err):-
	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(httplay_errInvalidDate_or_Time)).

  what_header("date",Inf,date_0(Res),R):-
  	strip_leading_spaces(Inf,Inf1),
	R = parse_date(Inf1,Res),
	!.
  what_header("pragma",Inf,pragma(Res),int_ok):-
  	strip_leading_spaces(Inf,Inf1),
  	parse_sep(Inf1,',',Res),
	!.
  what_header("location",Addr,location(Sheme,URI),int_ok):-
  	strip_leading_spaces(Addr,Addr1),
	searchchar(Addr1,':',FoundPos),
	FP = FoundPos - 1,
	frontstr(FP,Addr1,Sheme,RestString),
	frontchar(RestString,_,URI),
  	!.
  what_header("location",Addr,location("",URI),int_ok):-
  	strip_leading_spaces(Addr,URI),!.
  what_header("server",Inf,server(Res),R):-
  	strip_leading_spaces(Inf,Inf1),
  	R = parse_comment(Inf1,Res),
  	!.
  what_header("www-authenticate",Inf,www_authenticate(Sheme,Realm,Params),int_ok):-
  	strip_leading_spaces(Inf,Inf1),
	searchchar(Inf1,' ',FoundPos),
	FP = FoundPos - 1,
	frontstr(FP,Inf1,Sheme,RestString),
	frontchar(RestString,_,Rest),
	parse_sep(Rest,',',Lst),
	Lst = [Realm|Params],
  	!.
  what_header("www-authenticate",Inf,www_authenticate(Inf1,"",[]),int_ok):-		% NTLM case
  	strip_leading_spaces(Inf,Inf1),
	not(searchchar(Inf1,' ',_)),
  	!.  	
  what_header("www-authenticate",_,www_authenticate("","",[]),int_err):-
  	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(httplay_errInvalidHeader)),!.
  what_header("allow",Inf,allow(Lst1),int_ok):-
  	strip_leading_spaces(Inf,Inf1),
  	parse_sep(Inf1,',',Lst),
  	delete_commas(Lst,Lst1),
	!.
  what_header("content-encoding",Inf,content_encoding(Inf1),int_ok):-
  	strip_leading_spaces(Inf,Inf1),
	!.
  what_header("content-length",Inf,content_length(L),int_ok):-
  	strip_leading_spaces(Inf,Inf1),
	term_str(unsigned,L,Inf1),
	!.
  what_header("content-type",Inf,content_type(Type,SubType,LParams),int_ok):-
  	strip_leading_spaces(Inf,Inf1),
	searchchar(Inf1,'/',FoundPos),
	FP = FoundPos - 1,
	frontstr(FP,Inf1,Type,RestString),
	frontchar(RestString,_,Rest),
	parse_sep(Rest,';',Lst),
	Lst = [SubType|LParams],
	!.
  what_header("content-type",_,content_type("","",[]),int_err):-
	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(httplay_errInvalidHeader)),!.	
  what_header("expires",Inf,expires(Res),R):-
  	strip_leading_spaces(Inf,Inf1),
  	R = parse_date(Inf1,Res),
	!.
  what_header("last-modified",Inf,last_modified(Res),R):-
  	strip_leading_spaces(Inf,Inf1),
  	R = parse_date(Inf1,Res),  	
	!.
  what_header(Header_name,Header_content,unrecognized_header(Header_name,Header_content),int_ok):-	% unrecognized header
  	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(httplay_errInvalidHeader)),
  	!.

%predicate delete commas that can be after names of allowable methods	:    GET, HEAD
  delete_commas([],[]):-!.
  delete_commas([El|L],[El1|L1]):-
	searchchar(El,',',FoundPos),!,
	FP = FoundPos - 1,
	frontstr(FP,El,El1,_),
  	delete_commas(L,L1).
  delete_commas([El|L],[El|L1]):-     % no comma
  	delete_commas(L,L1).
  
  is_body_empty($[],[]):-!.
  is_body_empty(Body,[entity_body(Body)]).

%_____________________________________________________
% PREDICATES for processing multiple and persistent connections
%_____________________________________________________   
PREDICATES
  nondeterm httplay_for(INTEGER,INTEGER,INTEGER) - (o,i,i)
  
CLAUSES

  httplay_for(N,N,_).		  
  httplay_for(N,First,Last):- Last>First,Next=First+1,!,httplay_for(N,Next,Last). % [+] step
  httplay_for(N,First,Last):- Last<First,Next=First-1,!,httplay_for(N,Next,Last). % [-] step

  httpl_send_multi(NumberConn):-
  	httplay_for(_N,1,NumberConn),
  		to_do_db_requests(User_hndl,HostName,PortNo,[Req|Requests]),
  		retractall(to_do_db_requests(User_hndl,HostName,PortNo,[Req|Requests])),
  		trap(S = msglay_connect(HostName,PortNo,httplay_common_hndl,[msglay_RcvBuf(32767)]),E,err_proc_ini(User_hndl,Req,E)),
  		assert(db_request(Req,User_hndl,S,HostName,PortNo)),
  		check_rest_reqs(Requests),
  		assert(to_do_db_requests(User_hndl,HostName,PortNo,Requests)),
	fail.
  httpl_send_multi(_).
 
  check_rest_reqs([]):-!,fail.	%so no assert with empty list
  check_rest_reqs(_).
        
  run_rest_reqs():-
  	retract(to_do_db_requests(User_hndl,HostName,PortNo,Lst)),!,
  	run_rest_reqs_conn(User_hndl,HostName,PortNo,Lst).
  run_rest_reqs().
  
  run_rest_reqs_conn(User_hndl,HostName,PortNo,[Req|Requests]):-
    	trap(S = msglay_connect(HostName,PortNo,httplay_common_hndl,[msglay_RcvBuf(32767)]),E,err_proc_ini(User_hndl,Req,E)),
	assert(db_request(Req,User_hndl,S,HostName,PortNo)),
	check_rest_reqs(Requests),
	assert(to_do_db_requests(User_hndl,HostName,PortNo,Requests)),!.
  run_rest_reqs_conn(_,_,_,_).

  
%_____________________________________________________
%                          ERROR PREDICATES
%_____________________________________________________   
  err_proc(S,_):-
  	trap(msglay_Close(S),_,true),fail.
  err_proc(S,Err):-
	retract(db_temp(S,httplay_win(UserWin,UserMes),Request)),
	retractall( db_temp_data( S, _ ) ),
	retractall( db_temp_size( S, _ ) ),!,
	retractall(httplay_msglay_answer(S,_)),
  	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(Err)),
  	assert(httplay_answer(httplay_error(Request,Err))),
	win_PostEvent(UserWin,e_Native(UserMes,0,0)),
	run_rest_reqs(),!.
  err_proc(S,Err):-
  	retract(db_request(Request,User_hndl,S,_,_)),
  	User_hndl = httplay_win(UserWin,UserMes),
	retractall(httplay_msglay_answer(S,_)),
  	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(Err)),		
  	assert(httplay_answer(httplay_error(Request,Err))),
	win_PostEvent(UserWin,e_Native(UserMes,0,0)),
	run_rest_reqs(),!.
  err_proc(_,_).

  err_proc_ini(httplay_win(UserWin,UserMes),Request,Err):-
  	retractall(httplay_last_error(_)),
  	assert(httplay_last_error(Err)),		
  	assert(httplay_answer(httplay_error(Request,Err))),
	win_PostEvent(UserWin,e_Native(UserMes,0,0)),
	run_rest_reqs(),!.		%????? - nesting calls
        
%_____________________________________________________
%                          GLOBAL PREDICATES
%_____________________________________________________
  httplay_CancelPrevious():-
  	retractall(db_request(_,_,_,_,_)),
	retractall(to_do_db_requests(_,_,_,_)),
  	retractall(httplay_answer(_)),
  	retract(db_temp(S,_,_)),
  		retractall( db_temp_data( S, _ ) ),
  		retractall( db_temp_size( S, _ ) ),
  		retractall(httplay_msglay_answer(S,_)),
	        trap(msglay_Close(S),Err1,err_proc(S,Err1)),
	fail.
  httplay_CancelPrevious().
  
  httplay_SendRequests(Win,Mes, HostName, PortNo, Requests, NumberOfConn):-
  	httplay_init(),
  	A = httplay_win(Win,Mes),
	upper_lower(HostName,HostName_l),
	assert(to_do_db_requests(A,HostName_l,PortNo,Requests)),
  	httpl_send_multi(NumberOfConn),
  	!.
        
  httplay_CloseSession():-
  	retractall(http_window(_)),
	retractall(httplay_msglay_answer(_,_)),
	retractall(httplay_answer(_)),
	retractall(db_temp(_,_,_)),
	retractall(db_temp_data(_,_)),
	retractall(db_temp_size(_,_)),
	retractall(db_request(_,_,_,_,_)),
	retractall(to_do_db_requests(_,_,_,_)),
	retractall(httplay_last_error(_)),
	trap(msglay_CloseAll(),_,true),
	msglay_CloseSession(),
	!.
  httplay_CloseSession().
	
  httplay_GetAnswer(Result):-retract(httplay_answer(Result)),!.
  httplay_GetLastError(Result):-httplay_last_error(Result),!.
  
