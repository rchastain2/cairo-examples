
program horse4;

{$MODE OBJFPC}{$H+}

uses
  Classes, SysUtils, CustApp,
  BGRAGraphics, BGRABitmap, BGRABitmapTypes, BGRAGradients;

(* http://wiki.freepascal.org/BGRABitmap_tutorial_9/fr *)

type
  TTestBGRANoGui = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure TTestBGRANoGui.DoRun;
{$I horse}
const
  CORRECTION_X = 0.428;
  CORRECTION_Y = -0.7;
  CX = 3 * 128 / 2;
  RX = 3 * 127 / 2;
  CY = CX;
  RY = RX;
var
  bmp,
  result,
  aux: TBGRABitmap;
  scaled: array of TPointF;
  i: integer;
  phong: TPhongShading;
begin
  bmp := TBGRABitmap.Create(3 * 128, 3 * 128, BGRABlack);
  result := TBGRABitmap.Create(3 * 128, 3 * 128, BGRAPixelTransparent);
  phong := TPhongShading.Create;

  phong.LightPositionZ := 150;
  phong.SpecularIndex := 20;
  phong.AmbientFactor := 0.4;
  phong.LightSourceIntensity := 250;
  phong.LightSourceDistanceTerm := 200;

  (*
  bmp.FillEllipseAntialias(CX, CY, RX, RY, BGRAWhite);
  bmp.EllipseAntialias(CX, CY, RX, RY, BGRA(128, 128, 128, 255), 2);
  *)

  SetLength(scaled, Length(HORSE));
  for i := Low(HORSE) to High(HORSE) do
    scaled[i - 1] := PointF(
      ((HORSE[i].x + CORRECTION_X) * bmp.Width) / 30,
      bmp.Height - (((HORSE[i].y + CORRECTION_Y) * 2 * 128) / 20) - 64
      );
  bmp.FillPolyAntialias(scaled, BGRAWhite);

  (*
  SetLength(scaled, Length(PEDESTAL));
  for i := Low(PEDESTAL) to High(PEDESTAL) do
    scaled[i - 1] := PointF(
      ((PEDESTAL[i].x + CORRECTION_X) * bmp.Width) / 30,
      bmp.Height - (((PEDESTAL[i].y + CORRECTION_Y) * 2 * 128) / 20) - 64
      );
  bmp.FillPolyAntialias(scaled, BGRABlack);
  *)

  SetLength(scaled, 0);

  bmp.SaveToFile('1.png');

  bmp := bmp.FilterBlurRadial(5, rbfast) as TBGRABitmap;
  bmp.SaveToFile('2.png');

  aux := TBGRABitmap.Create('1.png');

  bmp.ApplyMask(aux, Rect(0, 0, 384, 384), Point(0, 0));
  bmp.SaveToFile('3.png');

  phong.LightPosition := point(32, 32);
  phong.Draw(result, bmp, 20, 0, 0, BGRA(0,0,0));
  result.SaveToFile('4.png');

  bmp.Free;
  result.Free;
  aux.Free;
  phong.Free;

  Terminate;
end;

constructor TTestBGRANoGui.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

destructor TTestBGRANoGui.Destroy;
begin
  inherited Destroy;
end;

var
  Application: TTestBGRANoGui;

begin
  Application := TTestBGRANoGui.Create(nil);
  Application.Title := 'TestBGRANoGui';
  Application.Run;
  Application.Free;
end.

