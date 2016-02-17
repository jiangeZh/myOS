    org 100h		     ;��������������

Dn_    equ 1                  ;Dn-Down,U-Up,Rt-right,Lt-Left
Rt_    equ 2                  ;
Lt_    equ 3                  ;
Up_    equ 4
delay  equ 30000		
ddelay equ 500		     ; ���ӳ�=30000*500		
				
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
	mov bl,0ah 		; �ַ���ɫ
	mov cx,19 		; ����
	mov dx,060eh 		; ��ʾ������ʼλ�ã�0��0����DH=�кš�DL=�к�		
	int 10h 
	jmp loop

BootMsg: 
	db "This is my program." ; ��ʾ�õ��ַ���	

loop:
	dec word[count]		; �ݼ���������
	jnz loop				
	mov word[count],delay
	dec word[dcount]
	jnz loop
	mov word[dcount],ddelay	

    	mov al,1
    	cmp al,byte[rdul]    	;rdul��ʾ�н�����
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
	inc word[x]		;���˶�
	mov bx,word[x]
	mov ax,13
	sub ax,bx
	jz  d2r		
	jmp show		;�������߽磬��ʾ
d2r:				;���ҷ���
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
    	xor ax,ax                 ; �����Դ��ַ
    	mov ax,word[x]		  ;ax = x
	mov bx,80		  ;bx = 80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	mov ah,0ch			; �ڵ�������
	mov al,byte[char]		;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov word[es:bp],ax  		;  ��ʾ�ַ���ASCII��ֵ
	pop es
	jmp loop
	

datadef:	
	count dw delay
	dcount dw ddelay
    	rdul db Dn_         ; �����˶�
    	x dw 0
	y dw 0
	char db 'A'