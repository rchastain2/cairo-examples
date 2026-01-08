
unit cairocolor;

{$MODE DELPHI}

interface

type
  TCairoColor = record
    r, g, b, a: double;
    constructor Create(const aColor: longword);
  end;

implementation

constructor TCairoColor.Create(const aColor: longword);
begin
  a := (aColor and $FF000000) / $FF000000;
  r := (aColor and $00FF0000) / $00FF0000;
  g := (aColor and $0000FF00) / $0000FF00;
  b := (aColor and $000000FF) / $000000FF;
end;

end.
