@echo off
 

if exist $$$.cmd del $$$.cmd

copy %prodir%\foreign\generate.bat %prodir%\foreign\$$$.cmd
if exist %prodir%\foreign\$$$.cmd goto Start
goto Error

:Start
call %prodir%\foreign\$$$.cmd %1 %2 %3 %4
del %prodir%\foreign\$$$.cmd
goto End

:Error
echo cannot make os2 cmd file

:End