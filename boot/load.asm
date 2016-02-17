
.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT,_DATA,_BSS
       assume cs:_TEXT

org 7c00h 		; ���߱�����������ص�7C00H��
start:
	mov ax,cs 
	mov ds,ax
	mov es,ax
	call Read
	mov ax,7e00h
	jmp ax
Read: 
	mov ax,0
	mov es,ax 		
	mov bx,7e00h ; ES:BX=�������ݵ��ڴ��еĴ洢��ַ
	mov ah,2 		; ���ܺ�
	mov al,10 		; Ҫ�����������
	mov dl,0 		; �����������ţ���Ӳ�̺�U�̣��˴���ֵӦ��Ϊ80H��
	mov dh,0 		; ��ͷ��
	mov ch,0 		; �����
	mov cl,2 		; ��ʼ�����ţ���Ŵ�1��ʼ��
	int 13H 		
	ret 			

_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start