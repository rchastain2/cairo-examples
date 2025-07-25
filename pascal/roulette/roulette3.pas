
uses
  SysUtils, Cairo, Constants;
  
var
  cr: pcairo_t;
  sf: pcairo_surface_t;
  te: cairo_text_extents_t;
  i, j: integer;
  s: string;
  
begin  
  sf := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, IW, IH);
  cr := cairo_create(sf);

{ Change coordinate system }
  cairo_scale(cr, IW, IH);
  cairo_translate(cr, 0.5, 0.5);
  
  (*
{ Background color }
  cairo_set_source_rgba(cr, 1.0, 1.0, 1.0, 1.0); { White }
  cairo_rectangle(cr, -0.5, -0.5, 1.0, 1.0);
  cairo_fill(cr);
  *)
  (*
{ Background color (simpler) }
  cairo_set_source_rgba(cr, 1.0, 1.0, 1.0, 1.0); { White }
  cairo_paint(cr);
  *)
  
  cairo_rotate(cr, -PI / 12);
  
  for i := 0 to 11 do
  begin
    cairo_move_to(cr, 0.0, 0.0);
    cairo_arc(
      cr,
      0.0,
      0.0,
      0.5,
      0.0,
      PI / 6
    );
    cairo_move_to(cr, 0.0, 0.0);
    cairo_close_path(cr);
    
    j := i mod 4;
    cairo_set_source_rgba(cr, PAL[j, 0], PAL[j, 1], PAL[j, 2], 1.0);
    cairo_fill(cr);
    
    cairo_rotate(cr, PI / 6);
  end;
  
  cairo_select_font_face(cr, 'Cantarell', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
  cairo_set_font_size(cr, 0.1);
  cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
  
  cairo_rotate(cr, PI / 12);
  
  for i := 0 to 11 do
  begin
    s := IntToStr(i + 1);
    cairo_text_extents(cr, pchar(s), @te);
    cairo_move_to(cr, -te.width / 2, -0.4 + te.height / 2);
    cairo_show_text(cr, pchar(s));
    cairo_rotate(cr, PI / 6);
  end;
  
  cairo_surface_write_to_png(sf, pchar('roulette3.png'));
  
  cairo_destroy(cr);
  cairo_surface_destroy(sf);
end.
