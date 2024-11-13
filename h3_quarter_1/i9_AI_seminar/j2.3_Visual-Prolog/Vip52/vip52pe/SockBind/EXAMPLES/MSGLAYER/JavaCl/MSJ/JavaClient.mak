# Microsoft Developer Studio Generated NMAKE File, Format Version 4.20
# ** DO NOT EDIT **

# TARGTYPE "Java Virtual Machine Java Workspace" 0x0809

!IF "$(CFG)" == ""
CFG=JavaClient - Java Virtual Machine Debug
!MESSAGE No configuration specified.  Defaulting to JavaClient - Java Virtual\
 Machine Debug.
!ENDIF 

!IF "$(CFG)" != "JavaClient - Java Virtual Machine Release" && "$(CFG)" !=\
 "JavaClient - Java Virtual Machine Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "JavaClient.mak"\
 CFG="JavaClient - Java Virtual Machine Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "JavaClient - Java Virtual Machine Release" (based on\
 "Java Virtual Machine Java Workspace")
!MESSAGE "JavaClient - Java Virtual Machine Debug" (based on\
 "Java Virtual Machine Java Workspace")
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
JAVA=jvc.exe

!IF  "$(CFG)" == "JavaClient - Java Virtual Machine Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir ""
# PROP BASE Intermediate_Dir ""
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir ""
# PROP Intermediate_Dir ""
# PROP Target_Dir ""
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\ReadDataTh.class" "$(OUTDIR)\JavaClient.class"\
 "$(OUTDIR)\ConnectionDlg.class" "$(OUTDIR)\NewKeyDlg.class"

CLEAN : 
	-@erase "$(INTDIR)\ConnectionDlg.class"
	-@erase "$(INTDIR)\JavaClient.class"
	-@erase "$(INTDIR)\NewKeyDlg.class"
	-@erase "$(INTDIR)\ReadDataTh.class"

# ADD BASE JAVA /O
# ADD JAVA /O

!ELSEIF  "$(CFG)" == "JavaClient - Java Virtual Machine Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir ""
# PROP BASE Intermediate_Dir ""
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir ""
# PROP Intermediate_Dir ""
# PROP Target_Dir ""
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\ReadDataTh.class" "$(OUTDIR)\JavaClient.class"\
 "$(OUTDIR)\ConnectionDlg.class" "$(OUTDIR)\NewKeyDlg.class"

CLEAN : 
	-@erase "$(INTDIR)\ConnectionDlg.class"
	-@erase "$(INTDIR)\JavaClient.class"
	-@erase "$(INTDIR)\NewKeyDlg.class"
	-@erase "$(INTDIR)\ReadDataTh.class"

# ADD BASE JAVA /g
# ADD JAVA /g

!ENDIF 

################################################################################
# Begin Target

# Name "JavaClient - Java Virtual Machine Release"
# Name "JavaClient - Java Virtual Machine Debug"

!IF  "$(CFG)" == "JavaClient - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "JavaClient - Java Virtual Machine Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\JavaClient.java

!IF  "$(CFG)" == "JavaClient - Java Virtual Machine Release"


"$(INTDIR)\ReadDataTh.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\JavaClient.class" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "JavaClient - Java Virtual Machine Debug"


"$(INTDIR)\ReadDataTh.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\JavaClient.class" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\ConnectionDlg.java

!IF  "$(CFG)" == "JavaClient - Java Virtual Machine Release"


"$(INTDIR)\ConnectionDlg.class" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "JavaClient - Java Virtual Machine Debug"


"$(INTDIR)\ConnectionDlg.class" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\NewKeyDlg.java

!IF  "$(CFG)" == "JavaClient - Java Virtual Machine Release"


"$(INTDIR)\NewKeyDlg.class" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "JavaClient - Java Virtual Machine Debug"


"$(INTDIR)\NewKeyDlg.class" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
