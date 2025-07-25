
uses
  Math;

const
  R3 = 0.72;
  R7 = 0.22;

var
  x, y: double;
  
begin
  y := (R7 * R7 - 2 * R3 * R3) / (-2 * R3);
  x := Sqrt(R3 * R3 - y * y);
  
  WriteLn('X1 = ', x:0:6);
  WriteLn('Y1 = ', y:0:6);
end.
{
  X1 = 0.217417
  Y1 = 0.686389
}
