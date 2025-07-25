unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  { TForm1 }
  TForm1 = class(TForm)
    PB: TPaintBox;
    procedure PBPaint(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  Cairo{$IFDEF WINDOWS}, CairoWin32{$ENDIF};

{ TForm1 }

procedure TForm1.PBPaint(Sender: TObject);
var
  surface: Pcairo_surface_t;
  cr: Pcairo_t;
  bmp: TBitmap;
  xc, yc, radius, angle1, angle2: double;
begin
  bmp := TBitmap.Create;
  bmp.SetSize(PB.Width, PB.Height);

{$IFDEF WINDOWS}
  surface := cairo_win32_surface_create(bmp.Canvas.Handle);
{$ELSE}
{ https://www.lazarusforum.de/viewtopic.php?p=133936#p133936 }
  surface := cairo_image_surface_create_for_data(
    bmp.RawImage.Data,
    CAIRO_FORMAT_ARGB32,
    bmp.Width,
    bmp.Height,
    cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, bmp.Width)
  );
{$ENDIF}
  cr := cairo_create (surface);

  cairo_save(cr);
  cairo_set_source_rgb(cr, 1, 1, 1);
  cairo_paint(cr);
  cairo_restore(cr);

  xc := 0.5;
  yc := 0.5;
  radius := 0.4;
  angle1 := PI / 4;
  angle2 := PI;

  cairo_scale(cr, bmp.Width, bmp.Height);
  cairo_set_line_width(cr, 0.04);

  cairo_arc (cr, xc, yc, radius, angle1, angle2);
  cairo_stroke (cr);

  cairo_set_source_rgba (cr, 1,0.2,0.2,0.6);
  cairo_arc (cr, xc, yc, 0.05, 0, 2 * PI);
  cairo_fill (cr);
  cairo_set_line_width (cr, 0.03);
  cairo_arc (cr, xc, yc, radius, angle1, angle1);
  cairo_line_to (cr, xc, yc);
  cairo_arc (cr, xc, yc, radius, angle2, angle2);
  cairo_line_to (cr, xc, yc);
  cairo_stroke (cr);

  PB.Canvas.Draw(0, 0, bmp);

  cairo_destroy(cr);
  cairo_surface_destroy(surface);

  bmp.Destroy;
end;

end.
