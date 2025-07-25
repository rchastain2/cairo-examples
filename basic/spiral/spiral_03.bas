
#include once "cairo/cairo.bi"

const WINDOW_W = 480
const WINDOW_H = 480

screenres WINDOW_W, WINDOW_H, 32

line (0, 0)-(WINDOW_W, WINDOW_H), rgb(192, 192, 192), BF

const IMAGE_W = 464
const IMAGE_H = 464

dim as any ptr image = imagecreate(IMAGE_W, IMAGE_H)
dim as any ptr pixels

imageinfo(image, IMAGE_W, IMAGE_H,,, pixels)

dim as long stride = cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, IMAGE_W) ' https://www.freebasic.net/forum/viewtopic.php?p=215065#p215065
dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data(pixels, CAIRO_FORMAT_ARGB32, IMAGE_W, IMAGE_H, stride)

dim as cairo_t ptr context = cairo_create(surface)

const POINT_NUM = 180
const PI = 3.1415926535897932

sub DrawSpiral(surface as cairo_surface_t ptr, context as cairo_t ptr, angle_diff as double)
	cairo_set_source_rgb(context, 1, 1, 1)
	cairo_paint(context)
	cairo_set_source_rgb(context, 0, 0, 0)
  
	const POINT_RAD = 3
	const RADIUS_MAX = 216
	const CX = IMAGE_W \ 2
	const CY = IMAGE_H \ 2

	dim as double x, y
	dim as double angle = 0
	dim as double radius = 0
	dim as double radius_diff = RADIUS_MAX / POINT_NUM

	for i as integer = 1 to POINT_NUM
	  x = radius * cos(angle) + CX
	  y = radius * sin(angle) + CY
	  
	  cairo_arc(context, x, y, POINT_RAD, 0, 2 * PI)
	  cairo_fill(context)
	  
	  angle += angle_diff
	  radius += radius_diff
	next i
end sub

dim as double angle_diff = 0

const ANGLE_DIFF_DIFF = (PI / 180) / POINT_NUM
const DELAY = 10

do
  DrawSpiral(surface, context, angle_diff)
  screenlock()
  put (8, 8), image, PSET
  screenunlock()
  angle_diff += ANGLE_DIFF_DIFF
  sleep(DELAY)
loop until len(inkey)

cairo_destroy(context)
cairo_surface_destroy(surface)

imagedestroy image

sleep
