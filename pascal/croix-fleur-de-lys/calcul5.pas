
uses
  Math;

const
  R8 = 0.30;
  X1 = 0.217417;
  Y1 = 0.686389;
  Y3 = 0.479677;
  Y4 = 0.893101;
  
begin
  WriteLn('A3 = ', ArcSin((Y3 - Y1) / R8):0:6);
  WriteLn('A4 = ', ArcSin((Y4 - Y1) / R8):0:6);
end.
{
  A3 = -0.760164
  A4 =  0.760164
}
