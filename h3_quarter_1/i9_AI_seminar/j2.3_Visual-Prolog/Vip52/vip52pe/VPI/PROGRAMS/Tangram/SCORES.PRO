/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  TANGRAM
 FileName: SCORES.PRO
 Purpose: Tangram puzzle game
 Written by: Hans Dybkjær
 Comments:
******************************************************************************/

include "tangram.inc"
include "tangram.con"
include "hlptopic.con"

domains
	SCORE = score(STRING,			% scorer
		INTEGER,INTEGER,INTEGER) 	% flips,turns,moves
	SCORELIST = SCORE*

predicates
	scoreGet(WINDOW,SCORE)			- (i,o)
	scoreSetHigh(WINDOW,SCORELIST)  	- (i,i)
	scoreSetCreator(WINDOW,SCORE)		- (i,i)
	scoreTotal(SCORE,INTEGER)		- (i,o)
	scoreInsert(SCORE,SCORELIST,SCORELIST)	- (i,i,o)
	scoreInsertAux(SCORELIST,SCORELIST)	- (i,o)

database - scoredb
	score_now(WINDOW,SCORE)
	score_creator(WINDOW,SCORE)
	score_high(WINDOW,SCORELIST) % window,highscores

predicates
	score2string(SCORE,STRING) - (i,o)
	scores2strings(SCORELIST,SLIST) - (i,o)
	scoreCreator(WINDOW,WINDOW) 
	scoreHigh(WINDOW,WINDOW)
	
domains
	DBSCORE = dbscore(SCORE,SCORELIST)
	
constants 
	empty_score = score("",0,0,0)
clauses
scoreReset(Win) :-
	retractall(score_now(Win,_)),
	assert(score_now(Win,empty_score)).
scoreGet(Win,Sco) :-
	score_now(Win,Sco),!.
	
scoreSetHigh(Win,ScoList) :-
	retractall(score_high(Win,_)),
	assert(score_high(Win,ScoList)).
scoreResetHigh(Win) :-
	scoreSetHigh(Win,[empty_score,empty_score,empty_score,empty_score,empty_Score]).
	
scoreTheCreator(Win,Name) :-
	score_now(Win,score(_,F,T,M)),!,
	scoreSetCreator(Win,score(Name,F,T,M)).
	
scoreSetCreator(Win,Sco) :-
	retractall(score_creator(Win,_)),
	assert(score_creator(Win,Sco)).
	
scoreTotal(score(_,F,T,M),N) :- 
	N=F+T+M.

scoreIncFlip(Win) :-
	score_now(Win,score(S,F,T,M)),!,FF=F+1,
	retractall(score_now(Win,_)),assert(score_now(Win,score(S,FF,T,M))).

scoreIncTurn(Win) :-
	score_now(Win,score(S,F,T,M)),!,TT=T+1,
	retractall(score_now(Win,_)),assert(score_now(Win,score(S,F,TT,M))).

scoreIncMove(Win) :-
	score_now(Win,score(S,F,T,M)),!,MM=M+1,
	retractall(score_now(Win,_)),assert(score_now(Win,score(S,F,T,MM))).
	
score2string(empty_score,"-\t \t \t \t") :- !.
score2string(score(Name,F,T,M),S) :-
	Total=F+T+M,
	format(S,"%s\t%u\t%u\t%u\t%u",Name,F,T,M,Total).
	
scores2strings([],[]).
scores2strings([S1|L1],[S2|L2]) :-
	score2string(S1,S2),scores2strings(L1,L2).
	
scoreCreator(TangramWin,LBoxCreator) :-
	score_creator(TangramWin,Sco),!,score2string(Sco,S),
	lbox_Clear(LBoxCreator),lbox_Add(LBoxCreator,S).
	
scoreHigh(TangramWin,LBoxCreator) :-
	score_high(TangramWin,Scos),!,scores2strings(Scos,Ss),
	lbox_Clear(LBoxCreator),lbox_Add(LBoxCreator,Ss).
	
scoreDrawCurrent(Win) :-
	Rct=win_GetClientRect(Win),
	Rct = rct(Rx0,_,_,Ry1), % lower left corner
	score_now(Win,score(Name,F,T,M)),!,
	Total=F+T+M,
	format(S,"%s  Flip: %u  Turn: %u  Move: %u  Total: %u",Name,F,T,M,Total),
	win_SetForeColor(Win,color_Black),
	win_SetBackColor(Win,color_Yellow),
	win_SetBackMode(Win,bk_Opaque),
	win_GetTextExtent(Win, S, -1, _Width, Height),
	Ry=Ry1-Height-5,
	Rx=Rx0+5,
	draw_Text(Win,Rx,Ry,S).

