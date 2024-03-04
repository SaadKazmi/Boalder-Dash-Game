[org 0x0100] 
 jmp start 
 
 dirt: db 'x',0
 rockford: db 'R',0
 target: db 'T',0
 boulder: db 'B',0
 diamond: db 'D',0
 wall: db 'W',0
 mainmessage:db 'Enter the cave file name or press Enter to use the default(cave1.txt)$'
 mainmessage2: db 'File name: $'
 errormessage: db 'Error!$'
 message: db '>>> BOULDER DASH NUCES EDITION <<<$'
 message1: db 'Arrow keys: move$'
 message2: db 'Esc: quit$'
 message3: db 'Score:$'
 scorecount: dw 0
 message4: db 'Level: 1$'
 message5: db 'LEVEL COMPLETED $'
 message6: db 'GAME OVER FOR YOU $'
 buffer: times 1600 db 0 ; allocate 1600 bytes
 sound_note: db 07, '$'
 buffer1: db 9
         db 0
		 times 30 db 0
 fname: db 'cave1.txt',0
 fhandle: dw 0
 count: db 1600
 movlabel: dw 0
; subroutine to clear the screen 
clrscr: 
push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 xor di, di ; point di to top left column 
 mov ax, 0x0720 ; space char in normal attribute 
 mov cx, 2000 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear the whole screen 
 pop di
 pop cx 
 pop ax 
 pop es 
 ret 
 
 mymessageprint:
 push ax
 push bx
 push cx
 push dx
 mov ah,02h
mov bh,0
mov dl,0
mov dh,1
int 10h

mov ah,09h
mov dx,message5
int 21h
pop dx
pop cx
pop bx
pop ax
ret
 
 mymessageprint2:
 push ax
 push bx
 push cx
 push dx
 mov ah,02h
mov bh,0
mov dl,0
mov dh,1
int 10h

mov ah,09h
mov dx,message6
int 21h
pop dx
pop cx
pop bx
pop ax
ret

printnum: push bp 
 mov bp, sp 
 push es 
 push ax 
 push bx 
 push cx 
 push dx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov ax, [scorecount] ; load number in ax 
 mov bx, 10 ; use base 10 for division 
 mov cx, 0 ; initialize count of digits 
nextdigit: mov dx, 0 ; zero upper half of dividend 
 div bx ; divide by 10 
 add dl, 0x30 ; convert digit into ascii value 
 push dx ; save ascii value on stack 
 inc cx ; increment count of values 
 cmp ax, 0 ; is the quotient zero 
 jnz nextdigit ; if no divide it again 
 mov di, 3854
 nextpos: pop dx ; remove a digit from the stack 
 mov dh, 0x07 ; use normal attribute 
 mov [es:di], dx ; print char on screen 
 add di, 2 ; move to next screen location 
 loop nextpos ; repeat for all digits on stack
 pop di 
 pop dx 
 pop cx 
 pop bx 
 pop ax 
 pop es 
 pop bp 
 ret 
 
 ;screenprint:
;mov ah,3dh
;mov al,2
;lea dx,fname
;int 21h
;mov fhandle,ax
 
 ;mov ah,3fh
 ;lea dx,buffer
 ;mov cx,1600
 ;mov bx,fhandle
 ;int 21h
 ;lea dx,buffer
 ;mov ah,09h
 ;int 21h
 ;ret
 
 sound:
 mov ah,09h
 mov dx,sound_note
 int 21h
 ret


 
start: 


call clrscr ; call clrscr subroutine 
mov ah,02h
mov bh,0
mov dl,0
mov dh,1
int 10h

mov ah,09h
mov dx,mainmessage
int 21h

mov ah,02h
mov bh,0
mov dl,0
mov dh,2
int 10h

mov ah,09h
mov dx,mainmessage2
int 21h

mov ah,01h
int 21h
cmp al,13
je checkfile
mov si,buffer1
mov [si],al
inc si

nextchar2:
mov ah,01h
int 21h
cmp al,13
je checkfile
mov [si],al
inc si
loop nextchar2

;-------------------------
;mov ah,0x00
;int 0x16
;cmp al,0x0d
;jne start
checkfile:
mov ah,3dh
mov dx,buffer1
mov al,0
int 21h
mov [fhandle],ax
jnc begin
jmp terminate
;-------------------------

begin:

