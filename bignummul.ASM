;Procedure:
;displayStr far (str, Color)
;numToArray far (num, strToSaveNum) output lenRes
;displayStrArray far (len, str )
;copyArray far (sourceLen, sourceStr, destStr)
;arrayMul far (num1, num1Len, num2, num2Len, result) output lenRes
;inputNum far (n)
;clearArray far (len, array)
;computeFactorial far (n) change num1,num2,result
;showInSci far (len, array) change expo

;Macro:
;clearScreen
;showMenu
;call_inputNum num
;checkN n
;checkChoice choice
;call_displayStr str, bgColor, frontColor
;call_numToArray num,strToSaveNum (auto adjust numLen)
;call_displayStrArray len,s
;call_copyArray sourceLen,sourceStr,destStr (auto adjust destLen)
;call_arrayMul num1,num1Len,num2,num2Len,result  (auto adjust resultLen)
;call_clearArray len, array
;showResultInform numStr
;call_computeFactorial num

call_showInSci macro len, array
	push ax
	mov ax,len
	push ax
	lea ax,array
	push ax
	call_displayStr subSplitter, bgBlack, frontLightGreen
	call_displayStr expoInform, bgBlack, frontLightCyan
	call far ptr showInSci
	call_displayStr nl, bgBlack, frontWhite
	pop ax
endm

call_computeFactorial macro num
	push ax
	mov ax,num
	push ax
	call far ptr computeFactorial
	pop ax
endm

showResultInform macro numStr
	call_displayStr resultInform1, bgBlack, frontWhite
	call_displayStrArray numStr&Len,numStr
	call_displayStr resultInform2, bgBlack, frontWhite
endm
call_clearArray macro len,array
	push ax
	mov ax,len
	push ax
	lea ax,array
	push ax
	call far ptr clearArray
	pop ax
endm

clearScreen macro
	push ax
	mov ax,0003h
	int 10h
	pop ax
endm

showMenu macro
	call_displayStr splitter, bgBlack, frontLightGreen
	call_displayStr menu, bgBlack, frontLightBlue
	call_displayStr splitter, bgBlack, frontLightGreen
endm

call_inputNum macro num
Local Lexit
	mov exceptionFlag,false
	call_displayStr inputSymbol, bgBlack, frontWhite
	push ax
	lea ax,num
	push ax
	call far ptr inputNum
	mov ax, num
	call_displayStr nl, bgBlack, frontWhite
	cmp exceptionFlag,true
	jnz Lexit
	
	call_displayStr exceptionOccur, bgRed, frontYellow
Lexit:
	pop ax
endm

checkN macro n
local Lexit,L1
	mov exceptionFlag,false
	cmp n,0
	jl L1
	cmp n,1500
	jge L1
	jmp Lexit

L1:
	mov exceptionFlag,true
	call_displayStr exceptionOccur, bgRed, frontYellow
Lexit:
endm

checkChoice macro choice
local Lexit,L1,L2
	mov inputFlag,false
	mov exitFlag,false
	mov exceptionFlag,false
	cmp choice,1
	jz L1
	cmp choice,0
	jz L2
	mov exceptionFlag,true
	call_displayStr exceptionOccur, bgRed, frontYellow
	jmp Lexit
L1:
	mov inputFlag,true
	jmp Lexit
L2:
	mov exitFlag,true
Lexit:
endm

call_displayStr macro s, bgColor, frontColor	;call_前缀宏为简化函数调用宏
	push ax
    push cx
	lea ax,s
	push ax
    mov ax,bgColor
    mov cl,4
    shl ax,cl
    mov cx,frontColor
    xor ax,cx
    push ax
	call far ptr displayStr
    pop cx
	pop ax
endm

call_numToArray macro num, strToSaveNum
	push ax
	mov ax,lenRes
	push ax
	mov ax,num
	push ax
	lea ax,strToSaveNum
	push ax
	call far ptr numToArray
	mov ax,lenRes
	mov strToSaveNum&Len,ax		;保存串长
	pop ax
	mov lenRes,ax
	pop ax
