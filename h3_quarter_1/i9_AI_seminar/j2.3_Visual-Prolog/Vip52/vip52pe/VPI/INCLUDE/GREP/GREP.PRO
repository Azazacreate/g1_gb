/*****************************************************************************

	Copyright (c) 1984 - 2000 Prolog Development Center A/S 

			 VISUAL Prolog

 Project:  GREP
 FileName: GREP.PRO
 Purpose: Grep
 Written by: Maksim Avilov
 Comments:
******************************************************************************/

ifndef grep_pre_included
 #Error: this file requires include: grep.pre
enddef 
ifndef dlgdir_pre_included
 #Error: this file requires include: dlgdir.pre
enddef 
ifndef dialog_dom_included
 #Error: this file requires include: dialog.dom
enddef 


database -grepIntDB
 
   usedValues(string)
   usedWildcards(string)
   usedPathes(string)
   mask(string)
   single lastQuery(string, string, string)
   single checkBoxValues(integer, integer, integer)
   single existAnyFile(integer)
   single existDir(integer)
   determ search_options(string, integer, integer)
   determ result_Search(grep_handler)
	
%BEGIN_DLG Grep
/**************************************************************************
	Creation and event handling for dialog: Grep
**************************************************************************/

constants

%BEGIN Grep, CreateParms, 13:28:43-11.11.1984 - 2000, Code automatically updated!
  dlg_grep_DlgType = wd_Modal
  dlg_grep_Title = "Grep"
  dlg_grep_RCT = rct(40,32,252,125)
  dlg_grep_Flags = [wsf_DlgBorder,wsf_Close,wsf_TitleBar]
  dlg_grep_Help = idh_contents
  dlg_grep_Font = "MS Sans Serif"
  dlg_grep_FSize = 8
%END Grep, CreateParms
  idc_grep_1 = 101
  idc_grep_2 = 102
  idc_grep_3 = 103
  idc_match_whole_words = 104
  idc_search_subfolders = 105
  idc_match_case = 106
  idc_browse = 107
  idct_find_what = 108
  idc_grep_5 = 109
  idc_grep_6 = 110
  
      
predicates

  dlg_grep_eh : EHANDLER
  procedure badfiletype(string)
  incorrectpath(string, boolean IsSeachSubdirectories) - determ (i,i)
  procedure setBaseUsed(string, string, string)
  procedure collect_extensions(string)
  procedure collect_directories(string)
  procedure get_names(string, boolean)
  procedure do_search(string)
  procedure doPathCorrect(string, string)
  collect_files(string, boolean IsSeachSubdirectories) - determ(i,i)
  determ call_result_search(string,edit_poslist,slist)
  
clauses

   checkBoxValues(b_false, b_false, b_false).
   existAnyFile(b_false).
   existDir(b_false).
   lastQuery("","","").
   
   badfiletype(X):-dlg_error("Not valid file type!", X).
   incorrectpath(X, b_false):-dlg_error("Invalid path!", X),fail.
   
   doPathCorrect(Path, NewPath):-
	str_len(Path, Lenght),
	subchar(Path, Lenght, LastChar),
	LastChar = '\\',!,
	NewPath = Path.

   doPathCorrect(Path, NewPath):-
	concat(Path, "\\", NewPath).


   grep_Run(DialogMode, Parent, "","","",b_false,b_false,b_false,UserHandler):-
	findall(X,usedValues(X),IDC_GREP_1_ITEMLIST),
	findall(Y,usedWildcards(Y),IDC_GREP_2_ITEMLIST),
	findall(Z,usedPathes(Z),IDC_GREP_3_ITEMLIST),
