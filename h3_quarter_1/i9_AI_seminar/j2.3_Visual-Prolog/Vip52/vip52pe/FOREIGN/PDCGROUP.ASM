;/***************************************************************************
;
;			   PDC Prolog
;
;		  Basic Runtime Support Functions
;
; FileName: PDCGROUP.ASM
; PURPOSE:  segment declarations for linking with C.
;
; 様様様様様様様曜様様様僕様様様様様様様様様様様様様様様様様様様様様様様様様�
;  Date Modified,� By,  �  Comments.
; 様様様様様様様洋様様様陵様様様様様様様様様様様様様様様様様様様様様様様様様�
;    18/06/96    �SPB172� D960612.07 Convert pdcgroup obj to COFF for win32 msc
;                �      �
;***************************************************************************/

TITLE	PDCGROUP - Layout of module table segments
SUBTTL	Copyright 1987,94,96 by Prolog Development Center A/S
NAME	PDCGROUP
  IFDEF PLATFORM_16BITS
    public _PROLOG_ModTab               ;###
    PROMOD	SEGMENT BYTE PUBLIC 'PROMOD'
  	_PROLOG_ModTab	label	byte
    PROMOD	ENDS

    PROMODE     SEGMENT BYTE PUBLIC 'PROMOD'
  	dd 0
    PROMODE	ENDS

    MODGROUP GROUP PROMOD,PROMODE
  ENDIF
  IFDEF WIN32
    IFDEF BCC32
      .386P
      .model flat
      public _PROLOG_ModTab
      PROMOD  SEGMENT DWORD USE32 PUBLIC 'DATA'
        _PROLOG_ModTab    label byte
      PROMOD  ENDS
      PROMODE SEGMENT DWORD USE32 PUBLIC 'DATA'
             dd 0
      PROMODE ENDS
      MODGROUP GROUP PROMOD,PROMODE
    ENDIF
    IFDEF MSC
        .386P
	.model flat
        CONST   SEGMENT DWORD USE32 PUBLIC 'CONST'
        CONST   ENDS
        _BSS    SEGMENT DWORD USE32 PUBLIC 'BSS'
        _BSS    ENDS

        public _PROLOG_ModTab
        public _INIT_StartOfData
        _DATA SEGMENT DWORD USE32 PUBLIC 'DATA'
          	ASSUME        CS: FLAT, DS: FLAT, ES: FLAT, SS: FLAT
          	_stklen			dd 10000
          	_INIT_StartOfData	db 0
          	_PROLOG_ModTab		dd 0
        _DATA  ENDS

      public endbyt
      PROMODE SEGMENT DWORD USE32 PUBLIC 'DATA'
                endbyt dd 0
      PROMODE ENDS
      ;SPB172 FLAT GROUP _DATA, PROMODE, CONST, _BSS
      FLAT_GROUP GROUP _DATA, PROMODE, CONST, _BSS	;SPB172
    ENDIF
  ENDIF

  IFDEF OS32
    .386P
    IFDEF BCC
      model flat
    ENDIF

    public _PROLOG_ModTab
    PROMOD  SEGMENT DWORD PUBLIC 'DATA'
        _PROLOG_ModTab  label   byte
    PROMOD  ENDS

    PROMODE SEGMENT DWORD PUBLIC 'DATA'
        dd 0
    PROMODE ENDS

    DGROUP GROUP PROMOD,PROMODE

    pgoal_CONST SEGMENT DWORD PUBLIC 'DATA'
    pgoal_CONST ENDS
    PROSYMB SEGMENT DWORD PUBLIC 'DATA'
    PROSYMB ENDS
    IFDEF BC
      DGROUP GROUP pgoal_CONST,PROSYMB
    ENDIF

    IFDEF IBMCPP
      public _stkbase
      STACKBASE       SEGMENT PARA USE32 PUBLIC 'STACK'
                _stkbase        dd      0
                db              01000h dup(0)
      STACKBASE       ENDS

      _STACK          SEGMENT PARA  USE32 PUBLIC 'STACK'
                db              0b000h dup (?)
      _STACK          ENDS

      DGROUP GROUP pgoal_CONST,PROSYMB,STACKBASE,_STACK
    ENDIF
  ENDIF
END
