
unit cairo_071_u;

{$MODE objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

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
  surface: pcairo_surface_t;
  context: pcairo_t;
  x, y: integer;
begin
  surface := cairo_win32_surface_create(PaintBox1.Canvas.Handle);
  context := cairo_create(surface);

  cairo_translate(context, 0, PaintBox1.Height);
  cairo_scale(context, PaintBox1.Width, -PaintBox1.Height);

  cairo_set_source_rgb(context, 1.00, 0.65, 0.00); // orange

  cairo_paint(context);

  cairo_set_source_rgb(context, 1.00, 0.55, 0.00); // orange foncé

  for x := 1 to 8 do for y := 1 to 8 do
    if (x + y) and 1 = 0 then
    begin
      cairo_rectangle(context, Pred(x) / 8, Pred(y) / 8, 1 / 8, 1 / 8);
      cairo_fill(context);
    end;

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end;

{ TForm1 }

end.
