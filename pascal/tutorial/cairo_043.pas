
uses
  SysUtils, Cairo;
  
const
  SURFACE_WIDTH = 300;
  SURFACE_HEIGHT = 300;
  
var
  context: pcairo_t;
  surface: pcairo_surface_t;
  font_options: cairo_font_options_t;
  text_extents: cairo_text_extents_t;
  i: integer;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_scale(context,SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_translate(context, 1 / 2, 1 / 2);
	cairo_set_source_rgb(context, 1.0, 1.0, 1.0);
  cairo_paint(context);
  
  cairo_set_source_rgba(context, 1.0, 0.0, 0.0, 0.5);
  cairo_set_line_width(context, 1 / 200);
  
  cairo_arc(context, 0, 0, 0.3, 0, 2 * PI);
  cairo_stroke(context);
  
  cairo_select_font_face(context, 'Courier New', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
  cairo_set_font_size(context, 0.1);
  cairo_font_options_set_antialias(@font_options, CAIRO_ANTIALIAS_GRAY);
  cairo_set_font_options(context, @font_options);
  cairo_set_source_rgb(context, 0, 0, 1);
  
  for i := 1 to 12 do
  begin
    cairo_text_extents(context, pchar(IntToStr(i)), @text_extents);
    cairo_move_to(context, 0.3 * Cos(i * PI / 6 - PI / 2) - text_extents.width / 2, 0.3 * Sin(i * PI / 6 - PI / 2) + text_extents.height / 2);
    cairo_show_text(context, pchar(IntToStr(i)));
  end;
  
  cairo_stroke(context);
  
  cairo_surface_write_to_png(surface, pchar('image.png'));
  
  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
