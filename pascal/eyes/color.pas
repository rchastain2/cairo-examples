
unit Color;

interface

type
  TColor = record
    r, g, b: double;
  end;

function RandomColor: TColor;

implementation

function RandomColor: TColor;
begin
  result.r := Random(256) / 255; 
  result.g := Random(256) / 255; 
  result.b := Random(256) / 255; 
end;

end. 
