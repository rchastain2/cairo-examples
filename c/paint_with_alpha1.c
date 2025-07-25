#include <cairo/cairo.h>

int main(int argc, char* argv[])
{
  cairo_surface_t* surface;
  cairo_t* cr;

  surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 120, 120);
  cr = cairo_create(surface);
  cairo_scale(cr, 120, 120);

  cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
  cairo_paint_with_alpha(cr, 0.5);

  cairo_surface_write_to_png(surface, "image.png");
  cairo_destroy(cr);
  cairo_surface_destroy(surface);

  return 0;
}

