
' https://freebasic.net/forum/viewtopic.php?p=170292#p170292

#define CAIRO_HAS_PNG_FUNCTIONS 1
#include once "cairo\cairo.bi"

#define DIRECTORY_INSTALLATION
#ifdef DIRECTORY_INSTALLATION
#libpath "lib\win32"
#endif

sub draw_img(byval cr as cairo_t ptr, byref aFileName as string, byval x as uinteger, byval y as uinteger)
  var img = cairo_image_surface_create_from_png(aFileName)
  var sta = cairo_surface_status(img)
  if sta = CAIRO_STATUS_SUCCESS then
    cairo_set_source_surface(cr, img, x, y)
    cairo_paint(cr)
  else
    ?"Cannot load " & aFileName & ": " & sta
  end if
  cairo_surface_destroy(img)
end sub

sub draw_page(byval sf as cairo_surface_t ptr)
  var cr = cairo_create(sf)
  draw_img(cr, "horse.png", 0, 0)
  cairo_destroy(cr)
  cairo_surface_flush(sf)
end sub

const SCREEN_W = 450, SCREEN_H = 300

screenres SCREEN_W, SCREEN_H, 32

var sf = cairo_image_surface_create_for_data(screenptr, CAIRO_FORMAT_ARGB32, SCREEN_W, SCREEN_H, SCREEN_W * 4)

screenlock
draw_page(sf)
screenunlock

sleep

if inkey <> chr(27) then
  var sta = cairo_surface_write_to_png(sf, "cairo_png.png")
  if sta <> CAIRO_STATUS_SUCCESS then
    ?"Cannot write png file cairo_png.png: " & sta
  else
    ?"Wrote cairo_png.png file! " & sta
  end if
  sleep
end if

cairo_surface_destroy(sf)
