
.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT,_DATA,_BSS
       assume cs:_TEXT

org 7c00h 		; 告诉编译器程序加载到7C00H处
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
	mov bx,7e00h ; ES:BX=读入数据到内存中的存储地址
	mov ah,2 		; 功能号
	mov al,10 		; 要读入的扇区数
	mov dl,0 		; 软盘驱动器号（对硬盘和U盘，此处的值应改为80H）
	mov dh,0 		; 磁头号
	mov ch,0 		; 柱面号
	mov cl,2 		; 起始扇区号（编号从1开始）
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