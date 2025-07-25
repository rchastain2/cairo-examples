
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
  cairo_set_source_rgb(context, 0.0, 0.0, 1.0);
  cairo_set_line_width(context, 0.1);
  
	cairo_rectangle(context, 0.1, 0.1, 0.8, 0.8);
	cairo_fill(context); 
  
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
