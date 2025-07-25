' cairo_text_gradient.bas

' Translated after the C example from here
' http://zetcode.com/gfx/cairo/cairotext/

#include once "cairo/cairo.bi"

const SCREEN_W = 350
const SCREEN_H = 110

screenres SCREEN_W, SCREEN_H, 32

' Create a cairo drawing context, using the FB screen as surface.
dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data(screenptr(), _
      CAIRO_FORMAT_ARGB32, SCREEN_W, SCREEN_H, SCREEN_W * 4 )

dim as cairo_t ptr cr = cairo_create(surface)
dim as cairo_pattern_t ptr pat
dim as long h = 100
 
screenlock

 ' draw the entire context green
  cairo_set_source_rgb(cr, 0.2, 0.8, 0.5)
  cairo_paint(cr)

  cairo_select_font_face(cr, "Georgia", CAIRO_FONT_SLANT_ITALIC, CAIRO_FONT_WEIGHT_BOLD)
  cairo_set_font_size(cr, h)
 
  pat = cairo_pattern_create_linear(0, 15, 0, h*0.8)
  cairo_pattern_set_extend(pat, CAIRO_EXTEND_REPEAT)
  cairo_pattern_add_color_stop_rgb(pat, 0.0, 1, 0.9, 0)
  cairo_pattern_add_color_stop_rgb(pat, 0.5, 1, 0.1, 0)
                 
  cairo_move_to(cr, 20, 90)
  cairo_text_path(cr, "Cairo")
  cairo_set_source(cr, pat)
  cairo_fill(cr)

screenunlock

' Clean up the cairo context
cairo_destroy(cr)

sleep