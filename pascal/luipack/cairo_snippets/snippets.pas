unit Snippets;

interface

uses
  Cairo, Math;

const
  snippet_count = 22;
  snippet_name: array [0..21] of String = (
    'arc',
    'arc_negative',
    'clip',
    'clip_image',
    'curve_rectangle',
    'curve_to',
    'fill_and_stroke',
    'fill_and_stroke2',
    'gradient',
    'image',
    'imagepattern',
    'path',
    'set_line_cap',
    'set_line_join',
    'text',
    'text_align_center',
    'text_extents',
    'xxx_clip_rectangle',
    'xxx_dash',
    'xxx_long_lines',
    'xxx_multi_segment_caps',
    'xxx_self_intersect'
   );

procedure snippet_do(cr: PCairo_t; snippet_no, width, height: Integer);

procedure snippet_normalize(cr: PCairo_t; width, height: Integer);

implementation

procedure do_arc(cr: PCairo_t; width, height: Integer);
var
  xc: Double;
  yc: Double;
  radius: Double;
  angle1: Double;
  angle2: Double;
  OldMask: TFPUExceptionMask;
begin
  //workaround to a cairo bug (fixed post 1.6.4)
  OldMask := GetExceptionMask;
  SetExceptionMask([exInvalidOp, exPrecision]);

  xc := 0.5;
  yc := 0.5;
  radius := 0.4;
  angle1 := 45.0  * (PI/180.0);  (* angles are specified *)
  angle2 := 180.0 * (PI/180.0);  (* in radians           *)

  snippet_normalize (cr, width, height);

  cairo_arc (cr, xc, yc, radius, angle1, angle2);
  cairo_stroke (cr);

  (* draw helping lines *)
  cairo_set_source_rgba (cr, 1,0.2,0.2,0.6);
  cairo_arc (cr, xc, yc, 0.05, 0, 2*PI);
  cairo_fill (cr);
  cairo_set_line_width (cr, 0.03);
  cairo_arc (cr, xc, yc, radius, angle1, angle1);
  cairo_line_to (cr, xc, yc);
  cairo_arc (cr, xc, yc, radius, angle2, angle2);
  cairo_line_to (cr, xc, yc);
  cairo_stroke (cr);

  SetExceptionMask(OldMask);
end;

procedure do_arc_negative(cr: PCairo_t; width, height: Integer);
var
  xc: Double;
  yc: Double;
  radius: Double;
  angle1: Double;
  angle2: Double;
  OldMask: TFPUExceptionMask;
begin
  //workaround to a cairo bug (fixed post 1.6.4)
  OldMask := GetExceptionMask;
  SetExceptionMask([exInvalidOp, exPrecision]);

  xc := 0.5;
  yc := 0.5;
  radius := 0.4;
  angle1 := 45.0  * (PI/180.0);  (* angles are specified *)
  angle2 := 180.0 * (PI/180.0);  (* in radians           *)

  snippet_normalize (cr, width, height);

  cairo_arc_negative (cr, xc, yc, radius, angle1, angle2);
  cairo_stroke (cr);

  (* draw helping lines *)
  cairo_set_source_rgba (cr, 1,0.2,0.2,0.6);
  cairo_arc (cr, xc, yc, 0.05, 0, 2*PI);
  cairo_fill (cr);
  cairo_set_line_width (cr, 0.03);
  cairo_arc (cr, xc, yc, radius, angle1, angle1);
  cairo_line_to (cr, xc, yc);
  cairo_arc (cr, xc, yc, radius, angle2, angle2);
  cairo_line_to (cr, xc, yc);
  cairo_stroke (cr);

  SetExceptionMask(OldMask);
end;

procedure do_clip(cr: PCairo_t; width, height: Integer);
begin
  snippet_normalize (cr, width, height);

  cairo_arc (cr, 0.5, 0.5, 0.3, 0, 2 * PI);
  cairo_clip (cr);

  cairo_new_path (cr);  (* current path is not
                           consumed by cairo_clip() *)
  cairo_rectangle (cr, 0, 0, 1, 1);
  cairo_fill (cr);
  cairo_set_source_rgb (cr, 0, 1, 0);
  cairo_move_to (cr, 0, 0);
  cairo_line_to (cr, 1, 1);
  cairo_move_to (cr, 1, 0);
  cairo_line_to (cr, 0, 1);
  cairo_stroke (cr);
end;

