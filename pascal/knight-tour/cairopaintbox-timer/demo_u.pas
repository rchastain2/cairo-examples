unit demo_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Cairo,

  CairoLCL; { https://github.com/blikblum/luipack }

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CairoPaintBox1: TCairoPaintBox;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure CairoPaintBox1CreateContext(Sender: TObject);
    procedure CairoPaintBox1Draw(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    w, h: Integer;
    procedure DrawBoard;
    procedure DrawPath;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{
  Knight's tour
  https://rosettacode.org/wiki/Knight%27s_tour#Lua
}

type
  TVector = record
    x, y: integer;
  end;

  TVectorArray = array of TVector;

{ TForm1 }

const
  VECTORS: array[1..8] of TVector = (
    (x: +1; y: +2),
    (x: +2; y: +1),
    (x: +2; y: -1),
    (x: +1; y: -2),
    (x: -1; y: -2),
    (x: -2; y: -1),
    (x: -2; y: +1),
    (x: -1; y: +2)
  );

{
  . 8 . 1 .
  7 . . . 2
  . . N . .
  6 . . . 3
  . 5 . 4 .
}

  BOARDSIZE = 8;

type
  TBoard = array[1..BOARDSIZE, 1..BOARDSIZE] of integer;

const
  UNVISITED = 0;

function TryNextMove(const aBoard: TBoard; const x1, y1: integer): boolean;
var
  x2, y2: integer;
  i: integer;
begin
  if aBoard[x1, y1] >= High(VECTORS) then
    result := FALSE
  else
  begin
    i := Succ(aBoard[x1, y1]);
    x2 := x1 + VECTORS[i].x;
    y2 := y1 + VECTORS[i].y;
    result := (x2 >= 1) and (x2 <= BOARDSIZE) and (y2 >= 1) and (y2 <= BOARDSIZE) and (aBoard[x2, y2] = UNVISITED);
  end;
end;

var
  path: TVectorArray;
  board: TBoard;
  gX, gY: integer;

procedure TForm1.Button1Click(Sender: TObject);
var
  x, y: integer;
begin
  for x := 1 to BOARDSIZE do
    for y := 1 to BOARDSIZE do
      board[x, y] := UNVISITED;

  gX := 6;
  gY := 5;

  SetLength(path, 1);
  path[0].x := gX;
  path[0].y := gY;

  Timer1.Enabled := TRUE;
end;

procedure TForm1.CairoPaintBox1CreateContext(Sender: TObject);
begin
  with CairoPaintBox1.Context do
  begin
    Translate(0, h);
    Scale(w, -h);
  end;
end;

procedure TForm1.CairoPaintBox1Draw(Sender: TObject);
begin
  DrawBoard;
  if Length(path) > 0 then
    DrawPath;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  w := CairoPaintBox1.Width;
  h := CairoPaintBox1.Height;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  Timer1.Enabled := FALSE;

  if TryNextMove(board, gX, gY) then
  begin
    Inc(board[gX, gY]);

    i := board[gX, gY];
    gX := gX + VECTORS[i].x;
    gY := gY + VECTORS[i].y;

    SetLength(path, Succ(Length(path)));
    path[High(path)].x := gX;
    path[High(path)].y := gY;
  end else
  begin
    if board[gX, gY] >= High(VECTORS) then
    begin
      board[gX, gY] := UNVISITED;

      SetLength(path, Pred(Length(path)));
      if Length(path) = 0 then
        Exit;

      gX := path[High(path)].x;
      gY := path[High(path)].y;
    end;
    Inc(board[gX, gY]);
  end;

  CairoPaintBox1.Redraw;

  if Length(path) < BOARDSIZE * BOARDSIZE then
    Timer1.Enabled := TRUE;
end;

procedure TForm1.DrawBoard;
var
  x, y: integer;
begin
  with CairoPaintBox1.Context do
  begin
    SetSourceRgb(1.00, 0.65, 0.00);
    Paint;

    for x := 1 to 8 do
      for y := 1 to 8 do
        if (x + y) mod 2 = 0 then
        begin
          SetSourceRgb(1.00, 0.55, 0.00);
          Rectangle(Pred(x) / 8, Pred(y) / 8, 1 / 8, 1 / 8);
          Fill;
        end;
  end;
end;

procedure TForm1.DrawPath;
function
  F(const i: integer): double; inline; begin result := i / 8 - 1 / 16; end;
var
  i: integer;
begin
  with CairoPaintBox1.Context do
  begin
    LineWidth := 1 / 100;
    LineCap := CAIRO_LINE_CAP_ROUND;
    SetSourceRgb(1.00, 1.00, 0.00);

    MoveTo(
      F(path[0].x),
      F(path[0].y)
    );
    for i := 1 to High(path) do
      LineTo(
        F(path[i].x),
        F(path[i].y)
      );

    Stroke;
  end;
end;

end.

