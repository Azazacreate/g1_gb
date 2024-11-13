/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  WEBAGENT
 FileName: HTTP_CON.PRO
 Purpose: Example of HTTP Layer
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/

include "webagent.inc"
include "webagent.con"
include "hlptopic.con"

CONSTANTS
  wa_next = 0xC700

DATABASE - http_con_int
  row_errors(INTEGER,INTEGER)
  new_content(INTEGER)
  wa_answers(HTTPLAY_ANSWERS)
  row_auth_in_process( INTEGER, WA_REFERENCE )
  
PREDICATES
  add_new_req(INTEGER,INTEGER,WA_REFS_LIST) - (i,i,i)
  change_slash(STRING,STRING) - (i,o),(o,i)  
  change_state(INTEGER,STRING) - (i,i)
  check_fetched_refs(WA_REFS_LIST,WA_REFS_LIST,WA_REFS_LIST) - (i,i,o)
  check_file_cache_name(STRING,STRING,STRING,STRING) - (i,i,i,o)
  check_new(INTEGER,STRING) - (i,i)
  check_other_dir_refs(STRING,BOOLEAN,WA_REFS_LIST,WA_REFS_LIST) - (i,i,i,o)
  check_other_dir_refs(STRING,WA_REFS_LIST,WA_REFS_LIST) - (i,i,o)
  check_rest(INTEGER,INTEGER,INTEGER,INTEGER) - (i,i,o,o)
  check_update_parent_file(INTEGER,WA_REFERENCE,WA_REFERENCE,STRING) - (i,i,i,i)
  change_st_test_marker(INTEGER, GRID_MARKER) - (i,i)
  clean_row(INTEGER) - (i)
  create_sons_base(INTEGER,WA_REFERENCE,WA_REFS_LIST) - (i,i,i)
  con_hndl : msglay_handler
  del_last_slash(STRING,STRING) - (i,o)
  find_host(INTEGER Row, STRING Host, USHORT Port, STRING RelPath) - (i,i,i,i)
  first_call_file(INTEGER,STRING,STRING) - (i,i,o)
  form_req_proxy(INTEGER,WA_REFERENCE,HTTPLAY_REQUEST) - (i,i,o)
  form_req_local(INTEGER,WA_REFERENCE,HTTPLAY_REQUEST) - (i,i,o)
  form_req_lst(INTEGER Kind,INTEGER,INTEGER,WA_REFS_LIST,HTTPLAY_REQUEST_LIST) - (i,i,i,i,o) % Kind:0-local;1-proxy
  get_curtime(HTTPLAY_DATE) - (o)
  get_ErrorDescr(UNSIGNED,STRING) - (i,o)
  get_path(STRING,STRING) - (i,o)
  get_sysdate(HTTPLAY_DATE) - (o)
  procedure increm_errors(INTEGER) - (i)
  INTEGER is_other_path(STRING,STRING) - (i,i)
  list_append(WA_REFS_LIST,WA_REFS_LIST,WA_REFS_LIST) - (i,i,o)
  make_new_exten(STRING,STRING,STRING) - (i,i,o)
  nondeterm member(WA_REFS_LIST,WA_REFERENCE) - (i,i)  
  new_time(INTEGER,STRING) - (i,o)
  proc_ConnectError( SOCKET ) - (i)
  proc_content(INTEGER,WA_REFERENCE,INTEGER) - (i,i,i)  
  proc_first_code(INTEGER,WA_REFERENCE,CHAR,INTEGER,HEADERS_0,ENTITY_BODY_0,INTEGER,STRING) - (i,i,i,i,i,i,i,i)
  proc_resp(INTEGER,WA_REFERENCE,HTTPLAY_RESPONSE,INTEGER) - (i,i,i,i)
  replace_reffile(WA_REFS_LIST,WA_REFERENCE,WA_REFERENCE,WA_REFS_LIST) - (i,i,i,o)
  search_auth(INTEGER,WA_REFERENCE,INTEGER,HEADERS_0) - (i,i,i,i)
  search_loc(INTEGER,WA_REFERENCE,INTEGER,HEADERS_0) - (i,i,i,i)
  search_replace(STRING,STRING,STRING,STRING) - (i,i,i,o)
  search_subtype(HEADERS_0,STRING) - (i,o)
  send_next_req(INTEGER) - (i)
  set_timer(INTEGER,INTEGER) - (i,i)
  test_is_gif(INTEGER,WA_REFERENCE,INTEGER) - (i,i,i)
  test_new_is(INTEGER) - (i)
  test_rest(INTEGER,INTEGER) - (i,i)
  test_rest_tm(INTEGER,LONG) - (i,i)
  test_row_number(INTEGER,INTEGER) - (i,i)
  test_wa_answers_queue()
  trans_month(INTEGER,STRING) - (i,o)
  trans_wday(INTEGER,STRING) - (i,o)
  wa_err_findhost( INTEGER ) - (i)
  wa_event_eh : ehandler
  wa_process_answer(HTTPLAY_ANSWERS) - (i)
  what_rest_time(INTEGER,LONG,INTEGER) - (i,o,o)
  write_Data(INTEGER,STRING,ENTITY_BODY_0) - (i,i,i)
  STRING write_content(INTEGER,WA_REFERENCE,STRING,ENTITY_BODY_0) - (i,i,i,i)
  write_done_lst()
  update_file_refs(INTEGER,INTEGER,WA_REFERENCE, WA_REFERENCE) - (i,i,i,i)
  update_parents(INTEGER,INTEGER,WA_REFERENCE,WA_REFERENCE,WA_REFS_LIST) - (i,i,i,i,i)
  update_parentfile(STRING,STRING,STRING) - (i,i,i)
  
