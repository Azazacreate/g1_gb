/***************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S 

                Name mappings necessary for IBM C Set/2 compiler

 FileName: IBMMAP.H
 PURPOSE: Define identifier and function names with preceding underscores
 VERSION: opsys == OS2 && memmodel == MLINEAR && c_compiler == ibmc

 อออออออออออออออหออออออหออออออออออออออออออออออออออออออออออออออออออออออออออออ
  Date Modified,บ By,  บ  Comments.
 อออออออออออออออฮออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออ
    07/02/95    บ SPB  บ Added support for CONV_s_l_xxx
    15/06/95    บSPB054บ 950615.01 Reduce sources
    03/08/95    บSPB065บ 950730.10 New standart predicate
    22/08/95    บSPB067บ 941213.12 New compression predicates for binary
    29/09/95    บSPB095บ 950926.02 Additional predicates for calculating CRC
    10/10/95    บSPB099บ 951009.27 Remove predicates getports / freeports
    16/01/96    บSPB129บ 960113.15 COMPILER.LIB for OS/2
    14/02/96    บSPB138บ 960113.01 Sockets support
    15/02/96    บSPB139บ 960215.01 Linking with IBM C library
    01/03/96    บSPB145บ Inner Linking with PROLOG.LIB for IBM C again
    01/05/96    บSPB000บ FNM_ReducePath_iio moved from #ifdef UI
    22/05/96    บSPB166บ R960522.01 Test goal is missed under OS/2
    10/06/96    บSPB000บ PASS_CheckGlobalDomains
    17/06/96    บSPB171บ R960610.01 Error in sockets read by modem
    18/07/96    บSPB180บ R960709.01 unable to realize FTP & TCP/IP using existing sockets predicates
    23/07/96    บSPB051บ 950425.01 Avoid C libraries
    24/07/96	บSPB000บ Inner: OOP development
    29/07/96	บSPB000บ Inner: make some tools visible
    02/08/96	บSPB183บ R960802.01 Unresolved reference in configload()
    21/08/96	บSPB000บ New predicate created via K.Ivanov's request
    03/09/96    บSPB000บ Add ability to get full socket name
    04/09/96	บSPB000บ New module
    06/09/96    บSPB000บ Add new predicate socket_GetRealSocket
    25/09/96    บSPB000บ Remove file runctrap.asm
    03/10/96    บSPB202บ Inner: PIPES problems after Dan Ole
    05/10/96	บSPB203บ R960505.01 Remove str_long() & system2()
    07/10/96	บSPB208บ D960702.06 copyfile() & valid closing files
    24/10/96	บSPB217บ 950123.08 Put last runtime error to clipboard
    14/11/96    บSPB000บ addded get and set time predicate
    28/11/96    บSPB000บ addded MEM_MarkGStack & MEM_ReleaseGStack
    03/12/96    บSPB000บ added pdcrunt.h into libutil.pre
    04/01/97	บSPB244บ R970104.01 Need to obtain IO_Vars.konsolinput (EasyWin)
    05/01/97	บSPB245บ R961231. New predicates: socket_SendInt & socket_GetHostByAddr()
    02/05/97    บSPB283บ D961111.10 support difftime predicates for all platforms
    06/05/97    บSPB000บ Inner : added MEM_ReleaseStringHeap
    25/04/97	บSPB280บ R970425.01 New built-in predicate errorexit/1 & /0
    10/09/97	บSPB000บ add PDC_GetLibraryVersion
    01/10/97	บSPB351บ R971001.05 Invalid handling of global predicates in TestGoal
    12/10/97	บSPB000บ Inner: add routine to obtain the Compiler's version
    15/10/97	บSPB000บ Inner: unresolved references for TestGoal under OS/2
    06/11/97    บSPB000บ Inner: add PFP_ClearExceptionFlags
    11/11/97    บSPB000บ Inner : add reset FPU procedure & delete some errors
    21/01/98	บSPB393บ Inner: New classes
    27/01/98	บSPB000บ Inner: add new names in PTD
    15/02/98	บSPB000บ Inner: suport new cursor
                บ      บ
***************************************************************************/

#if defined(UNDERSCORES)

/* SPB166 begin */
/*#if !defined(complib_version)
  #define complib_version LIB
#endif*/
/* SPB166 end */

