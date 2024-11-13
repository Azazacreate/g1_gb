/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName: 	REPTOOL.PRO
 Purpose:  	Report Tool project's module template file
 Written by: 	Alexander Grachev
 Version:	1.3
 Build:		018.981112
 Tested with:	Visual Prolog v.5.1 build 555a
 Comments:
******************************************************************************/
ifdef platform_16bit
  code = 5000
enddef

include "applicat.inc"
include "applicat.con"

include "Reptool.pre"  

constants
%--------- Report Engine reservs space for one more digit to prevent -----------
%--------- cutting of wrong printer driver				--------
%  report_reserve_space = 1

%--------- Report Engine does not shift tabulated line with drawing text object ---
%  report_shift_tabpos = 1

%--------- Report Engine calculates time consumption, spent outside tool ---
%--------- eg. on User Defined CallBack functions		------------
%  time_consuption_check = 1

%  use_rtf_converter	= 1

%--------- Any value assigned to warning_level forces RE to put Run Time warning
%--------- to the Message Window 				   -----------
%  warning_level = 1
%--------- Temporary file for internal storage of generated Report -----------
  re_temp_file_name = "rep$$$.tmp"

include "..\\..\\include\\report\\Parser.dom"
include "..\\..\\include\\report\\engine.con"
include "..\\..\\include\\report\\repcomm.pro"
ifdef use_rtf_converter
include "..\\..\\include\\report\\rtfconv.pro"
include "..\\..\\include\\report\\tabconv.pro"
enddef
%------------------- EXPRESSIONS, CONDITIONS, FONTS AND PROPERTIES -------------------
include "..\\..\\include\\report\\exp_prop.pro"
%------------------- TEMPORARY BUFFER HANDLE -----------------------------------------
include "..\\..\\include\\report\\temporar.pro"
%------------------- PANES PRINTING TOOLS --------------------------------------------
include "..\\..\\include\\report\\engine.pro"
ifndef no_scanner
include "..\\..\\include\\report\\parser.pro"
include "..\\..\\include\\report\\scan.pro"
include "..\\..\\include\\report\\compile.pro"
enddef
include "..\\..\\include\\report\\EditPs.Pro"
include "..\\..\\include\\report\\Preview.Pro"
