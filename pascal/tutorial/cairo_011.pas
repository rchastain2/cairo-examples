
uses
  Cairo;

const
  SURFACE_WIDTH = 200;
  SURFACE_HEIGHT = 200;

var
  surface: pcairo_surface_t;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_surface_destroy(surface);
end.