;mov ah, 1       ; set AH = 1
;mov cx, 2000h   ; set CX = 2000h
;int 10h         ; call BIOS interrupt to hide cursor

call clrscr ; call clrscr subroutine 



mov ah,02h
mov bh,0
mov dl,24
mov dh,0
int 10h

mov ah,09h
mov dx,message
int 21h

mov ah,02h
mov bh,0
mov dl,0
mov dh,1
int 10h

mov ah,09h
mov dx,message1
int 21h

mov ah,02h
mov bh,0
mov dl,70
mov dh,1
int 10h

mov ah,09h
mov dx,message2
int 21h

mov ah,02h
mov bh,0
mov dl,0
mov dh,3
int 10h
;------------------------------------Print Borders
;printscreen:
mov ax,0xb800
mov es,ax
mov di,320

nextchar: mov word[es:di],0x66db
add di,2
cmp di,480
jne nextchar

;Hide cursor
mov ah,01h
mov cx,20h
int 10h
;-------------------------------------

;mov ah,02h
;mov bh,0
;mov dl,0
;mov dh,5
;int 10h

;Opening file and reading it
mov ah,3dh
mov dx,fname
mov al,0
int 21h
mov [fhandle],ax
 
 ;Reading data from the file
 mov bx,[fhandle]
 mov ah,3fh
 mov cx,1600
 mov dx,buffer
 int 21h
 ;mov ah,3fh
 ;mov bx,fhandle
 ;mov cx,1600
 ;mov dx,buffer
 ;int 21h

 ;mov cx,[count]
 
mov si,buffer
mov ah,02h
mov bh,0
mov dl,0
mov dh,2
int 10h

;closing of the file
mov ah,3eh
mov dx,fhandle
int 21h

;----------------------------------------

;----------------------------------------




;l1:
;mov ah,2
;mov dl,[si]
;int 21h
;inc si
;dec cx
;jne l1
;-----------------
mov di,482
;-----------------

printloop:
mov al,[si]
cmp al,[dirt]
je printdirt

cmp al,[wall]
je printwall

cmp al,[boulder]
je printboulder

cmp al,[diamond]
je printdiamond

cmp al,[rockford]
je printrockford

cmp al,[target]
je printtarget

printdirt:
;mov ah,0x0e
;mov al,0xb1
;int 0x10
;jmp continue
mov word[es:di],0x70b1
add di,2
;sub cx,1
jmp continue
;jmp printloop
printwall:
;mov ah,0x0e
;mov al,0xDB
;mov bl,66h
;int 0x10
mov word[es:di],0x66db
add di,2
jmp continue

printboulder:
;mov ah,0x0e
;mov al,09h
;int 0x10
mov word[es:di],0x0509
add di,2
jmp continue

printdiamond:
;mov ah,0x0e
;mov al,0x04
;int 0x10
mov word[es:di],0x0b04
add di,2
jmp continue

printrockford:
;mov ah,0x0e
;mov al,0x02
;int 0x10
mov word[es:di],0x0f02
mov word[movlabel],di
add di,2
jmp continue

printtarget:
;mov ah,0x0e
;mov al,0x7F
;int 0x10
mov word[es:di],0x0a7f
add di,2
jmp continue

continue:
inc si
dec cx
cmp cx,0
jne printloop


;--------------------------------
mov di,480
mov word[es:di],0x66db
mov word[es:638],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:798],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:958],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:1118],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:1278],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:1438],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:1598],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:1758],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:1918],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:2078],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:2238],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:2398],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:2558],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:2718],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:2878],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:3038],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:3198],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:3358],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:3518],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:3678],0x66db

add di,160
mov word[es:di],0x66db
mov word[es:3838],0x66db

mov di,3680
nextchar1: mov word[es:di],0x66db
add di,2
cmp di,3840
jne nextchar1
;--------------------------------

mov ah,02h
mov bh,0
mov dl,0
mov dh,24
int 10h

mov ah,09h
mov dx,message3
int 21h
call printnum

mov ah,02h
mov bh,0
mov dl,70
mov dh,24
int 10h

mov ah,09h
mov dx,message4
int 21h
;-------------------
jmp p2
;---------------
up:
push ax
push bx
push cx
push dx
mov di,word [movlabel]
cmp word[es:di],0x8402
jne finishstop
jmp subfinal
finishstop:
mov ax,di
sub ax,160
mov di,ax
cmp word[es:di],0x8202 ;rockford movement
jne bldcmp
jmp subfinal

