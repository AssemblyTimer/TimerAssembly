# TIMER ASSEMBLY

* * *

## Primeiro problema proposto na disciplina TEC499 - MI SISTEMAS DIGITAIS

Professor: Thiago de Jesus Almeida

Dupla: Carlos Valadão e Fernando Mota

* * *

## Descrição do problema
Desenvolver um aplicativo de temporização (timer) que apresente a contagem num
display LCD. O tempo inicial deverá ser configurado diretamente no código. Além disso,
deverão ser usados 2 botões de controle: 

1 para iniciar/parar a contagem e outro para reiniciar
a partir do tempo definido.


Com o objetivo de desenvolver uma biblioteca para uso futuro em conjunto com um
programa em linguagem C, a função para enviar mensagem para o display deve estar
separada como uma biblioteca (.o), e permitir no mínimo as seguinte operações: 
```
1) Limpar display
2) Escrever caractere
3) Posicionar cursor (linha e coluna).
```

## Descrição da solução
A biblioteca TimerAssembly é capaz de gerenciar displays LCDs que seguem o padrão Hitachi HD44780U, eliminando a necessidade de lidar com as complexidades da comunicação. Desenvolvida para funcionar com a Orange PI PC Plus e sua arquitetura Arm V7, essa biblioteca permite que se apague o display, escreva caracteres e mova o cursor para uma posição específica. Para demonstrar seu uso, há um programa disponível nesse repositório, em conjunto com esta documentação que descreve todas as etapas de desenvolvimento e os recursos utilizados durante o processo.

* * *

## Hardware usado:
## [Orange Pi PC Plus](http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/details/Orange-Pi-PC-Plus.html)

### Especificações:

| CPU | H3 Quad-core Cortex-A7 H.265/HEVC 4K   |
|:--- |                                   ---: |
| GPU |     Mali400MP2 GPU @600MHz             |
| Memória (SDRAM) |  1GB DDR3 (shared with GPU)|
| Armazenamento interno | Cartão MicroSD (32 GB); 8GB eMMC Flash|
| Rede embarcada | 10/100 Ethernet RJ45        |
| Fonte de alimentação | Entrada DC,<br>entradas USB e OTG não servem como fonte de alimentação | 
| Portas USB | 3 Portas USB 2.0, uma porta OTG USB 2.0 |
| Periféricos de baixo nível | 40 pinos        |

### Configuração de Pinagem da placa:
<img src="./src/pinagemOrange.png" alt="isolated" width="500"/>
<!-- ![configuracao dos pinos](./src/pinagemOrange.png) -->


## Softwares utilizados:
Para o processo de desenvolvimento do sistema, foram empregadas diversas ferramentas, sendo elas:

