/*
======================================================
        Macro que faz a chamada a nanosleep com
		~sec~ segundos e ~nsec~ nanossegundos
======================================================
*/
.macro nanoSleep sec nsec
	LDR R0, =\sec @ segundos
	LDR R1, =\nsec @ nanossegundos
	MOV R7, #162 @ sys_nanosleep
	SVC 0 @ interrupcao
.endm
