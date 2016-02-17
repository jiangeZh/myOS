;���룬��ʾ�ַ�

.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT,_DATA,_BSS
       assume cs:_TEXT

org 100h 	
start:	
	mov ax,cs 		
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov bp,sp
	mov sp,0
	push bp
	int 34
	int 35
	int 36
	int 37
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
	mov ah,0 		; ���ܺ�
	int 16h 		

	cmp al,1bh 	; �Ƚ�AL�еļ����ַ���ESC�ַ���ASCII��Ϊ1BH��
	je goout		; �����ת�����˳�����Ŵ�

; ѭ�����԰���
	jmp Keyin 		; ��ת��ǰ��ġ�����������Ŵ�
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