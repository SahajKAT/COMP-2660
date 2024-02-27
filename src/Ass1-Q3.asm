; Assignment 1, Question 3
; Name and Student ID:  Sahaj Kataria, 110108041
; Group Members: Ibrahim Arain, Mudasir Qureshi 
; Lab Section 52

INCLUDE Irvine32.inc    
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    bigEndian BYTE ?, ?, ?, ?   ; Array to store reversed bytes
    littleEndian DWORD ?        ; Variable to store user input
    msgprompt BYTE "Enter an 8 digit hexadecimal number: ", 0  ; Prompt for user input
    msg1 BYTE "bigEndian = ", 0  ; Message for displaying reversed bytes
    msg2 BYTE "littleEndian = ", 0  ; Message for displaying original input
    comma BYTE "h, ", 0         ; Comma and space for formatting
    h BYTE "h", 0               ; 'h' character

.code
main PROC
    ; Prompt and read value for littleEndian
    mov edx, OFFSET msgprompt   ; Display the prompt message
    call WriteString            ; Invoke the Irvine32 WriteString function
    call ReadHex                ; Read a hexadecimal value for littleEndian
    mov littleEndian, eax       ; Store the input in littleEndian

    ; Reverse the bytes and store in bigEndian
    mov eax, littleEndian       ; Copy littleEndian to EAX
    mov [bigEndian+3], al       ; Store the least significant byte in the first element
    shr eax, 8                  ; Shift right to get the next byte
    mov [bigEndian+2], al       ; Store the next byte in the second element
    shr eax, 8                  ; Shift right again
    mov [bigEndian+1], al       ; Store the next byte in the third element
    shr eax, 8                  ; Shift right to get the most significant byte
    mov [bigEndian], al         ; Store the most significant byte in the last element

    ; Display the content of bigEndian
    mov edx, OFFSET msg1        ; Load the message for displaying reversed bytes
    call WriteString            ; Display the message

    mov ecx, LENGTHOF bigEndian ; Initialize loop counter with the total elements in bigEndian
    mov ebx, 0                  ; Initialize index to zero

    printLoop:
        mov ebx, LENGTHOF bigEndian ; Calculate the index by subtracting the loop counter from the total elements
        sub ebx, ecx                ; Move to the next element in the array
        movzx eax, [bigEndian + ebx] ; Load the byte at the current index into EAX
        mov ebx, TYPE bigEndian      ; Set EBX to the size of one element in the array
        call WriteHexB               ; Display the hexadecimal value
        mov edx, OFFSET comma
        call WriteString             ; Display the comma and space

    loop printLoop  

    call Crlf                    ; Move to the next line

    ; Display the value of littleEndian
    mov edx, OFFSET msg2        ; Load the message for displaying original input
    call WriteString            ; Display the message
    mov eax, littleEndian       ; Load the original input
    call WriteHex               ; Display the hexadecimal value
    mov al, 'h'                 ; Load the 'h' character
    call WriteChar              ; Display the 'h' character
    call Crlf                   ; Move to the next line

    invoke ExitProcess, 0       ; Exit the program

main ENDP

END main
