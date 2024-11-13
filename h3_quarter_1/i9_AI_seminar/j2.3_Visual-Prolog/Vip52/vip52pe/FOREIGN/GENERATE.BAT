@echo off
rem Generate CMAIN.OBJ And PDCGROUP.OBJ
rem *************************************************************
rem * 18/06/96 Microsoft 32 - bit now use coff (masm 6.11)
rem *************************************************************
if "%1"=="" goto Usage
if "%1"=="/?" goto Usage
if "%1"=="?" goto Usage
if "%1"=="-?" goto Usage
if "%1"=="/h" goto Usage
if "%1"=="-h" goto Usage
if "%1"=="/H" goto Usage
if "%1"=="-H" goto Usage
if "%1"=="HELP" goto Usage
if "%1"=="Help" goto Usage
if "%1"=="help" goto Usage
if "%1"=="/help" goto Usage
if "%1"=="/HELP" goto Usage
if "%1"=="/Help" goto Usage

if "%2"=="" goto Usage
if "%3"=="" goto Usage
if "%4"=="" goto Usage





set bcc_opt=
set bcc32_opt=
set tasm_opt=
set tasm32_opt=
set ml_opt=
set cl32_opt=
set cl16_opt=
set masm386_opt=
set bcos2_opt=
set bcos216_opt=
set tasmos2_opt=
set ibmcpp_opt=

set c_compiler=
set my_asm=
set cc_opt=
set asm_opt=
set asm_opt=
set c_dir=
set asm_dir=
set cc_opt=
set asm_opt=
set alp_opt=

set bcc_opt=-w! -c -2 -d -K -H -ml -zEFAR_DATA -Ot -I%prodir%foreign\
set bcc32_opt=-w! -N -3 -a4 -c -E%MY_ASM% -d -H -K -k- -Od -pc -r- -WM -x -I%prodir%\foreign -DMLINEAR
set tasm_opt=/p /z /w2 /m2 /ml
set tasm32_opt=/p /z /w2 /m2 /ml
set ml_opt=/c /Cp /Cx /nologo /coff /w /X
rem set cl32_opt=-DMLINEAR -GX -WX -nologo -c -Oy- -Ox -G3 -Gd -W3 -J -I%prodir%foreign\ -I%msvc20dir%include
set cl32_opt=-DMLINEAR -GX -c -Oy- -Ox -G3 -Gd -W3 -J -I%prodir%foreign\ -I%msvc20dir%include
set cl16_opt=-nologo -c -G2 -Gd -W3 -J -I. -I%prodir%foreign\
set masm386_opt=/D_X86_ /Ml /w1 /z
set bcos2_opt=-sm -N -w! -Od -r- -c -d -k- -pc -K -DMLINEAR -I%prodir%foreign\
set tasmos2_opt=/w2 /z /m2 /ml /DBC
set ibmcpp_opt=/Gs- /c /G3 /Ms /J /Smsp4 /W3 /Ko+ /Q+ /DMLINEAR /I%prodir%foreign\;
set bcos216_opt=-w! -Tz -Tt -Tm2 -c -2 -d -K -H -ml -Ot -DOS2LIB -I.;%bcos2dir%include;..\os2incl
set masm611_opt=/c /Cp /Cx /Zm /nologo /w /X /coff
set alp_opt=-Sc -Sv:MASM60

set bcc_dbg_opt=-v -y
set bcc32_dbg_opt=-v -y
set tasm_dbg_opt=/zi
set ml_dng_opt= /Zi
set cl32_dbg_opt=/Zi
set cl16_dbg_opt=/Zi
set masm386_dbg_opt=/Zi
set bcos2_dbg_opt=-y -v
set tasmos2_dbg_opt=/zi
set ibmcpp_dbg_opt=/Ti /Tx
set masm611_dbg_opt=/Zi /Zd
set alp_opt_dbg=+Od

