/*****************************************************************************

                Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  FTPAgent
 FileName: dcbase64.PRO
 Purpose: Example of Winsock 1.1 and FTP
 Written by: Konstantin Ivanov
 Comments: Predicate encrypts/decrypts a string. See base64 standard for technical details
******************************************************************************/

include "ftpagent.inc"
include "ftpagent.con"
  
PREDICATES
 code_symb(INTEGER,CHAR) - (i,o),(o,i)
 
 cd_base64(STRING,STRING,STRING) - (i,i,o)
 code_segm(STRING,STRING) - (i,o)
 code_n_symb(CHAR,INTEGER,INTEGER) - (i,o,o)
 code_n_symb(INTEGER,CHAR,INTEGER,INTEGER,INTEGER) - (i,i,i,o,o)
 
 decd_base64(STRING,STRING,STRING) - (i,i,o)
 decd_del_eq(STRING,STRING) - (i,o)
 decode_segm(STRING,STRING) - (i,o)
 decode_n_symb(INTEGER,INTEGER,INTEGER,CHAR) - (i,i,i,o) 
 
CLAUSES
 code_base64(In,Out):-
 	bound(In),
 	free(Out),
 	cd_base64(In,"",Out),!.
 code_base64(In,Out):-
 	bound(Out),
 	free(In),
 	decd_del_eq(Out,Out1),
 	decd_base64(Out1,"",In).
 
 %_____coding_________________
 
  cd_base64("",Out,Out):-!.
  cd_base64(In,Ak,Out):-
	str_len(In,Length),
	Length < 3,!,
	code_segm(In,Cd),
	concat(Ak,Cd,Out).
  cd_base64(In,Ak,Out):-
	frontstr(3,In,StartString,RestString),
	code_segm(Startstring,Cd),
	concat(Ak,Cd,Ak1),!,
	cd_base64(RestString,Ak1,Out).
	
  code_segm(In,Out):-
 	str_len(In,Len),
 	Len = 1,!,
	frontchar(In,Symb1,_),
	code_n_symb(Symb1,Rs1_dec,Rs2_dec),
	code_symb(Rs1_dec,Rs1),
	code_symb(Rs2_dec,Rs2),
	format(Out,"%c%c==",Rs1,Rs2),
	!.
  code_segm(In,Out):-
  	str_len(In,Len),
 	Len = 2,!,
 	frontchar(In,Symb1,Rest1),
 	frontchar(Rest1,Symb2,_),
 	code_n_symb(Symb1,Rs1_dec,Rest1_dec),
 	code_n_symb(2,Symb2,Rest1_dec,Rs2_dec,Rs3_dec),
	code_symb(Rs1_dec,Rs1),
	code_symb(Rs2_dec,Rs2),
	code_symb(Rs3_dec,Rs3),
	format(Out,"%c%c%c=",Rs1,Rs2,Rs3),
	!.
  code_segm(In,Out):-
  	str_len(In,Len),
 	Len = 3,!,
 	frontchar(In,Symb1,Rest1),
	frontchar(Rest1,Symb2,Rest2),
	frontchar(Rest2,Symb3,_),
	code_n_symb(Symb1,Rs1_dec,Rest1_dec),
 	code_n_symb(2,Symb2,Rest1_dec,Rs2_dec,Rest2_dec),
 	code_n_symb(3,Symb3,Rest2_dec,Rs3_dec,Rs4_dec),
	code_symb(Rs1_dec,Rs1),
	code_symb(Rs2_dec,Rs2),
	code_symb(Rs3_dec,Rs3),
	code_symb(Rs4_dec,Rs4),
	format(Out,"%c%c%c%c",Rs1,Rs2,Rs3,Rs4),
 	!.
 	
  code_n_symb(Symb,Rs1_dec,Rest_dec):-
  	char_int(Symb,Symb_i),
	bitright(Symb_i,2,Rs1_dec),
	bitleft(Symb_i,4,Temp_dec),
	bitand(Temp_dec,0x30,Rest_dec),!.
  code_n_symb(2,Symb,RestPr_dec,Rs2_dec,Rest_dec):-
	char_int(Symb,Symb_i),
	bitright(Symb_i,4,TempLow_dec),
	bitor(RestPr_dec,TempLow_dec,Rs2_dec),
	bitleft(Symb_i,2,Temp_dec),
	bitand(Temp_dec,0x3C,Rest_dec),!.
  code_n_symb(3,Symb,RestPr_dec,Rs3_dec,Rs4_dec):-
	char_int(Symb,Symb_i),
	bitright(Symb_i,6,TempLow_dec),
	bitor(RestPr_dec,TempLow_dec,Rs3_dec),
	bitand(Symb_i,0x3F,Rs4_dec),!.
 