bldcmp:
cmp word[es:di],0x0509
jne diamondcmp
mov word[es:di],0x8409 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x8402 ;lag
disable_keyboardbld:
    mov ah, 0x00 ; set interrupt number to 0x00 (keyboard)
    int 0x16 ; call interrupt
    cmp ah, 0x01 ; check if the escape key was pressed
    je enable_keyboardbld ; if the escape key was pressed, enable the keyboard and return
	call mymessageprint2
    cmp ah, 0x00 ; check if any other key was pressed
    jne disable_keyboardbld ; if any other key was pressed, disable the keyboard again
    jmp enable_keyboardbld ; otherwise, keep checking for a keypress

enable_keyboardbld:
   jmp finish
;sub di,160
;mov word[movlabel],di

diamondcmp:
cmp word[es:di],0x0b04
jne wallcmp
mov word[es:di],0x0f02 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
sub di,160
mov word[movlabel],di
add word[scorecount],1
call printnum

wallcmp:
cmp word[es:di],0x66db
jne targetcmp
call sound
jmp subfinal

targetcmp:
cmp word[es:di],0x0a7f
jne dirtcmp
mov word[es:di],0x8202 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
sub di,160
mov word[movlabel],di
 disable_keyboard:
    mov ah, 0x00 ; set interrupt number to 0x00 (keyboard)
    int 0x16 ; call interrupt
    cmp ah, 0x01 ; check if the escape key was pressed
    je enable_keyboard ; if the escape key was pressed, enable the keyboard and return
	call mymessageprint
    cmp ah, 0x00 ; check if any other key was pressed
    jne disable_keyboard ; if any other key was pressed, disable the keyboard again
    jmp enable_keyboard ; otherwise, keep checking for a keypress

enable_keyboard:
   jmp finish


dirtcmp:
mov word[es:di],0x0f02 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
sub di,160
mov word[movlabel],di

subfinal:
pop dx
pop cx
pop bx
pop ax
ret

;---------------

right:
push ax
push bx
push cx
push dx
mov di,word [movlabel]
cmp word[es:di],0x8402
jne finishstop1
jmp subfinal1
finishstop1:
mov ax,di
add ax,2
mov di,ax
cmp word[es:di],0x8202 ;rockford movement
jne bldcmp1
jmp subfinal1

bldcmp1:
cmp word[es:di],0x0509
jne diamondcmp1
call sound
jmp subfinal1
;sub di,160
;mov word[movlabel],di

diamondcmp1:
cmp word[es:di],0x0b04
jne wallcmp1
mov word[es:di],0x0f02 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
add di,2
mov word[movlabel],di
add word[scorecount],1
call printnum

wallcmp1:
cmp word[es:di],0x66db
jne targetcmp1
call sound
jmp subfinal1

targetcmp1:
cmp word[es:di],0x0a7f
jne dirtcmp1
mov word[es:di],0x8202 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
add di,2
mov word[movlabel],di
disable_keyboard1:
    mov ah, 0x00 ; set interrupt number to 0x00 (keyboard)
    int 0x16 ; call interrupt
    cmp ah, 0x01 ; check if the escape key was pressed
    je enable_keyboard1 ; if the escape key was pressed, enable the keyboard and return
	call mymessageprint
    cmp ah, 0x00 ; check if any other key was pressed
    jne disable_keyboard1 ; if any other key was pressed, disable the keyboard again
    jmp enable_keyboard1 ; otherwise, keep checking for a keypress

enable_keyboard1:
    jmp finish


dirtcmp1:
mov word[es:di],0x0f02 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
add di,2
mov word[movlabel],di

subfinal1:
pop dx
pop cx
pop bx
pop ax
ret

;--------------------
;left

;---------------
left:
push ax
push bx
push cx
push dx
mov di,word [movlabel]
cmp word[es:di],0x8402
jne finishstop2
jmp subfinal2
finishstop2:
mov ax,di
sub ax,2
mov di,ax
cmp word[es:di],0x8202 ;rockford movement
jne bldcmp2
jmp subfinal2
;dirtcmp2:
;cmp word[es:di],0x70b1
;jne bldcmp2
;mov word[es:di],0x0f02 ;rockford movement
;mov word[movlabel],di
;mov di,word [movlabel]
;mov word [es:di],0x0720 ;lag
;sub di,2
;mov word[movlabel],di

