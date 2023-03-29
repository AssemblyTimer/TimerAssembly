.include "gpio.s"
.include "sleep.s"
.include "lcd.s"


.global _start

.macro _end
    MOV R0, #0
    MOV R7, #1
    SVC 0
.endm

.macro print str len
    MOV R0, #1
    LDR R1, =\str
    MOV R2, \len
    MOV R7, #4
    SVC 0
.endm

_start:
	@ Salva o endereco base em R8
    MemoryMap
LDR R0, =PA9
loop:
    GPIOPinState b2
    BL GPIOPinTurn
b loop
.data
    text: .asciz "on\n"

    fileName: .asciz "/dev/mem"
    gpioaddr: .word 0x1C20
    pagelen: .word 0x1000
    
    @ LED VERMELHO
    PA9:
        .word 4 @offset do registrador do pino
        .word 4 @offset do pino no registrador de funcao (LSB)
        .word 9 @offset do pino no registrador de set e clear
        .word 0x10
    
    @ LED AZUL
    PA8:
        .word 4
        .word 0
        .word 8
        .word 0x10

	time:
		.word 2
		.word 0

	@ Pinos do LCD
	
	@PG7 - DB7
	d7:
		.word 216
		.word 28
		.word 7
		.word 0xE8

	@PG6 - DB6
	d6:
		.word 216
		.word 24
		.word 6
		.word 0xE8

	@PG9 - DB5
	d5:
		.word 220
		.word 4
		.word 5
		.word 0xE8

	@PG8 - DB4
	d4:
		.word 220
		.word 0
		.word 8
		.word 0xE8
	
	@PA18 - Enable
	E:
		.word 8
		.word 8
		.word 18
        .word 0x10

	@PA2 - RS
	RS:
		.word 0
		.word 8
		.word 2
        .word 0x10

	@RW
	@GROUND

	@PA10
	b1:
		.word 4
		.word 8
		.word 10
		.word 0x10

	@PA20
	b2:
		.word 8
		.word 16
		.word 20
		.word 0x10
	
	NULL:
        .word 0
        .word 0
        .word 0
        .word 0x10
		

   second: .word 1                 @ 1 segundo

   timeZero: .word 0

   timeZeroMili: .word 000000000
   
   timeSpecMicro40: .word 50000 @ microssegundos

   timeSpecMilli155: .word 1550000 @ 1.55 milissegundos

   timeSpecNano5: .word 5000000    @ 5 milissegundos

   timeSpecNano120: .word 120000   @ 120 microssegundos

   timeMilli15: .word 1500000