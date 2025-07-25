
uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH = 595;
  SURFACE_HEIGHT = 842;
{ http://www.a4papersize.org/a4-paper-size-in-pixels.php }

var 
  context: pcairo_t;
  surface: pcairo_surface_t;
  
begin
  surface := cairo_pdf_surface_create(
    pchar(ChangeFileExt(ParamStr(0), '.pdf')), 
    SURFACE_WIDTH,
    SURFACE_HEIGHT
  );
  
  context := cairo_create(surface);
  
  cairo_select_font_face(context, 'Cantarell', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(context, 12);
  
  cairo_move_to(context, 10, 10);
  cairo_show_text(context, pchar('Лорем ипсум долор сит амет'));
  
  cairo_stroke(context);
  cairo_destroy(context);
  
  cairo_surface_destroy(surface);
end.