#pragma map(PSTR_con_ioi,"_PSTR_con_ioi")
#pragma map(PSTR_str_l_ii,"_PSTR_str_l_ii")
#pragma map(PSTR_fr_tok_iio,"_PSTR_fr_tok_iio")
#pragma map(PSTR_SearchStr,"_PSTR_SearchStr")
#pragma map(PSTR_con_oii,"_PSTR_con_oii")
#pragma map(PSTR_fr_tok_ioi,"_PSTR_fr_tok_ioi")
#pragma map(PSTR_SubChar,"_PSTR_SubChar")
#pragma map(PSTR_con_iii,"_PSTR_con_iii")
#pragma map(PSTR_ft_ioo,"_PSTR_ft_ioo")
#pragma map(PSTR_ft_iio,"_PSTR_ft_iio")
#pragma map(PSTR_con_iio,"_PSTR_con_iio")
#pragma map(PSTR_ft_ioi,"_PSTR_ft_ioi")
#pragma map(PSTR_ft_iii,"_PSTR_ft_iii")
#pragma map(PSTR_ft_oii,"_PSTR_ft_oii")
#pragma map(PSTR_fr_str,"_PSTR_fr_str")
#pragma map(PSTR_fr_tok_iii,"_PSTR_fr_tok_iii")
#pragma map(PSTR_is_name,"_PSTR_is_name")
#pragma map(PSTR_fr_tok_oii,"_PSTR_fr_tok_oii")
#pragma map(PSTR_str_l_io,"_PSTR_str_l_io")
#pragma map(PSTR_str_l_oi,"_PSTR_str_l_oi")
#pragma map(PSTR_SearchChar,"_PSTR_SearchChar")
#pragma map(PSTR_SubStr,"_PSTR_SubStr")
#pragma map(PSTR_fr_tok_ioo,"_PSTR_fr_tok_ioo")
#pragma map(HASH_SymbRoot,"_HASH_SymbRoot")
#pragma map(HASH_GlobSymbPtr,"_HASH_GlobSymbPtr")
#pragma map(HASH_Init,"_HASH_Init")
#pragma map(HASH_Print,"_HASH_Print")
#pragma map(HASH_GetKeyW,"_HASH_GetKeyW")
#pragma map(HASH_BinInsert,"_HASH_BinInsert")
#pragma map(HASH_BinLookup,"_HASH_BinLookup")
#pragma map(HASH_DynDelKey,"_HASH_DynDelKey")
#pragma map(HASH_DynInsert,"_HASH_DynInsert")
#pragma map(HASH_DynLookup,"_HASH_DynLookup")
#pragma map(CONV_s_r_oi,"_CONV_s_r_oi")
#pragma map(CONV_s_r_io,"_CONV_s_r_io")
#pragma map(CONV_up_low_io,"_CONV_up_low_io")
#pragma map(CONV_up_low_ii,"_CONV_up_low_ii")
#pragma map(CONV_s_i_oi,"_CONV_s_i_oi")
#pragma map(CONV_s_l_oi,"_CONV_s_l_oi")
#pragma map(CONV_s_l_io,"_CONV_s_l_io")
#pragma map(CONV_s_l_ii,"_CONV_s_l_ii")
/* SPB065 */
#pragma map(CONV_str_DOSstr_oi,"_CONV_str_DOSstr_oi")
#pragma map(CONV_Str_Ref_io,"_CONV_Str_Ref_io")
#pragma map(CONV_up_low_oi,"_CONV_up_low_oi")
#pragma map(CONV_s_i_io,"_CONV_s_i_io")
/* SPB065 */
#pragma map(CONV_str_DOSstr_io,"_CONV_str_DOSstr_io")
#pragma map(CONV_LongHexToStr,"_CONV_LongHexToStr")
#pragma map(CONV_c_i_ii,"_CONV_c_i_ii")
#pragma map(CONV_c_i_oi,"_CONV_c_i_oi")
#pragma map(CONV_c_i_io,"_CONV_c_i_io")
#pragma map(CONV_s_c_ii,"_CONV_s_c_ii")
#pragma map(CONV_s_c_oi,"_CONV_s_c_oi")
#pragma map(CONV_s_c_io,"_CONV_s_c_io")
#pragma map(CONV_UnsignedToStr,"_CONV_UnsignedToStr")
#pragma map(CONV_IntToStr,"_CONV_IntToStr")
#pragma map(CONV_HexChar,"_CONV_HexChar")
#pragma map(CONV_Str_Ref_ii,"_CONV_Str_Ref_ii")
#pragma map(CONV_s_r_ii,"_CONV_s_r_ii")
#pragma map(CONV_r_ints_oi,"_CONV_r_ints_oi")
#pragma map(CONV_UpLowCh_oi,"_CONV_UpLowCh_oi")
#pragma map(CONV_UpLowCh_io,"_CONV_UpLowCh_io")
#pragma map(CONV_UpLowCh_ii,"_CONV_UpLowCh_ii")
#pragma map(CONV_s_i_ii,"_CONV_s_i_ii")
/* SPB065 */
#pragma map(CONV_str_DOSstr_ii,"_CONV_str_DOSstr_ii")
#pragma map(CONV_r_ints_io,"_CONV_r_ints_io")
#pragma map(CONV_BinText,"_CONV_BinText")
#pragma map(CONV_TextBin,"_CONV_TextBin")
#pragma map(CONV_BinToStr,"_CONV_BinToStr")
#pragma map(CONV_Str_Ref_oi,"_CONV_Str_Ref_oi")
/* SPB183 #pragma map(UI_Vars,"_UI_Vars")*/
/* SPB183 #pragma map(UI_CfgSave,"_UI_CfgSave") */
/* #pragma map(UI_CfgLoad,"_UI_CfgLoad") SPB054 */
#pragma map(DB_RefReplace,"_DB_RefReplace")
#pragma map(DB_DbaseReplace,"_DB_DbaseReplace")
#pragma map(DB_KeyDelete,"_DB_KeyDelete")
#pragma map(DB_KeyLast,"_DB_KeyLast")
#pragma map(DB_KeyPrev,"_DB_KeyPrev")
#pragma map(DB_ChainInsertz,"_DB_ChainInsertz")
#pragma map(DB_Insertz,"_DB_Insertz")
#pragma map(DB_RefBin,"_DB_RefBin")
#pragma map(DB_ChainTerms,"_DB_ChainTerms")
#pragma map(DB_RefTerm,"_DB_RefTerm")
#pragma map(DB_BTrees,"_DB_BTrees")
#pragma map(DB_Chains,"_DB_Chains")
#pragma map(DB_GarbageCollect,"_DB_GarbageCollect")
#pragma map(DB_dba_garbage,"_DB_dba_garbage")
#pragma map(DB_ChainInserta,"_DB_ChainInserta")
#pragma map(DB_Inserta,"_DB_Inserta")
#pragma map(DB_BtCreate5,"_DB_BtCreate5")
#pragma map(DB_BtCreate6,"_DB_BtCreate6")
#pragma map(DB_Flush,"_DB_Flush")
#pragma map(DB_Delete,"_DB_Delete")
#pragma map(DB_Close,"_DB_Close")
#pragma map(DB_release_descriptors,"_DB_release_descriptors")
#pragma map(DB_dbase_flush,"_DB_dbase_flush")
#pragma map(DB_BtUpdated,"_DB_BtUpdated")
#pragma map(DB_Updated,"_DB_Updated")
#pragma map(DB_NoOfDBInAbove,"_DB_NoOfDBInAbove")
#pragma map(DB_GlobalEMSFreelists,"_DB_GlobalEMSFreelists")
#pragma map(DB_NoOfDbSel,"_DB_NoOfDbSel")
#pragma map(DB_MemBases,"_DB_MemBases")
#pragma map(DB_Initialized,"_DB_Initialized")
#pragma map(DB_FDesArr,"_DB_FDesArr")
#pragma map(DB_End,"_DB_End")
#pragma map(DB_Init,"_DB_Init")
#pragma map(DB_Statistics,"_DB_Statistics")
#pragma map(DB_ChainDelete,"_DB_ChainDelete")
#pragma map(DB_TermDelete,"_DB_TermDelete")
#pragma map(DB_ChainPrev,"_DB_ChainPrev")
#pragma map(DB_ChainNext,"_DB_ChainNext")
#pragma map(DB_ChainLast,"_DB_ChainLast")
#pragma map(DB_ChainFirst,"_DB_ChainFirst")
#pragma map(DB_dbase_first,"_DB_dbase_first")
#pragma map(DB_dbase_next,"_DB_dbase_next")
#pragma map(DB_Copy,"_DB_Copy")
#pragma map(DB_KeyCurrent,"_DB_KeyCurrent")
#pragma map(DB_SetRetry,"_DB_SetRetry")
#pragma map(DB_ReUseRef,"_DB_ReUseRef")
#pragma map(DB_BtOpen,"_DB_BtOpen")
#pragma map(DB_ChainInsertAfter,"_DB_ChainInsertAfter")
#pragma map(DB_InsertAfter,"_DB_InsertAfter")
#pragma map(DB_remove_index,"_DB_remove_index")
#pragma map(DB_GetIdes,"_DB_GetIdes")
#pragma map(DB_ItemCmp,"_DB_ItemCmp")
#pragma map(DB_XKey,"_DB_XKey")
#pragma map(DB_ReleasePage,"_DB_ReleasePage")
#pragma map(DB_AllocPage,"_DB_AllocPage")
#pragma map(DB_SavePage,"_DB_SavePage")
#pragma map(DB_LoadPageBuf,"_DB_LoadPageBuf")
#pragma map(DB_LoadPage,"_DB_LoadPage")
#pragma map(DB_KeyFirst,"_DB_KeyFirst")
#pragma map(DB_KeyNext,"_DB_KeyNext")
#pragma map(DB_KeyInsert,"_DB_KeyInsert")
#pragma map(DB_BtCopySelector,"_DB_BtCopySelector")
#pragma map(DB_reg_dbaseupdated,"_DB_reg_dbaseupdated")
#pragma map(DB_getfdes,"_DB_getfdes")
#pragma map(DB_dbase_init,"_DB_dbase_init")
#pragma map(DB_remove_memdbase,"_DB_remove_memdbase")
#pragma map(DB_ins_memdbase,"_DB_ins_memdbase")
#pragma map(DB_lookup_memdbase,"_DB_lookup_memdbase")
#pragma map(DB_lookup_entry,"_DB_lookup_entry")
#pragma map(DB_delete_dbaseref,"_DB_delete_dbaseref")
#pragma map(DB_change_dbaseref,"_DB_change_dbaseref")
#pragma map(DB_lookup_dbaseref,"_DB_lookup_dbaseref")
#pragma map(DB_alloc_dbaseref,"_DB_alloc_dbaseref")
#pragma map(DB_alloc_dbase,"_DB_alloc_dbase")
#pragma map(DB_release_dbase,"_DB_release_dbase")
#pragma map(DB_seek_wrbin,"_DB_seek_wrbin")
#pragma map(DB_wrbin,"_DB_wrbin")
#pragma map(DB_seek_rdbin,"_DB_seek_rdbin")
#pragma map(DB_rdbin,"_DB_rdbin")
#pragma map(DB_BtClose,"_DB_BtClose")
#pragma map(DB_BtDelete,"_DB_BtDelete")
#pragma map(DB_KeySearch_i,"_DB_KeySearch_i")
#pragma map(DB_KeySearch_o,"_DB_KeySearch_o")
#pragma map(DB_EndTransaction,"_DB_EndTransaction")
#pragma map(DB_BeginTransaction,"_DB_BeginTransaction")
#pragma map(DB_BtStatistics,"_DB_BtStatistics")
#pragma map(DB_Create,"_DB_Create")
#pragma map(DB_OpenShare,"_DB_OpenShare")
#pragma map(DB_OpenInvalid,"_DB_OpenInvalid")
#pragma map(DB_Open,"_DB_Open")
#pragma map(DB_set_nameanddisk,"_DB_set_nameanddisk")
#pragma map(LANG_NoFiles,"_LANG_NoFiles")
#pragma map(LANG_Directory,"_LANG_Directory")
#pragma map(LANG_YESCH,"_LANG_YESCH")
#pragma map(LANG_areyousure,"_LANG_areyousure")
#pragma map(LANG_returnstr,"_LANG_returnstr")
#pragma map(LANG_overwriteok,"_LANG_overwriteok")
#pragma map(LANG_savetext,"_LANG_savetext")
#pragma map(LANG_makenew,"_LANG_makenew")
#pragma map(LANG_filemask,"_LANG_filemask")
#pragma map(LANG_filename,"_LANG_filename")
#pragma map(LANG_NO,"_LANG_NO")
#pragma map(LANG_YES,"_LANG_YES")
#pragma map(LANG_OFF,"_LANG_OFF")
#pragma map(LANG_ON,"_LANG_ON")
#pragma map(IO_FileMode_o,"_IO_FileMode_o")
#pragma map(IO_WrDev_i,"_IO_WrDev_i")
#pragma map(IO_RdFile,"_IO_RdFile")
#pragma map(IO_RdReal,"_IO_RdReal")
#pragma map(IO_WrRealTC,"_IO_WrRealTC")
#pragma map(IO_RdDev_i,"_IO_RdDev_i")
#pragma map(IO_FSeek_i,"_IO_FSeek_i")
#pragma map(IO_IsDevName,"_IO_IsDevName")
#pragma map(IO_GetPath,"_IO_GetPath")
#pragma map(IO_Disk_i,"_IO_Disk_i")
#pragma map(IO_RdIntg,"_IO_RdIntg")
#pragma map(IO_WrULong,"_IO_WrULong")
#pragma map(IO_WrLong,"_IO_WrLong")
#pragma map(IO_End,"_IO_End")
#pragma map(IO_init_pr_files,"_IO_init_pr_files")
#pragma map(IO_Close,"_IO_Close")
#pragma map(IO_CloseFile,"_IO_CloseFile")
#pragma map(IO_SetPath,"_IO_SetPath")
#pragma map(IO_RdBlock,"_IO_RdBlock")
#pragma map(IO_RdLine,"_IO_RdLine")
#pragma map(IO_RdLinePrompt,"_IO_RdLinePrompt")
#pragma map(IO_LoadLineBuf,"_IO_LoadLineBuf")
#pragma map(IO_Flush,"_IO_Flush")
#pragma map(IO_FlushBuf,"_IO_FlushBuf")
#pragma map(IO_SetFileSize,"_IO_SetFileSize")
#pragma map(IO_RdDev_o,"_IO_RdDev_o")
#pragma map(IO_WrReal,"_IO_WrReal")
#pragma map(IO_WrUShort,"_IO_WrUShort")
#pragma map(IO_WrIntg,"_IO_WrIntg")
#pragma map(IO_WrShort,"_IO_WrShort")
#pragma map(IO_WrUByte,"_IO_WrUByte")
#pragma map(IO_WrSByte,"_IO_WrSByte")
#pragma map(IO_FSeek_o,"_IO_FSeek_o")
#pragma map(IO_DiskSpace,"_IO_DiskSpace")
#pragma map(IO_WrBlockBin,"_IO_WrBlockBin")
#pragma map(IO_WrBlock,"_IO_WrBlock")
/* SPB208###*/
#pragma map(IO_MapFHand,"_IO_MapFHand")
#pragma map(IO_MapFSel,"_IO_MapFSel")
/*###*/
#pragma map(IO_Nl,"_IO_Nl")
#pragma map(IO_Disk_o,"_IO_Disk_o")
#pragma map(IO_WrCh,"_IO_WrCh")
#pragma map(IO_WrStr,"_IO_WrStr")