bldcmp2:
cmp word[es:di],0x0509
jne diamondcmp2
call sound
jmp subfinal2


;sub di,160
;mov word[movlabel],di

diamondcmp2:
cmp word[es:di],0x0b04
jne wallcmp2
mov word[es:di],0x0f02 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
sub di,2
mov word[movlabel],di
add word[scorecount],1
call printnum


wallcmp2:
cmp word[es:di],0x66db
jne targetcmp2
call sound
jmp subfinal2


targetcmp2:
cmp word[es:di],0x0a7f
jne dirtcmp2
mov word[es:di],0x8202 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
sub di,2
mov word[movlabel],di
disable_keyboard2:
    mov ah, 0x00 ; set interrupt number to 0x00 (keyboard)
    int 0x16 ; call interrupt
    cmp ah, 0x01 ; check if the escape key was pressed
    je enable_keyboard2 ; if the escape key was pressed, enable the keyboard and return
	call mymessageprint
    cmp ah, 0x00 ; check if any other key was pressed
    jne disable_keyboard2 ; if any other key was pressed, disable the keyboard again
    jmp enable_keyboard2 ; otherwise, keep checking for a keypress

enable_keyboard2:
    jmp finish

dirtcmp2:
mov word[es:di],0x0f02 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
sub di,2
mov word[movlabel],di

subfinal2:
pop dx
pop cx
pop bx
pop ax
ret

down:
push ax
push bx
push cx
push dx
mov di,word [movlabel]
cmp word[es:di],0x8402
jne finishstop3
jmp subfinal3
finishstop3:
mov ax,di
add ax,160
mov di,ax
cmp word[es:di],0x8202 ;rockford movement
jne bldcmp3
jmp subfinal3
;dirtcmp2:
;cmp word[es:di],0x70b1
;jne bldcmp2
;mov word[es:di],0x0f02 ;rockford movement
;mov word[movlabel],di
;mov di,word [movlabel]
;mov word [es:di],0x0720 ;lag
;sub di,2
;mov word[movlabel],di

bldcmp3:
cmp word[es:di],0x0509
jne diamondcmp3
call sound
jmp subfinal3


;sub di,160
;mov word[movlabel],di

diamondcmp3:
cmp word[es:di],0x0b04
jne wallcmp3
mov word[es:di],0x0f02 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
add di,160
mov word[movlabel],di
add word[scorecount],1
call printnum

wallcmp3:
cmp word[es:di],0x66db
jne targetcmp3
call sound
jmp subfinal3


targetcmp3:
cmp word[es:di],0x0a7f
jne dirtcmp3
mov word[es:di],0x8202 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
add di,160
mov word[movlabel],di
disable_keyboard3:
    mov ah, 0x00 ; set interrupt number to 0x00 (keyboard)
    int 0x16 ; call interrupt
    cmp ah, 0x01 ; check if the escape key was pressed
    je enable_keyboard3 ; if the escape key was pressed, enable the keyboard and return
	call mymessageprint
    cmp ah, 0x00 ; check if any other key was pressed
    jne disable_keyboard3 ; if any other key was pressed, disable the keyboard again
    jmp enable_keyboard3 ; otherwise, keep checking for a keypress

enable_keyboard3:
    jmp finish


dirtcmp3:
mov word[es:di],0x0f02 ;rockford movement
;mov word[movlabel],di
mov di,word [movlabel]
mov word [es:di],0x0720 ;lag
add di,160
mov word[movlabel],di

subfinal3:
pop dx
pop cx
pop bx
pop ax
ret

;exit on esc key press
p2:
mov ah,00h
int 16h
cmp ah,01h
je finish
cmp ah,72 ; up ascii
jne right_key
call up
jmp p2
right_key:
cmp ah,77 ;right ascii
jne left_key
call right
jmp p2
left_key:
cmp ah,75 ;left ascii
jne down_key
call left
jmp p2
down_key:
cmp ah,80 ;down ascii
jne p2
call down
jmp p2

;mov ah,00h
;mov al,03h
;int 10h
;------------------


terminate:
mov ah,09h
mov dx,errormessage
int 21h
jmp errorfinisher

errorfinisher:

 mov ax, 0x4c00 ; terminate program 
 int 0x21


;-------------------------------------
finish:
call clrscr
 mov ax, 0x4c00 ; terminate program 
 int 0x21