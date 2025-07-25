
' Cairo example by TJF
' https://www.freebasic.net/forum/viewtopic.php?t=18622

#include once "cairo\cairo.bi"

dim shared as cairo_t ptr cr
const Pi = 3.141592653589793

sub Elipsa(A as double, B as double, X0 as double, Y0 as double, Kut as double, Boja as integer)
  ' A, B   -> Horizontal and vertical radius of the ellipse (for ellipse at an angle 0)
  ' X0, Y0 -> The coordinates of the center of the ellipse
  ' Kut    -> The angle of the ellipse in radians  (angle in radians = angle in degrees * pi / 180)
  ' Boja   -> Numerical value of the color of the ellipse
  cairo_new_path(cr)
  cairo_save(cr)
  cairo_translate(cr, X0, Y0)
  cairo_rotate(cr, Kut)
  cairo_scale(cr, A, B)
  cairo_arc(cr, 0.0, 0.0, 1.0, 0.0, 2.0 * Pi)
  cairo_restore(cr)
  cairo_stroke(cr)
end sub

' ============== Main program =============================

const S_W = 800
const S_H = 600

screenres S_W, S_H, 32

var cs = cairo_image_surface_create_for_data(_
  screenptr, _
  CAIRO_FORMAT_ARGB32, _
  S_W, _
  S_H, _
  S_W * 4) ' * len(integer))

screenlock
cr = cairo_create(cs)

cairo_set_source_rgb(cr, 1.0, 1.0, 0.0)
var i = 0
for i = 0 to 5
  Elipsa(100, 30, 200 + cos(i * pi/6), 150 + cos(i * pi/6), i * Pi/6, 15)
next

cairo_set_line_width(cr, 5.0)
Elipsa(50, 20, 500 + cos(i * pi/6), 150 + cos(i * pi/6), Pi/4, 2)
Elipsa(50, 20, 500 + cos(i * pi/6), 150 + cos(i * pi/6), 3 * Pi/4, 2)

cairo_set_line_width(cr, 1.0)
cairo_set_source_rgb(cr, 1.0, 0.0, 0.0)
for i = 0 to 11
  Elipsa(100, 70, 500 + cos(i * pi/12), 150 + cos(i * pi/12), i * Pi/12, 8)
next

cairo_set_source_rgb(cr, 0.0, 1.0, 0.0)
for i = 0 to 11
  Elipsa(100, 20, 500 + cos(i * pi/12), 450 + cos(i * pi/12), i * Pi/12, 4)
next

cairo_set_line_width(cr, 0.5)
cairo_set_source_rgb(cr, 0.0, 1.0, 1.0)
for i = 0 to 2
  Elipsa(100, 30, 200 + cos(i * pi/3), 450 + cos(i * pi/3), i * Pi/3, 9)
next

cairo_destroy(cr)
cairo_surface_flush(cs)
screenunlock

cairo_surface_destroy(cs)
sleep
