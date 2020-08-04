#Makefile generated at Tue  4 Aug 13:42:59 AEST 2020

CC = gcc
CFLAGS = -Wall -g

main:	main.o c.o a.o b.o 
	$(CC) $(CFLAGS) -o $@ a.o b.o c.o main.o

a.o: a.h common.h a.c
b.o: b.h b.c
c.o: c.h c.c
main.o: c.h a.h b.h main.c
