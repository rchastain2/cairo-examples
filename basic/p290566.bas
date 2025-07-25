
' https://www.freebasic.net/forum/viewtopic.php?p=290566#p290566

#include once "cairo\cairo.bi"

const as single pi = 4 * atn(1)
const as integer scrnw = 800, scrnh = 260

dim as cairo_surface_t ptr surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, scrnw, scrnh)
dim as cairo_t ptr context = cairo_create(surface)

dim as single a, x, y, x1, y1
for a = 0 to 36 * 11 * pi * 2
	x = 360 * 1 * sin(a / 36) + scrnw / 2
	y = 90 * sin(a / 11) + scrnh / 2
	if a <> 0 then
    cairo_move_to(context, x, y)
    cairo_line_to(context, x1, y1)
	end if
	x1 = x
	y1 = y
next

cairo_set_source_rgb(context, 1, 1, 1)
cairo_paint(context)
cairo_set_source_rgb(context, 0, 0, 0)
cairo_set_line_width(context, 0.5)
cairo_stroke(context)

cairo_destroy(context)
cairo_surface_write_to_png(surface, "p290566.png")
cairo_surface_destroy(surface)
