;/* Copyright (c) 1984 - 2000 Prolog Development Center A/S */
; 32-bit version

	.386
DGROUP	GROUP	CONST, _BSS, _DATA
_DATA	SEGMENT  DWORD USE32 PUBLIC 'DATA'
_DATA      ENDS
_BSS	SEGMENT  DWORD USE32 PUBLIC 'BSS'
_BSS      ENDS
CONST	SEGMENT  DWORD USE32 PUBLIC 'CONST'
CONST      ENDS
_TEXT	SEGMENT  DWORD USE32 PUBLIC 'CODE'
	ASSUME   CS: _TEXT, DS: DGROUP, SS: DGROUP, ES: DGROUP


PUBLIC  sum_verify
sum_verify	PROC NEAR

lolim equ 16
hilim equ 12
string equ 8
sum equ 4

	xor	edx,edx			; Do sum in edx
	mov	esi,[esp+string]	; Pointer to string
	mov	cl,byte ptr [esp+lolim]	; Low limit in cl
	mov	ch,byte ptr [esp+hilim]	; High limit in ch
	xor	eax,eax


ALIGN 4
loopy:
	add	edx,eax			; Add sum
	lodsb
	cmp	al,cl
	jb	end_check
	cmp	al,ch
	jbe	loopy


end_check:
	or	al,al
	jnz	failure
	mov	ecx,[esp+sum]
	mov	[ecx],edx
	ret  	16			; eax (return value) already zero

failure:
	dec	eax			; eax: 0 -> -1
	ret	16
sum_verify	ENDP

_TEXT	ENDS
END