/*	usedValues(SearchStr),!,
	usedWildcards(FileMask),!,
	usedPathes(StartDir),!,*/
	lastQuery(Ch1, Ch2, Ch3),
	checkBoxValues(WordOnly, IncludeSub, CaseSensitive),
	retractall(result_Search(_)),
	retractall(search_options(_,_,_)),
	assert(existAnyFile(b_false)),
	assert(result_Search(UserHandler)),
	dialog_Create(Parent,
		[
%BEGIN Grep, WinDefList, 13:28:43-11.11.1984 - 2000, Code automatically updated!
		 dlg_font(wdef(dlg_grep_DlgType,dlg_grep_RCT,dlg_grep_Title,u_DlgBase),
		 	  dlg_grep_Font,dlg_grep_FSize,dlg_grep_Flags),
		 ctl(wdef(wc_LBoxEdit,rct(62,10,156,57),"",u_DlgBase),idc_grep_1,[wsf_TabStop,wsf_Group,wsf_VScroll]),
		 ctl(wdef(wc_LBoxEdit,rct(62,26,156,73),"",u_DlgBase),idc_grep_2,[wsf_TabStop,wsf_Group,wsf_VScroll, wsf_NoHideSel]),
		 ctl(wdef(wc_LBoxEdit,rct(62,42,156,88),"",u_DlgBase),idc_grep_3,[wsf_TabStop,wsf_Group,wsf_VScroll,wsf_AutoHScroll]),
		 ctl(wdef(wc_CheckBox,rct(5,62,80,72),"Match &whole words",u_DlgBase),idc_match_whole_words,[wsf_TabStop,wsf_Group,wsf_Auto]),
		 ctl(wdef(wc_CheckBox,rct(83,62,157,72),"&Search subfolders",u_DlgBase),idc_search_subfolders,[wsf_TabStop,wsf_Group,wsf_Auto]),
		 ctl(wdef(wc_CheckBox,rct(5,78,79,88),"Match &case",u_DlgBase),idc_match_case,[wsf_TabStop,wsf_Group,wsf_Auto]),
		 ctl(wdef(wc_PushButton,rct(161,10,209,22),"Find",u_DlgBase),idc_ok,[wsf_TabStop,wsf_Group,wsf_Default]),
		 ctl(wdef(wc_PushButton,rct(161,26,209,38),"Cancel",u_DlgBase),idc_cancel,[wsf_TabStop,wsf_Group]),
		 ctl(wdef(wc_PushButton,rct(161,42,209,54),"B&rowse...",u_DlgBase),idc_browse,[wsf_TabStop,wsf_Group]),
		 ctl(wdef(wc_PushButton,rct(161,62,209,74),"Help",u_DlgBase),idc_help,[wsf_TabStop,wsf_Group]),
		 ctl(wdef(wc_Text,rct(5,10,53,20),"Find what",u_DlgBase),idct_find_what,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(5,26,53,36),"In files",u_DlgBase),idc_grep_5,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(5,42,53,52),"In folder",u_DlgBase),idc_grep_6,[wsf_AlignLeft])
