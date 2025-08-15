
# Eyes

Animated face, whose eyes follow mouse cursor. Adapted from a [LÖVE animation][1].

![Screenshot](screenshots/01.png)

## Build

```bash
cd demo
make demo CAIRO=1
```

## Build SDL2 version

To build this version, you have to download [SDL2 units][2] and to adapt the value of the *SDL2_UNITS* variable in the Makefile.

```bash
cd demo-sdl
make demo CAIRO=1
```

## Test original program

```bash
cd original
love .
```

[1]: https://love2d.org/forums/viewtopic.php?p=220421#p220421
[2]: https://github.com/PascalGameDevelopment/SDL2-for-Pascal
