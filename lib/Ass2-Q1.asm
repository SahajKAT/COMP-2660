; Assignment 2, Question 1
; Name and Student ID: Sahaj Kataria, 110108041
; Group Members: Ibrahim Arain, Mudasir Qureshi
; Lab Section 52

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    ; Messages and prompts
    promptSizeMsg     BYTE 0Ah, "What is the size N of Vector? > ", 0
    error1            BYTE "Size must be positive or zero! Please enter a non-negative number: ", 0
    promptValuesMsg   BYTE "What are the ", 0
    promptValuesMsg2  BYTE " values in Vector? > ", 0
    vector            SDWORD 50 DUP(?) ; Array to store integers
    vectorSize        DWORD ?

    vectorSizeMsg     BYTE 0Ah, "Size of Vector is N = ", 0
    vectorDisplay     BYTE 0Ah, "Vector = ", 0

    negativeMsg       BYTE 0Ah, "The sum of all the negative values in Vector is: Sum = ", 0
    NegativeSum       DWORD 0
    positiveMsg       BYTE "The number of all the positive values in Vector is: Count = ", 0
    PositiveCount     DWORD 0
         
    promptIJ          BYTE 0Ah, "Please give me two values I and J such that 1 <= I <= J <= N > ", 0
    error2            BYTE "Invalid I or J! Please enter again: ", 0
    I                 DWORD ?
    J                 DWORD ?
    printI            BYTE "I = ", 0
    printJ            BYTE " and J = ", 0
    printand          BYTE ", and", 0Ah, 0
    Minimum           DWORD ?
    printMin1         BYTE "The minimum value between position ", 0
    printMin2         BYTE " and ", 0
    printMin3         BYTE " of Vector is: Minimum = ", 0   

    isPalindrome      BYTE 0Ah, "Vector is a palindrome because it reads the same way in both directions.", 0
    isNotPalindrome   BYTE 0Ah, "Vector is NOT a palindrome", 0

    repeatPromptMsg   BYTE 0Ah, "Repeat with a new Vector of different size and/or content? > ", 0

