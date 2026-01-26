unit geometry;

{$mode delphi}

interface

uses
  Classes, SysUtils;

function Tan(X: extended): extended;
function Hypot(X, Y: extended): extended;
function DegToRad(Degrees: extended): extended; { Radians := Degrees * PI / 180 }
function RadToDeg(Radians: extended): extended; { Degrees := Radians * 180 / PI }
function Tangens(Value: extended): extended;
function Sinus(E: extended): extended;
function CoSinus(E: extended): extended;
function arcTangens(x, y: extended): extended;

implementation

function Tan(X: extended): extended;
begin
  Tan := Sin(X) / Cos(X);
end;

function Hypot(X, Y: extended): extended;
var
  Temp: extended;
begin
  X := Abs(X);
  Y := Abs(Y);
  if X > Y then
  begin
    Temp := X;
    X := Y;
    Y := Temp;
  end;
  if X = 0 then
    result := Y
  else         // Y > X, X <> 0, so Y > 0
    result := Y * Sqrt(1 + Sqr(X / Y));
end;

function DegToRad(Degrees: extended): extended; { Radians := Degrees * PI / 180 }
begin
  result := Degrees * (PI / 180);
end;

function RadToDeg(Radians: extended): extended; { Degrees := Radians * 180 / PI }
begin
  result := Radians * (180 / PI);
end;

function Tangens(Value: extended): extended;
begin
  result := tan(degtorad(Value));
end;

function Sinus(E: extended): extended;
begin
  result := sin(degtorad(e));
end;

function CoSinus(E: extended): extended;
begin
  result := cos(degtorad(e));
end;

function arcTangens(x, y: extended): extended;
begin
  result := 0;
  if (x = 0) then
  begin
    if (Y >= 0) then
      result := 90;
    if (Y < 0) then
      result := 270;
  end
  else
  begin
    result := radtodeg(arctan(Y / X));
    if ((X < 0) and (y > 0)) or ((x < 0) and (Y <= 0)) then
      result := 180 + result;
    if (X > 0) and (Y < 0) then
      result := 360 + result;
  end;
end;

end.

