/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  CONV
 FileName: CONV.PRO
 Purpose: WebAgent
 Written by: Konstantin Ivanov
 Comments: Retrieves hreferences from incoming file
******************************************************************************/

include "webagent.inc"
include "webagent.con"
include "hlptopic.con"

PREDICATES
  reverse(SLIST,SLIST)
  reverse(SLIST,SLIST,SLIST)
CLAUSES
  reverse(In,Out):-
	reverse(In,[],Out).

  reverse([],L,L).
  reverse([H|T],Current,L):-
	reverse(T,[H|Current],L).

DATABASE - int
 determ  nocopy cur_url(STRING,STRING,STRING,STRING,INTEGER,WA_REFS_LIST,STRING,BOOLEAN)
  	 cur_refs(WA_REFERENCE)
% determ  cur_filecont(STRING)

PREDICATES
  print_res(STRING,WA_REFS_LIST) - (i,i)
  print_res(STRING,SLIST) - (i,i)
  
  check_abs_rel(STRING,STRING) - (i,o)
  check_jumps(STRING,STRING,STRING) - (i,i,o)
  check_jump(STRING,STRING) - (i,o)
  check_name_ref(STRING,STRING) - (i,o)
  check_NewCacheName(STRING,STRING,STRING) - (i,i,o)
  check_ref(STRING,STRING) - (i,o)
  correct_refer_with_cashma(STRING,STRING) - (i,o)
  INTEGER del_cashma(STRING,STRING) - (i,o)
  del_more_updir(STRING,STRING) - (i,o)
  INTEGER del_other_paths(STRING) - (i)
  INTEGER del_shemes_other_hosts(STRING,STRING) - (i,o)
  find_last_pos(STRING,ILIST,ILIST) - (i,i,o)
  find_refs(STRING, STRING, STRING ) - (i,i,o)
  format_url(STRING,STRING) - (i,o)
  get_last_state_symb(STRING,STRING) - (i,o)
  get_ref(STRING,STRING,STRING) - (i,o,o)
  is_sheme(STRING) - (i)
  is_sheme1(STRING) - (i)
  make_state_update()
  nondeterm member(WA_REFS_LIST,STRING,STRING) - (i,i,o)
  merge_url(STRING,STRING,STRING) - (i,i,o)
  modify_ref(STRING,STRING) - (i,o)
  search_ref(STRING,STRING,STRING,SLIST,STRING) - (i,i,i,i,o)
  select_host(STRING,STRING,STRING) - (i,o,o)
  test_found_ref(STRING, STRING) - (i,o)
  test_prevchar(CHAR)- (i)
  test_this_host_ref(STRING, STRING) - (i,o)
  wa_errcache(UNSIGNED,STRING) - (i,i)

CLAUSES

  conv(Already_lst,Sheme,Host,Path,TargetDir,File_name,NextLev,OriginalPath,FetchPath,S4,0):-
/*openappend(file_wadbg,"test_ans1.wer"),
writedevice(Old),
writedevice(file_wadbg),
	write("Done: ",Already_list,"\n"),!,
writedevice(Old),
closefile(file_wadbg),*/
	assert(cur_url(Sheme,Host,Path,TargetDir,NextLev,Already_lst,OriginalPath,FetchPath)),
%2Do its incorrect suggestion that reference must be quoted?
  	trap(file_str(File_name,Str_file),_,dlg_note("----?")),
 	find_refs(Str_file,"href",Str_out1),
 	find_refs(Str_out1,"src",Str_out2),
 	find_refs(Str_out2,"background",Str_new),
 	deletefile(File_name),
 	file_str(File_name,Str_new),
	findall(Refs,cur_refs(Refs),S4),
 	retractall(cur_url(_,_,_,_,_,_,_,_)),
 	retractall(cur_refs(_)),
%	retractall(cur_filecont(_)),
	!.
  conv(_,_,_,_,_,_,_,_,_,[],1):-
 	retractall(cur_url(_,_,_,_,_,_,_,_)),
% 	retractall(cur_filecont(_)),
 	retractall(cur_refs(_)).


  member([wa_ref(El1,F_name)|_],El2,F_name):-
  	0 = str_StrCmpi(El1,El2),!.
  member([_|L],F,F_name):-member(L,F,F_name).
	
  find_refs(Str_in,Str_sch, Str_out ):-
  	upper_lower(Str_in,Str_in_l),
  	search_ref(Str_in,Str_in_l,Str_sch,[],Str_out),
  	mem_systemFreeGStack().
