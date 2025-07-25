
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
    WriteLn('X1 = ', x1:0:6);
    WriteLn('X2 = ', x2:0:6);
  end;
end;

const
  R1 = 0.37;
  R6 = 0.32;
  
begin
  SolveQuadraticEquation(2, 2 * R1, R1 * R1 - R6 * R6);
end.

{
  X1 = -0.315288
  X2 = -0.054712
}
