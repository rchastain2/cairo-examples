
unit cairo_072_u;

{$MODE objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Spin;

type

  { TForm1 }
  
  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    PaintBox1: TPaintBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    { private declarations }
    procedure Capture;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  Cairo, CairoWin32, knight in '.\source\knight.pas';

{ TForm1 }

var
  knightPath: TPath;

procedure TForm1.PaintBox1Paint(Sender: TObject);
function F(const i: integer): double; inline;
begin
  result := i / 8 - 1 / 16;
end;
var
  surface: pcairo_surface_t;
  context: pcairo_t;
  x, y, i: integer;
begin
  surface := cairo_win32_surface_create(PaintBox1.Canvas.Handle);
  context := cairo_create(surface);
  cairo_translate(context, 0, PaintBox1.Height);
  cairo_scale(context, PaintBox1.Width, -PaintBox1.Height);
  cairo_set_source_rgb(context, 1.00, 0.65, 0.00); // orange
  cairo_paint(context);
  cairo_set_source_rgb(context, 1.00, 0.55, 0.00); // orange foncé
  for x := 1 to 8 do for y := 1 to 8 do
    if (x + y) mod 2 = 0 then
    begin
      cairo_rectangle(context, Pred(x) / 8, Pred(y) / 8, 1 / 8, 1 / 8);
      cairo_fill(context);
    end;

  if Length(knightPath) > 0 then
  begin
    cairo_set_line_width(context, 1 / 200);
    cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
    cairo_set_source_rgb(context, 1.00, 1.00, 0.00); // jaune
    cairo_move_to(
      context,
      F(knightPath[0].x),
      F(knightPath[0].y)
    );
    for i := 1 to High(knightPath) do
      cairo_line_to(
        context,
        F(knightPath[i].x),
        F(knightPath[i].y)
      );
    cairo_stroke(context);
  end;

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end;

{ http://forum.lazarus.freepascal.org/index.php/topic,27896.0.html }

procedure TForm1.Capture;
var
  lRect: TRect;
  lFormBitmap: TBitmap;
begin
  lRect := Bounds(0, 0, ClientWidth, ClientHeight);
  lFormBitmap := TBitmap.Create;
  try
    lFormBitmap.Width := ClientWidth;
    lFormBitmap.Height := ClientHeight;
    lFormBitmap.Canvas.CopyRect(lRect, Canvas, lRect);
    lFormBitmap.SaveToFile(ChangeFileExt(ParamStr(0), '.bmp'));
  finally
    lFormBitmap.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SearchPath(SpinEdit1.Value, SpinEdit2.Value, knightPath);
  PaintBox1.Repaint;
  SetLength(knightPath, 0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Capture;
end;

{ TForm1 }

end.