CLAUSES
  wa_init():-
        not(wa_window(_)),
        ScreenWindow = cast(window,vpi_GetAttrVal(attr_screen_window)),
        WinDefs = [dlg(wdef(wd_ModeLess,rct(0,0,0,0),"",u_Pixels),[wsf_Invisible,wsf_Disabled])],
        CreateData = cast(long,0),
        win_CreateDynDialog(ScreenWindow,WinDefs,wa_event_eh,CreateData),
        !.
  wa_init().

  wa_event_eh(Win,e_Create(_),0):-
        assert(wa_window(Win)),
        win_EnableHook(Win, b_true),
        !.
  wa_event_eh(_Win,e_Native(wa_mess,_WParam,_LParam),0):-
        httplay_GetAnswer(Answ),!,
	assertz(wa_answers(Answ)),
	test_wa_answers_queue(),
        !.
  wa_event_eh(_Win,e_Timer(T_id),0):-
  	retract(row_timer(Row,T_id,Rest)),!,
	timer_Kill(T_id),
	test_rest_tm(Row,Rest),
  	!.
  wa_event_eh(_Win,e_Native(wa_next,_,_LParam),0):-
  	test_wa_answers_queue(),fail.
  wa_event_eh(_Win,e_Native(wa_next,Row,_LParam),0):-
	row_remote(Row,_,_,_,Lv),
  	Lv >= 0,!,
  	test_rest(Row,Lv).
  wa_event_eh(_Win,e_Native(wa_next,Row,_LParam),0):-
	row_remote(Row,_,_,_,Lv),
	Lv < 0,!,
  	test_entry_timer(Row),
	uri_entry(Row,_,Uri,_,_,_,_,_),
	retractall(done_lst(Row,_)),
  	assert(done_lst(Row,Uri)),  	
  	make_done_lst(),
  	retract(row_errors(Row,Err_cnt)),
	format(SSS,"Row %d: All done ( %d errors )",Row,Err_cnt),
	write_log(0,SSS),
	clean_row(Row),
	check_new(Row,Uri),
	grid_win(Gwin),
	grid_Invalidate(Gwin,grid_area(Row,Row,3,3)),
	mem_systemFreeGStack(),
	!.

  test_wa_answers_queue():-
  	wa_answers(Answ),
  	not(on_work),
  	assert(on_work),
  	retract(wa_answers(Answ)),
        wa_process_answer(Answ),
        !.
  test_wa_answers_queue().
  	
  wa_process_answer(ok(Req,Resp)):-
	retract(to_answer_http(Row,Path,Req,Lv)),
	retract(to_send_req(Row,Path,Lv,b_true)),!,
	proc_resp(Row,Path,Resp,Lv),
	vpi_ProcessEvents(),
	mem_systemFreeGStack(),
	retract(on_work),
	wa_window(Wn),
	win_PostEvent(Wn,e_Native(wa_next,Row,0)),
	!.
  wa_process_answer(httplay_error(Req,Err)):-
	retract(to_answer_http(Row,Path,Req,Lv)),
	retractall(to_send_req(Row,Path,Lv,b_true)),!,
 	retractall(already_req(Row,Path,_,_)),
  	get_curtime(Dte),
	assert(already_req(Row,Path,Dte,b_false)),
	get_ErrorDescr(Err,ErrorMsg),
	format(S,"Row %d: HTTP Layer informs about an error %s",Row,ErrorMsg),
	write_log(0,S),
	increm_errors(Row),
	vpi_ProcessEvents(),
	retract(on_work),
	wa_window(Wn),
	win_PostEvent(Wn,e_Native(wa_next,Row,0)),	
	!.
  wa_process_answer(_).

  
  wa_errproc(100,Err):-
  	format(S,"An error occurred while writing file: result file of addresses %U",Err),
	write_log(0,S),
	!.
  wa_errproc(200,Err):-
  	format(S,"An error occurred while writing file: log file %U",Err),
	dlg_error(S),
	!.
  wa_errproc(250,Err):-
  	format(S,"An error occurred while writing file: debug log file %U",Err),
	dlg_error(S),
	!.
  wa_errproc(300,Err):-
  	format(S,"An error occurred while sending a message %U",Err),
	write_log(0,S),
	!.
  wa_errproc(301,Err):-
  	format(S,"An error occurred while sending a mail %U",Err),
	write_log(0,S),
	!.
  wa_errproc(Row,Err):-
  	format(S,"Row %d: An error occurred %U",Row,Err),
	write_log(0,S),
	increm_errors(Row),
	!.

  get_ErrorDescr(Err,ErrorMsg):-
	errormsg("prolog.err",Err,ErrorMsg,_),!.
  get_ErrorDescr(Err,ErrorMsg):-
  	format(ErrorMsg,"%U",Err).

  test_rest(Row,Lv):-
  	send_next_req(Row),
 	not(to_send_req(Row,_,Lv,b_true)),  
  	retract(row_remote(Row,Host,Port,Pr,Lv)),!,
