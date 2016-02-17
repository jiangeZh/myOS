extrn _Current_Process
extrn _Save_Process
extrn _Schedule
extrn _Have_Program
extrn _special
extrn _Program_Num
extrn _CurrentPCBno

;******************************************************
;          ʱ���жϴ������                           *

;******************************************************


Timer:
	push es
	push ax
	push bx
	mov ax,0B800h		; �ı������Դ���ʼ��ַ
	mov es,ax		; es = B800h
	mov ah,0Fh		; 0000���ڵס�1111�������֣�Ĭ��ֵΪ07h��
	dec byte ptr [count]		; �ݼ���������
	jnz goout2			; >0����ת
	inc word ptr [buffer]
	cmp word ptr [buffer],3
	jnz nonzero
	mov word ptr [buffer],0
nonzero:
	mov bx, word ptr [buffer]
	mov al, byte ptr [my_char+bx]
	mov es:[((80*12+39)*2)],ax
	mov byte ptr [count],delay		; ���ü�������=��ֵdelay
goout2:
	mov al,20h			; AL = EOI
	out 20h,al			; ����EOI����8529A
	out 0A0h,al			; ����EOI����8529A
	pop bx
	pop ax
	pop es
	iret			; ���жϷ���

;******************************************************
;         int 21hϵͳ����                           *

;******************************************************


syscall:
	cmp ah,0
	jnz _ah1
	jmp ah0
_ah1:
	cmp ah,1
	jnz _ah2
	jmp ah1
_ah2:
	cmp ah,2
	jnz _ah3
	jmp ah2
_ah3:
	cmp ah,3
	jnz _ah4
	jmp ah3
_ah4:
	cmp ah,4
	jnz _ah5
	jmp ah4
_ah5:
	cmp ah,5
	jnz _ah6
	jmp ah5
_ah6:
	cmp ah,6
	jnz _ah7
	jmp ah6
_ah7:
	cmp ah,7
	jnz _ah8
	jmp ah7
_ah8:
	cmp ah,8
	jnz _ah9
	jmp ah8
_ah9:
	cmp ah,9
	jnz _ah10
	jmp ah9
_ah10:
	cmp ah,0ah
	jnz _ah11
	jmp ah10
_ah11:
	cmp ah,0bh
	jnz _ah12
	jmp ah11

;return to myos
_ah12:
	cmp ah,0ch
	jnz _ah13
	jmp ah12

_ah13:
	cmp ah,0dh
	jnz _ah14
	jmp ah13

_ah14:
	cmp ah,0eh
	jnz _ah15
	jmp ah14

_ah15:
	cmp ah,0fh
	jmp _ah16
	jmp ah15

_ah16:
	cmp ah,10h
	jnz _ah17
	jmp ah16

_ah17:
	cmp ah,11h
	jnz _ah18
	jmp ah17

_ah18:
	cmp ah,12h
	jnz _ah19
	jmp ah18

_ah19:
	cmp ah,13h
	jmp ah19

ah0:
	mov ah,13h 		; BIOS�жϵĹ��ܺţ���ʾ�ַ�����
	mov al,1 		; ���ŵ���β������ֻ���ַ��ֽڣ�û�������ֽ�
	mov bh,0 		; ҳ��=0
	mov bl,0ch 		; �ַ���ɫ=������0���ڵף�000�����֣�1100��
	mov cx,4 		; ����
	mov dx,0a23h 		; ��ʾ������ʼλ�ã�0��0����DH=�кš�DL=�к�
	mov bp,offset ouch		; BP=����ƫ�Ƶ�ַ
	int 10h
	iret

	ouch: db "OUCH" 

ah1:
	mov si,dx
again1:	
	mov al,es:[si]
	cmp al,0
	jz end_ah1
	and al,	0dfh
	mov es:[si],al
	inc si
	jmp again1
end_ah1:
	iret

ah2:
	mov si,dx
again2:	
	mov al,es:[si]
	cmp al,0
	jz end_ah2
	or al,	20h
	mov es:[si],al
	inc si
	jmp again2
end_ah2:
	iret

ah3:
	push bx
	push cx
	push dx
	mov si,dx
	mov bh,0
	mov ax,0
again3:	
	mov cx,1
	mov bl,es:[si]
	cmp bl,0
	jz end_ah3
	sub bl,'0'
	mov dx,ax
mul10:
	inc cx
	add ax,dx 
	cmp cx,10
	jnz mul10

	add ax,bx
	inc si
	jmp again3
end_ah3:
	pop dx
	pop cx
	pop bx
	iret

ah4:
	push dx
	push bx
	call _intToStr
	pop bx
	pop dx
	iret

