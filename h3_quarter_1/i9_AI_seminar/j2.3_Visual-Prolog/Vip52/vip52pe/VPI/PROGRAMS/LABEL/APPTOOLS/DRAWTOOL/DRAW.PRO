/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	DRAW.PRO
 Purpose:	Drawing operation for Layout editor and Print module
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
include	"tools\\dbase\\readext.pro"
include	"tools\\dbase\\dbase3.pro"

database - draw_db
 dr_odbc_fact

clauses
  dr_odbc():-
	assert(dr_odbc_fact),!.

predicates
  dr_wrap_text(BOOLEAN,ILIST)
clauses
  dr_wrap_text(b_true,[dtext_Wordbreak]):-!.
  dr_wrap_text(b_false,[]):-!.

predicates
  dr_align_text(LE_TEXT_ALIGN,INTEGER)
clauses
  dr_align_text(left,dtext_left):-!.
  dr_align_text(right,dtext_right):-!.
  dr_align_text(center,dtext_center):-!.

predicates
  dr_flags_text(BOOLEAN,LE_TEXT_ALIGN,ILIST)
clauses
  dr_flags_text(Wrap,Align,Flags):-
	dr_wrap_text(Wrap,List),
	dr_align_text(Align,Item),
	Flags = [Item|List],!.

predicates
  dr_dig_str(ULONG Dig,UNSIGNED DigNum,STRING)
  dr_dig_str1(ULONG InitDivider,UNSIGNED DigNum,ULONG Divider)
  dr_dig_str1(ULONG Dig,ULONG Divider,STRING,STRING)
clauses
  dr_dig_str(Dig,0,String):-
	format(String,"%",Dig),!.
  dr_dig_str(Dig,DigNum,String):-
	dr_dig_str1(1,DigNum,Divider),
	dr_dig_str1(Dig,Divider,"",String),!.

  dr_dig_str1(Divider,1,Divider):-!.
  dr_dig_str1(Div,DigNum,Divider):-
	Div1 = Div * 10,
	DN = DigNum - 1,!,
	dr_dig_str1(Div1,DN,Divider).

  dr_dig_str1(Dig,1,Str,String):-
	format(S,"%",Dig),
	concat(Str,S,String),!.
  dr_dig_str1(Dig,Divider,Str,String):-
	D = Dig div Divider,
	format(S,"%",D),
	concat(Str,S,Str1),
	D1 = Dig - D * Divider,
	Div = Divider div 10,!,
	dr_dig_str1(D1,Div,Str1,String).

predicates
  dr_calc_counter(ULONG Count,ULONG Beg,ULONG End,ULONG Step,ULONG Answer)
clauses
  dr_calc_counter(_,Beg,_,0,Beg):-!.
  dr_calc_counter(Count,Beg,0,Step,Answer):-
	Answer = Beg + Step * (Count - 1),!.
  dr_calc_counter(Count,Beg,End,Step,Answer):-
	Num = (Count-1) mod (((End-Beg) div Step) + 1),
	Answer = Beg + Step * Num,!.
%  dr_calc_counter(Count,Beg,End,Step,Answer):-
%	Answer = Beg + (Step * (Count - 1)) mod (End - Beg + 1),!.


predicates
  dr_draw_border(BOOLEAN Design,WINDOW,RCT,PEN In,PEN Out)
clauses
  dr_draw_border(b_true,Win,rct(L,T,R,B),pen(_,ps_Hollow,Color),pen(10,ps_Hollow,Color)):-
	L1 = L + 5, T1 = T + 5, R1 = R - 5, B1 = B - 5,
	win_SetPen(Win,pen(1,ps_Hollow,color_White)),
	win_SetBrush(Win,brush(pat_FDiag,color_Black)),
	draw_Rect(Win,rct(L,T,L1,B1)),
	draw_Rect(Win,rct(L,B1,R1,B)),
	draw_Rect(Win,rct(R1,T1,R,B)),
	draw_Rect(Win,rct(L1,T,R,T1)),!.
  dr_draw_border(_,_,_,InPen,InPen):-!.

