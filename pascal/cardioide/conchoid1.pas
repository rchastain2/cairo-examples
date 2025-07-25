
(* https://mathimages.swarthmore.edu/index.php/Cardioid *)

uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH = 480;
  SURFACE_HEIGHT = 480;

const
  R = 0.15;
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
  R2 = 1 / 250;
  
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
  
  (*
  cairo_set_source_rgb(context, 0, 0, 1);
  cairo_arc(context, 0, 0, R, 0, 2 * PI);
  cairo_stroke(context);
  *)
  
  cairo_set_source_rgb(context, 0, 0, 0);
  cairo_arc(context, X, Y, R2, 0, 2 * PI);
  cairo_fill(context);
  
  a := 0;
  
  while a < 2 * PI - PI / 72 do
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
    
    cairo_set_source_rgb(context, 0.5, 0.5, 0.5);
    cairo_move_to(context, xx1, yy1);
    cairo_line_to(context, xx2, yy2);
    cairo_stroke(context);
    
    cairo_set_source_rgb(context, 0, 0, 0);
    cairo_arc(context, xx, yy, R2, 0, 2 * PI);
    cairo_arc(context, xx1, yy1, R2, 0, 2 * PI);
    cairo_arc(context, xx2, yy2, R2, 0, 2 * PI);
    cairo_fill(context);
    
    a := a + PI / 18;
  end;

  cairo_surface_write_to_png(surface, pchar('image.png'));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
