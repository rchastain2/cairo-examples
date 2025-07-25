
procedure SolveQuadraticEquation(const a, b, c: double);
var
  delta, x0, x1, x2: double;
begin
  delta := b * b - 4 * a * c;
  if delta < 0 then
    WriteLn('delta < 0')
  else if delta = 0 then
  begin
    x0 := -b / (2 * a);
    WriteLn('X0 = ', x0:0:6);
  end else
  begin
    x1 := (-b - Sqrt(delta)) / (2 * a);
    x2 := (-b + Sqrt(delta)) / (2 * a);
    WriteLn('Y3 = ', x1:0:6);
    WriteLn('Y4 = ', x2:0:6);
  end;
end;

const
  R8 = 0.30;
  X1 = 0.217417;
  Y1 = 0.686389;
  
begin
  SolveQuadraticEquation(1, -2 * Y1, X1 * X1 + Y1 * Y1 - R8 * R8);
end.

{
  Y3 = 0.479677
  Y4 = 0.893101
}
