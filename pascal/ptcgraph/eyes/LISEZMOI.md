
# Eyes

Essai d'adaptation en Pascal d'une [animation LÖVE][1]. Visage animé dont les yeux suivent le curseur de la souris.

![Capture d'écran](screenshots/01.png)

Programme basé sur ptcGraph et Cairo. La méthode pour dessiner avec Cairo dans une fenêtre ptcGraph provient de [cette discussion][2].

<!--
https://forum.lazarus.freepascal.org/index.php/topic,59894.msg450696.html#msg450696
https://forum.lazarus.freepascal.org/index.php/topic,59894.msg450796.html#msg450796
-->

Programme développé et essayé sous Linux.

Pour compiler:

```bash
cd demo
make demo CAIRO=1
```

(Si *CAIRO* n'est pas défini, le visage est dessiné avec les fonctions de ptcGraph.)

## Version SDL2 (inachevée)

```bash
cd demo-sdl
make demo CAIRO=1
```

(Si *CAIRO* n'est pas défini, le visage est dessiné avec les fonctions de SDL_gfx.)

## Programme original

Pour lancer le programme original :

```bash
love original
```

[1]: https://love2d.org/forums/viewtopic.php?p=220421#p220421
[2]: https://forum.lazarus.freepascal.org/index.php/topic,59894.0.html
