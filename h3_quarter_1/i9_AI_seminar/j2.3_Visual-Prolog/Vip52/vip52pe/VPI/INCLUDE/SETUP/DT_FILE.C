/*****************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName: DT_FILE.C
 Purpose: part of setup tool for os/2
 Written by: Zaichenko Michael
 Comments: IBMCPP version
******************************************************************************/

 #define INCL_DOSFILEMGR   /* File Manager values */
 #include <os2.h>
 #include <stdio.h>


 ULONG        PathInfoFlags;   /* Control flags */

APIRET _DTFile_SetDateTime(char *PathName,FDATE prodate,FTIME protime);
APIRET _DTFile_SetDateTime(char *PathName,FDATE prodate,FTIME protime)
 {
  ULONG       FileInfoLevel;	/* File info data required */
  FILESTATUS3 FileStat;		/* File info buffer */
  ULONG       FileInfoSize;	/* File info buffer size */
  APIRET      rc;		/* ULONG Return code */

/*  USHORT      year,month,day,hours,minutes;*/

    FileInfoLevel = 1;    /* Indicate that Level 1 information */
			  /*   is desired                      */

    FileInfoSize = sizeof(FILESTATUS3);

    rc = DosQueryPathInfo(PathName, FileInfoLevel, &FileStat,
				FileInfoSize);

			  /* Obtain a copy of the Level 1 */
			  /*   file information           */

    if (rc == 0)
    {
     FileStat.fdateLastAccess=prodate;
     FileStat.ftimeLastAccess=protime;

     FileStat.fdateCreation=FileStat.fdateLastAccess;
     FileStat.ftimeCreation=FileStat.ftimeLastAccess;

     FileStat.fdateLastWrite=FileStat.fdateLastAccess;
     FileStat.ftimeLastWrite=FileStat.ftimeLastAccess;



     PathInfoFlags = 0;
     rc = DosSetPathInfo(PathName, FileInfoLevel, &FileStat,
			    FileInfoSize, PathInfoFlags);

    }

	return(rc);
  };

/*unsigned long _DTFile_GetDriveInfo(unsigned char DRIVE,long *BPC,LONG *AVAIL ,LONG *TOTAL);
  */
/*
dword  DTFile_GetDriveInfo(CHAR drive, LONG BPC,LONG avail,LONG total)-(i,o,o,o) language c
*/


unsigned _DTFile_GetDriveInfo(unsigned char Drive,long *BPC,LONG *AVAIL ,LONG *TOTAL)
{

 ULONG   FSInfoBuf[10]; /* File system info buffer */
 APIRET  rc;            /* Return code */
 ULONG   BytesPerCluster ;

    if (Drive >'Z')
	  Drive -= ('a'-1);
    else  Drive -=('A'-1);

 
    rc = DosQueryFSInfo((ULONG)Drive,(ULONG)FSIL_ALLOC, &FSInfoBuf,0x28);
       
    if (rc == 0)
      {
/* 
 FSInfoBuf (PVOID) - output format for Level 1 Information 

ULONG  FSInfoBuf[10]
	[0] filesysid	: File system ID. 
	[1] sectornum  	: Number of sectors per allocation unit.
	[2] unitnum     : Number of allocation units. (Total)
        [3] unitavail 	: Number of allocation units available. 
        [4] bytesnum    : (word) Number of bytes per sector. 
*/

       BytesPerCluster = FSInfoBuf[1] * (FSInfoBuf[4] & 0xffff);
       *BPC   =  BytesPerCluster;
       *AVAIL =  FSInfoBuf[3] * BytesPerCluster;
       *TOTAL =  FSInfoBuf[2] * BytesPerCluster;
      }
    return(rc);
 }