predicates
  procedure dr_draw_TextInRect(BOOLEAN Design,BOOLEAN Print,REAL PixInMM,WINDOW Win,RCT Rect,STRING,INTEGER StrLen,ILIST Flags)
clauses
  dr_draw_TextInRect(b_false,b_false,PixInMM,Win,Rect,Str,StrLen,Flags):-
	Scale = PixInMM / 4,
	Font = win_GetFont(Win),
	font_GetAttrs(Font,StyleFlags,Size),
	NewSize = Size * Scale,
	NewFont = font_SetAttrs(Font,StyleFlags,NewSize),
	win_SetFont(Win,NewFont),
	draw_TextInRect(Win,Rect,Str,StrLen,Flags),!.
  dr_draw_TextInRect(_,_,_,Win,Rect,Str,StrLen,Flags):-
	draw_TextInRect(Win,Rect,Str,StrLen,Flags),!.

predicates
  dr_draw(BOOLEAN Design,BOOLEAN Print,REAL PixInMM,WINDOW,ULONG Count,RCT,LE_FIELD_TYPE)
  dr_data_request(ULONG Count,LE_FIELD_TYPE,STRING)
clauses
  dr_draw(Design,_,_,Win,_,rct(L,T,R,B),rectangle(PenIn,Brush)):-
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,Brush),
	draw_Rect(Win,rct(L1,T1,R1,B1)),!.
  dr_draw(Design,_,_,Win,_,rct(L,T,R,B),ellipse(PenIn,Brush)):-
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,Brush),
	draw_Ellipse(Win,rct(L1,T1,R1,B1)),!.
  dr_draw(_,_,_,Win,_,rct(L,T,R,B),line(Pen)):-
	win_SetPen(Win,Pen),
	draw_line(Win,pnt(L,T),pnt(R,B)),!.
  dr_draw(Design,_,_,Win,_,rct(L,T,R,B),bitmap(PenIn,FileName,b_true)):-
	trap(Picture = pict_Load(FileName),_,fail),
	pict_GetSize(Picture,Rp1,Bp1,_),
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	pict_Draw(Win,Picture,rct(L1,T1,R1,B1),rct(0,0,Rp1,Bp1),rop_SrcCopy),
	pict_Destroy(Picture),
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,brush(pat_Hollow,color_White)),
	draw_Rect(Win,rct(L1,T1,R1,B1)),!.
  dr_draw(Design,_,_,Win,_,rct(L,T,R,B),bitmap(PenIn,FileName,b_false)):-
	trap(Picture = pict_Load(FileName),_,fail),
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	pict_Draw(Win,Picture,pnt(L1,T1),rop_SrcCopy),
	pict_Destroy(Picture),
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,brush(pat_Hollow,color_White)),
	draw_Rect(Win,rct(L1,T1,R1,B1)),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,bitmap(_,_,_)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg95,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(Design,Print,PixInMM,Win,_,rct(L,T,R,B),text(text(String),Font,_,Color1,Align,PenIn,Brush,Wrap,none)):-
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,Brush),
	win_SetForeColor(Win,Color1),
	win_SetFont(Win,Font),
	draw_Rect(Win,rct(L1,T1,R1,B1)),
	dr_flags_text(Wrap,Align,Flags),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,rct(L1,T1,R1,B1),String,-1,Flags),!.
  dr_draw(_,Print,_,Win,_,Rect,text(text(String),_,_,_,_,Pen,_,_,BarCode)):-
	barcode_draw(Win,Print,Rect,Pen,String,BarCode),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,text(text(_),_,_,_,_,_,_,_,_)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg96,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(Design,Print,PixInMM,Win,Count,rct(L,T,R,B),text(dyntext(Slist),Font,FontName,Color1,Align,PenIn,Brush,Wrap,none)):-
	dr_data_request(Count,text(dyntext(Slist),Font,FontName,Color1,Align,PenIn,Brush,Wrap,none),String),
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,Brush),
	win_SetForeColor(Win,Color1),
	win_SetFont(Win,Font),
	draw_Rect(Win,rct(L1,T1,R1,B1)),
	dr_flags_text(Wrap,Align,Flags),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,rct(L1,T1,R1,B1),String,-1,Flags),!.
  dr_draw(_,Print,_,Win,Count,Rect,text(dyntext(Slist),Font,FontName,Color1,Align,Pen,Brush,Wrap,BarCode)):-
	dr_data_request(Count,text(dyntext(Slist),Font,FontName,Color1,Align,Pen,Brush,Wrap,BarCode),String),
	barcode_draw(Win,Print,Rect,Pen,String,BarCode),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,text(dyntext(_),_,_,_,_,_,_,_,_)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg245,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(Design,Print,PixInMM,Win,Count,rct(L,T,R,B),text(ascii(FileName,From,To),Font,FontName,Color1,Align,PenIn,Brush,Wrap,none)):-
	existfile(FileName),
	dr_data_request(Count,text(ascii(FileName,From,To),Font,FontName,Color1,Align,PenIn,Brush,Wrap,none),String),
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,Brush),
	win_SetForeColor(Win,Color1),
	win_SetFont(Win,Font),
	draw_Rect(Win,rct(L1,T1,R1,B1)),
	dr_flags_text(Wrap,Align,Flags),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,rct(L1,T1,R1,B1),String,-1,Flags),!.
  dr_draw(_,Print,_,Win,Count,Rect,text(ascii(FileName,From,To),Font,FontName,Color,Align,Pen,Brush,Wrap,BarCode)):-
	existfile(FileName),
	dr_data_request(Count,text(ascii(FileName,From,To),Font,FontName,Color,Align,Pen,Brush,Wrap,BarCode),String),
	barcode_draw(Win,Print,Rect,Pen,String,BarCode),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,text(ascii(_,_,_),_,_,_,_,_,_,_,none)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg97,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,text(ascii(_,_,_),_,_,_,_,_,_,_,_)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg98,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
