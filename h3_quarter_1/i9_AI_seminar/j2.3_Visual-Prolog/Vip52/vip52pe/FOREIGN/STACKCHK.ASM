;/******************************************************************************
;
;               Copyright (c) 1984 - 2000 Prolog Development Center A/S
;
;                            PDC PROLOG Upstart code
;
; ModuleName: CHK
; FileName: CHKSTK.ASM
; PURPOSE: Check stack
; VERSION: opsys == NT
; อออออออออออออออหออออออหออออออออออออออออออออออออออออออออออออออออออออออออออออ
;  Date Modified,บ By,  บ  Comments.
; อออออออออออออออฮออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออ
;                บ      บ
;******************************************************************************/

.386p
ifdef WIN32
  STACK_PAGE_SIZE	equ	1000h


	TITLE	$stackchk

  _TEXT SEGMENT PUBLIC DWORD USE32 'CODE'

    _chkstk PROC NEAR C

      push    edx
      cmp     eax, STACK_PAGE_SIZE
      lea     edx,[esp] + 8
      jb      short test_last_page

test_pages_loop:
      sub     edx, STACK_PAGE_SIZE
      sub     eax, STACK_PAGE_SIZE

      test    dword ptr [edx],eax

      cmp     eax, STACK_PAGE_SIZE
      jae     short test_pages_loop

test_last_page:
      sub     edx, eax
      mov     eax, esp

      test    dword ptr [edx], eax

      mov     esp, edx

      mov     edx, dword ptr [eax]
      mov     eax, dword ptr [eax + 4]

      push    eax

      ret

    _chkstk ENDP

_TEXT ENDS

endif
	END
