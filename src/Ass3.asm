; Assignment 3
; Name and Student ID: Sahaj Kataria, 110108041
; Group Members: Ibrahim Arain, Mudasir Qureshi, Isteyak Isteyak
; Lab Section 52

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    Vector          DWORD 50 DUP(?)
    N               DWORD ?
    tempN           DWORD ?
    isEmpty         DWORD 1

    strInput        BYTE "What do you want to do now? > ", 0
    strInputN       BYTE "What is the size N of Vector? > ", 0
    strVecVal1      BYTE "What are the ", 0
    strVecVal2      BYTE " values in Vector? >", 0

    strSizeN        BYTE "The size of Vector is N = ", 0
    strVec          BYTE "Vector = ", 0

    strVis          BYTE "Vector is ", 0
    strSis          BYTE "Stack is ", 0

    strB_AtoS       BYTE " before ArraytoStack", 0
    strA_AtoS       BYTE " after ArraytoStack", 0

    strB_StoA       BYTE " before StacktoArray", 0
    strA_StoA       BYTE " after StacktoArray", 0

    strB_SR         BYTE " before StackReverse", 0
    strA_SR         BYTE " after StackReverse", 0

    strEmpty        BYTE "Stack is empty.", 0
    strNotEmpty     BYTE "Stack not empty.", 0

    strSpace        BYTE " ", 0
    strInvalidInput BYTE "Invalid input! Please try again.", 0

    strError        BYTE "Error - Stack is empty: Cannot perform StackToArray", 0

    goodbye         BYTE "I am exiting... Thank you Honey... and Get lost...", 0

.code
main PROC
    start:        
        MOV  edx, OFFSET strInput   ; Ask for option
        CALL WriteString
        CALL ReadInt
        CALL crlf
        CMP  eax, -1                ; Check if -1 is input
        JE   exitProgram            ; Exit if -1 is input
        CMP  eax, 0
        JL   invalidInput           ; Jump to invalidInput if input is less than 0
        CMP  eax, 3
        JG   invalidInput           ; Jump to invalidInput if input is greater than 3
        JMP  optionSelected         ; Jump to optionSelected if input is valid

    invalidInput:
        MOV  edx, OFFSET strInvalidInput  ; Output "Invalid input! Please try again."
        CALL WriteString
        CALL crlf
        JMP  start

    optionSelected:
        CMP  eax, 0
        JE   initCall
        CMP  eax, 1
        JE   AtoS
        CMP  eax, 2
        JE   StoA
        CMP  eax, 3
        JE   SR
        JMP  mainDone               ; Jump to mainDone if invalid input

    initCall:
        LEA  esi, Vector
        CALL Initialize
        JMP  start

    AtoS:
        LEA  esi, Vector
        CALL ArraytoStack
        JMP  start

    StoA:
        LEA  esi, Vector
        CALL StacktoArray
        JMP  start

    SR:
        LEA  esi, Vector
        CALL StackReverse
        JMP  start

    mainDone:

exitProgram:
    MOV  edx, OFFSET goodbye   ; Ask for option
    CALL WriteString
    CALL crlf
    exit

main ENDP

Initialize PROC
    MOV  N, 0
    MOV  edx, OFFSET strInputN
    CALL WriteString
    CALL ReadInt
    MOV  N, eax

    MOV  edx, OFFSET strVecVal1
    CALL WriteString
    mov  eax, N
    CALL WriteDec
    MOV  edx, OFFSET strVecVal2
    CALL WriteString
    CALL ReadVector

    MOV  edx, OFFSET strSizeN
    CALL WriteString
    MOV  eax, N
    CALL WriteDec
    CALL crlf

    MOV  edx, OFFSET strVec
    CALL WriteString
    LEA  esi, Vector
    CALL WriteVector
    CALL crlf
    
    CMP  isEmpty, 1
    JNE  notEmpty
    MOV  edx, OFFSET strEmpty
    CALL WriteString
    CALL crlf
    CALL crlf
    RET

notEmpty:
    MOV  edx, OFFSET strNotEmpty
    CALL WriteString
    CALL crlf
    CALL crlf
    RET
Initialize ENDP

