
' https://www.freebasic.net/forum/viewtopic.php?p=163536#p163536

#define CAIRO_HAS_PDF_SURFACE 1
#define CAIRO_HAS_SVG_SURFACE 1
#define CAIRO_HAS_PS_SURFACE  1

#include once "cairo\cairo.bi"
#include once "cairo\cairo-pdf.bi"
#include once "cairo\cairo-ps.bi"
#include once "cairo\cairo-svg.bi"

'{612, 792},     /* HPDF_PAGE_SIZE_LETTER */
'{612, 1008},    /* HPDF_PAGE_SIZE_LEGAL */
'{841.89, 1199.551},    /* HPDF_PAGE_SIZE_A3 */
'{595.276, 841.89},     /* HPDF_PAGE_SIZE_A4 */
'{419.528, 595.276},     /* HPDF_PAGE_SIZE_A5 */
'{708.661, 1000.63},     /* HPDF_PAGE_SIZE_B4 */
'{498.898, 708.661},     /* HPDF_PAGE_SIZE_B5 */
'{522, 756},     /* HPDF_PAGE_SIZE_EXECUTIVE */
'{288, 432},     /* HPDF_PAGE_SIZE_US4x6 */
'{288, 576},     /* HPDF_PAGE_SIZE_US4x8 */
'{360, 504},     /* HPDF_PAGE_SIZE_US5x7 */
'{297, 684}      /* HPDF_PAGE_SIZE_COMM10 */

const Pag_W = 595.276, Pag_H = 841.89 '                        A4 format
const M_PI = 4 * atn(1) '                                             Pi

type arc_seg_data
  as cairo_t ptr c_t
  as double xc, yc, ri, ra, a1, a2, fg, fb
end type

' draw a colored circle segment / farbiges Kreissegment zeichnen
sub arc_seg(byval seg as arc_seg_data ptr)
  var pa = new cairo_path_t
  with *seg
    cairo_arc_negative(.c_t, .xc, .yc, .ri, .a2, .a1)
    cairo_arc(.c_t, .xc, .yc, .ra, .a1, .a2)
    cairo_close_path(.c_t)
    pa = cairo_copy_path(.c_t)
    cairo_set_source_rgba(.c_t, 1, .fg, .fb, 0.9)
    cairo_fill(.c_t)
    cairo_append_path(.c_t, pa)
    cairo_set_source_rgb(.c_t, 0.0, 0.0, 0.0)
    cairo_stroke(.c_t)
  end with
  cairo_path_destroy(pa)
end sub

' draw / zeichnen
sub DoDrawing(byval C as cairo_surface_t ptr)
  var seg = new arc_seg_data, t = "Cairo grafics example"
  with *seg
    .c_t = cairo_create(C)
    cairo_set_source_rgb(.c_t, 1.0, 1.0, 1.0) '         white background
    cairo_paint(.c_t) '                                        fill page
    cairo_set_line_width(.c_t, 0.5)
    var f = 0.3 * Pag_W
    .xc = f
    .yc = f
    for z as integer = 0 to 1 '                        two center points
      .ri = 0.1 * f
      for j as integer = 1 to 5 step 1 '                     five radius
        .ra = .ri + 0.35 * f / j
        for i as integer = 0 to 5 step 2 '                three segments
          .a1 = 60.0 * M_PI / 180 * i
          .a2 = 60.0 * M_PI / 180 * (i + 1)
          .fg = .ra / f
          .fb = .a1 / M_PI / 2
          arc_seg(seg)
        next
        .ri = .ra
      next
      cairo_set_font_size (.c_t, 0.2 * f)
      dim as cairo_font_extents_t fe '                         font data
      cairo_font_extents (.c_t, @fe)

      dim as cairo_text_extents_t te '                         text size
      cairo_text_extents (.c_t, t, @te)
      cairo_move_to (.c_t, _ '                 lower left corner of text
                     Pag_W / 2 - (te.width / 2 + te.x_bearing), _
                     Pag_H / 2 + (te.height / 2) - fe.descent)
      cairo_show_text(.c_t, t)
      cairo_stroke(.c_t)

      .yc = Pag_H - f
      .xc = Pag_W - f
    next
    cairo_show_page(.c_t)
    cairo_destroy(.c_t)
  end with
  cairo_surface_flush(C)
  cairo_surface_destroy(C)
end sub

' screen output / Bildschirmausgabe
sub write_screen()
  var S_W = cuint(Pag_W) + 1, S_H = cuint(Pag_H) + 1
  screenres S_W, S_H, 32
  var c_s_t = cairo_image_surface_create_for_data( _
                screenptr, CAIRO_FORMAT_ARGB32, _
                S_W, S_H, S_W * 4) ' * LEN(INTEGER))

  screenlock
  DoDrawing(c_s_t)
  screenunlock
  sleep
end sub

' file output / Schreibt eine Datei, pdf/svg/ps je nach Endung in fname
sub write_file(byref fname as string = "")
  dim as cairo_surface_t ptr c_s_t

  select case lcase(right(fname, 4))
  case ".pdf"
    c_s_t = cairo_pdf_surface_create(fname, Pag_W, Pag_H)
  case ".svg"
    c_s_t = cairo_svg_surface_create(fname, Pag_W, Pag_H)
  case else
    c_s_t = cairo_ps_surface_create(fname, Pag_W, Pag_H)
  end select
  DoDrawing(c_s_t)
end sub


' main / Hauptprogramm
write_screen()

var f = "circle."
write_file(f & "pdf")
write_file(f & "ps")
write_file(f & "svg")
end 0
