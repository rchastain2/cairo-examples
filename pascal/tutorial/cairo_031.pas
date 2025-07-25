
uses
  Cairo;

var 
  source, destination: pcairo_surface_t;
  context: pcairo_t;
  width, height: integer;
  
begin
  source := cairo_image_surface_create_from_png('.\image\corot1.png');
  
  width := cairo_image_surface_get_width(source);
  height := cairo_image_surface_get_height(source);
  
  destination := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, width + 20, height + 20);
  
  context := cairo_create(destination);
  cairo_set_source_surface(context, source, 10, 10);
  cairo_paint(context);
  cairo_destroy(context);
  
  cairo_surface_destroy(source);
  
  cairo_surface_write_to_png(destination, pchar('image.png'));
  
  cairo_surface_destroy(destination);
end.
