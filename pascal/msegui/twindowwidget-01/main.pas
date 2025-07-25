
unit main;

{$IFDEF FPC}{$MODE objfpc}{$H+}{$ENDIF}

interface

uses
  mseguiintf, { msedisplay }
  msegui,
  msegraphutils, { rectty }
  mseforms,
  msewindowwidget;

type
  tmainfo = class(tmainform)
    xrenderwidget: twindowwidget;
    procedure clientpaintexe(const sender: tcustomwindowwidget; const aupdaterect: rectty);
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
begin
  widgetwidth := sender.viewport.cx;
  widgetheight := sender.viewport.cy;
  scr := XDefaultScreen(msedisplay);
  vis := XDefaultVisual(msedisplay, scr);
  XClearWindow(msedisplay, sender.clientwinid);
  surf := cairo_xlib_surface_create(msedisplay, sender.clientwinid, vis, widgetwidth, widgetheight);
  context := cairo_create(surf);
{ Paint widget in blue. }
  cairo_set_source_rgb(context, 0.0, 0.0, 0.5);
  cairo_paint(context);
{ Draw a white line. }
  cairo_set_line_width(context, 20);
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
  cairo_set_source_rgb(context, 1.0, 1.0, 1.0);
  cairo_move_to(context, widgetwidth div 8, widgetheight div 8);
  cairo_line_to(context, 7 * (widgetwidth div 8), 7 * (widgetheight div 8));
  cairo_stroke(context);
  cairo_destroy(context);
  cairo_surface_destroy(surf);
end;

end.