/*  	retractall(cur_filecont(_)),
  	assert(cur_filecont(Str_out)),
  	fail.
%  	!.	%GStack problems
  find_refs(_,_,Str_out):-
  	mem_systemFreeGStack(),
	cur_filecont(Str_out),
  	!.*/
  	
  search_ref(Str_in,Str_in_l,Str_sch,ListOfStrings,S):-
  	not(searchstring(Str_in_l,Str_sch,_)),!,
	reverse([Str_in|ListOfStrings],ReversedList),
	list_to_string(ReversedList,"",S).
  search_ref(Str_in,Str_in_l,Str_sch,Prev,Str_out):-
  	searchstring(Str_in_l,Str_sch,FoundPos),
  	TestPos = FoundPos - 1,
	subchar(Str_in_l,TestPos,TestChar),
	test_prevchar(TestChar),!,
  	str_len(Str_sch,L_str_sch),
  	No = FoundPos + L_str_sch - 1,
	frontstr(No,Str_in,Start_norm,Rest_norm),
	get_ref(Rest_norm,Ref_old,Ref_new),	% without href,src .. at begin
	str_len(Ref_old,L_old),
	frontstr(L_old,Rest_norm,_,Rest),
	Low_rest_pos = No + L_old,
	frontstr(Low_rest_pos,Str_in_l,_,Rest_l),
	make_state_update(),
	vpi_ProcessEvents(),
	search_ref(Rest,Rest_l,Str_sch,[Ref_new,Start_norm|Prev],Str_out).
  search_ref(Str_in,Str_in_l,Str_sch,Prev,Str_out):-
  	searchstring(Str_in_l,Str_sch,FoundPos),
  	str_len(Str_sch,L_str_sch),
  	No = FoundPos + L_str_sch - 1,
  	frontstr(No,Str_in,Start_norm,Rest_norm),
  	frontstr(No,Str_in_l,_,Rest_norm_l),
  	search_ref(Rest_norm,Rest_norm_l,Str_sch,[Start_norm|Prev],Str_out).
  
  test_prevchar(' '):-!.
  test_prevchar('\a'):-!.
  test_prevchar('\b'):-!.
  test_prevchar('\f'):-!.
  test_prevchar('\n'):-!.
  test_prevchar('\r'):-!.
  test_prevchar('\t'):-!.
  test_prevchar('\v'):-!.
  test_prevchar('\''):-!.
  test_prevchar('\\'):-!.
  test_prevchar('\?'):-!.
  test_prevchar(_):-fail.
    
  get_ref(Str_in1,Str_ref_old,Str_ref_new):-          	%gets ref from first " to next "
	wa_strip_leading_spaces(Str_in1,Str_in2),		% delete space before =
	frontchar(Str_in2,'=',Str_in3),			% first must be =
	wa_strip_leading_spaces(Str_in3,Str_in4),		% delete space before first "
	frontchar(Str_in4,'\"',Rest1),			% first must be first "
	searchchar(Rest1,'\"',FoundPos2),
	frontstr(FoundPos2,Rest1,Ref_q,Rest_u),
	No = FoundPos2 - 1,
	frontstr(No,Ref_q,Ref_old,_),
	test_found_ref(Ref_old,Ref_new),
	% getting symbols before first "
	str_len(Str_in1,L_in1),
	str_len(Rest1,L_rest1),
	L_old = L_in1 - L_rest1,
	frontstr(L_old,Str_in1,Start_old,_),
	format(Str_ref_new,"%s%s\"",Start_old,Ref_new),
	concat(Str_ref_old,Rest_u,Str_in1),
	!.
  get_ref(_,"","").

  test_found_ref(Ref_old_j,Ref_new_Fname_j):-
  	0 = del_shemes_other_hosts(Ref_old_j,Ref1),
  	0 = del_cashma(Ref1,Ref_new1_1),
  	check_jump(Ref_new1_1,Ref_old),				% check whatever orig ref cont. jump
  	modify_ref(Ref_old,Ref_check),
  	test_this_host_ref(Ref_check,Ref_new_Fname1),
  	check_name_ref(Ref_new_Fname1,Ref_new_Fname),
  	check_jumps(Ref_old_j,Ref_new_Fname,Ref_new_Fname_j), 	% if original ref cont. jump then add it
  	!.
  test_found_ref(Ref_old,Ref_old).

  test_this_host_ref(Ref_check,Ref_new_Fname):-
  	0 = del_other_paths(Ref_check),
  	check_ref(Ref_check,Ref_new_Fname),
  	!.
  test_this_host_ref(Ref_in,Ref_out):-
  	check_abs_rel(Ref_in,Ref_out).
