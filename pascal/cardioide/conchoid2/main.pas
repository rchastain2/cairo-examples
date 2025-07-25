
unit main;

{$IFDEF FPC}{$MODE objfpc}{$H+}{$ENDIF}

interface

uses
  mseguiintf, { msedisplay }
  msegui,
  msegraphutils, { rectty }
  mseforms,
  msewindowwidget,
  msetimer;

type
  tmainfo = class(tmainform)
    xrenderwidget: twindowwidget;
    ttimer1: ttimer;
    procedure clientpaintexe(const sender: tcustomwindowwidget; const aupdaterect: rectty);
    procedure ttimer1ontimer(const sender: TObject);
    procedure tmainfooncreate(const sender: TObject);
  private
    fangle: double;
  end;

var
  mainfo: tmainfo;

implementation

uses
  main_mfm,
  x,
  xlib,
  xutil,
  cairo,
  cairoxlib;

procedure tmainfo.clientpaintexe(const sender: tcustomwindowwidget; const aupdaterect: rectty);
var
  scr: integer;
  vis: PVisual;
  surf: pcairo_surface_t;
  context: pcairo_t;
  widgetwidth, widgetheight: integer;
const
  R = 0.15;
  X = -R;
  Y = 0;
var
  a,
  xx, yy,
  rr: double;
const
  D = 0.3;
var
  dx, dy: double;
  xx1, yy1, xx2, yy2: double;
begin
  widgetwidth := sender.viewport.cx;
  widgetheight := sender.viewport.cy;

  scr := XDefaultScreen(msedisplay);
  vis := XDefaultVisual(msedisplay, scr);

  XClearWindow(msedisplay, sender.clientwinid);

  surf := cairo_xlib_surface_create(msedisplay, sender.clientwinid, vis, widgetwidth, widgetheight);
  context := cairo_create(surf);

  cairo_set_source_rgb(context, 1.0, 1.0, 1.0);
  cairo_paint(context);

  cairo_scale(context, widgetwidth, widgetheight);
  cairo_translate(context, 0.5, 0.5);
  
  cairo_set_line_width(context, 1 / 500);
  
  cairo_set_source_rgb(context, 0, 0, 1);
  cairo_arc(context, 0, 0, R, 0, 2 * PI);
  cairo_stroke(context);
  
  cairo_set_source_rgb(context, 0, 0, 0);
  cairo_arc(context, X, Y, 1 / 200, 0, 2 * PI);
  cairo_fill(context);
  
    xx := R * Cos(fangle);
    yy := R * Sin(fangle);
    
    dx := xx - X;
    dy := yy - Y;
    rr := Sqrt(dx * dx + dy * dy);
    
    xx1 := xx - (D / rr) * dx;
    yy1 := yy - (D / rr) * dy;
    xx2 := xx + (D / rr) * dx;
    yy2 := yy + (D / rr) * dy;
    
    cairo_set_source_rgba(context, 1, 0, 0, 0.5);
    cairo_move_to(context, xx1, yy1);
    cairo_line_to(context, xx2, yy2);
    cairo_stroke(context);
    
    cairo_set_source_rgb(context, 0, 0, 0);
    cairo_arc(context, xx, yy, 1 / 200, 0, 2 * PI);
    cairo_arc(context, xx1, yy1, 1 / 200, 0, 2 * PI);
    cairo_arc(context, xx2, yy2, 1 / 200, 0, 2 * PI);
    cairo_fill(context);
  
  cairo_destroy(context);
  cairo_surface_destroy(surf);
end;

procedure tmainfo.ttimer1ontimer(const sender: TObject);
begin
  fangle := fangle + PI / 18;
  if fangle > 2 * pi then
    fangle := fangle - 2 * pi;
  xrenderwidget.invalidate;
end;

procedure tmainfo.tmainfooncreate(const sender: TObject);
begin
  fangle := 0;
end;

end.
