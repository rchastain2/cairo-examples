' This is file cairo_elipsis.bas, an example for cairo library
' (C) 2011 by Thomas[ dot ]Freiherr[ at ]gmx{ dot }net
' License GPLv 3
'
' Details: http://cairographics.org/documentation/

#include once "cairo\cairo.bi"

const Pag_W = 700, Pag_H = 700
const M_PI = 4 * atn(1)

type arc_seg_data
  as cairo_t ptr c_t
  as double xc, yc, ri, ra, a1, a2, fg, fb
  as integer Mo
end type

' draw a colored circle segment / farbiges Kreissegment zeichnen
sub arc_seg(byval seg as arc_seg_data ptr)
  var pa = new cairo_path_t
  with *seg
    cairo_save (.c_t)
    cairo_translate(.c_t, .xc, .yc)
    if .Mo then cairo_scale(.c_t, 1.0, 0.279) else cairo_scale(.c_t, 0.6, 1.0)
    cairo_rotate(.c_t, .a1)
    cairo_arc_negative(.c_t, 0.0, 0.0, .ri, .a2, 0.0)
    cairo_arc(.c_t, 0.0, 0.0, .ra, 0.0, .a2)
    cairo_close_path(.c_t)
    pa = cairo_copy_path(.c_t)
    cairo_set_source_rgba(.c_t, 1, .fg, .fb, 0.9)
    cairo_fill(.c_t)
    cairo_append_path(.c_t, pa)
    cairo_set_source_rgb(.c_t, 0.0, 0.0, 0.0)
    cairo_stroke(.c_t)
    cairo_restore (.c_t)
  end with
  cairo_path_destroy(pa)
end sub

sub DoDrawing(byval C as cairo_surface_t ptr, byval W as double)
  var seg = new arc_seg_data, t = "Cairo elipsis example"
  with *seg
    .c_t = cairo_create(C)
    cairo_set_source_rgb(.c_t, 1.0, 1.0, 1.0) '         white background
    cairo_paint(.c_t) '                                        fill page
    cairo_set_line_width(.c_t, 2.5)
    var f = Pag_W / 4.3
    .xc = f
    .yc = f
    .a2 = 60.0 * M_PI / 180
    for z as integer = 0 to 1 '                        two center points
      .ri = 0.1 * f
      for j as integer = 1 to 5 step 1 '                     five radius
        .ra = .ri + 0.35 * f / j
        for i as integer = 0 to 5 step 2 '                three segments
          .a1 = (1 + (2 * (z = 1))) * W + 60.0 * M_PI / 180 * i
          .fb = 60.0 * M_PI / 180 * i / M_PI / 2
          .fg = .ra / f
          arc_seg(seg)
        next
        .ri = .ra
      next
      .yc = Pag_H - 0.8 * f
      .xc = Pag_W - f
      .Mo = 1
      cairo_set_line_width(.c_t, 0.5)
    next
    cairo_set_font_size (.c_t, 0.2 * f)
    dim as cairo_font_extents_t fe '                         font data
    cairo_font_extents (.c_t, @fe)

    dim as cairo_text_extents_t te '                         text size
    cairo_text_extents (.c_t, t, @te)
    cairo_move_to (.c_t, _ '                 lower left corner of text
                   0.5 * Pag_W - (te.width / 2 + te.x_bearing), _
                   0.6 * Pag_H + (te.height / 2) - fe.descent)
    cairo_set_source_rgb(.c_t, 0.0, 0.0, 0.0)
    cairo_show_text(.c_t, t)

    cairo_show_page(.c_t)
    cairo_destroy(.c_t)
  end with
  cairo_surface_flush(C)
end sub

' main1 / Hauptprogramm1
var S_W = cuint(Pag_W) + 1, S_H = cuint(Pag_H) + 1
screenres S_W, S_H, 32
var c_s_t = cairo_image_surface_create_for_data( _
              screenptr, CAIRO_FORMAT_ARGB32, _
              S_W, S_H, S_W * 4)
var wi = 0.0
do
  screenlock
  DoDrawing(c_s_t, wi)
  screenunlock
  wi += 1.73 * M_PI / 180
  while wi > M_PI * 2 : wi -= M_PI * 2 : wend
  sleep 35
loop until len(inkey)
cairo_surface_destroy(c_s_t)
end 0