ifdef  use_odbc
  dr_draw(Design,Print,PixInMM,Win,Count,rct(L,T,R,B),text(odbc(BaseName,TableName,Column,UserName,Password),Font,FontName,Color1,Align,PenIn,Brush,Wrap,none)):-
	dr_data_request(Count,text(odbc(BaseName,TableName,Column,UserName,Password),Font,FontName,Color1,Align,PenIn,Brush,Wrap,none),String),
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,Brush),
	win_SetForeColor(Win,Color1),
	win_SetFont(Win,Font),
	draw_Rect(Win,rct(L1,T1,R1,B1)),
	dr_flags_text(Wrap,Align,Flags),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,rct(L1,T1,R1,B1),String,-1,Flags),!.
  dr_draw(_,Print,_,Win,Count,Rect,text(odbc(BaseName,TableName,Column,UserName,Password),Font,FontName,Color1,Align,Pen,Brush,Wrap,BarCode)):-
	dr_data_request(Count,text(odbc(BaseName,TableName,Column,UserName,Password),Font,FontName,Color1,Align,Pen,Brush,Wrap,BarCode),String),
	barcode_draw(Win,Print,Rect,Pen,String,BarCode),!.
enddef
  dr_draw(Design,Print,PixInMM,Win,_,Rect,text(odbc(_,_,_,_,_),_,_,_,_,_,_,_,none)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg99,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,text(odbc(_,_,_,_,_),_,_,_,_,_,_,_,_)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg100,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(Design,Print,PixInMM,Win,Count,rct(L,T,R,B),text(dbase(FileName,Column),Font,FontName,Color1,Align,PenIn,Brush,Wrap,none)):-
	existfile(FileName),
	dr_data_request(Count,text(dbase(FileName,Column),Font,FontName,Color1,Align,PenIn,Brush,Wrap,none),String),
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,Brush),
	win_SetForeColor(Win,Color1),
	win_SetFont(Win,Font),
	draw_Rect(Win,rct(L1,T1,R1,B1)),
	dr_flags_text(Wrap,Align,Flags),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,rct(L1,T1,R1,B1),String,-1,Flags),!.
  dr_draw(_,Print,_,Win,Count,Rect,text(dbase(FileName,Column),Font,FontName,Color1,Align,Pen,Brush,Wrap,BarCode)):-
	existfile(FileName),
	dr_data_request(Count,text(dbase(FileName,Column),Font,FontName,Color1,Align,Pen,Brush,Wrap,BarCode),String),
	barcode_draw(Win,Print,Rect,Pen,String,BarCode),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,text(dbase(_,_),_,_,_,_,_,_,_,none)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg101,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,text(dbase(_,_),_,_,_,_,_,_,_,_)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg102,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(Design,Print,PixInMM,Win,Count,rct(L,T,R,B),text(date(FormatStr,Shift),Font,FontName,Color1,Align,PenIn,Brush,Wrap,none)):-
	dr_data_request(Count,text(date(FormatStr,Shift),Font,FontName,Color1,Align,PenIn,Brush,Wrap,none),String),
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,Brush),
	win_SetForeColor(Win,Color1),
	win_SetFont(Win,Font),
	draw_Rect(Win,rct(L1,T1,R1,B1)),
	dr_flags_text(Wrap,Align,Flags),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,rct(L1,T1,R1,B1),String,-1,Flags),!.
  dr_draw(_,Print,_,Win,Count,Rect,text(date(FormatStr,Shift),Font,FontName,Color1,Align,Pen,Brush,Wrap,BarCode)):-
	dr_data_request(Count,text(date(FormatStr,Shift),Font,FontName,Color1,Align,Pen,Brush,Wrap,BarCode),String),
	barcode_draw(Win,Print,Rect,Pen,String,BarCode),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,text(date(_,_),_,_,_,_,_,_,_,none)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg171,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,text(date(_,_),_,_,_,_,_,_,_,_)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg172,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(Design,Print,PixInMM,Win,Count,rct(L,T,R,B),counter(Beg,End,Step,DigNum,Font,_,Color1,Align,PenIn,Brush,none)):-
	dr_draw_border(Design,Win,rct(L,T,R,B),PenIn,pen(Width,Style,Color)),
	D = Width div 2,
	L1 = L + D, T1 = T + D, R1 = R - D, B1 = B - D,
	win_SetPen(Win,pen(Width,Style,Color)),
	win_SetBrush(Win,Brush),
	win_SetForeColor(Win,Color1),
	win_SetFont(Win,Font),
	draw_Rect(Win,rct(L1,T1,R1,B1)),
	dr_calc_counter(Count,Beg,End,Step,Answer),
	dr_dig_str(Answer,DigNum,String),
	dr_flags_text(b_false,Align,Flags),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,rct(L1,T1,R1,B1),String,-1,Flags),!.
  dr_draw(_,_,_,Win,Count,Rect,counter(Beg,End,Step,DigNum,_,_,_,_,Pen,_,BarCode)):-
	dr_calc_counter(Count,Beg,End,Step,Answer),
	dr_dig_str(Answer,DigNum,String),
	barcode_draw(Win,b_false,Rect,Pen,String,BarCode),!.
  dr_draw(Design,Print,PixInMM,Win,_,Rect,counter(_,_,_,_,_,_,_,_,_,_,_)):-
	Font = font_Create(ff_System,[],10),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetForeColor(Win,color_Red),
	win_SetFont(Win,Font),
	draw_Rect(Win,Rect),
	dr_draw_TextInRect(Design,Print,PixInMM,Win,Rect,label_msg103,-1,[dtext_singleline,dtext_center,dtext_vcenter]),!.
  dr_draw(_,_,_,_,_,_,_).

  dr_draw_field(Design,Print,PixInMM,Win,Count,Rect,angle_0,Style):-
	dr_draw(Design,Print,PixInMM,Win,Count,Rect,Style),!.
  dr_draw_field(Design,Print,PixInMM,Win,Count,rct(L,T,R,B),angle_90,Style):-
	Pict1 = pict_GetFromWin(Win,rct(L,T,R,B)),
	Pict2 = pict_Rotate(Pict1,pictRotate_270deg),
	pict_Destroy(Pict1),
	Width = B - T, Height = R - L,
	PictWin3 = pict_Open(rct(0,0,Width,Height)),
	pict_Draw(PictWin3,Pict2,pnt(0,0),rop_SrcCopy),
	pict_Destroy(Pict2),
	dr_draw(Design,Print,PixInMM,PictWin3,Count,rct(0,0,Width,Height),Style),
	Pict3 = pict_Close(PictWin3),
	Pict4 = pict_Rotate(Pict3,pictRotate_90deg),
	pict_Destroy(Pict3),
	pict_Draw(Win,Pict4,pnt(L,T),rop_SrcCopy),
	pict_Destroy(Pict4),!.
  dr_draw_field(Design,Print,PixInMM,Win,Count,rct(L,T,R,B),angle_270,Style):-
	Pict1 = pict_GetFromWin(Win,rct(L,T,R,B)),
	Pict2 = pict_Rotate(Pict1,pictRotate_90deg),
	pict_Destroy(Pict1),
	Width = B - T, Height = R - L,
	PictWin3 = pict_Open(rct(0,0,Width,Height)),
	pict_Draw(PictWin3,Pict2,pnt(0,0),rop_SrcCopy),
	pict_Destroy(Pict2),
	dr_draw(Design,Print,PixInMM,PictWin3,Count,rct(0,0,Width,Height),Style),
	Pict3 = pict_Close(PictWin3),
	Pict4 = pict_Rotate(Pict3,pictRotate_270deg),
	pict_Destroy(Pict3),
	pict_Draw(Win,Pict4,pnt(L,T),rop_SrcCopy),
	pict_Destroy(Pict4),!.
  dr_draw_field(Design,Print,PixInMM,Win,Count,rct(L,T,R,B),angle_180,Style):-
	Pict1 = pict_GetFromWin(Win,rct(L,T,R,B)),
	Pict2 = pict_Rotate(Pict1,pictRotate_180deg),
	pict_Destroy(Pict1),
	Width = R - L, Height = B - T,
	PictWin3 = pict_Open(rct(0,0,Width,Height)),
	pict_Draw(PictWin3,Pict2,pnt(0,0),rop_SrcCopy),
	pict_Destroy(Pict2),
	dr_draw(Design,Print,PixInMM,PictWin3,Count,rct(0,0,Width,Height),Style),
	Pict3 = pict_Close(PictWin3),
	Pict4 = pict_Rotate(Pict3,pictRotate_180deg),
	pict_Destroy(Pict3),
	pict_Draw(Win,Pict4,pnt(L,T),rop_SrcCopy),
	pict_Destroy(Pict4),!.

