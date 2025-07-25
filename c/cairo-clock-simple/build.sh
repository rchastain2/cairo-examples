
rm -f *.o
rm -f cairo-clock

cc -Wall -Os `pkg-config --cflags gtk+-2.0 librsvg-2.0` -c cairo-clock.c -o cairo-clock.o
cc `pkg-config --libs gtk+-2.0 librsvg-2.0` cairo-clock.o -o cairo-clock
