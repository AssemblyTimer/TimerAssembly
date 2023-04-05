all:	main.o
	ld -o main main.o

main.o:
	as -o main.o main.s

run:
	sudo ./main

clear:
	rm main main.o

all2:	main2.o
	ld -o main2 main2.o

main2.o:
	as -g -o main2.o main2.s

run2:
	sudo ./main2

clear2:
	rm main2 main2.o