ah5:
	push cx
	mov bp,dx
	mov si,dx
	mov dx,cx
	mov cx,0
cnt:	
	mov al,es:[si]
	cmp al,0
	jz	next
	inc cx
	inc si
	jmp cnt
	
next:		
	mov ah,13h 		
	mov al,1 		
	mov bh,0 		
	mov bl,0ch 		; �ַ���ɫ=������0���ڵף�000�����֣�1100��
	int 10h
	pop cx
	iret

ah6:
	push bp
	push si
	push ax
	mov bp,sp
	mov si,word ptr [bp+2+2+2+2+2+2+2]
	mov ah,0
	int 16h
	mov byte ptr [si],al
	pop ax
	pop si
	pop bp
	iret

ah7:
	mov bp,sp
	mov si,[bp+2+2+2+2] 
	push si
	call _mygets
	pop si
	iret

ah8:
	push bp
	push ax
	push bx
	mov bp,sp
	mov al,byte ptr [bp+2+2+2+2+2+2+2] ;ch\IP
	mov ah,0eh 		; ���ܺ�
	mov bl,0 		; ���ı���ʽ��0
	int 10h
	pop bx
	pop ax
	pop bp
	iret

ah9:
	mov bp,sp
	mov si,[bp+2+2+2+2] 
	push si
	call _myputs
	pop si
	iret

ah10:
;	call _myscanf
	iret

ah11:
	push bp
	push si
	push ax
	push bx
	mov bp,sp
	add bp,16
	mov si,[bp]	;ָ��format�ַ������׵�ַ	
loop1:
	cmp byte ptr[si],0
	jz  end1
	cmp byte ptr[si],'%'
	jnz show
	;�ǰٷֺ�
	inc si
	cmp byte ptr[si],'c'
	jz  _c
	cmp byte ptr[si],'d'
	jz  _d
	cmp byte ptr[si],'s'
	jz  _s	
end1:
	pop bx
	pop ax
	pop si
	pop bp
	iret
_c:
	inc si
	push si
	add bp,2
	mov si,bp
	mov al,byte ptr[si]
	mov ah,0eh 		; ���ܺ�
	mov bl,0 		; ���ı���ʽ��0
	int 10h	
	pop si
	jmp loop1
_d:
	inc si	
	push si
	
	add bp,2
	mov si,bp
	mov ax,word ptr[si] ;AX��Ϊһ����������Ҫ��ʾ��ʮ����
	push ax
	call _showInt
	pop ax 
	pop si
	jmp loop1
_s:
	inc si
	push si
	add bp,2
	mov si,[bp]
	push bp
l:
	cmp byte ptr[si],0
	jz  end_s
	mov al,byte ptr[si]
	mov ah,0eh 		; ���ܺ�
	mov bl,0 		; ���ı���ʽ��0
	int 10h	
	inc si
	jmp l
end_s:	
	pop bp
	pop si
	jmp loop1
show:
	mov al,[si]
	mov ah,0eh 		; ���ܺ�
	mov bl,0 		; ���ı���ʽ��0
	int 10h	
	inc si
	jmp loop1
	iret

ah12:
	mov ah,13h 	
	mov al,1 	
	mov bl,0fh 
	mov bh,0 	
	mov dh,06h 	
	mov dl,0 		
	mov bp,offset return 	
	mov cx,31 		
	int 10h 	
Keyin: 	
	mov ah,0 		
	int 16h 		
	cmp al,1bh 		
	je  goout	
	jmp Keyin 
goout:
	iret

return:  
	db "Please Key in Esc to quit."
	db 7,7,0ah,0ah,0dh ; ���� ���� �س�

extrn _do_fork:near
extrn _do_wait:near
extrn _do_exit:near

;fork()
ah13:
	cli
	push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086
	mov ax,cs
	mov ds, ax
	mov es, ax
	call near ptr _Save_Process
	call near ptr _do_fork
	sti
;Restart
	jmp Pre

;exit(int)
ah14:
	cli
	mov ax,cs
	mov ds,ax
	mov es,ax
	push dx
	call near ptr _do_exit
	pop dx
	sti
	jmp Pre

;wait()
ah15:
	cli
	push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086
	mov ax,cs
	mov ds, ax
	mov es, ax
	call near ptr _Save_Process
	call near ptr _do_wait
	sti
	jmp Pre

extrn _do_p:near
extrn _do_v:near
extrn _do_getSem:near
extrn _do_freeSem:near

;p
ah16:
	cli
	push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086
	push dx
	mov ax,cs
	mov ds, ax
	mov es, ax
	pop dx
	call near ptr _Save_Process
	push dx
	call near ptr _do_p
	pop dx
	sti
	jmp Pre