%beep,
	Cl = Lv - 1,
	test_row_number(Row,Cl),
  	assert(row_remote(Row,Host,Port,Pr,Cl)),
	vpi_ProcessEvents(),
	wa_window(Wn),
	win_PostEvent(Wn,e_Native(wa_next,Row,0)),
	!.
  test_rest(Row,_):-
  	format(Str_state,"Row %d: Waiting for response...",Row),
  	write_state(Str_state).

  test_row_number(_, -1):-!.
  test_row_number(_, 0):-!.  
  test_row_number(Row, Cl):-
	uri_entry(Row,_,_,_,setts(Lv_orig_str,_,_,_,_),_,_,_),
	str_int(Lv_orig_str,Lv_orig),
	Lv_next = Lv_orig - Cl + 1,
	format(SS,"Row %d: Next level: %d",Row,Lv_next),
	write_log(1,SS),!.

  con_hndl(S,e_Connect(S)):-
  	retract(to_conn(S,Row,_,_,Path)),
  	trap(msglay_close(S),E,wa_errproc(Row,E)),
	format(Str,"Row %d: Host found in LAN",Row),
	write_log(1,Str),  	
  	wa_window(Wa_win),
  	row_remote(Row,_,_,_,Lv),
	first_call_file(Row,Path,Cache_name),
  	assert(to_send_req(Row,wa_ref(Path,Cache_name),Lv,b_false)),
	format(SS,"Row %d: Next level: 1",Row),
	write_log(1,SS), 
	win_PostEvent(Wa_win,e_Native(wa_next,Row,0)),
  	!.
  con_hndl( S, e_Error( msglay_errEvConnect )):- 	proc_ConnectError( S ),!.
  con_hndl( S, e_Error( msglay_errEventConnect( _ ))):- proc_ConnectError( S ),!.
  con_hndl(_,e_Close(_)):-!.
  con_hndl(S,e_ReadBin(_)):- % there mustn't any receives
  	to_conn(S,Row,Host,Port,_Path),
  	retract(to_conn(S,Row,Host,Port,_Path)),!.
  con_hndl(S,_):-	% if msglay_close fails
  	retract(to_conn(S,Row,_Host,_Port,_Path)),
  	wa_window(Wa_win),
  	win_PostEvent(Wa_win,e_Native(wa_next,Row,0)),!.
  	
  proc_ConnectError( S ):-  	
    	options(_,_,proxy(1,ProxyName,ProxyPort),_,_,_),
  	to_conn(S,Row,Host,Port,_Path),
  	trap(msglay_close(S),E,wa_errproc(Row,E)),
 	retract(to_conn(S,Row,Host,Port,Path)),
  	format(Str,"Row %d: Using proxy %s:%U",Row,ProxyName,ProxyPort),
	write_log(1,Str),
  	wa_window(Wa_win),
  	retract(row_remote(Row,Host,Port,_,Lv)),
  	assert(row_remote(Row,Host,Port,1,Lv)),
  	first_call_file(Row,Path,Cache_name),
  	assert(to_send_req(Row,wa_ref(Path,Cache_name),Lv,b_false)),
	format(SS,"Row %d: Next level: 1",Row),
	write_log(1,SS),   	
	win_PostEvent(Wa_win,e_Native(wa_next,Row,0)),
	!.
  proc_ConnectError( S ):-
  	options(_,_,proxy(0,_,_),_,_,_),
  	to_conn(S,Row,Host,Port,_Path),
  	trap(msglay_close(S),E,wa_errproc(Row,E)),
  	retract(to_conn(S,Row,Host,Port,_Path)),
  	format(Str,"Row %d: Unable to find to a host %s:%U",Row,Host,Port),
  	write_log(0,Str),
  	increm_errors(Row),
  	wa_err_findhost(Row),
	!.
  proc_ConnectError( S ):-				% if msglay_close fails
  	retract(to_conn(S,Row,_Host,_Port,_Path)),
  	wa_window(Wa_win),
  	win_PostEvent(Wa_win,e_Native(wa_next,Row,0)),!.
	

  
  find_host(Row,Host,Port,Path):-
	trap(S = msglay_connect(Host,Port,con_hndl,[]),_,true),
	upper_lower(Host,Host_l),
	assert(to_conn(S,Row,Host_l,Port,Path)),
	!.
  find_host(Row,Host,Port,Path):- % unable to go to socket_connect (i.e. get hostname)- go through proxy
  	options(_,_,proxy(1,ProxyName,ProxyPort),_,_,_),!,
  	retract(row_remote(Row,Host,Port,_,Lv)),
  	assert(row_remote(Row,Host,Port,1,Lv)),
  	format(Str,"Row %d: Using proxy %s:%U",Row,ProxyName,ProxyPort),
	write_log(0,Str),  	
  	wa_window(Wa_win),
	first_call_file(Row,Path,Cache_name),
 	assert(to_send_req(Row,wa_ref(Path,Cache_name),Lv,b_false)),
	format(SS,"Row %d: Next level: 1",Row),
	write_log(1,SS), 	
	win_PostEvent(Wa_win,e_Native(wa_next,Row,0)),
  	!.
  find_host(Row,Host,Port,_):-
  	options(_,_,proxy(0,_,_),_,_,_),!,
  	format(Str,"Row %d: Unable to find to a host %s:%U",Row,Host,Port),
  	write_log(1,Str),
  	increm_errors(Row),
  	wa_err_findhost(Row),
	!.

  first_call_file(Row,_,Cache_name):-
  	file_refs(Row,wa_ref(_,Cache_name),_,[]),!.
  first_call_file(Row,Path,Cache_name):-
  	uri_entry(Row,_,_,_,setts(_,_,_,TargDir,_),_,_,_),
  	make_unique_cache_name(TargDir,Cache_name),
	assert(file_refs(Row,wa_ref(Path,Cache_name),[],[])),!.
  
  wa_err_findhost(Row):-
	retract(already_req(Row,PathFile,Date,b_false)),
		assert(already_req(Row,PathFile,Date,b_true)),
	fail.
  wa_err_findhost(Row):-
  	retractall(to_conn(_,Row,_,_,_)),
  	retractall(row_remote(Row,_,_,_,_)),
  	test_entry_timer(Row),
  	retract(row_errors(Row,Err_cnt)),
	format(SSS,"Row %d: Failed ( %d errors )",Row,Err_cnt),
	write_log(0,SSS),
	grid_win(Gwin),
	grid_Invalidate(Gwin,grid_area(Row,Row,3,3)),
	!.
  	
  form_req_proxy(Row,wa_ref(Path,File),full_req(req_line("GET",absoluteURI("http",Rest),http_ver(1,0)),[pragma(["no-cache"]),if_modified_since(Date),unrecognized_header("Accept","*/*")],[])):-
  	already_req(Row,wa_ref(Path,File),Date,b_false),
  	row_remote(Row,Host,Port,1,_),
  	format(Rest,"%s:%U%s",Host,Port,Path),
  	!.
  form_req_proxy(Row,wa_ref(Path,File),full_req(req_line("",absoluteURI("",""),http_ver(1,0)),[],[])):-
  	already_req(Row,wa_ref(Path,File),_,b_true),!,
  	fail.
  form_req_proxy(Row,wa_ref(Path,_),full_req(req_line("GET",absoluteURI("http",Rest),http_ver(1,0)),[pragma(["no-cache"]),unrecognized_header("Accept","*/*")],[])):-
  	row_remote(Row,Host,Port,1,_),
  	format(Rest,"%s:%U%s",Host,Port,Path),
  	!.
  	
  form_req_local(Row,wa_ref(Rel_path,File),full_req(req_line("GET",rel_path(Path,Params,Query),http_ver(1,0)),[pragma(["no-cache"]),if_modified_since(Date),unrecognized_header("Accept","*/*")],[])):-
  	already_req(Row,wa_ref(Rel_path,File),Date,b_false),
  	parse_path(Rel_path,Path,Params,Query),
  	!.
  form_req_local(Row,wa_ref(Rel_path,File),full_req(req_line("",rel_path("",[],""),http_ver(1,0)),[],[])):-
  	already_req(Row,wa_ref(Rel_path,File),_,b_true),!,
  	fail.
  form_req_local(_,wa_ref(Rel_path,_),full_req(req_line("GET",rel_path(Path,Params,Query),http_ver(1,0)),[pragma(["no-cache"]),unrecognized_header("Accept","*/*")],[])):-
  	parse_path(Rel_path,Path,Params,Query),!.

  form_req_lst(_,_,_,[],[]):-!.
  form_req_lst(0,Row,Lv,[PathFile|LP],[Req|ResL]):-
  	form_req_local(Row,PathFile,Req),
  	PathFile = wa_ref(Path,_),
  	format(SSS,"Row %d: Fetching address %s",Row,Path),
	write_log(1,SSS),
	assert(to_answer_http(Row,PathFile,Req,Lv)),
  	assert(to_send_req(Row,PathFile,Lv,b_true)),!,
  	form_req_lst(0,Row,Lv,LP,ResL).
  form_req_lst(0,Row,Lv,[_|LP],ResL):-!,
  	form_req_lst(0,Row,Lv,LP,ResL).
  form_req_lst(1,Row,Lv,[PathFile|LP],[Req|ResL]):-
  	form_req_proxy(Row,PathFile,Req),
  	PathFile = wa_ref(Path,_),
  	format(SSS,"Row %d: Fetching address %s",Row,Path),
	write_log(1,SSS),
	assert(to_answer_http(Row,PathFile,Req,Lv)),
  	assert(to_send_req(Row,PathFile,Lv,b_true)),!,
  	form_req_lst(1,Row,Lv,LP,ResL).
  form_req_lst(1,Row,Lv,[_|LP],ResL):-!,
  	form_req_lst(1,Row,Lv,LP,ResL).
  	  	
  clean_row(Row):-
  	retract(already_req(Row,wa_ref(Url,F_name),_,b_false)),
  		retractall(file_refs(Row,wa_ref(Url,F_name),_,_)),
  		F_name <> "",
  		trap(deletefile(F_name),_,true),
  	fail.
  clean_row(Row):-
  	retractall(to_send_req(Row,_,_,_)),
  	retractall(to_conn(_,Row,_,_,_)),
  	retractall(to_answer_http(Row,_,_,_)),
  	retractall(row_remote(Row,_,_,_,_)),
  	retractall(row_errors(Row,_)),
  	retractall(on_work),
  	retractall(wa_answers(_)),
  	!.
  	
  send_next_req(Row):-
  	row_remote(Row,_,_,1,Lv),
	findall(PathFile,to_send_req(Row,PathFile,Lv,b_false), ListPathsFiles ),
	retractall(to_send_req(Row,_,Lv,b_false)),
	not(ListPathsFiles = []),
	options(Nb_conn,_,proxy(1,ProxyName,ProxyPort),_,_,_),
  	form_req_lst(1,Row,Lv,ListPathsFiles,ListReqs),
  	not(ListReqs = []),
  	wa_window(WA_win),
 	httplay_SendRequests(WA_win,wa_mess,ProxyName,ProxyPort,ListReqs,Nb_conn),!.
  send_next_req(Row):-
  	row_remote(Row,Host,Port,0,Lv),
	findall(PathFile,to_send_req(Row,PathFile,Lv,b_false), ListPathsFiles ),
	retractall(to_send_req(Row,_,Lv,b_false)),
	not(ListPathsFiles = []),	
  	form_req_lst(0,Row,Lv,ListPathsFiles,ListReqs),
  	not(ListReqs = []),
  	wa_window(WA_win),
  	options(Nb_conn,_,_,_,_,_),
 	httplay_SendRequests(WA_win,wa_mess,Host,Port,ListReqs,Nb_conn),!.
  send_next_req(_).
  
  get_sysdate(http_date(WeekDay,date(Day,Mon,Year),time(Hour,Minute,Second))):-
