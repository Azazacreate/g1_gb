# Microsoft Developer Studio Generated NMAKE File, Format Version 4.10
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

!IF "$(CFG)" == ""
CFG=comlayer - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to comlayer - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "comlayer - Win32 Release" && "$(CFG)" !=\
 "comlayer - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "COMLAYER.MAK" CFG="comlayer - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "comlayer - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "comlayer - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 
################################################################################
# Begin Project
# PROP Target_Last_Scanned "comlayer - Win32 Debug"
CPP=cl.exe

!IF  "$(CFG)" == "comlayer - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\lib"
# PROP Intermediate_Dir "..\obj"
# PROP Target_Dir ""
OUTDIR=.\..\lib
INTDIR=.\..\obj

ALL : "$(OUTDIR)\COMUTIL.lib"

CLEAN : 
	-@erase "$(INTDIR)\COMCOM.OBJ"
	-@erase "$(INTDIR)\DISPHELP.OBJ"
	-@erase "$(INTDIR)\intinst.obj"
	-@erase "$(OUTDIR)\COMUTIL.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /Zp4 /W3 /GX /Od /I "d:\vpro\foreign" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /c
CPP_PROJ=/nologo /Zp4 /ML /W3 /GX /Od /I "d:\vpro\foreign" /D "WIN32" /D\
 "NDEBUG" /D "_WINDOWS" /Fp"$(INTDIR)/COMLAYER.pch" /YX /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\..\obj/
CPP_SBRS=.\.
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/COMLAYER.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo /out:"..\lib\COMUTIL.lib"
LIB32_FLAGS=/nologo /out:"$(OUTDIR)/COMUTIL.lib" 
LIB32_OBJS= \
	"$(INTDIR)\COMCOM.OBJ" \
	"$(INTDIR)\DISPHELP.OBJ" \
	"$(INTDIR)\intinst.obj"

"$(OUTDIR)\COMUTIL.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ELSEIF  "$(CFG)" == "comlayer - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "$(OUTDIR)\COMLAYER.lib"

CLEAN : 
	-@erase "$(INTDIR)\COMCOM.OBJ"
	-@erase "$(INTDIR)\DISPHELP.OBJ"
	-@erase "$(INTDIR)\intinst.obj"
	-@erase "$(OUTDIR)\COMLAYER.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /Zp4 /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /c
CPP_PROJ=/nologo /Zp4 /MLd /W3 /GX /Z7 /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)/COMLAYER.pch" /YX /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.\.
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/COMLAYER.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo
LIB32_FLAGS=/nologo /out:"$(OUTDIR)/COMLAYER.lib" 
LIB32_OBJS= \
	"$(INTDIR)\COMCOM.OBJ" \
	"$(INTDIR)\DISPHELP.OBJ" \
	"$(INTDIR)\intinst.obj"

"$(OUTDIR)\COMLAYER.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ENDIF 

.c{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.c{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

################################################################################
# Begin Target

# Name "comlayer - Win32 Release"
# Name "comlayer - Win32 Debug"

!IF  "$(CFG)" == "comlayer - Win32 Release"

!ELSEIF  "$(CFG)" == "comlayer - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\intinst.C

"$(INTDIR)\intinst.obj" : $(SOURCE) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\COMCOM.C

!IF  "$(CFG)" == "comlayer - Win32 Release"

DEP_CPP_COMCO=\
	"..\..\..\VPRO\FOREIGN\IBMMAP.H"\
	"\vpro\foreign\pdcrunt.h"\
	

"$(INTDIR)\COMCOM.OBJ" : $(SOURCE) $(DEP_CPP_COMCO) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "comlayer - Win32 Debug"


"$(INTDIR)\COMCOM.OBJ" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\DISPHELP.CPP

!IF  "$(CFG)" == "comlayer - Win32 Release"

DEP_CPP_DISPH=\
	"..\..\..\VPRO\FOREIGN\IBMMAP.H"\
	"\vpro\foreign\pdcrunt.h"\
	

"$(INTDIR)\DISPHELP.OBJ" : $(SOURCE) $(DEP_CPP_DISPH) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "comlayer - Win32 Debug"


"$(INTDIR)\DISPHELP.OBJ" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
