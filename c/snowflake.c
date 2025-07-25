
/* http://www.informatik.uni-kiel.de/~sb/WissRech/cairo3_recursion.c */

/* ============================================================
   cairo3_recursion.c
   Written 2011 by Steffen Boerm, all rights reserved.
   ============================================================ */

#include <cairo/cairo.h>
#include <cairo/cairo-pdf.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

static void snowflake_arm(cairo_t* cr, int l)
{
  cairo_move_to(cr, 0.0, 0.0);
  cairo_line_to(cr, 0.0, 0.5);
  cairo_stroke(cr);

  if (l > 0)
  {
    cairo_save(cr);

    cairo_translate(cr, 0.0, 0.5);
    cairo_scale(cr, 0.45, 0.45);

    snowflake_arm(cr, l - 1);

    cairo_rotate(cr, 1.2);
    snowflake_arm(cr, l - 1);

    cairo_rotate(cr, -2.4);
    snowflake_arm(cr, l - 1);

    cairo_restore(cr);
  }
}

int
main()
{
  cairo_surface_t* surface;
  cairo_t* cr;
  int i, l;

  surface = cairo_pdf_surface_create("image.pdf", 400.0, 80.0);

  cr = cairo_create(surface);
  cairo_surface_destroy(surface);

  for (l = 0; l < 5; l++)
  {
    cairo_save(cr);
    cairo_translate(cr, 40.0 + l * 80.0, 40.0);
    cairo_scale(cr, 40.0, 40.0);
    cairo_set_line_width(cr, 0.01);

    for (i = 0; i < 5; i++)
    {
      cairo_save(cr);
      cairo_rotate(cr, 2.0 * M_PI * i / 5);
      snowflake_arm(cr, l);
      cairo_restore(cr);
    }

    cairo_restore(cr);
  }

  cairo_destroy(cr);

  return 0;
}
