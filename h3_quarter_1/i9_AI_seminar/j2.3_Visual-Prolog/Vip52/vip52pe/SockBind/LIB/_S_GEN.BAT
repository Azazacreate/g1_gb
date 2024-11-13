@echo off

if not x%1 == x goto CheckTarg
echo Use: _s_gen TARGET (W16/W32/OS32) C_COMPILER (BC/MSC/ICC) DEBUG (DEB/NOD)
goto Stop

:CheckTarg
if not x%_RUN_PATH% == x goto Start
echo Invalid usage (_RUN_PATH) is undefined
goto Stop

:Start
if exist %_RUN_PATH%_s_paths.bat goto CheckCopy
echo File %_RUN_PATH%_s_paths.bat is not found
goto End

:CheckCopy
if x%1 == xOS32 goto ToCopy
if x%1 == xos32 goto ToCopy

call %_RUN_PATH%_s_paths
goto SetSLIB

:ToCopy
if exist %_RUN_PATH%_s_paths.cmd del %_RUN_PATH%_s_paths.cmd
copy %_RUN_PATH%_s_paths.bat %_RUN_PATH%_s_paths.cmd

call %_RUN_PATH%_s_paths
if exist %_RUN_PATH%_s_paths.cmd del %_RUN_PATH%_s_paths.cmd

:SetSLIB
set s_lib=pdcsock.lib
set _tmp_dbg=OFF

if x%3 == x	goto ParseTarget
if x%3 == xNOD	goto ParseTarget
if x%3 == xnod	goto ParseTarget
if x%3 == xDEB	goto UseDebug
if x%3 == xdeb	goto UseDebug
echo Invalid debug mode: %3
goto End

:UseDebug
set _tmp_dbg=ON

:ParseTarget
if x%1 == xW16	goto Win16
if x%1 == xw16	goto Win16

if x%1 == xW32	goto Win32
if x%1 == xw32	goto Win32

if x%1 == xOS32	goto Os232
if x%1 == xos32 goto Os232
echo Invalid platform: %1
goto End

:Win16
if x%2 == xBC goto Win16_BC
if x%2 == xbc goto Win16_BC
echo Invalid C compiler (Win16): %2
goto End

:Win16_BC
set cc_exe=%BC_PATH%bin\bcc.exe
set cc_opt=-w! -c -2 -d -K -H -ml -zEFAR_DATA -Ot -D__WIN__ -I%PRO_PATH%foreign
set lib_exe=%MSVC15_PATH%bin\lib.exe
set lib_opt=/pagesize:128 %S_LIB% psock_tc.obj ;

if x%_TMP_DBG% == xOFF goto Compile

set cc_opt=-y -n %CC_OPT%
goto Compile

:Win32
if x%2 == xMSC	goto Win32_MSC
if x%2 == xmsc	goto Win32_MSC
if x%2 == xBC	goto Win32_BC
if x%2 == xbc	goto Win32_BC
echo Invalid C compiler (Win32): %2
goto End

:Win32_MSC
if exist pdcsock.pdb del pdcsock.pdb

set cc_exe=%MSVC20_PATH%bin\cl.exe
set cc_opt=-GX -WX -nologo -c -Oy- -G3 -Gd -W3 -DWIN32 -D__WIN__ -DMLINEAR
set cc_opt=%CC_OPT% -J -I%PRO_PATH%foreign
set lib_exe=%MSVC20_PATH%bin\lib.exe
set lib_opt=/OUT:%S_LIB% psock_tc.obj

if x%_TMP_DBG% == xOFF goto Compile

set cc_opt=-Zi -Od -Fdpdcsock.pdb %CC_OPT%
goto Compile

:Win32_BC
set cc_exe=%BC_PATH%bin\bcc32.exe
set cc_opt=-w! -N -Tz -Tt -Tm2 -3 -a4 -c -d -H -K -k- -Od -pc -r- -WE -x
set cc_opt=%CC_OPT% -DWIN32 -D__WIN__ -DMLINEAR -I%PRO_PATH%foreign
set lib_exe=%BC_PATH%bin\tlib.exe
set lib_opt=%S_LIB% /p128 +psock_tc.obj

if x%_TMP_DBG% == xOFF goto Compile

set cc_opt=-y -v %CC_OPT%
goto Compile

:Os232
if x%2 == xICC	goto Os232_ICC
if x%2 == xicc	goto Os232_ICC
if x%2 == xBC	goto Os232_BC
if x%2 == xbc	goto Os232_BC
echo Invalid C compiler (Os2): %2
goto End

:Os232_ICC
set cc_exe=%IBMC_PATH%bin\icc.exe
set cc_opt=/Gs- /C /Op- /G3 /Ms /J /Smsp4 /W3 /Ko+ /Q+ /DMLINEAR
set cc_opt=%CC_OPT% /I%PRO_PATH%foreign /I%TLKT21_PATH%c\os2h
set lib_exe=%IBMC_PATH%bin\lib.exe
set lib_opt=/pagesize:128 %S_LIB% psock_tc.obj ;

if x%_TMP_DBG% == xOFF goto Compile

set cc_opt=/Ti+ /Gi+ /D_LOGREC_ %CC_OPT% /I%IBMC_PATH%include
goto Compile

:Os232_BC
set cc_exe=%BCOS2_PATH%bin\bcc.exe
set cc_opt=-N -Od -r- -c -d -k- -pc -K -DMLINEAR
set cc_opt=%CC_OPT% -I%PRO_PATH%foreign;%BCOS2_PATH%include
set lib_exe=%BCOS2_PATH%bin\tlib.exe
set lib_opt=/p64 %S_LIB% +psock_tc.obj

if x%_TMP_DBG% == xOFF goto Compile

set cc_opt=-y -v -D_LOGREC_ %CC_OPT%
goto Compile

:Compile
if exist psock_tc.obj del psock_tc.obj
if exist psock_tc.lst del psock_tc.lst

%CC_EXE% %CC_OPT% %_RUN_PATH%..\source\psock_tc.c >> psock_tc.lst

if exist psock_tc.obj goto MakeLib
echo Unsuccessfull compilation (see psock_tc.lst)
goto End

:MakeLib
if exist %S_LIB% del %S_LIB%
%LIB_EXE% %LIB_OPT%

if exist psock_tc.obj del psock_tc.obj
if exist psock_tc.lst del psock_tc.lst
goto End

:End
set _tmp_dbg=
set s_lib=
set cc_exe=
set cc_opt=
set lib_exe=
set lib_opt=

:Stop

