; Module Name: BSEDOS.INC
;
; Includes the definitions for the DOS kernel
;
; Copyright (c) 1988  Microsoft Corporation
;
; The following symbols are used in this file for conditional sections:
;
;    Define:                 To include:
;
;    INCL_DOSPROCESS         Process and thread support
;    INCL_DOSINFOSEG         InfoSeg support
;    INCL_DOSFILEMGR         File Management
;    INCL_DOSMEMMGR          Memory Management
;    INCL_DOSSEMAPHORES      Semaphore support
;    INCL_DOSDATETIME        Date/Time and Timer support
;    INCL_DOSMODULEMGR       Module manager
;    INCL_DOSRESOURCES       Resource support
;    INCL_DOSNLS             National Language Support
;    INCL_DOSSIGNALS         Signals
;    INCL_DOSMONITORS        Monitors
;    INCL_DOSQUEUES          Queues
;    INCL_DOSSESMGR          Session Manager Support

INCL_DOSINCLUDED    equ 1

ifdef INCL_DOS
INCL_DOSPROCESS     equ 1
INCL_DOSINFOSEG     equ 1
INCL_DOSFILEMGR     equ 1
INCL_DOSMEMMGR      equ 1
INCL_DOSSEMAPHORES  equ 1
INCL_DOSDATETIME    equ 1
INCL_DOSMODULEMGR   equ 1
INCL_DOSRESOURCES   equ 1
INCL_DOSNLS         equ 1
INCL_DOSSIGNALS     equ 1
INCL_DOSMONITORS    equ 1
INCL_DOSQUEUES      equ 1
INCL_DOSSESMGR      equ 1
endif ;  INCL_DOS

ifdef INCL_ERRORS
INCL_DOSERRORS      equ 1
endif ;  INCL_ERRORS   

; **********************************
; *** Process and thread support ***
; **********************************

if1

; DosBeep included unconditonally
@DosBeep EQU <@Macro DOSBEEP, 2, 00b>

; DosExit included unconditonally
@DosExit EQU <@Macro DOSEXIT, 2, 00b>

endif ;  Pass 1

; Action codes for DosExit
EXIT_THREAD     equ 0       ; Current thread only
EXIT_PROCESS    equ 1       ; All threads in process

ifdef INCL_DOSPROCESS

; Action codes for DosCWait
DCWA_PROCESS        equ 0
DCWA_PROCESSTREE    equ 1

; Wait option values for DosCWait
DCWW_WAIT           equ 0
DCWW_NOWAIT         equ 1

; TerminateCode values for DosCWait and DosExecPgm
TC_EXIT             equ 0
TC_HARDERROR        equ 1
TC_TRAP             equ 2
TC_KILLPROCESS      equ 3

; DosExitList functions
EXLST_ADD           equ 1
EXLST_REMOVE        equ 2
EXLST_EXIT          equ 3

; DosExecPgm functions
EXEC_SYNC           equ 0
EXEC_ASYNC          equ 1
EXEC_ASYNCRESULT    equ 2
EXEC_TRACE          equ 3
EXEC_BACKGROUND     equ 4
EXEC_LOAD           equ 5

; Priority scopes for DosGetPrty and DosSetPrty
PRTYS_PROCESS       equ 0
PRTYS_PROCESSTREE   equ 1
PRTYS_THREAD        equ 2

; Priority classes for DosGetPrty and DosSetPrty
PRTYC_NOCHANGE      equ 0
PRTYC_IDLETIME      equ 1
PRTYC_REGULAR       equ 2
PRTYC_TIMECRITICAL  equ 3

; DosKill functions
DKP_PROCESS         equ 0
DKP_PROCESSTREE     equ 1

if1

; Process identification for @DosGetPid
PIDINFO struc
    pidi_pid        dw  ?
    pidi_tid        dw  ?
    pidi_pidParent  dw  ?
PIDINFO ends

@DosCreateThread EQU <@Macro DOSCREATETHREAD, 3, 111b>
@DosResumeThread EQU <@Macro DOSRESUMETHREAD, 1, 0b>
@DosSuspendThread EQU <@Macro DOSSUSPENDTHREAD, 1, 0b>

@DosCWait EQU <@Macro DOSCWAIT, 5, 01100b>
@DosSleep EQU <@Macro DOSSLEEP, 1, 1b>

