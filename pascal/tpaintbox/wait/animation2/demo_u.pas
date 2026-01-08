unit demo_u;

{$MODE OBJFPC}{$H+}
{$ASSERTIONS ON}
{$HINTS OFF}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Cairo, CairoColor;

type

  { TForm1 }

  TForm1 = class(TForm)
    BT1: TButton;
    PB1: TPaintBox;
    TM1: TTimer;
    procedure BT1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TM1Timer(Sender: TObject);
  private
    { private declarations }
    type
      TCairoPoint = record
        x, y: double;
      end;
    var
    FBitmap: TBitmap;
    FWidth, FHeight: integer;
    FHour: integer;
    FSurf: pcairo_surface_t;
    FCairo: pcairo_t;
    FColor, FBkColor: TCairoColor;
    FPoints: array[0..31] of TCairoPoint;
    procedure DrawToPaintBox;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{$I colornames.inc}

{ TForm1 }

procedure TForm1.BT1Click(Sender: TObject);
const
  CCaption: array[boolean] of string = ('Start', 'Stop');
begin
  TM1.Enabled := not TM1.Enabled;
  BT1.Caption := CCaption[TM1.Enabled];
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i, j, k: integer;
begin
  FBitmap := TBitmap.Create;
  FWidth := PB1.Width;
  FHeight := PB1.Height;
  FBitmap.SetSize(FWidth, FHeight);
  FHour := 0;

{ https://www.lazarusforum.de/viewtopic.php?p=133936#p133936 }
  FSurf := cairo_image_surface_create_for_data(
    FBitmap.RawImage.Data,
    CAIRO_FORMAT_ARGB32,
    FBitmap.Width,
    FBitmap.Height,
    cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, FBitmap.Width)
  );
  FCairo := cairo_create(FSurf);
  cairo_scale(FCairo, FWidth, FHeight);
  cairo_translate(FCairo, 0.5, 0.5);
  cairo_set_line_width(FCairo, 0.01);
  FColor.Create(SNOW);
  FBkColor.Create(MIDNIGHTBLUE);
  
  k := 0;
  for i := 0 to 11 do
    case i of
      4..7:
        for j := 0 to 3 do
        begin
          FPoints[k].x := 0.4 * Cos((PI / 6) * i + (PI / 24) * j - PI / 2);
          FPoints[k].y := 0.4 * Sin((PI / 6) * i + (PI / 24) * j - PI / 2);
          Inc(k);
        end;
      else
        for j := 0 to 1 do
        begin
          FPoints[k].x := 0.4 * Cos((PI / 6) * i + (PI / 12) * j - PI / 2);
          FPoints[k].y := 0.4 * Sin((PI / 6) * i + (PI / 12) * j - PI / 2);
          Inc(k);
        end;
    end;
  
  Assert(k = 32);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cairo_destroy(FCairo);
  cairo_surface_destroy(FSurf);
  FBitmap.Destroy;
end;

procedure TForm1.TM1Timer(Sender: TObject);
begin
  TM1.Enabled := FALSE;
  DrawToPaintBox;
  FHour := (FHour + 1) mod 32;
  TM1.Enabled := TRUE;
end;

procedure TForm1.DrawToPaintBox;
var
  i: integer;
begin
  FBitmap.BeginUpdate;

  with FBkColor do
    cairo_set_source_rgba(FCairo, r, g, b, 1.00);
  cairo_paint(FCairo);

  with FColor do
    cairo_set_source_rgba(FCairo, r, g, b, 1.00);
  for i := 0 to 7 do
  begin
    cairo_arc(
      FCairo,
      FPoints[(FHour - i + 32) mod 32].x,
      FPoints[(FHour - i + 32) mod 32].y,
      0.02,
      0,
      2 * PI
    );

    cairo_fill(FCairo);
  end;

  FBitmap.EndUpdate;
  PB1.Canvas.Draw(0, 0, FBitmap);
end;

end.
