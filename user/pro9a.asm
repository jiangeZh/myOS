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
	mov sp, 100h
	push bp
	mov ah,13h 	
	mov al,1 	
	mov bl,0fh 
	mov bh,0 	
	mov dh,0 	
	mov dl,0 		
	mov bp,offset begn 	
	mov cx,28 		
	int 10h 
	mov ah,0
	int 16h	
	call _main
	mov ah,0
	int 16h
	pop sp
	mov ax,0
	mov ss,ax
	retf

begn:
	db "Press any key to begin."
	db 7,7,0ah,0ah,0dh ; œÏ¡Â ªª–– ªÿ≥µ

public _printf
_printf proc 
	mov ah,0bh
	int 21h
	ret
_printf endp

public _fork
_fork proc 
	cli
	mov ah,0dh
	int 21h
	sti
	ret
_fork endp


public _wait
_wait proc 
	cli
	push ax
	push bp
	push dx
	mov bp,sp
	mov dx,[bp+8]
	mov ah,0fh
	int 21h
	pop dx
	pop bp
	pop ax
	sti
	ret
_wait endp

public _exit
_exit proc 
	mov ah,0eh
	int 21h
	ret
_exit endp


public _p
_p proc 
	cli
	push ax
	push bp
	push dx
	mov bp,sp
	mov dx,[bp+8]
	mov ah,10h
	int 21h
	pop dx
	pop bp
	pop ax
	sti
	ret
_p endp


public _v
_v proc 
	cli
	push ax
	push bp
	push dx
	mov bp,sp
	mov dx,[bp+8]
	mov ah,11h
	int 21h
	pop dx
	pop bp
	pop ax
	sti
	ret
_v endp

public _getSem
_getSem proc 
	cli
	push bp
	push dx
	mov bp,sp
	mov dx,[bp+6]
	mov ah,12h
	int 21h
	pop dx
	pop bp
	sti
	ret
_getSem endp

public _freeSem
_freeSem proc 
	cli
	push ax
	push bp
	push dx
	mov bp,sp
	mov dx,[bp+8]
	mov ah,13h
	int 21h
	pop dx
	pop bp
	pop ax
	sti
	ret
_freeSem endp

_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start