; Result code
RESULTCODES struc
    resc_codeTerminate  dw  ?
    resc_codeResult     dw  ?
RESULTCODES ends

@DosEnterCritSec EQU <@Macro DOSENTERCRITSEC, 0>
@DosExitCritSec EQU <@Macro DOSEXITCRITSEC, 0>
@DosExitList EQU <@Macro DOSEXITLIST, 2, 10b>

@DosExecPgm EQU <@Macro DOSEXECPGM, 7, 1111001b>

@DosGetPid EQU <@Macro DOSGETPID, 1, 1b>

@DosGetPrty EQU <@Macro DOSGETPRTY, 3, 010b>
@DosSetPrty EQU <@Macro DOSSETPRTY, 4, 0000b>

@DosKillProcess EQU <@Macro DOSKILLPROCESS, 2, 00b>

endif ;  Pass 1
endif ;  INCL_DOSPROCESS

; ***************************
; *** Information Segment ***
; ***************************

ifdef INCL_DOSINFOSEG
if1

@DosGetInfoSeg EQU <@Macro DOSGETINFOSEG, 2, 11b>

; Global information segment for DosGetInfoSeg
GINFOSEG struc
    gis_time                dd  ?
    gis_msecs               dd  ?
    gis_hour                db  ?
    gis_minutes             db  ?
    gis_seconds             db  ?
    gis_hundredths          db  ?
    gis_timezone            dw  ?
    gis_cusecTimerInterval  dw  ?
    gis_day                 db  ?
    gis_month               db  ?
    gis_year                dw  ?
    gis_weekday             db  ?
    gis_uchMajorVersion     db  ?
    gis_uchMinorVersion     db  ?
    gis_chRevisionLetter    db  ?
    gis_sgCurrent           db  ?
    gis_sgMax               db  ?
    gis_cHugeShift          db  ?
    gis_fProtectModeOnly    db  ?
    gis_pidForeground       dw  ?
    gis_fDynamicSched       db  ?
    gis_csecMaxWait         db  ?
    gis_cmsecMinSlice       dw  ?
    gis_cmsecMaxSlice       dw  ?
    gis_bootdrive           dw  ?
    gis_amecRAS             db  32 dup (?)
    gis_csgWindowableVioMax db  ?
    gis_csgPMMax            db  ?
GINFOSEG ends

; Local information segment for DosGetInfoSeg
LINFOSEG struc
    lis_pidCurrent     dw  ?
    lis_pidParent      dw  ?
    lis_prtyCurrent    dw  ?
    lis_tidCurrent     dw  ?
    lis_sgCurrent      dw  ?
    lis_sgSub          dw  ?
    lis_fForeground    dw  ?
    lis_typeProcess    db  ?
    lis_dummy          db  ?
    lis_selEnvironment dw  ?
    lis_offCmdLine     dw  ?
    lis_cbDataSegment  dw  ?
    lis_cbStack        dw  ?
    lis_cbHeap         dw  ?
    lis_hmod           dw  ?
    lis_selDS          dw  ?
LINFOSEG ends

endif ;  Pass 1
endif ;  INCL_DOSINFOSEG

; ***********************
; *** File Management ***
; ***********************

ifdef INCL_DOSFILEMGR
if1

@DosOpen EQU <@Macro DOSOPEN 8, 10001111b>
@DosClose EQU <@Macro DOSCLOSE, 1, 0b>
@DosRead EQU <@Macro DOSREAD, 4, 1010b>
@DosWrite EQU <@Macro DOSWRITE, 4, 1010b>

; File status structure for DosQFileInfo
FILESTATUS struc
    fsts_fdateCreation   dw  (size FDATE)/2 dup (?)
    fsts_ftimeCreation   dw  (size FTIME)/2 dup (?)
    fsts_fdateLastAccess dw  (size FDATE)/2 dup (?)
    fsts_ftimeLastAccess dw  (size FTIME)/2 dup (?)
    fsts_fdateLastWrite  dw  (size FDATE)/2 dup (?)
    fsts_ftimeLastWrite  dw  (size FTIME)/2 dup (?)
    fsts_cbFile          dd  ?
    fsts_cbFileAlloc     dd  ?
    fsts_attrFile        dw  ?
