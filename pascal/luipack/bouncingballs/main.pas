
unit main;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, LCLType,
  CairoLCL, CairoClasses;

type

  { TForm1 }

  TForm1 = class(TForm)
    CairoPaintBox1: TCairoPaintBox;
    IdleTimer1: TIdleTimer;
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure Render;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses
  Ball;

{$R *.lfm}

var
  LBalls: array of TBall;
  //LInitialized: boolean = False;

procedure TForm1.Render;
var
  i, j: integer;
begin
  // Wenn noch nicht initialisiert ist passiert auch nichts.
  (*
  if not LInitialized then
    Exit;
  *)
  // Bildschirm löschen.
  with CairoPaintBox1.Context do
  begin
    SetSourceRgb(0.1, 0.1, 0.1);
    Rectangle(0, 0, Width, Height);
    Fill;
  end;

  // Rendern der Einzelkugeln.
  for i := 0 to High(LBalls) do
    LBalls[i].Render(CairoPaintBox1);

  // Neuzeichnen des Formulars.
  CairoPaintBox1.Invalidate;

  // Bewegen der einzelnen Kugeln.
  for i := 0 to High(LBalls) do
    LBalls[i].Move;

  // Kollision der Kugeln untereinander.
  for i := 0 to High(LBalls) do
    for j := i + 1 to High(LBalls) do
      LBalls[i].Collision(LBalls[j]);

  // Collision mit den Wänden.
  for i := 0 to High(LBalls) do
    LBalls[i].BorderCollision(ClientRect);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  i: integer;
  LPoint: TFPoint;
begin
  case Key of
    VK_ESCAPE: Close;
    VK_ADD:
      for i := 0 to High(LBalls) do
        if Assigned(LBalls[i]) then
        begin
          LPoint := LBalls[i].SpeedVektor;
          LPoint.x := LPoint.x * 2;
          LPoint.y := LPoint.y * 2;
          LBalls[i].SpeedVektor := LPoint;
        end;
    VK_SUBTRACT:
      for i := 0 to High(LBalls) do
        if Assigned(LBalls[i]) then
        begin
          LPoint := LBalls[i].SpeedVektor;
          LPoint.x := LPoint.x / 2;
          LPoint.y := LPoint.y / 2;
          LBalls[i].SpeedVektor := LPoint;
        end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i, w, h: integer;
begin
  Randomize;
  Top := 0;
  Left := 0;
  Width := Screen.Width;
  Height := Screen.Height;
  BorderStyle := bsNone;

  CairoPaintBox1.Left := 0;
  CairoPaintBox1.Top := 0;
  CairoPaintBox1.Width := ClientWidth;
  CairoPaintBox1.Height := ClientHeight;

  SetLength(LBalls, 10);
  for i := 0 to High(LBalls) do
  begin
    LBalls[i] := TBall.Create(Point(0, 0), Point(0, 0), 20 + Random(40), 0);
    LBalls[i].CalculateMass;
  end;
  w := Width div 5;
  h := Height div 4;
  LBalls[0].position := Point(w, h * 2);
  LBalls[1].Position := Point(w * 2, h);
  LBalls[2].Position := Point(w * 3, h);
  LBalls[3].Position := Point(w * 4, h);
  LBalls[4].Position := Point(w * 2, h * 2);
  LBalls[5].Position := Point(w * 3, h * 2);
  LBalls[6].Position := Point(w * 4, h * 2);
  LBalls[7].Position := Point(w * 2, h * 3);
  LBalls[8].Position := Point(w * 3, h * 3);
  LBalls[9].Position := Point(w * 4, h * 3);
  // Die Richtung für unseren StarBall setzen
  LBalls[0].SpeedVektor := Point(Cos((-45) * Pi / 180) * 4, Sin(-45 * Pi / 180) * 4);
  //LInitialized := True;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  //LInitialized := False;
  for i := 0 to High(LBalls) do
    LBalls[i].Free;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  IdleTimer1.Enabled := TRUE;
end;

procedure TForm1.IdleTimer1Timer(Sender: TObject);
begin
  Render;
end;

end.
