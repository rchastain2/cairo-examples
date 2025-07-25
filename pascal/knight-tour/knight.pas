
unit knight;

{
  Knight's tour
  https://rosettacode.org/wiki/Knight%27s_tour#Lua
}

interface

type
  TVector = record
    x, y: integer;
  end;
  
  TVectorArray = array of TVector;

procedure SearchPath(const aX, aY: integer; var aPath: TVectorArray);

implementation

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
  
procedure SearchPath(const aX, aY: integer; var aPath: TVectorArray);
var
  board: TBoard;
  x, y: integer;
  i: integer;
begin
  for x := 1 to BOARDSIZE do
    for y := 1 to BOARDSIZE do
      board[x, y] := UNVISITED;

  x := aX;
  y := aY;
  
  SetLength(aPath, 1);
  aPath[0].x := x;
  aPath[0].y := y;
  
  repeat
    if TryNextMove(board, x, y) then
    begin
      Inc(board[x, y]);
      
      i := board[x, y];
      x := x + VECTORS[i].x;
      y := y + VECTORS[i].y;
      
      SetLength(aPath, Succ(Length(aPath)));
      aPath[High(aPath)].x := x;
      aPath[High(aPath)].y := y;
    end else
    begin
      if board[x, y] >= High(VECTORS) then
      begin
        board[x, y] := UNVISITED;
        
        SetLength(aPath, Pred(Length(aPath)));
        if Length(aPath) = 0 then
          Break;
        
        x := aPath[High(aPath)].x;
        y := aPath[High(aPath)].y;
      end;
      Inc(board[x, y]);   
    end
  until Length(aPath) = BOARDSIZE * BOARDSIZE;
end;

end.