FILESTATUS ends

; File system structure for DosQFSInfo
FSALLOCATE struc
    fsalloc_idFileSystem dd  ?
    fsalloc_cSectorUnit  dd  ?
    fsalloc_cUnit        dd  ?
    fsalloc_cUnitAvail   dd  ?
    fsalloc_cbSector     dw  ?
FSALLOCATE ends

@DosDelete EQU <@Macro DOSDELETE, 2, 11b>
@DosDupHandle EQU <@Macro DOSDUPHANDLE, 2, 10b>

@DosQFHandState EQU <@Macro DOSQFHANDSTATE, 2, 10b>
@DosSetFHandState EQU <@Macro DOSSETFHANDSTATE, 2, 00b>
@DosQHandType EQU <@Macro DOSQHANDTYPE, 2, 110b>

@DosReadAsync EQU <@Macro DOSREADASYNC, 6, 101110b>
@DosWriteAsync EQU <@Macro DOSWRITEASYNC, 6, 101110b>

@DosFindFirst EQU <@Macro DOSFINDFIRST, 7, 1101011b>
@DosFindNext EQU <@Macro DOSFINDNEXT, 4, 1010b>
@DosFindClose EQU <@Macro DOSFINDCLOSE, 1, 0b>

@DosNewSize EQU <@Macro DOSNEWSIZE, 2, 10b>
@DosBufReset EQU <@Macro DOSBUFRESET, 1, 0b>

@DosChgFilePtr EQU <@Macro DOSCHGFILEPTR, 4, 1010b>

@DosFileLocks EQU <@Macro DOSFILELOCKS, 3, 110b>

@DosMove EQU <@Macro DOSMOVE, 3, 111b>
@DosMkdir EQU <@Macro DOSMKDIR, 2, 11b>
@DosRmdir EQU <@Macro DOSRMDIR, 2, 11b>

@DosSelectDisk EQU <@Macro DOSSELECTDISK, 1, 0b>
@DosQCurDisk EQU <@Macro DOSQCURDISK, 2, 11b>

@DosChdir EQU <@Macro DOSCHDIR, 2, 11b>
@DosQCurDir EQU <@Macro DOSQCURDIR, 3, 110b>

@DosQFSInfo EQU <@Macro DOSQFSINFO, 4, 0100b>
@DosSetFSInfo EQU <@Macro DOSSETFSINFO, 4, 0100b>
@DosQVerify EQU <@Macro DOSQVERIFY, 1, 1b>
@DosSetVerify EQU <@Macro DOSSETVERIFY, 1, 0b>
@DosSetMaxFH EQU <@Macro DOSSETMAXFH, 1, 0b>

@DosQFileInfo EQU <@Macro DOSQFILEINFO, 4, 0100b>
@DosSetFileInfo EQU <@Macro DOSSETFILEINFO, 4, 0100b>

@DosQFileMode EQU <@Macro DOSQFILEMODE, 3, 111b>
@DosSetFileMode EQU <@Macro DOSSETFILEMODE, 3, 101b>

endif ;  Pass 1
endif ;  INCL_DOSFILEMGR

; *************************
; *** Memory Management ***
; *************************

ifdef INCL_DOSMEMMGR

; AllocFlags for DosAllocSeg
SEG_GIVEABLE        equ 00001h
SEG_GETTABLE        equ 00002h
SEG_DISCARDABLE     equ 00004h

if1

@DosAllocSeg EQU <@Macro DOSALLOCSEG, 3, 010b>
@DosReallocSeg EQU <@Macro DOSREALLOCSEG, 2, 00b>
@DosFreeSeg EQU <@Macro DOSFREESEG, 1, 0b>
@DosGiveSeg EQU <@Macro DOSGIVESEG, 3, 100b>
@DosGetSeg EQU <@Macro DOSGETSEG, 1, 0b>

@DosAllocHuge EQU <@Macro DOSALLOCHUGE, 5, 00100b>
@DosReallocHuge EQU <@Macro DOSREALLOCHUGE, 3, 000b>
@DosGetHugeShift EQU <@Macro DOSGETHUGESHIFT, 1, 1b>

@DosAllocShrSeg EQU <@Macro DOSALLOCSHRSEG, 3, 110b>

