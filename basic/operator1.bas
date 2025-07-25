
' https://www.cairographics.org/operators/

#include once "cairo\cairo.bi"

const SCREEN_W = 200
const SCREEN_H = 200

dim as cairo_surface_t ptr surface1 = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SCREEN_W, SCREEN_H), surface2

dim as cairo_t ptr c = cairo_create(surface1)

cairo_scale(c, SCREEN_W, SCREEN_H)
cairo_set_source_rgba(c, 0, 0, 1, 1)
cairo_paint(c)

cairo_set_line_cap(c, CAIRO_LINE_CAP_ROUND)
cairo_set_line_width(c, 1 / 50)
cairo_set_source_rgba(c, 1, 0, 0, 1)
cairo_move_to(c, 0.0, 0.0)
cairo_line_to(c, 1.0, 1.0)
cairo_stroke(c)
  
cairo_set_operator(c, CAIRO_OPERATOR_DEST_IN)
surface2 = cairo_image_surface_create_from_png("mask.png")
cairo_scale(c, 1/SCREEN_W, 1/SCREEN_H)

cairo_set_source_surface(c, surface2, 0, 0)
cairo_paint(c)

cairo_destroy(c)

cairo_surface_write_to_png(surface1, "image.png")

cairo_surface_destroy(surface1)
cairo_surface_destroy(surface2)
