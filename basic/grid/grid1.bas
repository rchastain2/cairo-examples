
#include once "cairo\cairo.bi"

const PI = 4 * atn(1)
const SCREEN_W = 7 * 50
const SCREEN_H = 6 * 50

dim as cairo_surface_t ptr surface = cairo_image_surface_create(_
  CAIRO_FORMAT_ARGB32,_
  SCREEN_W,_
  SCREEN_H _
)

dim as cairo_t ptr c = cairo_create(surface)

cairo_set_source_rgb(c, 0.5, 0.5, 0.5)
cairo_paint(c)

cairo_set_operator(c, CAIRO_OPERATOR_CLEAR)

for x as integer = 1 to 7
  for y as integer = 1 to 6
    cairo_arc(c, 50 * x - 25, 50 * y - 25, 20, 0, 2 * PI)
    cairo_fill(c)
  next
next

cairo_surface_write_to_png(surface, "image1.png")

cairo_destroy(c)
cairo_surface_destroy(surface)