IFDEF os_nt
  	api_GetSystemTime( Tm ),
  	Tm = systemtime(Year_us,Month,DayOfWeek,Day_us,Hour_us,Minute_us,Second_us,_),
  	trans_month(Month,Mon),trans_wday(DayOfWeek,WeekDay),
  	Year = cast( INTEGER, Year_us ),
  	Day = cast( INTEGER, Day_us ),
  	Hour = cast( INTEGER, Hour_us ),
  	Minute = cast( INTEGER, Minute_us ),
  	Second = cast( INTEGER, Second_us ),
%	WeekDay="Mon",Day=1,Mon="Jan",Year=1996,Hour=0,Minute=0,Second=0,
ELSEDEF
	WeekDay="Mon",Day=1,Mon="Jan",Year=1996,Hour=0,Minute=0,Second=0,  % it is not possible at all
ENDDEF
  	!.
  
  get_curtime(http_date(WeekDay,date(Day,Mon,Year),time(Hours,Minutes,Seconds))):-
	date(Year,Month,Day,DayOfWeek),
	trans_month(Month,Mon),trans_wday(DayOfWeek,WeekDay),
	time(Hours,Minutes,Seconds,_),
	!.
  	
  trans_month(1,"Jan").trans_month(2,"Feb").trans_month(3,"Mar").trans_month(4,"Apr").trans_month(5,"May").
  trans_month(6,"Jun").trans_month(7,"Jul").trans_month(8,"Aug").trans_month(9,"Sep").trans_month(10,"Oct").
  trans_month(11,"Nov").trans_month(12,"Dec").
  
  trans_wday(0,"Sun").trans_wday(1,"Mon").trans_wday(2,"Tue").trans_wday(3,"Wed").trans_wday(4,"Thu").
  trans_wday(5,"Fri").trans_wday(6,"Sat").
  
  add_new_req(_Row,_,[]):-!.
  add_new_req(Row,Lv,[PathFile|L]):-
  	CL = Lv - 1,
  	test_is_gif(Row,PathFile,CL),!,
  	add_new_req(Row,Lv,L).
  add_new_req(Row,Lv,[_|L]):-!,
  	add_new_req(Row,Lv,L).

  test_is_gif(Row,PathFile,CL):-
  	CL > 0,
  	assert(to_send_req(Row,PathFile,CL,b_false)),!.
  test_is_gif(Row,PathFile,CL):-
  	CL = 0,
  	PathFile = wa_ref(PAth,_),
  	filenameext(Path,_,Ext),!,
	upper_lower(Ext,Ext_l),
  	what_ext(Ext_l),
  	assert(to_send_req(Row,PathFile,CL,b_false)).
  test_is_gif(_,_,_).
  	
  what_ext(".gif"):-!.
  what_ext(".jpg"):-!.
  what_ext(".jpeg"):-!.
  what_ext(".jg"):-!.
  what_ext(".tiff"):-!.
  what_ext(".ief"):-!.
  what_ext(".x-bitmap"):-!.
  what_ext(".x-rgb"):-!.
  what_ext(".bmp"):-!.
  what_ext(".ms-bmp"):-!.
  what_ext(".quicktime"):-!.
  what_ext(".mpeg"):-!.
  what_ext(".x-mpeg2"):-!.
  what_ext(".x-msvideo"):-!.
  what_ext(".wav"):-!.
  what_ext(".x-wav"):-!.
  what_ext(".x-pn-realaudio"):-!.
  what_ext(".au"):-!.
  what_ext(".aiff"):-!.
  what_ext(".aif"):-!.
  what_ext(".x-aiff"):-!.
  what_ext(".basic"):-!.
  what_ext(".au"):-!.
  what_ext(".zip"):-!.
  what_ext(".exe"):-!.
  what_ext(_):-fail.
 
%predicate transfer a UNIX-name into DOS-name - (i,o),(o,i)
  change_slash(StrDos,StrUnix):-
        bound(StrDos),
        searchchar(StrDos,'\\',FoundPos),
        NB=FoundPos-1,
        frontstr(NB,StrDos,StartString,RestString),
        frontchar(RestString,'\\',Rest1),
        format(Str,"%/%",StartString,Rest1),!,
        change_slash(Str,StrUnix).
  change_slash(StrDos,StrUnix):-
        bound(StrUnix),
        searchchar(StrUnix,'/',FoundPos),
        NB=FoundPos-1,
        frontstr(NB,StrUnix,StartString,RestString),
        frontchar(RestString,'/',Rest1),
        format(Str,"%\\%",StartString,Rest1),!,
        change_slash(StrDos,Str).
  change_slash(Str,Str):-!.

  write_content(Row,wa_ref(Path,FileName),SubType,Data,NewFileName):-
  	uri_entry(Row,_,_,_,setts(_,_,_,TargDir,_),_,_,_),
  	check_file_cache_name(TargDir,FileName,SubType,NewFileName),
  	write_Data(Row,NewFileName,Data),
	update_file_refs(0,Row,wa_ref(Path,FileName),wa_ref(Path,NewFileName)),
	retractall(already_req(Row,wa_ref(Path,FileName),_,_)),
	get_sysdate(Dte),
	assert(already_req(Row,wa_ref(Path,NewFileName),Dte,b_true)),
	!.
  write_content(_,_,_,_,"").

  write_Data(Row,NewFileName,[]):-					% some servers can return 200 and empty body
	trap(openwrite(file_wr_cont,NewFileName),E,wa_errproc(Row,E)),
	closefile(file_wr_cont),	
  	!.
  write_Data(Row,NewFileName,[entity_body(Bin)|_]):-
	trap(openwrite(file_wr_cont,NewFileName),E,wa_errproc(Row,E)),
	writedevice(Old),
	writedevice(file_wr_cont),
	trap(writeblock(0,Bin),E1,wa_errproc(Row,E1)),
	writedevice(Old),
	closefile(file_wr_cont),
	!.
  	
  update_file_refs(_,_,wa_ref(Path,OldFileName),wa_ref(Path,NewFileName)):-
  	0 = str_StrCmpi(OldFileName,NewFileName),!.
  update_file_refs(Kind,Row,PathFile,NewPathFile):-
  	file_refs(Row,PathFile,_,ParentRefs),
  	update_parents(Kind,Row,PathFile,NewPathFile,ParentRefs),
  	!.
  	
  update_parents(_,_,_,_,[]):-!.
  update_parents(Kind,Row,PathFile,NewPathFile,[Node|L]):-
  	retract(file_refs(Row,Node,SonRefsOld,ParentRefs)),
  	replace_reffile(SonRefsOld,PathFile,NewPathFile,SonRefsNew),
  	assert(file_refs(Row,Node,SonRefsNew,ParentRefs)),
  	Node = wa_ref(_,NodeFileName),
  	check_update_parent_file(Kind,PathFile,NewPathFile,NodeFileName),!,
  	update_parents(Kind,Row,PathFile,NewPathFile,L).
		
  replace_reffile([wa_ref(A,B)|L],wa_ref(C,D),NewEl,[NewEl|L]):-
  	0 = str_StrCmpi(A,C),
  	0 = str_StrCmpi(B,D),!.
  replace_reffile([El1|L],El2,NewEl,[El1|NewList]):-!,
	replace_reffile(L,El2,NewEl,NewList).

  check_update_parent_file(1,_,_,_):-!.
  check_update_parent_file(0,wa_ref(Path,FileName),wa_ref(Path,NewFileName),ParentFile):-
  	filenamepath(FileName,_,Name),
  	frontchar(Name,'w',_),
	filenamepath(NewFileName,_,NewName),
	update_parentfile(ParentFile,Name,NewName),
	!.
  check_update_parent_file(0,wa_ref(Path,FileName),wa_ref(Path,NewFileName),ParentFile):-	% FileName is an absolute reference - from previous last level
  	filenamepath(FileName,_,Name),
  	not(frontchar(Name,'w',_)),
	filenamepath(NewFileName,_,NewName),
	concat(FileName,"\"",FileName1),
	concat(NewName,"\"",NewName1),
	update_parentfile(ParentFile,FileName1,NewName1),
	!.

  update_parentfile("",_,_):-!.		% for first (root) reference
  update_parentfile(ParentFile,OldName,NewName):-
