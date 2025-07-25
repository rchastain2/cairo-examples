
#include once "cairo/cairo.bi"

const SCREEN_W = 400
const SCREEN_H = 300

#define BYTES_PER_PIXEL 4

screenres SCREEN_W, SCREEN_H, 32

dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data(screenptr(), CAIRO_FORMAT_ARGB32, SCREEN_W, SCREEN_H, SCREEN_W * BYTES_PER_PIXEL)
dim as cairo_t ptr c = cairo_create(surface)

screenlock()

cairo_set_source_rgba(c, 1, 1, 1, 1)
cairo_paint(c)

cairo_set_line_width(c, 1)
cairo_set_source_rgba(c, 1, 0, 0, 1)
cairo_move_to(c, 0, 0)
cairo_line_to(c, SCREEN_W - 1, SCREEN_H - 1)
cairo_stroke(c)

screenunlock()

cairo_destroy(c)
cairo_surface_destroy(surface)

sleep
