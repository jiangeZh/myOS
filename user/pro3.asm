;���룬��ʾ�ַ�

.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT,_DATA,_BSS
       assume cs:_TEXT

org 0b000h 	
start:	
	mov ax,cs 		
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov sp,0b000h-4
DispStr:
	mov ah,13h 		
	mov al,1 		
	mov bh,0 		
	mov bl,0ah 		; �ַ���ɫ
	mov cx,25 		; ����
	mov dx,020h 		; ��ʾ������ʼλ�ã�0��0����DH=�кš�DL=�к�
	mov bp,offset BootMsg1		
	int 10h 
	
	mov ah,13h 	; ���ܺ�
	mov al,1 	
	mov bl,0fh 	; �ڵװ���
	mov bh,0 		; ��0ҳ
	mov dh,6h 	
	mov dl,0 		; ��0��
	mov bp,offset BootMsg2 	; BP=����ַ
	mov cx,31 		; ����Ϊ44���ַ����� + ���� ���� �س���
	int 10h 	
	jmp DispStr

BootMsg1: 
	db "This is my third program." ; ��ʾ�õ��ַ���	

BootMsg2: ; �ַ���
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