%2Do  
  	file_str(ParentFile,ParentFile_str),
  	search_replace(ParentFile_str,OldName,NewName,ParentFile_str_new),
  	deletefile(ParentFile),
  	file_str(ParentFile,ParentFile_str_new),!.
 
  check_file_cache_name(_,FileName,SubType,NewFileName):-
  	filenamepath(FileName,_,Name),
  	frontchar(Name,'w',_),						% !!! every WebAgent cache name begins with wa
  	make_new_exten(FileName,SubType,NewFileName),
  	!.
  check_file_cache_name(TargDir,FileName,SubType,NewFileName):-		% for last level - user can increment => no fetching
  	filenamepath(FileName,_,Name),
  	not(frontchar(Name,'w',_)),					% !!! every WebAgent cache name begins with wa
  	make_unique_cache_name(TargDir,F_name),
  	make_new_exten(F_name,SubType,NewFileName),
  	!.
  	
  make_new_exten(FileName,SubType,NewFileName):-
    	deletefile(FileName),
	filenameext(FileName,MainPart,_),
	concat(".",SubType,SbType),
	filenameext(NewFileName,MainPart,SbType),!.
  
  search_replace(Str_in,Old,_,Str_in):-
	not(searchstring(Str_in,Old,_)),!.
  search_replace(Str_in,Old,New,Str_out):-
  	searchstring(Str_in,Old,FoundPos),
  	str_len(Old,L),
  	FP = FoundPos - 1,
	frontstr(FP,Str_in,StartString,RestString),
	frontstr(L,RestString,_,Rest),!,
	search_replace(Rest,Old,New,Str_out1),
	format(Str_out,"%s%s%s",StartString,New,Str_out1).

  get_path(PathWhole,First):-
  	parse_path(PathWhole,Path,_,_),
	frontchar(Path,'/',P1),
	change_slash(Pth,P1),
	filenamepath(Pth,P2,_),
	del_last_slash(P2,F),
	change_slash(F,First),
  	!.

  del_last_slash(P,Res):-  	
	str_len(P,L),
	L1 = L - 1,
	frontstr(L1,P,Res,RestString),
	RestString = "\\",!.
  del_last_slash(S,S).
  
  proc_resp(Row,PathFile,simple_resp(Data),Lv):-
  	F_name = write_content(Row,PathFile,"txt",Data),
  	F_name <> "",
  	test_new_is(Row),
  	Lv > 0,
	format(SSS,"Row %d: Simple response",Row),
	write_log(1,SSS),
	PathFile = wa_ref(Path,_),
  	retract(file_refs(Row,PathFile,_,Parent_list)),
  	assert(file_refs(Row,wa_ref(Path,F_name),[],Parent_list)),	
  	proc_content(Row,wa_ref(Path,F_name),Lv),!.
  proc_resp(_,_,simple_resp([_]),_):-!.
  proc_resp(Row,PathFile,full_resp(res_line(_,Cod,Descr),H,E),Lv):-
  	str_int(Code_str,Cod),
  	PathFile = wa_ref(Path,_),
	format(SSS,"Row %d: %s - %d %s",Row,Path,Cod,Descr),
	write_log(1,SSS),
	frontchar(Code_str,F_char,_),
  	proc_first_code(Row,PathFile,F_char,Cod,H,E,Lv,Descr),!.  	
  proc_resp(_,_,_,_). 			% proc_first_code can fail
  	
  proc_first_code(Row,PathFile,'1',Cod,_,_,_,Descr):-
 	retractall(already_req(Row,PathFile,_,_)),
  	get_curtime(Dte),
	assert(already_req(Row,PathFile,Dte,b_false)),
	PathFile = wa_ref(Path,_),
	format(SSS,"Row %d: %s - %d, %s: unprocessed code!",Row,Path,Cod,Descr),
	write_log(0,SSS),
	increm_errors(Row),
	!.
  proc_first_code(Row,PathFile,'2',200,_,_,_,_):-
  	retract(row_auth_in_process( Row, PathFile )),fail.
  proc_first_code(Row,PathFile,'2',200,H,Data,Lv,_):-
  	search_subtype(H,SubType),
  	F_name = write_content(Row,PathFile,SubType,Data),
  	F_name <> "",
  	test_new_is(Row),
  	Lv > 0,
  	PathFile = wa_ref(Path,_),  	
  	retract(file_refs(Row,PathFile,_,Parent_list)),
  	assert(file_refs(Row,wa_ref(Path,F_name),[],Parent_list)),
  	proc_content(Row,wa_ref(Path,F_name),Lv),
	!.
  proc_first_code(_,_,'2',200,_,_,_,_):-!.
  	
  proc_first_code(Row,PathFile,'2',Cod,_,_,_,Descr):-
  	retractall(already_req(Row,PathFile,_,_)),
  	get_curtime(Dte),
	assert(already_req(Row,PathFile,Dte,b_false)),
	PathFile = wa_ref(Path,_),
	format(SSS,"Row %d: %s - %d, %s: unprocessed code!",Row,Path,Cod,Descr),
	write_log(0,SSS),
	increm_errors(Row),
	!.  	
  proc_first_code(Row,PathFile,'3',301,H,_,Lv,_):-
  	search_loc(Row,PathFile,Lv,H),!.
  proc_first_code(Row,PathFile,'3',302,H,_,Lv,_):-
  	search_loc(Row,PathFile,Lv,H),!.
  proc_first_code(Row,PathFile,'3',304,_,_,Lv,_):-
 	proc_content(Row,PathFile,Lv),
	already_req(Row,PathFile,Dte,_),			% it MUST exist!
	retractall(already_req(Row,PathFile,Dte,_)),
	assert(already_req(Row,PathFile,Dte,b_true)),	
	!.
  proc_first_code(_,_,'3',304,_,_,_,_):-!.
  proc_first_code(Row,PathFile,'3',Cod,_,_,_,Descr):-
    	retractall(already_req(Row,PathFile,_,_)),
  	get_curtime(Dte),
	assert(already_req(Row,PathFile,Dte,b_false)),
	PathFile = wa_ref(Path,_),
	format(SSS,"Row %d: %s - %d, %s: unprocessed code!",Row,Path,Cod,Descr),
	write_log(0,SSS),
	increm_errors(Row),	
	!.
  proc_first_code(Row,PathFile,'4',401,H,_,Lv,_):-
  	not(row_auth_in_process( Row, PathFile )),
  	search_auth(Row,PathFile,Lv,H),!.
  proc_first_code(Row,PathFile,'4',401,_,_,_,_):-
  	retract(row_auth_in_process( Row, PathFile )),
  	PathFile = wa_ref( Path, _ ),
  	format( SSS, "Row %d: Authorization for %s failed!", Row, Path ),
	write_log(0,SSS),
	increm_errors(Row),
  	!.
  proc_first_code(Row,PathFile,'4',Cod,_,_,_,Descr):-
  	retractall(already_req(Row,PathFile,_,_)),
  	get_curtime(Dte),
	assert(already_req(Row,PathFile,Dte,b_false)),
	PathFile = wa_ref(Path,_),
	format(SSS,"Row %d: %s - %d, %s: unprocessed code!",Row,Path,Cod,Descr),
	write_log(0,SSS),
	increm_errors(Row),
  	!.
  proc_first_code(Row,PathFile,'5',Cod,_,_,_,Descr):-
    	retractall(already_req(Row,PathFile,_,_)),
    	get_curtime(Dte),
	assert(already_req(Row,PathFile,Dte,b_false)),
	PathFile = wa_ref(Path,_),
	format(SSS,"Row %d: %s - %d, %s: unprocessed code!",Row,Path,Cod,Descr),
	write_log(0,SSS),
	increm_errors(Row),
	!.
  
  search_loc(Row,PathFile,_,[]):-
  	retractall(already_req(Row,PathFile,_,_)),
  	get_curtime(Dte),
	assert(already_req(Row,PathFile,Dte,b_false)),
	format(SSS,"Row %d: No Location header - unprocessed code!",Row),
	write_log(0,SSS),
	increm_errors(Row),
  	!.
  search_loc(Row,PathFile,Lv,[location(Sheme,Rest)|_]):-
  	format(S,"%s:%s",Sheme,Rest),
  	parse_uri(S,_,Host,Port,Path_new),
  	row_remote(Row,Host,Port,_,_),
  	retractall(already_req(Row,PathFile,_,_)),
  	PathFile = wa_ref(_,FileName),
  	update_file_refs(1,Row,PathFile,wa_ref(Path_new,FileName)),	% update of parent file is not necessary
	assert(to_send_req(Row,wa_ref(Path_new,FileName),Lv,b_false)),
  	!.
  search_loc(Row,PathFile,_,[location(Sheme,Rest)|_]):-
  	format(S,"%s:%s",Sheme,Rest),
  	parse_uri(S,_,Host,Port,_),
  	not(row_remote(Row,Host,Port,_,_)),
  	retractall(already_req(Row,PathFile,_,_)),
  	get_curtime(Dte),
	assert(already_req(Row,PathFile,Dte,b_false)),	% a reference to other host ( which is not currently processing)
  	!.
  search_loc(Row,_PathFile,_,[location(Sheme,Rest)|_]):-
  	format(AbsP,"%s:%s",Sheme,Rest),
  	not(parse_uri(AbsP,_,_,_,_)),
  	format(S,"Row %d: Invalid address %s",Row,AbsP),
  	write_log(0,S),
  	increm_errors(Row),
  	!.
  search_loc(Row,PathFile,Lv,[_|L]):-
  	search_loc(Row,PathFile,Lv,L).

