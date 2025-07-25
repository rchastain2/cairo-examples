#include <cairo/cairo.h>

int main(int argc, char* argv[])
{
  cairo_surface_t* surface;
  cairo_t* cr;

  surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 120, 120);
  cr = cairo_create(surface);
  cairo_scale(cr, 120, 120);

  cairo_set_source_rgb(cr, 0, 0, 0);
  cairo_move_to(cr, 0, 0);
  cairo_line_to(cr, 1, 1);
  cairo_move_to(cr, 1, 0);
  cairo_line_to(cr, 0, 1);
  cairo_set_line_width(cr, 0.2);
  cairo_stroke(cr);

  cairo_rectangle(cr, 0, 0, 0.5, 0.5);
  cairo_set_source_rgba(cr, 1, 0, 0, 0.80);
  cairo_fill(cr);

  cairo_rectangle(cr, 0, 0.5, 0.5, 0.5);
  cairo_set_source_rgba(cr, 0, 1, 0, 0.60);
  cairo_fill(cr);

  cairo_rectangle(cr, 0.5, 0, 0.5, 0.5);
  cairo_set_source_rgba(cr, 0, 0, 1, 0.40);
  cairo_fill(cr);

  cairo_surface_write_to_png(surface, "image.png");
  cairo_destroy(cr);
  cairo_surface_destroy(surface);

  return 0;
}

