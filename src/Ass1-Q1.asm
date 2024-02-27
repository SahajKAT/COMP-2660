; Assignment 1, Question 1
; Name and Student ID: Sahaj Kataria, 110108041
; Group Members: Ibrahim Arain, Mudasir Qureshi 
; Lab Section 52

INCLUDE Irvine32.inc    
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    A SDWORD -543210           ; Initialize A as a 32-bit signed integer with -543210
    B SWORD -3210              ; Initialize B as a 16-bit signed integer with -3210
    CC SDWORD ?              ; Declare C as a 32-bit signed integer, C can't be used independently so CC is used
    D SBYTE ?                  ; Declare D as an 8-bit signed integer
    Z SDWORD ?                 ; Declare Z to hold the result of the expression

    promptC BYTE "What is the value of C? ", 0          ; Prompt for user input for variable C
    promptD BYTE "What is the value of D? ", 0          ; Prompt for user input for variable D
    equation BYTE "Z = (A - B) - (C - D) ", 0Ah,0        ; Display the equation
    semicolon BYTE "   ;   ", 0                          ; Semicolon for formatting
    resultBinary BYTE "Binary: ", 0                       ; Display label for binary result
    resultDecimal BYTE "Decimal: ", 0                     ; Display label for decimal result
    resultHeximal BYTE "Hexadecimal: ", 0                 ; Display label for hexadecimal result

.code
main PROC
    ; Initialize registers
    mov eax, A
    movsx ebx, B
    sub eax, ebx    ; Compute (A - B) and store result in EAX

    ; Prompt and read value for C
    mov edx, OFFSET promptC
    call WriteString   ; Display prompt
    call ReadInt       ; Read user input as integer
    mov CC, eax        ; Store the input value in CC

    ; Prompt and read value for D
    mov edx, OFFSET promptD
    call WriteString   ; Display prompt
    call ReadInt       ; Read user input as integer
    movsx edx, al      ; Sign-extend the 8-bit input to 32-bit
    mov D, dl          ; Store the value in D

    ; Compute (C - D)
    mov eax, CC
    sub eax, edx       ; Subtract D from C and store result in EAX

    ; Compute (A - B) - (C - D)
    mov ebx, eax       ; Save (C - D) in EBX
    mov eax, A         ; Reload A into EAX
    movsx ecx, B       ; Sign-extend B to 32-bit and store in ECX
    sub eax, ecx       ; Compute (A - B)
    sub eax, ebx       ; Subtract (C - D) from (A - B) and store result in EAX
    mov Z, eax         ; Store the final result in Z

    ; Print equation for Z and values of variables A, B, C, D
    mov edx, OFFSET equation
    call WriteString   ; Display the equation
    
    mov eax, A 
    call WriteInt      ; Display value of A
    mov edx, OFFSET semicolon ; Print semicolon
    call WriteString

    ; Print B
    movsx eax, B
    call WriteInt      ; Display value of B
    mov edx, OFFSET semicolon ; Print semicolon
    call WriteString

    ; Print C
    mov eax, CC
    call WriteInt      ; Display value of C
    mov edx, OFFSET semicolon ; Print semicolon
    call WriteString

    ; Print D
    movzx eax, D
    call WriteInt      ; Display value of D
    call Crlf           ; Move to the next line

    ; Display the final result in binary, decimal, and hexadecimal
    call Crlf
    mov edx, OFFSET resultBinary ; Display label for binary result
    call WriteString   ; Write "Binary: "
    mov eax, Z
    call WriteBin      ; Display Z in binary
    call Crlf           ; Move to the next line
    mov edx, OFFSET resultDecimal ; Display label for decimal result
    call WriteString   ; Write "Decimal: "
    mov eax, Z
    call WriteInt      ; Display Z in decimal
    call Crlf           ; Move to the next line
    mov edx, OFFSET resultHeximal ; Display label for hexadecimal result
    call WriteString   ; Write "Hexadecimal: "
    mov eax, Z
    call WriteHex      ; Display Z in hexadecimal
    call Crlf           ; Move to the next line

    ; Exit the program
    invoke ExitProcess, 0

main ENDP

END main
