; Assignment 2, Question 3
; Name and Student ID: Sahaj Kataria, 110108041
; Group Members: Ibrahim Arain, Mudasir Qureshi
; Lab Section 52

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    inputMsg        BYTE "Enter a string of at most 128 characters: ", 0
    outputMsg1      BYTE "Here it is, with all lowercases and uppercases flipped, and in reverse order:", 0
    outputMsg2      BYTE "There are ", 0
    outputMsg3      BYTE " upper-case letters after conversion.", 0
    outputMsg4      BYTE "There are ", 0
    outputMsg5      BYTE " characters in the string.", 0
    buffer          BYTE 128 DUP(?)         ; Buffer to store the original string
    reversedBuffer  BYTE 128 DUP(?)         ; Buffer to store the reversed string
    uppercaseCount  DWORD ?                  ; Counter for uppercase letters
    lengthh         DWORD ?                  ; Variable to store the length of the string

.code
main PROC
    ; Step 1: Read the string
    mov  edx, OFFSET inputMsg       ; Display prompt message
    call WriteString                ; Invoke Irvine32 WriteString to display prompt
    mov  ecx, SIZEOF buffer - 1     ; Set maximum length of input
    mov  edx, OFFSET buffer         ; Set buffer address
    call ReadString                 ; Invoke Irvine32 ReadString to read input
    mov  lengthh, eax               ; Store the length of the string

    ; Step 2: Convert cases and count uppercase letters
    mov  esi, OFFSET buffer         ; Set source address
    mov  edi, OFFSET reversedBuffer ; Set destination address
    mov  uppercaseCount, 0          ; Initialize uppercase counter

    caseConversionLoop:
        mov  al, [esi]               ; Load a character from the source
        cmp  al, 0                   ; Check if it's the end of the string
        je   reverseString           ; Jump to reverseString if end of string
        cmp  al, 'a'                 ; Compare with lowercase 'a'
        jb   notLowercase            ; Jump if below 'a' (not a lowercase letter)
        cmp  al, 'z'                 ; Compare with lowercase 'z'
        ja   notLowercase            ; Jump if above 'z' (not a lowercase letter)
        sub  al, 32                  ; Convert lowercase to uppercase
        inc  uppercaseCount          ; Increment uppercase counter
        jmp  storeAndIncrement       ; Jump to storeAndIncrement

        notLowercase:
            cmp  al, 'A'             ; Compare with uppercase 'A'
            jb   storeAndIncrement   ; Jump if below 'A' (not an uppercase letter)
            cmp  al, 'Z'             ; Compare with uppercase 'Z'
            ja   storeAndIncrement   ; Jump if above 'Z' (not an uppercase letter)
            add  al, 32              ; Convert uppercase to lowercase

        storeAndIncrement:
            mov  [esi], al           ; Store the converted character back
            inc  esi                 ; Move to the next character
            jmp  caseConversionLoop  ; Repeat the loop

    ; Step 3: Reverse the string
    reverseString:
        mov  ecx, lengthh            ; Load the length of the string
        mov  esi, OFFSET buffer      ; Set source address to the original string
        add  esi, ecx                ; Move source address to the end of the string

        reverseLoop:
            dec  esi                 ; Move backward in the source string
            mov  al, [esi]           ; Load a character from the reversed position
            mov  [edi], al           ; Store the character in the reversedBuffer
            inc  edi                 ; Move to the next position in the destination
            loop reverseLoop         ; Repeat the loop until all characters are processed

    ; Step 4: Display the reversed string
    mov  edx, OFFSET outputMsg1     ; Display the header message
    call WriteString
    mov  edx, OFFSET reversedBuffer ; Set the address of the reversed string
    call WriteString                ; Display the reversed string
    call Crlf                       ; Move to the next line

    ; Step 5: Display counts
    mov  edx, OFFSET outputMsg2     ; Display the message about uppercase letters
    call WriteString
    mov  eax, uppercaseCount        ; Load the uppercase count
    call WriteDec                    ; Display the uppercase count
    mov  edx, OFFSET outputMsg3     ; Display the remaining part of the message
    call WriteString
    mov  edx, OFFSET outputMsg4     ; Display the message about total characters
    call WriteString
    mov  eax, lengthh                ; Load the length of the string
    call WriteDec                    ; Display the length of the string
    mov  edx, OFFSET outputMsg5     ; Display the remaining part of the message
    call WriteString

    exit
main ENDP

END main
