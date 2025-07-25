
/* ============================================================
   cairo2_transformation.c
   Written 2011 by Steffen Boerm, all rights reserved.
   ============================================================ */

#include <cairo/cairo.h>
#include <cairo/cairo-pdf.h>

#include <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

int main(void)
{
  cairo_surface_t* surface;
  cairo_t* cr;
  const int n = 1000;
  const int k = 15;
  int i;

  surface = cairo_pdf_surface_create("image.pdf", 400.0, 250.0);

  cr = cairo_create(surface);
  cairo_surface_destroy(surface);

  cairo_translate(cr, 200.0, 125.0);
  cairo_scale(cr, 125.0, 125.0);
  cairo_set_line_width(cr, 0.01);

  cairo_move_to(cr, 0.0, 0.9);

  for (i = 1; i < n; i++)
    cairo_line_to(
      cr,
      0.7 * sin(2.0 * M_PI * i / n) + 0.2 * sin(2.0 * M_PI * i * k / n),
      0.7 * cos(2.0 * M_PI * i / n) + 0.2 * cos(2.0 * M_PI * i * k / n)
    );

  cairo_close_path(cr);
  cairo_stroke(cr);

  cairo_destroy(cr);

  return 0;
}
