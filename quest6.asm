org 0x7c00
jmp 0x0000:start
string times 11 db 0
resposta times 11 db 0

start:
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
	mov ds, ax
	mov es, ax

    mov di, string
    call gets
    mov si, string
    call stoi

	mov bx, 1
	mov cx,1
    cmp al, 2
	jbe printRes	
	call fib
	call printRes



printRes:
	mov ax, dx
	mov di, resposta
	call tostring
	mov si, resposta
	call prints
ret

fib:
	mov dx,2
	call .loop2
	.loop2:
		push bx
		add bx, cx
		pop cx
		inc dx
		cmp dx, ax
		jne  .loop2
		mov ax, bx
		mov bx, 11
		div bx
ret

reverse:
	mov di, si
	xor cx, cx
	
	.loop7:
		lodsb
		cmp al, 0
		je .endloop7
		inc cl
		push ax
		jmp .loop7
	
	.endloop7:
	
	.loop8:
		cmp cl, 0
		je .endloop8
		dec cl
		pop ax
		stosb
		jmp .loop8
		
	.endloop8:
	ret

getchar:
	mov ah, 0x00
	int 16h
ret

putchar:

	mov ah, 0x0e
	int 10h

ret

delchar:

	mov al, 0x08
	call putchar
	
	mov al, ''
	call putchar
	
	mov al, 0x08
	call putchar
	
ret

endl:
	
	mov al, 0x0a
	call putchar
	mov al, 0x0d
	call putchar
	
ret

gets:
	xor cx, cx
	
	.loop1:
		call getchar
		cmp al, 0x08
		je .backspace
		cmp al, 0x0d
		je .done
		cmp cl, 50
		je .loop1
		stosb
		inc cl
		call putchar
		jmp .loop1
		
		.backspace:
			cmp cl, 0
			je .loop1
			dec di
			dec cl
			mov byte[di], 0
			call delchar
			jmp .loop1
	.done:
		mov al, 0
		stosb
		call endl
ret

prints:

    .loop:
        lodsb                   ;Carrega caracter em al              
        cmp al, 0
        je .endloop
        call putchar
        jmp .loop
    .endloop:
ret

stoi:            
  xor cx, cx
  xor ax, ax
  .loop3:
    push ax
    lodsb
    mov cl, al
    pop ax
    cmp cl, 0        
    je .endloop3
    sub cl, 48        
    mov bx, 10
    mul bx         
    add ax, cx        
    jmp .loop3
  .endloop3:
  ret

tostring:						; mov ax, int / mov di, string
	push di
	.loop1:
		cmp ax, 0
		je .endloop1
		xor dx, dx
		mov bx, 10
		div bx					; ax = 9999 -> ax = 999, dx = 9
		xchg ax, dx				; swap ax, dx
		add ax, 48				; 9 + '0' = '9'
		stosb
		xchg ax, dx
		jmp .loop1
	.endloop1:
	pop si
	cmp si, di
	jne .done
	mov al, 48
	stosb
	.done:
		mov al, 0
		stosb
		call reverse
		ret

times 510-($-$$) db 0
dw 0xaa55