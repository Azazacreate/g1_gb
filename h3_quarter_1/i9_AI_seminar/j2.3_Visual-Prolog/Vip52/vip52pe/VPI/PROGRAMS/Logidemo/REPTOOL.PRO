/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName: 	REPTOOL.PRO
 Purpose: 	Report Tool project's module template file
 Written by: 	Alexander Grachev
 Version:	1.3
 Build:		018.981112
 Tested with:	Visual Prolog v.5.1 build 555a
 Comments:
******************************************************************************/
ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of project:
include "trans.inc"
include "trans.con"

include "Reptool.pre"  		% Public

constants
%--------- Report Engine reservs space for one more digit to prevent -----------
%--------- cutting of wrong printer driver				--------
%  report_reserve_space = 1

%--------- Report Engine does not shift tabulated line with drawing text object ---
  report_shift_tabpos = 1

%--------- Report Engine calculates time consumption, spent outside tool ---
%--------- eg. on User Defined CallBack functions		------------
%  time_consuption_check = 1

%--------- Report Engine includes tools for reports converting to RTF	----
%  use_rtf_converter = 1

%--------- Plan Printing tools allow to print Gantt and scheme diagram	----
%--------- Should be defined in "PROJECT.inc"
%  use_report_plan_print = 1

%--------- Any value assigned to warning_level forces RE to put Run Time warning
%--------- to the Message Window 				   -----------
  warning_level = 1

%--------- Temporary file for internal storage of generated Report -----------
  re_temp_file_name = "rep$$$.tmp"

ifdef use_report_plan_print

include "plantool.pre"			% External
include "date.pre"			% External

% Replace PLANTOOL_DIR with actual path to PLAN tool
% and REPTOOL_DIR with actual path to REPORT tool:

include "REPORT\\Parser.dom"
include "REPORT\\planprnt.pro"

elsedef
include "REPORT\\Parser.dom"
enddef

include "REPORT\\engine.con"
include "REPORT\\repcomm.pro"
%------------------- EXPRESSIONS, CONDITIONS, FONTS AND PROPERTIES -------------------
include "REPORT\\exp_prop.pro"
%------------------- TEMPORARY BUFFER HANDLE -----------------------------------------
include "REPORT\\temporar.pro"
include "REPORT\\engine.pro"
%------------------- PANES PRINTING TOOLS --------------------------------------------

%ifdef use_report_plan_print
%include "REPTOOL_DIR\\panesprn.pro"
%elsedef
%clauses
%  end_of_pane.
%enddef

ifdef use_rtf_converter
%------------------- predicates TO CONVERT REPORTS TO RTFormat -----------------------
include "REPORT\\rtfconv.pro"
%-------------------------------------------------------------------------------------
enddef

include "REPORT\\parser.pro"
include "REPORT\\scan.pro"
include "REPORT\\compile.pro"
include "REPORT\\EditPs.Pro"
include "REPORT\\Preview.Pro"
include "Tools\\Reports\\Reports.pro"
