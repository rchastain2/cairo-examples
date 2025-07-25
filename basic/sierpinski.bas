
' Sierpinski triangle by Kristopher Windsor
' https://www.freebasic.net/forum/viewtopic.php?f=7&t=13060
' Cairo version by Roland Chastain
' https://www.freebasic.net/forum/viewtopic.php?p=215065#p215065

#include once "cairo/cairo.bi"

sub Triangle(byval cr as cairo_t ptr, x1 as double, y1 as double, x2 as double, y2 as double, x3 as double, y3 as double)

  #define factor .5

  #macro scale(x1, y1, x2, y2, x3, y3)
    scope
      dim as integer nx1, ny1, nx2, ny2, nx3, ny3
      nx1 = x1
      ny1 = y1
      nx2 = (x2 - x1) * factor + x1
      ny2 = (y2 - y1) * factor + y1
      nx3 = (x3 - x1) * factor + x1
      ny3 = (y3 - y1) * factor + y1
      Triangle(cr, nx1, ny1, nx2, ny2, nx3, ny3)
    end scope
  #endmacro

  #macro add(x, y)
    x1 += x
    x2 += x
    x3 += x
    y1 += y
    y2 += y
    y3 += y
  #endmacro

  static as integer depth

  depth += 1

  cairo_move_to(cr, x1, y1)
  cairo_line_to(cr, x2, y2)
  cairo_line_to(cr, x3, y3)
  cairo_line_to(cr, x1, y1)
  cairo_stroke(cr)

  if depth < 8 then
    scale(x1, y1, x2, y2, x3, y3)
    scale(x2, y2, x3, y3, x1, y1)
    scale(x3, y3, x1, y1, x2, y2)
  end if

  depth -= 1
end sub

const SCREEN_W = 800
const SCREEN_H = 600

screenres(SCREEN_W, SCREEN_H, 32)

'dim as long stride = cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, SCREEN_W)

#define BYTES_PER_PIXEL 4
dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data( _
  screenptr(), _
  CAIRO_FORMAT_ARGB32, _
  SCREEN_W, _
  SCREEN_H, _
  SCREEN_W * BYTES_PER_PIXEL _
)
'  stride _
')

dim as cairo_t ptr cr = cairo_create(surface)

screenlock()

cairo_set_source_rgb(cr, 1, 1, 1)
cairo_paint(cr)

cairo_set_source_rgb(cr, 0, 0, 0)
cairo_set_line_width(cr, 1 / 4)

Triangle(cr, 400, 0, 0, 599, 799, 599)

screenunlock()

cairo_surface_write_to_png(surface, "sierpinski.png")

cairo_destroy(cr)

sleep()