PREDICATES
  send_auth_req(INTEGER,WA_REFERENCE,INTEGER,STRING) - (i,i,i,i)
  form_req_local_auth(INTEGER,WA_REFERENCE,STRING,HTTPLAY_REQUEST) - (i,i,i,o)
  form_req_proxy_auth(INTEGER,WA_REFERENCE,STRING,HTTPLAY_REQUEST) - (i,i,i,o)
  
CLAUSES
  search_auth(Row,PathFile,_,[]):-
  	retractall(already_req(Row,PathFile,_,_)),
    	get_curtime(Dte),
	assert(already_req(Row,PathFile,Dte,b_false)),
	PathFile = wa_ref(Path,_),
	format(SSS,"Row %d: Authorization for %s failed - known authorization sheme was not specified by a remote server!",Row,Path),
	write_log(0,SSS),
	increm_errors(Row),!.
  search_auth(Row,PathFile,Lv,[www_authenticate("Basic",_,_)|_]):-	%ignore params and realm
  	uri_entry(Row,_,_,_,setts(_,_,_,_,auth(b_true,NamePwd)),_,_,_),!,
  	term_bin(STRING,NamePwd_str,NamePwd),
  	send_auth_req(Row,PathFile,Lv,NamePwd_str),!.
  search_auth(Row,PathFile,_,[www_authenticate("Basic",_,_)|_]):-	%ignore params and realm
  	uri_entry(Row,_,_,_,setts(_,_,_,_,auth(b_false,_NamePwd)),_,_,_),!,
  	retractall(already_req(Row,PathFile,_,_)),
    	get_curtime(Dte),
	assert(already_req(Row,PathFile,Dte,b_false)),
	PathFile = wa_ref(Path,_),
	format(SSS,"Row %d: Authorization for %s failed - no parameters were specified for this entry!",Row,Path),
	write_log(0,SSS),
	increm_errors(Row),!.
  search_auth(Row,PathFile,Lv,[www_authenticate(Sheme,_,_)|L]):-
  	PathFile = wa_ref(Path,_),
	format(SSS,"Row %d: Authorization for %s - unrecognized authentication sheme %s!",Row,Path,Sheme),
	write_log(1,SSS),!,
  	search_auth(Row,PathFile,Lv,L).	
  search_auth(Row,PathFile,Lv,[_|L]):-!,
  	search_auth(Row,PathFile,Lv,L).

  send_auth_req(Row,PathFile,Lv,NamePwd):-
  	row_remote(Row,Host,Port,0,Lv),
  	form_req_local_auth(Row,PathFile,NamePwd,Req),
  	PathFile = wa_ref(Path,_),
  	format(SSS,"Row %d: Authoring address %s",Row,Path),
	write_log(1,SSS),
	assert(to_answer_http(Row,PathFile,Req,Lv)),
  	assert(to_send_req(Row,PathFile,Lv,b_true)),
  	wa_window(WA_win),
  	assert(row_auth_in_process( Row, PathFile )),
  	httplay_SendRequests(WA_win,wa_mess,Host,Port,[Req],1),!.
  send_auth_req(Row,PathFile,Lv,NamePwd):-
  	row_remote(Row,_,_,1,Lv),
	options(_,_,proxy(1,ProxyName,ProxyPort),_,_,_),
	form_req_proxy_auth(Row,PathFile,NamePwd,Req),
	PathFile = wa_ref(Path,_),
  	format(SSS,"Row %d: Authoring address %s",Row,Path),
	write_log(1,SSS),
	assert(to_answer_http(Row,PathFile,Req,Lv)),
  	assert(to_send_req(Row,PathFile,Lv,b_true)),
  	wa_window(WA_win),
  	assert(row_auth_in_process( Row, PathFile )),
 	httplay_SendRequests(WA_win,wa_mess,ProxyName,ProxyPort,[Req],1),!.
  send_auth_req(_,_,_,_).
  
  form_req_proxy_auth(Row,PathFile,NamePwd,full_req(req_line("GET",absoluteURI("http",Rest),http_ver(1,0)),[pragma(["no-cache"]),authorization(basic_credentials(NamePwd)),if_modified_since(Date),unrecognized_header("Accept","*/*")],[])):-
  	already_req(Row,PathFile,Date,b_false),
  	row_remote(Row,Host,Port,1,_),
  	PathFile = wa_ref(Path,_),
  	format(Rest,"%s:%U%s",Host,Port,Path),!.
  form_req_proxy_auth(Row,PathFile,_,full_req(req_line("",absoluteURI("",""),http_ver(1,0)),[],[])):-
  	already_req(Row,PathFile,_,b_true),!,fail.
  form_req_proxy_auth(Row,PathFile,NamePwd,full_req(req_line("GET",absoluteURI("http",Rest),http_ver(1,0)),[pragma(["no-cache"]),authorization(basic_credentials(NamePwd)),unrecognized_header("Accept","*/*")],[])):-
  	row_remote(Row,Host,Port,1,_),
  	PathFile = wa_ref(Path,_),
  	format(Rest,"%s:%U%s",Host,Port,Path),!.
  	
  form_req_local_auth(Row,PathFile,NamePwd,full_req(req_line("GET",rel_path(Path,Params,Query),http_ver(1,0)),[pragma(["no-cache"]),authorization(basic_credentials(NamePwd)),if_modified_since(Date),unrecognized_header("Accept","*/*")],[])):-
  	already_req(Row,PathFile,Date,b_false),
  	PathFile = wa_ref(Rel_path,_),
  	parse_path(Rel_path,Path,Params,Query),!.
  form_req_local_auth(Row,PathFile,_,full_req(req_line("",rel_path("",[],""),http_ver(1,0)),[],[])):-
  	already_req(Row,PathFile,_,b_true),!,fail.
  form_req_local_auth(_,PathFile,NamePwd,full_req(req_line("GET",rel_path(Path,Params,Query),http_ver(1,0)),[pragma(["no-cache"]),authorization(basic_credentials(NamePwd)),unrecognized_header("Accept","*/*")],[])):-
  	PathFile = wa_ref(Rel_path,_),
  	parse_path(Rel_path,Path,Params,Query),!.
  	
  search_subtype([],"html"):-!.			% no content-type found - let be html subtype
  search_subtype([content_type(_,SubType,_)|_],SubType):-!.
  search_subtype([_|L],SubType):-!,
  	search_subtype(L,Subtype).
  
  proc_content(Row,Node,Lv):-
  	file_refs(Row,Node,Common_lst,_),
  	not(Common_lst = []),
  	!,
  	uri_entry(Row,_,Uri,_,setts(_,FetchPath,_,_,_),_,_,_),
  	parse_uri(Uri,_,_,_,OriginalPath),
  	get_path(OriginalPath,OrigPath),
	findall(Path_done,already_req(Row,Path_done,_,b_true),L1),
	findall(Path_done,to_send_req(Row,Path_done,_,_),L2),
	list_append(L1,L2,L_res),
	check_fetched_refs(L_res,Common_lst,Retr_refs1),
	check_other_dir_refs(OrigPath,FetchPath,Retr_refs1,Retr_refs),
  	add_new_req(Row,Lv,Retr_refs),!.
  proc_content(Row,wa_ref(Path,F_name),Lv):-
  	filenameext(F_name,_,Ext),
	upper_lower(Ext,Ext_l),	
  	0 = str_StrCmpi(Ext_l,".html"),
  	get_path(Path,Pth),
  	row_remote(Row,Host,_,_,_),
  	uri_entry(Row,_,Uri,_,setts(_,FetchPath,_,TargDir,_),_,_,_),
  	parse_uri(Uri,_,_,_,OriginalPath),
  	get_path(OriginalPath,OrigPath),
	NL = Lv - 1,
	findall(Path_done,already_req(Row,Path_done,_,_),L_all),
	findall(Path_done,already_req(Row,Path_done,_,b_true),L1),
	findall(Path_done,to_send_req(Row,Path_done,_,_),L2),
	list_append(L_all,L2,L_res),
	list_append(L1,L2,L_test),
	format(Str_state,"Row %d: Processing %s |",Row,Path),
	write_state(Str_state),
	0 = conv(L_res,"http",Host,Pth,TargDir,F_name,NL,OrigPath,FetchPath,Sons_Common_lst),
	!,on_work,
	create_sons_base(Row,wa_ref(Path,F_name),Sons_Common_lst),
	check_fetched_refs(L_test,Sons_Common_lst,Retr_refs1),
	check_other_dir_refs(OrigPath,FetchPath,Retr_refs1,Retr_refs),
	retract(file_refs(Row,wa_ref(Path,F_name),_,Parents_list)),
	assert(file_refs(Row,wa_ref(Path,F_name),Sons_Common_lst,Parents_list)),
	add_new_req(Row,Lv,Retr_refs),!.
  proc_content(Row,wa_ref(Path,F_name),_):-
  	filenameext(F_name,_,Ext),
	upper_lower(Ext,Ext_l),	
  	0 = str_StrCmpi(Ext_l,".html"),
  	format(SSS,"Row %d: Error while processing file %s -  a result of %s!",Row,F_name,Path),
	write_log(0,SSS),
	increm_errors(Row),!.
  proc_content(_,_,_).
	
  list_append([],L,L):-!.
  list_append([E1|L1],L,[E1|Res]):-list_append(L1,L,Res).

  create_sons_base(_,_,[]):-!.
  create_sons_base(Row,ParentNode,[Son_ref|L]):-
  	file_refs(Row,Son_ref,SonSons,SonParents),			% such son already exist?
  	not(SonParents = []),						% is it root ref?
  	retract(file_refs(Row,Son_ref,SonSons,SonParents)),
  	assert(file_refs(Row,Son_ref,SonSons,[ParentNode|SonParents])),!,
  	create_sons_base(Row,ParentNode,L).
  create_sons_base(Row,ParentNode,[Son_ref|L]):-
  	file_refs(Row,Son_ref,_,SonParents),			% such son already exist?
  	SonParents = [],!,
  	create_sons_base(Row,ParentNode,L).
  create_sons_base(Row,ParentNode,[Son_ref|L]):-
  	assert(file_refs(Row,Son_ref,[],[ParentNode])),!,
  	create_sons_base(Row,ParentNode,L).
  	
  member([wa_ref(El1,_)|_],wa_ref(El2,_)):-
  	0 = str_StrCmpi(El1,El2),!.
  member([_|L],F):-member(L,F).
  
  check_fetched_refs(_,[],[]):-!.
  check_fetched_refs(Already_lst,[Test_el|Test_lst],Out_lst):-
  	member(Already_lst,Test_el),!,
	check_fetched_refs(Already_lst,Test_lst,Out_lst).
  check_fetched_refs(Already_lst,[Test_el|Test_lst],[Test_el|Out_lst]):-!,
	check_fetched_refs(Already_lst,Test_lst,Out_lst).	
  	
  check_other_dir_refs(_,b_false,Lst_in,Lst_in):-!.	%FetchPath is not set
  check_other_dir_refs(OriginalPath,_,Lst_in,Lst_out):-
  	check_other_dir_refs(OriginalPath,Lst_in,Lst_out),!.
  	
  check_other_dir_refs(_,[],[]):-!.
  check_other_dir_refs(OriginalPath,[wa_ref(RefPath,Fname)|L],[wa_ref(RefPath,Fname)|L1]):-
  	0 = is_other_path(OriginalPath,RefPath),!,
  	check_other_dir_refs(OriginalPath,L,L1).
  check_other_dir_refs(OriginalPath,[_|L],L1):-!,
  	check_other_dir_refs(OriginalPath,L,L1).
  	
  is_other_path(_,Ref_in,0):-			% this is a ref. to gif, audio and so on.
	filenameext(Ref_in,_,Exten),
	upper_lower(Exten,Ext_l),
	what_ext(Ext_l),!.
  is_other_path(_,Ref_in,0):-			% this is a relational reference
	not(frontchar(Ref_in,'/',_)),!.
  is_other_path("/",_,0):-!.			% no path specified
  is_other_path(OriginalPath,Ref_in,0):-	% ref. belongs to current path
	frontchar(Ref_in,'/',Ref_in1),  	
  	concat(OriginalPath,_,Ref_in1),!.
  is_other_path(OriginalPath,Ref_in,1):-	% ref. to other dir-ry
	frontchar(Ref_in,'/',Ref_in1),	
  	not(concat(OriginalPath,_,Ref_in1)),!.
  
