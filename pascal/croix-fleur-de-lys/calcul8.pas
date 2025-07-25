
uses
  Math;

const
  R5 = 0.20;
  X2 = 0.195421;
  Y2 = 0.427447;
  Y3 = 0.384895;
  Y4 = 0.469999;
  Y31 = 0.230558;
  Y41 = 0.392310;
  
begin
  WriteLn('A5 = ', ArcSin((Y4 - Y2) / R5):0:6);
  WriteLn('A6 = ', ArcSin((Y41 - Y2) / R5):0:6);
end.
{
  A5 = 0.214399
  A6 = -0.176602
}
