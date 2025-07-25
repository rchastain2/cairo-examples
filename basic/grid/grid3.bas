
' https://www.cairographics.org/operators/

#include once "cairo\cairo.bi"

const PI = 4 * atn(1)
const SCREEN_W = 7 * 50
const SCREEN_H = 6 * 50

dim as cairo_surface_t ptr surface1 = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SCREEN_W, SCREEN_H), surface2

dim as cairo_t ptr c = cairo_create(surface1)

var x = 1
var y = 1.5

cairo_arc(c, 50 * x - 25, 50 * y - 25, 20, 0, 2 * PI)
cairo_set_source_rgb(c, 1, 0, 0)
cairo_fill_preserve(c)
cairo_set_line_width(c, 4)
cairo_set_source_rgb(c, 0.8, 0, 0)
cairo_stroke(c)

surface2 = cairo_image_surface_create_from_png("image2.png")

cairo_set_source_surface(c, surface2, 0, 0)
cairo_paint(c)

cairo_destroy(c)

cairo_surface_write_to_png(surface1, "image3.png")

cairo_surface_destroy(surface1)
cairo_surface_destroy(surface2)
