
/* http://cairographics.org/samples/curve_to/ */

#include <cairo/cairo.h>

int main(void)
{
  double x = 25.6,  y = 128.0;
  double x1 = 102.4, y1 = 230.4, x2 = 153.6, y2 = 25.6, x3 = 230.4, y3 = 128.0;

  cairo_surface_t* img = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 600, 400);
  cairo_t* cr = cairo_create(img);
  cairo_set_source_rgba(cr, 1, 1, 1, 1);
  cairo_paint(cr);

  cairo_set_source_rgba(cr, 1, 0.2, 0.2, 0.6);
  cairo_move_to(cr, x, y);
  cairo_curve_to(cr, x1, y1, x2, y2, x3, y3);

  cairo_set_line_width(cr, 10.0);
  cairo_stroke(cr);

  cairo_set_line_width(cr, 6.0);
  cairo_move_to(cr, x, y);
  cairo_line_to(cr, x1, y1);
  cairo_move_to(cr, x2, y2);
  cairo_line_to(cr, x3, y3);
  cairo_stroke(cr);

  cairo_surface_flush(img);
  cairo_destroy(cr);
  cairo_surface_write_to_png(img, "image.png");
  cairo_surface_destroy(img);

  return 0;
}
