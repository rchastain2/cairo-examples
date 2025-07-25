
uses
  Cairo;
  
const
  WIDTH = 512;
  h = 90;

{ http://zetcode.com/gfx/cairo/cairotext/ }

var
  c: pcairo_t;
  s: pcairo_surface_t;
  pat: pcairo_pattern_t;
  
begin
  
  s := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, WIDTH, WIDTH);
  c := cairo_create(s);
  
  cairo_select_font_face(c, 'Serif', CAIRO_FONT_SLANT_ITALIC, CAIRO_FONT_WEIGHT_BOLD);
  cairo_set_font_size(c, h);
  
  pat := cairo_pattern_create_linear(0, 15, 0, h*0.8);
  cairo_pattern_set_extend(pat, CAIRO_EXTEND_REPEAT);
  cairo_pattern_add_color_stop_rgb(pat, 0.0, 1, 0.6, 0);
  cairo_pattern_add_color_stop_rgb(pat, 0.5, 1, 0.3, 0);
                  
  cairo_move_to(c, 15, 80);
  cairo_text_path(c, 'ZetCode');
  cairo_set_source(c, pat);
  cairo_fill(c);
  
  cairo_surface_write_to_png(s, pchar('image.png'));
  
  cairo_destroy(c);
  cairo_surface_destroy(s);
end.