endm

call_displayStrArray macro len,s
	push ax
	mov ax,len
	push ax
	lea ax,s
	push ax
	call far ptr displayStrArray
	pop ax
endm
call_copyArray macro sourceLen, sourceStr, destStr
	push ax
	mov ax,sourceLen
	push ax
	lea ax,sourceStr
	push ax
	lea ax,destStr
	push ax
	call far ptr copyArray
	mov ax,sourceLen
	mov destStr&len,ax
	pop ax
endm

call_arrayMul macro num1,num1Len,num2,num2Len,result
	push ax
	mov ax,lenRes
	push ax
	lea ax,num1
	push ax
	mov ax,num1Len
	push ax
	lea ax,num2
	push ax
	mov ax,num2Len
	push ax
	lea ax,result
	push ax
	call far ptr arrayMul
	mov ax,lenRes
	mov result&Len,ax
	pop ax
	mov lenRes,ax
	pop ax
endm


data segment
result db 5000 DUP(0)
num1 db 5000 DUP(0)
num2 db 5000 DUP(0)
expo db 7 DUP(0)
buffer db 5,?,5 dup(0)
i dw 0
j dw 0
k dw 0
nl db 0ah,0dh,'$'
ti db 'System for computing factorial',0ah,0dh,'$'
menu db '1.Input n.',0ah,0dh,'0.Exit.',0ah,0dh,'$'
subMenu1 db 'Please input n (no larger than 1499):',0ah,0dh,'$'
subMenu2 db 'System terminated.',0ah,0dh,'$'
expoInform db 'Result in sci form: $'
splitter db 79 dup('='),0ah,0dh,'$'
subSplitter db 79 dup('-'),0ah,0dh,'$'
exceptionOccur db 'Invalid input!',0ah,0dh,'Please input again:',0ah,0dh,'$'
resultInform1 db 'Factorial of ','$'
resultInform2 db ' is:',0ah,0dh,'$'
pageInform db 'Need to page, press any key to continue: $'
inputSymbol db '>>>'
blank db ' $'
resultLen dw 0
num1Len dw 0
num2Len dw 0
expoLen dw 0
n dw 0
exceptionFlag dw 0
tem dw 0
lenTem dw 0
lenRes dw 0
choice dw 0
x dw 988
true equ 1
false equ 0
bgBlack equ 0b
bgBlue equ 1b
bgGreen equ 10b
bgCyan equ 11b
bgRed equ 100b
bgCarmine equ 101b
bgBrown equ 110b
bgLightGray equ 111b

frontGray equ 1000b
frontLightBlue equ 1001b
frontLightGreen equ 1010b
frontLightCyan equ 1011b
frontLightRed equ 1100b
frontLightCarmine equ 1101b
frontYellow equ 1110b
frontWhite equ 1111b

exitFlag dw false
negFlag dw false
inputFlag dw false

data ends

stack segment stack
dw 2000 dup(?)
stack ends

code segment
assume cs:code,ds:data,es:data,ss:stack
main proc far
start:
	push ds
	xor ax,ax
	push ax
	mov ax,data
	mov ds,ax
	mov es,ax
	clearScreen
	call_displayStr ti, bgBlack, frontLightCarmine			;第一次标题前不打印分隔符
	showMenu
	jmp Lcode_3
Lcode_1:
	call_displayStr splitter, bgBlack, frontLightGreen
	call_displayStr ti, bgBlack, frontLightCarmine
	showMenu
Lcode_3:
	call_inputNum choice
	cmp exceptionFlag,true
	jnz Lcode_2
	jmp Lcode_3

Lcode_3DeliverStart:
	jmp Lcode_3
Lcode_3DeliverEnd:

Lcode_2:
	checkChoice choice
	cmp exceptionFlag,true
	jz Lcode_3DeliverStart
	cmp inputFlag,true
	jz Lcode_4
	cmp exitFlag,true
	jz Lcode_exitDeliverStartDS
