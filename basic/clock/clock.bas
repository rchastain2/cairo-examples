
#include once "cairo/cairo.bi"
#include once "datetime.bi"
#include once "cairocolor.bi"

const SCR_W = 200
const SCR_H = SCR_W

const PI = 3.1415926535

screenres SCR_W, SCR_H, 32

windowtitle "Cairo Clock"

sub cairo_set_source_tcairocolor(cr as cairo_t ptr, color_ as tcairocolor)
  with color_
    cairo_set_source_rgba(cr, .r, .g, .b, .a)
  end with
end sub

sub DrawText(cr as cairo_t ptr, text as string, x as double, y as double, rectangle_color as tcairocolor, text_color as tcairocolor)
' Draw a text in a rectangle
  dim as cairo_text_extents_t e
  dim as double w = cairo_get_line_width(cr)
  cairo_text_extents(cr, text, @e)
  y -= e.y_bearing ' So that y be the top of rectangle
  cairo_save(cr)
' Draw rectangle
  cairo_rectangle(cr, x + e.x_bearing - w, y + e.y_bearing - w, e.width + 2 * w, e.height + 2 * w)
  cairo_set_source_tcairocolor(cr, rectangle_color)
  cairo_fill(cr)
' Draw text
  cairo_move_to(cr, x, y)
  cairo_set_source_tcairocolor(cr, text_color)
  cairo_show_text(cr, text)
  cairo_restore(cr)
end sub

dim as tcairocolor c1 = tcairocolor(&hDEE9FC)
dim as tcairocolor c2 = tcairocolor(&h6395F2)
dim as tcairocolor c3 = tcairocolor(&h1258DC)
dim as tcairocolor c4 = tcairocolor(&h0A337F)
dim as tcairocolor c5 = tcairocolor(&h091834)

' Create background surface

dim as cairo_surface_t ptr bk = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SCR_W, SCR_H)
dim as cairo_t ptr cr = cairo_create(bk)

cairo_set_source_tcairocolor(cr, c1)
cairo_paint(cr)

cairo_scale(cr, SCR_W, SCR_H)
cairo_translate(cr, 0.5, 0.5)
cairo_set_source_tcairocolor(cr, c2)

for n as integer = 0 to 59
  dim as double angle = n * PI / 30
  dim as double radius = iif(n mod 5, 1 / 160, 1 / 80)
  cairo_arc(cr, sin(angle) * 0.45, -1 * cos(angle) * 0.45, radius, 0, PI * 2)
  cairo_fill(cr)
next n

cairo_destroy(cr)

' Create clock image

dim as any ptr image = imagecreate(SCR_W, SCR_H)
dim as any ptr pixels
imageinfo(image, SCR_W, SCR_H,,, pixels)
dim as long stride = cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, SCR_W)
dim as cairo_surface_t ptr sf = cairo_image_surface_create_for_data(pixels, CAIRO_FORMAT_ARGB32, SCR_W, SCR_H, stride)
cr = cairo_create(sf)

cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)

dim as string version = "Cairo " & *cairo_version_string()
  
do
  dim as double minutes = minute(now()) * PI / 30
  dim as double hours   = hour(now())   * PI /  6
  dim as double seconds = second(now()) * PI / 30
  
  cairo_set_source_surface(cr, bk, 0.0, 0.0)
  cairo_paint(cr)
  
  DrawText(cr, version, 2, 2, c1, c2)
  
  cairo_save(cr)
  
  cairo_scale(cr, SCR_W, SCR_H)
  cairo_translate(cr, 0.5, 0.5)
  
  cairo_set_source_tcairocolor(cr, c3)
  cairo_set_line_width(cr, 1 / 24)
  
  cairo_move_to(cr, 0, 0)
  cairo_line_to(cr, sin(hours) * 0.25, -1 * cos(hours) * 0.25)
  cairo_stroke(cr)
  
  cairo_set_source_tcairocolor(cr, c4)
  
  cairo_move_to(cr, 0, 0)
  cairo_line_to(cr, sin(minutes) * 0.35, -1 * cos(minutes) * 0.35)
  cairo_stroke(cr)
  
  cairo_set_source_tcairocolor(cr, c5)
  cairo_set_line_width(cr, 1 / 80)
  
  cairo_move_to(cr, 0, 0)
  cairo_line_to(cr, sin(seconds) * 0.35, -1 * cos(seconds) * 0.35)
  cairo_stroke(cr)
  
  cairo_restore(cr)
  
  screenlock()
  put (0, 0), image, PSET
  screenunlock()

  sleep 100
loop until (len(inkey))

cairo_surface_destroy(bk)

cairo_destroy(cr)
cairo_surface_destroy(sf)
