;/* Copyright (c) 1984 - 2000 Prolog Development Center A/S */
; 16-bit version

CSUM_A16_TEXT	SEGMENT  WORD PUBLIC 'CODE'
CSUM_A16_TEXT	ENDS
_DATA	SEGMENT  WORD PUBLIC 'DATA'
_DATA	ENDS
CONST	SEGMENT  WORD PUBLIC 'CONST'
CONST	ENDS
_BSS	SEGMENT  WORD PUBLIC 'BSS'
_BSS	ENDS
DGROUP	GROUP	CONST, _BSS, _DATA
	ASSUME  CS: CSUM_A16_TEXT, DS: DGROUP, SS: DGROUP


CSUM_A16_TEXT      SEGMENT
	ASSUME	CS: CSUM_A16_TEXT

PUBLIC	sum_verify
sum_verify	PROC FAR
	push	bp
	mov	bp,sp


lolim equ 16
hilim equ 14
string equ 10
sum equ 6

	xor	dx,dx
	xor	bx,bx			; Do sum in dx:bx
	les	di,[bp+string]		; Pointer to string
	mov	cl,byte ptr [bp+lolim]	; Low limit in cl
	mov	ch,byte ptr [bp+hilim]	; High limit in ch
	xor	ax,ax


ALIGN 2
loopy:
	add	bx,ax			; Add sum
	adc	dx,0
	mov	al,byte ptr es:[di]
	inc	di
	cmp	al,cl
	jb	end_check
	cmp	al,ch
	jbe	loopy


end_check:
	or	al,al
	jnz	go_home
	les	di,[bp+sum]
	mov	es:[di],bx
	mov	es:[di+2],dx
	inc	ax			; ax: 0 -> 1

go_home:
	dec	ax			; ax: 1 -> 0, or 0 -> -1
	mov	sp,bp
	pop	bp
	ret	12
sum_verify	ENDP

CSUM_A16_TEXT	ENDS
END
