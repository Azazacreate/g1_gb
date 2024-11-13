@echo off
rem Generate CMAIN.OBJ for Microsoft C 32bit windows (NT)

set prodir=d:\vpro\
set cdir=c:\msvc20\

@echo on
%CDIR%bin\cl.exe -nologo -GX -Ox -Oy- -c -G3 -Gd -W3 -D_X86_=1 -DWIN32 -DMLINEAR -J -I.. -I%CDIR%include -I%PRODIR%foreign odbcbind.c
if not exist odbcbind.obj goto out
%CDIR%bin\lib.exe /OUT:%PRODIR%sqlbind\lib\win32\odbcbind.lib odbcbind.obj
del odbcbind.obj

:out
set prodir=
set cdir=