procedure do_clip_image(cr: PCairo_t; width, height: Integer);
var
  w, h: Integer;
  image: Pcairo_surface_t;
begin
  snippet_normalize (cr, width, height);

  cairo_arc (cr, 0.5, 0.5, 0.3, 0, 2*PI);
  cairo_clip (cr);
  cairo_new_path (cr); (* path not consumed by clip()*)

  image := cairo_image_surface_create_from_png ('data/romedalen.png');
  w := cairo_image_surface_get_width (image);
  h := cairo_image_surface_get_height (image);

  cairo_scale (cr, 1.0/w, 1.0/h);

  cairo_set_source_surface (cr, image, 0, 0);
  cairo_paint (cr);

  cairo_surface_destroy (image);
end;

procedure do_curve_rectangle(cr: PCairo_t; width, height: Integer);
(* a custom shape, that could be wrapped in a function *)
var
  x0, x1: Double;
  y0, y1: Double;
  rect_width: Double;
  rect_height: Double;
  radius: Double;
begin
  x0 := 0.1;   (*< parameters like cairo_rectangle *)
  y0 := 0.1;
  rect_width  := 0.8;
  rect_height := 0.8;
  radius := 0.4;   (*< and an approximate curvature radius *)

  snippet_normalize (cr, width, height);

  x1 := x0 + rect_width;
  y1 := y0 + rect_height;
  if (rect_width = 0) or (rect_height = 0) then
    Exit;
  if (rect_width/2 < radius) then
  begin
    if (rect_height/2 < radius) then
    begin
      cairo_move_to  (cr, x0, (y0 + y1)/2);
      cairo_curve_to (cr, x0 ,y0, x0, y0, (x0 + x1)/2, y0);
      cairo_curve_to (cr, x1, y0, x1, y0, x1, (y0 + y1)/2);
      cairo_curve_to (cr, x1, y1, x1, y1, (x1 + x0)/2, y1);
      cairo_curve_to (cr, x0, y1, x0, y1, x0, (y0 + y1)/2);
    end
    else begin
      cairo_move_to  (cr, x0, y0 + radius);
      cairo_curve_to (cr, x0 ,y0, x0, y0, (x0 + x1)/2, y0);
      cairo_curve_to (cr, x1, y0, x1, y0, x1, y0 + radius);
      cairo_line_to (cr, x1 , y1 - radius);
      cairo_curve_to (cr, x1, y1, x1, y1, (x1 + x0)/2, y1);
      cairo_curve_to (cr, x0, y1, x0, y1, x0, y1- radius);
    end;
  end
  else begin
    if (rect_height/2<radius) then
    begin
      cairo_move_to  (cr, x0, (y0 + y1)/2);
      cairo_curve_to (cr, x0 , y0, x0 , y0, x0 + radius, y0);
      cairo_line_to (cr, x1 - radius, y0);
      cairo_curve_to (cr, x1, y0, x1, y0, x1, (y0 + y1)/2);
      cairo_curve_to (cr, x1, y1, x1, y1, x1 - radius, y1);
      cairo_line_to (cr, x0 + radius, y1);
      cairo_curve_to (cr, x0, y1, x0, y1, x0, (y0 + y1)/2);
    end
    else begin
      cairo_move_to  (cr, x0, y0 + radius);
      cairo_curve_to (cr, x0 , y0, x0 , y0, x0 + radius, y0);
      cairo_line_to (cr, x1 - radius, y0);
      cairo_curve_to (cr, x1, y0, x1, y0, x1, y0 + radius);
      cairo_line_to (cr, x1 , y1 - radius);
      cairo_curve_to (cr, x1, y1, x1, y1, x1 - radius, y1);
      cairo_line_to (cr, x0 + radius, y1);
      cairo_curve_to (cr, x0, y1, x0, y1, x0, y1- radius);
    end;
  end;
  cairo_close_path (cr);

  cairo_set_source_rgb (cr, 0.5,0.5,1);
  cairo_fill_preserve (cr);
  cairo_set_source_rgba (cr, 0.5, 0, 0, 0.5);
  cairo_stroke (cr);
end;

procedure do_curve_to(cr: PCairo_t; width, height: Integer);
var
  x, x1, x2, x3: Double;
  y, y1, y2, y3: Double;
