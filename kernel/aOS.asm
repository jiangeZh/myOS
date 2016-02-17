;��ʾMy-OS

extrn _showInt:near
extrn _mygets:near
extrn _myputs:near
extrn _intToStr:near
extrn  _cDisplay:near
extrn  _disp_pos

SegOfUserPrg1 equ 1000h
SegOfUserPrg2 equ 2000h
SegOfUserPrg3 equ 3000h
SegOfUserPrg4 equ 4000h
SegOfUserPrg5 equ 5000h
SegOfUserPrg6 equ 6000h
SegOfUserPrg7 equ 7000h
SegOfUserPrg8 equ 8000h
SegOfUserPrg9 equ 9000h

.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT,_DATA,_BSS
       assume cs:_TEXT

org 7e00h

delay equ 8		; ��ʱ���ӳټ���
count db delay		; ��ʱ��������������ֵ=delay
my_char db '|','/','\'
buffer dw 0
pro dd 0

start:
	DBUFFER1 DB 20 DUP (' ')
	;װʱ���ж�����
	cli
	xor ax,ax			; AX = 0
	mov es,ax			; ES = 0
	mov word ptr es:[20h],offset Timer	; ����ʱ���ж�������ƫ�Ƶ�ַ
	mov ax,cs 
	mov word ptr es:[22h],ax		; ����ʱ���ж������Ķε�ַ=CS

	mov word ptr es:[4*33],offset syscall
	mov word ptr es:[4*33+2],ax

	mov word ptr es:[34*4],offset int_34	; �����ж�������ƫ�Ƶ�ַ 
	mov word ptr es:[34*4+2],ax		; �����ж������Ķε�ַ=CS
	
	mov word ptr es:[35*4],offset int_35	; �����ж�������ƫ�Ƶ�ַ
	mov word ptr es:[35*4+2],ax		; �����ж������Ķε�ַ=CS

	mov word ptr es:[36*4],offset int_36	; �����ж�������ƫ�Ƶ�ַ
	mov word ptr es:[36*4+2],ax		; �����ж������Ķε�ַ=CS

	mov word ptr es:[37*4],offset int_37	; �����ж�������ƫ�Ƶ�ַ
	mov word ptr es:[37*4+2],ax		; �����ж������Ķε�ַ=CS
	sti
dis:	
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov sp,0
	mov word ptr [pro], 100h
	call near PTR _cDisplay
	jmp dis	


include kliba.asm

str34:
	db "this is my int 34!"

str35:
	db "this is my int 35!"

str36:
	db "this is my int 36!"

str37:
	db "this is my int 37!"

_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start