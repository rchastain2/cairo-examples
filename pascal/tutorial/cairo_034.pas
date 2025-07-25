
uses
  Cairo, Math;

const
  SURFACE_WIDTH = 200;
  SURFACE_HEIGHT = 200;

var 
  context: pcairo_t;
  surface: pcairo_surface_t;
  w, h: integer;
  image: pcairo_surface_t;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_arc(context, 0.5, 0.5, 0.5, 0, 2 * PI);
  cairo_clip(context);

  image := cairo_image_surface_create_from_png('.\image\corot1.png');
  
  w := cairo_image_surface_get_width(image);
  h := cairo_image_surface_get_height(image);
  
  cairo_scale(context, 1 / Min(w, h), 1 / Min(w, h));
  
  cairo_set_source_surface(context, image, 0, 0);
  cairo_paint(context);
  cairo_surface_destroy(image);
  
  cairo_destroy(context);
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_surface_destroy(surface);
end.
