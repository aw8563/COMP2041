#Makefile generated at Tue Aug  4 17:37:15 AEST 2020

CC = gcc
CFLAGS = -Wall -g

main:	main.o c.o b.o bb.o a.o aaa.o 
	$(CC) $(CFLAGS) -o $@ main.o c.o b.o bb.o a.o aaa.o

main.o: c.h a.h b.h main.c
c.o: c.h c.c
b.o: b.h b.c
bb.o: bb.h bb.c
a.o: a.h common.h a.c
aaa.o: aaa.c
