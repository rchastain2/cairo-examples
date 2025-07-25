
' http://www.informatik.uni-kiel.de/~sb/WissRech/cairo3_recursion.c

#include once "cairo\cairo.bi"

sub snowflake_arm(byval cr as cairo_t ptr, byval l as integer)
  cairo_move_to(cr, 0.0, 0.0)
  cairo_line_to(cr, 0.0, 0.5)
  cairo_stroke(cr)

  if l > 0 then
    cairo_save(cr)

    cairo_translate(cr, 0.0, 0.5)
    cairo_scale(cr, 0.45, 0.45)

    snowflake_arm(cr, l - 1)

    cairo_rotate(cr, 1.2)
    snowflake_arm(cr, l - 1)

    cairo_rotate(cr, -2.4)
    snowflake_arm(cr, l - 1)

    cairo_restore(cr)
  end if
end sub

const PI = 4 * atn(1)
const ZOOM = 3

dim as cairo_surface_t ptr surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, ZOOM * 400, ZOOM * 80)
dim as cairo_t ptr cr = cairo_create(surface)

cairo_set_source_rgba(cr, 1, 1, 1, 1)
cairo_paint(cr)

cairo_set_source_rgba(cr, 0, 0, 0, 1)

for l as integer = 0 to 4
  cairo_save(cr)
  cairo_translate(cr, ZOOM * 40.0 + l * ZOOM * 80.0, ZOOM * 40.0)
  cairo_scale(cr, ZOOM * 40.0, ZOOM * 40.0)
  cairo_set_line_width(cr, 0.01)

  for i as integer = 0 to 4
    cairo_save(cr)
    cairo_rotate(cr, 2.0 * PI * i / 5)
    snowflake_arm(cr, l)
    cairo_restore(cr)
  next i
  
  cairo_restore(cr)
next l

cairo_surface_write_to_png(surface, "snowflake.png")
  
cairo_destroy(cr)
cairo_surface_destroy(surface)
