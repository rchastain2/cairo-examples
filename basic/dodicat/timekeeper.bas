
' https://www.freebasic.net/forum/viewtopic.php?p=246912#p246912

#include "vbcompat.bi"
#include once "cairo\cairo.bi"

#macro c_line(cr, x1, y1, x2, y2, thickness, colour, cap_round)
cairo_set_line_width(cr, (thickness))
cairo_set_source_rgba colour
cairo_move_to(cr, (x1), (y1))
cairo_line_to(cr, (x2), (y2))
if cap_round then
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
else
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_SQUARE)
end if
cairo_stroke(cr)
#endmacro

#macro c_circle(cr, cx, cy, radius, start, finish, thickness, colour, cap_round)
cairo_set_line_width(cr, (thickness))
cairo_set_source_rgba colour
cairo_arc(cr, (cx), (cy), (radius), (start), (finish))
if cap_round then
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
else
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_SQUARE)
end if
cairo_stroke(cr)
#endmacro

#macro c_rectangle(cr, x, y, widz, high, thickness, colour)
cairo_set_line_width(cr, (thickness))
cairo_set_source_rgba colour
cairo_move_to(cr, (x), (y))
cairo_rectangle(cr, (x), (y), (widz), (high))
cairo_stroke(cr)
#endmacro

#macro SetBackgroundColour(colour)
cairo_set_source_rgba colour
cairo_paint(g_cairo)
#endmacro

#macro InitFonts(cr)
dim shared as cairo_font_extents_t _fonts
cairo_font_extents(cr, @_fonts)
dim shared as cairo_text_extents_t _text
#endmacro

#macro c_print(cr, x, y, text, size, colour)
cairo_set_font_size(cr, (size))
cairo_text_extents(cr, text, @_text)
'cairo_move_to(cr, (x) - (_text.width / 2 + _text.x_bearing), (y) + (_text.height / 2) - _fonts.descent)
cairo_move_to(cr, (x), (y))
cairo_set_source_rgba colour
cairo_show_text(cr, text)
cairo_stroke(cr)
#endmacro

function setscreen(xres as integer, yres as integer) as cairo_t ptr
  screenres xres, yres, 32
  var surface = cairo_image_surface_create_for_data(screenptr(), CAIRO_FORMAT_ARGB32, xres, yres, xres * 4)
  return cairo_create(surface)
end function

const pi = 4 * atn(1)

dim as cairo_t ptr g_cairo = setscreen(800, 600)

SetBackgroundColour((g_cairo, 0, 155/255, 1, 255))

InitFonts(g_cairo)

sub circles(cr as cairo_t ptr, numballs as long, OutsideRadius as long, cx as long, cy as long, c as ulong, n as long, md as long)
  dim as double r, bigr, num, x, y, k=OutsideRadius
  dim as ulong clr
  #define rad *pi/180
  #define zcol(c, n) (cast(ubyte ptr, @c)[n])/255
  dim as long counter
  num= (45*(2*numballs-4)/numballs) rad
  num=cos(num)
  r=num/(1+num)
  bigr=((1-r))*k
  r=(r)*k -1
  for z as double=0 -pi/2 to 2*pi -pi/2 step 2*pi/numballs
    counter+=1
    x=cx+bigr*cos(z)
    y=cy+bigr*sin(z)
    if counter>numballs or counter>n+1  then exit for
    if (counter-1) mod md=0 then clr=c+rgba(50, 50, 200, 255) else clr=c
    c_circle(cr, x, y, r/2, 0, 2*pi, r, (cr, zcol(clr, 2), zcol(clr, 1), zcol(clr, 0), zcol(clr, 3)), 1)
    var g=right("0"+str(counter-1), 2)
    var l=len(str((counter-1)))
    if md<>3 then
      c_print(cr, (x-8), (y+8), g, 15, (cr, 0, 0, 0, 1))
    else
      c_print(cr, (x-6*l), (y+12), str(counter-1), 25, (cr, .5, 0, 0, 1))
    end if
  next z
end sub

function F(t as long, byref z as long=0) as long
  t=t mod 12
  if t=12 then t=1
  z=t
  if  z < 12 then return 12 else return 1
end function

dim as long z
dim as string dt

windowtitle "Cairo clock"

do
  dt= format( now, "dd-mmmm-yyyy" )
  
  screenlock
  SetBackgroundColour((g_cairo, 0, .5, 1, 1))
  c_rectangle(g_cairo, 5, 70, 150, 25, 3, (g_cairo, .3, 0, 0, 2))
  c_print(g_cairo, 10, 90, "Version "& *Cairo_version_string, 15, (g_cairo, 0, 0, 0, 1))
  c_circle(g_cairo, 400, 300, 300, 0, (2*pi), 2, (g_cairo, .2, .2, .2, 1), 0)
  c_print(g_cairo, (400-4*len(dt)), 294, dt, 20, (g_cairo, 0, 0, 0, 1))
  c_line(g_cairo, (400-4*len(dt)), 300, 400+4*len(dt)*1.7, 300, 5, (g_cairo, 1, 0, 0, .3), 1)
  circles(g_cairo, 60, 290, 400, 300, rgba(255, 150, 0, 255), second(now), 5)
  circles(g_cairo, 60, 250, 400, 300, rgba(250, 250, 250, 255), minute(now), 5)
  circles(g_cairo, F(hour(now), z), 190, 400, 300, rgba(0, 150, 200, 255), z, 3)
  screenunlock
  
  sleep 100
loop until len(inkey)

sleep
