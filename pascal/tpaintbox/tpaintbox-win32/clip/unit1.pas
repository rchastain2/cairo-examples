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

  cairo_scale(cr, width, height);
  cairo_set_line_width(cr, 0.04);

  cairo_arc (cr, 0.5, 0.5, 0.3, 0, 2 * PI);
  cairo_clip (cr);

  cairo_new_path (cr);

  cairo_rectangle (cr, 0, 0, 1, 1);
  cairo_fill (cr);
  cairo_set_source_rgb (cr, 0, 1, 0);
  cairo_move_to (cr, 0, 0);
  cairo_line_to (cr, 1, 1);
  cairo_move_to (cr, 1, 0);
  cairo_line_to (cr, 0, 1);
  cairo_stroke (cr);

  PaintBox1.Canvas.Draw(0, 0, Buffer);

  cairo_destroy(cr);
  cairo_surface_destroy(surface);

  Buffer.Destroy;
end;

{ TForm1 }

end.
