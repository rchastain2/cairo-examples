
(* https://mathimages.swarthmore.edu/index.php/Cardioid *)

uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH = 360;
  SURFACE_HEIGHT = 360;

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

var
  dx, dy: double;
  xx1, yy1, xx2, yy2: double;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  (*
  cairo_set_source_rgb(context, 1, 1, 1);
  cairo_paint(context);
  *)
  
  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_translate(context, 1 / 2, 1 / 2);
  
  (*
  cairo_set_line_width(context, 1 / 500);
  
  cairo_set_source_rgb(context, 0, 0, 1);
  cairo_arc(context, 0, 0, R, 0, 2 * PI);
  cairo_stroke(context);
  
  cairo_set_source_rgb(context, 0, 0, 0);
  cairo_arc(context, X, Y, 1 / 200, 0, 2 * PI);
  cairo_fill(context);
  *)
  
  a := 0;
  
  while a <= 2 * PI do
  begin
    (*
    xx := R * Cos(a);
    yy := R * Sin(a);
    
    dx := xx - X;
    dy := yy - Y;
    rr := Sqrt(dx * dx + dy * dy);
    
    xx1 := xx - (D / rr) * dx;
    yy1 := yy - (D / rr) * dy;
    xx2 := xx + (D / rr) * dx;
    yy2 := yy + (D / rr) * dy;
    *)
    
    xx := 2 * R * Cos(a) * (1 + Cos(a)) + X;
    yy := 2 * R * Sin(a) * (1 + Cos(a)) + Y;
    
    if a = 0 then
      cairo_move_to(context, xx, yy)
    else
      cairo_line_to(context, xx, yy);
    
    (*
    cairo_set_source_rgba(context, 1, 0, 0, 0.5);
    cairo_move_to(context, xx1, yy1);
    cairo_line_to(context, xx2, yy2);
    cairo_stroke(context);
    *)
    
    (*
    cairo_set_source_rgba(context, 1, 0, 0, 1);
    //cairo_arc(context, xx, yy, 1 / 200, 0, 2 * PI);
    cairo_arc(context, xx1, yy1, 1 / 300, 0, 2 * PI);
    cairo_arc(context, xx2, yy2, 1 / 300, 0, 2 * PI);
    cairo_fill(context);
    *)
    
    a := a + PI / 49;
  end;
  
  cairo_set_line_width(context, 1 / 300);
  cairo_set_source_rgb(context, 1, 0, 0);
  cairo_stroke(context);
  
  cairo_surface_write_to_png(surface, pchar('image.png'));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
