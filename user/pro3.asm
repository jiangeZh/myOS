;读入，显示字符

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
	mov bl,0ah 		; 字符颜色
	mov cx,25 		; 串长
	mov dx,020h 		; 显示串的起始位置（0，0）：DH=行号、DL=列号
	mov bp,offset BootMsg1		
	int 10h 
	
	mov ah,13h 	; 功能号
	mov al,1 	
	mov bl,0fh 	; 黑底白字
	mov bh,0 		; 第0页
	mov dh,6h 	
	mov dl,0 		; 第0列
	mov bp,offset BootMsg2 	; BP=串地址
	mov cx,31 		; 串长为44个字符（串 + 响铃 换行 回车）
	int 10h 	
	jmp DispStr

BootMsg1: 
	db "This is my third program." ; 显示用的字符串	

BootMsg2: ; 字符串
	db "Please Key in Esc to quit."
	db 7,7,0ah,0ah,0dh ; 响铃 换行 回车

_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start