@DosLockSeg EQU <@Macro DOSLOCKSEG, 1, 0b>
@DosUnlockSeg EQU <@Macro DOSUNLOCKSEG, 1, 0b>

@DosGetShrSeg EQU <@Macro DOSGETSHRSEG, 2, 11b>

@DosMemAvail EQU <@Macro DOSMEMAVAIL, 1, 1b>
@DosCreateCSAlias EQU <@Macro DOSCREATECSALIAS, 2, 10b>

@DosSubAlloc EQU <@Macro DOSSUBALLOC, 3, 010b>
@DosSubFree EQU <@Macro DOSSUBFREE, 3, 000b>
@DosSubSet EQU <@Macro DOSSUBSET, 3, 000b>

endif ;  Pass 1
endif ;  INCL_DOSMEMMGR

; ******************
; *** Semaphores ***
; ******************

ifdef INCL_DOSSEMAPHORES

; Exclusive flag for DosCreateSem
CSEM_PRIVATE        equ 0
CSEM_PUBLIC         equ 1

if1

@DosSemClear EQU <@Macro DOSSEMCLEAR, 1, 1b>
@DosSemSet EQU <@Macro DOSSEMSET, 1, 1b>
@DosSemWait EQU <@Macro DOSSEMWAIT, 2, 11b>
@DosSemSetWait EQU <@Macro DOSSEMSETWAIT, 2, 11b>
@DosSemRequest EQU <@Macro DOSSEMREQUEST, 2, 11b>

@DosCreateSem EQU <@Macro DOSCREATESEM, 3, 110b>

@DosOpenSem EQU <@Macro DOSOPENSEM, 2, 11b>
@DosCloseSem EQU <@Macro DOSCLOSESEM, 1, 1b>

@DosMuxSemWait EQU <@Macro DOSMUXSEMWAIT, 3, 111b>

; List address structure for DosMuxSemWait
MUXSEM  struc
    mxs_zero        dw  ?
    mxs_hsem        dd  ?
MUXSEM  ends

; Structure within MUXSEM
MUXSEMLIST struc
    mxsl_cmxs       dw  ?
    mxsl_amxs       dw  (size MUXSEM)/2 * 16 dup (?)
MUXSEMLIST ends

endif ;  Pass 1
endif ;  INCL_DOSSEMAPHORES

; *********************
; *** Date and Time ***
; *********************

ifdef INCL_DOSDATETIME
if1

@DosGetDateTime EQU <@Macro DOSGETDATETIME, 1, 1b>
@DosSetDateTime EQU <@Macro DOSSETDATETIME, 1, 1b>

; Structure for DosGetDateTime and DosSetDateTime
DATETIME struc
    date_hours      db  ?
    date_minutes    db  ?
    date_seconds    db  ?
    date_hundredths db  ?
    date_day        db  ?
    date_month      db  ?
    date_year       dw  ?
    date_timezone   dw  ?
    date_weekday    db  ?
DATETIME ends

@DosTimerAsync EQU <@Macro DOSTIMERASYNC, 3, 111b>
@DosTimerStart EQU <@Macro DOSTIMERSTART, 3, 111b>
@DosTimerStop EQU <@Macro DOSTIMERSTOP, 1, 0b>

endif ;  Pass 1
endif ;  INCL_DOSDATETIME

; *************************
; *** Module Management ***
; *************************

ifdef INCL_DOSMODULEMGR
if1

@DosLoadModule EQU <@Macro DOSLOADMODULE, 4, 1101b>
@DosFreeModule EQU <@Macro DOSFREEMODULE, 1, 0b>
@DosGetProcAddr EQU <@Macro DOSGETPROCADDR, 3, 110b>
@DosGetModHandle EQU <@Macro DOSGETMODHANDLE, 2, 11b>
@DosGetModName EQU <@Macro DOSGETMODNAME, 3, 100b>

endif ;  Pass 1
endif ;  INCL_DOSMODULEMGR

; Predefined resource types
RT_POINTER          equ 1
RT_BITMAP           equ 2
RT_MENU             equ 3
RT_DIALOG           equ 4
RT_STRING           equ 5
RT_FONTDIR          equ 6
RT_FONT             equ 7
RT_ACCELTABLE       equ 8
RT_RCDATA           equ 9
RT_MESSAGE          equ 10
RT_DLGINCLUDE       equ 11
RT_VKEYTBL          equ 12
RT_KEYTBL           equ 13
RT_CHARTBL          equ 14

