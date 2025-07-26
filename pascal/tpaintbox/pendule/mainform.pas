unit mainform;

interface

uses
  Classes, SysUtils, Graphics, Forms, Controls, ExtCtrls, LCLType, Cairo;

type

  { TForm1 }

  TForm1 = class(TForm)
    PB: TPaintBox;
    TM: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure PBPaint(Sender: TObject);
    procedure TMTimer(Sender: TObject);
  private
    FBackground: pcairo_surface_t;
    procedure DrawAnimation(const AStaticImage: pcairo_surface_t; const AAngle: double);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

const
  CFormat: cairo_format_t = CAIRO_FORMAT_ARGB32;
  CLineWidth = 1 / 500;
  CAngle360 = PI * 2;
  CAngle90 = PI / 2;

function CreateBackground(const AWidth, AHeight: integer): pcairo_surface_t;
begin
  result := cairo_image_surface_create_from_png('nuages.png');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := 'Cairo ' + cairo_version_string;
  FBackground := CreateBackground(PB.Width, PB.Height);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cairo_surface_destroy(FBackground);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Ord(Key) = VK_ESCAPE then
  begin
    TM.Enabled := FALSE;
    Close;
  end;
end;

procedure TForm1.DrawAnimation(const AStaticImage: pcairo_surface_t; const AAngle: double);
var
  srf: pcairo_surface_t;
  ctx: pcairo_t;
  bmp: TBitmap;
  x, y: single;
begin
  bmp := TBitmap.Create;
  bmp.SetSize(PB.Width, PB.Height);
  bmp.BeginUpdate;

  srf := cairo_image_surface_create_for_data(
    bmp.RawImage.Data,
    CFormat,
    bmp.Width,
    bmp.Height,
    cairo_format_stride_for_width(CFormat, bmp.Width)
  );

  ctx := cairo_create(srf);

  cairo_set_source_surface(ctx, AStaticImage, 0, 0);
  cairo_paint(ctx);

  cairo_scale(ctx, bmp.Height, bmp.Height);

  x := 1 / 2;
  y := 1 / 4;

  x := x * (bmp.Width / bmp.Height);

  cairo_translate(ctx, x, y);

  cairo_set_line_width(ctx, CLineWidth);
  cairo_set_source_rgb(ctx, 0.0, 0.0, 0.0);
  cairo_arc(ctx, 0, 0, 1 / 100, 0, CAngle360);
  cairo_fill(ctx);

  x := 0;
  y := 1 / 2;

  cairo_rotate(ctx, Sin(AAngle) * CAngle90);

  cairo_move_to(ctx, 0, 0);
  cairo_line_to(ctx, x, y);
  cairo_stroke(ctx);

  cairo_arc(ctx, x, y, 1 / 30, 0, CAngle360);
  cairo_set_line_width(ctx, 1 / 100);
  cairo_stroke_preserve(ctx);
  cairo_set_source_rgb(ctx, 0.8, 0.8, 0.8);
  cairo_fill(ctx);

  cairo_destroy(ctx);

  bmp.EndUpdate;

  PB.Canvas.Draw(0, 0, bmp);

  cairo_surface_destroy(srf);

  bmp.Free;
end;

procedure TForm1.PBPaint(Sender: TObject);
begin
  DrawAnimation(FBackground, GetTickCount64 / 1000);
end;

procedure TForm1.TMTimer(Sender: TObject);
begin
  PB.Invalidate;
end;

end.
