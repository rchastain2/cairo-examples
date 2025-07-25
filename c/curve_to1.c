
#include <cairo/cairo.h>

int main(void)
{
  cairo_surface_t* img = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 400 + 2 * 10, 400 + 2 * 10);
  cairo_t* cr = cairo_create(img);

  cairo_set_source_rgba(cr, 1, 1, 1, 1);
  cairo_paint(cr);

  cairo_translate(cr, 10, 10);

  cairo_set_source_rgba(cr, 0, 0, 0, 1);

  cairo_set_line_width(cr, 6);
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);

  cairo_move_to(cr, 0, 0);
  cairo_curve_to(cr, 400, 0, 400, 400, 0, 400);
  cairo_stroke(cr);

  cairo_surface_flush(img);
  cairo_destroy(cr);
  cairo_surface_write_to_png(img, "image.png");
  cairo_surface_destroy(img);

  return 0;
}
