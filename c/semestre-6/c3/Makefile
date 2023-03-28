# Définition des Variables (à compléter)
CC = gcc
CFLAGS = -Wextra -pedantic
LDFLAGS = 
EXE = test_file exemple_file

# Règles (à compléter avec des variables automatiques)
all: $(EXE)

test_file: test_file.o file.o
	$(CC) $(LDFLAGS) $^ -o $@

exemple_file: exemple_file.o file.o
	$(CC) $(LDFLAGS) $^ -o $@

makedepend:
	makedepend *.c -Y.

clean:
	rm $(EXE)

.PHONY: clean all makedepend
# DO NOT DELETE

exemple_file.o: file.h
file.o: file.h
test_file.o: file.h
