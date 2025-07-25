
program Screenshot;

{ 
  Capture d'écran sous Linux
  https://stackoverflow.com/a/15524366
}

uses
  X, XLib, Cairo, CairoXLib;

var
  LDisplay: PDisplay;
  LScreenNum: integer;
  LWindow: TWindow;
  LVisual: PVisual;
  LWidth: integer;
  LHeight: integer;
  LSurface: pcairo_surface_t;
  
begin
  LDisplay   := XOpenDisplay(nil);
  LScreenNum := XDefaultScreen(LDisplay);
  LWindow    := XDefaultRootWindow(LDisplay);
  LVisual    := XDefaultVisual(LDisplay, LScreenNum);
  LWidth     := XDisplayWidth(LDisplay, LScreenNum);
  LHeight    := XDisplayHeight(LDisplay, LScreenNum);
  
  LSurface := cairo_xlib_surface_create(LDisplay, LWindow, LVisual, LWidth, LHeight);
  cairo_surface_write_to_png(LSurface, 'screenshot.png');
  cairo_surface_destroy(LSurface);
  
  XCloseDisplay(LDisplay);
end.
