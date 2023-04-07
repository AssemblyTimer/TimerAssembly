all:	main.o
	ld -o main main.o

main.o:
	as -o main.o main.s

run:
	sudo ./main

clear:
	rm main main.o
