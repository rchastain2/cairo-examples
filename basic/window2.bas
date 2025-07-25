
' http://www.freebasic.net/forum/viewtopic.php?p=196719#p196719

#include once "cairo\cairo.bi"

const SCR_W = 595.276
const SCR_H = 841.89

sub build_page(byval cs as cairo_surface_t ptr)
  dim as cairo_t ptr c = cairo_create(cs)
  dim as double x = 50, y = 50, b = SCR_W - 100

  cairo_rectangle(c, 0.0, 0.0, SCR_W, SCR_H)
  cairo_set_source_rgb(c, 1.0, 1.0, 1.0)
  cairo_fill(c)

  cairo_set_source_rgb(c, 0.0, 0.0, 0.0)
  cairo_set_line_width(c, 0.5)
  cairo_rectangle(c, x, y + 10, b, SCR_H - 110)
  cairo_stroke(c)

  cairo_show_page(c)
  cairo_destroy(c)
end sub

dim as integer S_W = int(SCR_W) + 1, S_H = int(SCR_H) + 1
screenres S_W, S_H, 32
screenlock
dim as cairo_surface_t ptr cs = _
       cairo_image_surface_create_for_data(screenptr, _
                                           CAIRO_FORMAT_ARGB32, S_W, _
                                           S_H, S_W*4)
build_page(cs)
screenunlock

sleep
