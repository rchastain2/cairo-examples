
(*
  Chess Montreal by Gary Katch
  http://alcor.concordia.ca/~gpkatch/montreal_font.html
*)

uses
  Polices;

var
  gPosition: TPiecePlacement;
  
begin
  gPosition := StandardPosition;//EmptyPosition;
  WriteLn(HTMLHead, PositionToHtml(gPosition, AMChars), HTMLFoot);
end.
