@ Faz uma chamada a nanosleep
@R0 -> variavel com duas words
@ Primeira word = sec
@ Segunda word = nanosec
.macro nanoSleep sec nsec
	LDR R0, =\sec
	LDR R1, =\nsec
	MOV R7, #162	
	SVC 0
.endm