predicates
  dr_read_ln(FILE,STRING FileName,ULONG Count,STRING OutString)
clauses
  dr_read_ln(_,_,1,String):-
	readln(String),!.
  dr_read_ln(File,FileName,Count,String):-
	readln(_),
	C = Count - 1,!,
	dr_read_ln(File,FileName,C,String).
  dr_read_ln(File,FileName,Count,String):-
	closefile(le_file),
	openread(le_file,FileName),
	readdevice(le_file),!,
	dr_read_ln(File,FileName,Count,String).

predicates
  dr_read_db(FILE,STRING FileName,REAL,FldDescL,ULONG Count,Dbase3Rec)
clauses
  dr_read_db(_,_,TotRecs,FldDescL,1,Rec):-
	rd_Dbase3Rec(TotRecs,le_file,FldDescL,Rec),!.
  dr_read_db(File,FileName,TotRecs,FldDescL,Count,Rec):-
	rd_Dbase3Rec(TotRecs,le_file,FldDescL,_),
	C = Count - 1,!,
	dr_read_db(File,FileName,TotRecs,FldDescL,C,Rec).
  dr_read_db(File,FileName,TotRecs,FldDescL,Count,Rec):-
	closefile(le_file),
	openread(le_file,FileName),
	filemode(le_file,0),
	readdevice(le_file),!,
	dr_read_db(File,FileName,TotRecs,FldDescL,Count,Rec).