if x%1 == xNO_DEBUG     goto DebugOff
if x%1 == xno_debug     goto DebugOff
if x%1 == xnodebug      goto DebugOff
if x%1 == xNODEB        goto DebugOff
if x%1 == xnodeb        goto DebugOff

if x%1 == xdebug        goto DebugOn
if x%1 == xDEB          goto DebugOn
if x%1 == xdeb          goto DebugOn
if x%1 == xD            goto DebugOn
if x%1 == xd            goto DebugOn
echo Invalid first parameter: '%1' (debug or nodebug expected)
goto Usage


:DebugOn
set bcc_opt=%bcc_opt% %bcc_dbg_opt%
set bcc32_opt=%bcc32_opt% %bcc32_dbg_opt%
set tasm_opt=%tasm_opt% %tasm_dbg_opts%
set tasm32_opt=%tasm32_opt% %tasm_dbg_opts%
set ml_opt=%ml_opt% %ml_dbg_opt%
set cl32_opt=%cl32_opt%	%cl32_dbg_opt%
set cl16_opt=%cl16_opt%	%cl16_dbg_opt%
set masm386_opt=%masm386_opt% %masm386_dbg_opt%
set bcos2_opt=%bcos2_opt% %bcos2_dbg_opt%
set bcos216_opt=%bcos216_opt% %bcos2_dbg_opt%
set tasmos2_opt=%tasmos2_opt% %tasmos2_dbg_opt%
set ibmcpp_opt=	%ibmcpp_opt% %ibmcpp_dbg_opt%
set masm611_opt=%masm611_opt% %masm611_dbg_opt%
set alp_opt=%alp_opt% %alp_opt_dbg%
goto second_par_parse

:DebugOff
goto second_par_parse

:second_par_parse
if x%2==xDUMMYVPI	goto SetDummVpi
if x%2==xdummyvpi	goto SetDummVpi
if x%2==xDUMMY		goto SetDummy
if x%2==xdummy		goto SetDummy
if x%2==xno_dummy	goto SetNoDummy
if x%2==xNO_DUMMY	goto SetNoDummy
if x%2==xNODUMMY	goto SetNoDummy
if x%2==xnodummy	goto SetNoDummy

echo Invalid second parameter: %2 (dummy or no_dummy expected)
goto Usage

:SetDummVpi
set cc_opt=%cc_opt% -DPDCdummy -DVPI
set asm_opt=%asm_opt% /DVPI
goto version_parse

:SetDummy
set cc_opt=%cc_opt% -DPDCdummy
goto version_parse

:SetNoDummy
set is_dummy=

:version_parse
if x%3 == xDOS		goto DosVersion
if x%3 == xdos		goto DosVersion
if x%3 == xDOSX16	goto DosXVersion
if x%3 == xdosx16	goto DosXVersion
if x%3 == xWIN16	goto Win16Version
if x%3 == xwin16	goto Win16Version
if x%3 == xWIN32	goto Win32Version
if x%3 == xwin32	goto Win32Version
if x%3 == xOS16		goto OS16Version
if x%3 == xos16		goto OS16Version
if x%3 == xOS32		goto OS32Version
if x%3 == xos32		goto OS32Version
echo Invalid third parameter: '%3' (dos ! dosx16 ! win16 ! win32 ! os16 ! os32 )
goto Usage

:DosVersion
set version=DOSLIB
set target=PLATFORM_16BITS
goto test_path

:DosXVersion
set version=DOSXLIB
set target=PLATFORM_16BITS
goto test_path

:Win16Version
set version=WIN16
set target=PLATFORM_16BITS
goto test_path

:Win32Version
set version=WIN32
goto test_path

:OS16Version
set version=OS16
goto test_path

:OS32Version
set version=OS32
goto test_path

:test_path
if %version% == OS32 goto test_os2_path
if %version% == OS16 goto test_os2_path

