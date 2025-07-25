
/* ============================================================
   cairo1_drawing.c
   Written 2011 by Steffen Boerm, all rights reserved.
   ============================================================ */

#include <cairo/cairo.h>
#include <cairo/cairo-pdf.h>

int main(void)
{
  cairo_surface_t* surface;
  cairo_t* cr;
  cairo_path_t* path;
  double dashes[2] = { 4, 6 };

  surface = cairo_pdf_surface_create("image.pdf", 400.0, 250.0);

  cr = cairo_create(surface);
  cairo_surface_destroy(surface);

  cairo_move_to(cr, 10.0, 10.0);
  cairo_line_to(cr, 390.0, 240.0);
  cairo_stroke(cr);

  cairo_move_to(cr, 80.0, 20.0);
  cairo_line_to(cr, 290.0, 160.0);
  cairo_line_to(cr, 330.0, 40.0);
  cairo_close_path(cr);
  cairo_stroke(cr);

  cairo_move_to(cr, 20.0, 230.0);
  cairo_line_to(cr, 80.0, 210.0);
  cairo_line_to(cr, 100.0, 120.0);
  cairo_line_to(cr, 30.0, 100.0);
  cairo_close_path(cr);
  cairo_fill(cr);

  cairo_move_to(cr, 150.0, 50.0);
  cairo_line_to(cr, 250.0, 110.0);
  cairo_line_to(cr, 270.0, 40.0);
  cairo_close_path(cr);
  path = cairo_copy_path(cr);
  cairo_set_source_rgb(cr, 1.0, 0.0, 0.0);
  cairo_fill(cr);
  cairo_append_path(cr, path);
  cairo_path_destroy(path);
  cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
  cairo_stroke(cr);

  cairo_move_to(cr, 100.0, 190.0);
  cairo_line_to(cr, 200.0, 220.0);
  cairo_line_to(cr, 110.0, 90.0);
  cairo_close_path(cr);
  cairo_save(cr);
  cairo_set_source_rgb(cr, 0.0, 1.0, 0.0);
  cairo_fill_preserve(cr);
  cairo_restore(cr);
  cairo_save(cr);
  cairo_set_line_width(cr, 0.8);
  cairo_set_dash(cr, dashes, 2, 0.0);
  cairo_stroke(cr);
  cairo_restore(cr);

  cairo_arc(cr, 250.0, 210.0, 20.0, 0.0, 3.141);
  cairo_rectangle(cr, 230.0, 180.0, 40.0, 30.0);
  cairo_move_to(cr, 240.0, 198.0);
  cairo_show_text(cr, "Box");
  cairo_stroke(cr);

  cairo_destroy(cr);

  return 0;
}
