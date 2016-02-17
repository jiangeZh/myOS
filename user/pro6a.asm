extrn _main:near

.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT,_DATA,_BSS
       assume cs:_TEXT

org  100h
start:
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov bp, sp
	mov sp, 0
	push bp
	mov ah,02h
	mov bh,0
	mov dx,0
	int 10h
	call _main
	call DispStr
	call Keyin	
	pop sp
	mov ax,0
	mov ss,ax
	retf
DispStr:	
	mov ah,13h 	; ���ܺ�
	mov al,1 	
	mov bl,0fh 	
	mov bh,0 		; ��0ҳ
	mov dh,6h 	
	mov dl,0 		; ��0��
	mov bp,offset BootMsg 	; BP=����ַ
	mov cx,31 		; ����Ϊ44���ַ����� + ���� ���� �س���
	int 10h 	
	ret
Keyin: 
	mov ah,0 		
	int 16h 		
	cmp al,1bh 	
	je goout	
	jmp Keyin 	
goout: 
	ret

BootMsg: ; �ַ���
	db "Please Key in Esc to quit."
	db 7,7,0ah,0ah,0dh ; ���� ���� �س�

public _getch
_getch proc 
	mov ah,6
	int 21h        ;�����ж�
	ret
_getch endp

public _gets
_gets proc 
	mov ah,7
	int 21h        ;�����ж�
	ret
_gets endp

public _putch
_putch proc 
	mov ah,8
	int 21h        ;�����ж�
	ret
_putch endp

public _puts
_puts proc 
	mov ah,9
	int 21h        ;�����ж�
	ret
_puts endp

;public _scanf
;_scanf proc 
;	mov ah,0ah
;	int 21h
;	ret
;_scanf endp

public _printf
_printf proc 
	mov ah,0bh
	int 21h
	ret
_printf endp

_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start
