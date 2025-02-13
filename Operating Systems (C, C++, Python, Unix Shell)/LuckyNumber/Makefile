runme: main.c LuckyNumber.h Record.h LuckyNumber.o
		gcc main.c LuckyNumber.o -o runme

clean: 
		rm *.o runme

install: runme
		cp ./runme /bin/

uninstall:
		rm /bin/runme