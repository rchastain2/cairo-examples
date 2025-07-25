unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Spin,
  LazLogger, BGRABitmap, BGRABitmapTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    PBAnimation: TPaintBox;
    SEAngle: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PBAnimationPaint(Sender: TObject);
    procedure SEAngleChange(Sender: TObject);
  private
    FImages: array[0..35] of TBGRABitmap;
    FIndex: integer;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  Constants;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
const
  CImagePath = '..' + DirectorySeparator + 'images' + DirectorySeparator + Constants.FMT;
var
  i: integer;
  LImagePath: string;
begin
  for i := Low(FImages) to High(FImages) do
  begin
    FImages[i] := TBGRABitmap.Create(Constants.IW, Constants.IH, BGRAWhite);
    LImagePath := Format(CImagePath, [10 * i]);
    if FileExists(LImagePath) then
      FImages[i].LoadFromFile(LImagePath)
    else
      DebugLn('File not found: ' + LImagePath);
  end;
  FIndex := 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := Low(FImages) to High(FImages) do
  begin
    FImages[i].Free;
  end;
end;

procedure TForm1.PBAnimationPaint(Sender: TObject);
begin
  FImages[FIndex].Draw(PBAnimation.Canvas, 36, 36, FALSE);
end;

procedure TForm1.SEAngleChange(Sender: TObject);
begin
  if SEAngle.Value = 360 then
    SEAngle.Value := 0;
  FIndex := SEAngle.Value div 10;
  PBAnimation.Invalidate;
end;

end.

