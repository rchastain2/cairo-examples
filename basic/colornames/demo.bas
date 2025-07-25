
#include "cairo/cairo.bi"
#include "colors.bi"

#define CAIROCOLOR(c) (c and &hFF0000) / &hFF0000, (c and &h00FF00) / &h00FF00, (c and &h0000FF) / &h0000FF

const SW = 8 * 48
const SH = 8 * 48
const PI = 3.141592654

screenres SW, SH, 32

dim as cairo_surface_t ptr surface = cairo_image_surface_create_for_data(screenptr(), CAIRO_FORMAT_ARGB32, SW, SH, SW * 4)

dim as cairo_t ptr context = cairo_create(surface)

cairo_set_source_rgb(context, CAIROCOLOR(DarkSlateBlue))
cairo_paint(context)

cairo_set_source_rgb(context, CAIROCOLOR(SlateBlue))
cairo_arc(context, 48, 48, 20, 0, 2 * PI)
cairo_fill(context)

cairo_destroy(context)
cairo_surface_destroy(surface)

sleep