%END Grep, WinDefList
		],
  		[
		df(idc_grep_1,listedit(IDC_GREP_1_ITEMLIST,Ch1 /*SearchStr*/),nopr),
		df(idc_grep_2,listedit(IDC_GREP_2_ITEMLIST,Ch2 /*FileMask*/),nopr),
		df(idc_grep_3,listedit(IDC_GREP_3_ITEMLIST,Ch3 /*StartDir*/),nopr),
		df(idc_match_whole_words,checkbox(WordOnly),nopr),
		df(idc_search_subfolders,checkbox(IncludeSub),nopr),
		df(idc_match_case,checkbox(CaseSensitive),nopr)
		],
		dlg_grep_eh,DialogMode,_,_),
		!.


   grep_Run(DialogMode, Parent, SearchStr,FileMask,StartDir,IncludeSub,CaseSensitive,WordOnly,UserHandler):-
	findall(X,usedValues(X),IDC_GREP_1_ITEMLIST),
	findall(Y,usedWildcards(Y),IDC_GREP_2_ITEMLIST),
	findall(Z,usedPathes(Z),IDC_GREP_3_ITEMLIST),
	retractall(result_Search(_)),
	retractall(search_options(_,_,_)),
	assert(result_Search(UserHandler)),
	dialog_Create(Parent,
		[
%BEGIN Grep, WinDefList, 13:28:43-11.11.1984 - 2000, Code automatically updated!
		 dlg_font(wdef(dlg_grep_DlgType,dlg_grep_RCT,dlg_grep_Title,u_DlgBase),
		 	  dlg_grep_Font,dlg_grep_FSize,dlg_grep_Flags),
		 ctl(wdef(wc_LBoxEdit,rct(62,10,156,57),"",u_DlgBase),idc_grep_1,[wsf_TabStop,wsf_Group,wsf_VScroll]),
		 ctl(wdef(wc_LBoxEdit,rct(62,26,156,73),"",u_DlgBase),idc_grep_2,[wsf_TabStop,wsf_Group,wsf_VScroll]),
		 ctl(wdef(wc_LBoxEdit,rct(62,42,156,88),"",u_DlgBase),idc_grep_3,[wsf_TabStop,wsf_Group,wsf_VScroll,wsf_AutoHScroll]),
		 ctl(wdef(wc_CheckBox,rct(5,62,80,72),"Match &whole words",u_DlgBase),idc_match_whole_words,[wsf_TabStop,wsf_Group,wsf_Auto]),
		 ctl(wdef(wc_CheckBox,rct(83,62,157,72),"&Search subfolders",u_DlgBase),idc_search_subfolders,[wsf_TabStop,wsf_Group,wsf_Auto]),
		 ctl(wdef(wc_CheckBox,rct(5,78,79,88),"Match &case",u_DlgBase),idc_match_case,[wsf_TabStop,wsf_Group,wsf_Auto]),
		 ctl(wdef(wc_PushButton,rct(161,10,209,22),"Find",u_DlgBase),idc_ok,[wsf_TabStop,wsf_Group,wsf_Default]),
		 ctl(wdef(wc_PushButton,rct(161,26,209,38),"Cancel",u_DlgBase),idc_cancel,[wsf_TabStop,wsf_Group]),
		 ctl(wdef(wc_PushButton,rct(161,42,209,54),"B&rowse...",u_DlgBase),idc_browse,[wsf_TabStop,wsf_Group]),
		 ctl(wdef(wc_PushButton,rct(161,62,209,74),"Help",u_DlgBase),idc_help,[wsf_TabStop,wsf_Group]),
		 ctl(wdef(wc_Text,rct(5,10,53,20),"Find what",u_DlgBase),idct_find_what,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(5,26,53,36),"In files",u_DlgBase),idc_grep_5,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(5,42,53,52),"In folder",u_DlgBase),idc_grep_6,[wsf_AlignLeft])
%END Grep, WinDefList
		],
  		[
		df(idc_grep_1,listedit(IDC_GREP_1_ITEMLIST,SearchStr),nopr),
		df(idc_grep_2,listedit(IDC_GREP_2_ITEMLIST,FileMask),nopr),
		df(idc_grep_3,listedit(IDC_GREP_3_ITEMLIST,StartDir),nopr),
		df(idc_match_whole_words,checkbox(WordOnly),nopr),
		df(idc_search_subfolders,checkbox(IncludeSub),nopr),
		df(idc_match_case,checkbox(CaseSensitive),nopr)
		],
		dlg_grep_eh,DialogMode,_,_).


%MARK Grep, new events
  dlg_grep_eh(_Win,e_Create(b_true),0):-!,
  	CtrlWin = win_GetCtlHandle(_Win, idc_grep_1),
  	Text = win_GetText(CtrlWin),
	str_len(Text, Last),
	win_SelectText(CtrlWin, 0, Last),
  	!.
  	
  dlg_grep_eh(_Win,e_Create(_),0):-!,
  	win_SendEvent(_Win,e_Control(idc_ok,w_TopLevel,_Win,getfocus())),
  	!.
	
%BEGIN Grep, idc_cancel _CtlInfo
  dlg_grep_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	!,
	retract( search_options(_, _, _) ),
	fail.
%END Grep, idc_cancel _CtlInfo

