/*
======================================================
        Faz o mapeamento dos GPIO na memória

        | Realiza chamadas a open e mmap2
        para o mapeamento dos GPIO |
======================================================
*/
.macro MemoryMap
    @sys_open
    LDR R0, =fileName @ R0 = nome do arquivo
    MOV R1, #2 @ O_RDWR (permissao de leitura e escrita pra arquivo)
    MOV R7, #5 @ sys_open
    SVC 0
    MOV R4, R0 @ salva o descritor do arquivo.

    @sys_mmap2
    MOV R0, #0 @ NULL (SO escolhe o endereco)
    LDR R1, =pagelen
    LDR R1, [R1] @ tamanho da pagina de memoria
    MOV R2, #3 @ protecao leitura ou escrita
    MOV R3, #1 @ memoria compartilhada
    LDR R5, =gpioaddr @ endereco GPIO / 4096
    LDR R5, [R5]
    MOV R7, #192 @sys_mmap2
    SVC 0
    MOV R8, R0
    ADD R8, #0x800 @ endereco base
.endm


/*
======================================================
        Altera o modo de ~pin~
        para entrada
======================================================
*/
.macro GPIOPinIn pin
    LDR R0, =\pin       @ carrega o endereco de memoria de ~pin~
	LDR R1, [R0, #0]	@ offset do registrador de funcao do pino
	LDR R2, [R0, #4]	@ offset do pino no registrador de funcao (LSB)
    LDR R5, [R8, R1]     @ conteudo do registrador de dados do pino
    MOV R0, #0b111       @ mascara para limpar 3 bits
    LSL R0, R2           @ desloca @111 para posicao do pino no registrador de funcao
    BIC R5, R0           @ limpa os 3 bits da posicao
    STR R5, [R8, R1]    @ armazena o novo valor do registrador de funcao na memoria
.endm


/*
======================================================
        Altera o modo de ~pin~
        para saida
======================================================
*/
.macro GPIOPinOut pin
    LDR R0, =\pin       @ carrega o endereco de memoria de ~pin~
	LDR R1, [R0, #0] 	@ offset do registrador de funcao do pino
	LDR R2, [R0, #4]	@ offset do pino no registrador de funcao (LSB)
    LDR R5, [R8, R1]     @ conteudo do registrador de dados do pino
    MOV R0, #0b111       @ mascara para limpar 3 bits
    LSL R0, R2           @ desloca @111 para posicao do pino no registrador
    BIC R5, R0           @ limpa os 3 bits da posição
    MOV R0, #1           @ move 1 para R0
    LSL R0, R2           @ desloca o bit para a posicao de pino no registrador de funcao
    ORR R5, R0           @ adiciona o valor 1 na posicao anteriomente deslocada
    STR R5, [R8, R1]     @ armazena o novo valor do registrador de funcao na memoria
.endm


/*
======================================================
        Altera o estado de ~pin~
        para alto (1)
======================================================
*/
.macro GPIOPinHigh pin
	LDR R0, =\pin @ carrega o endereco de ~pin~
	LDR R2, [R0, #8] @ offset do pino no registrador de dados
    LDR R1, [R0, #12] @ offset do registrador de dados do pino
    LDR R5, [R8, R1] @ endereco base + registrador de dados
    MOV R4, #1 @ move 1 para R4
    LSL R4, R2 @ desloca o bit para a posicao do pino no registrador de dados
    ORR R3, R5, R4 @ insere 1 na posicao anteriomente deslocada
    STR R3, [R8, R1] @ armazena o novo valor do registrador de dados na memoria
.endm    


/*
======================================================
        Altera o estado de ~pin~
        para baixo (0)
======================================================
*/
.macro GPIOPinLow pin
    LDR R0, =\pin
    LDR R1, [R0, #12] @ offset do registrador de dados do pino
	LDR R2, [R0, #8] @ offset do pino no registrador de dados
    LDR R5, [R8, R1] @ endereco base + offset do registrador de dados
    MOV R4, #1 @ move 1 para R4
    LSL R4, R2@ desloca para R4 R4 R2 vezes
    BIC R3, R5, R4 @ insere 1 na posicao anteriomente deslocada
    STR R3, [R8, R1] @ armazena o novo valor do registrador de dados na memoria
.endm


/*
======================================================
        Altera o estado de ~pin~
        para alto (1)

        Parametros:
            R0: endereco da label
                que representa o pino
======================================================
*/
FGPIOPinHigh:
    LDR R2, [R0, #8] @ offset do pino no registrador de dados
    LDR R1, [R0, #12] @ offset do registrador de dados do pino
    LDR R5, [R8, R1] @ conteudo do registrador de dados
    MOV R4, #1 @ move 1 para R4
    LSL R4, R2 @ desloca para R4 o que tem em R4 (1) R2 vezes
    ORR R5, R4 @ insere 1 na posicao anteriormente deslocada
    STR R5, [R8, R1] @ armazena o novo conteudo do registrador de dados na memoria
    BX LR


/*
======================================================
        Altera o estado de ~pin~
        para baixo (0)

        Parametros:
            R0: endereco da label
                que representa o pino
======================================================
*/
FGPIOPinLow:
    LDR R2, [R0, #8] @ offset do pino no registrador de dados
    LDR R1, [R0, #12] @ offset do registrador de dados do pino
    LDR R5, [R8, R1] @ conteudo do registrador de dados
    MOV R4, #1 @ move 1 para R4
    LSL R4, R2 @ desloca para R4 o que tem em R4 (1) R2 vezes
    BIC R5, R4 @ limpa o bit na posicao anteriormente deslocada
    STR R5, [R8, R1] @ armazena o novo conteudo do registrador de dados na memoria
    BX LR


/*
======================================================
        "Pega" o estado de ~pin~

        Devolve em R1 o estado do pino
======================================================
*/
.macro GPIOPinState pin
	LDR R0, =\pin
	LDR R2, [R0, #8] @ offset do pino no registrador de dados
    LDR R1, [R0, #12] @ offset do registrador de dados do pino
    LDR R3, [R8, R1] @ endereco base + registrador de dados
    MOV R4, #1 @ move 1 para R4
    LSL R4, R2 @ desloca o que tem em R4 para R4, R2 vezes
    AND R3, R4 @ leitura do bit
    LSR R1, R3, R2 @ deslocamento do bit para o LSB
.endm


/*
======================================================
        Altera o estado de um pino
        ou para BAIXO (0) ou para ALTO (1) com
        base em um valor passado (0 | 1)

        Parametros:
            R0: endereco da label que representa o pino
            R1: valor a ser setado no pino
            R7: offset do pino no registrador de dados
======================================================
*/
GPIOPinTurn:
	LDR R2, [R0, #12] @ offset do registrador de dados do pino
	LDR R3, [R8, R2] @ conteudo do registrador de dados do pino
	MOV R4, #1 @ mascara de bit
	LSL R4, R7	@ desloca o bit para a posicao do pino no registrador de dados
    CMP R1, #1 @ compara se o valor passado em R1
    BEQ pinHigh @ caso R1 seja igual a 1
    BLT pinLow @ caso R1 nao seja menor que 1 (0)
pinHigh:
    ORR R3, R4 @ insere o bit anteriormente deslocado no registrador de dados
    STR R3, [R8, R2] @ armazena o novo valor do registrador de dados na memoria
    BX LR
pinLow:
    BIC R3, R4 @ limpando o bit anterirmente deslocado no registrador de dados
    STR R3, [R8, R2] @ armazenando o novo valor do registrador de dados na memoria
    BX LR


/*
======================================================
        "Pega" o estado de um bit de um
        imediato ou não-imediato

        Parametros:
            R2: posicao do bit a ser lido
            R9: valor de onde o bit em ~pos~ sera lido

        Devolve em R1 o estado do bit correspondente
======================================================
*/
getBitState:
	MOV R5, #1 @ mascara de bit
	LSL R4, R5, R2 @ desloca o bit para ~pos~
	AND R4, R4, R9 @ leitura do bit
	LSR R1, R4, R2  @ desloca o valor lido tornando-o LSB
	BX LR