predicates
  dr_get_data1(Dbase3Elem,STRING)
clauses
  dr_get_data1(char(String),String):-!.
  dr_get_data1(real(Real),String):-
	str_real(String,Real),!.
  dr_get_data1(logical(b_true),"1"):-!.
  dr_get_data1(logical(b_false),"0"):-!.
  dr_get_data1(date(String),String):-!.
  dr_get_data1(memo(_),_):-!,fail.

predicates
  dr_reverse_str(STRING InStr,STRING OutStr,STRING OutStr)
clauses
  dr_reverse_str("",OutStr,OutStr):-!.
  dr_reverse_str(InStr,OS,OutStr):-
	frontchar(InStr,Char,IS),
	frontchar(OS1,Char,OS),!,
	dr_reverse_str(IS,OS1,OutStr).

predicates
  dr_del_first_spaces(STRING InStr,STRING OutStr)
clauses
  dr_del_first_spaces(InStr,OutStr):-
	frontchar(InStr,' ',IS),!,
	dr_del_first_spaces(IS,OutStr).
  dr_del_first_spaces(OutStr,OutStr).

predicates
  dr_del_last_spaces(STRING InStr,STRING OutStr)
clauses
  dr_del_last_spaces(InStr,OutStr):-
	dr_reverse_str(InStr,"",InStr1),
	dr_del_first_spaces(InStr1,InStr2),
	dr_reverse_str(InStr2,"",OutStr),!.

