' textshake.bas

' FreeBASIC cairo example
' created by lizard

#include once "cairo\cairo.bi"

const SCREEN_W = 400
const SCREEN_H = 250

screenres SCREEN_W, SCREEN_H, 32

' Create a cairo drawing context, using the FB screen as surface 

dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data(screenptr(), _
      CAIRO_FORMAT_ARGB32, SCREEN_W, SCREEN_H, SCREEN_W * 4)
     
dim as cairo_t ptr canvas = cairo_create(surface)

dim as string shake(...) = {chr(34) & "To be, or not to be, that is the question:", _
"Whether 'tis nobler in the mind to suffer", "The slings and arrows of outrageous fortune,", _
"Or to take arms against a sea of troubles", "And by opposing end them. To die - to sleep..." _
& chr(34), "", "(William Shakespeare)"}   

screenlock()

  ' draw the entire context white
  cairo_set_source_rgba(canvas, 1, 1, 1, 1)
  cairo_paint(canvas)

  ' text color, font and size
  cairo_set_source_rgb(canvas, 0.1, 0.1, 0.1)
  cairo_select_font_face(canvas, "Times", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
  cairo_set_font_size(canvas, 16)
 
  ' draw text
  for i as short = 0 to ubound(shake)
    cairo_move_to(canvas, 20, 30 + i * 30)
    cairo_show_text(canvas, shake(i))
  next i

screenunlock()

' Clean up the cairo context
cairo_destroy(canvas)

sleep