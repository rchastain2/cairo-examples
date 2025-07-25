
' Pythagoras tree

#include "cairo/cairo.bi"

function rnd_range(first as double, last as double) as double
  return rnd() * (last - first) + first
end function

const PI = 4 * atn(1)

dim shared as double n1, n2
n1 = sqr(2)
n2 = rnd_range(sqr(2), 2)

declare sub draw_branches( _
  byval c as cairo_t ptr, _
  byref x1 as const double, _
  byref y1 as const double, _
  byref s1 as const double, _
  byref n as const integer _
)

sub draw_branch( _
  byval c as cairo_t ptr, _
  byref x2 as const double, _
  byref y2 as const double, _
  byref a as const double, _
  byref x3 as const double, _
  byref y3 as const double, _
  byref s2 as const double, _
  byref n as const integer _
)
  cairo_save(c)
  cairo_translate(c, x2, y2)
  cairo_rotate(c, a)
  
  cairo_rectangle(c, x3, y3, s2, s2)
  cairo_set_source_rgba(c, 0, 0, 1, 0.6)
  cairo_fill(c)
  
  draw_branches(c, x3, y3, s2, n - 1)
  cairo_restore(c)
end sub

sub draw_branches( _
  byval c as cairo_t ptr, _
  byref x1 as const double, _
  byref y1 as const double, _
  byref s1 as const double, _
  byref n as const integer _
)
  
  dim as double s2, s3, a1, a2
  if n > 0 then
    s2 = s1 / n1
    s3 = s1 / n2
    
    a1 = acos((s2 * s2 + s1 * s1 - s3 * s3) / (2 * s2 * s1))
    a2 = acos((s3 * s3 + s1 * s1 - s2 * s2) / (2 * s3 * s1))
    
    draw_branch(c, x1,      y1, -a1,   0, -s2, s2, n)
    draw_branch(c, x1 + s1, y1,  a2, -s3, -s3, s3, n)
  end if
end sub

const SURFACE_WIDTH = 600
const SURFACE_HEIGHT = 2 * SURFACE_WIDTH \ 3
const SQUARE_SIZE = SURFACE_HEIGHT \ 4
const as double X = (SURFACE_WIDTH - SQUARE_SIZE) / 2
const as double Y = SURFACE_HEIGHT - SQUARE_SIZE

dim as cairo_surface_t ptr surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT)
dim as cairo_t ptr context = cairo_create(surface)

cairo_set_source_rgba(context, 0, 0, 1, 0.6)

cairo_rectangle(context, X, Y, SQUARE_SIZE, SQUARE_SIZE)
cairo_fill(context)

randomize()
draw_branches(context, x, y, SQUARE_SIZE, 8)

cairo_destroy(context)
cairo_surface_write_to_png(surface, "image.png")
cairo_surface_destroy(surface)