/* SPB139 begin */
#pragma map(IO_WrChCon,"_IO_WrChCon")
#pragma map(IO_WrStrCon,"_IO_WrStrCon")
/* SPB139 end */

#pragma map(IO_PutStr,"_IO_PutStr")
#pragma map(IO_PutCh,"_IO_PutCh")
#pragma map(IO_WrDev_o,"_IO_WrDev_o")
#pragma map(IO_WrProcAddr,"_IO_WrProcAddr")
#pragma map(IO_WrRef,"_IO_WrRef")
#pragma map(IO_RdCh,"_IO_RdCh")
#pragma map(IO_GetCh,"_IO_GetCh")
#pragma map(IO_FillReadBuf,"_IO_FillReadBuf")
#pragma map(IO_Eof,"_IO_Eof")
#pragma map(IO_Exist,"_IO_Exist")
#pragma map(IO_FileMode_i,"_IO_FileMode_i")
#pragma map(IO_getln,"_IO_getln")
#pragma map(IO_SystemPF,"_IO_SystemPF")
#pragma map(IO_Vars,"_IO_Vars")
#pragma map(IO_Init,"_IO_Init")
#pragma map(IO_IsConsoleInput,"_IO_IsConsoleInput")	/* SPB244 */
#pragma map(IO_FileBin_io,"_IO_FileBin_io")
#pragma map(IO_SPrintf,"_IO_SPrintf")
#pragma map(IO_VSPrintf,"_IO_VSPrintf")
#pragma map(IO_Writef,"_IO_Writef")
#pragma map(IO_WritefDisplaced,"_IO_WritefDisplaced")
#pragma map(IO_FormatEnd,"_IO_FormatEnd")
#pragma map(IO_Format,"_IO_Format")
#pragma map(IO_FormatInit,"_IO_FormatInit")
#pragma map(IO_WritefDom,"_IO_WritefDom")
#pragma map(IO_WritefInit,"_IO_WritefInit")
#pragma map(IO_FileBin_ii,"_IO_FileBin_ii")
#pragma map(IO_WrPrinter,"_IO_WrPrinter")
#pragma map(IO_WrFile,"_IO_WrFile")
#pragma map(IO_O_Mod,"_IO_O_Mod")
#pragma map(IO_O_App,"_IO_O_App")
#pragma map(IO_O_Write,"_IO_O_Write")
#pragma map(IO_O_Read,"_IO_O_Read")
#pragma map(IO_Open,"_IO_Open")
#pragma map(IO_WrBinary,"_IO_WrBinary")
#pragma map(INTG_Abs,"_INTG_Abs")
#pragma map(INTG_Random,"_INTG_Random")
#pragma map(LONG_RandomReInit,"_LONG_RandomReInit")
#pragma map(DIR_FindFiles,"_DIR_FindFiles")
#pragma map(DIR_FindClose,"_DIR_FindClose")
#pragma map(DIR_FindMatch,"_DIR_FindMatch")
#pragma map(DIR_FindOpen,"_DIR_FindOpen")
#pragma map(DIR_SetFAttr,"_DIR_SetFAttr")
#pragma map(DIR_GetFAttr,"_DIR_GetFAttr")
#pragma map(CH_toupper,"_CH_toupper")
#pragma map(CH_ClassTab,"_CH_ClassTab")
#pragma map(CH_IbmHi,"_CH_IbmHi")
#pragma map(CH_IbmLo,"_CH_IbmLo")
#pragma map(CH_tolower,"_CH_tolower")
#pragma map(FNM_Unique,"_FNM_Unique")
#pragma map(FNM_SearchFile_iio,"_FNM_SearchFile_iio")
#pragma map(FNM_SearchFile,"_FNM_SearchFile")
#pragma map(FNM_Unique_o,"_FNM_Unique_o")
#pragma map(FNM_FileNameExt_oii,"_FNM_FileNameExt_oii")
#pragma map(FNM_FileNameExt_ioo,"_FNM_FileNameExt_ioo")
#pragma map(FNM_FileNamePath_oii,"_FNM_FileNamePath_oii")
#pragma map(FNM_FileNamePath_ioo,"_FNM_FileNamePath_ioo")
#pragma map(FNM_GetExt,"_FNM_GetExt")
#pragma map(FNM_RemovePathAndExt,"_FNM_RemovePathAndExt")
#pragma map(FNM_DefExt,"_FNM_DefExt")
#pragma map(FNM_SeeExt,"_FNM_SeeExt")
#pragma map(FNM_NewFileExt,"_FNM_NewFileExt")
#pragma map(FNM_RemoveExt,"_FNM_RemoveExt")
#pragma map(FNM_RemovePath,"_FNM_RemovePath")
#pragma map(FNM_RemoveFileMask,"_FNM_RemoveFileMask")
#pragma map(FNM_SplitCatSpec,"_FNM_SplitCatSpec")
#pragma map(FNM_BuildFullFName,"_FNM_BuildFullFName")
#pragma map(FNM_BuildExtFName,"_FNM_BuildExtFName")
#pragma map(FNM_Reduce,"_FNM_Reduce")
#pragma map(FNM_RemoveSlash,"_FNM_RemoveSlash")
#pragma map(FNM_AddSlash,"_FNM_AddSlash")
#pragma map(FNM_Decrement,"_FNM_Decrement")
#pragma map(FNM_UniqueCat,"_FNM_UniqueCat")
#pragma map(RUN_Storage,"_RUN_Storage")
#pragma map(RUN_PrintStorage,"_RUN_PrintStorage")
#pragma map(RUN_ErrorFlag,"_RUN_ErrorFlag")
#pragma map(RUN_ExitCode,"_RUN_ExitCode")
#pragma map(RUN_SaveStack,"_RUN_SaveStack")
#pragma map(RUN_MaxTTop,"_RUN_MaxTTop")
#pragma map(RUN_TTop,"_RUN_TTop")
#pragma map(RUN_Trail,"_RUN_Trail")
#pragma map(RUN_TrapTop,"_RUN_TrapTop")
#pragma map(RUN_BTop,"_RUN_BTop")
#pragma map(RUN_Main,"_RUN_Main")
#pragma map(RUN_End,"_RUN_End")
#pragma map(RUN_Init,"_RUN_Init")
#pragma map(RUN_InstallModule,"_RUN_InstallModule")
#pragma map(RUN_ExitZero,"_RUN_ExitZero")
#pragma map(RUN_Error,"_RUN_Error")
#pragma map(RUN_ErrorCont,"_RUN_ErrorCont")
#pragma map(RUN_Exit,"_RUN_Exit")
#pragma map(RUN_AppType,"_RUN_AppType")
#pragma map(RUN_GetApp,"_RUN_GetApp")
#pragma map(RUN_Storage_11,"_RUN_Storage_11")
#pragma map(RUN_ExceptionsHandling_i,"_RUN_ExceptionsHandling_i")
#pragma map(RUN_ExceptionsHandling_o,"_RUN_ExceptionsHandling_o")
#pragma map(RUN_GetExitCode, "_RUN_GetExitCode" )
#pragma map(RUN_GetErrorFlag, "_RUN_GetErrorFlag" )
#pragma map(OS_Time_iiii,"_OS_Time_iiii")
#pragma map(OS_GetEnvSymb,"_OS_GetEnvSymb")
#pragma map(OS_EnvSymb,"_OS_EnvSymb")
#pragma map(OS_Time_oooo,"_OS_Time_oooo")
#pragma map(OS_FUnlock,"_OS_FUnlock")
#pragma map(OS_FLock,"_OS_FLock")
#pragma map(OS_Close,"_OS_Close")
#pragma map(OS_ReadText,"_OS_ReadText")
/* SPB099
#pragma map(OS_FreePorts,"_OS_FreePorts")
#pragma map(OS_GetPorts,"_OS_GetPorts")
*/
#pragma map(OS_SetDisk,"_OS_SetDisk")
#pragma map(OS_SysPath,"_OS_SysPath")
#pragma map(OS_GetDiskFree,"_OS_GetDiskFree")
#pragma map(OS_Sound,"_OS_Sound")
#pragma map(OS_ComLine,"_OS_ComLine")
#pragma map(OS_MkDir,"_OS_MkDir")
#pragma map(OS_Flush,"_OS_Flush")
#pragma map(OS_Beep,"_OS_Beep")
#pragma map(OS_Seek,"_OS_Seek")
#pragma map(OS_Date_oooo,"_OS_Date_oooo")
#pragma map(OS_Date_ooo,"_OS_Date_ooo")
#pragma map(OS_SetFAttr,"_OS_SetFAttr")
#pragma map(OS_GetFAttr,"_OS_GetFAttr")
#pragma map(OS_WriteText,"_OS_WriteText")
#pragma map(OS_Date_iii,"_OS_Date_iii")
#pragma map(OS_SeekWrBin,"_OS_SeekWrBin")
#pragma map(OS_DiffTime, "_OS_DiffTime" )		/* SPB283 */
#pragma map(WINDOWS_LibraryNeeded,"_WINDOWS_LibraryNeeded")
#pragma map(PHARLAP_LibraryNeeded,"_PHARLAP_LibraryNeeded")
#pragma map(DOS_LibraryNeeded,"_DOS_LibraryNeeded")
#pragma map(NT_LibraryNeeded,"_NT_LibraryNeeded")
#pragma map(PM_LibraryNeeded,"_PM_LibraryNeeded")
#pragma map(PM_32bit_LibraryNeeded,"_PM_32bit_LibraryNeeded")
#pragma map(OS2_LibraryNeeded,"_OS2_LibraryNeeded")
#pragma map(OS2_32bit_LibraryNeeded,"_OS2_32bit_LibraryNeeded")
#pragma map(XENIX_LibraryNeeded,"_XENIX_LibraryNeeded")
#pragma map(UNIX_LibraryNeeded,"_UNIX_LibraryNeeded")
#pragma map(OS_Init,"_OS_Init")
#pragma map(OS_GetDisk,"_OS_GetDisk")
#pragma map(OS_GetDir,"_OS_GetDir")
#pragma map(OS_WriteBin,"_OS_WriteBin")
#pragma map(OS_Exist,"_OS_Exist")
#pragma map(OS_FindClose,"_OS_FindClose")
#pragma map(OS_FindNext,"_OS_FindNext")
#pragma map(OS_FindFirst,"_OS_FindFirst")
#pragma map(OS_Open,"_OS_Open")
#pragma map(OS_SystemBg,"_OS_SystemBg")
#pragma map(OS_System3,"_OS_System3")
#pragma map(OS_System1,"_OS_System1")
#pragma map(OS_SystemUI,"_OS_SystemUI")
#pragma map(OS_Rename,"_OS_Rename")
#pragma map(OS_SetDir,"_OS_SetDir")
#pragma map(OS_SeekRdBin,"_OS_SeekRdBin")
#pragma map(OS_Unlink,"_OS_Unlink")
#pragma map(OS_ReadBin,"_OS_ReadBin")
#pragma map(OS_Version,"_OS_Version")
#pragma map(OS_CopyFile,"_OS_CopyFile")
#pragma map(OS_RmDir,"_OS_RmDir")
#pragma map(OS_Sleep,"_OS_Sleep")
#pragma map(OS_TimeOut,"_OS_TimeOut")
#pragma map(OS_MarkTime,"_OS_MarkTime")
/* SPB000 14/11/96 ftime begin */
#pragma map(OS_GetFTime, "_OS_GetFTime")
#pragma map(OS_SetFTime, "_OS_SetFTime" )
#pragma map(file_time_0, "_file_time_0")
#pragma map(file_time_1, "_file_time_1")
/* SPB000 14/11/96 ftime end */
#pragma map(STR_StrLen,"_STR_StrLen")
#pragma map(STR_StrCat0Max,"_STR_StrCat0Max")
#pragma map(STR_ExtendStr,"_STR_ExtendStr")
#pragma map(STR_ToLower,"_STR_ToLower")
#pragma map(STR_StrCat0,"_STR_StrCat0")
#pragma map(STR_ToUpper,"_STR_ToUpper")
#pragma map(STR_UCat,"_STR_UCat")
#pragma map(STR_StrCat,"_STR_StrCat")
#pragma map(STR_SearchStr,"_STR_SearchStr")
#pragma map(STR_StrCatMax,"_STR_StrCatMax")
#pragma map(STR_StrCmp,"_STR_StrCmp")
#pragma map(STR_StrCmpi,"_STR_StrCmpi")	/* SPB000, 04/09/96 */
#pragma map(STR_StrNCmp, "_STR_StrNCmp")	/* SPB000 03/12/96 */
#pragma map(CPU_Type,"_CPU_Type")
#pragma map(CPU_Init,"_CPU_Init")
#pragma map(CFG_LoadSafe,"_CFG_LoadSafe")
#pragma map(CFG_LoadLib,"_CFG_LoadLib")
#pragma map(CFG_SaveSafe,"_CFG_SaveSafe")
#pragma map(CFG_LoadPred,"_CFG_LoadPred")
#pragma map(CFG_LoadMain,"_CFG_LoadMain")
#pragma map(CFG_LoadPredUI,"_CFG_LoadPredUI")
#pragma map(CFG_Save,"_CFG_Save")
#pragma map(SCAN_Real,"_SCAN_Real")
#pragma map(SCAN_Uns,"_SCAN_Uns")
#pragma map(SCAN_Intg,"_SCAN_Intg")
#pragma map(SCAN_Ref,"_SCAN_Ref")
#pragma map(BIT_Bitxor,"_BIT_Bitxor")
#pragma map(BIT_Ptr_Dword_ioo,"_BIT_Ptr_Dword_ioo")
#pragma map(BIT_Ptr_Dword_oii,"_BIT_Ptr_Dword_oii")
#pragma map(BIT_Port_Byte_io,"_BIT_Port_Byte_io")
#pragma map(BIT_MemByte_ii,"_BIT_MemByte_ii")
#pragma map(BIT_MemByte_iio,"_BIT_MemByte_iio")
#pragma map(BIT_MemByte_iii,"_BIT_MemByte_iii")
#pragma map(BIT_Port_Byte_ii,"_BIT_Port_Byte_ii")
#pragma map(BIT_Bitleft,"_BIT_Bitleft")
#pragma map(BIT_Bitand,"_BIT_Bitand")
#pragma map(BIT_MemDWord_ii,"_BIT_MemDWord_ii")
#pragma map(BIT_MemDWord_io,"_BIT_MemDWord_io")
#pragma map(BIT_MemDWord_iii,"_BIT_MemDWord_iii")
#pragma map(BIT_MemDWord_iio,"_BIT_MemDWord_iio")
#pragma map(BIT_Bitnot,"_BIT_Bitnot")
#pragma map(BIT_Bitor,"_BIT_Bitor")
#pragma map(BIT_MemWord_iii,"_BIT_MemWord_iii")
#pragma map(BIT_MemWord_iio,"_BIT_MemWord_iio")
#pragma map(BIT_MemByte_io,"_BIT_MemByte_io")
#pragma map(BIT_MemWord_ii,"_BIT_MemWord_ii")
#pragma map(BIT_MemWord_io,"_BIT_MemWord_io")
#pragma map(BIT_Bitright,"_BIT_Bitright")
#pragma map(BIT_WritePort,"_BIT_WritePort")
#pragma map(BIT_ReadPort,"_BIT_ReadPort")
#pragma map(ERR_ReadErrorMsg,"_ERR_ReadErrorMsg")
#pragma map(ERR_ErrorMsg,"_ERR_ErrorMsg")
#pragma map(ERR_SaveLastError,"_ERR_SaveLastError")
#pragma map(ERR_LastError,"_ERR_LastError")
#pragma map(ERR_File,"_ERR_File")
#pragma map(ERR_SaveFileTable,"_ERR_SaveFileTable")
#pragma map(ERR_SaveIncludeNo,"_ERR_SaveIncludeNo")
#pragma map(ERR_SaveSourceOffset,"_ERR_SaveSourceOffset")
#pragma map(ERR_SaveErrorNo,"_ERR_SaveErrorNo")
#pragma map(ERR_FileTable,"_ERR_FileTable")
#pragma map(ERR_IncludeNo,"_ERR_IncludeNo")
#pragma map(ERR_SourceOffset,"_ERR_SourceOffset")
#pragma map(ERR_FileDir,"_ERR_FileDir")
#pragma map(ERR_FileName,"_ERR_FileName")
#pragma map(ERR_Init,"_ERR_Init")
#pragma map(ERR_GetSysErrorMsg,"_ERR_GetSysErrorMsg")
#pragma map(ERR_Invar,"_ERR_Invar")
#pragma map(ERR_ReportLevel1,"_ERR_ReportLevel1")
#pragma map(ERR_ReportLevel0,"_ERR_ReportLevel0")
#pragma map(ERR_Fatal,"_ERR_Fatal")
#pragma map(RNT_Save,"_RNT_Save")
#pragma map(RNT_FinishRetract,"_RNT_FinishRetract")
#pragma map(RNT_RetractallCmp,"_RNT_RetractallCmp")
#pragma map(RNT_SizeOf,"_RNT_SizeOf")
#pragma map(RNT_ConsultErr,"_RNT_ConsultErr")
#pragma map(RNT_CopyComplxToHeap,"_RNT_CopyComplxToHeap")
#pragma map(RNT_DBTermToBin,"_RNT_DBTermToBin")
#pragma map(RNT_CopyToHeap,"_RNT_CopyToHeap")
#pragma map(RNT_SaveWorkStr,"_RNT_SaveWorkStr")
#pragma map(RNT_WorkStrLen,"_RNT_WorkStrLen")
#pragma map(RNT_WorkStr,"_RNT_WorkStr")
#pragma map(RNT_TermStr_oi,"_RNT_TermStr_oi")
#pragma map(RNT_ReadTerm,"_RNT_ReadTerm")
#pragma map(RNT_ReadTermError,"_RNT_ReadTermError")
#pragma map(RNT_ParseInit,"_RNT_ParseInit")
#pragma map(RNT_TermStringInit,"_RNT_TermStringInit")
#pragma map(RNT_RetractDeterm,"_RNT_RetractDeterm")
#pragma map(RNT_SetRealEntry,"_RNT_SetRealEntry")
#pragma map(RNT_GetRealEntry,"_RNT_GetRealEntry")
#pragma map(RNT_CopyUnify,"_RNT_CopyUnify")
#pragma map(RNT_CopyTermToGStack,"_RNT_CopyTermToGStack")
#pragma map(RNT_CopyBinaryToGStack,"_RNT_CopyBinaryToGStack")
#pragma map(RNT_RetractCmp,"_RNT_RetractCmp")
#pragma map(RNT_AssertaSimple,"_RNT_AssertaSimple")
#pragma map(RNT_RetractallVar,"_RNT_RetractallVar")
#pragma map(RNT_ParseFunctor,"_RNT_ParseFunctor")
#pragma map(RNT_FixUpBinChunk,"_RNT_FixUpBinChunk")
#pragma map(RNT_ReadTermErrorLinePos,"_RNT_ReadTermErrorLinePos")
#pragma map(RNT_ReadTermErrorOccured,"_RNT_ReadTermErrorOccured")
#pragma map(RNT_NoOfGlobDoms,"_RNT_NoOfGlobDoms")
#pragma map(RNT_Domdef,"_RNT_Domdef")
#pragma map(RNT_iiii,"_RNT_iiii")
#pragma map(RNT_End,"_RNT_End")
#pragma map(RNT_Init,"_RNT_Init")
#pragma map(RNT_FindallSlut,"_RNT_FindallSlut")
#pragma map(RNT_FindallAlloc,"_RNT_FindallAlloc")
#pragma map(RNT_ConsultErrorFilepos,"_RNT_ConsultErrorFilepos")
#pragma map(RNT_Consult,"_RNT_Consult")
#pragma map(RNT_Asserta,"_RNT_Asserta")
#pragma map(RNT_FixSymbols,"_RNT_FixSymbols")
#pragma map(RNT_TermStr_io,"_RNT_TermStr_io")
#pragma map(RNT_TermStrConv,"_RNT_TermStrConv")
#pragma map(RNT_CopyComplxToGStack,"_RNT_CopyComplxToGStack")
#pragma map(RNT_RetractVar,"_RNT_RetractVar")
#pragma map(RNT_ParseBinary,"_RNT_ParseBinary")
#pragma map(Hex2Int,"_Hex2Int")
#pragma map(RNT_ReadTermErr,"_RNT_ReadTermErr")
#pragma map(RNT_AssertzSimple,"_RNT_AssertzSimple")
#pragma map(RNT_CopyFacts,"_RNT_CopyFacts")
#pragma map(RNT_SetDWordEntry,"_RNT_SetDWordEntry")
#pragma map(RNT_SetWordEntry,"_RNT_SetWordEntry")
#pragma map(RNT_SetByteEntry,"_RNT_SetByteEntry")
#pragma map(RNT_GetDWordEntry,"_RNT_GetDWordEntry")
#pragma map(RNT_GetWordEntry,"_RNT_GetWordEntry")
#pragma map(RNT_GetByteEntry,"_RNT_GetByteEntry")
#pragma map(RNT_MakeBinary2,"_RNT_MakeBinary2")
#pragma map(RNT_ComposeBinary,"_RNT_ComposeBinary")

