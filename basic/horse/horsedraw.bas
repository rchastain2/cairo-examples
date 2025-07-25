
' https://www.freebasic-portal.de/code-beispiele/grafik-und-fonts/fb-pferd-in-freebasic-zeichen-8.html

#define CAIRO_HAS_PNG_FUNCTIONS 1
#include once "cairo/cairo.bi"

#include "horse.bas"

const SCREEN_W = 450
const SCREEN_H = 300

const CORRECTION_X = 0.428
const CORRECTION_Y = -0.7

screenres SCREEN_W, SCREEN_H, 32

dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data(_
  screenptr(),_
  CAIRO_FORMAT_ARGB32,_
  SCREEN_W,_
  SCREEN_H,_
  SCREEN_W * 4)

dim as cairo_t ptr c = cairo_create(surface)

cairo_scale(c, SCREEN_W / 30, SCREEN_H / 20)
cairo_set_source_rgba(c, 1, 1, 1, 1)
cairo_paint(c)

cairo_set_line_cap(c, CAIRO_LINE_CAP_ROUND)
cairo_set_line_width(c, 1 / 20)
cairo_set_source_rgba(c, 0, 0, 0, 1)

dim i as integer

#macro DrawPolygon(array, fill)
i = lbound(array)
cairo_move_to(c, array(i).x + CORRECTION_X, 20 - (array(i).y + CORRECTION_Y))
i += 1
do
  cairo_line_to(c, array(i).x + CORRECTION_X, 20 - (array(i).y + CORRECTION_Y))
  i += 1
loop while i <= ubound(array)
if not fill then
  cairo_stroke(c)
else
  cairo_fill(c)
end if
#endmacro

screenlock()
DrawPolygon(POINTS1, -1)
DrawPolygon(POINTS2, -1)
screenunlock()

cairo_surface_write_to_png(surface, "horse.png")
  
cairo_destroy(c)

sleep