.code
main PROC
    getVectorSize:           
        mov  edx, OFFSET promptSizeMsg ; Display prompt for vector size
        call WriteString
        call ReadInt
        mov  vectorSize, eax
        cmp  vectorSize, 0
        jge  validSize
        mov  edx, OFFSET error1 ; Display error message for non-positive vector size
        call WriteString
        jmp  getVectorSize

    validSize:            
        mov  edx, OFFSET promptValuesMsg ; Display prompt for vector values
        call WriteString
        mov  eax, vectorSize
        call WriteDec
        mov  edx, OFFSET promptValuesMsg2
        call WriteString
        mov  ecx, vectorSize
        mov  esi, 0

    readVectorLoop:       
        test ecx, ecx
        jz   finishedReading
        call ReadInt
        mov  vector[esi * TYPE vector], eax
        add  esi, 1
        loop readVectorLoop

    finishedReading:      
        mov  ecx, vectorSize
        mov  esi, 0

    promptToUser:
        mov  edx, OFFSET vectorSizeMsg ; Display size information of vector
        call WriteString
        mov  eax, vectorSize
        call WriteDec
        mov  edx, OFFSET vectorDisplay ; Display vector values
        call WriteString

    printVectorLoop:      
        test ecx, ecx
        jz   done
        mov  eax, vector[esi * TYPE vector]
        call WriteInt
        mov  al, ' '
        call WriteChar
        add  esi, 1
        loop printVectorLoop
        call Crlf

     done:                 
        mov  esi, OFFSET vector
        mov  ecx, VectorSize
        mov  eax, 0

     check_loop:           
        mov  eax, [esi]
        cmp  eax, 0
        jle  not_pos
        inc  PositiveCount
        not_pos:              
            add  esi, TYPE Vector
        loop check_loop
        mov  eax, 0
        mov  esi, OFFSET Vector
        mov  ecx, VectorSize

    loop_start:           
        mov  edx, [esi]
        cmp  edx, 0
        jge  not_negative
        add  eax, edx
        
    not_negative:         
        add  esi, 4
        loop loop_start
        mov  edx, OFFSET negativeMsg
        call WriteString
        mov  NegativeSum, eax
        mov  eax, NegativeSum
        call WriteInt
        call Crlf
        mov  esi, OFFSET vector
        mov  edi, OFFSET vector
        add  edi, vectorSize
        dec  edi  
        dec  edi
        dec  edi
        dec  edi
        mov  ecx, vectorSize
        shr  ecx, 1 

    positiveMsgToUser:
        mov  edx, OFFSET positiveMsg
        call WriteString
        mov  eax, PositiveCount
        call WriteDec
        call Crlf

    getIJ:     
        mov  edx, OFFSET promptIJ ; Prompt for values I and J
        call WriteString
        call ReadInt
        mov  I, eax
        call ReadInt
        mov  J, eax
        mov eax, I
        cmp eax, 1
        jl invalidIJ
        mov eax, J
        cmp eax, 1
        jl invalidIJ
        mov eax, I
        cmp eax, vectorSize
        jg invalidIJ
        mov eax, J
        cmp eax, vectorSize
        jg invalidIJ
        jmp  validIJ

    invalidIJ:
        mov  edx, OFFSET error2 ; Display error message for invalid I or J
        call WriteString
        jmp  getIJ

    validIJ:
        mov  edx, OFFSET printI ; Display values of I and J
        call WriteString
        mov  eax, I
        call WriteDec
        mov  edx, OFFSET printJ
        call WriteString
        mov  eax, J
        call WriteDec
        mov  edx, OFFSET printand
        call WriteString
        call Crlf

    IandJ:
        mov  eax, I 
        dec  eax    
        mov  ecx, J    
        sub  ecx, eax 
        inc  ecx 
        mov  esi, eax   
        mov  eax, vector[esi * 4] ; Get the value at position I
        mov  Minimum, eax

    findMinLoop:     
        cmp  ecx, 0
        je   displayMin                    
        mov  eax, vector[esi * 4] ; Get the value at the current position
        cmp  eax, Minimum
        jge  noUpdate                        
        mov  Minimum, eax                 

    noUpdate:        
        add  esi, 1                       
        loop findMinLoop

    displayMin:      
        mov  edx, OFFSET printMin1 ; Display minimum value and positions
        call WriteString
        mov  eax, I
        call WriteDec
        mov  edx, OFFSET printMin2
        call WriteString
        mov  eax, J
        call WriteDec
        mov  edx, OFFSET printMin3
        call WriteString
        mov  eax, Minimum
        call WriteInt 
        call Crlf

    palindrome:
        mov  esi, OFFSET vector
        mov  edi, OFFSET vector
        mov  ecx, vectorSize
        dec  ecx
        imul ecx, ecx, 4
        lea  edi, [edi + ecx]
        mov  ecx, vectorSize
        shr  ecx, 1

    palindrome_check:     
        cmp  ecx, 0
        je   is_palindrome  
        mov  eax, [esi]  ; Get value from the beginning of the vector
        mov  edx, [edi]  ; Get value from the end of the vector
        cmp  eax, edx
        jne  not_a_palindrome 
        add  esi, 4 
        sub  edi, 4 
        dec  ecx   
        jmp  palindrome_check  

    is_palindrome:        
        mov  edx, OFFSET isPalindrome ; Display palindrome message
        call WriteString
        jmp  done_palindrome_check

    not_a_palindrome:     
        mov  edx, OFFSET isNotPalindrome ; Display not a palindrome message
        call WriteString

    done_palindrome_check:
        call Crlf

    repeatPrompt:
        mov  edx, OFFSET repeatPromptMsg ; Prompt to repeat with a new vector
        call WriteString
        call ReadChar
        cmp  al, 'Y'
        je   main
        cmp  al, 'y'
        jmp  main ; If not 'Y' or 'y', exit the program

    call Crlf
    exit

main ENDP
END main