begin
  x := 0.1;
  y := 0.5;
  x1 := 0.4;
  y1 := 0.9;
  x2 := 0.6;
  y2 := 0.1;
  x3 := 0.9;
  y3 := 0.5;

  snippet_normalize (cr, width, height);

  cairo_move_to (cr,  x, y);
  cairo_curve_to (cr, x1, y1, x2, y2, x3, y3);

  cairo_stroke (cr);

  cairo_set_source_rgba (cr, 1,0.2,0.2,0.6);
  cairo_set_line_width (cr, 0.03);
  cairo_move_to (cr,x,y);   cairo_line_to (cr,x1,y1);
  cairo_move_to (cr,x2,y2); cairo_line_to (cr,x3,y3);
  cairo_stroke (cr);
end;

procedure do_fill_and_stroke(cr: PCairo_t; width, height: Integer);
begin
  snippet_normalize (cr, width, height);

  cairo_move_to (cr, 0.5, 0.1);
  cairo_line_to (cr, 0.9, 0.9);
  cairo_rel_line_to (cr, -0.4, 0.0);
  cairo_curve_to (cr, 0.2, 0.9, 0.2, 0.5, 0.5, 0.5);
  cairo_close_path (cr);

  cairo_set_source_rgb (cr, 0, 0, 1);
  cairo_fill_preserve (cr);
  cairo_set_source_rgb (cr, 0, 0, 0);
  cairo_stroke (cr);
end;

procedure do_fill_and_stroke2(cr: PCairo_t; width, height: Integer);
begin
  snippet_normalize (cr, width, height);

  cairo_move_to (cr, 0.5, 0.1);
  cairo_line_to (cr, 0.9, 0.9);
  cairo_rel_line_to (cr, -0.4, 0.0);
  cairo_curve_to (cr, 0.2, 0.9, 0.2, 0.5, 0.5, 0.5);
  cairo_close_path (cr);

  cairo_move_to (cr, 0.25, 0.1);
  cairo_rel_line_to (cr, 0.2, 0.2);
  cairo_rel_line_to (cr, -0.2, 0.2);
  cairo_rel_line_to (cr, -0.2, -0.2);
  cairo_close_path (cr);

  cairo_set_source_rgb (cr, 0, 0, 1);
  cairo_fill_preserve (cr);
  cairo_set_source_rgb (cr, 0, 0, 0);
  cairo_stroke (cr);
end;

procedure do_gradient(cr: PCairo_t; width, height: Integer);
var
  pat: Pcairo_pattern_t;
begin
  snippet_normalize (cr, width, height);

  pat := cairo_pattern_create_linear (0.0, 0.0,  0.0, 1.0);
  cairo_pattern_add_color_stop_rgba (pat, 1, 0, 0, 0, 1);
  cairo_pattern_add_color_stop_rgba (pat, 0, 1, 1, 1, 1);
  cairo_rectangle (cr, 0, 0, 1, 1);
  cairo_set_source (cr, pat);
  cairo_fill (cr);
  cairo_pattern_destroy (pat);

  pat := cairo_pattern_create_radial (0.45, 0.4, 0.1,
                                     0.4,  0.4, 0.5);
  cairo_pattern_add_color_stop_rgba (pat, 0, 1, 1, 1, 1);
  cairo_pattern_add_color_stop_rgba (pat, 1, 0, 0, 0, 1);
  cairo_set_source (cr, pat);
  cairo_arc (cr, 0.5, 0.5, 0.3, 0, 2 * PI);
  cairo_fill (cr);
  cairo_pattern_destroy (pat);
end;

procedure do_image(cr: PCairo_t; width, height: Integer);
var
  w,h: Integer;
  image: Pcairo_surface_t;
begin
  snippet_normalize (cr, width, height);

  image := cairo_image_surface_create_from_png ('data/romedalen.png');
  w := cairo_image_surface_get_width (image);
  h := cairo_image_surface_get_height (image);

  cairo_translate (cr, 0.5, 0.5);
  cairo_rotate (cr, 45* PI/180);
  cairo_scale  (cr, 1.0/w, 1.0/h);
  cairo_translate (cr, -0.5*w, -0.5*h);

  cairo_set_source_surface (cr, image, 0, 0);
  cairo_paint (cr);
  cairo_surface_destroy (image);
end;

procedure do_imagepattern(cr: PCairo_t; width, height: Integer);
var
  w, h: Integer;
  image: Pcairo_surface_t;
  pattern: Pcairo_pattern_t;
  matrix: cairo_matrix_t;

