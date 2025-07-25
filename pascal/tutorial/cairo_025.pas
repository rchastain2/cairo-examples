
uses
  Cairo;

const
  SURFACE_WIDTH = 100;
  SURFACE_HEIGHT = 100;

var 
  context: pcairo_t;
  surface: pcairo_surface_t;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_set_line_width(context, 0.1);
  
  cairo_arc(
    context,
    1 / 2,
    1 / 2,
    7 / 16,
    0,
    2 * PI
  );
  
  cairo_set_source_rgb(context, 1.0, 0.0, 0.0);
  cairo_fill_preserve(context);
  
  cairo_set_source_rgb (context, 0.0, 0.0, 1.0);
  cairo_stroke(context);
  
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
