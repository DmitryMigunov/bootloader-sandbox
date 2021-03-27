use16
org 07C00h

; 80x25
mov ax, 0003h
int 10h

mov ax, 0B800h
mov es, ax ; ES:DI <- B800:0000

jmp draw
loop:
; input
mov ah, 00h
int 16h

cmp ah, 48h
je top_pressed
cmp ah, 50h
je down_pressed
cmp ah, 4bh
je left_pressed
cmp ah, 4dh
je right_pressed

jmp next

top_pressed:
	dec word [player_y]
	cmp word [player_y], 1
	jge draw
	mov word [player_y], 1
	jmp draw
down_pressed:
	inc word [player_y]
	cmp word [player_y], 23
	jl draw
	mov word [player_y], 23
	jmp draw
left_pressed:
	dec word [player_x]
	cmp word [player_x], 2
	jg draw
	mov word [player_x], 2
	jmp draw
right_pressed:
	inc word [player_x]
	cmp word [player_x], 78*2
	jl draw
	mov word [player_x], 78*2
	jmp draw

draw:
; clean screen
xor ax, ax
xor di, di
mov cx, 80*25
rep stosw

; draw borders

xor di, di
mov ax, 0fcdh
tb_border:
	add di, 2
	mov [es:di], ax
	add di, 80*24*2
	mov [es:di], ax
	sub di, 80*24*2
	cmp di, 156
	jl tb_border

mov ax, 0fbah
xor di, di
add di, 80*2
lr_border:
	mov [es:di], ax
	add di, 79*2
	mov [es:di], ax
	add di, 2
  cmp di, 80*24*2
  jl lr_border

xor di, di
mov ax, 0fc9h
mov [es:di], ax
add di, 79*2
mov ax, 0fbbh
mov [es:di], ax
mov ax, 0fbch
add di, 80*24*2
mov [es:di], ax
mov ax, 0fc8h
sub di, 79*2
mov [es:di], ax

; draw player
imul di, [player_y], 160
add di, [player_x]
mov word [es:di], 2020h

next:
; delay
mov bx, [046ch]
inc bx
inc bx
.delay:
cmp [046ch], bx
jl .delay
jmp loop

player_y: dw 10
player_x: dw 10

times 510-($-$$) db 0
dw 0aa55h
