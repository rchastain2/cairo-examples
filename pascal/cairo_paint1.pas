
uses
  sysutils, Cairo;

const
  SURFACE_WIDTH = 100;
  SURFACE_HEIGHT = 100;

var
  surface: pcairo_surface_t;
  context: pcairo_t;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_set_source_rgb(context, 1.0, 0.0, 0.0);
  
{
  cairo_set_source_rgb ()

  void
  cairo_set_source_rgb (cairo_t *context,
                        double red,
                        double green,
                        double blue);

  Sets the source pattern within context to an opaque color. This opaque color will then be used for any
  subsequent drawing operation until a new source pattern is set.

  The default source pattern is opaque black, (that is, it is equivalent to
  cairo_set_source_rgb(context, 0.0, 0.0, 0.0)).
}
  
  cairo_paint(context);
  
  cairo_destroy(context);
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_surface_destroy(surface);
end.
