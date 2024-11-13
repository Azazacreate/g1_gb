/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	SCAN.PRO
 Purpose:	Scanner
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
*****************************************************************************/
predicates

determ  tokl(CURSOR,STRING,TOKL)
determ  maketok(CURSOR,STRING,TOK,STRING,STRING,CURSOR)
determ  string_token(STRING,TOK)
determ	isspace(CHAR)
procedure  skipspaces(STRING,STRING,INTEGER)
clauses

  tokl(POS,STR,TOKL):-
	skipspaces(STR,STR1,NOOFSP),
	fronttoken(STR1,"%",STR2),!,	% Skip comment until the end of line
        searchchar(STR2,'\n',EndPos),
	POS2=POS+NOOFSP+1+EndPos,
	frontstr(EndPos,STR2,_,STR3),
	tokl(POS2,STR3,TOKL).
  tokl(POS,STR,[t(TOK,POS1)|TOKL]):-
	skipspaces(STR,STR1,NOOFSP),
	POS1=POS+NOOFSP,
	fronttoken(STR1,STRTOK,STR2),!,
	maketok(POS1,STRTOK,TOK,STR2,STR3,LEN1),
	str_len(STRTOK,LEN),
	POS2=POS1+LEN+LEN1,
	tokl(POS2,STR3,TOKL).
  tokl(_,_,[]).

  isspace(' ').
  isspace('\t').
  isspace('\n').

/************************************************************************
 *									*
 *	string_token/2							*
 *									*
 ************************************************************************/

  string_token("=",		equal		) :- !.
  string_token(";",		semicolon	) :- !.
  string_token(",",		comma		) :- !.
  string_token("+",             plus            ) :- !.
  string_token("-",             minus           ) :- !.
  string_token("*",             mult            ) :- !.
  string_token("/",             div             ) :- !.
  string_token("<",             less            ) :- !.
  string_token(">",             more            ) :- !.
  string_token("report",	report		) :- !.
  string_token("header",	header		) :- !.
  string_token("footer",	footer		) :- !.
  string_token("block",         block           ) :- !.
  string_token("script",        script         	) :- !.
  string_token("begin",         begin          	) :- !.
  string_token("end",   	end     	) :- !.
  string_token("end_report",   	end_report     	) :- !.
  string_token("end_header",   	end_header     	) :- !.
  string_token("end_footer",   	end_footer     	) :- !.
  string_token("end_script",   	end_script     	) :- !.
  string_token("end_while",     end_while       ) :- !.
  string_token("end_if",        end_if 	        ) :- !.
  string_token("enlarge",       enlarge 	) :- !.
  string_token("margins",	margins		) :- !.
  string_token("units",		units		) :- !.
  string_token("orientation",	orientation	) :- !.
  string_token("portrait",	portrait	) :- !.
  string_token("landscape",	landscape	) :- !.
  string_token("at",          	at            	) :- !.
  string_token("pixel",		pixel		) :- !.
  string_token("cm",		cm		) :- !.
  string_token("logical",	logical		) :- !.
  string_token("while",         while 	        ) :- !.
  string_token("do",       	do	        ) :- !.
  string_token("if",          	if_ 	        ) :- !.
  string_token("then",          then 	        ) :- !.
  string_token("else",          else 	        ) :- !.
  string_token("(",		lbracket	) :- !.
  string_token(")",		rbracket	) :- !.
  string_token("text",		text		) :- !.
  string_token("bitmap",	bitmap		) :- !.
  string_token("line",		line		) :- !.
  string_token("pagebreak",     pagebreak      	) :- !.
  string_token("fontname",	fontname	) :- !.
  string_token("fontstyle",	fontstyle	) :- !.
  string_token("fontsize",	fontsize	) :- !.
  string_token("tabs",          tabs            ) :- !.
  string_token("defaulttabs",   defaulttabs     ) :- !.
  string_token("border",	border		) :- !.
  string_token("alignment",	alignment	) :- !.
  string_token("forecolor",	forecolor	) :- !.
  string_token("backcolor",	backcolor	) :- !.
  string_token("var_backcolor",	var_backcolor	) :- !.
  string_token("var_forecolor",	var_forecolor	) :- !.
  string_token("var_border",	var_border	) :- !.
  string_token("var_font",	var_font	) :- !.
  string_token("outer_rectangle",outer_rect	) :- !.
  string_token("keep_together",	keep_together	) :- !.
  string_token("new_page",	new_page	) :- !.
  string_token("expandable",	expandable	) :- !.
  string_token("clip",		clip		) :- !.
  string_token("wrap",		wrap		) :- !.
  string_token("recurrent",	recurrent	) :- !.
  string_token("topindent",	topindent	) :- !.
  string_token("vertical",	vertical	) :- !.
  string_token("horizontal",	horizontal	) :- !.
  string_token("center",	center		) :- !.
  string_token("left",		left		) :- !.
  string_token("leftindent",	leftindent	) :- !.
  string_token("right",		right		) :- !.
  string_token("normal",	normal		) :- !.
  string_token("bold",		bold		) :- !.
  string_token("italic",	italic		) :- !.
  string_token("underline",	underline	) :- !.
  string_token("or",		or_		) :- !.
  string_token("xor",		xor_		) :- !.
  string_token("and",		and_		) :- !.
  string_token("not",		not_		) :- !.

  maketok(_,":",assign,S1,S2,1):- 		/* assignment ( := )       */
  	frontchar(S1,'=',S2),!.
  maketok(_,"<",not_eq,S1,S2,1):- 		/* not equal ( <> )       */
  	frontchar(S1,'>',S2),!.
  maketok(_,"<",less_eq,S1,S2,1):- 		/* less or equal ( <= )   */
  	frontchar(S1,'=',S2),!.
  maketok(_,">",more_eq,S1,S2,1):- 		/* more or equal ( >= )   */
  	frontchar(S1,'=',S2),!.
  maketok(_,">",not_eq,S1,S2,1):- 		/* not  equal ( >< )   */
  	frontchar(S1,'<',S2),!.
  maketok(_,STR,TOK,S,S,0):-string_token(STR,TOK),!.
  maketok(_,NAME,call(NAME),STR,STR,0):-
	isname(NAME),
	frontchar(STR,'(',_),
	!.
  maketok(_CURSOR,"\"",str(STR),S1,S2,POS):-!,
        searchchar(S1,'"',Pos), Nu = Pos - 1,
        frontstr(Nu,S1,STR, Temp),
        fronttoken(Temp,_,S2), !.
  maketok(_,INTSTR,int(INTEGER),S,S,0):-
  	trap(str_int(INTSTR,INTEGER),_V,
	term_str(long,_,INTSTR)),
	!.
  maketok(_,LONGSTR,long(LONG),S,S,0):- trap(term_str(long,LONG,LONGSTR),_,fail),!.

  maketok(_,REALSTR,real(REAL),S,S,0):-         /* reals        */
  	str_real(REALSTR,REAL),!.
  maketok(_,STRING,id(STRING),S,S,0):-isname(STRING),!.
  maketok(ErrPos,_,_,_,_,_):-
                        assert(err(error_at(ErrPos,re_sc01))),!,
                        fail.
	
  skipspaces(STR,STR2,NOOFSP):-
	frontchar(STR,CH,STR1),isspace(CH),!,
	skipspaces(STR1,STR2,N1),
	NOOFSP=N1+1.
  skipspaces(STR,STR,0).

