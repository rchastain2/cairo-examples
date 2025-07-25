
uses
  Cairo;

const
  SURFACE_WIDTH = 200;
  SURFACE_HEIGHT = 200;

var 
  surface: pcairo_surface_t;
  context: pcairo_t;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  
  context := cairo_create(surface);
  cairo_move_to(context, 20, 20);
  cairo_line_to(context, SURFACE_WIDTH - 20, 20);
  cairo_line_to(context, SURFACE_WIDTH - 20, SURFACE_HEIGHT - 20);
  cairo_stroke(context);
  cairo_destroy(context);
  
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_surface_destroy(surface);
end.
