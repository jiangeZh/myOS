;读入，显示字符

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
	mov ah,13h 	; 功能号
	mov al,1 	
	mov bl,0fh 	
	mov bh,0 		; 第0页
	mov dh,6h 	
	mov dl,0 		; 第0列
	mov bp,offset BootMsg 	; BP=串地址
	mov cx,31 		; 串长为44个字符（串 + 响铃 换行 回车）
	int 10h 	
	ret
Keyin: 
	mov ah,0 		; 功能号
	int 16h 		

	cmp al,1bh 	; 比较AL中的键入字符与ESC字符（ASCII码为1BH）
	je goout		; 相等跳转到“退出”标号处

; 循环读显按键
	jmp Keyin 		; 跳转到前面的“读按键”标号处
goout: 
	ret

BootMsg: ; 字符串
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