/* SPB067 begin */
#pragma map(RNT_CompressBinary,"_RNT_CompressBinary")
#pragma map(RNT_ExpandBinary,"_RNT_ExpandBinary")
/* SPB095 begin */
/*#pragma map(RNT_CrcBinary,"_RNT_CrcBinary")*/
#pragma map(RNT_Crc16Binary_i,"_RNT_Crc16Binary_i")
#pragma map(RNT_Crc16Binary_ii,"_RNT_Crc16Binary_ii")
#pragma map(RNT_Crc32Binary_i,"_RNT_Crc32Binary_i")
#pragma map(RNT_Crc32Binary_ii,"_RNT_Crc32Binary_ii")
/* SPB095 end */
/* SPB067 end */

#pragma map(RNT_GetBinarySize,"_RNT_GetBinarySize")
#pragma map(RNT_Assertz,"_RNT_Assertz")
#pragma map(RNT_WriteComplx,"_RNT_WriteComplx")
#pragma map(RNT_TermBin_oi,"_RNT_TermBin_oi")
#pragma map(RNT_TermBin_io,"_RNT_TermBin_io")
#pragma map(RNT_ParseChar,"_RNT_ParseChar")
#pragma map(RNT_CopyStrToGStack,"_RNT_CopyStrToGStack")
#pragma map(RNT_LWriteTerm,"_RNT_LWriteTerm")
#pragma map(RNT_WriteTerm,"_RNT_WriteTerm")
#pragma map(RNT_SkrivDom,"_RNT_SkrivDom")
#pragma map(RNT_ParseStr,"_RNT_ParseStr")
#pragma map(EMM_Available,"_EMM_Available")
#pragma map(PFP_Random,"_PFP_Random")
//#pragma map(PFP_Round,"_PFP_Round")
//#pragma map(PFP_Trunc,"_PFP_Trunc")
//#pragma map(PFP_Abs,"_PFP_Abs")
#pragma map(MEM_ReAllocHeap,"_MEM_ReAllocHeap")
#pragma map(MEM_MovMem,"_MEM_MovMem")
#pragma map(MEM_ReleaseBinaryHeap,"_MEM_ReleaseBinaryHeap")
#pragma map(MEM_MakeBinaryHeap,"_MEM_MakeBinaryHeap")
#pragma map(MEM_NewCopyHeap,"_MEM_NewCopyHeap")
#pragma map(MEM_SaveBinaryHeap,"_MEM_SaveBinaryHeap")
#pragma map(MEM_NewCopyGStack,"_MEM_NewCopyGStack")
#pragma map(MEM_SaveStringGStack,"_MEM_SaveStringGStack")
#pragma map(MEM_ReleaseStringHeap, "_MEM_ReleaseStringHeap" )   /* SPB000 06/05/97 */
#pragma map(MEM_SaveBinaryGStack,"_MEM_SaveBinaryGStack")
#pragma map(MEM_SaveStringHeap,"_MEM_SaveStringHeap")
#pragma map(MEM_CreateDynarray,"_MEM_CreateDynarray")
#pragma map(MEM_NewDynarray,"_MEM_NewDynarray")
#pragma map(MEM_CreateDynspace,"_MEM_CreateDynspace")
#pragma map(MEM_AllocDynspace,"_MEM_AllocDynspace")
#pragma map(MEM_GTop,"_MEM_GTop")
#pragma map(MEM_GStat,"_MEM_GStat")
#pragma map(MEM_GetMaxGStack,"_MEM_GetMaxGStack")
#pragma map(MEM_GetBigGStack,"_MEM_GetBigGStack")
#pragma map(MEM_AllocGStack,"_MEM_AllocGStack")
#pragma map(MEM_FreeGStack,"_MEM_FreeGStack")

