/*****************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	TABCONV.PRO
 Purpose:	Report Conversion to Tabulated Text
 Written by:	Peter Moguilnitsy
 Version:	1.0
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:       
******************************************************************************/
constants
ifdef platform_16bit
   re_Max_Int = 32767	% Max Number of char in string
elsedef ifdef platform_32bit
   re_Max_Int = 65635	% Max Number of char in string
enddef enddef

domains 
   XY_AND_STRING =  xy_str(INTEGER,INTEGER,STRING)
   XY_AND_STRING_LIST = XY_AND_STRING*


database  -  tab_Converter
  NONDETERM  base_Of_String(XY_AND_STRING)	
  DETERM     list_Of_Y(ILIST) 
  DETERM     continue 

predicates
  procedure choose_Convert_Type(STRING,INTEGER)
  procedure re_TabConvert(STRING)
  procedure convert_RepFile_To_TabFile()
  procedure assemble_List()
  determ    check_Domen(KEEP_DBA_DOM)  
  procedure write_Tab_Text(XY_AND_STRING_LIST)
  nondeterm tab_repeat 
  procedure readln_until_NewPage() 
  procedure find_min(XY_AND_STRING ,XY_AND_STRING_LIST List,XY_AND_STRING Min) 
  determ    common_min(INTEGER,INTEGER) 
  procedure common_delete (XY_AND_STRING_LIST,XY_AND_STRING,XY_AND_STRING_LIST)
  procedure common_delete(ILIST,INTEGER,ILIST) 
  procedure common_sort_list(BOOLEAN Ascending,ILIST In,ILIST Out)
  procedure common_sort_list1(BOOLEAN Ascending,INTEGER First,ILIST Input,
							ILIST Deff,ILIST,ILIST Output)
  procedure out_facts(ILIST)
  procedure update_Y_List(INTEGER)
  determ    common_member_index(INTEGER,ILIST,INTEGER)							
  determ    common_compare_basic(BOOLEAN,INTEGER,INTEGER)
  nondeterm get_String_From_Base(INTEGER,XY_AND_STRING)
  
clauses 

  choose_Convert_Type(SFile,0):-
	re_RTFConvert(SFile),!.
  choose_Convert_Type(SFile,1):-
	re_TabConvert(SFile),!.
  choose_Convert_Type(_,_):-!.
  	




	
