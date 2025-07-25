
rm -f cairo-clock.o
rm -f cairo-clock

cc -Wall -Os `pkg-config --cflags gtk+-2.0 librsvg-2.0` -c cairo-clock-up.c -o cairo-clock.o
cc `pkg-config --libs gtk+-2.0 librsvg-2.0` cairo-clock.o -o cairo-clock

strip cairo-clock
