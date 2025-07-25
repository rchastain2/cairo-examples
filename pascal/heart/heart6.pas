
uses
  SysUtils, Math, Cairo;

procedure MakeHeart(c: pcairo_t; x, y, r, d: double);
var
  y1, y2, y3, y4, x1, x2, x3, x4: double;
begin
  y1 := y - r;
  y2 := y - r / 3;
  y3 := y + r / 3;
  y4 := y + r;
  x1 := x - r;
  x2 := x - d;
  x3 := x + d;
  x4 := x + r;
  cairo_move_to (c, x,  y4);
  cairo_curve_to(c, x2, y3, x1, y3, x1, y2);
  cairo_curve_to(c, x1, y1, x2, y1, x,  y2);
  cairo_curve_to(c, x3, y1, x4, y1, x4, y2);
  cairo_curve_to(c, x4, y3, x3, y3, x,  y4);
end;

const
  SURFACE_WIDTH = 128;
  SURFACE_HEIGHT = 128;
  
var
  context: pcairo_t;
  surface: pcairo_surface_t;
  dw, dh: integer;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  dw := SURFACE_WIDTH;
  dh := SURFACE_HEIGHT;
  
  MakeHeart(context, dw / 2, dh / 2, Min(dw, dh) / 3, 0);
{
  La sixième procédure fait la même chose mais utilise des jointures (joins) pointues et des extrémités (caps) carrées.
  On voit que la jointure pointue n'est pas effectuée dans le creux du cœur car l'angle (0 degré pour un écart d=0) est trop petit pour que ce soit réalisable.
}
  cairo_set_line_cap(context, CAIRO_LINE_CAP_SQUARE);
  cairo_set_line_join(context, CAIRO_LINE_JOIN_MITER);
  cairo_set_line_width(context, 9.0);
  cairo_set_source_rgba(context, 1.0, 0.0, 0.0, 0.5);
  cairo_stroke_preserve(context);
  cairo_set_line_width(context, 3.0);
  cairo_set_source_rgba(context, 1.0, 0.0, 0.0, 1.0);
  cairo_stroke(context);
  
  cairo_surface_write_to_png(surface, pchar(ChangeFileExt({$I %FILE%}, '.png')));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
