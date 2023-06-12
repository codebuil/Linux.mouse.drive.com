bits 32
org 101000h
mov eax,21cd4cffh
mov ax,0
mov ds,ax
mov ax,01720h
mov ebx,0b8000h
mov ecx,2000
call fill16

    ; Configurar a porta COM1 (serial)
    mov dx, 0x3F8    ; Endereço da porta COM1
    mov al, 0x80     ; Habilitar divisor de frequência (DLAB = 1)
    out dx, al       ; Enviar comando de configuração
    mov al, 0x03     ; Divisor de frequência: 3 (baud rate 38400 bps)
    out dx, al       ; Enviar divisor de frequência
    mov al, 0x03     ; Configurar para 8 bits de dados, sem paridade, 1 stop bit
    out dx, al       ; Enviar configuração
    
    ; Loop principal
  mov edx,12
mov ecx,40
call sets  
main_loop:
    push edx
    mov dx, 0x3F8    ; Endereço da porta COM1
    in al, dx        ; Ler byte da porta COM1
    pop edx    
    ; Verificar o movimento do mouse
    cmp al, 76     ; Verificar movimento para cima
    je move_up
    cmp al, 67     ; Verificar movimento para baixo
    je move_down
    cmp al, 79     ; Verificar movimento para a esquerda
    je move_left
    cmp al, 64     ; Verificar movimento para a direita
    je move_right
    
    ; Verificar cliques
    cmp al, 0x80     ; Verificar clique no botão esquerdo
    je left_click
    cmp al, 0x81     ; Verificar clique no botão direito
    je right_click
    
    jmp continue
    
move_up:
    ; Lógica para movimento para cima
	call clears
	dec edx
	cmp edx,0
	jg move_up1
	mov edx,0
move_up1:
	call sets
    jmp continue
    
move_down:
    ; Lógica para movimento para baixo
	call clears
	inc edx
	cmp edx,24
	jl move_down1
	mov edx,24
move_down1:
	call sets
    jmp continue
    
move_left:
    ; Lógica para movimento para a esquerda
	call clears
	dec ecx
	cmp ecx,0
	jg move_left1
	mov ecx,0
move_left1:
	call sets
    jmp continue
    
move_right:
    ; Lógica para movimento para a direita
	call clears
	inc ecx
	cmp ecx,79
	jl move_right1
	mov ecx,79
move_right1:
	call sets
    jmp continue
    
left_click:
    ; Lógica para clique no botão esquerdo
	call clears
	ret
    
right_click:
    ; Lógica para clique no botão direito
	ret
        
continue:
    jmp main_loop   ; Continuar o loop principal
    
    ; Encerrar o programa
ret
setmem:
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
		mov esi,eax
		push ecx		
		mov eax,edx
		mov edx,0
		mov ecx,0
		mov ebx,160
		clc
		mul ebx
		pop ebx
		clc
		add eax,ebx
		add eax,ebx
		inc eax
		mov ebx,eax
		add ebx,0b8000h
		mov eax,esi
		ds
		mov [ebx],al
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
ret
fill16:
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	fill161:
		ds
		mov [ebx],ax
		inc ebx
		inc ebx
		dec ecx
		jnz fill161	
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
ret
clears:
	mov al,017h
	call setmem
	ret
sets:
	mov al,071h
	call setmem
	ret

