; Assignment 1, Question 2
; Name and Student ID: Sahaj Kataria, 110108041
; Group Members: Ibrahim Arain, Mudasir Qureshi 
; Lab Section 52

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    bigEndian BYTE 12h, 34h, 0ABh, 0CDh   ; Input array in big-endian format
    littleEndian DWORD ?                    ; Output variable for little-endian format
    Msg1 BYTE "bigEndian = ", 0             ; Message to display big-endian array
    Msg2 BYTE "littleEndian = ", 0          ; Message to display little-endian value
    comma BYTE "h, ", 0                     ; Comma and space for formatting
    h BYTE "h", 0                           ; 'h' character for formatting

.code
main PROC
    ; Display bigEndian array values
    mov edx, OFFSET Msg1        ; Set the address of the message
    call WriteString            ; Display the message

    ; Loop to print bigEndian array values in hexadecimal
    mov edx, OFFSET comma       ; Set the address of the comma
    mov ecx, LENGTHOF bigEndian ; Set the loop counter (ECX = 4, as there are 4 elements)

    printLoop:
        mov ebx, LENGTHOF bigEndian ; Calculate the index by subtracting the loop counter from the total elements
        sub ebx, ecx                ; Move to the next element in the array
        movzx eax, [bigEndian + ebx] ; Load the byte at the current index into EAX
        mov ebx, TYPE bigEndian      ; Set EBX to the size of one element in the array
        call WriteHexB               ; Display the hexadecimal value
        call WriteString             ; Display the comma and space

    loop printLoop                  ; Continue looping until ECX becomes zero (all elements displayed)

    call Crlf                       ; Move to the next line

    ; Display littleEndian value
    mov edx, OFFSET Msg2            ; Set the address of the message
    call WriteString                ; Display the message

    ; Little-endian conversion code
    mov AL, [bigEndian]             ; Move the first byte of bigEndian to AL
    mov [bigEndian+7], AL           ; Store it in the last byte of littleEndian
    mov AL, [bigEndian+1]           ; Move the second byte of bigEndian to AL
    mov [bigEndian+6], AL           ; Store it in the second-to-last byte of littleEndian
    mov AL, [bigEndian+2]           ; Move the third byte of bigEndian to AL
    mov [bigEndian+5], AL           ; Store it in the third-to-last byte of littleEndian
    mov AL, [bigEndian+3]           ; Move the fourth byte of bigEndian to AL
    mov [bigEndian+4], AL           ; Store it in the fourth-to-last byte of littleEndian

    mov EAX, [littleEndian]         ; Load the littleEndian value into EAX
    call WriteHex                   ; Display the littleEndian value in hexadecimal
    mov al, 'h'                      ; Display 'h' character for formatting
    call WriteChar                  ; Display the 'h' character

    call Crlf                       ; Move to the next line

    invoke ExitProcess, 0           ; Exit the program

main ENDP

END main
