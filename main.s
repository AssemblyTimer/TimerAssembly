.equ VALUE, 23159 @ Valor a ser contado

.include "gpio.s"
.include "sleep.s"
.include "lcd.s"
.include "divisao.s"
.include "timer.s"

.global _start
/*
======================================================
	syscall exit
======================================================
*/
.macro _end
    MOV R0, #0
    MOV R7, #1
    SVC 0
.endm

_start:
    MemoryMap
	GPIOPinIn b1
	GPIOPinIn b2
	setLCDPinsOut
	init

	@ Valor de contagem
	DEFINE:
		MOV R6, #VALUE
	INIT:
		MOV R9, R6 
		MOV R10, #6
	B BEFORE

	@ Aguarda o usuario pressionar o botao de PLAY
	WAIT:
		GPIOPinState b2
		CMP R1, #0
		BEQ PLAY
	B WAIT

	@Exibe o numero no display LCD
	BEFORE:
		clearDisplay
	SHOWNUMBER:
		CMP      R10, #-1        @ verifica se o loop atingiu valor maximo (num maximo de caracteres)
		BEQ      INTERM           @ caso positivo sai do loop | aqui poderia vir para uma branch que decrementa e chama ele
									@ de novo
		potencia #10, R10       @ realiza 10^(contador do loop)

		divisao  R9, R1         @ faz a divisao do valor que queremos por r6 (potencia acima)
	
		WriteLCD R12		    @ Escreve no LCD o valor armazenado em r12 (quociente)
		SUB 	 R10, #1
		MOV		 R9, R11		@ novo valor de r9 sera o resto (valor armazenado em r11)
		B 		 SHOWNUMBER	@ volta ao começo do loop

	INTERM:
		CMP R6, #VALUE
		BEQ WAIT @ se for a primeira iteracao
		BLT PLAY @ se nao for a primeira iteracao

	PLAY:
		@SUB R6, #1
		nanoSleep time1s, timeZero @ contando
		@CMP R6, #0      @ verifica se o numero contado e zero
		SUBS R1, #1
		BEQ EXIT

		MOV R10, #6 @ Configura a "proxima chamada" a SHOWNUMBER
		MOV R9, R6

		GPIOPinState b2
		CMP R1, #0      @ verifica se o botao de pause foi pressionado
		BEQ PAUSE
		
		GPIOPinState b1
		CMP R1, #0     @ verifica se o botao de reset foi pressionado
		BEQ DEFINE
	B BEFORE

	PAUSE:
	@nanoSleep timeZero, time170ms
	DO:
		GPIOPinState b2
		CMP R1, #0      @ verifica se o play foi pressionado
		BEQ DO 
	DOSOME:	
		GPIOPinState b2 @ Verifica se o play foi pressionado
		CMP R1, #0
		BEQ BEFORE

		GPIOPinState b1
		CMP R1, #0      @ verifica se o reset foi pressionado
		BEQ DEFINE
	B DOSOME

	EXIT:
		_end

.data
    fileName: .asciz "/dev/mem" @ caminho do arquivo que representa a memoria RAM
    gpioaddr: .word 0x1C20 @ endereco base GPIO / 4096
    pagelen: .word 0x1000 @ tamanho da pagina
    
	time1s: .word 1  @ 1s

	time1ms: .word 1000000 @ 1ms

	time850ms: .word 850000000 @850ms

    time950ms: .word 950000000 @850ms

	time170ms: .word 170000000 @ 170ms

	timeZero: .word 0 @ zero
   
	time1d55ms: .word 1500000 @ 1.5ms

	time5ms: .word 5000000 @ 5 ms

	time150us: .word 150000 @ 150us
	
	/*
	======================================================
       Todas as labels com o nome de um pino da
		Orange PI PC Plus contem 4 ~words~

		Word 1: offset do registrador de funcao do pino
		Word 2: offset do pino no registrador de funcao (LSB)
		Word 3: offset do pino no registrador de dados
		Word 3: offset do registrador de dados do pino
	======================================================
	*/

    @ LED Vermelho
    PA9:
		.word 0x4
		.word 0x4
		.word 0x9
		.word 0x10
    
	PA7:
		.word 0x0
		.word 0x1C
		.word 0x7
		.word 0x10
	

    @ LED Azul
    PA8:
		.word 0x4
		.word 0x0
		.word 0x8
		.word 0x10
		
	@PG7 - DB7
	d7:
		.word 0xD8
		.word 0x1C
		.word 0x7
		.word 0xE8

	@PG6 - DB6
	d6:
		.word 0xD8
		.word 0x18
		.word 0x6
		.word 0xE8

	@PG9 - DB5
	d5:
		.word 0xDC
		.word 0x4
		.word 0x9
		.word 0xE8

	@PG8 - DB4
	d4:
		.word 0xDC
		.word 0x0
		.word 0x8
		.word 0xE8
	
	@PA18 - Enable
	E:
		.word 0x8
		.word 0x8
		.word 0x12
    .word 0x10

	@PA2 - RS
	RS:
		.word 0x0
		.word 0x8
		.word 0x2
    .word 0x10

	@RW
	@GROUND

	@PA10 - Reset
	b1:
		.word 0x4
		.word 0x8
		.word 0xA
		.word 0x10

	@PA20 - Play/Pause
	b2:
		.word 0x8
		.word 0x10
		.word 0x14
		.word 0x10