/*  test_this_host_ref(Ref_in,Ref_out):-			% ref is to other directory than original & FetchPath is set
	frontchar(Ref_in,'/',_),
  	cur_url(Sheme,Host,_,_,_,_,_,_),
  	format(Ref_out,"%s://%s%s",Sheme,Host,Ref_in),
	!.
  test_this_host_ref(Ref_in,Ref_out):-			% ref is to other directory than original & FetchPath is set	
	not(frontchar(Ref_in,'/',_)),
  	cur_url(Sheme,Host,Path,_,_,_,_,_),
  	format(Ref_out,"%s://%s/%s/%s",Sheme,Host,Path,Ref_in),
  	!.*/
  	
  check_name_ref(In,Name):-					% because in can an absolute refeence
  	filenamepath(In,_,Name),
  	frontchar(Name,'w',_),!.
  check_name_ref(In,In).

  check_ref(Ref_in,Ref_new_Fname):-				% this reference is already processed in this page
  	upper_lower(Ref_in,Ref_in_l),
  	cur_refs(wa_ref(Ref_in_l,Ref_new_Fname)),!.
  check_ref(Ref_in,Ref_new_Fname):-				% this reference is already processed in previous pages
  	cur_url(_,_,_,_,_,Already_lst,_,_),
  	member(Already_lst,Ref_in,Ref_new_Fname),
  	upper_lower(Ref_in,Ref_in_l),
  	assert(cur_refs(wa_ref(Ref_in_l,Ref_new_Fname))),
  	!.
  check_ref(Ref_in,Ref_old_mod):-				% returns a modified refrerence - not a name of a file
  	cur_url(_,_,_,_,0,_,_,_),				% next level will be null
	filenameext(Ref_in,_,Exten),
	upper_lower(Exten,Ext_l),
	not(what_ext(Ext_l)),
	check_abs_rel(Ref_in,Ref_old_mod),!.
  check_ref(Ref_in,Ref_new_Fname):-				% return a name of a file
  	cur_url(_,_,_,TargetDir,_,_,_,_),
	make_unique_cache_name(TargetDir,Ref_new_Fname),
	upper_lower(Ref_in,Ref_in_l),
  	assert(cur_refs(wa_ref(Ref_in_l,Ref_new_Fname))),
  	!.
  
  check_abs_rel(Ref_in,Ref_in):-				% ref is absolute - may be this clause isn't necess, 
  	searchchar(Ref_in,':',FoundPos),!,			% 'cause del_shemes_other_hosts returns relational path
	No = FoundPos - 1,
	frontstr(No,Ref_in,StartString_u,_),
	upper_lower(StartString_u,StartString),
	is_sheme1(StartString),!.
  check_abs_rel(Ref_in,Ref_out):-				% ref is relational with /
	frontchar(Ref_in,'/',_),
  	cur_url(Sheme,Host,_,_,_,_,_,_),
  	format(Ref_out,"%s://%s%s",Sheme,Host,Ref_in),
  	upper_lower(Ref_in,Ref_in_l),
  	assert(cur_refs(wa_ref(Ref_in_l,Ref_out))),		% for last level - user can increment => no fetching
  	!.
  check_abs_rel(Ref_in,Ref_out):-				% ref is relational
	not(frontchar(Ref_in,'/',_)),
  	cur_url(Sheme,Host,Path,_,_,_,_,_),
  	format(Ref_out,"%s://%s/%s/%s",Sheme,Host,Path,Ref_in),
  	format(Reff,"/%s/%s",Path,Ref_in),
  	upper_lower(Reff,Reff_l),
  	assert(cur_refs(wa_ref(Reff_l,Ref_out))),			% for last level - user can increment => no fetching
  	!.
  
  is_sheme1(Sh):- Sh="mailto",!;Sh="gopher",!;Sh="news",!;Sh="nntp",!;Sh="telnet",!;Sh="wais",!;Sh="prospero",!;Sh="file",!;Sh="http",!;Sh="ftp",!.
	
  del_shemes_other_hosts(Ref_in,Ref_in,1):-
	searchchar(Ref_in,':',FoundPos),
	No = FoundPos - 1,
	frontstr(No,Ref_in,StartString_u,_),
	upper_lower(StartString_u,StartString),
	is_sheme(StartString),!.		%another sheme
  del_shemes_other_hosts(Ref_in,Ref_in,1):-
  	searchchar(Ref_in,':',FoundPos),
	No = FoundPos + 2,              	% del http://
	frontstr(No,Ref_in,_,Rest),
	select_host(Rest,Host,_R),
	cur_url(_,Cur_host,_,_,_,_,_,_),
	Res = str_StrCmpi(Cur_host,Host),	%compare hosts ignoring case
	Res <> 0,!.				%another host
  del_shemes_other_hosts(Ref_in,R,0):-
  	searchchar(Ref_in,':',FoundPos),
	No = FoundPos + 2,              	% del http://
	frontstr(No,Ref_in,_,Rest),
	select_host(Rest,Host,R),
	cur_url(_,Cur_host,_,_,_,_,_,_),
	0 = str_StrCmpi(Cur_host,Host),		%compare hosts ignoring case
	!.					% our host
  del_shemes_other_hosts(Ref_in,Ref_in,0).

  is_sheme("mailto"):-!.
  is_sheme("gopher"):-!.
  is_sheme("news"):-!.
  is_sheme("nntp"):-!.
  is_sheme("telnet"):-!.
  is_sheme("wais"):-!.
  is_sheme("prospero"):-!.
  is_sheme("file"):-fail.
  is_sheme("http"):-fail.
  is_sheme("ftp"):-fail.
  	
  select_host(Rest,Host,R):-
	searchchar(Rest,'/',FoundPos1),	    %search http://ki/      -     host ki
	No1 = FoundPos1 - 1,
	frontstr(No1,Rest,Host,R),!.
  select_host(Rest,Rest,""). %no slash at the end  	

  del_cashma(Ref_in,Ref_in,1):-
	frontchar(Ref_in,'#',_),!.
  del_cashma(Ref_in,Ref_in,0).

  del_other_paths(_,0):-	% no fetch from path is set
  	cur_url(_,_,_,_,_,_,_,b_false),!.  
  del_other_paths(Ref_in,0):-	% this is a ref. to gif, audio and so on.
	filenameext(Ref_in,_,Exten),
	upper_lower(Exten,Ext_l),
	what_ext(Ext_l),!.
  del_other_paths(Ref_in,0):-	% this is a relational reference
	not(frontchar(Ref_in,'/',_)),
	!.
  del_other_paths(_,0):-	% no path specified
  	cur_url(_,_,_,_,_,_,"/",b_true),
  	!.
  del_other_paths(Ref_in,0):-	% ref. belongs to current path
  	cur_url(_,_,_,_,_,_,OriginalPath,b_true),
	frontchar(Ref_in,'/',Ref_in1),  	
  	concat(OriginalPath,_,Ref_in1),
  	!.
  del_other_paths(Ref_in,1):-	% ref. to other dir-ry
  	cur_url(_,_,_,_,_,_,OriginalPath,b_true),
	frontchar(Ref_in,'/',Ref_in1),  	
  	not(concat(OriginalPath,_,Ref_in1)),
  	!.

  make_unique_cache_name(Dir,Cache_name):-
	random(999999,RandomInt),
	format(Cache_name1,"%s\\wa%d",Dir,RandomInt),
  	check_NewCacheName(Dir,Cache_name1,Cache_name),
  	trap(openwrite(file_waunique,Cache_name),E,wa_errcache(E,Dir)),
	closefile(file_waunique),
	!.
	
  check_NewCacheName(_,PossibleNew,PossibleNew):-	% does not exist
  	format(TestName,"%s.*",PossibleNew),
	not(existfile(TestName)),!.
  check_NewCacheName(Dir,PossibleNew,New):-
  	format(TestName,"%s.*",PossibleNew),
	existfile(TestName),!,
  	random(999999,RandomInt),
	format(Cache_name1,"%s\\wa%d",Dir,RandomInt),!,
  	check_NewCacheName(Dir,Cache_name1,New).
  
  check_jumps(Ref_in,Cache_in,Cache_out):-
  	searchchar(Ref_in,'#',FoundPos),!,
	No = FoundPos - 1,
	frontstr(No,Ref_in,_,Jump),
	concat(Cache_in,Jump,Cache_out),!.
  check_jumps(_,Cache_in,Cache_in).
  
  check_jump(Ref_in,Ref_out):-
  	searchchar(Ref_in,'#',FoundPos),
  	No = FoundPos - 1,
  	frontstr(No,Ref_in,Ref_out,_),!.
  check_jump(Ref_in,Ref_in).


