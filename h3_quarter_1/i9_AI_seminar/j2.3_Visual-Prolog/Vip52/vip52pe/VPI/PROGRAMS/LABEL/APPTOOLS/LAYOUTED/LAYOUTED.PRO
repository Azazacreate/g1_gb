/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	LAYOUTED.PRO
 Purpose:	Layout editor
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
include "apptools\\layouted\\layoute1.pro"
include "apptools\\layouted\\layoute2.pro"

predicates
  le_color(COLOR,INTEGER)
clauses
  le_color(0xFFFFFF,0):-!.
  le_color(0x000000,1):-!.
  le_color(0x808080,2):-!.
  le_color(0xC0C0C0,3):-!.
  le_color(0x0000FF,4):-!.
  le_color(0x000080,5):-!.
  le_color(0x00FF00,6):-!.
  le_color(0x008000,7):-!.
  le_color(0xFF0000,8):-!.
  le_color(0x800000,9):-!.
  le_color(0xFFFF00,10):-!.
  le_color(0x808000,11):-!.
  le_color(0xFF00FF,12):-!.
  le_color(0x800080,13):-!.
  le_color(0x00FFFF,14):-!.
  le_color(0x008080,15):-!.

predicates
  le_pen(PENSTYLE,INTEGER)
clauses
  le_pen(ps_Solid,0):-!.
  le_pen(ps_Dash,1):-!.
  le_pen(ps_Dot,2):-!.
  le_pen(ps_DashDot,3):-!.
  le_pen(ps_DashDotDot,4):-!.
  le_pen(ps_Hollow,5):-!.

predicates
  le_pen1(INTEGER,PENSTYLE,INTEGER,INTEGER)
clauses
  le_pen1(Width,ps_Solid,Width,0):-!.
  le_pen1(1,ps_Dash,_,1):-!.
  le_pen1(1,ps_Dot,_,2):-!.
  le_pen1(1,ps_DashDot,_,3):-!.
  le_pen1(1,ps_DashDotDot,_,4):-!.
  le_pen1(1,ps_Hollow,_,5):-!.

predicates
  le_text_align(LE_TEXT_ALIGN,INTEGER)
clauses
  le_text_align(left,0):-!.
  le_text_align(right,1):-!.
  le_text_align(center,2):-!.

predicates
  le_brush(PATSTYLE,INTEGER)
clauses
  le_brush(pat_Hollow,0):-!.
  le_brush(pat_Solid,1):-!.
  le_brush(pat_Horz,2):-!.
  le_brush(pat_Vert,3):-!.
  le_brush(pat_FDiag,4):-!.
  le_brush(pat_BDiag,5):-!.
  le_brush(pat_Cross,6):-!.
  le_brush(pat_DiagCross,7):-!.

predicates
  le_text(LE_FIELD_TEXT,INTEGER)
  le_text(LE_FIELD_TEXT,INTEGER,LE_FIELD_TEXT)
clauses
  le_text(text(_),0):-!.
  le_text(dyntext(_),1):-!.
  le_text(date(_,_),2):-!.
  le_text(ascii(_,_,_),3):-!.
  le_text(odbc(_,_,_,_,_),4):-!.
  le_text(dbase(_,_),5):-!.

  le_text(text(S),0,text(S)):-!.
  le_text(text(S),1,dyntext([S])):-!.
  le_text(text(S),2,date(S,0)):-!.
  le_text(text(S),3,ascii(S,1,1)):-!.
  le_text(text(S),4,odbc(S,"",1,"","")):-!.
  le_text(text(S),5,dbase(S,1)):-!.
  le_text(ascii(S,_,_),0,text(S)):-!.
  le_text(ascii(S,_,_),1,dyntext([S])):-!.
  le_text(ascii(_,_,_),2,date("",0)):-!.
  le_text(ascii(S,F,T),3,ascii(S,F,T)):-!.
  le_text(ascii(_,_,_),4,odbc("","",1,"","")):-!.
  le_text(ascii(S,_,_),5,dbase(S,1)):-!.
  le_text(odbc(S,_,_,_,_),0,text(S)):-!.
  le_text(odbc(S,_,_,_,_),1,dyntext([S])):-!.
  le_text(odbc(_,_,_,_,_),2,date("",0)):-!.
  le_text(odbc(_,_,_,_,_),3,ascii("",1,1)):-!.
  le_text(odbc(S1,S2,S3,S4,S5),4,odbc(S1,S2,S3,S4,S5)):-!.
  le_text(odbc(_,_,_,_,_),5,dbase("",1)):-!.
  le_text(dbase(S,_),0,text(S)):-!.
  le_text(dbase(S,_),1,dyntext([S])):-!.
  le_text(dbase(_,_),2,date("",0)):-!.
  le_text(dbase(S,_),3,ascii(S,1,1)):-!.
  le_text(dbase(_,_),4,odbc("","",1,"","")):-!.
  le_text(dbase(S,S1),5,dbase(S,S1)):-!.
  le_text(date(S,_),0,text(S)):-!.
  le_text(date(S,_),1,dyntext([S])):-!.
  le_text(date(S1,S2),2,date(S1,S2)):-!.
  le_text(date(_,_),3,ascii("",1,1)):-!.
  le_text(date(_,_),4,odbc("","",1,"","")):-!.
  le_text(date(_,_),5,dbase("",1)):-!.
  le_text(dyntext([S|_]),0,text(S)):-!.
  le_text(dyntext([S|_]),1,dyntext([S])):-!.
  le_text(dyntext([S|_]),2,date(S,0)):-!.
  le_text(dyntext([S|_]),3,ascii(S,1,1)):-!.
  le_text(dyntext([S|_]),4,odbc(S,"",1,"","")):-!.
  le_text(dyntext([S|_]),5,dbase(S,1)):-!.

predicates
  le_orientation(LE_FIELD_ORIENTATION,INTEGER)
clauses
  le_orientation(angle_0,0):-!.
  le_orientation(angle_90,1):-!.
  le_orientation(angle_180,2):-!.
  le_orientation(angle_270,3):-!.

predicates
  le_stretch(BOOLEAN,INTEGER)
clauses
  le_stretch(b_true,0):-!.
  le_stretch(b_false,1):-!.

predicates
  le_barcod(BARCODE_TYPE,INTEGER)
clauses
  le_barcod(none,0):-!.
  le_barcod(upc_a,1):-!.
  le_barcod(ean_13,2):-!.
  le_barcod(ean_8,3):-!.
  le_barcod(s_2_5,4):-!.
  le_barcod(s_39,5):-!.

predicates
  le_visible(LAYOUT_GRID,INTEGER)
clauses
  le_visible(invisible,0):-!.
  le_visible(dot(color_Black),1):-!.
  le_visible(line(color_Black),2):-!.

predicates
  le_correct_visible(LAYOUT_GRID,COLOR,LAYOUT_GRID)
clauses
  le_correct_visible(invisible,_,invisible):-!.
  le_correct_visible(dot(_),Color,dot(Color)):-!.
  le_correct_visible(line(_),Color,line(Color)):-!.

predicates
  le_change_prop1(INTEGER PrId,LE_FIELD_TYPE,PROPERTY_CTRLVAL,LE_FIELD_TYPE)
  le_change_default(INTEGER PrId,PROPERTY_CTRLVAL)
