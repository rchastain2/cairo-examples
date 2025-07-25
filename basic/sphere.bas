' https://www.freebasic.net/forum/viewtopic.php?p=246885#p246885

' Translated from the C example written by Øyvind Kolås

#include once "cairo/cairo.bi"

const SCREEN_W = 256
const SCREEN_H = 256

const M_PI = 4 * atn(1)

screenres SCREEN_W, SCREEN_H, 32

dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data(screenptr(), _
      CAIRO_FORMAT_ARGB32, SCREEN_W, SCREEN_H, SCREEN_W * 4 )

dim as cairo_t ptr cr = cairo_create(surface)

screenlock()

dim as cairo_pattern_t ptr pat

pat = cairo_pattern_create_linear (0.0, 0.0,  0.0, 256.0)
cairo_pattern_add_color_stop_rgba (pat, 1, 0, 0, 0, 1)
cairo_pattern_add_color_stop_rgba (pat, 0, 1, 1, 1, 1)
cairo_rectangle (cr, 0, 0, 256, 256)
cairo_set_source (cr, pat)
cairo_fill (cr)
cairo_pattern_destroy (pat)

pat = cairo_pattern_create_radial (115.2, 102.4, 25.6, 102.4,  102.4, 128.0)
cairo_pattern_add_color_stop_rgba (pat, 0, 1, 1, 1, 1)
cairo_pattern_add_color_stop_rgba (pat, 1, 0, 0, 0, 1)
cairo_set_source (cr, pat)
cairo_arc (cr, 128.0, 128.0, 76.8, 0, 2 * M_PI)
cairo_fill (cr)
cairo_pattern_destroy (pat)

screenunlock()

sleep

cairo_destroy(cr)
