
#include once "cairo\cairo.bi"

const PI = 4 * atn(1)

dim as integer size = 256'Valint(Command(1))
dim as cairo_surface_t ptr surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, size, size)
dim as cairo_t ptr context = cairo_create(surface)

cairo_scale(context, size, size)
cairo_arc(context, 0.5, 0.5, 0.4, 0, 2 * PI)
cairo_set_source_rgb(context, 1, 0, 0)
cairo_fill_preserve(context)
cairo_set_line_width(context, 0.1)
cairo_set_source_rgb(context, 0.8, 0, 0)
cairo_stroke(context)
cairo_destroy(context)
cairo_surface_write_to_png(surface, str(size) & ".png")
cairo_surface_destroy(surface)
