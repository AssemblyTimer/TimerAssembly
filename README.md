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