
uses
  cairo, sysutils;

var
  w, h: integer; 
  context: pcairo_t;
  surf: pcairo_surface_t;

begin
  w := 40;
  h := w;
  
  surf := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, w, h);
  context := cairo_create(surf);
  
  cairo_scale(context, w, h);
  
	cairo_rectangle(context, 0.0, 0.0, 1.0, 1.0);
  cairo_set_source_rgba(context, 1.000, 1.000, 0.000, 1.0);
	cairo_fill(context);
  
  cairo_set_line_width(context, 0.1);
  cairo_set_source_rgba(context, 1.000, 0.647, 0.000, 1.0);
  
  cairo_arc(
    context,
    1/2,
    1/2,
    7/16,
    0.0,
    2 * PI
  ); 
  cairo_fill(context); 
  
  cairo_surface_write_to_png(surf, pchar('image.png'));
  
  cairo_destroy(context);
  cairo_surface_destroy(surf);
end.
