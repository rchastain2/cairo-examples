unit demo_u;

{$mode objfpc}{$H+}

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
    FBitmap: TBitmap;
    FWidth, FHeight: integer;
    FHour: integer;
    FSurf: pcairo_surface_t;
    FCairo: pcairo_t;
    FColor, FBkColor: TCairoColor;
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
  cairo_translate(FCairo, 1 / 2, 1 / 2);
  cairo_set_line_width(FCairo, 1 / 16);
  FColor.Create(SNOW);
  FBkColor.Create(MIDNIGHTBLUE);
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
  FHour := (FHour + 1) mod 12;
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
  
  for i := 0 to 6 do
  begin
    with FColor do
      cairo_set_source_rgba(FCairo, r, g, b, 1 - i / 7);
    cairo_move_to(
      FCairo,
      0.2 * Cos((PI / 6) * (FHour - i)),
      0.2 * Sin((PI / 6) * (FHour - i))
    );
    cairo_line_to(
      FCairo,
      0.4 * Cos((PI / 6) * (FHour - i)),
      0.4 * Sin((PI / 6) * (FHour - i))
    );
    cairo_stroke(FCairo);
  end;
  
  FBitmap.EndUpdate;
  
  PB1.Canvas.Draw(0, 0, FBitmap);
end;

end.