[GNU Make](https://www.gnu.org/software/make/manual/make.html): Uma vez que a SBC é acessada via terminal precisamos compilar o código através de comandos escritos em terminal, ao contrário das facilidades oferecidas por uma IDE, como um simples clique para compilar um código, é nesse sentido que o GNU Make ajuda na etapa de desenvolvimento e testes, essa ferramenta nos permite escrever Makefiles, que são arquivos de texto que possuem regras explícitas a serem executadas sempre que aquela regra for digitada, como um mnemônico ou apelido, ou seja podemos executar vários comandos com uma única regra, ou alias. Em geral, o arquivo executável é gerado a partir dos arquivos objeto, que são gerados pela compilação dos arquivos de origem. Uma vez que o makefile está configurado corretamente, basta executar o comando "make" sempre que houver alterações nos arquivos de origem.

[GNU Binutils](https://www.gnu.org/software/binutils/): Essa é uma coleção de ferramentas para lidar com arquivos binários, que inclui o GNU assembler (as) para montar código assembly e o GNU linker (ld) para combinar arquivos objeto, realocar dados e vincular referências de símbolos, gerando o arquivo executável final.

[GDB](https://www.gnu.org/savannah-checkouts/gnu/gdb/index.html): O GNU Debugger é um depurador de código fonte que vem como padrão em sistemas que usam ferramentas GNU, como sistemas baseados em Unix. Sua função é permitir a análise do comportamento de um programa enquanto ele é executado, ajudando a identificar problemas e erros. É possível utilizá-lo tanto com programas escritos em linguagens de alto nível como C e C++, quanto com programas em código assembly.

[QEMU](https://qemu.org) e [CPUlator](https://cpulator.01xz.net/): Essas são ferramentas de emulação de processadores que permitem a criação de um ambiente virtual para testar o sistema em desenvolvimento. O QEMU é capaz de emular uma máquina completa, enquanto o CPUlator é um emulador online que simula alguns periféricos como leds, botões e dip switches. Ambos foram usados para simular a arquitetura ARM.

## Documentação usada:
[Datasheet da H3 AllWinner](https://drive.google.com/drive/folders/1JmgtWTlGA-hPv47cLtEYZa-Y3UZPSQNN): Contém todas as informações relacionadas ao funcionamento dos pinos da SBC Orange Pi Pc Plus, bem como seus endereços de memória e informações extras sobre como acessá-las e enviar dados para os pinos relacionados a entrada e saída de propósito geral (GPIO)

[Datasheet do display LCD](https://www.sparkfun.com/datasheets/LCD/HD44780.pdf): Como citado anteriormente, o modelo do display LCD é o Hitachi HD44780U, e sua documentação nos permite descobrir o algoritmo responsável pela inicialização do display bem como o tempo de execução de cada instrução, além da representação de cada caractere em forma de número binário

[Tabela de syscalls do Linux 32 bits para ARM](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#arm-32_bit_EABI): Documentação contendo tabela de chamadas ao sistema operacional como chamadas de nanoSleep, ou de escrita para serem executadas

[Raspberry Pi Assembly Language Programming, ARM Processor Coding](https://link.springer.com/book/10.1007/978-1-4842-5287-1): Livro que mostra diversos casos de exemplo na prática do uso da linguagem Assembly na programação de dispositivos de placa única, no livro foi usado a Raspberry Pi.

[ARM Assembly by Example](https://armasm.com): Site contendo diversos exemplos de uso de ARM V7, também contem extensa fundamentação teórica.

## Conjunto de instruções usadas:

|      Instrução     	|                                                                             Descrição                                                                             	|
|:------------------:	|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------:	|
|        `MOV`       	|                              Move o valor do operando para o registrador destino. Podendo ser um valor imediato ou de um registrador.                             	|
|        `ADD`       	|                                             Soma o valor dos operandos e armazena o resultado  no registrador destino.                                            	|
|        `SUB`       	|                                 Subtrai do primeiro operando o valor do operando 2 e  armazena o resultado no registrador destino.                                	|
|        `AND`       	|                                    Faz uma operação and bit a bit nos operandos e  armazena o resultado no registrador destino.                                   	|
|        `ORR`       	|                                    Faz uma operação or bit a bit nos operandos e  armazena o resultado no registrador destino.                                    	|
|        `CMP`       	|                                                Compara o valor no registrador do primeiro operando  com Operando2.                                                	|
|        `LDR`       	|                                                            Carrega dados da memória em um registrador.                                                            	|
|        `STR`       	|                                                           Armazena o dado de um registrador na memória.                                                           	|
|        `SVC`       	|                                    Faz uma interrupção de software. Foi utilizado  para fazer chamadas ao sistema operacional.                                    	|
|        `STRB`         |                       Calcula endereço de um registrador base e de um registrador de offset, carrega um byte do registrador e armazena em memória |
|        `LDRB`         |                       Calcula endereço de um registrador base e de um registrador de offset, carrega um byte da memória e escreve no registrador |
|        `LSL`       	| Faz um deslocamento lógico à esquerda. O LSL fornece o valor de um registrador multiplicado por uma potência de dois,  inserindo zeros nas posições de bit vagas. 	|
|        `BIC`       	|       A instrução BIC (BIT Clear) realiza uma operação  AND nos bits em Rn(Operando 1) com os complementos dos bits correspondentes no valor de Operando 2.       	|
|         `B`        	|                                                      A instrução B causa um desvio para uma parte do código.                                                      	|
|        `BL`        	|                             A instrução BL copia o endereço da próxima instrução em r14 (LR) e faz o desvio para uma parte do código.                             	|
|        `BX`        	|                                                   A instrução BX causa um desvio para o endereço mantido em Rm.                                                   	|
|     `.include`     	|                                                                Inclui arquivos externos ao código.                                                                	|
|       `.equ`       	|                                                                     Define um valor constante.                                                                    	|
| `.macro` e `.endm` 	|                                     Cria uma rotina com um trecho de código que pode ser chamada em qualquer parte do programa                                    	|
|        `LSR`       	|    Faz um deslocamento lógico à direita. O LSL fornece o valor de um registrador dividido por uma potência de dois,  inserindo zeros nas posições de bit vagas.   	|
|       `.data`      	|                                                              Define uma seção de dados para o código.                                                             	|
|       `.word`      	|                                                              Define uma palavra de dados de 4 bytes.                                                              	|
|      `.asciz`      	|                                                              Define uma string seguida por 1 byte 0.                                                              	|
|      `.ltorg`      	|                                                              Usado em rotinas muito grandes para fazer com que o offset de instruções como LDR fique dentro do seu intervalo (+/- 4095).|

Em algumas das instruções acima(ADD,B,BL,SUB e MOV) foram utilizadas condições de execução. Segue abaixo a lista das que foram usadas:
- `EQ` - Compara se é igual.
- `LT` - Compara se é menor que.


## Execução do projeto:

A estrutura do projeto está dividida em:
```
├── botao.s
├── gpio.s
├── lcd.s
├── main.s
├── Makefile
├── README.md
├── sleep.s
```

Para obter o código desse repositório, faça em um terminal:
```
git clone https://github.com/AssemblyTimer/TimerAssembly.git
```


Em posse do código desse repositório e de um dispositivo com processador de arquitetura ARM, para testar o funcionamento do programa execute os comandos:
```
make main
make run
```