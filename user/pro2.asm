    org 100h		     ;软盘引导区启动

Dn_    equ 1                  ;Dn-Down,U-Up,Rt-right,Lt-Left
Rt_    equ 2                  ;
Lt_    equ 3                  ;
Up_    equ 4
delay  equ 30000		
ddelay equ 500		     ; 总延迟=30000*500		
				
start:
	
    	mov ax,cs
	mov es,ax
	mov ds,ax
	mov ss,ax
	mov sp,0					
    	mov byte[char],'A'
	mov word[x],0
	mov word[y],0
	mov byte[rdul],Dn_

begin:	
	mov ax,BootMsg
	mov bp,ax
	mov ah,13h 		
	mov al,1 		
	mov bh,0 		
	mov bl,0ah 		; 字符颜色
	mov cx,19 		; 串长
	mov dx,060eh 		; 显示串的起始位置（0，0）：DH=行号、DL=列号		
	int 10h 
	jmp loop

BootMsg: 
	db "This is my program." ; 显示用的字符串	

loop:
	dec word[count]		; 递减计数变量
	jnz loop				
	mov word[count],delay
	dec word[dcount]
	jnz loop
	mov word[dcount],ddelay	

    	mov al,1
    	cmp al,byte[rdul]    	;rdul表示行进方向
	jz  Dn
	mov al,2
    	cmp al,byte[rdul]    
	jz  Rt
    	mov al,3
    	cmp al,byte[rdul]    
	jz  Lt
	mov al,4
    	cmp al,byte[rdul]    
	jz  Up
    	jmp $	

end:
	ret

Dn:
	inc word[x]		;下运动
	mov bx,word[x]
	mov ax,13
	sub ax,bx
	jz  d2r		
	jmp show		;不碰到边界，显示
d2r:				;往右反弹
    	inc word[y]		
    	mov byte[rdul],Rt_	
    	jmp show

Rt:
	inc word[y]
	mov bx,word[y]
	mov ax,40
	sub ax,bx
	jz  r2u
	jmp show
r2u:
    	dec word[x]
    	mov byte[rdul],Up_	
    	jmp show

Up:
	dec word[x]
	mov bx,word[x]
	mov ax,0
	sub ax,bx
	jz  u2l
	jmp show
u2l:
    	dec word[y]
    	mov byte[rdul],Lt_	
    	jmp show
Lt:
	dec word[y]
	mov bx,word[y]
	mov ax,0
	sub ax,bx
    	jz  l2d	
	jmp show

l2d:
	inc word[x]
    	mov byte[rdul],Dn_
	mov al, byte[char]
	cmp al, 'Z'
	jnz change
	mov byte[char],'A'-1
change:
	inc byte[char]
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
    	rdul db Dn_         ; 向下运动
    	x dw 0
	y dw 0
	char db 'A'