/* SPB000 28/11/96 begin */
#pragma map(MEM_MarkGStack,"_MEM_MarkGStack")
#pragma map(MEM_ReleaseGStack,"_MEM_ReleaseGStack")
/* SPB000 28/11/96 end */

#pragma map(MEM_AdjustGStackAlloc,"_MEM_AdjustGStackAlloc")
#pragma map(MEM_MakeBinaryGStack,"_MEM_MakeBinaryGStack")
#pragma map(MEM_SetMemW,"_MEM_SetMemW")
#pragma map(MEM_SetMem,"_MEM_SetMem")
#pragma map(MEM_SetMem0,"_MEM_SetMem0")
#pragma map(MEM_GLims,"_MEM_GLims")
#pragma map(MEM_GSels,"_MEM_GSels")
#pragma map(MEM_GSTop,"_MEM_GSTop")
#pragma map(MEM_Init,"_MEM_Init")
#pragma map(MEM_PtrPtrOlder,"_MEM_PtrPtrOlder")
#pragma map(MEM_PtrOlder,"_MEM_PtrOlder")
#pragma map(_MEM_HeapInit,"__MEM_HeapInit")
#pragma map(MEM_HStat,"_MEM_HStat")
#pragma map(MEM_Free,"_MEM_Free")
#pragma map(MEM_Malloc,"_MEM_Malloc")
#pragma map(MSG_Close,"_MSG_Close")
#pragma map(MSG_Create,"_MSG_Create")
#pragma map(MSG_End,"_MSG_End")
#pragma map(MSG_GetError,"_MSG_GetError")
#pragma map(MSG_GetLastQ,"_MSG_GetLastQ")
#pragma map(MSG_GetLastRX,"_MSG_GetLastRX")
#pragma map(MSG_GetLoss,"_MSG_GetLoss")
#pragma map(MSG_Flush,"_MSG_Flush")
#pragma map(MSG_Open,"_MSG_Open")
#pragma map(MSG_Promote,"_MSG_Promote")
#pragma map(MSG_Purge,"_MSG_Purge")
#pragma map(MSG_Queued,"_MSG_Queued")
#pragma map(MSG_Receive,"_MSG_Receive")
#pragma map(MSG_ResetSeq,"_MSG_ResetSeq")
#pragma map(MSG_Send,"_MSG_Send")
#pragma map(MSG_SendSimple,"_MSG_SendSimple")
#pragma map(MSG_SetFlush,"_MSG_SetFlush")
#pragma map(MSG_SetWait,"_MSG_SetWait")
#pragma map(BRK_CheckBreak,"_BRK_CheckBreak")
/* SPB202 begin */
#pragma map(BRK_Break_i,"_BRK_Break_i")
#pragma map(BRK_Break_o,"_BRK_Break_o")
#pragma map(BRK_CheckPressed,"_BRK_CheckPressed")
/* SPB202 end */
#pragma map(RUN_LowStack,"_RUN_LowStack")
#pragma map(RUN_StackCheckInLine,"_RUN_StackCheckInLine")
#pragma map(RUN_StackCheckNoFiddle,"_RUN_StackCheckNoFiddle")

