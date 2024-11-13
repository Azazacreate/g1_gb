# Microsoft Developer Studio Generated NMAKE File, Based on Odbclib.dsp
!IF "$(CFG)" == ""
CFG=odbclib - Win32 Release
!MESSAGE No configuration specified. Defaulting to odbclib - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "odbclib - Win32 Release" && "$(CFG)" !=\
 "odbclib - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Odbclib.mak" CFG="odbclib - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "odbclib - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "odbclib - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "odbclib - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\Odbclib.lib"

!ELSE 

ALL : "$(OUTDIR)\Odbclib.lib"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\ODBCLIB.OBJ"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(OUTDIR)\Odbclib.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp4 /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)\Odbclib.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Release/
CPP_SBRS=.

.c{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Odbclib.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\Odbclib.lib" 
LIB32_OBJS= \
	"$(INTDIR)\ODBCLIB.OBJ"

"$(OUTDIR)\Odbclib.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ELSEIF  "$(CFG)" == "odbclib - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\Odbclib.lib"

!ELSE 

ALL : "$(OUTDIR)\Odbclib.lib"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\ODBCLIB.OBJ"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(OUTDIR)\Odbclib.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp4 /MLd /W3 /GR /GX /Z7 /O2 /D "WIN32" /D "_DEBUG" /D\
 "_WINDOWS" /Fp"$(INTDIR)\Odbclib.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD\
 /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.

.c{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

BSC32=bscmake.exe
BSC32_FLAGS=/o"$(OUTDIR)\Odbclib.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/out:"$(OUTDIR)\Odbclib.lib" 
LIB32_OBJS= \
	"$(INTDIR)\ODBCLIB.OBJ"

"$(OUTDIR)\Odbclib.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ENDIF 


!IF "$(CFG)" == "odbclib - Win32 Release" || "$(CFG)" ==\
 "odbclib - Win32 Debug"
SOURCE=..\..\..\SOURCE\ODBCLIB.C

!IF  "$(CFG)" == "odbclib - Win32 Release"

DEP_CPP_ODBCL=\
	"..\..\..\source\odbclib.h"\
	"..\..\..\source\pdcrunt.h"\
	

"$(INTDIR)\ODBCLIB.OBJ" : $(SOURCE) $(DEP_CPP_ODBCL) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "odbclib - Win32 Debug"

DEP_CPP_ODBCL=\
	"..\..\..\source\odbclib.h"\
	"..\..\..\source\pdcrunt.h"\
	
NODEP_CPP_ODBCL=\
	"..\..\..\source\ibmmap.h"\
	

"$(INTDIR)\ODBCLIB.OBJ" : $(SOURCE) $(DEP_CPP_ODBCL) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


!ENDIF 


!ENDIF 

