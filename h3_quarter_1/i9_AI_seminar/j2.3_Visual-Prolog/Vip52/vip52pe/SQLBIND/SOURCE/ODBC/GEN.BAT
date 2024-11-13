@ECHO OFF
SET I=%Include%
SET Include=C:\BIN\MSVC\include;..;C:\VPRO\foreign
rem goto bc
:msc
rem -G2   generate instructions for 80286
rem -Gs   Disable stack probes
rem -Gx-  Used with -AL to assume all data far
rem -J    Default character type is unsigned char
rem -W3   Warning level 3
rem -ALw  Use Large memory model 
rem         (one code segment per module, multiple data segments), 
rem         do not assume SS==DS, don't load DS at fct entry
rem -Od   Disable optimization, selects the fast code generator (-f)
rem -Zp1  Pack structures on one-byte boundaries
rem -nologo  Disable display of the sign-on banner when the compiler starts up
rem
rem C:\BIN\MSVC\bin\cl -c /Gs /G2 /Zp1 /W3 /ALw /O2 /D "NDEBUG" /FR /GA odbcbind.c
@ECHO ON
rem C:\BIN\MSVC\bin\cl -c /nologo -G2 -Gs -Gx- -J -W3 -ALw -Od -Zp1 odbcbind.c
@ECHO OFF
rem Use the following line for debugging version
rem
C:\BIN\MSVC\bin\cl -c /nologo -G2 -Gs -Gx- -J -W3 -Zd -ALw -Od -Zp1 odbcbind.c
@ECHO ON
C:\BIN\MSVC\bin\lib ..\..\lib\win16\odbcbind.lib -+odbcbind.obj ;
@ECHO OFF
goto end

:bc
SET TCDIR=C:\BC4\
%TCDIR%bin\bcc -c -2 -ml -I..;%MSCDIR%INCLUDE;%PRODIR%FOREIGN odbcbind.c
%TCDIR%bin\tlib ..\..\lib\win16\odbcbind.lib -+odbcbind.obj 
goto end

:end
SET Include=%I%
SET I=