#pragma map(IO_BuffSize_ii,"_IO_BuffSize_ii")
#pragma map(IO_BuffSize_oo,"_IO_BuffSize_oo")

/* Mapping names from assembler modules */
#pragma map(DB_specret,"_DB_specret")
#pragma map(DB_getretaddr,"_DB_getretaddr")
#pragma map(DB_getretbp,"_DB_getretbp")
#pragma map(RUN_GetSP,"_RUN_GetSP")
/* SPB000 25/09/96 begin */
/*
#pragma map(RUN_AdjustTrapPoints,"_RUN_AdjustTrapPoints")
#pragma map(RUN_AdjustTrapPoint,"_RUN_AdjustTrapPoint")
*/
/* SPB000 25/09/96 end */
#pragma map(RUN_Debug,"_RUN_Debug")
#pragma map(RUN_StackBTrack,"_RUN_StackBTrack")
#pragma map(RUN_stkb3,"_RUN_stkb3")
#pragma map(RUN_stkb2,"_RUN_stkb2")
#pragma map(RUN_stkb1,"_RUN_stkb1")
#pragma map(RUN_Cut_,"_RUN_Cut_")
#pragma map(RUN_RemoveTrap,"_RUN_RemoveTrap")
#pragma map(RUN_True,"_RUN_True")
#pragma map(RUN_JmpReturn1,"_RUN_JmpReturn1")
#pragma map(RUN_ChkRetract,"_RUN_ChkRetract")
#pragma map(RUN_Fail,"_RUN_Fail")
#pragma map(RUN_JmpReturn,"_RUN_JmpReturn")
#pragma map(RUN_Cut,"_RUN_Cut")
#pragma map(RUN_StackTrap,"_RUN_StackTrap")
#pragma map(RUN_ChkTrail,"_RUN_ChkTrail")
#pragma map(RUN_get_trailsize,"_RUN_get_trailsize")
#pragma map(RUN_stktrap,"_RUN_stktrap")
#pragma map(RUN_BPoints,"_RUN_BPoints")
#pragma map(RUN_BTop_o,"_RUN_BTop_o")
#pragma map(RUN_BTop_i,"_RUN_BTop_i")
#pragma map(RUN_Unify,"_RUN_Unify")
#pragma map(RUN_allocref_si,"_RUN_allocref_si")
#pragma map(RUN_allocref_dx,"_RUN_allocref_dx")
#pragma map(RUN_allocref_cx,"_RUN_allocref_cx")
#pragma map(RUN_allocref_bx,"_RUN_allocref_bx")
#pragma map(RUN_allocref_ax,"_RUN_allocref_ax")
#pragma map(RUN_allocref_di,"_RUN_allocref_di")
#pragma map(RUN_trail_ptr,"_RUN_trail_ptr")
#pragma map(RUN_coerse_si,"_RUN_coerse_si")
#pragma map(RUN_coerse_dx,"_RUN_coerse_dx")
#pragma map(RUN_coerse_cx,"_RUN_coerse_cx")
#pragma map(RUN_coerse_bx,"_RUN_coerse_bx")
#pragma map(RUN_coerse_ax,"_RUN_coerse_ax")
#pragma map(RUN_allocrefterm_si,"_RUN_allocrefterm_si")
#pragma map(RUN_allocrefterm_dx,"_RUN_allocrefterm_dx")
#pragma map(RUN_allocrefterm_cx,"_RUN_allocrefterm_cx")
#pragma map(RUN_allocrefterm_bx,"_RUN_allocrefterm_bx")
#pragma map(RUN_allocrefterm_ax,"_RUN_allocrefterm_ax")
#pragma map(RUN_coerse_di,"_RUN_coerse_di")
#pragma map(RUN_allocrefterm_di,"_RUN_allocrefterm_di")
#pragma map(RUN_trail_si,"_RUN_trail_si")
#pragma map(RUN_trail_dx,"_RUN_trail_dx")
#pragma map(RUN_trail_cx,"_RUN_trail_cx")
#pragma map(RUN_trail_bx,"_RUN_trail_bx")
#pragma map(RUN_trail_ax,"_RUN_trail_ax")
#pragma map(RUN_trail_di,"_RUN_trail_di")
#pragma map(RUN_uc,"_RUN_uc")
#pragma map(RUN_StackCheck,"_RUN_StackCheck")

