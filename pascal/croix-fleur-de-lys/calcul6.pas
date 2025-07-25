
uses
  Math;

const
  R2 = 0.47;
  R5 = 0.20;

var
  x, y: double;
  
begin
  y := (R5 * R5 - 2 * R2 * R2) / (-2 * R2);
  x := Sqrt(R2 * R2 - y * y);
  
  WriteLn('X2 = ', x:0:6);
  WriteLn('Y2 = ', y:0:6);
end.
{
  X2 = 0.195421
  Y2 = 0.427447
}
