    org 100h

Dn_    equ 1                  ;Dn-Down,U-Up,Rt-right,Lt-Left
Up_Rt  equ 2                  ;
Lt_    equ 3                  ;
delay  equ 30000		     ; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
ddelay equ 300		     ; ���ӳ�=50000*500		
stop   equ 300

dw 0,0
cnt dw 0
				
start:
	;����ԭ�ж�
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
	; ���ü����ж�������09h������ʼ���μĴ���
	xor ax,ax			; AX = 0
	mov es,ax			; ES = 0
	mov word[es:24h],Key	; �����ж�������ƫ�Ƶ�ַ
	mov ax,cs 
	mov word[es:26h],ax		; �����ж������Ķε�ַ=CS
	
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

; �����жϴ������
Key:
	mov dx,60h
	in al,dx
	mov ah,13h 		; BIOS�жϵĹ��ܺţ���ʾ�ַ�����
	mov al,1 		; ���ŵ���β������ֻ���ַ��ֽڣ�û�������ֽ�
	mov bh,0 		; ҳ��=0
	mov bl,0ch 		; �ַ���ɫ=������0���ڵף�000�����֣�1100��
	mov cx,word[cnt]
	mov dx,0a23h 		; ��ʾ������ʼλ�ã�0��0����DH=�кš�DL=�к�
	mov bp,BootMsg3		; BP=����ƫ�Ƶ�ַ
	int 10h 
	
	inc word[cnt]
	cmp word[cnt],11
	jnz nnext
	mov word[cnt],0
nnext:
	mov al,20h			; AL = EOI
	out 20h,al			; ����EOI����8529A
	out 0A0h,al			; ����EOI����8529A
	iret			; ���жϷ���


begin:	;��ʾѧ�ţ�����
	mov ax,BootMsg
	mov bp,ax 		; ES:BP=����ַ
	mov cx,21 		; CX=����
	mov ax,1301h 		; AH=BIOS�жϵĹ��ܺš�AL=1��ʾ���ŵ���β
	mov bx,0ch 		; BH=ҳ�š�BL=��ɫ���ڵ������֣�
	mov dx,0 		; ��ʾ������ʼλ�ã�DH=�кš�DL=�к�
	int 10h 		; ����10H����ʾ�ж�

BootMsg: ; �����ַ���
	db "13349152 zhanghuajian"

loop:
	dec word[count]		; �ݼ���������
	jnz loop				
	mov word[count],delay
	dec word[dcount]
	jnz loop
	mov word[dcount],ddelay	

	dec word[ddcount]
	jz  myend

    	mov al,1
    	cmp al,byte[rdul]    	;rdul��ʾ�н�����
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
	inc word[x]		;���˶�
	mov bx,word[x]
	mov ax,25
	sub ax,bx
	jz  dr2ur			;x=25,��ʾ��������ʾ25��
	jmp show		;�������߽磬��ʾ
dr2ur:				;�����ϽǷ���
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
	ddcount dw stop
    	rdul db Dn_         ; �����˶�
    	x dw 1
	y dw 0
	char db 'A'