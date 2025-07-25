
uses
  sysutils, classes, cairo;
  
var
  fontname, symbol, filename: string;
  size: integer;
  cr: Pcairo_t;
  surface: Pcairo_surface_t;
  
begin
  fontname := 'chess condal';
  symbol := 'b';
  filename := 'chess-condal-white-bishop.png';
  size := 256;

  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, size, size);
  cr := cairo_create(surface);
  cairo_select_font_face(cr, pchar(fontname), CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(cr, size);
  cairo_set_source_rgba(cr, 1.0, 1.0, 1.0, 0.0);
  cairo_paint(cr);
  cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
  cairo_move_to(cr, 0, size);
  cairo_show_text(cr, pchar(symbol));
  cairo_surface_write_to_png(surface, pchar(filename));
  cairo_destroy(cr);
  cairo_surface_destroy(surface);
end.