begin
  snippet_normalize (cr, width, height);

  image := cairo_image_surface_create_from_png ('data/romedalen.png');
  w := cairo_image_surface_get_width (image);
  h := cairo_image_surface_get_height (image);

  pattern := cairo_pattern_create_for_surface (image);
  cairo_pattern_set_extend (pattern, CAIRO_EXTEND_REPEAT);

  cairo_translate (cr, 0.5, 0.5);
  cairo_rotate (cr, PI / 4);
  cairo_scale (cr, 1 / sqrt (2), 1 / sqrt (2));
  cairo_translate (cr, - 0.5, - 0.5);

  //cairo_matrix_init_scale (@matrix, w * 5., h * 5.); <- original
  cairo_matrix_init_scale (@matrix, w * 5, h * 5);
  cairo_pattern_set_matrix (pattern, @matrix);

  cairo_set_source (cr, pattern);

  cairo_rectangle (cr, 0, 0, 1.0, 1.0);
  cairo_fill (cr);

  cairo_pattern_destroy (pattern);
  cairo_surface_destroy (image);
end;

procedure do_path(cr: PCairo_t; width, height: Integer);
begin
  snippet_normalize (cr, width, height);
  cairo_move_to (cr, 0.5, 0.1);
  cairo_line_to (cr, 0.9, 0.9);
  cairo_rel_line_to (cr, -0.4, 0.0);
  cairo_curve_to (cr, 0.2, 0.9, 0.2, 0.5, 0.5, 0.5);

  cairo_stroke (cr);
end;

procedure do_set_line_cap(cr: PCairo_t; width, height: Integer);
begin
  snippet_normalize (cr, width, height);
  cairo_set_line_width (cr, 0.12);
  cairo_set_line_cap  (cr, CAIRO_LINE_CAP_BUTT); (* default *)
  cairo_move_to (cr, 0.25, 0.2); cairo_line_to (cr, 0.25, 0.8);
  cairo_stroke (cr);
  cairo_set_line_cap  (cr, CAIRO_LINE_CAP_ROUND);
  cairo_move_to (cr, 0.5, 0.2); cairo_line_to (cr, 0.5, 0.8);
  cairo_stroke (cr);
  cairo_set_line_cap  (cr, CAIRO_LINE_CAP_SQUARE);
  cairo_move_to (cr, 0.75, 0.2); cairo_line_to (cr, 0.75, 0.8);
  cairo_stroke (cr);

  (* draw helping lines *)
  cairo_set_source_rgb (cr, 1,0.2,0.2);
  cairo_set_line_width (cr, 0.01);
  cairo_move_to (cr, 0.25, 0.2); cairo_line_to (cr, 0.25, 0.8);
  cairo_move_to (cr, 0.5, 0.2);  cairo_line_to (cr, 0.5, 0.8);
  cairo_move_to (cr, 0.75, 0.2); cairo_line_to (cr, 0.75, 0.8);
  cairo_stroke (cr);
end;

procedure do_set_line_join(cr: PCairo_t; width, height: Integer);
begin
  snippet_normalize (cr, width, height);
  cairo_set_line_width (cr, 0.16);
  cairo_move_to (cr, 0.3, 0.33);
  cairo_rel_line_to (cr, 0.2, -0.2);
  cairo_rel_line_to (cr, 0.2, 0.2);
  cairo_set_line_join (cr, CAIRO_LINE_JOIN_MITER); (* default *)
  cairo_stroke (cr);

  cairo_move_to (cr, 0.3, 0.63);
  cairo_rel_line_to (cr, 0.2, -0.2);
  cairo_rel_line_to (cr, 0.2, 0.2);
  cairo_set_line_join (cr, CAIRO_LINE_JOIN_BEVEL);
  cairo_stroke (cr);

  cairo_move_to (cr, 0.3, 0.93);
  cairo_rel_line_to (cr, 0.2, -0.2);
  cairo_rel_line_to (cr, 0.2, 0.2);
  cairo_set_line_join (cr, CAIRO_LINE_JOIN_ROUND);
  cairo_stroke (cr);
end;

