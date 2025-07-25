unit demo_u;

{$mode objfpc}{$H+}

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
    fBitmap: TBitmap;
    fWidth, fHeight: integer;
    fHour: integer;
    fSurface: pcairo_surface_t;
    fContext: pcairo_t;
    fColor, fBkColor: TCairoColor;
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
begin
  fBitmap := TBitmap.Create;
  fWidth := PaintBox1.Width;
  fHeight := PaintBox1.Height;
  fBitmap.SetSize(fWidth, fHeight);
  fHour := 0;
  fSurface := cairo_win32_surface_create(fBitmap.Canvas.Handle);
  fContext := cairo_create(fSurface);
  cairo_scale(fContext, fWidth, fHeight);
  cairo_translate(fContext, 1 / 2, 1 / 2);
  cairo_set_line_width(fContext, 1 / 16);
  fColor.Create(SNOW);
  fBkColor.Create(MIDNIGHTBLUE);
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
  fHour := (fHour + 1) mod 12;
  Timer1.Enabled := TRUE;
end;

procedure TForm1.DrawToPaintBox;
var
  i: integer;
begin
  with fBkColor do
    cairo_set_source_rgba(fContext, r, g, b, 1.00);
  cairo_paint(fContext);
  
  for i := 0 to 6 do
  begin
    with fColor do
      cairo_set_source_rgba(fContext, r, g, b, 1 - i / 7);
    cairo_move_to(
      fContext,
      0.2 * Cos((PI / 6) * (fHour - i)),
      0.2 * Sin((PI / 6) * (fHour - i))
    );
    cairo_line_to(
      fContext,
      0.4 * Cos((PI / 6) * (fHour - i)),
      0.4 * Sin((PI / 6) * (fHour - i))
    );
    cairo_stroke(fContext);
  end;
  
  PaintBox1.Canvas.Draw(0, 0, fBitmap);
end;

end.
