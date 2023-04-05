/*
======================================================
        Realiza uma divisao ~dividendo~/~divisor~
        Escreve o resultado da divisao em R12
        Escreve o resto da divisao em R11
======================================================
*/
.macro divisao dividendo, divisor
    mov r9, \dividendo  @ carrega dividendo
    mov r2, \divisor    @ carrega divisor
    sdiv r12, r9, r2     @ faz divisao e armazena o valor do quociente em r12
    mul r11, r2, r12      @ multiplica o quociente pelo divisor e armazena em r11
    sub r11, r9, r11      @ calcula o resto (dividendo - quociente*divisor) e armazena em r11
.endm


/*
======================================================
        Calcula ~base~ ^ ~exp~
        Escreve o resultado em R2
======================================================
*/
.macro potencia base, exp
    mov     r0, \base   @ carrega base
    mov     r1, \exp    @ carrega expoente    
    cmp     r1, #0      @ compara base a 0 se for igual
    moveq   r2, #1      @ resultado sera igual a 1
    beq     2f          @ move para label 2 e salva resultado final em r1
    mov     r2, r0      @ move o valor da base para o total
    sub     r1, #1      @ subtrai em 1 o valor do expoente
@ compara se o expoente eh zero, se for entao o resultado eh 1
1:
    cmp     r1, #0      @ novamente compara base a 0 se for igual
    ble     2f          @ resultado sera igual a 1
    mul     r2, r0, r2  @ multiplica total pela base e armazena em total
    sub     r1, #1      @ subtrai em 1 o valor do expoente
    b       1b          @ move novamente para label 1 acima para repetir o processo
@ encerra" execucao da macro
2:
    mov     r1, r2      @ armazena o resultado da macro em r0
.endm
