
/* http://stackoverflow.com/questions/10983739/how-to-composite-multiple-png-into-a-single-png-using-gtk-cairo */

#include <cairo/cairo.h>

int main(void)
{
  cairo_surface_t* surf1 = cairo_image_surface_create_from_png("image1.png");
  cairo_surface_t* surf2 = cairo_image_surface_create_from_png("image2.png");
  
  cairo_surface_t* img = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 100, 100);
  cairo_t* cr = cairo_create(img);

  cairo_set_source_rgba(cr, 0, 0, 0, 1);
  cairo_paint(cr);

  cairo_set_source_surface(cr, surf1, 0, 0);
  cairo_paint(cr);

  cairo_set_source_surface(cr, surf2, 50, 50);
  cairo_paint(cr);

  cairo_surface_flush(img);
  cairo_destroy(cr);

  cairo_surface_write_to_png(img, "image.png");

  cairo_surface_destroy(img);
  cairo_surface_destroy(surf1);
  cairo_surface_destroy(surf2);
  
  return 0;
}