% result list processing 
  make_done_lst():-
  	not(done_lst(_,_)),!.
  make_done_lst():-
  	options(_,_,_,_,RS,_),
  	trap(openwrite(file_wr_cont,RS),E,wa_errproc(100,E)),
  	writedevice(Old),
	writedevice(file_wr_cont),
	trap(write("<html>\n"),E1,wa_errproc(100,E1)),
	trap(write("<BIG><B>WebAgent's result file of addresses:</B></BIG><br><br><br>\n"),E2,wa_errproc(100,E2)),
	writedevice(Old),
  	write_done_lst(),!.
  	
  write_done_lst():-
  	done_lst(Row,Uri),
	  	writedevice(Old),
  		writedevice(file_wr_cont),
		file_refs(Row,wa_ref(_,F_name),_,[]),
		trap(write("<a href=\"",F_name,"\">",Uri,"</a><br>\n"),E,wa_errproc(100,E)),
		writedevice(Old),
  	fail.
  write_done_lst():-
  	writedevice(Old),
	writedevice(file_wr_cont),
	trap(write("<html>"),E,wa_errproc(100,E)),
	writedevice(Old),
  	closefile(file_wr_cont),!.
  	
% new content => notify persons  	
  check_new(Row,URL):-
  	retract(new_content(Row)),
  	uri_entry(Row,_,_,_,setts(_,_,notify_setts(Notifs,ProfileName),_,_),_,_,_),
  	format(Comm,"WebAgent: new information fetched from %s",URL),
  	notify_send_notifications(Notifs,Comm, ProfileName ),!.
  check_new(_,_).
  
  test_new_is(Row):-
  	new_content(Row),!.
  test_new_is(Row):-
  	assert(new_content(Row)).
  	
