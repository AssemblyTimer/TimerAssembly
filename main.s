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
	@clearDisplay
	@escreve

INIT:
	clearDisplay
	MOV R9, #9
	WriteLCD R9
	B WAIT

WAIT:
	GPIOPinState b2
	CMP R1, #0
	BEQ PLAY
B WAIT
PLAY:
	SUB R9, #1
	nanoSleep time1s, timeZero @ contando

	returnHome
	WriteLCD R9 @ escreve o valor decrementado no LCD

	GPIOPinState b2
	CMP R1, #0      @ verifica se o botao de pause foi pressionado
	BEQ PAUSE
	
	GPIOPinState b1
	CMP R1, #0     @ verifica se o botao de reset foi pressionado
	BEQ INIT

	CMP R9, #0 @ contagem finalizada
	BEQ INIT
B PLAY

PAUSE:
nanoSleep timeZero, time170ms
DO:
	GPIOPinState b2
	CMP R1, #0      @ verifica se o play foi pressionado
	BEQ DO 
DOSOME:	
	GPIOPinState b2
	CMP R1, #0
	BEQ PLAY

	GPIOPinState b1
	CMP R1, #0      @ verifica se o reset foi pressionado
	BEQ INIT
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

