    org 100h

Dn_    equ 1                  ;Dn-Down,U-Up,Rt-right,Lt-Left
Up_Rt  equ 2                  ;
Lt_    equ 3                  ;
delay  equ 30000		     ; 计时器延迟计数,用于控制画框的速度
ddelay equ 300		     ; 总延迟=50000*500		
stop   equ 300

dw 0,0
cnt dw 0
				
start:
	;保存原中断
	mov ax,cs
	mov ds,ax
	mov bp,sp
	mov ss,ax
	mov sp,0	
	push bp	
	xor ax,ax 
	mov es,ax
	push  word[es:9*4]
	pop word[ds:100h]
	push  word[es:9*4+2]
	pop word[ds:102h]
	; 设置键盘中断向量（09h），初始化段寄存器
	xor ax,ax			; AX = 0
	mov es,ax			; ES = 0
	mov word[es:24h],Key	; 设置中断向量的偏移地址
	mov ax,cs 
	mov word[es:26h],ax		; 设置中断向量的段地址=CS
	
    	mov ax,cs
	mov es,ax
	mov ds,ax
    	mov byte[char],'A'
	mov word[ddcount],stop	
	mov word[x],1
	mov word[y],0
	mov byte[rdul],Dn_
	mov word[cnt],0
	jmp begin
BootMsg3:
	db "OUCH!OUCH!"

; 键盘中断处理程序
Key:
	mov dx,60h
	in al,dx
	mov ah,13h 		; BIOS中断的功能号（显示字符串）
	mov al,1 		; 光标放到串尾，串中只有字符字节，没有属性字节
	mov bh,0 		; 页号=0
	mov bl,0ch 		; 字符颜色=不闪（0）黑底（000）红字（1100）
	mov cx,word[cnt]
	mov dx,0a23h 		; 显示串的起始位置（0，0）：DH=行号、DL=列号
	mov bp,BootMsg3		; BP=串的偏移地址
	int 10h 
	
	inc word[cnt]
	cmp word[cnt],11
	jnz nnext
	mov word[cnt],0
nnext:
	mov al,20h			; AL = EOI
	out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
	iret			; 从中断返回


begin:	;显示学号，姓名
	mov ax,BootMsg
	mov bp,ax 		; ES:BP=串地址
	mov cx,21 		; CX=串长
	mov ax,1301h 		; AH=BIOS中断的功能号、AL=1表示光标放到串尾
	mov bx,0ch 		; BH=页号、BL=颜色（黑底亮红字）
	mov dx,0 		; 显示串的起始位置：DH=行号、DL=列号
	int 10h 		; 调用10H号显示中断

BootMsg: ; 引导字符串
	db "13349152 zhanghuajian"

loop:
	dec word[count]		; 递减计数变量
	jnz loop				
	mov word[count],delay
	dec word[dcount]
	jnz loop
	mov word[dcount],ddelay	

	dec word[ddcount]
	jz  myend

    	mov al,1
    	cmp al,byte[rdul]    	;rdul表示行进方向
	jz  Dn
	mov al,2
    	cmp al,byte[rdul]    
	jz  UpRt
    	mov al,3
    	cmp al,byte[rdul]    
	jz  Lt
    	jmp $	

myend:
	mov ax,0
	mov es,ax
	cli
	push word[ds:100h]
	pop word[es:9*4]
	push word[ds:102h]
	pop word[es:9*4+2]
	sti
	pop sp
	mov ax,0
	mov ss,ax
	retf


Dn:
	inc word[x]		;下运动
	mov bx,word[x]
	mov ax,25
	sub ax,bx
	jz  dr2ur			;x=25,显示器可以显示25行
	jmp show		;不碰到边界，显示
dr2ur:				;往右上角反弹
    	mov word[x],23
    	inc word[y]		
    	mov byte[rdul],Up_Rt	
    	jmp show

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,80
	sub ax,bx
	jz  ur2ul
	mov bx,word[x]
	mov ax,0
	sub ax,bx
    	jz  ur2dr
	jmp show
ur2ul:
    	mov word[y],78
    	inc word[x]
    	mov byte[rdul],Lt_	
    	jmp show
ur2dr:
    	mov word[x],2
    	dec word[y]
    	mov byte[rdul],Dn_	
    	jmp show
	
Lt:
	dec word[y]
	mov bx,word[y]
	mov ax,0
	sub ax,bx
    	jz  ul2ur	
	jmp show

ul2ur:
	mov word[y],1
    	mov byte[rdul],Up_Rt	
    	jmp show
	
show:	
	push es
	mov ax,0B800h
	mov es,ax
    	xor ax,ax                 ; 计算显存地址
    	mov ax,word[x]		  ;ax = x
	mov bx,80		  ;bx = 80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	mov ah,0ch			; 黑底亮红字
	mov al,byte[char]		;  AL = 显示字符值（默认值为20h=空格符）
	mov word[es:bp],ax  		;  显示字符的ASCII码值
	pop es
	jmp loop
	

datadef:	
	count dw delay
	dcount dw ddelay
	ddcount dw stop
    	rdul db Dn_         ; 向下运动
    	x dw 1
	y dw 0
	char db 'A'