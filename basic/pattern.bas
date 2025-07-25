
#include once "cairo/cairo.bi"

const M_PI = 4 * atn(1)

const SCREEN_W = 256
const SCREEN_H = 256

screenres SCREEN_W, SCREEN_H, 32

dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data(screenptr(), _
      CAIRO_FORMAT_ARGB32, SCREEN_W, SCREEN_H, SCREEN_W * 4 )

dim as cairo_t ptr cr = cairo_create(surface)

screenlock

cairo_set_source_rgba(cr, 1, 1, 1, 1)
cairo_paint(cr)

cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
dim as long w, h
dim as cairo_surface_t ptr image

dim as cairo_pattern_t ptr pattern
dim as cairo_matrix_t matrix

image = cairo_image_surface_create_from_png ("myown.png")
w = cairo_image_surface_get_width (image)
h = cairo_image_surface_get_height (image)

pattern = cairo_pattern_create_for_surface (image)
cairo_pattern_set_extend (pattern, CAIRO_EXTEND_REPEAT)

cairo_translate (cr, 128.0, 128.0)
cairo_rotate (cr, M_PI / 4)
cairo_scale (cr, 1 / sqr (2), 1 / sqr (2))
cairo_translate (cr, -128.0, -128.0)

cairo_matrix_init_scale (@matrix, w/256.0 * 5.0, h/256.0 * 5.0)
cairo_pattern_set_matrix (pattern, @matrix)

cairo_set_source (cr, pattern)

cairo_rectangle (cr, 0, 0, 256.0, 256.0)
cairo_fill (cr)

cairo_pattern_destroy (pattern)
cairo_surface_destroy (image)

screenunlock

cairo_destroy(cr)

sleep
