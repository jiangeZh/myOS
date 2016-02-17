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
	mov ax,0
	mov ah,0
	int 21h
	mov dx,offset msg1
	mov ah,1
	int 21h
	mov ah,5
	mov cx,0
	int 21h

	mov dx,offset msg2
	mov ah,2
	int 21h
	mov ah,5
	mov cx,100h
	int 21h

	mov dx,offset msg3
	mov ah,3
	int 21h

	mov bx,ax
	mov ah,4
	mov dx,offset msg3
	int 21h
	mov ah,5
	mov dx,offset msg3
	mov cx,200h
	int 21h

	call DispStr
	call Keyin	
	pop sp
	mov ax,0
	mov ss,ax
	retf

msg1:	db "smalltobig",0	
msg2:	db "BIGTOSMALL",0
msg3:   db "12345",0

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



_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start
