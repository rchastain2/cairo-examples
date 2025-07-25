CC = gcc
FLAGS = -Wall `sdl2-config --cflags`
LIBS = `sdl2-config --libs` -lSDL2_gfx -lm
TARGET = clock
SRC = clock.c

$(TARGET): $(SRC)
	$(CC) -o $(TARGET) $(SRC) $(FLAGS) $(LIBS) 

.PHONY: clean
clean:
	rm -fv $(TARGET)

