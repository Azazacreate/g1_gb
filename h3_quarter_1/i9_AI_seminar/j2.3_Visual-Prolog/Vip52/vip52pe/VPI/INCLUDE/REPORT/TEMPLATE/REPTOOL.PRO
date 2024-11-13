/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName: REPTOOL.PRO
 Purpose:  Report Tool project's module template file
 Written by: Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
******************************************************************************/
ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of project:
include "PROJECT.inc"
include "PROJECT.con"

include "Reptool.pre"  		% Public

constants
%--------- Report Engine reservs space for one more digit to prevent -----------
%--------- cutting of wrong printer driver				--------
%  report_reserve_space = 1

%--------- Report Engine does not shift tabulated line with drawing text object ---
%  report_shift_tabpos = 1

%--------- Report Engine calculates time consumption, spent outside tool ---
%--------- eg. on User Defined CallBack functions		------------
%  time_consuption_check = 1

%--------- Report Engine includes tools for reports converting to RTF	----
%  use_rtf_converter = 1

%--------- Excludes the scanner and parser from Report Engine	-------------
%--------- It requires the script to be compressed with COMPRSS.EXE utility -
%--------- which is supplied with Report Engine			-------------
%  no_scanner	= 1

%--------- Any value assigned to warning_level forces RE to put Run Time warning
%--------- to the Message Window 				   -----------
  warning_level = 1

%--------- Temporary file for internal storage of generated Report -----------
  re_temp_file_name = "rep$$$.tmp"


% Replace REPTOOL_DIR with actual path to REPORT tool:
include "REPTOOL_DIR\\Parser.dom"
include "REPTOOL_DIR\\engine.con"
include "REPTOOL_DIR\\repcomm.pro"
ifdef use_rtf_converter
include "REPTOOL_DIR\\rtfconv.pro"
include "REPTOOL_DIR\\tabconv.pro"
enddef
%------------------- EXPRESSIONS, CONDITIONS, FONTS AND PROPERTIES -------------------
include "REPTOOL_DIR\\exp_prop.pro"
%------------------- TEMPORARY BUFFER HANDLE -----------------------------------------
include "REPTOOL_DIR\\temporar.pro"
include "REPTOOL_DIR\\engine.pro"
include "REPTOOL_DIR\\parser.pro"
include "REPTOOL_DIR\\scan.pro"
include "REPTOOL_DIR\\compile.pro"
include "REPTOOL_DIR\\EditPs.Pro"
include "REPTOOL_DIR\\Preview.Pro"