clauses
  le_change_default(le_Pen_Width,editInt(i(Width))):-
	retract(le_layout_style(pen(_,Style,Color),Brush,TextColor,PictStretch,WrapText)),
	assert(le_layout_style(pen(Width,Style,Color),Brush,TextColor,PictStretch,WrapText)),!.
  le_change_default(le_Pen_Style,listButton(S)):-
	le_pen(Style,S),
	retract(le_layout_style(pen(Width,_,Color),Brush,TextColor,PictStretch,WrapText)),
	assert(le_layout_style(pen(Width,Style,Color),Brush,TextColor,PictStretch,WrapText)),!.
  le_change_default(le_Pen_Color,listButton(S)):-
	le_color(Color,S),
	retract(le_layout_style(pen(Width,Style,_),Brush,TextColor,PictStretch,WrapText)),
	assert(le_layout_style(pen(Width,Style,Color),Brush,TextColor,PictStretch,WrapText)),!.
  le_change_default(le_Brush_Style,listButton(S)):-
	le_brush(Style,S),
	retract(le_layout_style(Pen,brush(_,Color),TextColor,PictStretch,WrapText)),
	assert(le_layout_style(Pen,brush(Style,Color),TextColor,PictStretch,WrapText)),!.
  le_change_default(le_Brush_Color,listButton(S)):-
	le_color(Color,S),
	retract(le_layout_style(Pen,brush(Style,_),TextColor,PictStretch,WrapText)),
	assert(le_layout_style(Pen,brush(Style,Color),TextColor,PictStretch,WrapText)),!.
  le_change_default(le_Text_Counter_Color,listButton(S)):-
	le_color(TextColor,S),
	retract(le_layout_style(Pen,Brush,_,PictStretch,WrapText)),
	assert(le_layout_style(Pen,Brush,TextColor,PictStretch,WrapText)),!.
  le_change_default(le_Bitmap_Stretch,listButton(S)):-
	le_stretch(Stretch,S),
	retract(le_layout_style(Pen,Brush,TextColor,_,WrapText)),
	assert(le_layout_style(Pen,Brush,TextColor,Stretch,WrapText)),!.
  le_change_default(le_Text_Wrap,listButton(S)):-
	le_stretch(Wrap,S),
	retract(le_layout_style(Pen,Brush,TextColor,PictStretch,_)),
	assert(le_layout_style(Pen,Brush,TextColor,PictStretch,Wrap)),!.

  le_change_prop(_,_,_,PrId,Value):-
	le_change_default(PrId,Value),
	fail.
  le_change_prop(LEWin,_,_,le_Grid_HorStep,editInt(i(GridHorStep))):-
	retract(le_grid_set(LEWin,_,GridVerStep,Visible,Color,SnapToGrid)),
	assert(le_grid_set(LEWin,GridHorStep,GridVerStep,Visible,Color,SnapToGrid)),
	le_grid(LEWin),!.
  le_change_prop(LEWin,_,_,le_Grid_VerStep,editInt(i(GridVerStep))):-
	retract(le_grid_set(LEWin,GridHorStep,_,Visible,Color,SnapToGrid)),
	assert(le_grid_set(LEWin,GridHorStep,GridVerStep,Visible,Color,SnapToGrid)),
	le_grid(LEWin),!.
  le_change_prop(LEWin,_,_,le_Grid_Visible,listButton(S)):-
	retract(le_grid_set(LEWin,GridHorStep,GridVerStep,_,Color,SnapToGrid)),
	le_visible(Visible1,S),
	le_correct_visible(Visible1,Color,Visible),
	assert(le_grid_set(LEWin,GridHorStep,GridVerStep,Visible,Color,SnapToGrid)),
	le_grid(LEWin),!.
  le_change_prop(LEWin,_,_,le_Grid_Color,listButton(S)):-
	retract(le_grid_set(LEWin,GridHorStep,GridVerStep,Visible,_,SnapToGrid)),
	le_color(Color,S),
	le_correct_visible(Visible,Color,Visible1),
	assert(le_grid_set(LEWin,GridHorStep,GridVerStep,Visible1,Color,SnapToGrid)),
	le_grid(LEWin),!.
  le_change_prop(LEWin,_,_,le_Grid_Snap,listButton(S)):-
	le_stretch(SnapToGrid,S),
	retract(le_grid_set(LEWin,GridHorStep,GridVerStep,Visible,Color,_)),
	assert(le_grid_set(LEWin,GridHorStep,GridVerStep,Visible,Color,SnapToGrid)),
	le_grid(LEWin),!.
  le_change_prop(LEWin,LOWin,IdList,le_Rect_Left,editReal(r(Left))):-
	layout_rectangle(LOWin,IdList,Rect),
	Rect = rct(L,T,R,B),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	L1=Left*PixInMM,T1=T,R1=L1+(R-L),B1=B,
	L2=val(integer,L1),T2=val(integer,T1),R2=val(integer,R1),B2=val(integer,B1),
	layout_rectangle(LOWin,IdList,rct(L2,T2,R2,B2)),!.
  le_change_prop(LEWin,LOWin,IdList,le_Rect_Top,editReal(r(Top))):-
	layout_rectangle(LOWin,IdList,Rect),
	Rect = rct(L,T,R,B),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	L1=L,T1=Top*PixInMM,R1=R,B1=T1+(B-T),
	L2=val(integer,L1),T2=val(integer,T1),R2=val(integer,R1),B2=val(integer,B1),
	layout_rectangle(LOWin,IdList,rct(L2,T2,R2,B2)),!.
  le_change_prop(LEWin,LOWin,IdList,le_Rect_Width,editReal(r(Width))):-
	layout_rectangle(LOWin,IdList,Rect),
	Rect = rct(L,T,_,B),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	L1=L,T1=T,R1=L1+Width*PixInMM,B1=B,
	L2=val(integer,L1),T2=val(integer,T1),R2=val(integer,R1),B2=val(integer,B1),
	layout_rectangle(LOWin,IdList,rct(L2,T2,R2,B2)),!.
  le_change_prop(LEWin,LOWin,IdList,le_Rect_Heght,editReal(r(Height))):-
	layout_rectangle(LOWin,IdList,Rect),
	Rect = rct(L,T,R,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	L1=L,T1=T,R1=R,B1=T1+Height*PixInMM,
	L2=val(integer,L1),T2=val(integer,T1),R2=val(integer,R1),B2=val(integer,B1),
	layout_rectangle(LOWin,IdList,rct(L2,T2,R2,B2)),!.
  le_change_prop(LEWin,LOWin,[LId|Rest],le_Orientation_id,listButton(Selected)):-
	le_orientation(Orientation,Selected),
	retract(le_field_info(LEWin,LId,OrientationOld,Type)),
	assert(le_field_info(LEWin,LId,Orientation,Type)),!,
	le_to_stack(init(LEWin,LId,OrientationOld,Type,Orientation,Type)),
	le_redraw_fields(LOWin,[LId]),
	le_change_prop(LEWin,LOWin,Rest,le_Orientation_id,listButton(Selected)).
  le_change_prop(LEWin,LOWin,[LId|Rest],PrId,Value):-
	retract(le_field_info(LEWin,LId,Orientation,Type)),
	le_change_prop1(PrId,Type,Value,Type1),
	assert(le_field_info(LEWin,LId,Orientation,Type1)),!,
	le_to_stack(init(LEWin,LId,Orientation,Type,Orientation,Type1)),
	le_redraw_fields(LOWin,[LId]),
	le_change_prop(LEWin,LOWin,Rest,PrId,Value).
  le_change_prop(LEWIn,_,_,le_TEXT_STYLE,_):-
	le_prop_status(LEWin),!.
  le_change_prop(_,_,_,_,_).

  le_change_prop1(le_Pen_Width,rectangle(pen(_,Style,Color),Brush),
	editInt(i(Width)),rectangle(pen(Width,Style,Color),Brush)):-!.
  le_change_prop1(le_Pen_Width,ellipse(pen(_,Style,Color),Brush),
	editInt(i(Width)),ellipse(pen(Width,Style,Color),Brush)):-!.
  le_change_prop1(le_Pen_Width,bitmap(pen(_,Style,Color),FileName,Stretch),
	editInt(i(Width)),bitmap(pen(Width,Style,Color),FileName,Stretch)):-!.
  le_change_prop1(le_Pen_Width,text(String,Font,FontName,TextColor,Align,pen(_,Style,Color),Brush,Wrap,Barcode),
	editInt(i(Width)),text(String,Font,FontName,TextColor,Align,pen(Width,Style,Color),Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_Pen_Width,counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,pen(_,Style,Color),Brush,Barcode),
	editInt(i(Width)),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,pen(Width,Style,Color),Brush,Barcode)):-!.
  le_change_prop1(le_Pen_Width,line(pen(_,Style,Color)),
	editInt(i(Width)),line(pen(Width,Style,Color))):-!.
  le_change_prop1(le_Pen_Style,rectangle(pen(Width,_,Color),Brush),
	listButton(S),rectangle(pen(Width1,Style,Color),Brush)):-
	le_pen1(Width1,Style,Width,S),!.
  le_change_prop1(le_Pen_Style,ellipse(pen(Width,_,Color),Brush),
	listButton(S),ellipse(pen(Width1,Style,Color),Brush)):-
	le_pen1(Width1,Style,Width,S),!.
  le_change_prop1(le_Pen_Style,bitmap(pen(Width,_,Color),FileName,Stretch),
	listButton(S),bitmap(pen(Width1,Style,Color),FileName,Stretch)):-
	le_pen1(Width1,Style,Width,S),!.
  le_change_prop1(le_Pen_Style,text(String,Font,FontName,TextColor,Align,pen(Width,_,Color),Brush,Wrap,Barcode),
	listButton(S),text(String,Font,FontName,TextColor,Align,pen(Width1,Style,Color),Brush,Wrap,Barcode)):-
	le_pen1(Width1,Style,Width,S),!.
  le_change_prop1(le_Pen_Style,counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,pen(Width,_,Color),Brush,Barcode),
	listButton(S),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,pen(Width1,Style,Color),Brush,Barcode)):-
	le_pen1(Width1,Style,Width,S),!.
  le_change_prop1(le_Pen_Style,line(pen(Width,_,Color)),
	listButton(S),line(pen(Width1,Style,Color))):-
	le_pen1(Width1,Style,Width,S),!.
  le_change_prop1(le_Pen_Color,rectangle(pen(Width,Style,_),Brush),
	listButton(S),rectangle(pen(Width,Style,Color),Brush)):-
	le_color(Color,S),!.
  le_change_prop1(le_Pen_Color,ellipse(pen(Width,Style,_),Brush),
	listButton(S),ellipse(pen(Width,Style,Color),Brush)):-
	le_color(Color,S),!.
  le_change_prop1(le_Pen_Color,bitmap(pen(Width,Style,_),FileName,Stretch),
	listButton(S),bitmap(pen(Width,Style,Color),FileName,Stretch)):-
	le_color(Color,S),!.
  le_change_prop1(le_Pen_Color,text(String,Font,FontName,TextColor,Align,pen(Width,Style,_),Brush,Wrap,Barcode),
	listButton(S),text(String,Font,FontName,TextColor,Align,pen(Width,Style,Color),Brush,Wrap,Barcode)):-
	le_color(Color,S),!.
  le_change_prop1(le_Pen_Color,counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,pen(Width,Style,_),Brush,Barcode),
	listButton(S),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,pen(Width,Style,Color),Brush,Barcode)):-
	le_color(Color,S),!.
  le_change_prop1(le_Pen_Color,line(pen(Width,Style,_)),
	listButton(S),line(pen(Width,Style,Color))):-
	le_color(Color,S),!.
  le_change_prop1(le_Brush_Style,rectangle(Pen,brush(_,Color)),
	listButton(S),rectangle(Pen,brush(Style,Color))):-
	le_brush(Style,S),!.
  le_change_prop1(le_Brush_Style,ellipse(Pen,brush(_,Color)),
	listButton(S),ellipse(Pen,brush(Style,Color))):-
	le_brush(Style,S),!.
  le_change_prop1(le_Brush_Style,text(String,Font,FontName,TextColor,Align,Pen,brush(_,Color),Wrap,Barcode),
	listButton(S),text(String,Font,FontName,TextColor,Align,Pen,brush(Style,Color),Wrap,Barcode)):-
	le_brush(Style,S),!.
  le_change_prop1(le_Brush_Style,counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,brush(_,Color),Barcode),
	listButton(S),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,brush(Style,Color),Barcode)):-
	le_brush(Style,S),!.
  le_change_prop1(le_Brush_Color,rectangle(Pen,brush(Style,_)),
	listButton(S),rectangle(Pen,brush(Style,Color))):-
	le_color(Color,S),!.
  le_change_prop1(le_Brush_Color,ellipse(Pen,brush(Style,_)),
	listButton(S),ellipse(Pen,brush(Style,Color))):-
	le_color(Color,S),!.
  le_change_prop1(le_Brush_Color,text(String,Font,FontName,TextColor,Align,Pen,brush(Style,_),Wrap,Barcode),
	listButton(S),text(String,Font,FontName,TextColor,Align,Pen,brush(Style,Color),Wrap,Barcode)):-
	le_color(Color,S),!.
  le_change_prop1(le_Brush_Color,counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,brush(Style,_),Barcode),
	listButton(S),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,brush(Style,Color),Barcode)):-
	le_color(Color,S),!.
  le_change_prop1(le_Bitmap_FileName,bitmap(Pen,_,Stretch),
	editStr(FileName),bitmap(Pen,FileName,Stretch)):-!.
  le_change_prop1(le_Bitmap_Stretch,bitmap(Pen,FileName,_),
	listButton(S),bitmap(Pen,FileName,Stretch)):-
	le_stretch(Stretch,S),!.
  le_change_prop1(le_Text_Counter_Color,text(String,Font,FontName,_,Align,Pen,Brush,Wrap,Barcode),
	listButton(S),text(String,Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-
	le_color(TextColor,S),!.
  le_change_prop1(le_Text_Counter_Color,counter(Start,End,Step,DigitNumber,Font,FontName,_,Align,Pen,Brush,Barcode),
	listButton(S),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode)):-
	le_color(TextColor,S),!.
  le_change_prop1(le_Text_Wrap,text(String,Font,FontName,TextColor,Align,Pen,Brush,_,Barcode),
	listButton(S),text(String,Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-
	le_stretch(Wrap,S),!.
  le_change_prop1(le_Barcode,text(String,Font,FontName,TextColor,Align,Pen,Brush,Wrap,_),
	listButton(S),text(String,Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-
	le_barcod(Barcode,S),!.
  le_change_prop1(le_Barcode,counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,_),
	listButton(S),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode)):-
	le_barcod(Barcode,S),!.
  le_change_prop1(le_Counter_Start,counter(_,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode),
	editLong(l(Start)),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode)):-!.
  le_change_prop1(le_Counter_End,counter(Start,_,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode),
	editLong(l(End)),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode)):-!.
  le_change_prop1(le_Counter_Step,counter(Start,End,_,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode),
	editLong(l(Step)),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode)):-!.
  le_change_prop1(le_Counter_Digit_Number,counter(Start,End,Step,_,Font,FontName,TextColor,Align,Pen,Brush,Barcode),
	editInt(i(DigitNumber)),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode)):-!.
  le_change_prop1(le_Text_String,text(text(_),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editStr(String),text(text(String),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_ASCII_FileName,text(ascii(_,From,To),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editStr(String),text(ascii(String,From,To),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_ASCII_From,text(ascii(String,_,To),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editInt(i(From)),text(ascii(String,From,To),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_ASCII_To,text(ascii(String,From,_),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editInt(i(To)),text(ascii(String,From,To),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_ODBC_BaseName,text(odbc(_,Table,Column,User,Pass),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editStr(String),text(odbc(String,Table,Column,User,Pass),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_ODBC_TableName,text(odbc(Base,_,Column,User,Pass),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editStr(Table),text(odbc(Base,Table,Column,User,Pass),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_ODBC_Column,text(odbc(Base,Table,_,User,Pass),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editInt(i(Column)),text(odbc(Base,Table,Column,User,Pass),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_ODBC_UserName,text(odbc(Base,Table,Column,_,Pass),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editStr(User),text(odbc(Base,Table,Column,User,Pass),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_ODBC_Password,text(odbc(Base,Table,Column,User,_),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editStr(Pass),text(odbc(Base,Table,Column,User,Pass),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_DBASE_FileName,text(dbase(_,Column),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editStr(FileName),text(dbase(FileName,Column),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_DBASE_Column,text(dbase(FileName,_),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editInt(i(Column)),text(dbase(FileName,Column),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_TEXT_STYLE,text(String1,Font,FontName,TextColor,Align,Pen,Brush,Wrap,BarCode),
	listButton(S),text(String,Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-
	le_text(String1,S,String),!.
  le_change_prop1(le_DATE_Format_string,text(date(_,Shift),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editStr(FormatStr),text(date(FormatStr,Shift),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_DATE_Shift,text(date(FormatStr,_),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	editInt(i(Shift)),text(date(FormatStr,Shift),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-!.
  le_change_prop1(le_Text_alignment,text(String,Font,FontName,TextColor,_,Pen,Brush,Wrap,Barcode),
	listButton(S),text(String,Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode)):-
	le_text_align(Align,S),!.
  le_change_prop1(le_Text_alignment,counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,_,Pen,Brush,Barcode),
	listButton(S),counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode)):-
	le_text_align(Align,S),!.
  le_change_prop1(_,Type,_,Type).

ifdef use_odbc
predicates
  le_init_odbc()
clauses
  le_init_odbc():-
	odbcInit(),
	assert(le_odbc),
	dr_odbc(),!.
  le_init_odbc().

predicates
  le_close_odbc()
clauses
  le_close_odbc():-
	retract(le_odbc),
	odbcDestroy(),!.
  le_close_odbc().
enddef

  le_init_module(CallBackFunc):-
	le_assert_default(),
	assert(le_callback(CallBackFunc)),
	assert(le_stack(0)),
	assert(le_undo_stack([])),
	assert(le_redo_stack([])),
	assert(le_prop_title_width(175,350,300)),
ifdef use_odbc
	le_init_odbc(),
enddef
	class_Create("property",propwin_handler),!.
  le_close_module():-
	le_retract_default(),
	retractall(le_callback(_)),
	retractall(le_stack(_)),
	retractall(le_undo_stack(_)),
	retractall(le_redo_stack(_)),
	retractall(le_prop_title_width(_,_,_)),
ifdef use_odbc
	le_close_odbc(),
enddef
	class_Destroy("property"),!.

  le_controls_off():-
	le_property_off(),
	le_align_off(),
	le_palette_off(),!.

predicates
  le_property_on1()
clauses
  le_property_on1():-
	le_property(_),
	le_property_on(),!.
  le_property_on1().

predicates
  le_align_on1()
clauses
  le_align_on1():-
	le_align(_),
	le_align_on(),!.
  le_align_on1().

predicates
  le_palette_on1()
clauses
  le_palette_on1():-
	le_palette(_),
	le_palette_on(),!.
  le_palette_on1().

  le_controls_on():-
	le_property_on1(),
	le_align_on1(),
	le_palette_on1(),!.

  le_property_off():-
	not(le_property_stored(_)),
	le_property(PRWin),
	ParentWin1 = win_GetParent(PRWin),
	win_SetState(ParentWin1,[wsf_Disabled,wsf_Invisible]),
	assert(le_property_stored(ParentWin1)),
	le_check_callback1(PRWin,user_action(property_destroy)),!.
  le_property_off():-
	le_property_stored(_),
	assert(le_property_stored1),!.
  le_property_off().

  le_align_off():-
	not(le_align_stored(_)),
	le_align(ALWin),
	win_SetState(ALWin,[wsf_Disabled,wsf_Invisible]),
	assert(le_align_stored(ALWin)),
	le_check_callback1(ALWin,user_action(align_destroy)),!.
  le_align_off():-
	le_align_stored(_),
	assert(le_align_stored1),!.
  le_align_off().

  le_palette_off():-
	not(le_palette_stored(_)),
	le_palette(PLWin),
	win_SetState(PLWin,[wsf_Disabled,wsf_Invisible]),
	assert(le_palette_stored(PLWin)),
	le_check_callback1(PLWin,user_action(palette_destroy)),!.
  le_palette_off():-
	le_palette_stored(_),
	assert(le_palette_stored1),!.
  le_palette_off().

  le_property_on():-
	retract(le_property_stored1),!.
  le_property_on():-
	retract(le_property_stored(PRWin)),
	win_SetState(PRWin,[wsf_Enabled,wsf_Visible]),
	le_check_callback1(PRWin,user_action(property_create)),!.
  le_property_on():-
	le_property_create(),!.

  le_align_on():-
	retract(le_align_stored1),!.
  le_align_on():-
	retract(le_align_stored(ALWin)),
	win_SetState(ALWin,[wsf_Enabled,wsf_Visible]),
	le_check_callback1(ALWin,user_action(align_create)),!.
  le_align_on():-
	le_align_create(),!.

predicates
  le_palette_preview(PROPERTY_LIST)
clauses
  le_palette_on():-
	retract(le_palette_stored1),!.
  le_palette_on():-
	retract(le_palette_stored(PLWin)),
	win_SetState(PLWin,[wsf_Enabled,wsf_Visible]),
	le_check_callback1(PLWin,user_action(palette_create)),!.
  le_palette_on():-
	le_palette_create(),!.

predicates
  align_cb : ALIGN_CALLBACK
  propwin_eh : EHANDLER
  propwin_handler : EHANDLER
  palette_cb : PALETTE_CALLBACK
clauses
  le_property_destroy():-
	not(le_property(_)),!.
  le_property_destroy():-
	le_property(PRWin),
	win_SendEvent(PRWin,e_CloseRequest()),
	Win = win_GetParent(PRWin),
	win_Destroy(Win),!.
  le_property_destroy().


  le_align_destroy():-
	align_destroy(),!.

  le_palette_destroy():-
	not(le_palette(_)),!.
  le_palette_destroy():-
	le_palette(PALWin),
	win_SendEvent(PALWin,e_CloseRequest()),
	win_Destroy(PALWin),!.
  le_palette_destroy().

  le_property_create():-
	le_property(_),!.
  le_property_create():-
	le_property_stored(_),!.
  le_property_create():-
	FocWin = win_GetActiveWindow(),
	Win1 = vpi_GetAttrVal(attr_task_window),
	Win = cast(window,Win1),
	Rect = win_GetClientRect(Win),
	Rect = rct(_,T,R,_),
	le_prop_title_width(_,Width,Height),
	T1 = T + 40, L1 = R - 360, R1 = L1 + Width, B1 = T1 + Height,
	R2 = (R1 - L1) - 10, B2 = (B1 - T1) - 10,
	win_CreateDynDialog(Win,[
		dlg(wdef(wd_ModeLess,rct(L1,T1,R1,B1),label_msg4,u_Pixels),[wsf_DlgBorder,wsf_TitleBar,wsf_Close]),
		customctl(wdef(wc_custom,rct(5,5,R2,B2),"",u_Pixels),"property",777,[])
	],propwin_eh,0),
	win_SetFocus(FocWin),!.

  le_align_create():-
	le_align_stored(_),!.
  le_align_create():-
	FocWin = win_GetActiveWindow(),
	Win1 = vpi_GetAttrVal(attr_task_window),
	Win = cast(window,Win1),
	Rect = win_GetClientRect(Win),
	Rect = rct(_,T,R,_),
	L = R - 360, B = T + 380,
	ALLWin = align_create(Win,pnt(L,B),align_cb),
	le_check_callback1(ALLWin,user_action(align_create)),
	assert(le_align(ALLWin)),
	win_SetFocus(FocWin),!.

  le_palette_create():-
	le_palette(_),!.
  le_palette_create():-
	le_palette_stored(_),!.
  le_palette_create():-
	FocWin = win_GetActiveWindow(),
	Win1 = vpi_GetAttrVal(attr_task_window),
	Win = cast(window,Win1),
	Rect = win_GetClientRect(Win),
	Rect = rct(_,_,_,B),
	L = 40, B1 = B - 110,
	ColorList=[0xFFFFFF,0x000000,0x808080,0xC0C0C0,0x0000FF,0x000080,0x00FF00,
	0x008000,0xFF0000,0x800000,0xFFFF00,0x808000,0xFF00FF,0x800080,0x00FFFF,0x008080],
	PaletteWin = palette_Create(Win,pnt(L,B1),palette_cb,label_msg234,b_true,b_true,8,ColorList),
	le_check_callback1(PaletteWin,user_action(palette_create)),
	assert(le_palette(PaletteWin)),
	le_palette_preview([]),
	win_SetFocus(FocWin),!.

  palette_cb(Win,is_ToBeDestroyed):-
	retract(le_palette(_)),
	le_check_callback1(Win,user_action(palette_destroy)),!,fail.
  palette_cb(_,change_PATSTYLE(PatStyle)):-
	le_brush(PatStyle,S),
	le_change_default(le_Brush_Style,listButton(S)),
	le_focus_win(LEWin),
	win_SetFocus(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	le_change_prop(LEWin,LOWin,IdList,le_Brush_Style,listButton(S)),
	le_prop_status2(LEWin,IdList),!,
	fail.
  palette_cb(_,change_PEN(PenStyle,PenWidth)):-
	le_pen(PenStyle,S),
	le_change_default(le_Pen_Width,editInt(i(PenWidth))),
	le_change_default(le_Pen_Style,listButton(S)),
	le_focus_win(LEWin),
	win_SetFocus(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	le_change_prop(LEWin,LOWin,IdList,le_Pen_Width,editInt(i(PenWidth))),
	le_change_prop(LEWin,LOWin,IdList,le_Pen_Style,listButton(S)),
	le_prop_status2(LEWin,IdList),!,
	fail.
  palette_cb(_,change_PenColor(Color)):-
	le_color(Color,S),
	le_change_default(le_Pen_Color,listButton(S)),
	le_focus_win(LEWin),
	win_SetFocus(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	le_change_prop(LEWin,LOWin,IdList,le_Pen_Color,listButton(S)),
	le_prop_status2(LEWin,IdList),!,
	fail.
  palette_cb(_,change_BrushColor(Color)):-
	le_color(Color,S),
	le_change_default(le_Brush_Color,listButton(S)),
	le_focus_win(LEWin),
	win_SetFocus(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	le_change_prop(LEWin,LOWin,IdList,le_Brush_Color,listButton(S)),
	le_prop_status2(LEWin,IdList),!,
	fail.

predicates
  le_cursor_Set1(WINDOW,CURSOR)
clauses
  le_cursor_Set1(Win,Cursor):-
	trap(cursor_Set(Win,Cursor),_,fail),!.
  le_cursor_Set1(_,_).
predicates
  le_cursor_Set(WINDOW,RCT,PNT)
clauses
  le_cursor_Set(Win,_,_):-
	prop_cursor(Cursor,_,b_true),
	le_cursor_Set1(Win,Cursor),!.
  le_cursor_Set(Win,rct(L,T,_,_),pnt(X,Y)):-
	L1 = L + 5,
	T1 = T + 5,
	L <= X, X <= L1,
	T <= Y, Y <= T1,
	le_cursor_Set1(Win,cursor_SizeNWSE),
	retractall(prop_cursor(_,_,_)),
	assert(prop_cursor(cursor_SizeNWSE,le_lt,b_false)),!.
  le_cursor_Set(Win,rct(_,T,R,_),pnt(X,Y)):-
	R1 = R - 5,
	T1 = T + 5,
	R1 <= X, X <= R,
	T <= Y, Y <= T1,
	le_cursor_Set1(Win,cursor_SizeNESW),
	retractall(prop_cursor(_,_,_)),
	assert(prop_cursor(cursor_SizeNESW,le_rt,b_false)),!.
  le_cursor_Set(Win,rct(_,_,R,B),pnt(X,Y)):-
	R1 = R - 5,
	B1 = B - 5,
	R1 <= X, X <= R,
	B1 <= Y, Y <= B,
	le_cursor_Set1(Win,cursor_SizeNWSE),
	retractall(prop_cursor(_,_,_)),
	assert(prop_cursor(cursor_SizeNWSE,le_rb,b_false)),!.
  le_cursor_Set(Win,rct(L,_,_,B),pnt(X,Y)):-
	L1 = L + 5,
	B1 = B - 5,
	L <= X, X <= L1,
	B1 <= Y, Y <= B,
	le_cursor_Set1(Win,cursor_SizeNESW),
	retractall(prop_cursor(_,_,_)),
	assert(prop_cursor(cursor_SizeNESW,le_lb,b_false)),!.
  le_cursor_Set(Win,rct(L,_,_,_),pnt(X,_)):-
	L1 = L + 5,
	L <= X, X <= L1,
	le_cursor_Set1(Win,cursor_SizeWE),
	retractall(prop_cursor(_,_,_)),
	assert(prop_cursor(cursor_SizeWE,le_l,b_false)),!.
  le_cursor_Set(Win,rct(_,_,R,_),pnt(X,_)):-
	R1 = R - 5,
	R1 <= X, X <= R,
	le_cursor_Set1(Win,cursor_SizeWE),
	retractall(prop_cursor(_,_,_)),
	assert(prop_cursor(cursor_SizeWE,le_r,b_false)),!.
  le_cursor_Set(Win,rct(_,T,_,_),pnt(_,Y)):-
	T1 = T + 5,
	T <= Y, Y <= T1,
	le_cursor_Set1(Win,cursor_SizeNS),
	retractall(prop_cursor(_,_,_)),
	assert(prop_cursor(cursor_SizeNS,le_t,b_false)),!.
  le_cursor_Set(Win,rct(_,_,_,B),pnt(_,Y)):-
	B1 = B - 5,
	B1 <= Y, Y <= B,
	le_cursor_Set1(Win,cursor_SizeNS),
	retractall(prop_cursor(_,_,_)),
	assert(prop_cursor(cursor_SizeNS,le_b,b_false)),!.

predicates
  le_size_change(WINDOW,PNT)
clauses
  le_size_change(Win,pnt(X,Y)):-
	prop_cursor(_,le_lt,_),
	Rect = win_GetOuterRect(Win),
	Rect = rct(L,T,R,B),
	L1 = L + X,
	R1 = R - 50,
	le_min(L1,R1,L2),
	T1 = T + Y,
	B1 = B - 50,
	le_min(T1,B1,T2),
	win_Move(Win,rct(L2,T2,R,B)),!.
  le_size_change(Win,pnt(X,Y)):-
	prop_cursor(_,le_rt,_),
	Rect = win_GetOuterRect(Win),
	Rect = rct(L,T,_,B),
	T1 = T + Y,
	B1 = B - 50,
	le_min(T1,B1,T2),
	R1 = L + X,
	L1 = L + 50,
	le_max(R1,L1,R2),
	win_Move(Win,rct(L,T2,R2,B)),!.
  le_size_change(Win,pnt(X,Y)):-
	prop_cursor(_,le_lb,_),
	Rect = win_GetOuterRect(Win),
	Rect = rct(L,T,R,_),
	L1 = L + X,
	R1 = R - 50,
	le_min(L1,R1,L2),
	TitleHeight = vpi_GetAttrVal(attr_title_height),
	B1 = T + Y + TitleHeight,
	T1 = T + 50,
	le_max(B1,T1,B2),
	win_Move(Win,rct(L2,T,R,B2)),!.
  le_size_change(Win,pnt(X,Y)):-
	prop_cursor(_,le_rb,_),
	Rect = win_GetOuterRect(Win),
	Rect = rct(L,T,_,_),
	R1 = L + X,
	L1 = L + 50,
	le_max(R1,L1,R2),
	TitleHeight = vpi_GetAttrVal(attr_title_height),
	B1 = T + Y + TitleHeight,
	T1 = T + 50,
	le_max(B1,T1,B2),
	win_Move(Win,rct(L,T,R2,B2)),!.
  le_size_change(Win,pnt(X,_)):-
	prop_cursor(_,le_l,_),
	Rect = win_GetOuterRect(Win),
	Rect = rct(L,T,R,B),
	L1 = L + X,
	R1 = R - 50,
	le_min(L1,R1,L2),
	win_Move(Win,rct(L2,T,R,B)),!.
  le_size_change(Win,pnt(X,_)):-
	prop_cursor(_,le_r,_),
	Rect = win_GetOuterRect(Win),
	Rect = rct(L,T,_,B),
	R1 = L + X,
	L1 = L + 50,
	le_max(R1,L1,R2),
	win_Move(Win,rct(L,T,R2,B)),!.
  le_size_change(Win,pnt(_,Y)):-
	prop_cursor(_,le_t,_),
	Rect = win_GetOuterRect(Win),
	Rect = rct(L,T,R,B),
	T1 = T + Y,
	B1 = B - 50,
	le_min(T1,B1,T2),
	win_Move(Win,rct(L,T2,R,B)),!.
  le_size_change(Win,pnt(_,Y)):-
	prop_cursor(_,le_b,_),
	Rect = win_GetOuterRect(Win),
	Rect = rct(L,T,R,_),
	TitleHeight = vpi_GetAttrVal(attr_title_height),
	B1 = T + Y + TitleHeight,
	T1 = T + 50,
	le_max(B1,T1,B2),
	win_Move(Win,rct(L,T,R,B2)),!.

  propwin_eh(Win,e_MouseMove(Point,_,_),0):-
	Rect = win_GetClientRect(Win),
	le_cursor_Set(Win,Rect,Point),!.
  propwin_eh(Win,e_MouseMove(_,_,_),0):-
	cursor_Set(Win,cursor_Arrow),!.
  propwin_eh(Win,e_MouseDown(pnt(_,_),_,mouse_button_left),0):-
	retract(prop_cursor(Cursor,Corner,_)),
	assert(prop_cursor(Cursor,Corner,b_true)),
	le_cursor_Set1(Win,Cursor),
	win_CaptureMouse(Win),!.
  propwin_eh(Win,e_MouseUp(Point,_,_),0):-
	retract(prop_cursor(Cursor,Corner,_)),
	assert(prop_cursor(Cursor,Corner,b_false)),
	win_ReleaseMouse(),
	le_size_change(Win,Point),!.

  propwin_eh(_,e_Size(Width,Height),0):-
	R = Width - 10, B = Height - 10,
	le_property(PRWin),
	HalfWidth1 = Width div 2,
	le_min(HalfWidth1,200,HalfWidth),
	retract(le_prop_title_width(_,_,_)),
	assert(le_prop_title_width(HalfWidth,R,B)),
	win_Move(PRWin,rct(5,5,R,B)),
	le_focus_win(LEWin),
	le_prop_status(LEWin),!.

  propwin_eh(_,e_CloseRequest(),_):-
	le_property(PrWin),
	win_SendEvent(PrWin,e_CloseRequest()),fail.
  propwin_eh(_,_,_):-fail.

  propwin_handler(PRWin,e_Create(_),0):-
	assert(le_property(PRWin)),
	le_font(Font),
	le_check_callback1(PRWin,user_action(property_create)),
	le_prop_title_width(Width,_,_),
	propedit_CreateCustom(PRWin,Font,[],le_prop_cb,Width),!.

  propwin_handler(PRWin,e_Destroy,0):-
  	not(propedit_HandleEvent(PRWin,e_Destroy)),
	retract(le_property(PRWin)),!.

  propwin_handler(PRWin,EVENT,0):-
  	propedit_HandleEvent(PRWin,EVENT).

predicates
  le_convert_align(WINDOW,ALIGN_PUSH,LAYOUT_ALIGN)
clauses
  align_cb(is_ToBeDestroyed):-
	retract(le_align(_)),
	Win = cast(window,0),
	le_check_callback1(Win,user_action(align_destroy)),!,fail.
  align_cb(Action):-
	le_focus_win(LEWin),
	win_SetFocus(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	le_convert_align(LEWin,Action,Action1),
	layout_select(LOWin,IdList),
	layout_align(LOWin,IdList,Action1),!.

  le_convert_align(_,left_align,left):-!.
  le_convert_align(_,top_align,top):-!.
  le_convert_align(_,right_align,right):-!.
  le_convert_align(_,bottom_align,bottom):-!.
  le_convert_align(_,center_hor,center_hor):-!.
  le_convert_align(_,center_ver,center_ver):-!.
  le_convert_align(_,divider_hor,divider_hor):-!.
  le_convert_align(_,divider_ver,divider_ver):-!.
  le_convert_align(LEWin,equal_all,_):-
	assert(le_layout_size(LEWin,equal_all)),
ifdef idc_cursor_as
	le_layout(LEWin,_,LOWin,_,_),
	win_CaptureMouse(LOWin),
	cursor_Set(LOWin,idc_cursor_as),
enddef
	fail.
  le_convert_align(LEWin,equal_hor,_):-
	assert(le_layout_size(LEWin,equal_hor)),
ifdef idc_cursor_as
	le_layout(LEWin,_,LOWin,_,_),
	win_CaptureMouse(LOWin),
	cursor_Set(LOWin,idc_cursor_as),
enddef
	fail.
  le_convert_align(LEWin,equal_ver,_):-
	assert(le_layout_size(LEWin,equal_ver)),
ifdef idc_cursor_as
	le_layout(LEWin,_,LOWin,_,_),
	win_CaptureMouse(LOWin),
	cursor_Set(LOWin,idc_cursor_as),
enddef
	fail.

predicates
  le_prop_status1(WINDOW)
  le_append_list(PROPERTY_LIST,PROPERTY_LIST,PROPERTY_LIST,PROPERTY_LIST)
  le_get_type(LE_FIELD_TYPE,PROPERTY_LIST)
  le_get_orientation(INTEGER Id,LE_FIELD_ORIENTATION,PROPERTY)
  le_get_rect(WINDOW LOWin,RCT,PROPERTY_LIST)
clauses
  le_prop_status():-
	trap(LEWin = win_GetActiveWindow(),_,fail),
	le_info(_,LEWin,_,_,_,_,_,_,_,_,_,_,_),
	le_prop_status1(LEWin),!.
  le_prop_status().
  le_prop_status(LEWin):-
	le_info(_,LEWin,_,_,_,_,_,_,_,_,_,_,_),
	le_prop_status1(LEWin),!.
  le_prop_status(_).

  le_prop_status1(LEWin):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	le_prop_status2(LEWin,IdList),!.

predicates
  le_get_prop_title(WINDOW LEWin,ILIST IdList,STRING PropTitle)
clauses
  le_get_prop_title(LeWin,[Id|[]],label_msg5):-
	le_field_info(LEWin,Id,_,Type),
	Type = rectangle(_,_),!.
  le_get_prop_title(LeWin,[Id|[]],label_msg6):-
	le_field_info(LEWin,Id,_,Type),
	Type = ellipse(_,_),!.
  le_get_prop_title(LeWin,[Id|[]],label_msg7):-
	le_field_info(LEWin,Id,_,Type),
	Type = line(_),!.
  le_get_prop_title(LeWin,[Id|[]],label_msg8):-
	le_field_info(LEWin,Id,_,Type),
	Type = bitmap(_,_,_),!.
  le_get_prop_title(LeWin,[Id|[]],label_msg9):-
	le_field_info(LEWin,Id,_,Type),
	Type = counter(_,_,_,_,_,_,_,_,_,_,_),!.
  le_get_prop_title(LeWin,[Id|[]],label_msg10):-
	le_field_info(LEWin,Id,_,Type),
	Type = text(Text,_,_,_,_,_,_,_,_),
	Text = text(_),!.
  le_get_prop_title(LeWin,[Id|[]],label_msg243):-
	le_field_info(LEWin,Id,_,Type),
	Type = text(Text,_,_,_,_,_,_,_,_),
	Text = dyntext(_),!.
  le_get_prop_title(LeWin,[Id|[]],label_msg11):-
	le_field_info(LEWin,Id,_,Type),
	Type = text(Text,_,_,_,_,_,_,_,_),
	Text = ascii(_,_,_),!.
  le_get_prop_title(LeWin,[Id|[]],label_msg12):-
	le_field_info(LEWin,Id,_,Type),
	Type = text(Text,_,_,_,_,_,_,_,_),
	Text = odbc(_,_,_,_,_),!.
  le_get_prop_title(LeWin,[Id|[]],label_msg13):-
	le_field_info(LEWin,Id,_,Type),
	Type = text(Text,_,_,_,_,_,_,_,_),
	Text = dbase(_,_),!.
  le_get_prop_title(LeWin,[Id|[]],label_msg168):-
	le_field_info(LEWin,Id,_,Type),
	Type = text(Text,_,_,_,_,_,_,_,_),
	Text = date(_,_),!.
  le_get_prop_title(_,_,label_msg14):-!.

predicates
  le_get_property(WINDOW,ILIST,PROPERTY_LIST2D)
  le_get_color(INTEGER Id,STRING,COLOR,PROPERTY)
  le_get_snap(INTEGER Id,STRING,BOOLEAN,PROPERTY)
  le_check_property_list(PROPERTY_LIST2D,PROPERTY_LIST)
  le_property_preview(STRING PropTitle,PROPERTY_LIST)
  le_vert_hor_str(UNSIGNED,STRING)
  le_page_roll_str(BOOLEAN,STRING)
  le_landscape_str(BOOLEAN,STRING)
clauses
  le_landscape_str(b_true,label_msg131):-!.
  le_landscape_str(_,label_msg130):-!.

  le_page_roll_str(b_true,label_msg112):-!.
  le_page_roll_str(_,label_msg113):-!.

  le_vert_hor_str(0,"~~~"):-!.
  le_vert_hor_str(ValDig,ValStr):-
	str_int(ValStr,ValDig),!.

  le_prop_status2(LEWin,[]):-
	le_info(_,LEWin,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,_,_,_,_),
	le_page_roll_str(Page_Roll,Page_RollStr),
	format(PageStr,"%s (%s)",PageName,Page_RollStr),
	PageSet = property(le_PAGE_NAME,label_msg118,editStr(PageStr,[ronly]),nopr,b_true),
	format(SizeStr,"% X %",LabelWidth,LabelHeight),
	SizeSet = property(le_PAGE_SIZE,label_msg235,editStr(SizeStr,[ronly]),nopr,b_true),
	le_vert_hor_str(NoHor,NoHorStr),
	le_vert_hor_str(NoVert,NoVertStr),
	format(NumStr,"%s X %s",NoHorStr,NoVertStr),
	NumSet = property(le_PAGE_NUMB,label_msg236,editStr(NumStr,[ronly]),nopr,b_true),
	le_landscape_str(Landscape,LandscapeStr),
	LandscapeSet = property(le_PAGE_ORIENT,label_msg237,editStr(LandscapeStr,[ronly]),nopr,b_true),
	le_label_style(LEWin,_,FontName),
	FontList = property(le_PAGE_FONT,label_msg69,editStr(FontName,[ronly]),nopr,b_true),
	le_grid_set(LEWin,GridHorStep,GridVerStep,Visible,Color,SnapToGrid),
	HorStep = property(le_Grid_HorStep,label_msg15,editInt(i(GridHorStep),[range(1,500)]),nopr,b_false),
	VerStep = property(le_Grid_VerStep,label_msg16,editInt(i(GridVerStep),[range(1,500)]),nopr,b_false),
	le_correct_visible(Visible,color_Black,Visible1),
	le_visible(Visible1,Num1),
	Vis = property(le_Grid_Visible,label_msg17,listButton([label_msg18,label_msg19,label_msg20],Num1),nopr,b_false),
	le_get_color(le_Grid_Color,label_msg21,Color,Col),
	le_get_snap(le_Grid_Snap,label_msg22,SnapToGrid,Snap),
	le_palette_preview([]),
	PropertyList = [PageSet,SizeSet,NumSet,LandscapeSet,FontList,HorStep,VerStep,Vis,Col,Snap],
	le_property_preview(label_msg23,PropertyList),!.
  le_prop_status2(LEWin,IdList):-
	le_get_property(LEWin,IdList,PropertyList2D),
	le_check_property_list(PropertyList2D,PropertyList),
	le_get_prop_title(LEWin,IdList,PropTitle),
	le_palette_preview(PropertyList),
	le_property_preview(PropTitle,PropertyList),!.
  le_prop_status2(_,_).

  le_property_preview(PropTitle,PropertyList):-
	le_property(PRWin),
	DlgWin = win_GetParent(PRWin),
	win_SetText(DlgWin,PropTitle),
	le_prop_title_width(Width,_,_),
	propedit_ReloadCustom(PRWin,
		[pTbl(0,"",PropertyList)],Width),!.
  le_property_preview(_,_).

predicates
  le_palette_preview1(PROPERTY_LIST,PEN,BRUSH,PEN,BRUSH)
clauses
  le_palette_preview([]):-
	le_palette(PaletteWin),
	le_layout_style(Pen,Brush,_,_,_),
	palette_SetPreviewPen(PaletteWin,Pen),
	palette_SetPreviewBrush(PaletteWin,Brush),!.
  le_palette_preview(List):-
	le_palette(PaletteWin),
	le_palette_preview1(List,pen(1,ps_Hollow,color_white),brush(pat_Hollow,color_White),
		Pen,Brush),
	palette_SetPreviewPen(PaletteWin,Pen),
	palette_SetPreviewBrush(PaletteWin,Brush),!.
  le_palette_preview(_).

  le_palette_preview1([],Pen,Brush,Pen,Brush):-!.
  le_palette_preview1([property(le_Pen_Width,_,editInt(i(Width),_),_,_)|Rest],
	pen(_,Style,Color),Brush1,Pen,Brush):-!,
	le_palette_preview1(Rest,pen(Width,Style,Color),Brush1,Pen,Brush).
  le_palette_preview1([property(le_Pen_Style,_,listButton(_,Num),_,_)|Rest],
	pen(Width,_,Color),Brush1,Pen,Brush):-
	le_pen(Style,Num),!,
	le_palette_preview1(Rest,pen(Width,Style,Color),Brush1,Pen,Brush).
  le_palette_preview1([property(le_Pen_Color,_,listButton(_,Num),_,_)|Rest],
	pen(Width,Style,_),Brush1,Pen,Brush):-
	le_color(Color,Num),!,
	le_palette_preview1(Rest,pen(Width,Style,Color),Brush1,Pen,Brush).
  le_palette_preview1([property(le_Brush_Style,_,listButton(_,Num),_,_)|Rest],
	Pen1,brush(_,Color),Pen,Brush):-
	le_brush(Style,Num),!,
	le_palette_preview1(Rest,Pen1,brush(Style,Color),Pen,Brush).
  le_palette_preview1([property(le_Brush_Color,_,listButton(_,Num),_,_)|Rest],
	Pen1,brush(Style,_),Pen,Brush):-
	le_color(Color,Num),!,
	le_palette_preview1(Rest,Pen1,brush(Style,Color),Pen,Brush).
  le_palette_preview1([_|Rest],Pen1,Brush1,Pen,Brush):-!,
	le_palette_preview1(Rest,Pen1,Brush1,Pen,Brush).

predicates
  le_check_property_list1(PROPERTY_LIST,PROPERTY_LIST2D,PROPERTY_LIST,PROPERTY_LIST)
clauses
  le_check_property_list([PropertyList|[]],PropertyList):-!.
  le_check_property_list([PL|Rest],PropertyList):-
	le_check_property_list1(PL,Rest,[],PropertyList),!.

predicates
  le_check_property_list2(PROPERTY,PROPERTY_LIST2D,PROPERTY)
clauses
  le_check_property_list1([],_,OutPL,OutPL1):-
	le_reverse(OutPL,[],OutPL1),!.
  le_check_property_list1([P|Rest],PL2d,PL,OutPL):-
	le_check_property_list2(P,PL2d,P1),!,
	le_check_property_list1(Rest,PL2d,[P1|PL],OutPL).
  le_check_property_list1([_|Rest],PL2d,PL,OutPL):-!,
	le_check_property_list1(Rest,PL2d,PL,OutPL).

predicates
  le_check_property_list3(PROPERTY,PROPERTY_LIST,PROPERTY)
clauses
  le_check_property_list2(OutP,[],OutP):-!.
  le_check_property_list2(P,[PL|Rest],OutP):-!,
	le_check_property_list3(P,PL,P1),
	le_check_property_list2(P1,Rest,OutP).

  le_check_property_list3(_,[],_):-!,fail.
  le_check_property_list3(property(Id,Name,Control,Error,Button),
	[property(Id,Name,Control,Error,Button)|_],property(Id,Name,Control,Error,Button)):-!.
  le_check_property_list3(property(le_Orientation_id,Name,_,Error,Button),
	[property(le_Orientation_id,_,_,_,_)|_],property(le_Orientation_id,Name,
	listButton(["0°","90°","180°","270°",""],4),Error,Button)):-!.
  le_check_property_list3(property(le_Pen_Width,Name,_,Error,Button),
	[property(le_Pen_Width,_,_,_,_)|_],property(le_Pen_Width,Name,
	editInt(void,[range(1,500)]),Error,Button)):-!.
  le_check_property_list3(property(le_Pen_Style,Name,_,Error,Button),
	[property(le_Pen_Style,_,_,_,_)|_],property(le_Pen_Style,Name,
	listButton([label_msg24,label_msg25,label_msg26,label_msg27,label_msg28,label_msg29,""],6),Error,Button)):-!.
  le_check_property_list3(property(le_Pen_Color,Name,_,Error,Button),
	[property(le_Pen_Color,_,_,_,_)|_],property(le_Pen_Color,Name,
	listButton([label_msg30,label_msg31,label_msg32,label_msg33,label_msg34,label_msg35,label_msg36,label_msg37,
  	label_msg38,label_msg39,label_msg40,label_msg41,label_msg42,label_msg43,label_msg44,label_msg45,""],16),Error,Button)):-!.
  le_check_property_list3(property(le_Brush_Style,Name,_,Error,Button),
	[property(le_Brush_Style,_,_,_,_)|_],property(le_Brush_Style,Name,
	listButton(
	[label_msg29,label_msg24,label_msg46,label_msg47,label_msg48,label_msg49,label_msg50,label_msg51,""],8),Error,Button)):-!.
  le_check_property_list3(property(le_Brush_Color,Name,_,Error,Button),
	[property(le_Brush_Color,_,_,_,_)|_],property(le_Brush_Color,Name,
	listButton([label_msg30,label_msg31,label_msg32,label_msg33,label_msg34,label_msg35,label_msg36,label_msg37,
  	label_msg38,label_msg39,label_msg40,label_msg41,label_msg42,label_msg43,label_msg44,label_msg45,""],16),Error,Button)):-!.
  le_check_property_list3(property(le_Bitmap_FileName,Name,_,Error,Button),
	[property(le_Bitmap_FileName,_,_,_,_)|_],property(le_Bitmap_FileName,Name,
	editStr("",[]),Error,Button)):-!.
  le_check_property_list3(property(le_Bitmap_Stretch,Name,_,Error,Button),
	[property(le_Bitmap_Stretch,_,_,_,_)|_],property(le_Bitmap_Stretch,Name,
	listButton([label_msg52,label_msg53,""],2),Error,Button)):-!.
  le_check_property_list3(property(le_Font_Name,Name,_,Error,Button),
	[property(le_Font_Name,_,_,_,_)|_],property(le_Font_Name,Name,
	editStr("",[]),Error,Button)):-!.
  le_check_property_list3(property(le_Text_Counter_Color,Name,_,Error,Button),
	[property(le_Text_Counter_Color,_,_,_,_)|_],property(le_Text_Counter_Color,Name,
	listButton([label_msg30,label_msg31,label_msg32,label_msg33,label_msg34,label_msg35,label_msg36,label_msg37,
  	label_msg38,label_msg39,label_msg40,label_msg41,label_msg42,label_msg43,label_msg44,label_msg45,""],16),Error,Button)):-!.
  le_check_property_list3(property(le_Text_Wrap,Name,_,Error,Button),
	[property(le_Text_Wrap,_,_,_,_)|_],property(le_Text_Wrap,Name,
	listButton([label_msg54,label_msg55,""],2),Error,Button)):-!.
  le_check_property_list3(property(le_Barcode,Name,_,Error,Button),
	[property(le_Barcode,_,_,_,_)|_],property(le_Barcode,Name,
	listButton([label_msg186,"UPC - A","EAN - 13","EAN - 8","2/5","39",""],6),Error,Button)):-!.
  le_check_property_list3(property(le_Counter_Start,Name,_,Error,Button),
	[property(le_Counter_Start,_,_,_,_)|_],property(le_Counter_Start,Name,
	editLong(void,[]),Error,Button)):-!.
  le_check_property_list3(property(le_Counter_End,Name,_,Error,Button),
	[property(le_Counter_End,_,_,_,_)|_],property(le_Counter_End,Name,
	editLong(void,[]),Error,Button)):-!.
  le_check_property_list3(property(le_Counter_Step,Name,_,Error,Button),
	[property(le_Counter_Step,_,_,_,_)|_],property(le_Counter_Step,Name,
	editLong(void,[]),Error,Button)):-!.
  le_check_property_list3(property(le_Counter_Digit_Number,Name,_,Error,Button),
	[property(le_Counter_Digit_Number,_,_,_,_)|_],property(le_Counter_Digit_Number,Name,
	editInt(void,[range(1,9)]),Error,Button)):-!.
  le_check_property_list3(property(le_Text_String,Name,_,Error,Button),
	[property(le_Text_String,_,_,_,_)|_],property(le_Text_String,Name,
	editStr("",[]),Error,Button)):-!.
  le_check_property_list3(property(le_ASCII_FileName,Name,_,Error,Button),
	[property(le_ASCII_FileName,_,_,_,_)|_],property(le_ASCII_FileName,Name,
	editStr("",[]),Error,Button)):-!.
  le_check_property_list3(property(le_ASCII_From,Name,_,Error,Button),
	[property(le_ASCII_From,_,_,_,_)|_],property(le_ASCII_From,Name,
	editInt(void,[range(1,1000)]),Error,Button)):-!.
  le_check_property_list3(property(le_ASCII_To,Name,_,Error,Button),
	[property(le_ASCII_To,_,_,_,_)|_],property(le_ASCII_To,Name,
	editInt(void,[range(1,1000)]),Error,Button)):-!.
  le_check_property_list3(property(le_ODBC_BaseName,Name,_,Error,Button),
	[property(le_ODBC_BaseName,_,_,_,_)|_],property(le_ODBC_BaseName,Name,
	editStr("",[]),Error,Button)):-!.
  le_check_property_list3(property(le_ODBC_TableName,Name,_,Error,Button),
	[property(le_ODBC_TableName,_,_,_,_)|_],property(le_ODBC_TableName,Name,
	editStr("",[]),Error,Button)):-!.
  le_check_property_list3(property(le_ODBC_Column,Name,_,Error,Button),
	[property(le_ODBC_Column,_,_,_,_)|_],property(le_ODBC_Column,Name,
	editInt(void,[range(1,1000)]),Error,Button)):-!.
  le_check_property_list3(property(le_ODBC_UserName,Name,_,Error,Button),
	[property(le_ODBC_UserName,_,_,_,_)|_],property(le_ODBC_UserName,Name,
	editStr("",[]),Error,Button)):-!.
  le_check_property_list3(property(le_ODBC_Password,Name,_,Error,Button),
	[property(le_ODBC_Password,_,_,_,_)|_],property(le_ODBC_Password,Name,
	editStr("",[]),Error,Button)):-!.
  le_check_property_list3(property(le_DBASE_FileName,Name,_,Error,Button),
	[property(le_DBASE_FileName,_,_,_,_)|_],property(le_DBASE_FileName,Name,
	editStr("",[]),Error,Button)):-!.
  le_check_property_list3(property(le_DBASE_Column,Name,_,Error,Button),
	[property(le_DBASE_Column,_,_,_,_)|_],property(le_DBASE_Column,Name,
	editInt(void,[range(1,1000)]),Error,Button)):-!.
  le_check_property_list3(property(le_TEXT_STYLE,Name,_,Error,Button),
	[property(le_TEXT_STYLE,_,_,_,_)|_],property(le_TEXT_STYLE,Name,
	listButton([label_msg56,label_msg244,label_msg173,label_msg57,label_msg58,label_msg59,""],6),Error,Button)):-!.
  le_check_property_list3(property(le_DATE_Format_string,Name,_,Error,Button),
	[property(le_DATE_Format_string,_,_,_,_)|_],property(le_DATE_Format_string,Name,
	editStr("",[]),Error,Button)):-!.
  le_check_property_list3(property(le_DATE_Shift,Name,_,Error,Button),
	[property(le_DATE_Shift,_,_,_,_)|_],property(le_DATE_Shift,Name,
	editInt(void,[]),Error,Button)):-!.
  le_check_property_list3(property(le_Text_alignment,Name,_,Error,Button),
	[property(le_Text_alignment,_,_,_,_)|_],property(le_Text_alignment,Name,
	listButton([label_msg60,label_msg230,label_msg231,""],3),Error,Button)):-!.

  le_check_property_list3(P,[_|Rest],OutP):-!,
	le_check_property_list3(P,Rest,OutP).

  le_reverse([],IdList,IdList):-!.
  le_reverse([Id|Rest],IL,IdList):-!,
     le_reverse(Rest,[Id|IL],IdList).

  le_append_list([],[],List3,List4):-
	le_reverse(List3,[],List4),!.
  le_append_list([],[A|Rest],List3,List4):-!,
	le_append_list([],Rest,[A|List3],List4).
  le_append_list([A|Rest],List2,List3,List4):-!,
	le_append_list(Rest,List2,[A|List3],List4).

predicates
  le_get_pen(PEN,PROPERTY_LIST)
  le_get_property1(WINDOW,ILIST,RCT,PROPERTY_LIST2D,PROPERTY_LIST2D)
clauses
  le_get_property(LEWin,IdList,PropertyList2D):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_rectangle(LOWin,IdList,Rect),
	le_get_property1(LEWin,IdList,Rect,[],PropertyList2D),!.

  le_get_property1(_,[],_,PropertyList2D,PropertyList2D):-!.
  le_get_property1(LEWin,[Id|Rest],Rect,PL,PropertyList2D):-
	le_field_info(LEWin,Id,Orientation,Type),
	le_get_type(Type,TypeList),
	le_get_orientation(le_Orientation_id,Orientation,OrientationList),
	le_get_rect(LEWin,Rect,RectList),
	le_append_list(TypeList,[OrientationList],[],PropList),
	le_append_list(PropList,RectList,[],PropertyList),!,
	le_get_property1(LEWin,Rest,Rect,[PropertyList|PL],PropertyList2D).

  le_get_rect(LEWin,rct(L,T,R,B),[LeftList,TopList,WidthList,HeightList]):-
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	L1=L/PixInMM,T1=T/PixInMM,R1=R/PixInMM,B1=B/PixInMM,
	Width = (R1 - L1), Height = (B1 - T1),
	LeftList = property(le_Rect_Left,label_msg60,editReal(r(L1),[range(1,1000)]),nopr,b_false),
	TopList = property(le_Rect_Top,label_msg61,editReal(r(T1),[range(1,1000)]),nopr,b_false),
	WidthList = property(le_Rect_Width,label_msg62,editReal(r(Width),[range(1,1000)]),nopr,b_false),
	HeightList = property(le_Rect_Heght,label_msg63,editReal(r(Height),[range(1,1000)]),nopr,b_false),!.

predicates
  le_get_brush(BRUSH,PROPERTY_LIST)
  le_get_stretch(INTEGER Id,STRING,BOOLEAN,PROPERTY)
  le_get_barcode(INTEGER Id,STRING,BARCODE_TYPE,PROPERTY)
  le_get_wrap(INTEGER Id,STRING,BOOLEAN,PROPERTY)
  le_get_text(INTEGER Id,STRING,LE_FIELD_TEXT,PROPERTY)
  le_get_text_align(INTEGER Id,STRING,LE_TEXT_ALIGN,PROPERTY)
clauses
  le_get_type(rectangle(Pen,Brush),PropList):-
	le_get_pen(Pen,PenList),
	le_get_brush(Brush,BrushList),
	le_append_list(BrushList,PenList,[],PropList),!.
  le_get_type(ellipse(Pen,Brush),PropList):-
	le_get_pen(Pen,PenList),
	le_get_brush(Brush,BrushList),
	le_append_list(BrushList,PenList,[],PropList),!.
  le_get_type(line(Pen),PropList):-
	le_get_pen(Pen,PropList),!.
  le_get_type(bitmap(Pen,FileName,Stretch),PropList):-
	FileList = property(le_Bitmap_FileName,label_msg64,editStr(FileName,[]),nopr,b_true),
	le_get_stretch(le_Bitmap_Stretch,label_msg65,Stretch,StretchList),
	le_get_pen(Pen,PenList),
	le_append_list([FileList,StretchList],PenList,[],PropList),!.
  le_get_type(text(text(String),_,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),PropList):-
	le_get_text(le_TEXT_STYLE,label_msg66,text(String),TypeList),
	StrList = property(le_Text_String,label_msg67,editStr(String,[]),nopr,b_false),
	le_get_text_align(le_Text_alignment,label_msg232,Align,AlignList),
	le_get_color(le_Text_Counter_Color,label_msg68,TextColor,ColorList),
	FontList = property(le_Font_Name,label_msg69,editStr(FontName,[ronly]),nopr,b_true),
	le_get_pen(Pen,PenList),
	le_get_brush(Brush,BrushList),
	le_get_wrap(le_Text_Wrap,label_msg70,Wrap,WrapList),
	le_get_barcode(le_Barcode,label_msg71,Barcode,BarcodeList),
	le_append_list([TypeList,StrList,AlignList,WrapList,ColorList,FontList,BarcodeList],BrushList,[],PropList1),
	le_append_list(PropList1,PenList,[],PropList),!.
  le_get_type(text(dyntext([String|Rest]),_,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),PropList):-
	le_get_text(le_TEXT_STYLE,label_msg66,dyntext([String|Rest]),TypeList),
	StrList = property(le_Text_String,label_msg67,editStr(String,[ronly]),nopr,b_true),
	le_get_text_align(le_Text_alignment,label_msg232,Align,AlignList),
	le_get_color(le_Text_Counter_Color,label_msg68,TextColor,ColorList),
	FontList = property(le_Font_Name,label_msg69,editStr(FontName,[ronly]),nopr,b_true),
	le_get_pen(Pen,PenList),
	le_get_brush(Brush,BrushList),
	le_get_wrap(le_Text_Wrap,label_msg70,Wrap,WrapList),
	le_get_barcode(le_Barcode,label_msg71,Barcode,BarcodeList),
	le_append_list([TypeList,StrList,AlignList,WrapList,ColorList,FontList,BarcodeList],BrushList,[],PropList1),
	le_append_list(PropList1,PenList,[],PropList),!.
  le_get_type(text(ascii(FileName,From,To),_,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),PropList):-
	le_get_text(le_TEXT_STYLE,label_msg72,ascii(FileName,From,To),TypeList),
	FileList = property(le_ASCII_FileName,label_msg64,editStr(FileName,[]),nopr,b_true),
	FromList = property(le_ASCII_From,label_msg73,editInt(i(From),[range(1,1000)]),nopr,b_false),
	ToList = property(le_ASCII_To,label_msg74,editInt(i(To),[range(1,1000)]),nopr,b_false),
	le_get_text_align(le_Text_alignment,label_msg232,Align,AlignList),
	le_get_color(le_Text_Counter_Color,label_msg68,TextColor,ColorList),
	FontList = property(le_Font_Name,label_msg69,editStr(FontName,[ronly]),nopr,b_true),
	le_get_pen(Pen,PenList),
	le_get_brush(Brush,BrushList),
	le_get_wrap(le_Text_Wrap,label_msg70,Wrap,WrapList),
	le_get_barcode(le_Barcode,label_msg71,Barcode,BarcodeList),
	le_append_list([TypeList,FileList,FromList,ToList,AlignList,WrapList,ColorList,FontList,BarcodeList],BrushList,[],PropList1),
	le_append_list(PropList1,PenList,[],PropList),!.
  le_get_type(text(odbc(BaseName,TableName,Column,UserName,Password),_,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),PropList):-
	le_get_text(le_TEXT_STYLE,label_msg66,odbc(BaseName,TableName,Column,UserName,Password),TypeList),
	BaseList = property(le_ODBC_BaseName,label_msg75,editStr(BaseName,[]),nopr,b_true),
	TableList = property(le_ODBC_TableName,label_msg76,editStr(TableName,[]),nopr,b_false),
	ColumnList = property(le_ODBC_Column,label_msg77,editInt(i(Column),[range(1,1000)]),nopr,b_false),
	UserList = property(le_ODBC_UserName,label_msg78,editStr(UserName,[]),nopr,b_false),
	PasswordList = property(le_ODBC_Password,label_msg79,editStr(Password,[]),nopr,b_false),
	le_get_text_align(le_Text_alignment,label_msg232,Align,AlignList),
	le_get_color(le_Text_Counter_Color,label_msg68,TextColor,ColorList),
	FontList = property(le_Font_Name,label_msg69,editStr(FontName,[ronly]),nopr,b_true),
	le_get_pen(Pen,PenList),
	le_get_brush(Brush,BrushList),
	le_get_wrap(le_Text_Wrap,label_msg70,Wrap,WrapList),
	le_get_barcode(le_Barcode,label_msg71,Barcode,BarcodeList),
	le_append_list([TypeList,BaseList,TableList,ColumnList,UserList,PasswordList,AlignList,WrapList,
		ColorList,FontList,BarcodeList],BrushList,[],PropList1),
	le_append_list(PropList1,PenList,[],PropList),!.
  le_get_type(text(dbase(FileName,Column),_,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),PropList):-
	le_get_text(le_TEXT_STYLE,label_msg66,dbase(FileName,Column),TypeList),
	FileList = property(le_DBASE_FileName,label_msg64,editStr(FileName,[]),nopr,b_true),
	ColumnList = property(le_DBASE_Column,label_msg77,editInt(i(Column),[range(1,1000)]),nopr,b_false),
	le_get_text_align(le_Text_alignment,label_msg232,Align,AlignList),
	le_get_color(le_Text_Counter_Color,label_msg68,TextColor,ColorList),
	FontList = property(le_Font_Name,label_msg69,editStr(FontName,[ronly]),nopr,b_true),
	le_get_pen(Pen,PenList),
	le_get_brush(Brush,BrushList),
	le_get_wrap(le_Text_Wrap,label_msg70,Wrap,WrapList),
	le_get_barcode(le_Barcode,label_msg71,Barcode,BarcodeList),
	le_append_list([TypeList,FileList,ColumnList,AlignList,WrapList,ColorList,FontList,BarcodeList],BrushList,[],PropList1),
	le_append_list(PropList1,PenList,[],PropList),!.
  le_get_type(text(date(FormatStr,Shift),_,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),PropList):-
	le_get_text(le_TEXT_STYLE,label_msg66,date(FormatStr,Shift),TypeList),
	FormatList = property(le_DATE_Format_string,label_msg169,editStr(FormatStr,[]),nopr,b_true),
	ShiftList = property(le_DATE_Shift,label_msg170,editInt(i(Shift),[]),nopr,b_false),
	le_get_text_align(le_Text_alignment,label_msg232,Align,AlignList),
	le_get_color(le_Text_Counter_Color,label_msg68,TextColor,ColorList),
	FontList = property(le_Font_Name,label_msg69,editStr(FontName,[ronly]),nopr,b_true),
	le_get_pen(Pen,PenList),
	le_get_brush(Brush,BrushList),
	le_get_wrap(le_Text_Wrap,label_msg70,Wrap,WrapList),
	le_get_barcode(le_Barcode,label_msg71,Barcode,BarcodeList),
	le_append_list([TypeList,FormatList,ShiftList,AlignList,WrapList,ColorList,FontList,BarcodeList],BrushList,[],PropList1),
	le_append_list(PropList1,PenList,[],PropList),!.
  le_get_type(counter(Start,End,Step,DigitNumber,_,FontName,TextColor,Align,Pen,Brush,Barcode),PropList):-
	StartList = property(le_Counter_Start,label_msg80,editLong(l(Start),[]),nopr,b_false),
	EndList = property(le_Counter_End,label_msg81,editLong(l(End),[]),nopr,b_false),
	StepList = property(le_Counter_Step,label_msg82,editLong(l(Step),[]),nopr,b_false),
	DigitNumberList = property(le_Counter_Digit_Number,label_msg83,editInt(i(DigitNumber),[range(1,9)]),nopr,b_false),
	le_get_text_align(le_Text_alignment,label_msg232,Align,AlignList),
	le_get_color(le_Text_Counter_Color,label_msg68,TextColor,ColorList),
	FontList = property(le_Font_Name,label_msg69,editStr(FontName,[ronly]),nopr,b_true),
	le_get_pen(Pen,PenList),
	le_get_brush(Brush,BrushList),
	le_get_barcode(le_Barcode,label_msg71,Barcode,BarcodeList),
	le_append_list([StartList,EndList,StepList,DigitNumberList,AlignList,ColorList,FontList,BarcodeList],BrushList,[],PropList1),
	le_append_list(PropList1,PenList,[],PropList),!.

predicates
  le_get_pen_style(INTEGER Id,STRING,PENSTYLE,PROPERTY)
clauses
  le_get_pen(pen(Width,Style,Color),PenList):-
	WidthList = property(le_Pen_Width,label_msg84,editInt(i(Width),[range(1,1000)]),nopr,b_false),
	le_get_pen_style(le_Pen_Style,label_msg85,Style,StyleList),
	le_get_color(le_Pen_Color,label_msg86,Color,ColorList),
	le_append_list([WidthList,StyleList],[ColorList],[],PenList),!.

predicates
  le_get_brush_style(INTEGER Id,STRING,PATSTYLE,PROPERTY)
clauses
  le_get_brush(brush(Style,Color),BrushList):-
	le_get_brush_style(le_Brush_Style,label_msg90,Style,StyleList),
	le_get_color(le_Brush_Color,label_msg91,Color,ColorList),
	le_append_list([StyleList],[ColorList],[],BrushList),!.

  le_get_pen_style(Id,Str,Pen,property(Id,Str,listButton(
  	[label_msg24,label_msg25,label_msg26,label_msg27,label_msg28,label_msg29],Num),nopr,b_false)):-
	le_pen(Pen,Num),!.

  le_get_brush_style(Id,Str,Brush,property(Id,Str,listButton(
	[label_msg29,label_msg24,label_msg46,label_msg47,label_msg48,label_msg49,label_msg50,label_msg51],Num),nopr,b_false)):-
	le_brush(Brush,Num),!.

  le_get_stretch(Id,Str,Stretch,property(Id,Str,listButton(
	[label_msg52,label_msg53],Num),nopr,b_false)):-
	le_stretch(Stretch,Num),!.

  le_get_wrap(Id,Str,Stretch,property(Id,Str,listButton(
	[label_msg54,label_msg55],Num),nopr,b_false)):-
	le_stretch(Stretch,Num),!.

  le_get_snap(Id,Str,Stretch,property(Id,Str,listButton(
	[label_msg92,label_msg93],Num),nopr,b_false)):-
	le_stretch(Stretch,Num),!.

  le_get_barcode(Id,Str,Barcode,property(Id,Str,listButton(
	[label_msg186,"UPC - A","EAN - 13","EAN - 8","2/5","39"],Num),nopr,b_false)):-
	le_barcod(Barcode,Num),!.

  le_get_color(Id,Str,Color,property(Id,Str,listButton(
  	[label_msg30,label_msg31,label_msg32,label_msg33,label_msg34,label_msg35,label_msg36,label_msg37,
  	label_msg38,label_msg39,label_msg40,label_msg41,label_msg42,label_msg43,label_msg44,label_msg45],Num),nopr,b_false)):-
	le_color(Color,Num),!.

  le_get_text(Id,Str,Dtext,property(Id,Str,listButton(
  	[label_msg56,label_msg244,label_msg173,label_msg57,label_msg58,label_msg59],Num),nopr,b_false)):-
	le_text(Dtext,Num),!.

  le_get_text_align(Id,Str,Align,property(Id,Str,listButton(
  	[label_msg60,label_msg230,label_msg231],Num),nopr,b_false)):-
	le_text_align(Align,Num),!.

  le_get_orientation(Id,Orientation,property(Id,label_msg94,listButton(
  	["0°","90°","180°","270°"],Num),nopr,b_false)):-
	le_orientation(Orientation,Num),!.

predicates
  le_dlg_fs_eh	: EHANDLER
clauses
  le_get_format_string(PWIN,FormatString):-
	retractall(le_base_answer(_)),
	win_CreateDynDialog(PWIN,[
	dlg(wdef(wd_Modal,rct(10,10,300,300),label_msg233,u_Pixels),[wsf_Close,wsf_DlgBorder,wsf_TitleBar]),
	ctl(wdef(wc_LBox,rct(5,5,285,260),"",u_Pixels),1,[wsf_VScroll]),
	ctl(wdef(wc_PushButton,rct(25,260,125,285),label_msg180,u_Pixels),idc_ok,[]),
	ctl(wdef(wc_PushButton,rct(165,260,265,285),label_msg181,u_Pixels),idc_cancel,[])
	],le_dlg_fs_eh,0),
	retract(le_base_answer(FormatString)),!.

predicates
  le_convert_date(SLIST FormatStringList,MINUT_OFFSET,SLIST Empty,SLIST ResultStringList_Reverse)
clauses
  le_convert_date([],_,RList,RList):-!.
  le_convert_date([FS|Rest],Mins,Empty,RList):-
	dt_minoffset_to_str(Mins,FS,RS),!,
	le_convert_date(Rest,Mins,[RS|Empty],RList).

  le_dlg_fs_eh(Win,e_Create(_),0):-
	Window = win_GetCtlHandle(Win,1),
	date(Year,Month,Day),
	time(Hours,Minutes,_,_),
	dt_min_to_offset(Year,Month,Day,Hours,Minutes,MinutOffset),
	le_convert_date(["%DD-%MD-%YL (Week-%Wd %DN) %HH:%MM","%DD-%MD-%YL (Week-%WD %DN) %HH:%MM",
	"%Dd-%Md-%YS %Hh:%Mm","%Dd-%Md-%YL %Hh:%Mm","%DD-%MN-%YS %HH:%MM","%DD-%MD-%YS %HH:%MM",
	"%DD-%MN-%YL %HH:%MM","%DD-%MD-%YL %HH:%MM","%DD-%MD-%YL (Week-%Wd %DN)",
	"%DD-%MD-%YL (Week-%WD %DN)","%Dd-%Md-%YS","%Dd-%Md-%YL","%DD-%MN-%YS","%DD-%MD-%YS",
	"%DD-%MN-%YL","%DD-%MD-%YL"],
	MinutOffset,[],ExamStringList),
	lbox_Add(Window,ExamStringList),!.
  le_dlg_fs_eh(Win,e_Control(idc_ok,_,_,activated()),0):-
	Window = win_GetCtlHandle(Win,1),
	SelIndex1 = lbox_GetSelIndex(Window),
	SelIndex = SelIndex1 + 1,
	le_member_index(FormatString,["%DD-%MD-%YL","%DD-%MN-%YL","%DD-%MD-%YS","%DD-%MN-%YS","%Dd-%Md-%YL",
	"%Dd-%Md-%YS","%DD-%MD-%YL (Week-%WD %DN)","%DD-%MD-%YL (Week-%Wd %DN)",
	"%DD-%MD-%YL %HH:%MM","%DD-%MN-%YL %HH:%MM","%DD-%MD-%YS %HH:%MM","%DD-%MN-%YS %HH:%MM",
	"%Dd-%Md-%YL %Hh:%Mm","%Dd-%Md-%YS %Hh:%Mm","%DD-%MD-%YL (Week-%WD %DN) %HH:%MM",
	"%DD-%MD-%YL (Week-%Wd %DN) %HH:%MM"],SelIndex),
	assert(le_base_answer(FormatString)),
	win_destroy(Win),!.
  le_dlg_fs_eh(Win,e_Control(idc_cancel,_,_,activated()),0):-
	win_destroy(Win),!.
  le_dlg_fs_eh(Win,e_Control(1,_,_,activated()),0):-
	Window = win_GetCtlHandle(Win,idc_ok),
	win_SendEvent(Win,e_Control(idc_ok,wc_PushButton,Window,activated())),!.