scoreInsert(Sco,[Sco1|ScoList],[Sco|ScoList]) :- Sco1 = empty_score,!.
scoreInsert(Sco1,[Sco2|ScoList],[Sco2|ScoList3]) :-
	scoreTotal(Sco1,T1),scoreTotal(Sco2,T2),
	T2<=T1,!,scoreInsert(Sco1,ScoList,ScoList3).
scoreInsert(_,[],[]):-!,fail.
scoreInsert(Sco,ScoList,ScoList2) :-
	scoreInsertAux([Sco|ScoList],ScoList2).
scoreInsertAux([_],[]):-!. % Throw out worst (i.e. largest total) score.
scoreInsertAux([Sco|ScoList],[Sco|ScoList2]) :-
	scoreInsertAux(ScoList,ScoList2).

scoreRead(Win) :-
	scoreSetCreator(Win,empty_score),
	scoreReset(Win),scoreResetHigh(Win),
	readterm(DBSCORE,dbscore(Sco,L)),
	scoreSetCreator(Win,Sco),
	scoreSetHigh(Win,L).
	
scoreWrite(Win) :-
	score_creator(Win,Sco),!,
	score_high(Win,L),!,
	DBScore=dbscore(Sco,L),write(DBScore).
	
scoreDlgSuccess(Win) :-
	score_now(Win,ScoNow),score_high(Win,ScoHiList),
	scoreInsert(ScoNow,ScoHiList,_),!,
	% In high score! get his/her name
	Msg="Congratulation! You are one of the best! Your name:",
	InitStr="Winner name",
	Title="Congratulation",
	Name=dlg_GetStr(Title,Msg,InitStr),not(Name=InitStr),
	% register the name and score.
	ScoNow=score(_,F,T,M),
	scoreInsert(score(Name,F,T,M),ScoHiList,NewHiList),
	scoreSetHigh(Win,NewHiList).
	
scoreDlgShowHigh(Win) :-
	dlg_scores_high_Create(Win).
	
%BEGIN_DLG Scores high
/**************************************************************************
	Creation and event handling for dialog: Scores high
**************************************************************************/

CONSTANTS

%BEGIN Scores high, CreateParms, 19:53:14-25.11.1999, Code automatically updated!
  dlg_scores_high_ResID = idd_scores_high
  dlg_scores_high_DlgType = wd_Modal
  dlg_scores_high_Help = contents
%END Scores high, CreateParms

PREDICATES

  dlg_scores_high_eh : EHANDLER
  dlg_scores_high_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_scores_high_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_scores_high_Create(Parent):-

	IDC_SCORES_HIGH_CREATOR = [],
	IDC_SCORES_HIGH_ITEMS = [],
%MARK Scores high, new variables

	dialog_CreateModal(Parent,dlg_scores_high_ResID,"",
  		[
%BEGIN Scores high, ControlList, 19:53:14-25.11.1999, Code automatically updated!
		df(idc_scores_high_creator,listbox(IDC_SCORES_HIGH_CREATOR,[0]),nopr),
		df(idc_scores_high,listbox(IDC_SCORES_HIGH_ITEMS,[0]),nopr)
%END Scores high, ControlList
		],
		dlg_scores_high_eh,0,VALLIST,ANSWER),
	dlg_scores_high_handle_answer(ANSWER,VALLIST).

  dlg_scores_high_handle_answer(idc_ok,VALLIST):-!,
	dlg_scores_high_update(VALLIST).
  dlg_scores_high_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_scores_high_handle_answer(_,_):-
	errorexit().

  dlg_scores_high_update(_VALLIST):-
%BEGIN Scores high, Update controls, 19:53:14-25.11.1999, Code automatically updated!
	dialog_VLGetListBox(idc_scores_high_creator,_VALLIST,_IDC_SCORES_HIGH_CREATOR,_IDC_SCORES_HIGH_CREATOR_SELECT),
	dialog_VLGetListBox(idc_scores_high,_VALLIST,_IDC_SCORES_HIGH_ITEMS,_IDC_SCORES_HIGH_8_SELECT),
%END Scores high, Update controls
	true.

%MARK Scores high, new events

%BEGIN Scores high, e_Create
  dlg_scores_high_eh(_Win,e_Create(_CreationData),0):-!,
  	Parent =win_GetParent(_Win),
	TabStops=[64,88,112,144],
	% show creator
	CreaWin = win_GetCtlHandle(_Win, idc_scores_high_creator),
	lbox_SetTabStops(CreaWin, TabStops),
	scoreCreator(Parent,CreaWin),
	% show high ones
	HighWin = win_GetCtlHandle(_Win, idc_scores_high),
	lbox_SetTabStops(HighWin, TabStops),
	scoreHigh(Parent,HighWin),
	!.
%END Scores high, e_Create

%BEGIN Scores high, idc_ok _CtlInfo
  dlg_scores_high_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Scores high, idc_ok _CtlInfo

  dlg_scores_high_eh(_,_,_):-!,fail.

%END_DLG Scores high




