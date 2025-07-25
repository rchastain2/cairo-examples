unit demo_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, knight;

type
  { TForm1 }
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    PaintBox1: TPaintBox;
    procedure Button1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    { private declarations }
    path: TVectorArray;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  Cairo, CairoWin32, Windows;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  SetLength(path, 0);
  knight.SearchPath(6, 5, path); // Recherche d'un chemin partant de la case F5
  if Length(path) > 0 then
    //DrawPath(path);
    PaintBox1.Repaint;
  SetLength(path, 0);
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
function F(const i: integer): double; inline;
begin
  result := i / 8 - 1 / 16;
end;

var
  cr: pcairo_t;
  surface: pcairo_surface_t;
  w, h: Integer;
  x, y, i: integer;
begin
  w := PaintBox1.Width;
  h := PaintBox1.Height;

  surface := cairo_win32_surface_create_with_dib(CAIRO_FORMAT_ARGB32,w,h);

  cr := cairo_create(surface);

  cairo_translate(cr, 0, h);
  cairo_scale(cr, w, -h);

  cairo_set_source_rgb(cr, 1.00, 0.65, 0.00);
  cairo_paint(cr);

  for x := 1 to 8 do for y := 1 to 8 do
    if (x + y) mod 2 = 0 then
    begin
      cairo_set_source_rgb(cr, 1.00, 0.55, 0.00);
      cairo_rectangle(cr, Pred(x) / 8, Pred(y) / 8, 1 / 8, 1 / 8);
      cairo_fill(cr);
    end;

  if Length(path) > 0 then
  begin
    cairo_set_line_width(cr, 1 / 200);
    cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);
    cairo_set_source_rgb(cr, 1.00, 1.00, 0.00);
    cairo_move_to(
      cr,
      F(path[0].x),
      F(path[0].y)
    );
    for i := 1 to High(path) do
      cairo_line_to(
        cr,
        F(path[i].x),
        F(path[i].y)
      );
    cairo_stroke(cr);
  end;
  cairo_destroy(cr);

  BitBlt(PaintBox1.Canvas.Handle,0,0,w,h,cairo_win32_surface_get_dc(surface),0,0,SRCCOPY);

  cairo_surface_destroy(surface);
end;

end.
