
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

cairo_set_source_rgb(context, 1, 1, 1)
cairo_paint(context)
cairo_set_source_rgb(context, 0, 0, 1)
cairo_move_to(context, 8, 8)
cairo_line_to(context, IMAGE_W - 8, IMAGE_H - 8)
cairo_stroke(context)
cairo_destroy(context)

cairo_surface_destroy(surface)

screenlock()
put (8, 8), image, PSET
screenunlock()

imagedestroy image

sleep
