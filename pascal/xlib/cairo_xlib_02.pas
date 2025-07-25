
program Cairo_XLib_02;

{  
  Exemple d'utilisation de la bibliothèque Cairo dans une application X11
  
  Version 0.2
    * Libération de la mémoire allouée par la fonction XAllocSizeHints
    * Gestion de l'événement ClientMessage (fermeture de la fenêtre par le bouton "X")
    * Vérification de la touche pressée par l'utilisateur
  
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
    FQuitCode: TKeyCode
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
    
  { Pour pouvoir réagir à la fermeture de la fenêtre par le bouton "X", et
    éviter le message "X connection to :0 broken (explicit kill or server shutdown)."
    L'événement ClientMessage est ajouté dans la boucle de contrôle des événements. }
    LWindowClosingProtocol := XInternAtom(FDisplay, 'WM_DELETE_WINDOW', TRUE);
    if LWindowClosingProtocol = 0 then
      WriteLn(ErrOutput, 'LWindowClosingProtocol = 0')
    else
      XSetWMProtocols(FDisplay, FWindow, @LWindowClosingProtocol, 1);
    
    FQuitCode := XKeysymToKeycode(FDisplay, XStringToKeysym('Q'));
    XSelectInput(FDisplay, FWindow, ExposureMask or KeyPressMask or ButtonPressMask or StructureNotifyMask);
    XStoreName(FDisplay, FWindow, 'Exemple Cairo X11');
    XMapWindow(FDisplay, FWindow);
  end;
end;

procedure WinDestroy(const AWindowRec: PWindowRec);
begin
  XDestroyWindow(AWindowRec^.FDisplay, AWindowRec^.FWindow);
end;

procedure WinDraw(const AWindowRec: PWindowRec);
var
  LVisual: PVisual;
  LSurface: pcairo_surface_t;
  LContext: pcairo_t;
begin
  with AWindowRec^ do
  begin
    LVisual := XDefaultVisual(FDisplay, FScreenNum);
    XClearWindow(FDisplay, FWindow);
    LSurface := cairo_xlib_surface_create(FDisplay, FWindow, LVisual, FWidth, FHeight);
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
        begin
          if LEvent.XExpose.Count = 0 then
          begin
            WinDraw(AWindowRec);
          end;
        end;
      ConfigureNotify:
        begin
          AWindowRec^.FWidth  := LEvent.XConfigure.Width;
          AWindowRec^.FHeight := LEvent.XConfigure.Height;
        end;
      ButtonPress:
        begin
          Break;
        end;
      KeyPress:
        begin
        { v0.2 }
          LKeyEvent := LEvent.XKey;
          if LKeyEvent.KeyCode = AWindowRec^.FQuitCode then
            Break
          else
            WriteLn(ErrOutput, 'LKeyEvent.KeyCode = ', LKeyEvent.KeyCode);
        end;
      ClientMessage:
        begin
        { Fermeture de la fenêtre par le bouton "X". }
          Break;
        end;
    end;
  end;
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
