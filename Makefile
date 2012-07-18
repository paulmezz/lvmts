CC=gcc
#CFLAGS=-std=gnu99 -Wall -pthread -ggdb -Os
CFLAGS=-std=gnu99 -Wall -pthread -ggdb -lm
LFLAGS=-llvm2cmd -pthread

all: lvmtsd lvmtscd lvmtscat lvmls

lvmtsd: lvmtsd.c lvmls.o
	$(CC) $(CFLAGS) lvmtsd.c lvmls.o $(LFLAGS) -o lvmtsd

lvmls.o: lvmls.c
	$(CC) $(CFLAGS) -c lvmls.c

lvmls: lvmls.c
	$(CC) $(CFLAGS) lvmls.c $(LFLAGS) -DSTANDALONE -o lvmls

lvmtscd: lvmtscd.c activity_stats.o
	$(CC) $(CFLAGS) lvmtscd.c activity_stats.o -o lvmtscd

lvmtscat: lvmtscat.c activity_stats.o
	$(CC) $(CFLAGS) lvmtscat.c activity_stats.o -o lvmtscat

activity_stats.o: activity_stats.c
	$(CC) $(CFLAGS) -c activity_stats.c

clean:
	rm -f lvmtscd lvmtscat lvmls lvmtsd activity_stats_test *.o

test: activity_stats_test
	./activity_stats_test

activity_stats_test: activity_stats_test.c activity_stats.c activity_stats.h
	$(CC) $(CFLAGS) -fprofile-arcs -ftest-coverage activity_stats_test.c $(LFLAGS) -lcheck -o activity_stats_test
