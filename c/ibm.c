
/* http://www.ibm.com/developerworks/library/l-cairo/index.html */

#include <cairo/cairo.h>
#include <cairo/cairo-pdf.h>
#include <cairo/cairo-ps.h>
#include <cairo/cairo-svg.h>
#include <math.h>
#include <string.h>

#define WIDTH 800
#define HEIGHT 600
#define STRIDE WIDTH*4
#define MAX_COORDS 1024

static void travel_path(cairo_t* cr)
{
  int pen_radius = 10;
  cairo_set_source_rgb(cr, 1, 1, 1);
  cairo_paint(cr);
  cairo_set_line_width(cr, pen_radius * 2);
  cairo_set_source_rgba(cr, .3, .42, .69, 1);
  cairo_move_to(cr, 10, 10);
  cairo_line_to(cr, 160, 10);
  cairo_move_to(cr, 10, 40);
  cairo_line_to(cr, 160, 40);
  cairo_move_to(cr, 60, 70);
  cairo_line_to(cr, 110, 70);
  cairo_move_to(cr, 60, 100);
  cairo_line_to(cr, 110, 100);
  cairo_move_to(cr, 60, 130);
  cairo_line_to(cr, 110, 130);
  cairo_move_to(cr, 60, 160);
  cairo_line_to(cr, 110, 160);
  cairo_move_to(cr, 10, 190);
  cairo_line_to(cr, 160, 190);
  cairo_move_to(cr, 10, 220);
  cairo_line_to(cr, 160, 220);
  cairo_move_to(cr, 170, 10);
  cairo_line_to(cr, 340, 10);
  cairo_move_to(cr, 170, 40);
  cairo_line_to(cr, 360, 40);
  cairo_move_to(cr, 200, 70);
  cairo_line_to(cr, 250, 70);
  cairo_move_to(cr, 300, 70);
  cairo_line_to(cr, 360, 70);
  cairo_move_to(cr, 210, 100);
  cairo_line_to(cr, 350, 100);
  cairo_move_to(cr, 210, 130);
  cairo_line_to(cr, 350, 130);
  cairo_move_to(cr, 200, 160);
  cairo_line_to(cr, 250, 160);
  cairo_move_to(cr, 300, 160);
  cairo_line_to(cr, 360, 160);
  cairo_move_to(cr, 170, 190);
  cairo_line_to(cr, 360, 190);
  cairo_move_to(cr, 170, 220);
  cairo_line_to(cr, 340, 220);
  cairo_move_to(cr, 370, 10);
  cairo_line_to(cr, 470, 10);
  cairo_move_to(cr, 560, 10);
  cairo_line_to(cr, 660, 10);
  cairo_move_to(cr, 370, 40);
  cairo_line_to(cr, 490, 40);
  cairo_move_to(cr, 540, 40);
  cairo_line_to(cr, 660, 40);
  cairo_move_to(cr, 400, 70);
  cairo_line_to(cr, 510, 70);
  cairo_move_to(cr, 520, 70);
  cairo_line_to(cr, 630, 70);
  cairo_move_to(cr, 400, 100);
  cairo_line_to(cr, 630, 100);
  cairo_move_to(cr, 400, 130);
  cairo_line_to(cr, 470, 130);
  cairo_move_to(cr, 480, 130);
  cairo_line_to(cr, 550, 130);
  cairo_move_to(cr, 560, 130);
  cairo_line_to(cr, 630, 130);
  cairo_move_to(cr, 400, 160);
  cairo_line_to(cr, 470, 160);
  cairo_move_to(cr, 490, 160);
  cairo_line_to(cr, 540, 160);
  cairo_move_to(cr, 560, 160);
  cairo_line_to(cr, 630, 160);
  cairo_move_to(cr, 370, 190);
  cairo_line_to(cr, 470, 190);
  cairo_move_to(cr, 500, 190);
  cairo_line_to(cr, 530, 190);
  cairo_move_to(cr, 560, 190);
  cairo_line_to(cr, 660, 190);
  cairo_move_to(cr, 370, 220);
  cairo_line_to(cr, 470, 220);
  cairo_move_to(cr, 510, 220);
  cairo_line_to(cr, 520, 220);
  cairo_move_to(cr, 560, 220);
  cairo_line_to(cr, 660, 220);
  cairo_stroke(cr);
  cairo_set_line_width(cr, pen_radius * .5);
  cairo_move_to(cr, 710, 200);
  double angle1 = 0 * (M_PI / 180.0);
  double angle2 = 360 * (M_PI / 180.0);
  cairo_set_source_rgba(cr, 0, 0, 0, 1);
  cairo_arc(cr, 710, 200, 20, angle1, angle2);
  cairo_stroke(cr);
  cairo_set_source_rgba(cr, 1, 1, 1, 1);
  cairo_arc(cr, 710, 200, 20, angle1, angle2);
  cairo_fill(cr);
  cairo_move_to(cr, 695, 212);
  cairo_set_source_rgba(cr, 0, 0, 0, 1);
  cairo_select_font_face(cr, "Sans", CAIRO_FONT_SLANT_NORMAL,
                         CAIRO_FONT_WEIGHT_BOLD);
  cairo_set_font_size(cr, 40);
  cairo_show_text(cr, "R");
  cairo_stroke(cr);
}

static void draw(cairo_surface_t* surface)
{
  cairo_t* cr;
  cr = cairo_create(surface);
  travel_path(cr);
  cairo_destroy(cr);
}

int main(int argc, char** argv)
{
  cairo_surface_t* surface;

  surface = cairo_pdf_surface_create("image.pdf",
                                     WIDTH, HEIGHT);
  draw(surface);
  cairo_surface_destroy(surface);

  surface = cairo_ps_surface_create("image.ps",
                                    WIDTH, HEIGHT);
  draw(surface);
  cairo_surface_destroy(surface);

  surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32,
                                       WIDTH, HEIGHT);
  draw(surface);
  cairo_surface_write_to_png(surface, "image.png");
  cairo_surface_destroy(surface);

  surface = cairo_svg_surface_create("image.svg",
                                     WIDTH, HEIGHT);
  draw(surface);
  cairo_surface_destroy(surface);

  return 0;
}