Lcode_4:
	call_displayStr subMenu1, bgBlack, frontLightBlue
Lcode_5:
    jmp Lcode_exitDeliverStartDE

Lcode_exitDeliverStartDS:
    jmp Lcode_exitDeliverStart
Lcode_exitDeliverStartDE:
    
    jmp Lcode_5DeliverEnd

Lcode_5DeliverStart:
    jmp Lcode_5
Lcode_5DeliverEnd:

	call_inputNum n
	cmp exceptionFlag,true
	jz Lcode_5DeliverStart
	jmp Lcode_exitDeliverEnd

Lcode_5DeliverStartDS:
    jmp Lcode_5DeliverStart
Lcode_5DeliverEndDE:

Lcode_exitDeliverStart:
	jmp Lcode_exit
Lcode_exitDeliverEnd:

	checkN n
	cmp exceptionFlag,true
	jz Lcode_5DeliverStartDS
	call_numToArray n,result
	showResultInform result
	jmp Lcode_1DeliverEnd
Lcode_1DeliverStart:
	jmp Lcode_1
Lcode_1DeliverEnd:
	call_computeFactorial n
	call_displayStrArray resultLen,result
	call_displayStr nl, bgBlack, frontWhite
	cmp resultLen,25
	jb Lcode_1DeliverStart
	call_showInSci resultLen,result
	jmp Lcode_1DeliverStart

Lcode_exit:
	call_displayStr splitter, bgBlack, frontLightGreen
	call_displayStr subMenu2, bgBlue, frontLightGreen
	call_displayStr splitter, bgBlack, frontLightGreen
	ret
main endp
code ends

code1 segment
assume cs:code1
displayStr proc far
	push ax
    push bx
    push cx
	push bp
    push si
	mov bp,sp
	mov bx,[bp+14]
    mov bh,00h
    mov si,[bp+16]
    mov cx,1

Lcode1_1:	
    cmp BYTE PTR [si],'$'
    jz Lcode1_exit

    cmp BYTE PTR [si],0ah
    jnz Lcode1_4
    push ax
    push dx
    mov ah,02h
    mov dl,0ah
    int 21h
    inc si
    pop dx
    pop ax
    jmp Lcode1_1
Lcode1_4:
    cmp BYTE PTR [si],0dh
    jnz Lcode1_3
    push dx
    push ax
    mov ah,02h
    mov dl,0dh
    int 21h
    inc si
    pop dx
    pop ax
    jmp Lcode1_1

Lcode1_3:
    mov al,[si]
    mov ah,09h
    int 10h
    inc si

    push cx
    push dx
    mov ah,03h
    int 10h
    inc dl
    cmp dl,80
    jnz Lcode1_2
    mov dl,0
    inc dh
    cmp dh,25
    jnz Lcode1_2
    mov dh,24
    push ax
    push cx
    push dx
    mov dh,25
    mov dl,80
    mov cx,0
    mov ah,06h
    mov al,1
    int 10h
    pop dx
    pop cx
    pop ax
Lcode1_2:
    mov ah,02h
    int 10h
    pop dx
    pop cx

    jmp Lcode1_1

Lcode1_exit:
    pop si
    pop bp
    pop cx
    pop bx
    pop ax
	ret 4
displayStr endp
code1 ends
code2 segment
assume cs:code2
numToArray proc far
	push dx
	push bx
	push ax
	push bp
	push cx
	push di
	mov bp,sp
	mov di,[bp+16]
	mov ax,[bp+18]

	mov bx,0
	mov bl,10
	mov dx,0
	mov cx,0

	cmp ax,0
	jnz Lcode2_2				;约定0用数组表示为[0,0,,,,,]
	mov BYTE PTR [di],0
	mov BYTE PTR [di+1],0
	mov lenRes,1
	jmp Lcode2_exit

Lcode2_2:
	mov dx,0
	div bx
	push dx
	inc cx
	cmp ax,0
	jne Lcode2_2

	mov lenRes,cx
	cld
