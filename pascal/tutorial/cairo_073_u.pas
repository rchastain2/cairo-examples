unit cairo_073_u;

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
    procedure RedrawBitmap;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  fBitmap := TBitmap.Create;
  fBitmap.SetSize(PaintBox1.Width, PaintBox1.Height);

  fSurface := cairo_win32_surface_create(fBitmap.Canvas.Handle);
  fContext := cairo_create(fSurface);
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
  Timer1.Enabled := TRUE;
end;

procedure TForm1.RedrawBitmap;
begin
  cairo_set_source_rgb(fContext, 0, 0, Random(100) / 100);
  cairo_paint(fContext);
end;

end.
