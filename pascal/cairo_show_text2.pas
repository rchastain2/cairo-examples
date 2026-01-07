
uses
  sysutils, Cairo;

const
  SURFACE_WIDTH = 800;
  SURFACE_HEIGHT = 200;
  FONT_NAME = 'Palatine Parliamentary';

var
  sf: pcairo_surface_t;
  cr: pcairo_t;
  ex: cairo_text_extents_t;
  x, y: double;
  s: string;
  
begin
  s := 'Salut Éléonore ! Ça gaze ?';
  
  sf := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  
  cr := cairo_create(sf);
  
  cairo_set_source_rgb(cr, 0.184, 0.310, 0.310);
  cairo_paint(cr);
  
  cairo_select_font_face(cr, FONT_NAME, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
  cairo_set_font_size(cr, 48);
  cairo_set_source_rgb(cr, 0.961, 0.961, 0.961);
  
  cairo_text_extents(cr, pchar(s), @ex);
  
  x := (SURFACE_WIDTH - ex.width) / 2;
  y := (SURFACE_HEIGHT - ex.height) / 2 - ex.y_bearing;
  
  cairo_move_to(cr, x, y);
  cairo_show_text(cr, pchar(s));
  
  cairo_set_source_rgba(cr, 0.992, 0.914, 0.063, 0.4);
  cairo_arc(cr, x, y, 0.05, 0, 2 * PI);
  cairo_fill(cr);
  cairo_move_to(cr, x, y);
  cairo_rel_line_to(cr, 0, -ex.height);
  cairo_rel_line_to(cr, ex.width, 0);
  cairo_rel_line_to(cr, ex.x_bearing, -ex.y_bearing);
  cairo_stroke(cr);
{ https://github.com/blikblum/luipack/blob/master/cairo/demos/cairo_snippets/snippets/text_extents.cairo }
  
  cairo_destroy(cr);
  
  cairo_surface_write_to_png(sf, 'image.png');
  
  cairo_surface_destroy(sf);
end.
