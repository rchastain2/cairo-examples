
uses
  Math;

const
  R6 = 0.32;
  X2 = -0.054712;
  
begin
  WriteLn('A1 = ', ArcCos( X2 / R6):0:6);
  WriteLn('A2 = ', ArcCos(-X2 / R6):0:6);
end.

{
  A1 = 1.742615
  A2 = 1.398977
}