predicates
  dr_read_subfield(Dbase3Rec,ULONG Count,STRING)
clauses
  dr_read_subfield([],_,_):-!,fail.
  dr_read_subfield([Item|_],1,String):-!,
	dr_get_data1(Item,String1),
	dr_del_last_spaces(String1,String).
  dr_read_subfield([_|Rest],Column,String):-
	C = Column - 1,!,
	dr_read_subfield(Rest,C,String).

predicates
  dr_read_substr(INTEGER From,INTEGER To,STRING In,STRING Out)
clauses
  dr_read_substr(From,To,In,Out):-
	F = From - 1,
	frontstr(F,In,_,String),
	T = To - From + 1,
	frontstr(T,String,Out,_),!.

ifdef  use_odbc
predicates
  dr_set_row(HENV,HDBC,HSTMT,ULONG Count,STRING SelectStr)
clauses
  dr_set_row(_,_,_,1,_):-!.
  dr_set_row(Henv,Hdbc,Hstmt,Count,SelectStr):-
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,fail),
	C = Count - 1,!,
	dr_set_row(Henv,Hdbc,Hstmt,C,SelectStr).
  dr_set_row(Henv,Hdbc,Hstmt,Count,SelectStr):-
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SelectStr),_,fail),!,
	dr_set_row(Henv,Hdbc,Hstmt,Count,SelectStr).
predicates
  dr_get_data(ODBC_DATA,STRING)
