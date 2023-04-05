/*
======================================================
        Altera o modo dos pinos conectados
		no LCD em modo de saida
======================================================
*/
.macro setLCDPinsOut
	GPIOPinOut E
	GPIOPinOut RS
	GPIOPinOut d7
	GPIOPinOut d6
	GPIOPinOut d5
	GPIOPinOut d4
.endm

/*
======================================================
        Da um pulso no pino conectado ao enable (E)
		do display LCD
======================================================
*/
.macro enable
    GPIOPinLow E
    nanoSleep timeZero, time1ms
    GPIOPinHigh E
    nanoSleep timeZero, time1ms
    GPIOPinLow E
.endm


/*
======================================================
        Realiza a inicialização do display LCD
		(com base nas instrucoes do datasheet dele)
======================================================
*/
.macro init
    GPIOPinLow RS

    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinHigh d5
    GPIOPinHigh d4
    enable
    nanoSleep timeZero, time5ms

    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinHigh d5
    GPIOPinHigh d4
    enable    
    nanoSleep timeZero, time150us

    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinHigh d5
    GPIOPinHigh d4
    enable

    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinHigh d5
    GPIOPinLow d4
    enable

    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinHigh d5
    GPIOPinLow d4
    enable

    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinLow d5
    GPIOPinLow d4
    enable

    enable

    GPIOPinHigh d7
    GPIOPinLow d6
    GPIOPinLow d5
    GPIOPinLow d4
    enable

    GPIOPinLow d7
    enable

    GPIOPinHigh d4
    enable

    GPIOPinLow d4
    enable

    GPIOPinLow d7
    GPIOPinHigh d6
    GPIOPinHigh d5
    enable

    GPIOPinLow d6
    GPIOPinLow d5
    enable

    GPIOPinHigh d7
    GPIOPinHigh d6
    GPIOPinHigh d5
    enable

    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinLow d5
    GPIOPinLow d4
    enable

    GPIOPinLow d7
    GPIOPinHigh d6
    GPIOPinHigh d5
    GPIOPinLow d4
    enable
	.ltorg
.endm

/*
======================================================
		Executa a instrucao de clear do LCD
======================================================
*/
.macro clearDisplay
	GPIOPinLow RS

	GPIOPinLow d7
	GPIOPinLow d6
	GPIOPinLow d5
	GPIOPinLow d4
	enable
	
	GPIOPinHigh d4
	enable
.endm

/*
======================================================
	Manda o upper bits da coluna da matriz da tabela
	de dados do LCD para o LCD
	(Usada como auxiliar em WriteLCD)
======================================================
*/
.macro prefixNumberDisplay
    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinHigh d5
    GPIOPinHigh d4
    enable
.endm

/*
======================================================
	Escreve um numero no display LCD
======================================================
*/
.macro WriteLCD value

	GPIOPinHigh RS
	prefixNumberDisplay

	@ D4	
    mov r1, #0b00001      
    and r1, \value          @0001 & 0011 -> 0001
    LDR R0, =d4
	LDR R7, [R0, #8]
    BL GPIOPinTurn

    @ D5
    mov r1, #0b00010   
    and r1, \value          @ 0010 & 0011 -> 0010
    lsr r1, #1              @ Desloca o bit 1x para direita  -> 0001
    LDR R0, =d5
	LDR R7, [R0, #8]
    BL GPIOPinTurn

    @ D6
    mov r1, #0b00100      
    and r1, \value          @ 0100 & 0101 -> 0100
    lsr r1, #2              @ Desloca o bit 2x para direita  -> 0001
    LDR R0, =d6
	LDR R7, [R0, #8]
    BL GPIOPinTurn

    @ D7
    mov r1, #0b01000      
    and r1, \value          @ 01000 & 01000 -> 01000
    lsr r1, #3              @ Desloca o bit 3x para direita  -> 00001
    LDR R0, =d7
	LDR R7, [R0, #8]
    BL GPIOPinTurn    
  	enable
.endm


/*
======================================================
	Liga o display LCD, exibe o cursor e o torna
	piscante
======================================================
*/
.macro displayOn
	GPIOPinLow RS
	
	GPIOPinLow d7	
	GPIOPinLow d5	
	GPIOPinLow d6	
	GPIOPinLow d4
	enable

	GPIOPinHigh d7
	GPIOPinHigh d6
	GPIOPinHigh d5
	GPIOPinHigh d4
	enable
.endm


/*
======================================================
	Desliga o display LCD
======================================================
*/
.macro displayOff
	GPIOPinLow RS
	
	GPIOPinLow d7	
	GPIOPinLow d5	
	GPIOPinLow d6	
	GPIOPinLow d4
	enable

	GPIOPinHigh d7
	enable
.endm



/*
======================================================
	Desloca o cursor do display LCD para a direita
======================================================
*/
.macro cursorShiftRight
    GPIOPinLow RS

    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinLow d5
    GPIOPinHigh d4
    enable

    GPIOPinHigh d6
    enable
.endm


/*
======================================================
	Executa a instrucao Return Home no display
	LCD
======================================================
*/
.macro returnHome
	GPIOPinLow RS

	GPIOPinLow d7
	GPIOPinLow d6
	GPIOPinLow d5
	GPIOPinLow d4
	enable

	GPIOPinHigh d5
	enable
.endm


/*
======================================================
	Escreve um caractere no display LCD

    O Hexadecimal, de acordo com a table do LCD
    deve vir do seguinte formato |0x upper lower|
======================================================
*/
.macro WriteCharLCD hex
    MOV R9, \hex
    GPIOPinHigh RS

    MOV R2, #7
    BL getBitState
    LDR R0, =d7
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #6
    BL getBitState
    LDR R0, =d6
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #5
    BL getBitState
    LDR R0, =d5
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #4
    BL getBitState
    LDR R0, =d4
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    enable

    MOV R2, #3
    BL getBitState
    LDR R0, =d7
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #2
    BL getBitState
    LDR R0, =d6
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #1
    BL getBitState
    LDR R0, =d5
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #0
    BL getBitState
    LDR R0, =d4
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    enable
.endm


/*
======================================================
	Seta o cursor do display para uma posicao especifica
    a partir do inicio.

    ~pos~ tem de estar entre 1 e 32
======================================================
*/
.macro setLCDCursor pos
    MOV R0, \pos
    returnHome
    WHILE:
        cursorShiftRight
        nanoSleep timeZero, time150us
        SUB R0, #1
        CMP R0, #0
        BGT WHILE
.endm
