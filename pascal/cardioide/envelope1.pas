
(* https://mathimages.swarthmore.edu/index.php/Cardioid *)

uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH = 480;
  SURFACE_HEIGHT = 480;

const
  R = 0.15;
  X = -R;
  Y = 0;
  
var
  context: pcairo_t;
  surface: pcairo_surface_t;
  e: cairo_text_extents_t;
  a,
  xx, yy,
  rr: double;
  i: integer;
  
begin
  Randomize;
  
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_set_source_rgb(context, 1, 1, 1);
  cairo_paint(context);

  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_translate(context, 1 / 2, 1 / 2);
  
  (*
  cairo_set_line_width(context, 1 / 1000);
  cairo_set_source_rgb(context, 0, 0, 0);
  cairo_move_to(context,-0.4, 0.0);
  cairo_line_to(context, 0.4, 0.0);
  cairo_move_to(context, 0.0,-0.4);
  cairo_line_to(context, 0.0, 0.4);
  cairo_stroke(context);
  *)
  
  cairo_set_line_width(context, 1 / 500);
  
  cairo_set_source_rgb(context, 0, 0, 1);
  cairo_arc(context, 0, 0, R, 0, 2 * PI);
  cairo_stroke(context);
  
  cairo_set_source_rgb(context, 1, 0, 0);
  cairo_arc(context, X, Y, 1 / 200, 0, 2 * PI);
  cairo_fill(context);
  
  cairo_set_source_rgb(context, 0, 0, 0);
  cairo_select_font_face(context, 'Cantarell', {CAIRO_FONT_SLANT_NORMAL}CAIRO_FONT_SLANT_ITALIC, {CAIRO_FONT_WEIGHT_BOLD}CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(context, 1 / 28);
  cairo_text_extents(context, pchar('Z'), @e);
  cairo_move_to(context, X - 2 * e.width, Y + 2 * e.height);
  cairo_show_text(context, 'P');
  cairo_move_to(context, -e.width / 2, R + 2 * e.height);
  cairo_show_text(context, 'C');
  cairo_stroke(context);
  
  for i := 1 to 3 do
  begin
    a := 2 * PI * (Random(360) / 359);
    
    xx := R * Cos(a);
    yy := R * Sin(a);
    
    cairo_set_source_rgb(context, 0, 0, 1);
    cairo_arc(context, xx, yy, 1 / 200, 0, 2 * PI);
    cairo_fill(context);
    
    rr := Sqrt((xx - X) * (xx - X) + (yy - Y) * (yy - Y));
    
    cairo_set_source_rgba(context, 1, 0, 0, 0.3);
    cairo_arc(context, xx, yy, rr, 0, 2 * PI);
    cairo_stroke(context);
  end;

  cairo_surface_write_to_png(surface, pchar('image.png'));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
