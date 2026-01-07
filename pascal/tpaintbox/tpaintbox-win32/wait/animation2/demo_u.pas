unit demo_u;

{$MODE OBJFPC}{$H+}
{$ASSERTIONS ON}
{$HINTS OFF}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Cairo, CairoWin32, CairoColor in '..\cairocolor.pas';

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    type
      TCairoPoint = record
        x, y: double;
      end;
    var
    fBitmap: TBitmap;
    fWidth, fHeight: integer;
    fHour: integer;
    fSurface: pcairo_surface_t;
    fContext: pcairo_t;
    fColor, fBkColor: TCairoColor;
    fPoints: array[0..31] of TCairoPoint;
    procedure DrawToPaintBox;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{$I ..\colornames.inc}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Timer1.Enabled := TRUE;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i, j, k: integer;
begin
  fBitmap := TBitmap.Create;
  fWidth := PaintBox1.Width;
  fHeight := PaintBox1.Height;
  fBitmap.SetSize(fWidth, fHeight);
  fHour := 0;
  fSurface := cairo_win32_surface_create(fBitmap.Canvas.Handle);
  fContext := cairo_create(fSurface);
  cairo_scale(fContext, fWidth, fHeight);
  cairo_translate(fContext, 0.5, 0.5);
  cairo_set_line_width(fContext, 0.01);
  fColor.Create(SNOW);
  fBkColor.Create(MIDNIGHTBLUE);
  
  k := 0;
  for i := 0 to 11 do
    case i of
      4..7:
        for j := 0 to 3 do
        begin
          fPoints[k].x := 0.4 * Cos((PI / 6) * i + (PI / 24) * j - PI / 2);
          fPoints[k].y := 0.4 * Sin((PI / 6) * i + (PI / 24) * j - PI / 2);
          Inc(k);
        end;
      else
        for j := 0 to 1 do
        begin
          fPoints[k].x := 0.4 * Cos((PI / 6) * i + (PI / 12) * j - PI / 2);
          fPoints[k].y := 0.4 * Sin((PI / 6) * i + (PI / 12) * j - PI / 2);
          Inc(k);
        end;
    end;
  
  Assert(k = 32);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cairo_destroy(fContext);
  cairo_surface_destroy(fSurface);
  fBitmap.Destroy;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := FALSE;
  DrawToPaintBox;
  fHour := (fHour + 1) mod 32;
  Timer1.Enabled := TRUE;
end;

procedure TForm1.DrawToPaintBox;
var
  i: integer;
begin
  with fBkColor do
    cairo_set_source_rgba(fContext, r, g, b, 1.00);
  cairo_paint(fContext);

  with fColor do
    cairo_set_source_rgba(fContext, r, g, b, 1.00);
  for i := 0 to 7 do
  begin
    cairo_arc(
      fContext,
      fPoints[(fHour - i + 32) mod 32].x,
      fPoints[(fHour - i + 32) mod 32].y,
      0.02,
      0,
      2 * PI
    );

    cairo_fill(fContext);
  end;
  
  PaintBox1.Canvas.Draw(0, 0, fBitmap);
end;

end.