clauses
  dr_get_data(s(DataS),DataS):-!.
  dr_get_data(bit(Data),DataS):-
	str_int(DataS,Data),!.
  dr_get_data(byte(Data),DataS):-
	str_int(DataS,Data),!.
  dr_get_data(i(Data),DataS):-
	str_int(DataS,Data),!.
  dr_get_data(l(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  dr_get_data(f(Data),DataS):-
	str_real(DataS,Data),!.
  dr_get_data(r(Data),DataS):-
	str_real(DataS,Data),!.
  dr_get_data(d(DataS),DataS):-!.
  dr_get_data(t(DataS),DataS):-!.
  dr_get_data(ts(DataS),DataS):-!.
  dr_get_data(n(DataS),DataS):-!.
enddef

predicates
  dr_listlength(SLIST,INTEGER)
clauses
  dr_listlength([],0):-!.
  dr_listlength([_|T],N1):-
	dr_listlength(T,N),
	N1=N+1.

predicates
  dr_member_index(STRING,SLIST,UNSIGNED)
clauses
  dr_member_index(S,[S|_],1):-!.
  dr_member_index(S,[_|L],M):-
        bound(M),!,
        N = M - 1,
        dr_member_index(S,L,N),!.
  dr_member_index(S,[_|L],M):-
        dr_member_index(S,L,N),!,
        M = N + 1.

  dr_data_request(Count,text(dyntext(Slist),_,_,_,_,_,_,_,_),String):-
	dr_listlength(Slist,Lenght),
	C = ((Count - 1) mod Lenght) + 1,
	dr_member_index(String,Slist,C),!.
  dr_data_request(Count,text(ascii(FileName,From,To),_,_,_,_,_,_,_,_),String):-
	closefile(le_file),
	openread(le_file,FileName),
	readdevice(le_file),
	dr_read_ln(le_file,FileName,Count,Str),
	closefile(le_file),
	dr_read_substr(From,To,Str,String),!.
  dr_data_request(_,text(date(FormatStr,Shift),_,_,_,_,_,_,_,_),String):-
	date(Year,Month,Day1),
	Day = Day1 + Shift,
	time(Hours,Minutes,_,_),
	dt_min_to_offset(Year,Month,Day,Hours,Minutes,MinutOffset),
	dt_minoffset_to_str(MinutOffset,FormatStr,String),!.
ifdef  use_odbc
  dr_data_request(Count,text(odbc(BaseName,TableName,Column,UserName,Password),_,_,_,_,_,_,_,_),String):-
	dr_odbc_fact,
	trap(odbcAllocEnv(Henv),_,fail),
	trap(odbcAllocConnect(Henv,Hdbc),_,fail),
	trap(odbcConnect(Henv,Hdbc,BaseName,UserName,Password),_,fail),
	trap(odbcAllocStmt(Henv,Hdbc,Hstmt),_,fail),
	format(SelectStr,"SELECT * FROM %s",TableName),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SelectStr),_,fail),
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,fail),
	dr_set_row(Henv,Hdbc,Hstmt,Count,SelectStr),
	trap(odbcDescribeCol(Henv,Hdbc,Hstmt,Column,_,DataType,_,_,_),_,fail),
	trap(odbcGetData(Henv,Hdbc,Hstmt,Column,DataType,1000,Answer,_),_,fail),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_drop),_,fail),
	trap(odbcDisconnect(Henv,Hdbc),_,fail),
	trap(odbcFreeConnect(Henv,Hdbc),_,fail),
	trap(odbcFreeEnv(Henv),_,fail),
	dr_get_data(Answer,String),!.
enddef
  dr_data_request(Count1,text(dbase(FileName,Column),_,_,_,_,_,_,_,_),String):-
	closefile(le_file),
	openread(le_file,FileName),
	filemode(le_file,0),
	readdevice(le_file),
	init_dbase3(TotRecs,_,FldDescL),
	TotRecs1 = val(long,TotRecs),
	Count = (Count1 - 1) mod TotRecs1 + 1,
	dr_read_db(le_file,FileName,TotRecs,FldDescL,Count,Answer),
	closefile(le_file),
	dr_read_subfield(Answer,Column,String),!.

