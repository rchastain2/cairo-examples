
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
  x, y: double;
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

  cairo_set_line_width(context, 1 / 300);
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
  cairo_set_source_rgba(context, 0.0, 0.0, 0.0, 0.5);

  cairo_move_to(context,-0.45, 0.00);
  cairo_line_to(context, 0.45, 0.00);
  cairo_move_to(context, 0.00,-0.45);
  cairo_line_to(context, 0.00, 0.45);
  cairo_stroke(context);

  cairo_arc(context, 0, 0, 0.4, 0, 2 * PI);
  cairo_stroke(context);

  cairo_set_line_width(context, 1 / 200);  
  
  cairo_arc(context, 0, 0, 0.4, -fangle, 0);
  cairo_stroke(context);
  
  x :=  0.4 * cos(fangle);
  y := -0.4 * sin(fangle);
  
  cairo_set_source_rgba(context, 0.0, 0.0, 0.5, 0.7);
  
  cairo_move_to(context, 0, 0);
  cairo_line_to(context, x, y);
  cairo_stroke(context);

  cairo_set_source_rgba(context, 0.0, 0.5, 0.0, 0.7);

  cairo_move_to(context, 0, y);
  cairo_line_to(context, x, y);
  cairo_stroke(context);

  cairo_set_source_rgba(context, 0.5, 0.0, 0.0, 0.7);

  cairo_move_to(context, x, 0);
  cairo_line_to(context, x, y);
  cairo_stroke(context);

  cairo_destroy(context);
  cairo_surface_destroy(surf);
end;

procedure tmainfo.ttimer1ontimer(const sender: TObject);
begin
  fangle := fangle + 1 / 100;
  if fangle > 2 * pi then
    fangle := fangle - 2 * pi;
  xrenderwidget.invalidate;
end;

procedure tmainfo.tmainfooncreate(const sender: TObject);
begin
  fangle := 0;
end;

end.
