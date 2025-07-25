
program Cairo_XLib_03;

{  
  Exemple d'utilisation de la bibliothèque Cairo dans une application X11
  
  Version 0.2
    * Libération de la mémoire allouée par la fonction XAllocSizeHints
    * Gestion de l'événement ClientMessage (fermeture de la fenêtre par le bouton "X")
    * Vérification de la touche pressée par l'utilisateur
  
  Version 0.3
    * Utilisation d'un pixmap (au lieu de dessiner directement dans la fenêtre)
    * Affichage des événements dans le terminal
  
  https://gitlab.com/cairo/cairo-demos/-/blob/master/X11/cairo-demo.c
  https://lists.freepascal.org/pipermail/fpc-pascal/2008-March/017049.html
  https://stackoverflow.com/a/15089506
  http://supertos.free.fr/html/linux/dev/xwindow/dev/xlib/index.htm
  https://www.lemoda.net/xlib/index.html
}

uses
  X, XLib, XUtil, Cairo, CairoXLib;

type
  PWindowRec = ^TWindowRec;
  TWindowRec = record
    FDisplay: PDisplay;
    FScreenNum: integer;
    FWindow: TWindow;
    FX, FY, FWidth, FHeight: integer;
    FQuitCode: TKeyCode;
    FPixmap: TPixmap; { v0.3 }
    FGC: TGC;
  end;
  
procedure WinInit(const AWindowRec: PWindowRec);
var
  LRoot: TWindow;
  LSizeHints: PXSizeHints;
  LWindowClosingProtocol: TAtom;
