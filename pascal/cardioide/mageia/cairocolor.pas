
unit CairoColor;

{$MODE objfpc}
{$MODESWITCH advancedrecords}

interface

type
  TCairoColor = record
    r, g, b, a: double;
    constructor Create(const aColor: longword);
  end;

var
  darkblue, lightblue, white: TCairoColor;

implementation

constructor TCairoColor.Create(const aColor: longword);
begin
  a := (aColor and $FF000000) / $FF000000;
  r := (aColor and $00FF0000) / $00FF0000;
  g := (aColor and $0000FF00) / $0000FF00;
  b := (aColor and $000000FF) / $000000FF;
end;

initialization
  darkblue  := TCairoColor.Create($262F45);
  lightblue := TCairoColor.Create($2397D4);
  white     := TCairoColor.Create($FFFFFF);
{ https://wiki.mageia.org/en/Directives_pour_la_conception_graphique-fr#Palette_de_couleurs_officielle }
  
end.