ArraytoStack PROC                                 ;;;ArraytoStack Procedure
                  MOV  isEmpty, 0
                  MOV  ecx, N                     ;Loop iterations #
                  LEA  esi, Vector
    PushonStack:                                  ;;;Add to stack
                  MOV  ebx, [esi]                 ;Add element to ebx
                  PUSH ebx                        ;Push ebx to stack
                  ADD  esi, 4                     ;Increment to next element
                  Loop PushonStack                ;Increment loop count

                  MOV  edx, OFFSET strVis         ;;;Output Vector
                  CALL WriteString
                  LEA  esi, Vector
                  CALL WriteVector
                  MOV  edx, OFFSET strB_AtoS
                  CALL WriteString
                  CALL crlf
  
                  MOV  edx, OFFSET strSis         ;;;Output Stack
                  CALL WriteString
                  MOV  ecx, N                     ;Loop iterations #
    PrintStack:   
                  POP  eax                        ;Pop top element to eax
                  CALL WriteInt                   ;Write eax
                  MOV  edx, OFFSET strSpace       ;Add a space
                  CALL WriteString
                  Loop PrintStack                 ;Increment loop counter
                  MOV  edx, OFFSET strA_AtoS
                  CALL WriteString
                  CALL crlf

                  MOV  edx, OFFSET strVis         ;;;Output Vector
                  CALL WriteString
                  WriteZeroes PROC
                        MOV  ecx, N
                        MOV  eax, 0   ; The value to be printed (zero)
                    PrintZero:
                        CALL WriteDec
                        DEC  ecx
                        CMP  ecx, 0
                        JNE  PrintSpace
                        MOV  edx, OFFSET strA_AtoS
                        CALL WriteString
                        Call crlf
                        MOV  edx, OFFSET strNotEmpty       ;;;Empty output
                        CALL WriteString
                        Call crlf
                        Call crlf
                        RET
                    PrintSpace:
                        MOV  edx, OFFSET strSpace
                        CALL WriteString
                        JMP  PrintZero
                    WriteZeroes ENDP
                
                  CMP  isEmpty, 1                 ;;;Is stack empty?
                  JNE  notEmpty                   ;If empty (1), continue, otherwise jump to notEmpty
                  MOV  edx, OFFSET strEmpty       ;;;Empty output
                  CALL WriteString
                  RET
  
    notEmpty:                                     ;;;NotEmpty output
                  MOV  edx, OFFSET strNotEmpty
                  CALL WriteString
                  CALL crlf
                  RET
ArraytoStack ENDP                                 ;;;ArraytoStack End Procedure

StacktoArray PROC                                 ;;;StacktoArray Procedure
                  CMP  isEmpty, 1                                ; Check if stack is empty
                  JE   StackEmptyError                            ; If stack is empty, jump to error
                  MOV  isEmpty, 1
                  MOV  ecx, N
                  LEA  esi, Vector
    PushStack:                                    ;;;Add back to stack
                  MOV  ebx, [esi]                 ;Move element to ebx
                  PUSH ebx                        ;Push ebx to stack
                  ADD  esi, 4                     ;Increment array element
                  Loop PushStack                  ;Increment loop counter

                  MOV  edx, OFFSET strSis         ;;;Output Stack
                  CALL WriteString
                  MOV  ecx, N
    PrintStack:                                   ;;;Printing Stack
                  POP  eax                        ;Pop top to eax
                  CALL WriteInt                   ;Write eax
                  MOV  edx, OFFSET strSpace       ;Add a space
                  CALL WriteString
                  Loop PrintStack                 ;Increment loop counter
                  MOV  edx, OFFSET strB_StoA
                  CALL WriteString
                  CALL crlf

                  MOV  ecx, N
                  LEA  esi, Vector
    PushBackStack:                                ;;;Add back to stack
                  MOV  ebx, [esi]                 ;Move element to ebx
                  PUSH ebx                        ;Push ebx to stack
                  ADD  esi, 4                     ;Increment element
                  Loop PushBackStack              ;Increment loop counter

                  LEA  esi, Vector
                  MOV  eax, N                     ;;;Getting to last element of array
                  MOV  edx, 4
                  MUL  edx                        ;N*4 for size of array
                  SUB  eax, 4                     ;Subtract 4 to find location of beginning of last element
                  MOV  tempN, eax
                  MOV  ecx, N
                  ADD  esi, tempN                 ;Starting from the last element location
    intoArray:                                    ;;;Add stack to array
                  POP  eax                        ;Pop top element to eax
                  MOV  [esi], eax                 ;Move eax to last array position
                  SUB  esi, 4                     ;Decrement element
                  Loop intoArray                  ;Increment loop counter

                  MOV  edx, OFFSET strVis         ;;;Output Vector
                  CALL WriteString
                  LEA  esi, Vector
                  CALL WriteVector
                  MOV  edx, OFFSET strA_StoA
                  CALL WriteString
                  CALL crlf

                  CMP  isEmpty, 1                 ;;;Is stack empty?
                  JNE  notEmpty                   ;If empty (1), continue, otherwise jump to notEmpty
                  MOV  edx, OFFSET strEmpty       ;;;Empty output
                  CALL WriteString
                  CALL crlf
                  CALL crlf
                  RET

    notEmpty:                                     ;;;NotEmpty output
                  MOV  edx, OFFSET strNotEmpty
                  CALL WriteString
                  CALL crlf
                  CALL crlf
                  RET
    StackEmptyError:
                  MOV  edx, OFFSET strError                      ; Output "Error – Stack is empty: Cannot perform StackToArray"
                  CALL WriteString
                  CALL crlf
                  RET