procedure do_text(cr: PCairo_t; width, height: Integer);
begin
snippet_normalize (cr, width, height);
  cairo_select_font_face (cr, 'Sans', CAIRO_FONT_SLANT_NORMAL,
                                 CAIRO_FONT_WEIGHT_BOLD);
  cairo_set_font_size (cr, 0.35);

  cairo_move_to (cr, 0.04, 0.53);
  cairo_show_text (cr, 'Hello');

  cairo_move_to (cr, 0.27, 0.65);
  cairo_text_path (cr, 'void');
  cairo_set_source_rgb (cr, 0.5, 0.5, 1);
  cairo_fill_preserve (cr);
  cairo_set_source_rgb (cr, 0, 0, 0);
  cairo_set_line_width (cr, 0.01);
  cairo_stroke (cr);

  (* draw helping lines *)
  cairo_set_source_rgba (cr, 1,0.2,0.2, 0.6);
  cairo_arc (cr, 0.04, 0.53, 0.02, 0, 2*PI);
  cairo_close_path (cr);
  cairo_arc (cr, 0.27, 0.65, 0.02, 0, 2*PI);
  cairo_fill (cr);
end;

procedure do_text_align_center(cr: PCairo_t; width, height: Integer);
const
  utf8 = 'cairo';
var
  extents: cairo_text_extents_t;
  x,y: Double;
begin
  snippet_normalize (cr, width, height);

  cairo_select_font_face (cr, 'Sans',
      CAIRO_FONT_SLANT_NORMAL,
      CAIRO_FONT_WEIGHT_NORMAL);

  cairo_set_font_size (cr, 0.2);
  cairo_text_extents (cr, utf8, @extents);
  x := 0.5-(extents.width/2 + extents.x_bearing);
  y := 0.5-(extents.height/2 + extents.y_bearing);

  cairo_move_to (cr, x, y);
  cairo_show_text (cr, utf8);

  (* draw helping lines *)
  cairo_set_source_rgba (cr, 1,0.2,0.2, 0.6);
  cairo_arc (cr, x, y, 0.05, 0, 2*PI);
  cairo_fill (cr);
  cairo_move_to (cr, 0.5, 0);
  cairo_rel_line_to (cr, 0, 1);
  cairo_move_to (cr, 0, 0.5);
  cairo_rel_line_to (cr, 1, 0);
  cairo_stroke (cr);
end;

procedure do_text_extents(cr: PCairo_t; width, height: Integer);
const
  utf8 = 'cairo';
var
  extents: cairo_text_extents_t;
  x,y: Double;
begin
  snippet_normalize (cr, width, height);

  cairo_select_font_face (cr, 'Sans',
      CAIRO_FONT_SLANT_NORMAL,
      CAIRO_FONT_WEIGHT_NORMAL);

  cairo_set_font_size (cr, 0.4);
  cairo_text_extents (cr, utf8, @extents);

  x := 0.1;
  y := 0.6;

  cairo_move_to (cr, x,y);
  cairo_show_text (cr, utf8);

  (* draw helping lines *)
  cairo_set_source_rgba (cr, 1,0.2,0.2, 0.6);
  cairo_arc (cr, x, y, 0.05, 0, 2*PI);
  cairo_fill (cr);
  cairo_move_to (cr, x,y);
  cairo_rel_line_to (cr, 0, -extents.height);
  cairo_rel_line_to (cr, extents.width, 0);
  cairo_rel_line_to (cr, extents.x_bearing, -extents.y_bearing);
  cairo_stroke (cr);
end;

procedure do_xxx_clip_rectangle(cr: PCairo_t; width, height: Integer);
(* This is intended to test the rectangle-based clipping support in
 * cairo.  On 2004-08-03, we noticed a bug in which this clipping
 * wasn't happening at all, so we disabled it in
 * cairo_gstate.c:extract_transformed_rectangle.
 *
 * When that works again, and is re-enabled, this test can be renamed
 * without the xxx_.
 *)
begin
  snippet_normalize (cr, width, height);

  cairo_new_path (cr);
  {
  cairo_move_to (cr, .25, .25);
  cairo_line_to (cr, .25, .75);
  cairo_line_to (cr, .75, .75);
  cairo_line_to (cr, .75, .25);
  cairo_line_to (cr, .25, .25);
  }
  cairo_move_to (cr, 0.25, 0.25);
  cairo_line_to (cr, 0.25, 0.75);
  cairo_line_to (cr, 0.75, 0.75);
  cairo_line_to (cr, 0.75, 0.25);
  cairo_line_to (cr, 0.25, 0.25);
  cairo_close_path (cr);

  cairo_clip (cr);

  cairo_move_to (cr, 0, 0);
  cairo_line_to (cr, 1, 1);
  cairo_stroke (cr);
end;

procedure do_xxx_dash(cr: PCairo_t; width, height: Integer);
(* BUG: spline is not stroked, is it a bug that
   a negative offset for cairo_set_dash, causes
   no dashing to occur?
*)
const
  dashes: array [0..3] of Double = (
                   0.20,  (* ink *)
                   0.05,  (* skip *)
                   0.05,  (* ink *)
                   0.05   (* skip*)
                   );