%BEGIN Grep, idc_ok _CtlInfo
  dlg_grep_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
	retract( search_options(_, _, _) ),
	win_SetText(_CtrlWin, "Find"),
	!.
  
  dlg_grep_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
	_IDC_GREP_1_DEFAULT = dialog_GetListEdit(_Win, idc_grep_1),
  	_IDC_GREP_1_DEFAULT = "",
  	!,
  	CtrlWin = win_GetCtlHandle(_Win, idc_grep_1),
	win_SetFocus(CtrlWin),
  	dlg_Note("Search string is empty!").
  
  dlg_grep_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
	_IDC_GREP_2_DEFAULT = dialog_GetListEdit(_Win, idc_grep_2),
  	_IDC_GREP_2_DEFAULT = "",
  	!,
  	CtrlWin = win_GetCtlHandle(_Win, idc_grep_2),
	win_SetFocus(CtrlWin),
  	dlg_Note("Please specify file mask!").

  dlg_grep_eh(_Win,e_Control(idc_ok,_CtrlType,_,_CtlInfo),0):-
	_IDC_GREP_3_DEFAULT = dialog_GetListEdit(_Win, idc_grep_3),
  	_IDC_GREP_3_DEFAULT = "",
  	!,
  	CtrlWin = win_GetCtlHandle(_Win, idc_grep_3),
	win_SetFocus(CtrlWin),
  	dlg_Note("Please specify directory!").

  dlg_grep_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
	Path = dialog_GetListEdit(_Win, idc_grep_3),
	doPathCorrect(Path, NewDir),
	concat(NewDir, "*.*",NewPath),
	trap(dirfiles( NewPath, 0x10, _, _, _, _, _, _, _, _, _ ), _,incorrectpath(NewPath, b_false)),
	assert(existDir(b_true)),
	fail.

  dlg_grep_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	existDir(b_true),
	assert(existDir(b_false)),
	assert(existAnyFile(b_false)),
	_IDC_MATCH_WHOLE_WORDS_CHECKED = dialog_GetCheck(_Win, idc_match_whole_words),
	_IDC_MATCH_CASE_CHECKED = dialog_GetCheck(_Win, idc_match_case),
	_IDC_SEARCH_SUBFOLDERS_CHECKED = dialog_GetCheck(_Win, idc_search_subfolders),
	_IDC_GREP_1_DEFAULT = dialog_GetListEdit(_Win, idc_grep_1),
	_IDC_GREP_2_DEFAULT = dialog_GetListEdit(_Win, idc_grep_2),
	_IDC_GREP_3_DEFAULT = dialog_GetListEdit(_Win, idc_grep_3),
	doPathCorrect(_IDC_GREP_3_DEFAULT, Path),
        setBaseUsed(Path, _IDC_GREP_2_DEFAULT, _IDC_GREP_1_DEFAULT),
        assert(lastQuery(_IDC_GREP_1_DEFAULT, _IDC_GREP_2_DEFAULT, Path)),
        assert(checkBoxValues(_IDC_MATCH_WHOLE_WORDS_CHECKED, _IDC_SEARCH_SUBFOLDERS_CHECKED, _IDC_MATCH_CASE_CHECKED)),
        retractall(mask(_)),
	retractall(search_options(_,_,_)),
        assert(search_options(_IDC_GREP_1_DEFAULT, _IDC_MATCH_CASE_CHECKED, _IDC_MATCH_WHOLE_WORDS_CHECKED)),
        win_SetText(_CtrlWin, "S&top"),
        collect_extensions(_IDC_GREP_2_DEFAULT), 
        get_names(Path, _IDC_SEARCH_SUBFOLDERS_CHECKED),
	retractall(search_options(_,_,_)),
        existAnyFile(b_false),
        !,
  	dlg_Note("No any matches found"),
	win_SetText(_CtrlWin, "Find").
  dlg_grep_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
	win_SetText(_CtrlWin, "Find"),
  	CtrlWin = win_GetCtlHandle(_Win, idc_grep_3),
	win_SetFocus(CtrlWin),
	fail.
  dlg_grep_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	!.
	
