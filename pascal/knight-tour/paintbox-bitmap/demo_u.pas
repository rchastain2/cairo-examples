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
  private
    { private declarations }
    procedure DrawPath(const aPath: TVectorArray);
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

procedure TForm1.Button1Click(Sender: TObject);
var
  path: TVectorArray;
begin
  SetLength(path, 0);
  SearchPath(6, 5, path); // Recherche d'un chemin partant de la case F5
  if Length(path) > 0 then
    DrawPath(path);
  SetLength(path, 0);
end;

procedure TForm1.DrawPath(const aPath: TVectorArray);

  function F(const i: integer): double; inline;
  begin
    result := i / 8 - 1 / 16;
  end;

var
  cr: pcairo_t;
  surface: pcairo_surface_t;
  bitmap: TBitmap;
  w, h: Integer;
  x, y, i: integer;
begin
  w := PaintBox1.Width;
  h := PaintBox1.Height;

  bitmap := TBitmap.Create;
  bitmap.SetSize(w, h);

  surface := cairo_win32_surface_create(bitmap.Canvas.Handle);

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

  cairo_set_line_width(cr, 1 / 200);
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);
  cairo_set_source_rgb(cr, 1.00, 1.00, 0.00);
  cairo_move_to(
    cr,
    F(aPath[0].x),
    F(aPath[0].y)
  );
  for i := 1 to High(aPath) do
    cairo_line_to(
      cr,
      F(aPath[i].x),
      F(aPath[i].y)
    );
  cairo_stroke(cr);
  
  cairo_destroy(cr);
  cairo_surface_destroy(surface);
  
  PaintBox1.Canvas.Draw(0, 0, bitmap);
  
  bitmap.Destroy;
end;

end.