begin
  with AWindowRec^ do
  begin
    FX := 40;
    FY := 30;
    FWidth := 400;
    FHeight := 400;
    
  { Nécessaire pour obtenir le positionnement souhaité de la fenêtre. }
    LSizeHints := XAllocSizeHints;
    LSizeHints^.Flags := PPosition or PSize;
    LSizeHints^.X := FX;
    LSizeHints^.Y := FY;
    LSizeHints^.Width := FWidth;
    LSizeHints^.Height := FHeight;
    
    LRoot := XDefaultRootWindow(FDisplay);
    FScreenNum := XDefaultScreen(FDisplay);
    FWindow := XCreateSimpleWindow(FDisplay, LRoot, 10, 10, FWidth, FHeight, 0, XBlackPixel(FDisplay, FScreenNum), XWhitePixel(FDisplay, FScreenNum));
    
    XSetNormalHints(FDisplay, FWindow, LSizeHints);
    XFree(LSizeHints); { v0.2 }
    
  { Pour pouvoir réagir à la fermeture de la fenêtre par le bouton "X".
    L'événement ClientMessage sera ajouté dans la boucle de contrôle des événements. }
    LWindowClosingProtocol := XInternAtom(FDisplay, 'WM_DELETE_WINDOW', TRUE);
    if LWindowClosingProtocol = 0 then
      WriteLn(ErrOutput, 'LWindowClosingProtocol = 0')
    else
      XSetWMProtocols(FDisplay, FWindow, @LWindowClosingProtocol, 1);
    
    FQuitCode := XKeysymToKeycode(FDisplay, XStringToKeysym('Q'));
    XSelectInput(FDisplay, FWindow, ExposureMask or KeyPressMask or ButtonPressMask or StructureNotifyMask);
    XStoreName(FDisplay, FWindow, 'Exemple Cairo X11');
    
    FPixmap := XCreatePixmap(FDisplay, FWindow, FWidth, FHeight, DefaultDepth(FDisplay, FScreenNum));
    FGC := XCreateGC(FDisplay, FPixmap, 0, nil);
    
    XMapWindow(FDisplay, FWindow);
  end;
end;

procedure WinDestroy(const AWindowRec: PWindowRec);
begin
  with AWindowRec^ do
  begin
    XDestroyWindow(FDisplay, FWindow);
    XFreePixmap(FDisplay, FPixmap);
    XFreeGC(FDisplay, FGC);
  end;
end;

procedure WinDraw(const AWindowRec: PWindowRec);
var
  (*
  LVisual: PVisual;
  *)
  LSurface: pcairo_surface_t;
  LContext: pcairo_t;
begin
  with AWindowRec^ do
  begin
    (*
    LVisual := XDefaultVisual(FDisplay, FScreenNum);
    *)
    XClearWindow(FDisplay, FWindow);
    (*
    LSurface := cairo_xlib_surface_create(FDisplay, FWindow, LVisual, FWidth, FHeight);
    *)
  { v0.3 }
    LSurface := cairo_xlib_surface_create(FDisplay, FPixmap, DefaultVisual(FDisplay, DefaultScreen(FDisplay)), FWidth, FHeight);
    
    LContext := cairo_create(LSurface);
  { Peindre la fenêtre en bleu. }
    cairo_set_source_rgb(LContext, 0.0, 0.0, 0.5);
    cairo_paint(LContext);
  { Tracer un trait blanc. }
    cairo_set_line_width(LContext, 24);
    cairo_set_line_cap(LContext, CAIRO_LINE_CAP_ROUND);
    cairo_set_source_rgb(LContext, 1.0, 1.0, 1.0);
    cairo_move_to(LContext, FWidth div 8, FHeight div 8);
    cairo_line_to(LContext, 7 * (FWidth div 8), 7 * (FHeight div 8));
    cairo_stroke(LContext);
    cairo_destroy(LContext);
    cairo_surface_destroy(LSurface);
    
  { v0.3 }
    XCopyArea(FDisplay, FPixmap, FWindow, FGC, 0, 0, FWidth, FHeight, 0, 0);
  end;
end;

procedure WinHandleEvents(const AWindowRec: PWindowRec);
var
  LEvent: TXEvent;
  LKeyEvent: TXKeyEvent;
begin
  while TRUE do
  begin
    XNextEvent(AWindowRec^.FDisplay, @LEvent);
    case LEvent._type of
      Expose:
        with LEvent.XExpose do
        begin
          WriteLn('Expose    ', X:3, ', ', Y:3, ', ', Width:3, ', ', Height:3, ', ', Count:3);
          if Count = 0 then
            WinDraw(AWindowRec);
        end;
      ConfigureNotify:
        with AWindowRec^, LEvent.XConfigure do
        begin
          WriteLn('Configure ', X:3, ', ', Y:3, ', ', Width:3, ', ', Height:3);
          FWidth  := Width;
          FHeight := Height;
          XFreePixmap(FDisplay, FPixmap);
          XFreeGC(FDisplay, FGC);
          FPixmap := XCreatePixmap(FDisplay, FWindow, FWidth, FHeight, DefaultDepth(FDisplay, FScreenNum));
          FGC := XCreateGC(FDisplay, FPixmap, 0, nil);
        end;
      ButtonPress:
        begin
          WriteLn('ButtonPress');
          Break;
        end;
      KeyPress:
        begin
          WriteLn('KeyPress');
        { v0.2 }
          LKeyEvent := LEvent.XKey;
          WriteLn('LKeyEvent.KeyCode = ', LKeyEvent.KeyCode);
          if LKeyEvent.KeyCode = AWindowRec^.FQuitCode then
            Break;
        end;
      ClientMessage:
        begin
          WriteLn('ClientMessage');
        { Fermeture de la fenêtre par le bouton "X". }
          Break;
        end;
    end;
  end;
  WriteLn('Au revoir !');
end;

var
  LWindowRec: TWindowRec;
  
begin
  LWindowRec.FDisplay := XOpenDisplay(nil);
  if LWindowRec.FDisplay = nil then
  begin
    WriteLn(ErrOutput, 'Failed to open display');
    Halt(1);
  end;
  WinInit(@LWindowRec);
  WinDraw(@LWindowRec);
  WinHandleEvents(@LWindowRec);
  WinDestroy(@LWindowRec);
  XCloseDisplay(LWindowRec.FDisplay);
end.
