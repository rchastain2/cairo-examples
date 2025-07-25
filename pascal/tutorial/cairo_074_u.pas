
unit cairo_074_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Cairo, CairoWin32;

type

  { TForm1 }

  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    fContext: pcairo_t;
    fSurface: pcairo_surface_t;
    fBitmap: TBitmap;
    fPoints: array[0..19, 0..1] of double;
    fPosition: integer;
    procedure RedrawBitmap;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  CairoColor in '.\source\cairocolor.pas';

{$I .\source\colornames.inc}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  i, j, k: integer;
begin
  fBitmap := TBitmap.Create;
  fBitmap.SetSize(PaintBox1.Width, PaintBox1.Height);

  fSurface := cairo_win32_surface_create(fBitmap.Canvas.Handle);

  fContext := cairo_create(fSurface);

  cairo_scale(fContext, fBitmap.Width, fBitmap.Height);
  cairo_translate(fContext, 0.5, 0.5);

  i := 0;
  for j := 0 to 11 do
  begin
    fPoints[i, 0] := 0.4 * Cos(j * PI / 6 - PI / 2);
    fPoints[i, 1] := 0.4 * Sin(j * PI / 6 - PI / 2);
    Inc(i);
    case j of
      0, 11:
        for k := 1 to 4 do
        begin
          fPoints[i, 0] := 0.4 * Cos(j * PI / 6 + k * PI / 30 - PI / 2);
          fPoints[i, 1] := 0.4 * Sin(j * PI / 6 + k * PI / 30 - PI / 2);
          Inc(i);
        end;
    end;
  end;

  fPosition := 15;

  Timer1.Enabled := TRUE;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cairo_destroy(fContext);
  cairo_surface_destroy(fSurface);
  fBitmap.Free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := FALSE;
  RedrawBitmap;
  PaintBox1.Canvas.Draw(0, 0, fBitmap);
  fPosition := Succ(fPosition) mod 20;
  Timer1.Enabled := TRUE;
end;

procedure TForm1.RedrawBitmap;
var
  i: integer;
begin
  with TCairoColor.Create(ColorToRGB(clForm)) do
    cairo_set_source_rgb(fContext, r, g, b);

  cairo_paint(fContext);

  with TCairoColor.Create(DarkIndigo) do
    cairo_set_source_rgb(fContext, r, g, b);

  for i := 0 to 5 do
  begin
    cairo_arc(
      fContext,
      fPoints[(fPosition + i) mod 20, 0],
      fPoints[(fPosition + i) mod 20, 1],
      0.02,
      0,
      2 * PI
    );
    cairo_fill(fContext);
  end;
end;

end.