#ifdef LOGREC
  #pragma map(RUN_LogEnable,"_RUN_LogEnable")
  #pragma map(RUN_LogDisable,"_RUN_LogDisable")
  #pragma map(RUN_LogName,"_RUN_LogName")
  #pragma map(RUN_SetLogToMemory,"_RUN_SetLogToMemory")
  #pragma map(RUN_SetLogToDisk,"_RUN_SetLogToDisk")
  #pragma map(RUN_FlushLogToFile,"_RUN_FlushLogToFile")
  #pragma map(putLog,"_putLog")
  #pragma map(RUN_SharingOn,"_RUN_SharingOn")
  #pragma map(RUN_SharingOff,"_RUN_SharingOff")
  #pragma map(RUN_TimeStampOn,"_RUN_TimeStampOn")
  #pragma map(RUN_TimeStampOff,"_RUN_TimeStampOff")
#endif

#pragma map(JMP_SetJmp,"_JMP_SetJmp")
#pragma map(JMP_LongJmp,"_JMP_LongJmp")
//#pragma map(PFP_Sqrt,"_PFP_Sqrt")
//#pragma map(PFP_Atan,"_PFP_Atan")
//#pragma map(PFP_Exp,"_PFP_Exp")
//#pragma map(PFP_Sin,"_PFP_Sin")
//#pragma map(PFP_Cos,"_PFP_Cos")
//#pragma map(PFP_Tan,"_PFP_Tan")
//#pragma map(PFP_Log,"_PFP_Log")
#pragma map(MEM_alloc_dx,"_MEM_alloc_dx")
#pragma map(MEM_alloc_si,"_MEM_alloc_si")
#pragma map(MEM_alloc_cx,"_MEM_alloc_cx")
#pragma map(MEM_alloc_bx,"_MEM_alloc_bx")
#pragma map(MEM_alloc_ax,"_MEM_alloc_ax")
#pragma map(MEM_alloc_di,"_MEM_alloc_di")

