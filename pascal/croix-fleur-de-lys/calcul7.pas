
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
  R5 = 0.20;
  X2 = 0.195421;
  Y2 = 0.427447;
  
begin
  SolveQuadraticEquation(1, -2 * Y2, X2 * X2 + Y2 * Y2 - R5 * R5);
  SolveQuadraticEquation(2, -2 * (X2 + Y2), X2 * X2 + Y2 * Y2 - R5 * R5);
end.

{
  Y3 = 0.384895
  Y4 = 0.469999
  Y3 = 0.230558
  Y4 = 0.392310
}
