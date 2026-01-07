unit pendulum_u;

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
    fTime: double;
    fBitmap: TBitmap;
    fSurface: pcairo_surface_t;
    fContext: pcairo_t;
    procedure RedrawBitmap;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  CairoColor;

{$I colornames.inc}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  fBitmap := TBitmap.Create;
  fBitmap.SetSize(PaintBox1.Width, PaintBox1.Height);

  fSurface := cairo_win32_surface_create(fBitmap.Canvas.Handle);
  fContext := cairo_create(fSurface);
  cairo_scale(fContext, fBitmap.Width, 2 * fBitmap.Height);
  cairo_translate(fContext, 0.5, 0.1);
  
  fTime := 0;
  
  Timer1.Enabled := TRUE;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cairo_destroy(fContext);
  cairo_surface_destroy(fSurface);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := FALSE;
  RedrawBitmap;
  PaintBox1.Canvas.Draw(0, 0, fBitmap);
  fTime := fTime + 1 / 40;
  Timer1.Enabled := TRUE;
end;

procedure TForm1.RedrawBitmap;
const
  x = 0.0;
  y = 0.3;
begin
  with TCairoColor.Create({ColorToRGB(clForm)}Snow) do
    cairo_set_source_rgb(fContext, r, g, b);
  cairo_paint(fContext);
  
  cairo_save(fContext);
  cairo_rotate(fContext, Sin(fTime) * PI / 2);

  with TCairoColor.Create(MidnightBlue) do
    cairo_set_source_rgba(fContext, r, g, b, 0.5);

  cairo_set_line_width(fContext, 0.005);
  cairo_set_line_cap(fContext, CAIRO_LINE_CAP_ROUND);
  cairo_move_to(fContext, 0, 0);
  cairo_line_to(fContext, x, y);
  cairo_stroke(fContext);

  cairo_arc(fContext, x, y, 0.05, 0, 2 * PI);
  cairo_fill(fContext);

  cairo_restore(fContext);
end;

end.