/* Mapping names from user module */
#pragma map(PROLOG_SymbolTable,"_PROLOG_SymbolTable")
#pragma map(PROLOG_Goal,"_PROLOG_Goal")
#pragma map(PROLOG_Vars,"_PROLOG_Vars")
#pragma map(PROLOG_ModTab,"_PROLOG_ModTab")
#pragma map(PROLOG_ErrReport,"_PROLOG_ErrReport")
#pragma map(CFG_Load,"_CFG_Load")

#pragma map(FNM_ReducePath_iio,"_FNM_ReducePath_iio") /* SPB000 010596 */

/* SPB129 begin */
/*#if complib_version == UI*/
  /* #pragma map(PASS_StopCompilation,"_PASS_StopCompilation")*/
  #pragma map(PASS_ExpandAndCompile,"_PASS_ExpandAndCompile")
  #pragma map(PASS_CheckGlobalDomains,"_PASS_CheckGlobalDomains") /* SPB000 100696 */
  /* SPB145 begin
  #pragma map(DB_FastLoadEMS,"_DB_FastLoadEMS")
  #pragma map(DB_FastSaveEMS,"_DB_FastSaveEMS")
   SPB145 end */
/*#endif*/
/* SPB129 end */

/* SPB145 begin */
/*#if complib_version != COMLN*/
  #pragma map(DB_FastLoadEMS,"_DB_FastLoadEMS")
  #pragma map(DB_FastSaveEMS,"_DB_FastSaveEMS")
/*#endif*/
/* SPB145 end */

/* SPB138 begin */
/*#if complib_version != COMLN*/
  #pragma map(socket_Create,"_socket_Create")
  #pragma map(socket_Listen,"_socket_Listen")
  #pragma map(socket_Connect,"_socket_Connect")
  #pragma map(socket_Bind,"_socket_Bind")
  #pragma map(socket_TryAccept_0,"_socket_TryAccept_0")
  #pragma map(socket_TryAccept_1,"_socket_TryAccept_1")
  #pragma map(socket_Close,"_socket_Close")
  #pragma map(socket_GetLastError,"_socket_GetLastError")	/* SPB000 16/10/96 */
  #pragma map(socket_Send,"_socket_Send")
  #pragma map(socket_SendOOB,"_socket_SendOOB")
  #pragma map(socket_TryReceive,"_socket_TryReceive")
  #pragma map(socket_GetOption,"_socket_GetOption")
  #pragma map(socket_SetOption,"_socket_SetOption")
  #pragma map(socket_GetLingerOption,"_socket_GetLingerOption")
  #pragma map(socket_SetLingerOption,"_socket_SetLingerOption")
  #pragma map(socket_GetName,"_socket_GetName")
  #pragma map(socket_GetPeerName,"_socket_GetPeerName")
  #pragma map(socket_GetHostName,"_socket_GetHostName")
  #pragma map(socket_GetHostByName,"_socket_GetHostByName")
  #pragma map(socket_AsyncSelect,"_socket_AsyncSelect")
  #pragma map(socket_Message2Socket,"_socket_Message2Socket")
  #pragma map(socket_GetSelectEvent,"_socket_GetSelectEvent")
  #pragma map(socket_GetSelectError,"_socket_GetSelectError")
  #pragma map(socket_TrySend,"_socket_TrySend")		/* SPB171 */
  #pragma map(socket_QueryUnsent,"_socket_QueryUnsent")	/* SPB171 */
  #pragma map(socket_inet,"_socket_inet")		/* SPB180 */
  #pragma map(socket_ntohl,"_socket_ntohl")		/* SPB180 */
  #pragma map(socket_ntohs,"_socket_ntohs")		/* SPB180 */
  #pragma map(socket_htonl,"_socket_htonl")		/* SPB180 */
  #pragma map(socket_htons,"_socket_htons")		/* SPB000 16/10/96 */
  #pragma map(socket_CreateHuge,"_socket_CreateHuge")	/* SPB180 */
  /* SPB199 begin */
  /*#pragma map(socket_HugeData,"_socket_HugeData")*/	/* SPB180 */
  #pragma map(socket_IsHuge,"_socket_IsHuge")		/* SPB180 */
  /* SPB199 end */

  /* SPB000, 03/09/96 begin */
  #pragma map(socket_GetFullName,"_socket_GetFullName")
  #pragma map(socket_GetFullPeerName,"_socket_GetFullPeerName")
  /* SPB000, 03/09/96 end */

  #pragma map(socket_GetRealSocket,"_socket_GetRealSocket")	/* SPB000 06/09/96 */

  #pragma map(socket_SendInt,"_socket_SendInt")			/* SPB245 */
  #pragma map(socket_GetHostByAddr,"_socket_GetHostByAddr")	/* SPB245 */

  #pragma map(MEM_ObjectsDiag,"_MEM_ObjectsDiag")		/* SPB000 24/07/96 */
  #pragma map(STR_Separate_String,"_STR_Separate_String")	/* SPB000 29/07/96 */
  #pragma map(STR_List_To_String,"_STR_List_To_String")		/* SPB000 29/07/96 */
  #pragma map(CONV_Bin_To_StrList,"_CONV_Bin_To_StrList")	/* SPB000 21/08/96 */
/*#endif*/
/* SPB138 end */

/* SPB051 begin */
#if !defined(PFP_INCLUDED)
  #pragma map( PFP_GetExponent,		"_PFP_GetExponent" )
  #pragma map( PFP_GetTypeArgument,	"_PFP_GetTypeArgument" )
  #pragma map( PFP_ClearExceptionFlags, "_PFP_ClearExceptionFlags" ) /* SPB000 06/11/97 */
  #pragma map( PFP_FPUReset, "_PFP_FPUReset" )			     /* SPB000 11/11/97 */
  #pragma map( PFP_ClearFPUStack, "_PFP_ClearFPUStack" )	     /* SPB000  11/11/97 */
#endif

/* SPB051 end */

  #pragma map( __PTD__, "___PTD__" )	/* SPB151 */

  #pragma map( ERR_InstallUserRepFns, "_ERR_InstallUserRepFns" ) /* SPB217 */

  #pragma map( IO_SetWrStrConFNS,	"_IO_SetWrStrConFNS" )
  #pragma map( IO_SetWrChConFNS,	"_IO_SetWrChConFNS" )

  #pragma map( RUN_ErrorExit, "_RUN_ErrorExit" )	/* SPB280 */
  #pragma map( PDC_GetLibraryVersion, "_PDC_GetLibraryVersion" )	/* SPB000 10/09/97 */

  #pragma map( RUN_UnresolvedRefError, "_RUN_UnresolvedRefError" )	/* SPB351 */

  #pragma map( PDC_GetCompilerVersion, "_PDC_GetCompilerVersion" )	/* SPB000 12/10/97 */

  /* SPB000 15/10/97 begin */
  /* SPB393 begin */
  /*
  #pragma map( MEM_AllocObject, "_MEM_AllocObject" )
  #pragma map( MEM_ReleaseObject, "_MEM_ReleaseObject" )
  */
  #pragma map( RNT_CreateObject,    "_RNT_CreateObject" )
  #pragma map( RNT_DestroyObject,   "_RNT_DestroyObject" )
  #pragma map( RNT_PrepareDBnew,    "_RNT_PrepareDBnew" )
  /* SPB393 end */
  /* SPB000 15/10/97 end */

/* SPB000 27/01/98 begin */
#pragma map( ERR_NativeOsErrorCode,   "_ERR_NativeOsErrorCode" )
#pragma map( RUN_ExceptionCode,	      "_RUN_ExceptionCode" )
#pragma map( RUN_ExceptionInProgress, "_RUN_ExceptionInProgress" )
#pragma map( ERR_AdditiveInfo,	      "_ERR_AdditiveInfo" )
/* SPB000 27/01/98 end */

/* SPB000 15/02/98 begin */
#pragma map( RNT_Cursor,   "_RNT_Cursor" )
/* SPB000 15/02/98 end */

#endif
