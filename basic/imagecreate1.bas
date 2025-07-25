
#include once "cairo/cairo.bi"

screenres 416, 416, 32

const IMAGE_WIDTH  = 400
const IMAGE_HEIGHT = 400

dim as any ptr image = imagecreate(IMAGE_WIDTH, IMAGE_HEIGHT, rgb(255, 0, 0))

dim as any ptr pixels

imageinfo(image, IMAGE_WIDTH, IMAGE_HEIGHT,,, pixels)

dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data(pixels, CAIRO_FORMAT_ARGB32, IMAGE_WIDTH, IMAGE_HEIGHT, IMAGE_WIDTH * 4)

dim as cairo_t ptr context = cairo_create(surface)

cairo_set_source_rgb(context, 0, 0, 1)
cairo_paint(context)
cairo_set_source_rgb(context, 1, 1, 1)
cairo_move_to(context, 8, 8)
cairo_line_to(context, 392, 392)
cairo_stroke(context)

cairo_destroy(context)
cairo_surface_destroy(surface)

screenlock()
put (8, 8), image, PSET
screenunlock()

imagedestroy image

sleep
