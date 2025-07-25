
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
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_set_source_rgb(context, 1, 1, 1);
  cairo_paint(context);

  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_translate(context, 1 / 2, 1 / 2);
  
  cairo_set_line_width(context, 1 / 500);
  (*
  cairo_set_source_rgb(context, 0, 0, 1);
  cairo_arc(context, 0, 0, R, 0, 2 * PI);
  cairo_stroke(context);
  *)
  cairo_set_source_rgb(context, 1, 0, 0);
  cairo_arc(context, X, Y, 1 / 200, 0, 2 * PI);
  cairo_fill(context);
  
  a := 0;
  
  while a < 2 * PI - PI / 72 do
  begin
    xx := R * Cos(a);
    yy := R * Sin(a);
    
    cairo_set_source_rgb(context, 0, 0, 1);
    cairo_arc(context, xx, yy, 1 / 250, 0, 2 * PI);
    cairo_fill(context);
    
    rr := Sqrt((xx - X) * (xx - X) + (yy - Y) * (yy - Y));
    
    cairo_set_source_rgba(context, 1, 0, 0, 0.3);
    cairo_arc(context, xx, yy, rr, 0, 2 * PI);
    cairo_stroke(context);

    a := a + PI / 36;
  end;

  cairo_surface_write_to_png(surface, pchar('image.png'));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