% timer processing  	
  test_entry_timer(Row):-
  	uri_entry(Row,_,_,"",_,_,_,_),
  	change_state(Row,"Stop"),
	!.
  test_entry_timer(Row):-
	uri_entry(Row,_,_,Timer,_,_,_,_),
	str_int(Timer,Tm),
	retractall(row_next_timer(Row,_)),
	new_time(Tm,NextTimer),
	assert(row_next_timer(Row,NextTimer)),
	T_sec = Tm*60,
	set_timer(Row,T_sec),
	format(S,"Row %d: Timer starts",Row),
	write_log(1,S),
	change_state(Row,"Wait"),
	!.
  	
  set_timer(Row,Cur):-
  	wa_window(WA_win),
        what_rest_time(Cur,Nt,Rest),
        trap(WAtimer = timer_Set(WA_win, Nt),E,wa_errproc(Row,E)),
        retractall(row_timer(Row,_,_)),
        assert(row_timer(Row,WAtimer,Rest)),
        !.
        
  test_rest_tm(Row,0):-start_fetch(Row),!.
  test_rest_tm(Row,Rest_cur):-set_timer(Row,Rest_cur).
  
  what_rest_time(Net,Nt,0):-
  	Net <= 60,
  	Nt = Net*1000,!.
%  	Nt = Net*100,!.
  what_rest_time(Net,60000,Rest):-
  	Rest = Net - 60,!.

  start_fetch(Row):-
	retract(already_req(Row,PathFile,Date,b_true)),
		assert(already_req(Row,PathFile,Date,b_false)),
	fail.
  start_fetch(Row):-
  	uri_entry(Row,_,Uri,_,setts(Lv_str,_,_,_,_),_,_,_),
  	str_int(Lv_str,Lv),
  	parse_uri(Uri,_Sheme,Host,Port,Path),
  	format(S,"Row %d: Start fetching %s",Row,Uri),
  	write_log(0,S),  
	change_state(Row,"Fetch"),
  	assert(row_remote(Row,Host,Port,0,Lv)),
  	assert(row_errors(Row,0)),
 	find_host(Row,Host,Port,Path),
  	!.
  start_fetch(Row):- % parse_uri can fail
  	uri_entry(Row,_,Uri,_,_,_,_,_),
  	format(S,"Row %d: Invalid address %s",Row,Uri),
  	write_log(0,S),!.
  	
  stop_fetch(Row):-
  	change_state(Row,"Stop"),
  	clean_row(Row),
  	format(S,"Row %d: Fetch stops",Row),
  	write_log(1,S),
  	!.
  stop_fetch(_).
  
  stop_timer(Row):-
  	row_timer(Row,T_id,_),
	trap(timer_Kill(T_id),E,wa_errproc(Row,E)),
	retract(row_timer(Row,T_id,_)),
	format(S,"Row %d: Timer stops",Row),
	write_log(1,S),	
	!.
  stop_timer(_).
  	
  change_state(Row,Status):-
  	retract(uri_entry(Row,_,Uri,Timer,Path,Levels,Fc,Bc)),!,
  	assert(uri_entry(Row,Status,Uri,Timer,Path,Levels,Fc,Bc)),
	grid_win(G_win),
	grid_marker(G_win,Mark),
	change_st_test_marker(Row,Mark),
	!.

  change_st_test_marker(Row,grid_edit_cell(_,4)):-
	grid_win(G_win),  
  	grid_Invalidate(G_win,grid_area(Row,Row,1,1)),!.
  change_st_test_marker(Row,grid_edit_cell(_,2)):-
	grid_win(G_win),  
  	grid_Invalidate(G_win,grid_area(Row,Row,1,1)),!.  	
  change_st_test_marker(Row,Mark):-
	grid_win(G_win),
  	grid_marker(G_win,grid_no_marker),
	grid_Invalidate(G_win,grid_area(Row,Row,1,1)),
	grid_marker(G_win,Mark),!.

  restart_timer(Row):-
  	stop_timer(Row),
  	uri_entry(Row,"Wait",_,_,_,_,_,_),
  	test_entry_timer(Row),!.
  restart_timer(_).
  
  increm_errors(Row):-
  	retract(row_errors(Row,Old)),
  	New = Old + 1,
  	assert(row_errors(Row,New)),!.
  increm_errors(_).
  	
  new_time(Timer,Out):-
	time(Hours,Minutes,Seconds,_),
	H = Timer div 60,
	H1 = Hours + H,
	M1 = (Timer - H*60) + Minutes,
	check_rest(H1,M1,H2,M2),
	format(Out,"%d:%d:%d",H2,M2,Seconds),!.
  check_rest(H1,M1,H1,M1):-
  	H1 < 24,
  	M1 < 60,!.
  check_rest(H1,M1,H,M1):-
  	H1 >= 24,
  	M1 < 60,
  	H = H1 - 24,!.
  check_rest(H1,M1,H,M):-
  	H1 < 24,
  	M1 >= 60,
  	M2 = M1 - 60,
  	H2 = H1 + 1,!,
  	check_rest(H2,M2,H,M).
  check_rest(H1,M1,H,M):-
  	H1 >= 24,
  	M1 >= 60,
  	M2 = M1 - 60,
  	H2 = H1 - 23,!,
  	check_rest(H2,M2,H,M).