%  convert_To(".rtf",SFile):-
%	re_RTFConvert(SFile),!.
%  convert_To(".txt",SFile):-
%  convert_To(_,_):-
%  	dlg_Note("Illegal File name"),!.
  	

    re_TabConvert(FileName):-	
	openread(re_temp_file,"rep$$$.tmp"),
	openwrite(re_rtffile,FileName),
	readdevice(re_temp_file),
	writedevice(re_rtffile),
	readln(_),			% Read first string
	convert_RepFile_To_TabFile(),
	closefile(re_temp_file),
	closefile(re_rtffile),!.
     re_TabConvert(_):-
     	dlg_note("Tab Convertioin fail"),
     	errorexit().

  tab_repeat.
  tab_repeat:-not(eof(re_temp_file)),
  	  tab_repeat.
  tab_repeat:- fail.

  convert_RepFile_To_TabFile():-
   	tab_repeat,
   	_Result = vpi_ProcessEvents(),
   	retractAll(base_Of_String(_)),
   	retractAll(list_Of_Y(_)),
   	assert(list_Of_Y([])),
   	assemble_List(),
        list_Of_Y(List),
   	common_sort_list(b_true,List,OutList),
   	out_facts(OutList),
	fail.	
  convert_RepFile_To_TabFile():-!.
  
  
  assemble_List():-
  	retractAll(continue),
  	readln(Str),
  	term_Str(KEEP_DBA_DOM,Domen,Str),
	check_Domen(Domen),
	!,
	assemble_List().
   assemble_List():-
   	not(eof(re_temp_file)),
   	not(continue),
   	!,
   	assemble_List().		
   assemble_List():-!.
   
	
   check_Domen(outpage(_)):-
   	assert(continue),
   	fail.
   check_Domen(outfooter):-
 	readln_until_NewPage(),
 	assert(continue),
 	fail.
   check_Domen(out_text(rct(X,Y,_,_),STRING,_)):-
   	assert(base_Of_String(xy_Str(X,Y,STRING))),
	update_Y_List(Y),
   	!.
   
   readln_until_NewPage():-
   	readln(Str),
	term_Str(KEEP_DBA_DOM,outPage(_),Str),
	!.
   readln_until_NewPage():-
	eof(re_temp_file),
	!.	
   readln_until_NewPage():-!,
	readln_until_NewPage().

   update_Y_List(Y):-
	list_Of_Y(YLIST),
	not(common_member_index(Y,YLIST,_)),
	retractAll(list_Of_Y(_)),
	assert(list_Of_Y([Y|YLIST])),!.	   
   update_Y_List(_):-!.
   
	
   out_facts([]):-
	!.
   out_facts([Y|OutList]):-
   	findall(H,get_String_From_Base(Y,H),ListVariable),
    	write_Tab_Text(ListVariable),!,
   	out_facts(OutList).	
   out_facts(_):-
   	errorexit().
   	
   get_String_From_Base(Y,M):-
	base_Of_String(M),
	M = xy_str(_,Y,_).
	
	
   write_Tab_Text([]):-
   	write("\n"),
   	!.
   write_Tab_Text(List):-
   	find_min(xy_str(re_Max_Int,0,""),List,xy_str(X,Y,String)),
	common_delete(List,xy_str(X,Y,String),OutList),
   	write(String,"\t"),
	!,
	write_Tab_Text(OutList).	
   write_Tab_Text(_):-
   	errorexit().


		
  find_min(Element,[],Element):-!.
  find_min(xy_str(X,_,_),[xy_str(X1,Y,String)|List],MinElement):-
  	common_min(X,X1),!,	
	find_min(xy_str(X1,Y,String),List,MinElement).
  find_min(CurrentMinEl,[_|List],MinElement):-!,
	find_min(CurrentMinEl,List,MinElement).
  find_min(_,_,_):-
  	errorexit().
  	
   common_delete([],_,[]):-
   	!.
   common_delete([YS|XS],YS,XS):-
   	!.
   common_delete([X|XS],YS,[X|ZS]):-
	common_delete(XS,YS,ZS),
	!.
   common_delete(_,_,[]):-
		errorexit().   	

  common_min(X,X1):-X1 < X,!.
  common_min(_,_):-fail.

  common_member_index(S,[S|_],1):-!.
  common_member_index(S,[_|L],M):-
        bound(M),!,
        N = M - 1,
        common_member_index(S,L,N),!.
  common_member_index(S,[_|L],M):-
	bound(S),
        common_member_index(S,L,N),!,
        M = N + 1.

  common_compare_basic(b_true,A,B):-!,
	B > A.
  common_compare_basic(b_false,A,B):-!,
	A > B.

  common_sort_list1(_,_,[],[A|[]],Curr,[A|Curr]):-!.
  common_sort_list1(Ascending,A,[],Deff,Curr,Output):-
	common_delete(Deff,A,Deff1),
	Deff1 = [B|Rest],!,
	common_sort_list1(Ascending,B,[B|Rest],[B|Rest],[A|Curr],Output).
  common_sort_list1(Ascending,A,[B|Rest],Deff,Curr,Output):-
	common_compare_basic(Ascending,A,B),!,
	common_sort_list1(Ascending,B,Rest,Deff,Curr,Output).
  common_sort_list1(Ascending,A,[_|Rest],Deff,Curr,Output):-!,
	common_sort_list1(Ascending,A,Rest,Deff,Curr,Output).
  common_sort_list1(_,_,_,_,_,[]):-
	errorexit().

  common_sort_list(_,[],[]):-!.
  common_sort_list(_,[A|[]],[A]):-!.
  common_sort_list(Ascending,[A|Rest],Output):-
	common_sort_list1(Ascending,A,[A|Rest],[A|Rest],[],Output),!.
  common_sort_list(_,_,[]):-
	errorexit().
