
' Pythagoras tree

#include "cairo/cairo.bi"

const PI = 4 * atn(1)

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
  dim s2 as double
  if n > 0 then
    s2 = s1 / sqr(2)
    draw_branch(c, x1,      y1, -PI / 4,   0, -s2, s2, n)
    draw_branch(c, x1 + s1, y1,  PI / 4, -s2, -s2, s2, n)
  end if
end sub

const SURFACE_WIDTH = 900
const SURFACE_HEIGHT = 2 * SURFACE_WIDTH \ 3
const SQUARE_SIZE = SURFACE_HEIGHT \ 4
const as double X = (SURFACE_WIDTH - SQUARE_SIZE) / 2
const as double Y = SURFACE_HEIGHT - SQUARE_SIZE

screenres(SURFACE_WIDTH, SURFACE_HEIGHT, 32)
windowtitle("Pythagoras Tree")
color(0, &hFFFFFF)
cls

#define BYTES_PER_PIXEL 4

dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data( _
  screenptr(), _
  CAIRO_FORMAT_ARGB32, _
  SURFACE_WIDTH, _
  SURFACE_HEIGHT, _
  SURFACE_WIDTH * BYTES_PER_PIXEL _
)
dim as cairo_t ptr context = cairo_create(surface)

screenlock()

cairo_set_source_rgba(context, 0, 0, 1, 0.6)

cairo_rectangle(context, X, Y, SQUARE_SIZE, SQUARE_SIZE)
cairo_fill(context)

draw_branches(context, x, y, SQUARE_SIZE, 4)

screenunlock()

cairo_destroy(context)
cairo_surface_destroy(surface)

sleep