%______decoding_____________

  decd_del_eq(In,Out):-
	searchchar(In,'=',FoundPos),
	FP = FoundPos - 1,
	frontstr(FP,In,Out,_),!.
  decd_del_eq(In,In).
  	
  decd_base64("",Out,Out):-!.
  decd_base64(In,Ak,Out):-
	str_len(In,Length),
	Length < 4,!,
	decode_segm(In,Cd),
	concat(Ak,Cd,Out).
  decd_base64(In,Ak,Out):-
	frontstr(4,In,StartString,RestString),
	decode_segm(Startstring,Cd),
	concat(Ak,Cd,Ak1),!,
	decd_base64(RestString,Ak1,Out).
	
  decode_segm(In,Out):-
  	str_len(In,Len),
  	Len = 2,!,
  	frontchar(In,Symb1,Rest1),
 	frontchar(Rest1,Symb2,_),
 	code_symb(Symb1_dec,Symb1),
 	code_symb(Symb2_dec,Symb2),
 	decode_n_symb(1,Symb1_dec,Symb2_dec,Rs1),
 	format(Out,"%c",Rs1),
 	!.
  decode_segm(In,Out):-
  	str_len(In,Len),
  	Len = 3,!,
  	frontchar(In,Symb1,Rest1),
 	frontchar(Rest1,Symb2,Rest2),
 	frontchar(Rest2,Symb3,_),
 	code_symb(Symb1_dec,Symb1),
 	code_symb(Symb2_dec,Symb2),
 	code_symb(Symb3_dec,Symb3),
 	decode_n_symb(1,Symb1_dec,Symb2_dec,Rs1),
 	decode_n_symb(2,Symb2_dec,Symb3_dec,Rs2),
	format(Out,"%c%c",Rs1,Rs2),
 	!.
   decode_segm(In,Out):-
  	str_len(In,Len),
  	Len = 4,!,
  	frontchar(In,Symb1,Rest1),
 	frontchar(Rest1,Symb2,Rest2),
 	frontchar(Rest2,Symb3,Rest3),
 	frontchar(Rest3,Symb4,_),
 	code_symb(Symb1_dec,Symb1),
 	code_symb(Symb2_dec,Symb2),
 	code_symb(Symb3_dec,Symb3),
 	code_symb(Symb4_dec,Symb4),
 	decode_n_symb(1,Symb1_dec,Symb2_dec,Rs1),
 	decode_n_symb(2,Symb2_dec,Symb3_dec,Rs2),
 	decode_n_symb(3,Symb3_dec,Symb4_dec,Rs3),
	format(Out,"%c%c%c",Rs1,Rs2,Rs3),
  	!.
  	
  decode_n_symb(1,Symb1_dec,Symb2_dec,Rs1):-
  	bitleft(Symb1_dec,2,TempHigh1_dec),
	bitright(Symb2_dec,4,TempLow1_dec),
	bitor(TempHigh1_dec,TempLow1_dec,Rs1_dec),
	char_int(Rs1,Rs1_dec),!.
  decode_n_symb(2,Symb2_dec,Symb3_dec,Rs2):-
  	bitleft(Symb2_dec,4,TempHigh2_dec),
	bitright(Symb3_dec,2,TempLow2_dec),
	bitor(TempHigh2_dec,TempLow2_dec,Rs2_dec),
	char_int(Rs2,Rs2_dec),!.
  decode_n_symb(3,Symb3_dec,Symb4_dec,Rs3):-
  	bitleft(Symb3_dec,6,TempHigh3_dec),
	bitor(TempHigh3_dec,Symb4_dec,Rs3_dec),
	char_int(Rs3,Rs3_dec),!.
	
%______code table___________

  code_symb(0,'A').code_symb(16,'Q').code_symb(32,'g').code_symb(48,'w').
  code_symb(1,'B').code_symb(17,'R').code_symb(33,'h').code_symb(49,'x').
  code_symb(2,'C').code_symb(18,'S').code_symb(34,'i').code_symb(50,'y').
  code_symb(3,'D').code_symb(19,'T').code_symb(35,'j').code_symb(51,'z').
  code_symb(4,'E').code_symb(20,'U').code_symb(36,'k').code_symb(52,'0').
  code_symb(5,'F').code_symb(21,'V').code_symb(37,'l').code_symb(53,'1').
  code_symb(6,'G').code_symb(22,'W').code_symb(38,'m').code_symb(54,'2').
  code_symb(7,'H').code_symb(23,'X').code_symb(39,'n').code_symb(55,'3').
  code_symb(8,'I').code_symb(24,'Y').code_symb(40,'o').code_symb(56,'4').
  code_symb(9,'J').code_symb(25,'Z').code_symb(41,'p').code_symb(57,'5').
  code_symb(10,'K').code_symb(26,'a').code_symb(42,'q').code_symb(58,'6').
  code_symb(11,'L').code_symb(27,'b').code_symb(43,'r').code_symb(59,'7').
  code_symb(12,'M').code_symb(28,'c').code_symb(44,'s').code_symb(60,'8').
  code_symb(13,'N').code_symb(29,'d').code_symb(45,'t').code_symb(61,'9').
  code_symb(14,'O').code_symb(30,'e').code_symb(46,'u').code_symb(62,'+').
  code_symb(15,'P').code_symb(31,'f').code_symb(47,'v').code_symb(63,'/').
