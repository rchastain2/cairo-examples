 

uses
  SysUtils, Cairo;
 
const
  SURFACE_WIDTH = 595;
  SURFACE_HEIGHT = 842;
{ http://www.a4papersize.org/a4-paper-size-in-pixels.php }

procedure DrawString(context: pcairo_t; x, y: double; s: string);
begin
  cairo_move_to(context, x, y);
  cairo_show_text(context, pchar(s));
end;

var 
  context: pcairo_t;
  surface: pcairo_surface_t;
  s: rawbytestring;
 
begin
  surface := cairo_pdf_surface_create(
    pchar(ChangeFileExt(ParamStr(0), '.pdf')), 
    SURFACE_WIDTH,
    SURFACE_HEIGHT
  );
 
  context := cairo_create(surface);
 
  cairo_select_font_face(context, 'Palatino Linotype', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(context, 12);
  
  DrawString(context, 10, 30, 'bonjour');
  DrawString(context, 10, 50, AnsiToUTF8(FormatDateTime('dddd dd mmmm yyyy', Date())));
  DrawString(context, 10, 70, Format('Année %d', [2016]));
  
  s := FormatDateTime('dddd dd mmmm yyyy', Date());
  SetCodePage(s, CP_UTF8, TRUE);
  
  DrawString(context, 10, 90, s);
  
  cairo_stroke(context);  
  cairo_destroy(context);
  
  cairo_surface_destroy(surface);
end.
