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

  w2, h2: Integer;
  image: Pcairo_surface_t;

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
  cairo_set_line_width (cr, 0.04);

  cairo_arc (cr, 0.5, 0.5, 0.3, 0, 2 * PI);
  cairo_clip (cr);
  cairo_new_path (cr); (* path not consumed by clip()*)

  image := cairo_image_surface_create_from_png ('..\..\demos\cairo_snippets\data\romedalen.png');
  w2 := cairo_image_surface_get_width (image);
  h2 := cairo_image_surface_get_height (image);

  cairo_scale (cr, 1.0/w2, 1.0/h2);

  cairo_set_source_surface (cr, image, 0, 0);
  cairo_paint (cr);

  cairo_surface_destroy (image);

  PaintBox1.Canvas.Draw(0, 0, Buffer);

  cairo_destroy(cr);
  cairo_surface_destroy(surface);

  Buffer.Destroy;
end;

{ TForm1 }

end.

