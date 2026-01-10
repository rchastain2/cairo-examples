
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
  cr1, cr2: pcairo_t;
  sf1, sf2: pcairo_surface_t;
  a,
  xx, yy,
  rr: double;
  sw, sh: integer;

const
  D = 0.3;
  R2 = 1 / 250;
  
var
  dx, dy: double;
  xx1, yy1, xx2, yy2: double;
  darkblue, lightblue, white, bkcolor, linecolor, pointcolor: TCairoColor;
  filename: string;

begin
  sw := StrToIntDef(ParamStr(1), SURFACE_WIDTH);
  sh := StrToIntDef(ParamStr(2), SURFACE_HEIGHT);
  
  darkblue  := TCairoColor.Create($262F45);
  lightblue := TCairoColor.Create($2397D4);
  white     := TCairoColor.Create($FFFFFF);
{ https://wiki.mageia.org/en/Directives_pour_la_conception_graphique-fr#Palette_de_couleurs_officielle }
  
  if (ParamStr(1) = '--dark') or (ParamStr(3) = '--dark') then
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
  filename := Format(Concat(filename, '-%dx%d.png'), [sw, sh]);
  
  sf1 := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, sw, sh);
  cr1 := cairo_create(sf1);
  
  sf2 := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, sw, sh);
  cr2 := cairo_create(sf2);
  
  cairo_save(cr1);
  
  cairo_scale(cr1, sh, sh);
  cairo_translate(cr1, (1 / 2) * (sw / sh), 1 / 2);
  cairo_scale(cr2, sh, sh);
  cairo_translate(cr2, (1 / 2) * (sw / sh), 1 / 2);
  
  cairo_set_line_width(cr1, 1 / 500);
  cairo_set_line_cap(cr1, CAIRO_LINE_CAP_ROUND);
  cairo_set_line_join(cr1, CAIRO_LINE_JOIN_ROUND);
  
  with bkcolor do cairo_set_source_rgb(cr1, r, g, b);
  cairo_paint(cr1);
  
 {cairo_set_source_rgb(cr1, 0, 0, 1);
  cairo_arc(cr1, 0, 0, R, 0, 2 * PI);
  cairo_stroke(cr1);
  
  cairo_set_source_rgb(cr1, 0, 0, 0);
  cairo_arc(cr1, X, Y, R2, 0, 2 * PI);
  cairo_fill(cr1);}
  
  with linecolor do cairo_set_source_rgb(cr1, r, g, b);
  with pointcolor do cairo_set_source_rgb(cr2, r, g, b);
  
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
    
    cairo_move_to(cr1, xx1, yy1);
    cairo_line_to(cr1, xx2, yy2);
    cairo_stroke(cr1);
    
    cairo_arc(cr2, xx, yy, R2, 0, 2 * PI);
    cairo_arc(cr2, xx1, yy1, R2, 0, 2 * PI);
    cairo_arc(cr2, xx2, yy2, R2, 0, 2 * PI);
    cairo_fill(cr2);
    
    a := a + PI / 18;
  end;
  
  cairo_restore(cr1);
  cairo_set_source_surface(cr1, sf2, 0.0, 0.0);
  cairo_paint(cr1);
  
  cairo_surface_write_to_png(sf1, pchar(filename));

  cairo_destroy(cr1);
  cairo_surface_destroy(sf1);
  cairo_destroy(cr2);
  cairo_surface_destroy(sf2);
end.
