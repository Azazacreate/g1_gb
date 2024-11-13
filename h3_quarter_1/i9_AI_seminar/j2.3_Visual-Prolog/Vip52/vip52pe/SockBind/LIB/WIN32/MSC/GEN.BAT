@echo off

rem Usage: gen [DEB]

set _run_path=..\..\
set _is_debug=NOD

if x%1 == x goto Run
set _is_debug=%1

:Run
call %_RUN_PATH%_s_gen W32 MSC %_IS_DEBUG%

set _is_debug=
set _run_path=

