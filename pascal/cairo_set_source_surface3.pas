
uses
  Cairo;

const
  SURFACE_WIDTH = 256;
  SURFACE_HEIGHT = 256;

var 
  context: pcairo_t;
  destination, source: pcairo_surface_t;
  w, h: integer;
  
begin
  destination := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(destination);
  
  cairo_arc(context, SURFACE_WIDTH / 2, SURFACE_HEIGHT / 2, SURFACE_WIDTH / 2, 0, 2 * PI);
  cairo_clip(context);
  //cairo_new_path(context);
  
  source := cairo_image_surface_create_from_png('corot1.png');
  w := cairo_image_surface_get_width(source);
  h := cairo_image_surface_get_height(source);
  
  //cairo_scale(context, 256 / w, 256 / h);
  
  cairo_set_source_surface(context, source, 0, 0);
  cairo_paint(context);
  cairo_destroy(context);
  
  cairo_surface_destroy(source);
  
  cairo_surface_write_to_png(destination, pchar('image.png'));
  
  cairo_surface_destroy(destination);
end.
