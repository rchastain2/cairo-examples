
uses
  Cairo;

var 
  source, destination: pcairo_surface_t;
  context: pcairo_t;
  w, h: integer;
  
begin
  source := cairo_image_surface_create_from_png('corot1.png');
  w := cairo_image_surface_get_width(source);
  h := cairo_image_surface_get_height(source);
  
  destination := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, w + 20, h + 20);
  
  context := cairo_create(destination);
  cairo_set_source_surface(context, source, 10, 10);
  cairo_paint(context);
  cairo_destroy(context);
  
  cairo_surface_destroy(source);
  
  cairo_surface_write_to_png(destination, pchar('image.png'));
  
  cairo_surface_destroy(destination);
end.
