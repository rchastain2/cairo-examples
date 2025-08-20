
# Eyes

Visage animé dont les yeux suivent le curseur de la souris. Adaptation en Pascal d'une [animation LÖVE][1].

![Capture d'écran](screenshots/ptcgraph-cairo.png)

Programme basé sur ptcGraph et Cairo. (La méthode employée pour dessiner avec Cairo dans une fenêtre ptcGraph provient de [cette discussion][2].)

## Compilation

```bash
cd demo
make demo CAIRO=1
```

Si *CAIRO* n'est pas défini, le visage est dessiné avec ptcGraph.

## Compilation de la version SDL2

Pour compiler cette version, vous devez télécharger les [unités SDL2][3] et adapter la valeur de la variable *SDL2_UNITS* dans le Makefile.

```bash
cd demo-sdl
make demo CAIRO=1
```

Si *CAIRO* n'est pas défini, le visage est dessiné avec SDL_gfx.

## Exécution du programme original

```bash
cd original
love .
```

[1]: https://love2d.org/forums/viewtopic.php?p=220421#p220421
[2]: https://forum.lazarus.freepascal.org/index.php/topic,59894.0.html
[3]: https://github.com/PascalGameDevelopment/SDL2-for-Pascal