; ***************************
; *** Resource Management ***
; ***************************

ifdef INCL_DOSRESOURCES
if1

@DosGetResource EQU <@Macro DOSGETRESOURCE, 4, 1000b>

endif ;  Pass 1
endif ;  INCL_DOSRESOURCES

; *********************************
; *** National Language Support ***
; *********************************

ifdef INCL_DOSNLS
if1

@DosGetCtryInfo EQU <@Macro DOSGETCTRYINFO, 4, 1110b>
@DosGetDBCSEv EQU <@Macro DOSGETDBCSEV, 3, 110b>
@DosCaseMap EQU <@Macro DOSCASEMAP, 3, 110b>
@DosGetCollate EQU <@Macro DOSGETCOLLATE, 4, 1110b>
@DosGetCp EQU <@Macro DOSGETCP, 3, 110b>
@DosSetCp EQU <@Macro DOSSETCP, 2, 00b>

; Code for DosGetDBCSEv, DosCaseMap, and DosGetCollate
COUNTRYCODE struc
    ctryc_country   dw  ?
    ctryc_codepage  dw  ?
COUNTRYCODE ends

; Information for DosGetCtryInfo
COUNTRYINFO struc
    ctryi_country              dw  ?
    ctryi_codepage             dw  ?
    ctryi_fsDateFmt            dw  ?
    ctryi_szCurrency           db  5 dup (?)
    ctryi_szThousandsSeparator db  2 dup (?)
    ctryi_szDecimal            db  2 dup (?)
    ctryi_szDateSeparator      db  2 dup (?)
    ctryi_szTimeSeparator      db  2 dup (?)
    ctryi_fsCurrencyFmt        db  ?
    ctryi_cDecimalPlace        db  ?
    ctryi_fsTimeFmt            db  ?
    ctryi_abReserved1          dw  2 dup (?)
    ctryi_szDataSeparator      db  2 dup (?)
    ctryi_abReserved2          dw  5 dup (?)
COUNTRYINFO ends

endif ;  Pass 1
endif ;  INCL_DOSNLS   

; ***************
; *** Signals ***
; ***************

ifdef INCL_DOSSIGNALS

; Signal numbers for DosSetSigHandler
SIG_CTRLC           equ 1
SIG_BROKENPIPE      equ 2
SIG_KILLPROCESS     equ 3
SIG_CTRLBREAK       equ 4
SIG_PFLG_A          equ 5
SIG_PFLG_B          equ 6
SIG_PFLG_C          equ 7
SIG_CSIGNALS        equ 8

; Signal actions for DosSetSigHandler
SIGA_KILL           equ 0
SIGA_IGNORE         equ 1
SIGA_ACCEPT         equ 2
SIGA_ERROR          equ 3
SIGA_ACKNOWLEDGE    equ 4

; Action codes DosFlagProcess
FLGP_SUBTREE        equ 0
FLGP_PID            equ 1

; Flag numbers for DosFlagProcess
PFLG_A              equ 0
PFLG_B              equ 1
PFLG_C              equ 2

; Action codes for DosHoldSignal
HLDSIG_ENABLE       equ 0
HLDSIG_DISABLE      equ 1

if1

@DosSetSigHandler EQU <@Macro DOSSETSIGHANDLER, 5, 00111b>

@DosFlagProcess EQU <@Macro DOSFLAGPROCESS, 4, 0000b>

@DosHoldSignal EQU <@Macro DOSHOLDSIGNAL, 1, 0b>
@DosSendSignal EQU <@Macro DOSSENDSIGNAL, 2, 00b>

endif ;  Pass 1
endif ;  INCL_DOSSIGNALS   

; ****************
; *** Monitors ***
; ****************

ifdef INCL_DOSMONITORS
if1

@DosMonOpen EQU <@Macro DOSMONOPEN, 2, 11b>
@DosMonClose EQU <@Macro DOSMONCLOSE, 1, 0b>
@DosMonReg EQU <@Macro DOSMONREG, 5, 00110b>
@DosMonRead EQU <@Macro DOSMONREAD, 4, 1101b>
@DosMonWrite EQU <@Macro DOSMONWRITE, 3, 011b>

