.macro setLCDPinsOut
	GPIOPinOut E
	GPIOPinOut RS
	GPIOPinOut d7
	GPIOPinOut d6
	GPIOPinOut d5
	GPIOPinOut d4
	.ltorg
.endm


.macro enable
    GPIOPinLow E
    nanoSleep timeZero, timeMilli15
    GPIOPinHigh E
    nanoSleep timeZero, timeMilli15
    GPIOPinLow E
.endm

@ pl = pin low
@ ph = pin high
.macro send4bCommand pl0 pl1 pl2 pl3 ph0 ph1
    GPIOPinLow RS

    GPIOPinLow =\pl0
    GPIOPinLow =\pl1
    GPIOPinLow =\pl2
    GPIOPinLow =\pl3

    GPIOPinHigh =\ph0
    GPIOPinHigh =\ph1

    enable
    @.ltorg
.endm


.macro pinsOff p0 p1 p2 p3
    GPIOPinLow RS

    GPIOPinLow =\p0
    GPIOPinLow =\p1
    GPIOPinLow =\p2
    GPIOPinLow =\p3
    enable
.endm


.macro pinsOn p0 p1 p2 p3
    GPIOPinLow RS

    GPIOPinHigh =\p0
    GPIOPinHigh =\p1
    GPIOPinHigh =\p2
    GPIOPinHigh =\p3
    enable
.endm



@ TInitLCD = Tricky Init LCD
.macro TInitLCD
    @function set
    send4bCommand d7, d6, NULL, NULL, d5, d4
    nanoSleep timeZero, timeSpecNano5

    @function set
    send4bCommand d7, d6, NULL, NULL, d5, d4
    nanoSleep timeZero, timeSpecNano120

    @function set
    send4bCommand d7, d6, NULL, NULL, d5, d4
    send4bCommand d7, d6, d4, NULL, d5, NULL
    nanoSleep timeZero, timeSpecNano120
    .ltorg

    @function set
    send4bCommand d7, d6, d4, NULL, d5, NULL
    pinsOff d7, d6, d5, d4
    nanoSleep timeZero, timeSpecNano120

    @display off
    pinsOff d7, d6, d5, d4
    send4bCommand d6, d5, d4, NULL, d7, NULL
    nanoSleep timeZero, timeSpecNano120

    @display clear
    pinsOff d7, d6, d5, d4
    send4bCommand d7, d6, d5, NULL, d4, NULL
    nanoSleep timeZero, timeSpecNano120

    @ entry mode set
    pinsOff d7, d6, d5, d4
    send4bCommand d7, d4, NULL, NULL, d6, d5
    nanoSleep timeZero, timeSpecNano120
    .ltorg
.endm


.macro clearDisplay
    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinLow d5
    GPIOPinLow d4
    enable
    GPIOPinLow d7
    GPIOPinLow d6
    GPIOPinLow d5
    GPIOPinHigh d4
    enable
    nanoSleep timeZero, timeSpecMilli155
.endm


.macro ReturnHome
    pinsOff d7, d6, d5, d4
    send4bCommand d7, d6, NULL, NULL, d5, d4
    nanoSleep timeZero, timeSpecMili155
.endm


.macro controlDisplay
    pinsOff d7, d6, d5, d4
    pinsOn d7, d6, d5, d4
    nanoSleep timeZero, timeSpecNano120
.endm


.macro rightCursorShift
    send4bCommand d7, d6, d5, NULL, d4, NULL
    send4bCommand d7, d5, d4, NULL, d6, NULL
    nanoSleep timeZero, timeSpecNano120
.endm

@ 0100
@ 1000
.macro escreveH
   send4bData d7, d6, NULL, NULL, d5, d4
   send4bData d7, d4, NULL, NULL, d6, d5 
.endm

.macro send4bData pl0 pl1 pl2 pl3 ph0 ph1
    GPIOPinHigh RS
    GPIOPinLow =\pl0
    GPIOPinLow =\pl1
    GPIOPinLow =\pl2
    GPIOPinLow =\pl3

    GPIOPiHigh =\ph0
    GPIOPinHigh =\ph1
    enable
    .ltorg
.endm
