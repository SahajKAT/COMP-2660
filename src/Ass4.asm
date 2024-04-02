; Assignment 4
; Name and Student ID: Sahaj Kataria, 110108041
; Group Members: Ibrahim Arain, Mudasir Qureshi 
; Lab Section 52

INCLUDE Irvine32.inc
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib
INCLUDELIB Irvine32.lib

.data

initialPrompt BYTE "What do you want to do, Lovely? ", 0
decimalBuffer BYTE 8 DUP(?), 0
hexBuffer BYTE 10 DUP(?), 0

decimalInputPrompt BYTE "Enter a positive unsigned 32-bit number in decimal: ", 0
hexInputPrompt BYTE "Enter a string to turn into binary: ", 0
exitMessage BYTE "Get Lost, you Sweetey Honey Bun", 0
thankYouMessage BYTE "Thank you, Sweetey Honey Bun", 0

.code
main PROC
    ; Display the initial action prompt to the user.
    mov edx, OFFSET initialPrompt
    call WriteString
    call crlf
    ; Read a single character from the user as command input.
    call ReadChar
    call WriteChar
    ; Compare the input with predefined commands ('W', 'w', 'R', 'r').
    cmp al, 57h ; Check for 'W'
    je decimalToHex
    cmp al, 77h ; Check for 'w'
    je decimalToHex
    cmp al, 52h ; Check for 'R'
    je hexToDecimal
    cmp al, 72h ; Check for 'r'
    je hexToDecimal
    ; If input does not match any command, show exit message.
    jmp doneMsg

decimalToHex:
    ; Convert decimal input to hexadecimal.
    call crlf
    mov eax, 0 ; Clear EAX register to store new input.
    mov edx, OFFSET decimalInputPrompt
    call WriteString
    call ReadDec ; Read decimal number input from user.
    mov ebx, eax ; Store the input number in EBX for conversion.
    call HexOutput ; Convert and display the hexadecimal result.
    jmp byeMsg

hexToDecimal:
    ; Convert hexadecimal input to binary.
    call crlf
    mov edx, OFFSET hexInputPrompt
    call WriteString
    call HexInput ; Read and convert the hexadecimal string to binary.
    jmp byeMsg

doneMsg:
    ; Display exit message to the user.
    call crlf
    call crlf
    mov edx, OFFSET exitMessage
    call WriteString
    call crlf
    jmp doneProgram

byeMsg:
    ; Thank the user for using the program.
    call crlf
    mov edx, OFFSET thankYouMessage
    call WriteString
    call crlf

doneProgram:
    ; Clean up and exit the program.
    call crlf
    call WaitMsg
    call crlf
    exit
main ENDP

HexOutput PROC
    ; Convert a decimal number in EBX to a hexadecimal string.
    mov ecx, 8 ; Loop counter for hexadecimal digits.
    mov esi, OFFSET decimalBuffer ; Pointer to store hexadecimal digits.
    Begin_Rotation:
        ROL ebx, 4 ; Rotate left the contents of EBX to process the next nibble.
        mov DL, BL
        AND DL, 0Fh ; Isolate the lowest 4 bits.
        cmp DL, 0Ah ; Check if the nibble is a digit or a letter.
        jb less_ten ; If less than 10, it's a digit.
        add DL, 37h ; Convert to ASCII character for A-F.
        mov [esi], DL
        jmp next
    less_ten:
        add DL, 30h ; Convert to ASCII character for 0-9.
        mov [esi], DL
    next:
        ADD esi, TYPE decimalBuffer ; Move to the next position in the buffer.
        LOOP Begin_Rotation ; Continue until all digits are processed.
        mov BYTE PTR[esi], 68h ; Append 'h' to signify hexadecimal.
        mov edx, OFFSET decimalBuffer ; Prepare the buffer for output.
        call WriteString ; Output the hexadecimal string.
        ret
HexOutput ENDP

HexInput PROC
    ; Convert a hexadecimal string input into binary.
    mov edx, OFFSET hexBuffer ; Pointer to read input string.
    mov ecx, sizeof hexBuffer ; Limit for input read.
    call ReadString ; Read the hexadecimal string from user.
    xor eax, eax ; Clear EAX for result accumulation.
    Read_Next:
        mov bl, [edx] ; Load the next character of the input.
        cmp bl, 'h' ; Check for end of the input string.
        je Finish_Input
        cmp bl, 'A' ; Check if character is a letter.
        jb It_Number ; If below 'A', it's a digit.
        sub bl, 37h ; Adjust ASCII value to get the actual number value.
        shl eax, 4 ; Shift left to make space for the new digit.
        OR al, bl ; Merge the new digit into the result.
        inc edx ; Move to the next character.
        jmp Read_Next
    It_Number:
        sub bl, 30h ; Adjust ASCII value for digit.
        shl eax, 4
        OR al, bl
        inc edx
        jmp Read_Next
    Finish_Input:
        call WriteBin ; Output the result in binary.
        call crlf
        ret
HexInput ENDP

END main
