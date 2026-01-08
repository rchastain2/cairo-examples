
{$mode objfpc}{$H+}

(*
  Chess Montreal by Gary Katch
  http://alcor.concordia.ca/~gpkatch/montreal_font.html
*)

uses
  ChessFonts;

var
  p: TPiecePlacement;
  
begin
  p := StandardPosition;
  WriteLn(
    HTMLHead,
    PositionToHtml(p, AMChars, 'chess alfonso-x', 'midnightblue', '32px'),
  //PositionToHtml(p, EBChars, 'chess alpha',     'midnightblue', '32px'),
    PositionToHtml(p, GKChars, 'chess montreal',  'midnightblue', '32px'),
    HTMLFoot);
end.
