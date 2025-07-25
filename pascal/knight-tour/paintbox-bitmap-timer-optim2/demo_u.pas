unit demo_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Cairo, CairoWin32;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    cr: pcairo_t;
    surface, surface2: pcairo_surface_t;
    bitmap: TBitmap;
    w, h, w8, h8: Integer;
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

procedure TForm1.FormCreate(Sender: TObject);
var
  x, y: integer;
begin
  w := PaintBox1.Width;
  h := PaintBox1.Height;

  w8 := w div 8;
  h8 := h div 8;

  bitmap := TBitmap.Create;
  bitmap.SetSize(w, h);

  surface := cairo_win32_surface_create(bitmap.Canvas.Handle);
  
  surface2 := cairo_image_surface_create_from_png('board.png');

  cr := cairo_create(surface);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cairo_destroy(cr);
  cairo_surface_destroy(surface);
  cairo_surface_destroy(surface2);
  bitmap.Destroy;
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

  DrawPath;

  if Length(path) < BOARDSIZE * BOARDSIZE then
    Timer1.Enabled := TRUE;
end;

procedure TForm1.DrawPath;
var
  x, y, i: integer;
begin
  cairo_set_source_surface(cr, surface2, 0, 0);
  cairo_paint(cr);

  cairo_set_line_width(cr, 1.5);
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);
  cairo_set_source_rgb(cr, 1.00, 1.00, 0.00);
  cairo_move_to(
    cr,
    w8 * (path[0].x - 0.5),
    h8 * (8.5 - path[0].y)
  );
  for i := 1 to High(path) do
    cairo_line_to(
      cr,
      w8 * (path[i].x - 0.5),
      h8 * (8.5 - path[i].y)
    );
  cairo_stroke(cr);

  PaintBox1.Canvas.Draw(0, 0, bitmap);
end;

end.

