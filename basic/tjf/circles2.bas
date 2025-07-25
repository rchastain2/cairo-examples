
' https://www.freebasic.net/forum/viewtopic.php?p=163599#p163599

#INCLUDE ONCE "cairo/cairo.bi"

CONST Pag_W = 700, Pag_H = 700
CONST M_PI = 4 * ATN(1) '                                             Pi

TYPE arc_seg_data
  AS cairo_t PTR c_t
  AS DOUBLE xc, yc, ri, ra, a1, a2, fg, fb
END TYPE

' draw a colored circle segment / farbiges Kreissegment zeichnen
SUB arc_seg(BYVAL seg AS arc_seg_data PTR)
  VAR pa = NEW cairo_path_t
  WITH *seg
    cairo_arc_negative(.c_t, .xc, .yc, .ri, .a2, .a1)
    cairo_arc(.c_t, .xc, .yc, .ra, .a1, .a2)
    cairo_close_path(.c_t)
    pa = cairo_copy_path(.c_t)
    cairo_set_source_rgba(.c_t, 1, .fg, .fb, 0.9)
    cairo_fill(.c_t)
    cairo_append_path(.c_t, pa)
    cairo_set_source_rgb(.c_t, 0.0, 0.0, 0.0)
    cairo_stroke(.c_t)
  END WITH
  cairo_path_destroy(pa)
END SUB

' draw / zeichnen
SUB DoDrawing(BYVAL C AS cairo_surface_t PTR, BYVAL W AS DOUBLE)
  VAR seg = NEW arc_seg_data, t = "Cairo grafics example"
  WITH *seg
    .c_t = cairo_create(C)
    cairo_set_source_rgb(.c_t, 1.0, 1.0, 1.0) '         white background
    cairo_paint(.c_t) '                                        fill page
    cairo_set_line_width(.c_t, 0.5)
    VAR f = Pag_W / 4.3
    .xc = f
    .yc = f
    FOR z AS INTEGER = 0 TO 1 '                        two center points
      .ri = 0.1 * f
      FOR j AS INTEGER = 1 TO 5 STEP 1 '                     five radius
        .ra = .ri + 0.35 * f / j
        FOR i AS INTEGER = 0 TO 5 STEP 2 '                three segments
          .a1 = (1 + (2 * (z = 1))) * W + 60.0 * M_PI / 180 * i
          .a2 = .a1 + 60.0 * M_PI / 180
          .fb = 60.0 * M_PI / 180 * i / M_PI / 2
          .fg = .ra / f
          arc_seg(seg)
        NEXT
        .ri = .ra
      NEXT
      cairo_set_font_size (.c_t, 0.2 * f)
      DIM AS cairo_font_extents_t fe '                         font data
      cairo_font_extents (.c_t, @fe)

      DIM AS cairo_text_extents_t te '                         text size
      cairo_text_extents (.c_t, t, @te)
      cairo_move_to (.c_t, _ '                 lower left corner of text
                     Pag_W / 2 - (te.width / 2 + te.x_bearing), _
                     Pag_H / 2 + (te.height / 2) - fe.descent)
      cairo_show_text(.c_t, t)
      cairo_stroke(.c_t)

      .yc = Pag_H - f
      .xc = Pag_W - f
    NEXT
    cairo_show_page(.c_t)
    cairo_destroy(.c_t)
  END WITH
  cairo_surface_flush(C)
END SUB

' main1 / Hauptprogramm1
VAR S_W = CUINT(Pag_W) + 1, S_H = CUINT(Pag_H) + 1
SCREENRES S_W, S_H, 32
VAR c_s_t = cairo_image_surface_create_for_data( _
              SCREENPTR, CAIRO_FORMAT_ARGB32, _
              S_W, S_H, S_W * 4)
VAR wi = 0.0
DO
  SCREENLOCK
  DoDrawing(c_s_t, wi)
  SCREENUNLOCK
  wi += 1.73 * M_PI / 180
  WHILE wi > M_PI * 2 : wi -= M_PI * 2 : WEND
  SLEEP 35
LOOP UNTIL LEN(INKEY)
cairo_surface_destroy(c_s_t)
'END 0