if %prodir% == ""	goto Path_is_Empty
if %msvcdir% == ""	goto Path_is_Empty
if %msvc20dir% == ""	goto Path_is_Empty
if %bcdir% == ""	goto Path_is_Empty
if %tasmdir% == ""	goto Path_is_Empty
if %mstoolsdir% == ""	goto Path_is_Empty
if %masm611dir% ==  ""	goto Path_is_Empty
goto parse_compiler

:test_os2_path
if %bcos2dir% == ""	goto Path_is_Empty
if %tasmos2dir% == ""	goto Path_is_Empty
if %ibmcdir% == ""	goto Path_is_Empty
goto parse_compiler

:Path_is_Empty
set error=path to compilers haven't defined
goto Error

:parse_compiler
if x%4 == xbc		goto BC
if x%4 == xBC		goto BC

if x%4 == xmsc		goto MSC
if x%4 == xMSC		goto MSC

if x%4 == xibmcpp	goto IBM
if x%4 == xIBMCPP	goto IBM

echo Invalid parameter: '%4' (must be BC ! MSC ! IBMCPP )
goto Usage

:BC
if x%version% == xDOSLIB	goto bccset
if x%version% == xDOSXLIB	goto bccset
if x%version% == xWIN16		goto bccset
if x%version% == xWIN32		goto bcc32set
if x%version% == xOS16		goto bccos16set
if x%version% == xOS32 		goto bccos32set

set error_msg=wrong version variables
goto error

:bccset
set c_compiler=bcc
set my_asm=tasm
set cc_opt=%cc_opt% %bcc_opt% -D%version% -I%c_dir%include\
set asm_opt=%asm_opt% %tasm_opt% /D%version%
set asm_dir=%tasmdir%bin\
set c_dir=%bcdir%bin\
goto Start

:bcc32set
set c_compiler=bcc32
set my_asm=tasm32
set cc_opt=%cc_opt% %bcc32_opt% -D%version%
set asm_opt=%asm_opt% %tasm32_opt% /D%version% /D%c_compiler%
set c_dir=%bcdir%bin\
set asm_dir=%tasmdir%bin\
goto Start

:bccos32set
set c_compiler=bcc
set my_asm=tasm
set c_dir=%bcos2dir%bin\
set asm_dir=%tasmos2dir%bin\
set cc_opt=%cc_opt% %bcos2_opt% -D%version%
set asm_opt=%asm_opt% %tasmos2_opt% /D%version% /D%c_compiler%
goto Start

:bccos16set
set c_compiler=bcc
set my_asm=tasm
set c_dir=%bcos2dir%bin\
set asm_dir=%tasmos2dir%bin\
set cc_opt=%cc_opt% %bcos216_opt%  -D%version%
set asm_opt=%asm_opt% %tasmos2_opt% /D%version%
goto Start

:MSC
set c_comp_def=MSC
if x%version% == xDOSLIB	goto clset
if x%version% == xDOSXLIB	goto clset
if x%version% == xWIN16		goto clset
if x%version% == xWIN32		goto cl32set
set error=wrong version variables
goto error

:clset
set c_compiler=cl
set my_asm=tasm
set asm_opt=%asm_opt% %tasm_opt% /D%version%
set cc_opt=%cc_opt% %cl16_opt% -D%version%
set c_dir=%msvcdir%bin\
set asm_dir=%tasmdir%bin\
goto Start

:cl32set
set c_compiler=cl
rem set my_asm=masm386
set my_asm=ml
set cc_opt=%cc_opt% %cl32_opt% -D%version%
rem set asm_opt=%asm_opt% %masm386_opt% /D%version% /D%c_comp_def%
set asm_opt=%asm_opt% %masm611_opt% /D%version% /D%c_comp_def%
set c_dir=%msvc20dir%bin\
rem set asm_dir=%mstoolsdir%bin\
set asm_dir=%masm611dir%bin\
set target=%prodir%lib\win32\msc\
goto Start

