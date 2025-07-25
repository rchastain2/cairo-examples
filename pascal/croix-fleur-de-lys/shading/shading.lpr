
program shading;

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
var
  bmp,
  result,
  aux: TBGRABitmap;
  i: integer;
  phong: TPhongShading;
begin
  bmp := TBGRABitmap.Create('image.png');
  result := TBGRABitmap.Create(400, 400, BGRAPixelTransparent);
  phong := TPhongShading.Create;

  phong.LightPositionZ := 150;
  phong.SpecularIndex := 20;
  phong.AmbientFactor := 0.4;
  phong.LightSourceIntensity := 250;
  phong.LightSourceDistanceTerm := 200;

  bmp.SaveToFile('1.png');

  bmp := bmp.FilterBlurRadial(5, rbfast) as TBGRABitmap;
  bmp.SaveToFile('2.png');

  aux := TBGRABitmap.Create('1.png');

  bmp.ApplyMask(aux, Rect(0, 0, 400, 400), Point(0, 0));
  bmp.SaveToFile('3.png');

  phong.LightPosition := Point(32, 32);
  phong.Draw(result, bmp, 20, 0, 0, BGRA(0, 0, 0));
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

