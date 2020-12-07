CC=gcc
CFLAGS=-c Wall
TARGET=mydatetime

.PHONY: all clean install uninstall

ifeq ($(BINDIR),)
    BINDIR := /usr/local/bin
endif

all: $(TARGET)

$(TARGET): main.o
	$(CC) main.o -o $(TARGET)

main.o: main.c
	$(CC) main.c -c

install:
	install ./$(TARGET) $(DESTDIR)/$(BINDIR)/$(TARGET)

uninstall:
	rm -rf $(DESTDIR)/$(BINDIR)/$(TARGET)
clean:
	rm -rf *.o $(TARGET)