:IBM
set c_compiler=icc
set my_asm=alp
set cc_opt=%cc_opt% %ibmcpp_opt% -D%version%
set c_dir=%ibmcdir%bin\
set asm_dir=%alp_dir%
set asm_opt=%alp_opt% -D:%version% -D:IBMCPP
goto Start

:Start
if x%version% == xOS16 goto os16gen
%c_dir%%c_compiler% %cc_opt% %prodir%foreign\cmain.c
if x%version% == xDOSLIB goto dosgen
if x%version% == xDOSXLIB goto dosxgen
if x%version% == xWIN16 goto win16gen
if x%version% == xWIN32 goto win32gen
if x%version% == xOS32 goto os32gen
set error=wrong version variables
goto error

:dosgen
%asm_dir%%my_asm% %asm_opt% %prodir%foreign\inits\init.asm %prodir%\lib\dos\init.obj
if x%c_compiler% == xbcc goto bcadd
if x%c_compiler% == xcl goto mscadd
goto End

:bcadd
%asm_dir%%my_asm% %asm_opt% %prodir%foreign\inits\bcinit.asm %prodir%lib\dos\bc\bcinit.obj
%asm_dir%%my_asm% %asm_opt% %prodir%foreign\inits\bcfirst.asm %prodir%lib\dos\bc\bcfirst.obj
goto End

:mscadd
%asm_dir%%my_asm% %asm_opt% %prodir%foreign\inits\mscinit.asm %prodir%\lib\dos\msc\mscinit.obj
goto End

:dosxgen
%asm_dir%%my_asm% %asm_opt% /D%target% %prodir%foreign\pdcgroup.asm
%asm_dir%%my_asm% %asm_opt% %prodir%foreign\inits\initph.asm %prodir%lib\dosx16\init.obj
goto End

:win16gen
%asm_dir%%my_asm% %asm_opt% /D%target% %prodir%foreign\pdcgroup.asm
%asm_dir%%my_asm% %asm_opt% %prodir%foreign\inits\initw.asm %prodir%\lib\win16\init.obj
goto End

:win32gen
if x%my_asm% == xmasm386 goto masm386
%asm_dir%%my_asm% %asm_opt% %prodir%foreign\pdcgroup.asm
if x%c_compiler% == xbcc32 goto End
%asm_dir%%my_asm% %asm_opt% /DPROLOG_EXE %prodir%foreign\inits\init32.asm
%asm_dir%%my_asm% %asm_opt% /DPROLOG_DLL /Foinit32d.obj %prodir%foreign\inits\init32.asm
goto End

:masm386
%asm_dir%%my_asm% %asm_opt% %prodir%foreign\pdcgroup.asm %target%pdcgroup.obj nul nul
goto End

:os32gen
echo %asm_dir%%my_asm% %asm_opt% %prodir%foreign\pdcgroup.asm
%asm_dir%%my_asm% %asm_opt% %prodir%foreign\pdcgroup.asm
%asm_dir%%my_asm% %asm_opt% -D:PROLOG_EXE -D:PDC_LINK %prodir%foreign\inits\init32.asm
copy init32.obj ..\init32.obj
del init32.obj
%asm_dir%%my_asm% %asm_opt% -D:PROLOG_EXE -D:OS2_LINK %prodir%foreign\inits\init32.asm
goto End

:os16gen
set asm_opt=%asm_opt% /i%tasmos2_dir%\include
%asm_dir%%my_asm% %asm_opt% %prodir%foreign\inits\init2.asm %prodir%\lib\os2_16\init.obj
goto End

:error
echo %error_msg%
goto usage

:usage
echo 
echo Usage : generate IS_DEBUG IS_DUMMY PLATFORM C_COMPILER
echo Examples : generate debug dummy dos bc

echo Notes:
echo 
echo **************************************************************
echo You must :
echo 1. set you path to compiler in file vpro\foreign\setpath.bat
echo 2. set path to setpath.bat file in current gen.bat file
echo **************************************************************


:End


