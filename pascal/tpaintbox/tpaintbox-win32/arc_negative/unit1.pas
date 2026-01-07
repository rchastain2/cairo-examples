unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  { TForm1 }
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    procedure PaintBox1Paint(Sender: TObject);
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
  Cairo, CairoWin32;

{ TForm1 }

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  surface: Pcairo_surface_t;
  cr: Pcairo_t;
  Buffer: TBitmap;
  w, h: Integer;

  xc: double;
  yc: double;
  radius: double;
  angle1: double;
  angle2: double;

begin
  w := PaintBox1.Width;
  h := PaintBox1.Height;

  Buffer := TBitmap.Create;
  Buffer.SetSize(w, h);

  surface := cairo_win32_surface_create(Buffer.Canvas.Handle);

  cr := cairo_create (surface);

  cairo_save(cr);
  cairo_set_source_rgb(cr, 1, 1, 1);
  cairo_paint(cr);
  cairo_restore(cr);

  xc := 0.5;
  yc := 0.5;
  radius := 0.4;
  angle1 := 45.0  * (PI / 180.0);
  angle2 := 180.0 * (PI / 180.0);

  cairo_scale(cr, width, height);
  cairo_set_line_width(cr, 0.04);

  cairo_arc_negative (cr, xc, yc, radius, angle1, angle2);
  cairo_stroke (cr);

  cairo_set_source_rgba (cr, 1,0.2,0.2,0.6);
  cairo_arc (cr, xc, yc, 0.05, 0, 2*PI);
  cairo_fill (cr);
  cairo_set_line_width (cr, 0.03);
  cairo_arc (cr, xc, yc, radius, angle1, angle1);
  cairo_line_to (cr, xc, yc);
  cairo_arc (cr, xc, yc, radius, angle2, angle2);
  cairo_line_to (cr, xc, yc);
  cairo_stroke (cr);

  PaintBox1.Canvas.Draw(0, 0, Buffer);

  cairo_destroy(cr);
  cairo_surface_destroy(surface);

  Buffer.Destroy;
end;

{ TForm1 }

end.
