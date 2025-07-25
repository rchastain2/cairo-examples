
uses
  Cairo;

const
  SURFACE_WIDTH = 256;
  SURFACE_HEIGHT = 256;

var
  context: pcairo_t;
  surface: pcairo_surface_t;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH,
    SURFACE_HEIGHT);
  context := cairo_create(surface);

  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);

  cairo_set_operator(context, CAIRO_OPERATOR_XOR);
  cairo_set_source_rgba(context, 1, 0, 0, 0.5);
  cairo_rectangle(context, 0.2, 0.2, 0.5, 0.5);
  cairo_fill(context);
  cairo_set_source_rgb(context, 0, 1, 0);
  cairo_rectangle(context, 0.4, 0.4, 0.4, 0.4);
  cairo_fill(context);
  cairo_set_source_rgb(context, 0, 0, 1);
  cairo_rectangle(context, 0.6, 0.6, 0.3, 0.3);
  cairo_fill(context);

  cairo_surface_write_to_png(surface, pchar('image.png'));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
