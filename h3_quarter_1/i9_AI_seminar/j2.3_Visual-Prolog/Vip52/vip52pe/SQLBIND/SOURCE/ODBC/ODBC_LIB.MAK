# Microsoft Visual C++ generated build script - Do not modify

PROJ = ODBC_LIB
DEBUG = 1
PROGTYPE = 4
CALLER = 
ARGS = 
DLLS = 
D_RCDEFINES = -d_DEBUG
R_RCDEFINES = -dNDEBUG
ORIGIN = MSVC
ORIGIN_VER = 1.00
PROJPATH = C:\BIN\VPRO\SQLBIND\SOURCE\ODBC\
USEMFC = 0
CC = cl
CPP = cl
CXX = cl
CCREATEPCHFLAG = 
CPPCREATEPCHFLAG = 
CUSEPCHFLAG = 
CPPUSEPCHFLAG = 
FIRSTC = ODBCBIND.C  
FIRSTCPP =             
RC = rc
CFLAGS_D_LIB = /nologo /f- /Gs /G2 /Zp1 /W3 /Zi /ALw /Od /D "_DEBUG" /FR /GA /Fd"ODBC_LIB.PDB"
CFLAGS_R_LIB = /nologo /Gs /G2 /W3 /AM /Ox /D "NDEBUG" /FR /GA 
RCFLAGS = /nologo
RESFLAGS = /nologo
RUNFLAGS = 
OBJS_EXT = 
LIBS_EXT = 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_LIB)
LFLAGS = 
LIBS = 
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
!else
CFLAGS = $(CFLAGS_R_LIB)
LFLAGS = 
LIBS = 
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = ODBCBIND.SBR


ODBCBIND_DEP = c:\bin\vpro\foreign\pdcrunt.h \
	c:\bin\vpro\foreign\ibmmap.h \
	c:\bin\vpro\sqlbind\source\sqlbind.h


all:	$(PROJ).LIB $(PROJ).BSC

ODBCBIND.OBJ:	ODBCBIND.C $(ODBCBIND_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c ODBCBIND.C

$(PROJ).LIB::	ODBCBIND.OBJ $(OBJS_EXT)
	echo >NUL @<<$(PROJ).CRF
$@ /PAGESIZE:64
y
+ODBCBIND.OBJ &
;
<<
	if exist $@ del $@
	lib @$(PROJ).CRF

$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
