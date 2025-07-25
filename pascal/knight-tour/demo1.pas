
program demo1;

uses
  knight;

procedure PrintPath(const aPath: TVectorArray);
const
  NAMES: array[1..8, 1..8] of string[2] = (
    ('a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8'),
    ('b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7', 'b8'),
    ('c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8'),
    ('d1', 'd2', 'd3', 'd4', 'd5', 'd6', 'd7', 'd8'),
    ('e1', 'e2', 'e3', 'e4', 'e5', 'e6', 'e7', 'e8'),
    ('f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8'),
    ('g1', 'g2', 'g3', 'g4', 'g5', 'g6', 'g7', 'g8'),
    ('h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'h7', 'h8')
  );
  function PathToName(const i: integer): string;
  begin
    with aPath[i] do result := NAMES[x, y];
  end;
var
  i: integer;
  a, b: string;
begin
  a := PathToName(0);
  for i := 1 to High(aPath) do
  begin
    b := PathToName(i);
    WriteLn(a, b);
    a := b;
  end;
end;

var
  path: TVectorArray;

begin
  SetLength(path, 0);
  SearchPath(6, 5, path); // Recherche d'un chemin partant de la case F5
  if Length(path) > 0 then
    PrintPath(path);
  SetLength(path, 0);
end.