;v
ah17:
	push ds
	push es
	push bp
	push ax
	push dx
	mov ax,cs
	mov ds, ax
	mov es, ax
	call near ptr _do_v
	pop dx
	pop ax
	pop bp
	pop es
	pop ds
	iret

;getsem
ah18:
	push ds
	push es
	push bp
	push dx
	mov ax,cs
	mov ds, ax
	mov es, ax
	call near ptr _do_getSem
	pop dx
	pop bp
	pop es
	pop ds
	iret

;freesem
ah19:
	push ds
	push es
	push bp
	push ax
	mov ax,cs
	mov ds, ax
	mov es, ax
	push dx
	call near ptr _do_freeSem
	pop dx
	pop ax
	pop bp
	pop es
	pop ds
	iret

;Finite dw 0
	
Pro_Timer:
    	cmp word ptr[_Program_Num],0
	jnz Save
	jmp No_Progress
Save:
	;inc word ptr[Finite]
	;cmp word ptr[Finite],2000
	;jnz Lee 
    	;mov word ptr[_CurrentPCBno],0
	;mov word ptr[Finite],0
	;mov word ptr[_Program_Num],0
	;jmp Pre
Lee:
    	push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
	call near ptr _Schedule 
	
Pre:
	mov ax, cs
	mov ds, ax
	mov es, ax
	
	call near ptr _Current_Process
	mov bp, ax

	mov ss,word ptr ds:[bp+0]         
	mov sp,word ptr ds:[bp+16] 

	cmp word ptr ds:[bp+32],0 ;NEW
	jnz Not_First_Time

;*****************************************
;*                Restart                *
; ****************************************
Restart:
        call near ptr _special
	
	push word ptr ds:[bp+30]
	push word ptr ds:[bp+28]
	push word ptr ds:[bp+26]
	
	push word ptr ds:[bp+2]
	push word ptr ds:[bp+4]
	push word ptr ds:[bp+6]
	push word ptr ds:[bp+8]
	push word ptr ds:[bp+10]
	push word ptr ds:[bp+12]
	push word ptr ds:[bp+14]
	push word ptr ds:[bp+18]
	push word ptr ds:[bp+20]
	push word ptr ds:[bp+22]
	push word ptr ds:[bp+24]

	pop ax
	pop cx
	pop dx
	pop bx
	pop bp
	pop si
	pop di
	pop ds
	pop es
	.386
	pop fs
	pop gs
	.8086

	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret

Not_First_Time:	
	add sp,16 
	jmp Restart
	
No_Progress:
  	xor ax,ax			; AX = 0
	mov es,ax			; ES = 0
	mov word ptr es:[20h],offset Timer	; ����ʱ���ж�������ƫ�Ƶ�ַ
	mov ax,cs 
	mov word ptr es:[22h],ax		; ����ʱ���ж������Ķε�ַ=CS
	
	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret


;******************************************************
;          int 34,35,36,37                            *

;******************************************************


int_34:
	pushf
	push ax
	push bx
	push cx
	push dx
	push es
	push bp
	mov ax,cs
	mov es,ax
	mov ah,13h 		; BIOS�жϵĹ��ܺţ���ʾ�ַ�����
	mov al,1 		; ���ŵ���β������ֻ���ַ��ֽڣ�û�������ֽ�
	mov bh,0 		; ҳ��=0
	mov bl,0ch 		; �ַ���ɫ=������0���ڵף�000�����֣�1100��
	mov cx,18
	mov dx,0302h 		; ��ʾ������ʼλ�ã�0��0����DH=�кš�DL=�к�
	mov bp,offset str34		; BP=����ƫ�Ƶ�ַ
	int 10h
	pop bp
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	popf
	iret			; ���жϷ���

int_35:
	push ax
	push bx
	push cx
	push dx
	push es
	push bp
	mov ax,cs
	mov es,ax
	mov ah,13h 		; BIOS�жϵĹ��ܺţ���ʾ�ַ�����
	mov al,1 		; ���ŵ���β������ֻ���ַ��ֽڣ�û�������ֽ�
	mov bh,0 		; ҳ��=0
	mov bl,0ch 		; �ַ���ɫ=������0���ڵף�000�����֣�1100��
	mov cx,18
	mov dx,032fh 		; ��ʾ������ʼλ�ã�0��0����DH=�кš�DL=�к�
	mov bp,offset str35		; BP=����ƫ�Ƶ�ַ
	int 10h
	pop bp
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	iret			; ���жϷ���

