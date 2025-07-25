
/* https://stackoverflow.com/questions/10983739/how-to-composite-multiple-png-into-a-single-png-using-gtk-cairo */

#include <cairo.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
   if (argc < 3) {
      printf("Usage:\n%s file1.png file2.png [outputfilename.png]\n", argv[0]);
      return 1;
   }
  
  cairo_surface_t *surf1 = cairo_image_surface_create_from_png(argv[1]);
  cairo_surface_t *surf2 = cairo_image_surface_create_from_png(argv[2]);

  cairo_surface_t *surf0 = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 400, 400);

  cairo_t *cr = cairo_create(surf0);

  cairo_set_source_rgba(cr, 0, 0, 0, 0);
  cairo_paint(cr);

  cairo_set_source_surface(cr, surf1, 0, 0);
  cairo_paint(cr);

  cairo_set_source_surface(cr, surf2, 0, 0);
  cairo_paint(cr);

  cairo_surface_flush(surf0);
  cairo_destroy(cr);
  
  if (argc > 3) {
    cairo_surface_write_to_png(surf0, argv[3]);
  } else {
    cairo_surface_write_to_png(surf0, "out.png");
  }

  cairo_surface_destroy(surf0);
  cairo_surface_destroy(surf1);
  cairo_surface_destroy(surf2);

  return 0;
}
