
(* https://mathimages.swarthmore.edu/index.php/Cardioid *)

{$MODE objfpc}{$H+}

uses
  SysUtils, Cairo, CairoColor;

const
  SURFACE_WIDTH = 1600;
  SURFACE_HEIGHT = 900;

const
  R = 0.15;
  X = -R;
  Y = 0;
  
var
  context, context2: pcairo_t;
  surface, surface2: pcairo_surface_t;
  a,
  xx, yy,
  rr: double;

const
  D = 0.3;
  R2 = 1 / 250;
  
var
  dx, dy: double;
  xx1, yy1, xx2, yy2: double;
  darkblue, lightblue, white, bkcolor, linecolor, pointcolor: TCairoColor;
  filename: string;

begin
  darkblue  := TCairoColor.Create($262F45);
  lightblue := TCairoColor.Create($2397D4);
  white     := TCairoColor.Create($FFFFFF);
{ https://wiki.mageia.org/en/Directives_pour_la_conception_graphique-fr#Palette_de_couleurs_officielle }
  
  if ParamStr(1) = '--dark' then
  begin
    bkcolor := darkblue;
    linecolor := lightblue;
    filename := 'dark';
  end else
  begin
    bkcolor := lightblue;
    linecolor := darkblue;
    filename := 'light';
  end;
  pointcolor := white;
  filename := Format(Concat(filename, '-%dx%d.png'), [SURFACE_WIDTH, SURFACE_HEIGHT]);
  
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  surface2 := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context2 := cairo_create(surface2);
  
  cairo_save(context);
  
  cairo_scale(context, SURFACE_HEIGHT, SURFACE_HEIGHT);
  cairo_translate(context, (1 / 2) * (SURFACE_WIDTH / SURFACE_HEIGHT), 1 / 2);
  cairo_scale(context2, SURFACE_HEIGHT, SURFACE_HEIGHT);
  cairo_translate(context2, (1 / 2) * (SURFACE_WIDTH / SURFACE_HEIGHT), 1 / 2);
  
  cairo_set_line_width(context, 1 / 500);
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
  cairo_set_line_join(context, CAIRO_LINE_JOIN_ROUND);
  
  with bkcolor do cairo_set_source_rgb(context, r, g, b);
  cairo_paint(context);
  
 {cairo_set_source_rgb(context, 0, 0, 1);
  cairo_arc(context, 0, 0, R, 0, 2 * PI);
  cairo_stroke(context);
  
  cairo_set_source_rgb(context, 0, 0, 0);
  cairo_arc(context, X, Y, R2, 0, 2 * PI);
  cairo_fill(context);}
  
  with linecolor do cairo_set_source_rgb(context, r, g, b);
  with pointcolor do cairo_set_source_rgb(context2, r, g, b);
  
  a := PI / 36;
  
  while a < 2 * PI do
  begin
    xx := R * Cos(a);
    yy := R * Sin(a);
    
    dx := xx - X;
    dy := yy - Y;
    rr := Sqrt(dx * dx + dy * dy);
    
    xx1 := xx - (D / rr) * dx;
    yy1 := yy - (D / rr) * dy;
    xx2 := xx + (D / rr) * dx;
    yy2 := yy + (D / rr) * dy;
    
    cairo_move_to(context, xx1, yy1);
    cairo_line_to(context, xx2, yy2);
    cairo_stroke(context);
    
    cairo_arc(context2, xx, yy, R2, 0, 2 * PI);
    cairo_arc(context2, xx1, yy1, R2, 0, 2 * PI);
    cairo_arc(context2, xx2, yy2, R2, 0, 2 * PI);
    cairo_fill(context2);
    
    a := a + PI / 18;
  end;
  
  cairo_restore(context);
  cairo_set_source_surface(context, surface2, 0.0, 0.0);
  cairo_paint(context);
  
  cairo_surface_write_to_png(surface, pchar(filename));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
  cairo_destroy(context2);
  cairo_surface_destroy(surface2);
end.
