
' https://www.cairographics.org/operators/

#include once "cairo\cairo.bi"

const PI = 4 * atn(1)
const SCREEN_W = 7 * 50
const SCREEN_H = 6 * 50

dim as cairo_surface_t ptr surface1 = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SCREEN_W, SCREEN_H), surface2

dim as cairo_t ptr c = cairo_create(surface1)

cairo_set_source_rgb(c, 0, 0, 1)
cairo_paint(c)

cairo_set_source_rgb(c, 0, 0, 0.8)
cairo_set_line_width(c, 4)

for x as integer = 1 to 7
  for y as integer = 1 to 6
    'cairo_arc(c, 50 * x - 25, 50 * y - 25, 20, 0, 2 * PI)
    'cairo_stroke(c)
  next
next

surface2 = cairo_image_surface_create_from_png("image1.png")

cairo_set_operator(c, CAIRO_OPERATOR_DEST_IN)
cairo_set_source_surface(c, surface2, 0, 0)
cairo_paint(c)

cairo_destroy(c)

cairo_surface_write_to_png(surface1, "image2.png")

cairo_surface_destroy(surface1)
cairo_surface_destroy(surface2)
