
uses
  Cairo;

const
  SURFACE_WIDTH = 100;
  SURFACE_HEIGHT = 100;

var
  context: pcairo_t;
  surface: pcairo_surface_t;

var
  x, x1, x2, x3: Double;
  y, y1, y2, y3: Double;
begin
  x := 0.1;
  y := 0.5;
  x1 := 0.4;
  y1 := 0.9;
  x2 := 0.6;
  y2 := 0.1;
  x3 := 0.9;
  y3 := 0.5;

  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH,
    SURFACE_HEIGHT);
  context := cairo_create(surface);

  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_set_line_width(context, 0.03);
  cairo_move_to(context, x, y);
  cairo_curve_to(context, x1, y1, x2, y2, x3, y3);

  cairo_stroke(context);

  cairo_set_source_rgba(context, 1, 0.2, 0.2, 0.6);
  
  cairo_move_to(context, x, y);
  cairo_line_to(context, x1, y1);
  cairo_move_to(context, x2, y2);
  cairo_line_to(context, x3, y3);
  cairo_stroke(context);

  cairo_destroy(context);
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_surface_destroy(surface);
end.