%END Grep, idc_ok _CtlInfo


%BEGIN Grep, idc_help _CtlInfo
  dlg_grep_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	!.
%END Grep, idc_help _CtlInfo


%BEGIN Grep, idc_browse _CtlInfo
  dlg_grep_eh(_Win,e_Control(idc_browse,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	Item=dialog_GetListEdit(_Win,idc_grep_3),
  	Ret = dlg_GetDirectoryName(_Win, Item, SourceDir),
  	Ret = 1,!,
	dialog_SetListEdit(_Win,idc_grep_3,SourceDir),
	!.
%END Grep, idc_browse _CtlInfo

  dlg_grep_eh(_,_,_):-!,fail.

%END_DLG Grep

  setBaseUsed(A, _, _):-
  	not( usedPathes(A) ),
  	asserta( usedPathes(A) ),
  	fail.
  setBaseUsed(_, B, _):-
  	not( usedWildcards(B) ),
  	asserta( usedWildcards(B) ),
  	fail.	
  setBaseUsed(_, _, C):-
  	not( usedValues(C) ),
  	asserta( usedValues(C) ),
  	fail.
  setBaseUsed(_, _, _).
  
  collect_directories(SourceDir):-
       	 search_options(_, _, _),
 	 concat(SourceDir, "*.*", SourceDir3),
   	 collect_files( SourceDir, b_true ),
	 trap(dirfiles(SourceDir3,0x10,F,_,_,_,_,_,_,_,_),_,incorrectpath(SourceDir3, b_false)),
	 F <> ".", F <> "..",
  	 concat(SourceDir, F, FoundDir),
  	 doPathCorrect(FoundDir, CorrectFoundDir),
         vpi_ProcessEvents(),
       	 search_options(_, _, _),
  	 collect_directories( CorrectFoundDir ),
  	 fail.

  collect_directories(_).
         
  collect_files(SourceDir, IsSearchSubdirectories):-	
       	 search_options(_, _, _),
       	 mask(ExtMask),
	 concat( SourceDir, ExtMask, SourceDir2),
 	 trap(dirfiles( SourceDir2, 0x40, Fnam, _, _, _, _, _, _, _, _ ), _,incorrectpath(SourceDir2, IsSearchSubdirectories)),
         concat( SourceDir, Fnam, LongFileName),           
	 do_search(LongFileName),
         vpi_ProcessEvents(),
       	 not(search_options(_, _, _)),!,
       	 fail.
	 
  collect_files(_,_).

  do_search(X):-
	search_options(What, Case, Whole),
	trap(file_str(X, DataX ), _ , badfiletype(X)),
	PosList = edit_SearchSubStr(What, DataX, RetStrList, Case, Whole),
	not(PosList = [] ),
	assert(existAnyFile(b_true)),
	call_result_search(X, PosList, RetStrList),
	fail.

  do_search(_).

  collect_extensions(ExtStr):-
	searchchar(ExtStr,' ',FoundPos),
	Length=FoundPos-1,
	frontstr(Length,ExtStr,Mask,RestString),
	assert( mask(Mask) ),
	frontchar(RestString,_,NewExtStr),!,
  	collect_extensions(NewExtStr).
  collect_extensions(ExtStr):-
	assert( mask(ExtStr) ).

  get_names(Where, b_True):-
  	collect_directories(Where),
  	!.
  	
  get_names(Where, b_False):-
  	collect_files(Where,b_false),
  	!.	
  	
  get_names(_, _).
  
  call_result_search(_, [], _):-!.
  
  call_result_search(X, [Pos|PosList], [Str|RetStrList]):-
  	result_search(UHandler),
  	not(UHandler(X,Pos,Str)),!,
  	call_result_search(X, PosList, RetStrList),
  	fail.	

  call_result_search(_, [], _):-
	retract( search_options(X, Y, Z) ),
	write("**",X,Y,Z),nl,
	fail.

  	
