; Assignment 5, Question 1
; Name and Student ID: Sahaj Kataria, 110108041
; Group Member: Mudasir Qureshi
; Lab Section 52

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
askX BYTE "Enter the value for X: ", 0
askY BYTE "Enter the value for Y: ", 0
equalMsg BYTE " = GCD of ", 0
andMsg BYTE " and ", 0
X DWORD ?
Y DWORD ?

.code
main PROC
    ; Ask and read the value for X
    mov edx, OFFSET askX
    call WriteString
    call ReadInt
    mov X, eax  ; Store the read value in 'X'
    call Crlf

    ; Ask and read the value for Y
    mov edx, OFFSET askY
    call WriteString
    call ReadInt
    mov Y, eax  ; Store the read value in 'Y'
    call Crlf

    ; Call the GCD function
    mov eax, X  ; Move 'X' into EAX
    mov ebx, Y  ; Move 'Y' into EBX
    call GCD  ; Call the GCD function, result will be in EAX
    mov ecx, eax  ; Store the GCD result in ECX

    ; Display the result
    mov eax, ecx  ; Move the GCD result to EAX
    call WriteDec
    mov edx, OFFSET equalMsg
    call WriteString
    mov eax, X
    call WriteDec
    mov edx, OFFSET andMsg
    call WriteString
    mov eax, Y
    call WriteDec
    call Crlf

    ; Exit the program
    exit
main ENDP

; Recursive GCD procedure
; Arguments: EAX = X, EBX = Y
; Return: GCD in EAX
GCD PROC
    ; Base case: if Y is 0, return X
    test ebx, ebx  ; Test if EBX (Y) is zero
    jz gcd_done  ; If zero, we're done

    ; Recursive case: GCD(Y, X mod Y)
    mov edx, 0  ; Clear EDX for division
    div ebx  ; Divide EAX by EBX, quotient in EAX, remainder in EDX
    mov eax, ebx  ; Move EBX (Y) into EAX for next call
    mov ebx, edx  ; Move remainder (X mod Y) into EBX for next call
    call GCD  ; Recursive call

    ; Result of recursive call will be in EAX, which is what we want
gcd_done:
    ret
GCD ENDP

END main