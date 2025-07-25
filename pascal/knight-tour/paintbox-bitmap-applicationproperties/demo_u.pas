unit demo_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Cairo, CairoWin32;

type

  { TForm1 }

  TForm1 = class(TForm)
    ApplicationProperties1: TApplicationProperties;
    Button1: TButton;
    PaintBox1: TPaintBox;
    procedure ApplicationProperties1Idle(Sender: TObject; var Done: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
    fStop: boolean;
    cr: pcairo_t;
    surface: pcairo_surface_t;
    bitmap: TBitmap;
    w, h: Integer;
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

  fStop := FALSE;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  fStop := TRUE;

  w := PaintBox1.Width;
  h := PaintBox1.Height;

  bitmap := TBitmap.Create;
  bitmap.SetSize(w, h);

  surface := cairo_win32_surface_create(bitmap.Canvas.Handle);

  cr := cairo_create(surface);

  cairo_translate(cr, 0, h);
  cairo_scale(cr, w, -h);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cairo_destroy(cr);
  cairo_surface_destroy(surface);
  bitmap.Destroy;
end;

procedure TForm1.ApplicationProperties1Idle(Sender: TObject; var Done: Boolean);
var
  i: integer;
begin
  Done := FALSE;

  if not fStop then
  begin
    fStop := TRUE;

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

    DrawPath;

    if Length(path) < BOARDSIZE * BOARDSIZE then
      fStop := FALSE;
  end;

  Sleep(1);
end;

procedure TForm1.DrawPath;

  function F(const i: integer): double; inline;
  begin
    result := i / 8 - 1 / 16;
  end;

var
  x, y, i: integer;
begin
  cairo_set_source_rgb(cr, 1.00, 0.65, 0.00);

  cairo_paint(cr);

  cairo_set_source_rgb(cr, 1.00, 0.55, 0.00);

  for x := 1 to 8 do for y := 1 to 8 do
    if (x + y) mod 2 = 0 then
    begin
      cairo_rectangle(cr, Pred(x) / 8, Pred(y) / 8, 1 / 8, 1 / 8);
      cairo_fill(cr);
    end;

  cairo_set_line_width(cr, 1 / 100);
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);
  cairo_set_source_rgb(cr, 1.00, 1.00, 0.00);

  cairo_move_to(
    cr,
    F(path[0].x),
    F(path[0].y)
  );
  for i := 1 to High(path) do
    cairo_line_to(
      cr,
      F(path[i].x),
      F(path[i].y)
    );
  cairo_stroke(cr);

  PaintBox1.Canvas.Draw(0, 0, bitmap);
end;

end.

