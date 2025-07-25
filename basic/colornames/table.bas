
' https://math.ubbcluj.ro/~sberinde/wingraph/main.html

#include once "cairo/cairo.bi"

#define CAIROCOLOR(c) (c and &hFF0000) / &hFF0000, (c and &h00FF00) / &h00FF00, (c and &h0000FF) / &h0000FF

dim colors(255) as long
dim names(255) as string
dim idx as integer

' ======================================================================

dim f as integer
dim s as string
dim p as integer

f = freefile
open "colornames.bi" for input as #f
do until eof(f)
  input #f, s
  if mid(s, 1, 7) = "#define" then
    p = instr(s, "&")
    colors(idx) = valint(mid(s, p))
    names(idx) = mid(s, 9, p - 10)
    idx += 1
  end if
loop
close #f

' ======================================================================

const screen_w = 1024
const screen_h = 768

screenres screen_w, screen_h, 32
windowtitle "Color Table"

dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data(screenptr(), _
       CAIRO_FORMAT_ARGB32, screen_w, screen_h, screen_w * 4)
     
dim as cairo_t ptr canvas = cairo_create(surface)

cairo_translate(canvas, 12, 20)

dim as integer x, y

screenlock

for idx = 0 to 255
  cairo_set_source_rgb(canvas, CAIROCOLOR(colors(idx)))
  x = 200 * (idx \ 52)
  y = 14 * (idx mod 52)
  cairo_rectangle(canvas, x, y, 50, 14 - 2)
  cairo_fill(canvas)
  cairo_set_source_rgb(canvas, 1, 1, 1)
  cairo_move_to(canvas, x + 50 + 4, y + 14 - 4)
  cairo_show_text(canvas, names(idx))
next idx

screenunlock

cairo_destroy(canvas)

sleep
