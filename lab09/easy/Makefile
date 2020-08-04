#Makefile generated at Tue  4 Aug 13:41:56 AEST 2020

CC = gcc
CFLAGS = -Wall -g

easymain:	easymain.o graphics.o world.o 
	$(CC) $(CFLAGS) -o $@ easymain.o graphics.o world.o

easymain.o: graphics.h world.h easymain.c
graphics.o: graphics.h world.h graphics.c
world.o: world.h world.c