var
  ndash: Integer;
  offset: Double;
begin
  //todo: properly set ndash
  ndash  := sizeof (dashes) div sizeof(dashes[0]);
  offset := -0.2;

  snippet_normalize (cr, width, height);

  cairo_set_dash (cr, dashes, ndash, offset);

  cairo_move_to (cr, 0.5, 0.1);
  cairo_line_to (cr, 0.9, 0.9);
  cairo_rel_line_to (cr, -0.4, 0.0);
  cairo_curve_to (cr, 0.2, 0.9, 0.2, 0.5, 0.5, 0.5);

  cairo_stroke (cr);
end;

procedure do_xxx_long_lines(cr: PCairo_t; width, height: Integer);
begin
  snippet_normalize (cr, width, height);

  cairo_move_to (cr, 0.1, -50);
  cairo_line_to (cr, 0.1,  50);
  cairo_set_source_rgb (cr, 1, 0 ,0);
  cairo_stroke (cr);

  cairo_move_to (cr, 0.2, -60);
  cairo_line_to (cr, 0.2,  60);
  cairo_set_source_rgb (cr, 1, 1 ,0);
  cairo_stroke (cr);

  cairo_move_to (cr, 0.3, -70);
  cairo_line_to (cr, 0.3,  70);
  cairo_set_source_rgb (cr, 0, 1 ,0);
  cairo_stroke (cr);

  cairo_move_to (cr, 0.4, -80);
  cairo_line_to (cr, 0.4,  80);
  cairo_set_source_rgb (cr, 0, 0 ,1);
  cairo_stroke (cr);
end;

procedure do_xxx_multi_segment_caps(cr: PCairo_t; width, height: Integer);
(* BUG: Caps are added only to the last subpath in a complex path *)
begin
  snippet_normalize (cr, width, height);

  cairo_move_to (cr, 0.2, 0.3);
  cairo_line_to (cr, 0.8, 0.3);

  cairo_move_to (cr, 0.2, 0.5);
  cairo_line_to (cr, 0.8, 0.5);

  cairo_move_to (cr, 0.2, 0.7);
  cairo_line_to (cr, 0.8, 0.7);

  cairo_set_line_width (cr, 0.12);
  cairo_set_line_cap  (cr, CAIRO_LINE_CAP_ROUND);
  cairo_stroke (cr);
end;

procedure do_xxx_self_intersect(cr: PCairo_t; width, height: Integer);
(* the minimally different shade of the right part of the bar
   is an artifact of the self intersect bug described in BUGS *)
begin
  snippet_normalize (cr, width, height);

  cairo_move_to (cr, 0.3, 0.3);
  cairo_line_to (cr, 0.7, 0.3);

  cairo_line_to (cr, 0.5, 0.3);
  cairo_line_to (cr, 0.5, 0.7);

  cairo_set_line_width (cr, 0.22);
  cairo_set_line_cap  (cr, CAIRO_LINE_CAP_ROUND);
  cairo_set_line_join  (cr, CAIRO_LINE_JOIN_ROUND);
  cairo_stroke (cr);
end;

type
  TSnippetProc = procedure (cr: PCairo_t; width, height: Integer);

const
  snippet_functions: array [0..21] of TSnippetProc = (
    @do_arc,
    @do_arc_negative,
    @do_clip,
    @do_clip_image,
    @do_curve_rectangle,
    @do_curve_to,
    @do_fill_and_stroke,
    @do_fill_and_stroke2,
    @do_gradient,
    @do_image,
    @do_imagepattern,
    @do_path,
    @do_set_line_cap,
    @do_set_line_join,
    @do_text,
    @do_text_align_center,
    @do_text_extents,
    @do_xxx_clip_rectangle,
    @do_xxx_dash,
    @do_xxx_long_lines,
    @do_xxx_multi_segment_caps,
    @do_xxx_self_intersect
  );

procedure snippet_do(cr: PCairo_t; snippet_no, width, height: Integer);
begin
  if (snippet_no >= 0) and (snippet_no < snippet_count) then
    snippet_functions[snippet_no](cr, width, height);
end;

procedure snippet_normalize(cr: PCairo_t; width, height: Integer);
begin
  cairo_scale (cr, width, height);
  cairo_set_line_width (cr, 0.04);
end;
end.
