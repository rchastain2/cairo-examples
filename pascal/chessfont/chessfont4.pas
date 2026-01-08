
uses
  Cairo, SysUtils;

const
  W = 192;
  H = W;
  COL_SYMBOLS = 'wb';
  FEN_SYMBOLS = 'pnbrqk';
  TTF_SYMBOLS = 'pnbrqk' + 'omvtwl' + 'PNBRQK' + 'OMVTWL' + ' +';

var
  cr: pcairo_t;
  surface: pcairo_surface_t;
  i, j: integer;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, W, H);
  cr := cairo_create(surface);

  cairo_select_font_face(cr, 'Chess Montreal', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(cr, H);
  cairo_set_source_rgba(cr, 0.0, 0.0, 0.0, 1.0);
  
  for i := 1 to Length(COL_SYMBOLS) do
    for j := 1 to Length(FEN_SYMBOLS) do
    begin
      cairo_save(cr);
      cairo_set_operator(cr, CAIRO_OPERATOR_CLEAR);
      cairo_paint(cr);
      cairo_restore(cr);
      
      cairo_move_to(cr, 0, H);
      cairo_show_text(cr, pchar(string(TTF_SYMBOLS[j + 6 * (i - 1)])));
      cairo_surface_write_to_png(surface, pchar(COL_SYMBOLS[i] + FEN_SYMBOLS[j] + '.png'));

    end;
  
  cairo_destroy(cr);
  cairo_surface_destroy(surface);    
end.
