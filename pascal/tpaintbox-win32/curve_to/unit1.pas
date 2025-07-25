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

  x, x1, x2, x3: Double;
  y, y1, y2, y3: Double;

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

  x := 0.1;
  y := 0.5;
  x1 := 0.4;
  y1 := 0.9;
  x2 := 0.6;
  y2 := 0.1;
  x3 := 0.9;
  y3 := 0.5;

  cairo_scale(cr, width, height);
  cairo_set_line_width(cr, 0.04);

  cairo_move_to (cr,  x, y);
  cairo_curve_to (cr, x1, y1, x2, y2, x3, y3);
  cairo_stroke (cr);
  cairo_set_source_rgba (cr, 1,0.2,0.2,0.6);
  cairo_set_line_width (cr, 0.03);
  cairo_move_to (cr,x,y);   cairo_line_to (cr,x1,y1);
  cairo_move_to (cr,x2,y2); cairo_line_to (cr,x3,y3);
  cairo_stroke (cr);

  PaintBox1.Canvas.Draw(0, 0, Buffer);

  cairo_destroy(cr);
  cairo_surface_destroy(surface);

  Buffer.Destroy;
end;

{ TForm1 }

end.
