INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    A SBYTE ?
    B SBYTE ?
    CC SBYTE ?
    D SBYTE ?
    Quotient1 SBYTE ?
    Quotient2 SBYTE ?
    R SBYTE ?

    Prompt BYTE "Enter:  ", 0
    promptA BYTE "What is the value of A? ", 0
    promptB BYTE "What is the value of B? ", 0
    promptC BYTE "What is the value of C? ", 0
    promptD BYTE "What is the value of D? ", 0
    equation BYTE "R = ", 0
    promptInvalid BYTE "Invalid out of range ", 0

.code
main PROC
    ; Prompt and read value for A
    mov edx, OFFSET promptA
    call WriteString
    call Crlf
    call ReadSByteInput
    mov A, al

    ; Prompt and read value for B
    mov edx, OFFSET promptB
    call WriteString
    call Crlf
    call ReadSByteInput
    mov B, al

    ; Prompt and read value for C
    mov edx, OFFSET promptC
    call WriteString
    call Crlf
    call ReadSByteInput
    mov CC, al

    ; Prompt and read value for D
    mov edx, OFFSET promptD
    call WriteString
    call Crlf
    call ReadSByteInput
    mov D, al

    mov edx, OFFSET equation
    call WriteString

    ; Calculate A / B and store the result in Quotient1
    movsx eax, A   ; Move A to eax with sign extension
    cwd            ; Sign extend eax into edx:eax
    idiv B         ; Divide edx:eax by B
    mov Quotient1, al      ; Store quotient in Quotient1

    ; Calculate C / D and store the result in Quotient2
    movsx eax, CC  ; Move CC to eax with sign extension
    cwd            ; Sign extend eax into edx:eax
    idiv D         ; Divide edx:eax by D
    mov Quotient2, al      ; Store quotient in Quotient2

    ; Multiply Quotient1 by Quotient2 and store the result in R
    mov al, Quotient1
    imul Quotient2
    mov R, al

    ; Display R
    movsx eax, R  ; Sign-extend R to eax
    call WriteInt ; Display the result
    call Crlf 

    ; Exit the program
    invoke ExitProcess, 0

main ENDP

ReadSByteInput PROC
    push edx  ; Save EDX value as it will be modified within the loop.

PromptInput:
    mov edx, OFFSET prompt  ; Load prompt message address.
    call WriteString        ; Display prompt message.
    call ReadInt            ; Read integer input.
    
    ; Validate input is within the SBYTE range.
    cmp eax, -128
    jl InvalidInput
    cmp eax, 127
    jg InvalidInput

    ; Additional non-zero check for B and D could be performed outside this procedure
    pop edx  ; Restore original EDX value.
    ret

InvalidInput:
    mov edx, OFFSET promptInvalid
    call WriteString        ; Display invalid input message.
    jmp PromptInput         ; Retry input prompt.

ReadSByteInput ENDP

END main
