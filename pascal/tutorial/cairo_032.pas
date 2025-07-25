
uses
  Cairo;

var 
  source, destination: pcairo_surface_t;
  context: pcairo_t;
  
begin
  source := cairo_image_surface_create_from_png('.\image\corot1.png');
  destination := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 120, 120);
  context := cairo_create(destination);
  
{
  Note that the paint operation will copy the entire surface. If you'd like to instead copy some
  (width, height) rectangle from (source_x, source_y) to some point (dest_x, dest_y) on the
  destination you would instead compute a new position for the source surface origin and then use
  cairo_fill instead of cairo_paint:

  cairo_set_source_surface(context, source, dest_x - source_x, dest_y - source_y);
  cairo_rectangle(context, dest_x, dest_y, width, height);
}
  
  cairo_set_source_surface(context, source, 10 - 200, 10 - 400);
  
  cairo_rectangle(context, 10, 10, 100, 100);
  cairo_fill(context);
  cairo_destroy(context);
  
  cairo_surface_destroy(source);
  
  cairo_surface_write_to_png(destination, pchar('image.png'));
  
  cairo_surface_destroy(destination);
end.
