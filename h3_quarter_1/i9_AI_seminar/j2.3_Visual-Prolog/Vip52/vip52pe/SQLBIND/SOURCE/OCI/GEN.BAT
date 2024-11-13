@ECHO OFF
SET I=%Include%
SET Include=C:\BIN\ORAWIN\PRO15\INCLUDE;C:\BIN\MSVC\include;..;C:\VPRO\foreign
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
@ECHO ON
C:\BIN\MSVC\bin\cl -c /nologo -G2 -Gs -Gx- -J -W3 -ALw -Od -Zp1 ocibind.c
@ECHO OFF
rem C:\BIN\MSVC\bin\cl -c /nologo -G2 -Gs -Gx- -J -W3 -Zd -ALw -Od -Zp1 ocibind.c
@ECHO ON
C:\BIN\MSVC\bin\lib ..\..\lib\win16\ocibind.lib -+ocibind.obj ;
@ECHO OFF
goto end

:bc
SET TCDIR=C:\BC4\
%TCDIR%bin\bcc -c -2 -ml -I..;%MSCDIR%INCLUDE;%PRODIR%FOREIGN ocibind.c
%TCDIR%bin\tlib ..\..\lib\win16\ocibind.lib -+ocibind.obj 
goto end

:end
SET Include=%I%
SET I=

