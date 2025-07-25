
#include once "cairo/cairo.bi"
#include once "cairo/cairo-pdf.bi"

const PAGE_WIDTH = 700, PAGE_HEIGHT = 700
const SURF_WIDTH = cuint(PAGE_WIDTH) + 1, SURF_HEIGHT = cuint(PAGE_HEIGHT) + 1

dim as cairo_surface_t ptr surface = cairo_pdf_surface_create("image.pdf", SURF_WIDTH, SURF_HEIGHT)
dim as cairo_t ptr context = cairo_create(surface)

dim as string text = "Cairo example"

cairo_select_font_face (context, "Times", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
cairo_set_font_size(context, 80)

dim as cairo_font_extents_t fe
cairo_font_extents(context, @fe)

dim as cairo_text_extents_t te
cairo_text_extents(context, text, @te)

cairo_move_to(context, PAGE_WIDTH / 2 - (te.width / 2 + te.x_bearing), PAGE_HEIGHT / 2 + (te.height / 2) - fe.descent)
cairo_show_text(context, text)
cairo_stroke(context)

cairo_show_page(context)
cairo_destroy(context)

cairo_surface_flush(surface)
cairo_surface_destroy(surface)
