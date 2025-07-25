
uses
  SysUtils, Cairo, Lys;

const
  SURFACE_WIDTH  = 480;
  SURFACE_HEIGHT = 480;
  X_SCALE        = 440;
  Y_SCALE        = 480;
  
var
  context: pcairo_t;
  surface: pcairo_surface_t;

procedure MoveTo(const i: integer);
var
  x, y: double;
begin
  x := DATA[i];
  y := DATA[i + 1];
  cairo_move_to(context, x, y);
end;

procedure CurveTo(const i: integer);
var
  x1, y1, x2, y2, x3, y3: double;
begin
  x1 := DATA[i];
  y1 := DATA[i + 1];
  x2 := DATA[i + 2];
  y2 := DATA[i + 3];
  x3 := DATA[i + 4];
  y3 := DATA[i + 5];
  cairo_curve_to(context, x1, y1, x2, y2, x3, y3);
end;

var
  i: integer;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_set_source_rgb(context, 0.0, 0.0, 0.0);
  cairo_paint(context);
  
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
  cairo_set_line_join(context, CAIRO_LINE_JOIN_ROUND);
  
  cairo_translate(context, (SURFACE_WIDTH - X_SCALE) div 2, 0);
  cairo_scale(context, X_SCALE, Y_SCALE);
  cairo_set_line_width(context, 1 / 100);
  
  MoveTo(0);
  for i := 0 to 9 do
    CurveTo(6 * i + 2);
  cairo_close_path(context);
  
  MoveTo(62);
  for i := 0 to 9 do
    CurveTo(6 * i + 64);
  cairo_close_path(context);
  
  MoveTo(124);
  for i := 0 to 7 do
    CurveTo(6 * i + 126);
  cairo_close_path(context);
  
  (*
  cairo_set_source_rgba(context, 0.0, 0.0, 1.0, 0.2);
  cairo_fill_preserve(context);
  cairo_set_source_rgba(context, 0.0, 0.0, 1.0, 0.5);
  cairo_stroke(context);
  *)
  cairo_set_source_rgb(context, 1.0, 1.0, 1.0);
  cairo_fill(context);
  
  MoveTo(174);
  for i := 0 to 3 do
    CurveTo(6 * i + 176);
  cairo_close_path(context);
  
  (*
  cairo_set_source_rgba(context, 0.0, 0.0, 1.0, 0.2);
  cairo_fill_preserve(context);
  cairo_set_source_rgba(context, 0.0, 0.0, 1.0, 0.5);
  cairo_stroke(context);
  *)
  cairo_set_source_rgb(context, 1.0, 1.0, 1.0);
  cairo_fill(context);
  
  cairo_surface_write_to_png(surface, pchar(ChangeFileExt({$I %FILE%}, '.png')));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
