
/* http://zetcode.com/gfx/cairo/clippingmasking/ */

#include <cairo/cairo.h>
#include <math.h>

struct {
  cairo_surface_t *image;
} glob;

int main(int argc, char *argv[])
{
  int width, height;
  cairo_surface_t* surface;
  cairo_t* cr;
  
  glob.image = cairo_image_surface_create_from_png("corot.png");
  width = cairo_image_surface_get_width(glob.image);
  height = cairo_image_surface_get_height(glob.image); 
  
  surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 800, 571);
  cr = cairo_create(surface);
  
  cairo_set_source_surface(cr, glob.image, 1, 1);
  cairo_arc(cr, 400, 300, 200, 0, 2 * M_PI);
  cairo_clip(cr);
  cairo_paint(cr);
  
  cairo_surface_write_to_png(surface, "image.png");
  
  cairo_destroy(cr);
  cairo_surface_destroy(surface);
  
  cairo_surface_destroy(glob.image);

  return 0;
}
