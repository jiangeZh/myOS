.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT,_DATA,_BSS
       assume cs:_TEXT	


delay  equ 30000		
ddelay equ 300		     ; 总延迟=30000*500	
count dw 30000
dcount dw 300		

org 100h   		
	
start:	
    	mov ax,cs
	mov es,ax
	mov ds,ax
	mov ss,ax
	mov word ptr [count],delay
	mov word ptr [dcount],ddelay	
	mov bp, sp
	mov sp,0
	push bp
	mov cx,0		
begin:	
	inc cx
	cmp cx,25
	jnz show
	mov cx,24
	mov ax,offset Cls
	mov bp,ax
	mov ah,13h 		
	mov al,1 		
	mov bh,0 		
	mov bl,0ch 		
	mov dx,120eh 				
	int 10h 
	mov cx,1
show:
	dec word ptr [count]		; 递减计数变量
	jnz show				
	mov word ptr [count],delay
	dec word ptr [dcount]
	jnz show
	mov word ptr [dcount],ddelay	

	mov ax,offset Msg
	mov bp,ax
	mov ah,13h 		
	mov al,1 		
	mov bh,0 		
	mov bl,0dh 		; 字符颜色
	mov dx,120eh 		; 显示串的起始位置（0，0）：DH=行号、DL=列号		
	int 10h 
	jmp begin

goout:
	pop sp
	mov ax,0
	mov ss,ax
	retf

Msg:
	db "Hello,I'm Zhang Huajian!"
Cls:
	db "                        "

_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start