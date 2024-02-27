; Assignment 2, Question 2
; Name and Student ID: Sahaj Kataria, 110108041
; Group Members: Ibrahim Arain, Mudasir Qureshi
; Lab Section 52

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    promptMsg   BYTE "Enter value for N: ", 0
    fibMsg      BYTE "Fibonacci sequence with N = ", 0
    isMsg       BYTE " is: ", 0
    fibBuffer   BYTE 256 DUP(0) ; Buffer to store the Fibonacci sequence as a string

.code
main PROC
    mov  edx, OFFSET promptMsg    ; Display prompt message
    call WriteString               ; Invoke Irvine32 WriteString to display prompt

    ; Read N
    call ReadInt                   ; Invoke Irvine32 ReadInt to read input
    mov  ecx, eax                  ; Store N in ECX, which will be the loop counter

    ; Display the header
    mov  edx, OFFSET fibMsg        ; Display the first part of the header
    call WriteString
    mov  eax, ecx                  ; Move N into EAX to display it
    call WriteDec                  ; Display the value of N
    mov  edx, OFFSET isMsg         ; Display the second part of the header
    call WriteString

    ; Display the Fibonacci sequence
    mov  ebx, 0                    ; Initialize Fib(0)
    mov  esi, 1                    ; Initialize Fib(1)

    ; Display the first N Fibonacci numbers
    fibonacciLoop:
        ; Display Fib(N)
        mov  eax, ebx
        call WriteDec               ; Display the current Fibonacci number
        mov  al, ' '
        call WriteChar              ; Display a space after the number

        ; Calculate the next Fibonacci number
        mov  edx, esi
        add  esi, ebx
        mov  ebx, edx
        sub  ecx, 1                  ; Decrease the counter

        ; Check if there are more numbers to display
        jnz  fibonacciLoop           ; Jump to the next iteration if ECX is not zero

    call Crlf                       ; Move to the next line

    exit
main ENDP

END main
