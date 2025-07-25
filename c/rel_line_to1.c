
#include <math.h>
#include <cairo/cairo.h>

int main(int argc, char* argv[])
{
  cairo_surface_t* surface;
  cairo_t* cr;

  surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 120, 120);
  cr = cairo_create(surface);

  cairo_scale(cr, 120, 120);

  cairo_set_line_width(cr, 0.1);
  cairo_set_source_rgb(cr, 0, 0, 0);

  cairo_move_to(cr, 0.25, 0.25);
  cairo_line_to(cr, 0.5, 0.375);
  cairo_rel_line_to(cr, 0.25, -0.125);
  cairo_arc(cr, 0.5, 0.5, 0.25 * sqrt(2), -0.25 * M_PI, 0.25 * M_PI);
  cairo_rel_curve_to(cr, -0.25, -0.125, -0.25, 0.125, -0.5, 0);
  cairo_close_path(cr);

  cairo_stroke(cr);

  cairo_surface_write_to_png(surface, "image.png");
  cairo_destroy(cr);
  cairo_surface_destroy(surface);

  return 0;
}