StacktoArray ENDP                                 ;;;StacktoArray End Procedure

StackReverse PROC                                 ;;;StackReverse Procedure
                  MOV  isEmpty, 0
                  MOV  ecx, N
                  LEA  esi, Vector
    PushStack:                                    ;;;Add back to stack
                  MOV  ebx, [esi]                 ;Move element to ebx
                  PUSH ebx                        ;Push ebx to stack
                  ADD  esi, 4                     ;Increment element
                  Loop PushStack                  ;Increment loop counter

                  MOV  edx, OFFSET strVis         ;;;Output Vector
                  CALL WriteString
                  LEA  esi, Vector
                  CALL WriteVector
                  MOV  edx, OFFSET strB_SR
                  CALL WriteString
                  CALL crlf

                  CMP  isEmpty, 1                 ;;;Is stack empty?
                  JNE  notEmpty                   ;If empty (1), continue, otherwise jump to notEmpty
                  MOV  edx, OFFSET strEmpty       ;;;Empty output
                  CALL WriteString
                  CALL crlf
                  JMP  skip                       ;;;Skip NotEmpty if it was empty

    notEmpty:                                     ;;;NotEmpty output
                  MOV  edx, OFFSET strNotEmpty
                  CALL WriteString
                  CALL crlf
  
    skip:                                         ;;;Skip to here
                  MOV  isEmpty, 1
                  MOV  ecx, N
                  LEA  esi, Vector
    PushBackArray:                                ;;;Add back to Array
                  POP  eax                        ;Pop top element to eax
                  MOV  [esi], eax                 ;Move eax to array
                  ADD  esi, 4                     ;Increment element
                  Loop PushBackArray              ;Increment loop counter

                  MOV  edx, OFFSET strVis         ;;;Output Vector
                  CALL WriteString
                  LEA  esi, Vector
                  CALL WriteVector
                  MOV  edx, OFFSET strA_SR
                  CALL WriteString
                  CALL crlf

                  CMP  isEmpty, 1                 ;;;Is stack empty?
                  JNE  notEmptyAfter              ;If empty (1), continue, otherwise jump to notEmpty
                  MOV  edx, OFFSET strEmpty       ;;;Empty output
                  CALL WriteString
                  CALL crlf
                  CALL crlf
                  RET
    notEmptyAfter:                                ;;;NotEmpty output
                  MOV  edx, OFFSET strNotEmpty
                  CALL WriteString
                  CALL crlf
                  CALL crlf
                  RET
StackReverse ENDP                                 ;;;StackReverse End Procedure

ReadVector PROC                                   ;;;ReadVector Procedure
                  MOV  ecx, N
    NextInt:                                      ;;;Add each element to the array
                  CALL ReadInt
                  MOV  [esi], eax
                  ADD  esi, 4
                  Loop NextInt
                  RET
ReadVector ENDP                                   ;;;ReadVector End Procedure

WriteVector PROC                                  ;;;WriteVecotor Procedure
                  MOV  ecx, N
    NextVec:                                      ;;;Print out each array element
                  MOV  eax, [esi]
                  CALL WriteInt
                  MOV  edx, OFFSET strSpace
                  CALL WriteString
                  ADD  esi, 4
                  Loop NextVec
                  RET
WriteVector ENDP                                  ;;;WriteVector End Procedure

END main