
uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH = 200;
  SURFACE_HEIGHT = SURFACE_WIDTH;
  
var 
  context: pcairo_t;
  surface: pcairo_surface_t;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_set_source_rgb(context, 1.0, 1.0, 1.0);
  cairo_paint(context);
  
  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_translate(context, 1/2, 1/2);
  
  cairo_set_line_width(context, 1/100);
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
  cairo_set_source_rgb(context, 0.0, 0.0, 0.0); 
  
  cairo_arc(context, 0, 0, 1/3, 0, 2 * PI);
  cairo_stroke_preserve(context);
  
  cairo_set_source_rgb(context, 0.3, 0.4, 0.6); 
  cairo_fill(context);  
  
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
