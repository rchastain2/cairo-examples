
(* https://mathimages.swarthmore.edu/index.php/Cardioid *)

uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH = 480;
  SURFACE_HEIGHT = 480;

const
  R = 0.25;
  X = -R;
  Y = 0;
  
var
  context: pcairo_t;
  surface: pcairo_surface_t;
  a,
  xx, yy,
  rr: double;

const
  D = 0.3;

var
  dx, dy: double;
  xx1, yy1, xx2, yy2: double;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_set_source_rgb(context, 1, 1, 1);
  cairo_paint(context);

  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_translate(context, 1 / 2, 1 / 2);
  
  cairo_set_line_width(context, 1 / 500);
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
  cairo_set_line_join(context, CAIRO_LINE_JOIN_ROUND);
  
  cairo_set_source_rgb(context, 0, 0, 0);
  cairo_arc(context, 0, 0, R, 0, 2 * PI);
  cairo_stroke(context);
  (*
  cairo_set_source_rgb(context, 0, 0, 0);
  cairo_arc(context, X, Y, 1 / 200, 0, 2 * PI);
  cairo_fill(context);
  *)
  a := 0;
  
  while a < 2 * PI - PI / 72 do
  begin
    xx1 := 0;
    yy1 := -R;
    xx2 := R * Cos(PI - a);
    yy2 := R * Sin(PI - a);
    
    cairo_set_source_rgba(context, 0.5, 0.0, 0.0, 0.5);
    cairo_move_to(context, xx1, yy1);
    cairo_line_to(context, xx2, yy1);
    cairo_line_to(context, xx2, yy2);
    cairo_stroke(context);

    a := a + PI / 36;
    cairo_rotate(context, PI / 36);
  end;
  (*
  cairo_set_source_rgb(context, 0, 0, 0);
  cairo_arc(context, X, Y, 1 / 200, 0, 2 * PI);
  cairo_fill(context);
  *)
  cairo_surface_write_to_png(surface, pchar('image.png'));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