int_36:
	push ax
	push bx
	push cx
	push dx
	push es
	push bp
	mov ax,cs
	mov es,ax
	mov ah,13h 		; BIOS�жϵĹ��ܺţ���ʾ�ַ�����
	mov al,1 		; ���ŵ���β������ֻ���ַ��ֽڣ�û�������ֽ�
	mov bh,0 		; ҳ��=0
	mov bl,0ch 		; �ַ���ɫ=������0���ڵף�000�����֣�1100��
	mov cx,18
	mov dx,0f02h 		; ��ʾ������ʼλ�ã�0��0����DH=�кš�DL=�к�
	mov bp,offset str36		; BP=����ƫ�Ƶ�ַ
	int 10h 	
	pop bp
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	iret			; ���жϷ���

int_37:
	push ax
	push bx
	push cx
	push dx
	push es
	push bp
	mov ax,cs
	mov es,ax
	mov ah,13h 		; BIOS�жϵĹ��ܺţ���ʾ�ַ�����
	mov al,1 		; ���ŵ���β������ֻ���ַ��ֽڣ�û�������ֽ�
	mov bh,0 		; ҳ��=0
	mov bl,0ch 		; �ַ���ɫ=������0���ڵף�000�����֣�1100��
	mov cx,18
	mov dx,0f2fh 		; ��ʾ������ʼλ�ã�0��0����DH=�кš�DL=�к�
	mov bp,offset str37		; BP=����ƫ�Ƶ�ַ
	int 10h 	
	pop bp
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	iret			; ���жϷ���

;******************************************************
;        �û��ӳ���                                   *

;******************************************************


public _do1
_do1 proc

	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push ss
	push bp
	mov word ptr [pro+2], SegOfUserPrg1
	call dword ptr pro	
	pop bp
	pop ss
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_do1 endp


public _do2
_do2 proc
	
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push ss
	push bp
	mov word ptr [pro+2], SegOfUserPrg2
	call dword ptr pro	
	pop bp
	pop ss
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_do2 endp


public _do3
_do3 proc
	
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push ss
	push bp
	mov word ptr [pro+2], SegOfUserPrg3
	call dword ptr pro	
	pop bp
	pop ss
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_do3 endp


public _do4
_do4 proc
	
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push ss
	push bp
	mov word ptr [pro+2], SegOfUserPrg4
	call dword ptr pro	
	pop bp
	pop ss
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_do4 endp


public _do5
_do5 proc
	
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push ss
	push bp
	mov word ptr [pro+2], SegOfUserPrg5
	call dword ptr pro	
	pop bp
	pop ss
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_do5 endp


public _do6
_do6 proc
	
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push ss
	push bp
	mov word ptr [pro+2], SegOfUserPrg6
	call dword ptr pro
	pop bp
	pop ss
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_do6 endp


public _do7
_do7 proc
	
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push ss
	push bp
	mov word ptr [pro+2], SegOfUserPrg7
	call dword ptr pro	
	pop bp
	pop ss
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_do7 endp


public _do8
_do8 proc
	
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push ss
	push bp
	mov word ptr [pro+2], SegOfUserPrg8
	call dword ptr pro	
	pop bp
	pop ss
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_do8 endp



public _do9
_do9 proc
	
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push ss
	push bp
	mov word ptr [pro+2], SegOfUserPrg9
	call dword ptr pro	
	pop bp
	pop ss
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_do9 endp



;****************************

; void _cls()               *

;****************************


public _cls

_cls proc 
; ����
        
	push ax
        
	push bx
        
	push cx
        
	push dx		
			
	mov	ax, 600h	; AH = 6,  AL = 0
			
	mov	bx, 700h	; �ڵװ���(BL = 7)
			
	mov	cx, 0		; ���Ͻ�: (0, 0)
			
	mov	dx, 184fh	; ���½�: (24, 79)
				
	int	10h		; ��ʾ�ж�
		
	pop dx
		
	pop cx
		
	pop bx
		
	pop ax
        
	mov [_disp_pos],0
		
ret

_cls endp




; ========================================================================

;  void _printf(char * pszInfo,int pos,int size);

; ========================================================================

Public	_printf

_printf proc
	
	push	bp         ;sp+2
	
	push	es         ;sp+2+2
	
	push    ax         ;sp+2+2+2
 
	push    bx
	push	cx
	push	dx
	push 	si
	mov ax,cs 
	mov es,ax
	mov ax,1301h 		; AH=BIOS�жϵĹ��ܺš�AL=1��ʾ���ŵ���β
	mov bx,000ah 		; BH=ҳ�š�BL=��ɫ���ڵ������֣�
	mov bp,sp
	mov cx,word ptr [bp+2+2+2+2+2+2+2+2+2+2]
	mov dx,word ptr [bp+2+2+2+2+2+2+2+2+2] 	; ��ʾ������ʼλ�ã�DH=�кš�DL=�к�
	mov si,word ptr [bp+2+2+2+2+2+2+2+2]
	mov bp,si
	int 10h 		; ����10H����ʾ�ж�
	pop si	
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop es
	
	pop bp
	