Lcode2_1:
	pop dx
	mov ax,dx
	stosb
	loop Lcode2_1

Lcode2_exit:
	pop di
	pop cx
	pop bp
	pop ax
	pop bx
	pop dx
	ret 4
numToArray endp
code2 ends

code3 segment
assume cs:code3
displayStrArray proc far
	push ax
	push dx
	push bx
	push cx
	push bp
	push si

	mov bp,sp
	mov ax,[bp+18]
	mov cx, ax
	mov si,[bp+16]
	mov dx,0
	mov ah,02h
	cld

	mov bx,cx
	sub bx,80*20

	cmp BYTE PTR [si],0
	jnz Lcode3_1
	cmp BYTE PTR [si+1],0		;约定结果为0时，数组前两数均应为0
	jz Lcode3_1
	inc si

Lcode3_1:

	cmp bx,cx
	jl Lcode3_2
	call_displayStr pageInform, bgRed, frontYellow
	push ax
	mov ah,01h
	int 21h
	pop ax
	clearScreen
	mov bx,cx
	sub bx,80*20

Lcode3_2:

	Lodsb
	mov dl,al
	add dx,30h
	int 21h
	loop Lcode3_1


	pop si
	pop bp
	pop cx
	pop bx
	pop dx
	pop ax

	ret 4
displayStrArray endp
code3 ends

code4 segment
assume cs:code4
copyArray proc far
	push ax
	push bp
	push cx
	push si
	push di

	mov bp,sp
	mov di,[bp+14]
	mov si,[bp+16]
	mov cx,[bp+18]

	cmp BYTE PTR [si],0
	jnz Lcode4_1
	inc si
Lcode4_1:

	cld
	 
	rep movsb
	
	pop di
	pop si
	pop cx
	pop bp
	pop ax
	
	ret 6
copyArray endp
code4 ends

code5 segment
assume cs:code5
arrayMul proc far
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	mov ax,num1Len
	push ax
	mov ax,num2Len
	push ax
	mov ax,resultLen
	push ax
	mov ax,i
	push ax
	mov ax,j
	push ax
	mov ax,k
	push ax

	mov bp,sp
	mov bx,[bp+30]
	mov ax,[bp+32]
	mov num2Len,ax
	mov di,[bp+34]
	mov ax,[bp+36]
	mov num1Len,ax
	mov si,[bp+38]
	mov ax,num1Len
	add ax,num2Len
	mov resultLen,ax
	mov cx,resultLen

	cmp BYTE PTR [si],0
	jnz Lcode5_11
	inc si

Lcode5_11:
	push di
	push ax
	mov di,bx
Lcode5_10:
	mov ax,0
	stosb
	loop Lcode5_10
	pop ax
	pop di

	mov i,0
	mov j,0
	mov k,0
	push di
Lcode5_1:
	mov cx,i
	cmp cx,num1Len
	jae Lcode5_4
	mov j,0
	pop di
	push di
	Lcode5_2:
		mov cx,j
		cmp cx,num2Len
		jae Lcode5_3
		mov ax,0
		mov al,[si]
		mov dx,0
		mov dl,[di]
		mul dl
		push si
		mov si,0
		add si,i
		add si,j
		inc si
		add [bx+si],al
		pop si
		inc di
		inc j
		jmp Lcode5_2
Lcode5_3:
	inc i
	inc si
	jmp Lcode5_1
Lcode5_4:
	pop di
	mov si,resultLen
	dec si
	
Lcode5_5:
	cmp si,0
	jz Lcode5_6
	cmp BYTE PTR [bx+si],10
	jb Lcode5_7
	mov dx,10
	mov ax,0
	mov al,[bx+si]
	div dl
	add [bx+si-1],al
	mov [bx+si],ah
Lcode5_7:
	dec si
	jmp Lcode5_5
Lcode5_6:

	mov si,0
	cmp BYTE PTR [bx+si],0
	jnz Lcode5_8
	dec resultLen
	
