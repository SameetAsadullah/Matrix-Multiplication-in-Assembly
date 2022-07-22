dosseg
.model small
.stack 100h
.data
	str1 db "Enter total Rows/Columns for nxn matrix: $"
	str2 db "Enter elements of arr1: $"
	str3 db "Enter elements of arr2: $"
	str4 db "Output after multiplying: $"
	ary1 db 100 DUP(?)
	ary2 db 100 DUP(?)
	ary3 db 100 DUP(?)
	n db ?
	sum db 0
.code
main proc
	mov ax,@data
	mov ds,ax
	
;==========INPUT ROW/COLUMN NO===========;
	
	LEA dx, str1
	mov ah,09h
	int 21h
	
	mov ah,01h
	int 21h
	
	mov n,al
	sub n,48

;==========INPUT MATRIX 1===========;

	mov ah,02h
	mov dl,10
	int 21h
	
	LEA dx, str2
	mov ah,09h
	int 21h
	
	mov cx,0
	mov cl,n
	mov si,0
	L1:
		PUSH cx
		mov cx,0
		mov cl,n
		L2:
			mov ah,01h
			int 21h
			
			sub al,48
			mov ary1[si], al
			INC si
		LOOP L2
		POP cx
	LOOP L1

;==========INPUT MATRIX 2===========;	
	
	mov ah,02h
	mov dl,10
	int 21h
	
	LEA dx, str3
	mov ah,09h
	int 21h
	
	mov cx,0
	mov cl,n
	mov si,0
	L3:
		PUSH cx
		mov cx,0
		mov cl,n
		L4:
			mov ah,01h
			int 21h
			
			sub al,48
			mov ary2[si],al
			INC si
		LOOP L4
		POP cx
	LOOP L3
	
;==========MATRICES MULTIPLICATION===========;

	mov ah,02h
	mov dl,10
	int 21h

	LEA dx, str4
	mov ah,09h
	int 21h

	mov si,0
	mov di,0
	mov bx,0
	mov cx,0
	mov cl,n
	L5:	
		PUSH cx
		mov cx,0
		mov cl,n
		L6:
			PUSH cx
			mov cx,0
			mov cl,n
			PUSH si
			PUSH di
			mov sum,0
			L7:
				PUSH bx
				mov bl,ary1[si]
				mov al,ary2[di]
				MUL bl
				POP bx
				
				add sum,al
				
				INC si
				mov ax,0
				mov al,n
				add di,ax
			LOOP L7
			
			mov al,sum
			mov ary3[bx],al
			
			INC bx
			POP di
			INC di
			POP si
			POP cx
		LOOP L6
		
		mov di,0
		mov ax,0
		mov al,n
		add si,ax
		POP cx
	LOOP L5

;==========DISPLAYING MATRIX 3 (OUTPUT)===========;

	mov cx,0
	mov cl,n
	mov bx,0
	L8:
		PUSH cx
		mov cx,0
		mov cl,n
		L9:
			CALL Display
			INC bx
		LOOP L9
		POP cx
	LOOP L8

	mov ah,4ch
	int 21h

main endP

;==========PROCEDURE FOR DISPLAYING OUTPUT===========;

Display proc
	PUSH bx
	CMP ary3[bx],9
	JA Two_Digit_Num

	mov ah,02h
	mov dl,ary3[bx]
	add dl,48
	int 21h
	
	mov ah,02h
	mov dl,32
	int 21h

	POP bx
	RET
	
	Two_Digit_Num:		
		mov ax,0
		mov al,ary3[bx]
		mov bl,10
		DIV bl
		
		mov bl,al
		mov bh,ah
		
		mov ah,02h
		mov dl,bl
		add dl,48
		int 21h
	
		mov ah,02h
		mov dl,bh
		add dl,48
		int 21h
		
		mov ah,02h
		mov dl,32
		int 21h
		
	POP bx	
	RET
Display ENDP

end main