ret

_printf endp


; ========================================================================

;  void _getch(char &ch);

; ========================================================================
public _getch
_getch proc 
	mov ah,6
	int 21h        ;�����ж�
	ret
_getch endp

; ========================================================================

;  void _gets(char str[]);

; ========================================================================

public _gets
_gets proc 
	mov ah,7
	int 21h        ;�����ж�
	ret
_gets endp

; ========================================================================

;  void _putch(char ch);

; ========================================================================
public _putch
_putch proc 
	mov ah,8
	int 21h        ;�����ж�
	ret
_putch endp

; ========================================================================

;  void _puts(char str[]);

; ========================================================================
public _puts
_puts proc 
	mov ah,9
	int 21h        ;�����ж�
	ret
_puts endp

; ========================================================================

;  void _time();

; ========================================================================

Public	_time
_time proc
	
	push	bp         	
	push    ax        
	push    bx
	push	cx
	push	dx

       mov ah,04h           ;ȡ����
       int 1ah			;21�Ų����ã�
       mov si,0
       mov al,ch
       call BCDASC1         ;������ֵת������Ӧ��ASCII���ַ�
       mov al,cl
       call BCDASC1
       inc si
       mov al,dh
       call BCDASC1
       inc si
       mov al,dl
       call BCDASC1
       mov bp,offset dbuffer1
       mov dx,0c1dh
       mov cx,20
       mov bx,000ah
       mov ax,1301h
       int 10h

	pop dx
	pop cx
	pop bx
	pop ax
		
	pop bp
	
ret

_time endp


BCDASC1 PROC NEAR              ;������ֵת����ASCII���ַ��ӳ���
       push bx
       cbw
       mov bl,16
       div bl
       add al,'0'
       mov DBUFFER1[SI],AL
       inc si
       add ah,'0'
       mov DBUFFER1[SI],AH
       inc si
       pop bx
       ret
BCDASC1 ENDP

public _printf2
_printf2 proc 
	mov ah,0bh
	int 21h
	ret
_printf2 endp

SetTimer: 
    push ax
    mov al,34h   ; �������ֵ 
    out 43h,al   ; д�����ֵ������ּĴ��� 
    mov ax,29830 ; ÿ�� 20 ���жϣ�50ms һ�Σ� 
    out 40h,al   ; д������ 0 �ĵ��ֽ� 
    mov al,ah    ; AL=AH 
    out 40h,al   ; д������ 0 �ĸ��ֽ� 
	pop ax
	ret


;*****************************************
;*            setClock                   *
; ****************************************
public _setClock
_setClock proc
    	push ax
	push bx
	push cx
	push dx
	push ds
	push es
	
    	call SetTimer
   	 xor ax,ax
	mov es,ax
	mov word ptr es:[20h],offset Pro_Timer
	mov ax,cs
	mov word ptr es:[22h],cs
	
	pop ax
	mov es,ax
	pop ax
	mov ds,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_setClock endp

public _stackcopy
_stackcopy proc
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	push di	
	push si

	mov ax,[bp+4]
	mov es,ax
	mov ds,ax
	mov ax,[bp+6]
	mov si,ax
	add ax,1000h
	mov di,ax
	mov cx,100h
	cld
	rep movsw

	pop si
	pop di
	pop ds
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret
_stackcopy endp



;*****************************************
;* void load(int seg,int num, int i)  *
; ****************************************
public _load
_load proc
    	push ax
	push bp	
	mov bp,sp	
	
    	mov ax,[bp+6]	
	mov es,ax          	;���öε�ַ������ֱ��mov es,�ε�ַ��
	mov bx,100h       	;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
	mov ah,2           	;���ܺ�
	mov al,[bp+8]          	;������	
	mov dl,0          	;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
	mov dh,0          	;��ͷ�� ; ��ʼ���Ϊ0
	mov ch,0          	;����� ; ��ʼ���Ϊ0
	mov cl,[bp+10]       ;��ʼ������ ; ��ʼ���Ϊ1
	cmp cl,18
	jna  na			;С�ڵ���ת��
	inc dh
	sub cl,18	
na:	
	int 13H          	; �����ж�
	
	pop bp
	pop ax
	
	ret
_load endp