unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  LazLogger, BGRABitmap, BGRABitmapTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    BTRoll: TButton;
    EDResult: TEdit;
    PBAnimation: TPaintBox;
    TMAnimation: TTimer;
    procedure BTRollClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PBAnimationPaint(Sender: TObject);
    procedure TMAnimationTimer(Sender: TObject);
  private
    FImages: array[0..35] of TBGRABitmap;
    FBuffer: TBGRABitmap;
    FIndex: integer;
    FTicks: integer;
    FInterval, FDeceleration: double;
    procedure PrintResult;
  end;

var
  Form1: TForm1;

implementation

uses
  Constants;

{$R *.lfm}

{ TForm1 }

procedure TForm1.PrintResult;
begin
  EDResult.Text := IntToStr(Succ(FIndex div 3));
end;

procedure TForm1.FormCreate(Sender: TObject);
const
  CImagePath = '..' + DirectorySeparator + 'images' + DirectorySeparator + Constants.FMT;
var
  LImagePath: string;
  i: integer;
begin
  for i := Low(FImages) to High(FImages) do
  begin
    FImages[i] := TBGRABitmap.Create(Constants.IW, Constants.IH);
    LImagePath := Format(CImagePath, [10 * i]);
    if FileExists(LImagePath) then
      FImages[i].LoadFromFile(LImagePath)
    else
      DebugLn('File not found: ' + LImagePath);
  end;
  FBuffer := TBGRABitmap.Create(Constants.IW + 32, Constants.IH + 32);
  FIndex := 0;
  PrintResult;
  Randomize;
end;

procedure TForm1.BTRollClick(Sender: TObject);
begin
  FTicks := Random(72) + 36;
  FInterval := 10.0;
  TMAnimation.Interval := Round(FInterval);
  TMAnimation.Enabled := TRUE;
  FDeceleration := 180 / FTicks;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := Low(FImages) to High(FImages) do
    FImages[i].Free;
  FBuffer.Free;
end;

procedure TForm1.PBAnimationPaint(Sender: TObject);
begin
  FBuffer.EraseRect(Rect(0, 0, 159, 159), 255);
  FBuffer.PutImage(16, 16, FImages[FIndex], dmSet);
  FBuffer.FillPolyAntialias([PointF(138, 80), PointF(152, 74), PointF(152, 86)], CssDarkRed);
  FBuffer.Draw(PBAnimation.Canvas, 18, 18, FALSE);
end;

procedure TForm1.TMAnimationTimer(Sender: TObject);
begin
  FIndex := (Findex + 1) mod 36;
  PrintResult;
  PBAnimation.Invalidate;
  Dec(FTicks);
  if FTicks = 0 then
    TMAnimation.Enabled := FALSE
  else
  begin
    FInterval := FInterval + FDeceleration;
    TMAnimation.Interval := Round(FInterval);
  end;
end;

end.

