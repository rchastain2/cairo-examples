
program demo2;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

uses
  SysUtils, Paques, NombreJulien, Cairo;

{$I fetesmobiles.inc}

var
  vYear: word;
  vEasterDate, vRelativeDate: TDate;
  i: integer;
  
const
  IMAGE_WIDTH = 595;
  IMAGE_HEIGHT = 842;
{ http://www.a4papersize.org/a4-paper-size-in-pixels.php }

var 
  cr: pcairo_t;
  surface: pcairo_surface_t;
  
begin
  vYear := CurrentYear();
  
  surface := cairo_pdf_surface_create(
    pchar(ChangeFileExt(ParamStr(0), '.pdf')), 
    IMAGE_WIDTH,
    IMAGE_HEIGHT
  );
  
  cr := cairo_create(surface);
  
  cairo_set_source_rgb(cr, 0, 0, 0);
  cairo_select_font_face(cr, 'Palatino Linotype', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(cr, 16);
  
  cairo_set_line_width(cr, 0.5);
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);
  
  cairo_move_to(cr, 10, 30);
  cairo_show_text(cr, pchar(Format('Fêtes mobiles pour l''année %d', [vYear])));
  
  vEasterDate := Paques.DatePaques(vYear);
  
  for i := Low(FETES) to High(FETES) do
  begin
    cairo_set_source_rgba(cr, 0.5, 0.5, 0.5, 0.5);
    cairo_move_to(cr, 10, 20 * i + 70);
    cairo_line_to(cr, 585, 20 * i + 70);
    cairo_stroke(cr);
    
    cairo_set_source_rgba(cr, 0, 0, 0, 1);
    cairo_move_to(cr, 10, 20 * i + 70);
    cairo_show_text(cr, pchar(FETES[i].name));
    
    vRelativeDate := NombreJulien.RelativeDate(vEasterDate, FETES[i].position);
    
    cairo_move_to(cr, 300, 20 * i + 70);
    cairo_show_text(cr, pchar(AnsiToUTF8(FormatDateTime('dddd dd mmmm', vRelativeDate))));
  end;
  
  cairo_destroy(cr);
  cairo_surface_destroy(surface);
end.