% be sure that there is no slash at the end of a path
  modify_ref(Ref_in,Ref_out):-
	format_url(Ref_in,Ref_out1),
	correct_refer_with_cashma(Ref_out1,Ref_out),
	!.

  format_url(Ref_in,Ref_out):-
	not(frontchar(Ref_in,'/',_)),
  	cur_url(_,_,Path,_,_,_,_,_),
  	merge_url(Ref_in,Path,RR),
  	format(Ref_out,"/%s",RR),!.
  format_url(Ref_in,Ref_in).

  merge_url(Ref,Cur_path,Ref1):-
  	Cur_path = "",!,
  	%fixes problem with superflouos ../
  	del_more_updir(Ref,Ref1),
  	!.
  merge_url(Ref,Cur_path,Res):-
	frontstr(3,Ref,Start,RestString),
	Start = "../",
	find_last_pos(Cur_path,[],L),
	L = [Pos|_],
	P = Pos - 1,
	frontstr(P,Cur_path,Cur_path1,_),!,
	merge_url(RestString,Cur_path1,Res).
  merge_url(Ref,Cur_path,Res1):-
	frontstr(3,Ref,Start,Res),
	Start = "../",
	find_last_pos(Cur_path,[],L),
	L = [],
	del_more_updir(Res,Res1),!.
  merge_url(Ref,Cur_path,Res):-
  	Cur_path <> "",
  	format(Res,"%s/%s",Cur_path,Ref),
  	!.
  	
  find_last_pos(Str_in,[],Res):-
	searchchar(Str_in,'/',FoundPos),
	frontstr(FoundPos,Str_in,_,RestString),!,
	find_last_pos(RestString,[FoundPos],Res).  	
  find_last_pos(Str_in,[Fp|L],Res):-
	searchchar(Str_in,'/',FoundPos),
	Fp_r = Fp + FoundPos,
	frontstr(FoundPos,Str_in,_,RestString),!,
	find_last_pos(RestString,[Fp_r|L],Res).
  find_last_pos(_,L,L):-!.

  del_more_updir(Ref,Ref):-
  	not(frontstr(3,Ref,_,_)),!.
  del_more_updir(Ref,Ref):-
  	frontstr(3,Ref,Start,_),
	Start <> "../",!.
  del_more_updir(Ref,Ref1):-
  	frontstr(3,Ref,Start,RestString),
	Start = "../",!,
	del_more_updir(RestString,Ref1).

  correct_refer_with_cashma(Ref_in,Ref_out):-
  	searchchar(Ref_in,'#',FoundPos),!,
	No = FoundPos - 1,
	frontstr(No,Ref_in,Ref_out,_),!.
  correct_refer_with_cashma(Ref_in,Ref_in).
  
  print_res(_,[]):-!.
  print_res(Str,[El|L]):-
openappend(file_wadbg,"test_ans2.wer"),
writedevice(Old),
writedevice(file_wadbg),
	write(Str,"Element: ",El,"\n"),!,
writedevice(Old),
closefile(file_wadbg),  
  	print_res(Str,L).	

  wa_errcache(Err,Dir):-
  	format(S,"An error occurred while writing file: cache file %U",Err),
	write_log(0,S),
	is_md(Dir,0),
	!.
	
  make_state_update():-
  	wa_dialog_win(Win),
	CtrlWin = win_GetCtlHandle(Win,idct_tip_text),
	Str_state_old = win_GetText(CtrlWin),
	str_len(Str_state_old,L),
	L1 = L - 1,
	frontstr(L1,Str_state_old,StartString,RestString),
	get_last_state_symb(RestString,LastSymb),
	format(Str_state_new,"%s%s",StartString,LastSymb),
	win_SetText(CtrlWin,Str_state_new).
	
  get_last_state_symb("|","\\"):-!.
  get_last_state_symb("\\","-"):-!.
  get_last_state_symb("-","/"):-!.
  get_last_state_symb("/","|"):-!.
  