endif ;  Pass 1
endif ;  INCL_DOSMONITORS   

; **************
; *** Queues ***
; **************

ifdef INCL_DOSQUEUES
if1

@DosMakePipe EQU <@Macro DOSMAKEPIPE, 3, 011b>
@DosCloseQueue EQU <@Macro DOSCLOSEQUEUE, 1, 0b>
@DosCreateQueue EQU <@Macro DOSCREATEQUEUE, 3, 101b>
@DosOpenQueue EQU <@Macro DOSOPENQUEUE, 3, 111b>
@DosPeekQueue EQU <@Macro DOSPEEKQUEUE, 8, 11011110b>
@DosPurgeQueue EQU <@Macro DOSPURGEQUEUE, 1, 0b>
@DosQueryQueue EQU <@Macro DOSQUERYQUEUE, 2, 10b>
@DosReadQueue EQU <@Macro DOSREADQUEUE, 8, 11001110b>
@DosWriteQueue EQU <@Macro DOSWRITEQUEUE, 5, 01000b>

endif ;  Pass 1
endif ;  INCL_DOSQUEUES

; ******************************
; *** Miscellaneous Services ***
; ******************************

ifdef INCL_DOSMISC
if1

@DosError EQU <@Macro DOSERROR, 1, 0b>
@DosSetVec EQU <@Macro DOSSETVEC, 3, 110b>
@DosGetMessage EQU <@Macro DOSGETMESSAGE, 7, 1100101b>
@DosErrClass EQU <@Macro DOSERRCLASS, 4, 1110b>
@DosInsMessage EQU <@Macro DOSINSMESSAGE, 7, 1010101b>
@DosPutMessage EQU <@Macro DOSPUTMESSAGE, 3, 100b>
@DosGetEnv EQU <@Macro DOSGETENV, 2, 11b>
@DosScanEnv EQU <@Macro DOSSCANENV, 2, 11b>
@DosSearchPath EQU <@Macro DOSSEARCHPATH, 5, 01110b>
@DosGetVersion EQU <@Macro DOSGETVERSION, 1, 1b>
@DosGetMachineMode EQU <@Macro DOSGETMACHINEMODE, 1, 1b>

endif ;  Pass 1
endif ;  INCL_DOSMISC

; **************************
; *** Session Management ***
; **************************

ifdef INCL_DOSSESMGR
if1

@DosStartSession EQU <@Macro DOSSTARTSESSION, 3, 111b>
@DosSetSession EQU <@Macro DOSSETSESSION, 2, 10b>
@DosSelectSession EQU <@Macro DOSSELECTSESSION, 2, 10b>
@DosStopSession EQU <@Macro DOSSTOPSESSION, 3, 100b>

; Information for DosStartSession
STARTDATA struc
    stdata_cb         dw  ?
    stdata_Related    dw  ?
    stdata_FgBg       dw  ?
    stdata_TraceOpt   dw  ?
    stdata_PgmTitle   dd  ?
    stdata_PgmName    dd  ?
    stdata_PgmInputs  dd  ?
    stdata_TermQ      dd  ?
STARTDATA ends

; Information for DosSetSession
STATUSDATA struc
    stsdata_cb        dw  ?
    stsdata_SelectInd dw  ?
    stsdata_BindInd   dw  ?
STATUSDATA ends

endif ;  Pass 1
endif ;  INCL_DOSSESMGR   

; **********************
; *** Device Control ***
; **********************

ifdef INCL_DOSDEVICES
if1

@DosDevConfig EQU <@Macro DOSDEVCONFIG, 3, 001b>
@DosDevIOCtl EQU <@Macro DOSDEVIOCTL, 5, 00011b>
@DosSystemService EQU <@Macro DOSSYSTEMSERVICE, 3, 110b>

@DosCLIAccess EQU <@Macro DOSCLIACCESS, 0>
@DosPortAccess EQU <@Macro DOSPORTACCESS, 4, 0000b>
@DosPhysicalDisk EQU <@Macro DOSPHYSICALDISK, 5, 01010b>

endif ;  Pass 1
endif ;  INCL_DOSDEVICES   
