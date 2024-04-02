; Assignment 5, Question 3
; Name and Student ID: Sahaj Kataria, 110108041
; Group Member: Mudasir Qureshi
; Lab Section 52

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    promptA         db "Enter coefficient a: ", 0
    promptB         db "Enter coefficient b: ", 0
    promptC         db "Enter coefficient c: ", 0
    discriminantMsg db "Discriminant: ", 0
    rootMsg         db "The roots are real.", 0
    imaginaryMsg    db "The roots are imaginary.", 0

.code
main PROC
    ; Prompt and read coefficient a
        mov  edx, OFFSET promptA
        call WriteString
        call ReadInt
        mov  ebx, eax                       ; Move input to EBX (coefficient a)
    
    ; Prompt and read coefficient b
        mov  edx, OFFSET promptB
        call WriteString
        call ReadInt
        push eax                            ; Save coefficient b on stack
    
    ; Prompt and read coefficient c
        mov  edx, OFFSET promptC
        call WriteString
        call ReadInt
    ; Now, EAX has c, [ESP] has b, EBX has a

    ; Calculate discriminant b^2 - 4ac
    ; Assuming integer arithmetic for simplicity
        mov  eax, [esp]                     ; Move b into EAX
        imul eax, eax                       ; b^2
        mov  ecx, eax                       ; Save b^2 in ECX
    
        mov  eax, ebx                       ; Move a into EAX
        imul eax, 4                         ; 4a
        imul eax, [esp]                     ; 4a * c
        sub  ecx, eax                       ; b^2 - 4ac, result in ECX
    
    ; Display discriminant
        mov  edx, OFFSET discriminantMsg
        call WriteString
        mov  eax, ecx                       ; Move discriminant back to EAX for printing
        call WriteInt
        call Crlf

    ; Check if discriminant is negative
        cmp  ecx, 0
        jl   ImaginaryRoots                 ; Jump if less than 0 (imaginary roots)
    
    ; If real roots
        mov  edx, OFFSET rootMsg
                   call WriteString
        jmp  Done

    ImaginaryRoots:
        mov  edx, OFFSET imaginaryMsg
        call WriteString

    Done:          
        add  esp, 4                         ; Clean up the stack (pop b)
        call Crlf
        exit
main ENDP

END main