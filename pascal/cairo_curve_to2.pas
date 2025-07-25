
uses
  Cairo;

const
  SURFACE_WIDTH = 100;
  SURFACE_HEIGHT = 100;

var
  surface: pcairo_surface_t;
  context: pcairo_t;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH,
    SURFACE_HEIGHT);
  context := cairo_create(surface);
  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_set_line_width(context, 0.12);
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
  cairo_set_line_join(context, CAIRO_LINE_JOIN_ROUND);
  cairo_move_to(context, 0.5, 0.1);
  cairo_line_to(context, 0.9, 0.9);
  cairo_rel_line_to(context, -0.4, 0.0);
  cairo_curve_to(context, 0.2, 0.9, 0.2, 0.5, 0.5, 0.5);
  cairo_stroke(context);
  cairo_destroy(context);
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_surface_destroy(surface);
end.