Lcode5_8:
	mov ax,resultLen
	mov lenRes,ax
	
	pop ax
	mov k,ax
	pop ax
	mov j,ax
	pop ax
	mov i,ax
	pop ax
	mov resultLen,ax
	pop ax
	mov num2Len,ax
	pop ax
	mov num1Len,ax
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
   
	ret 10

arrayMul endp   
code5 ends
code6 segment
assume cs:code6
inputNum proc far
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	mov bp,sp
	mov di,[bp+18]

Lcode6_1:
	mov ah,0ah
	lea dx,buffer
	int 21h
	lea si,buffer+1
	mov cl,[si]
	mov ch,0
	cmp cx,0
	jz Lcode6_1				;单输入回车不处理

	inc si
	mov ax,0
	mov dx,0
	mov bx,10
	mov WORD PTR [di],0
	
Lcode6_2:
	cmp cx,0
	jz Lcode6_exit
	lodsb
	dec cx
	cmp al,'0'
	jb Lcode6_exception
	cmp al,'9'
	ja Lcode6_exception
	sub al,30h
	mov ah,0
	push ax
	mov ax,[di]
	mul bx
	pop dx
	add ax,dx
	mov [di],ax
	jmp Lcode6_2

Lcode6_exception:
	mov exceptionFlag,true

Lcode6_exit:

	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	ret 2
inputNum endp
code6 ends

code7 segment
assume cs:code7
clearArray proc far
	push ax
	push cx
	push bp
	push di

	mov bp,sp
	mov di,[bp+12]
	mov cx,[bp+14]
	mov ax,0
	rep stosb
	
	pop di
	pop bp
	pop cx
	pop ax
	ret 4
clearArray endp
code7 ends

code8 segment
assume cs:code8
computeFactorial proc far
	push ax
	push bp
	mov ax,n
	push ax
	mov ax,tem
	push ax

	mov bp,sp
	mov ax,[bp+12]
	mov n,ax
	mov tem,2

	call_numToArray 1,result

Lcode8_1:						;轮换存储结果，避免数组间复制
	cmp n,1
	jbe Lcode8_exitDS
	
	call_numToArray n,num2
	dec n
	call_arrayMul result,resultLen,num2,num2Len,num1
	mov tem,1
	cmp n,1
	jbe Lcode8_exitDS

	jmp Lcode8_exitDE
Lcode8_exitDS:
	jmp Lcode8_exitDS1
Lcode8_exitDE:

	call_numToArray n,num2
	dec n

	jmp Lcode8_exitDE1
Lcode8_exitDS1:
	jmp Lcode8_exit
Lcode8_exitDE1:


	call_arrayMul num1,num1Len,num2,num2Len,result
	mov tem,2
	jmp Lcode8_1

Lcode8_exit:
	cmp tem,2
	jz Lcode8_2
	call_copyArray num1Len,num1,result
Lcode8_2:
	pop ax
	mov tem,ax
	pop ax
	mov n,ax
	pop bp
	pop ax
	ret 2
computeFactorial endp
code8 ends

code9 segment
assume cs:code9
showInSci proc far
	push ax
	push cx
	push si
	push dx
	push bp
	mov ax,tem
	push ax
	
	mov bp,sp
	mov si,[bp+16]
	mov cx,[bp+18]

	cmp BYTE PTR [si],0
	jnz Lcode9_2
	inc si

Lcode9_2:
	mov dl,[si]
	add dl,30h
	mov ah,02h
	int 21h
	mov dl,'.'
	int 21h
	inc si
	dec cx
	push cx
	mov cx,19

Lcode9_1:
	lodsb
	mov dl,al
	add dl,30h
	int 21h
	loop Lcode9_1

	mov dl,'e'
	int 21h
	pop cx
	mov tem,cx

	call_numToArray tem,expo
	call_displayStrArray expoLen,expo

	pop ax
	mov tem,ax
	pop bp
	pop dx
	pop si
	pop cx
	pop ax
	
	ret 4
code9 ends
end start
