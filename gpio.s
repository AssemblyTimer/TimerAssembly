@ Colocar uma word para o offset do registrador
@ de dados do pino
@ Porque sao varias classes de pino


.macro MemoryMap
    LDR R0, =fileName     @ R0 = nome do arquivo
    MOV R1, #2        @ Move um hexadecimal para R1
    MOV R7, #5            @ sys_open
    SVC 0
    MOV R4, R0            @ Salva o descritor do arquivo.

    @sys_mmap2
    MOV R0, #0 @NULL
    LDR R1, =pagelen
    LDR R1, [R1] @ pagelen
    MOV R2, #3 @prot read an write
    MOV R3, #1 @map shared
    LDR R5, =gpioaddr
    LDR R5, [R5]
    MOV R7, #192 @sys_mmap2
    SVC 0
    MOV R8, R0
    ADD R8, #0x800
.endm

@R0 => enderedo da primeira word da label em .data
.macro GPIOPinIn pin
    LDR R0, =\pin
	LDR R1, [R0, #0]	@ offset do registrador do pino
	LDR R2, [R0, #4]	@ offset do pino no registrador de funcao	
    LDR R5, [R8, R1]     @ Carrega em R1 o valor do endereço base em R8 com um offset que é o valor de R2
    MOV R0, #0b111       @ Mascara para limpar 3 bits
    LSL R0, R2           @ Faz um deslocamento em R0 com o valor que está em R3
    BIC R5, R0           @ Limpa os 3 bits da posição
    STR R5, [R8, R1]
.endm


@R0 => endereco da primeira word da label em .data
.macro GPIOPinOut pin
    LDR R0, =\pin
	LDR R1, [R0, #0] 	@ offset do registrador do pino
	LDR R2, [R0, #4]	@ offset do pino no registrador de funcao
    LDR R5, [R8, R1]     @ Carrega em R1 o valor do endereço base em R8 com um offset que é o valor de R2
    MOV R0, #0b111       @ Mascara para limpar 3 bits
    LSL R0, R2           @ Faz um deslocamento em R0 com o valor que está em R3
    BIC R5, R0           @ Limpa os 3 bits da posição
    MOV R0, #1           @ Move 1 bit para R0
    LSL R0, R2           @ Faz um deslocamento em R0 com o valor que está em R3
    ORR R5, R0           @ Faz uma operação lógica ORR para adicionar na posição o valor 1
    STR R5, [R8, R1]     @ Armazena no endereço base em R8 com um offset que é o valor de R2, o valor de R1
.endm



@R5 sempre sera o registrador que contera os dados
@a serem manipulados
@ R0 -> endereco da primeira word da label
.macro GPIOPinHigh pin
	LDR R0, =\pin
	LDR R2, [R0, #8] @ offset do pino no registrador de dados
    LDR R1, [R0, #12]
    LDR R5, [R8, R1] @ endereco base + registrador de dados
    MOV R4, #1
    LSL R4, R2
    ORR R5, R4
    STR R5, [R8, R1]
.endm
    

@ R0 -> endereco da primeira word da label
.macro GPIOPinLow pin
    LDR R0, =\pin
    LDR R1, [R0, #12]
	LDR R2, [R0, #8]
    LDR R5, [R8, R1] @ endereco base + offset do registrador de dados
    MOV R4, #1
    LSL R4, R2
    BIC R5, R4
    STR R5, [R8, R1]
.endm



@R5 sempre sera o registrador que contera os dados
@a serem manipulados
@ R0 -> endereco da primeira word da label
FGPIOPinHigh:
    LDR R2, [R0, #8]
    LDR R1, [R0, #12]
    LDR R5, [R8, R1]
    MOV R4, #1
    LSL R4, R2
    ORR R5, R4
    STR R5, [R8, R1]
    POP {LR}
    BX LR


@ R0 -> endereco da primeira word da label
FGPIOPinLow:
    LDR R2, [R0, #8]
    LDR R1, [R0, #12]
    LDR R5, [R8, R1]
    MOV R4, #1
    LSL R4, R2
    BIC R5, R4
    STR R5, [R8, R1]
    POP {LR}
    BX LR


@ R1 -> retorno
.macro GPIOPinState pin
	LDR R0, =\pin
	LDR R2, [R0, #8] @ offset do pino no registrador de dados
    LDR R1, [R0, #12]
    LDR R3, [R8, R1] @ endereco base + registrador de dados
    MOV R4, #1
    LSL R4, R2
    AND R3, R4
    LSR R1, R3, R2
.endm


@ R1 -> valor a setar no pino
@ R0 -> endereco da primeira word da label
GPIOPinTurn:
    PUSH {LR}
    CMP R1, #1
    BEQ pinHigh
    BLT pinLow
pinHigh:
    LDR R2, [R0, #8]
    LDR R1, [R0, #12]
    LDR R5, [R8, R1]
    MOV R4, #1
    LSL R4, R2
    ORR R5, R4
    STR R5, [R8, R1]
    POP {LR}
    BX LR
pinLow:
    LDR R2, [R0, #8]
    LDR R1, [R0, #12]
    LDR R5, [R8, R1]
    MOV R4, #1
    LSL R4, R2
    BIC R5, R4
    STR R5, [R8, R1]
    POP {LR}
    BX LR


@ Devolve o valor de um bit especifico
@ R0 -> posicao do bit (0-31)
@ R0 -> retorno
.macro getBitState pin pos
    LDR R1, =\pin
    LDR R1, [R8, #12]
    MOV R0, \pos
    MOV R2, #1
    LSL R2, R0
    AND R2, R1
    LSR R2, R0
.endm