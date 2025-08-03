
unit Eye;

interface

uses
  Color;

type
  TEye = class
    x, y, dx, dy, ix, iy, dix, diy, radius, irisRadius: double;
    irisColor: TColor;
    pupilDilation, blinkProgress: double;
    constructor Create(const x_, y_, radius_, irisRadius_: double; const irisColor_: TColor; const pupilDilation_: double);
    procedure Look(const x_, y_: integer);
    procedure Update(const dt: double);
  end;

implementation

uses
  Math;

(* ========================================================================== *)

function Angle(const x1, y1, x2, y2: double): double;
begin
	result := ArcTan2(y2 - y1, x2 - x1);
end;

function Distance(const x1, y1, x2, y2: double): double;
begin
	result := Sqrt(Sqr(x2 - x1) + Sqr(y2 - y1));
end;

function Normal(const val, min, max: double): double;
begin
	result := (val - min) / (max - min);
end;

(* ========================================================================== *)

constructor TEye.Create(const x_, y_, radius_, irisRadius_: double; const irisColor_: TColor; const pupilDilation_: double);
begin
  x := x_;
  y := y_;
  dx := x;
  dy := y;
  ix := x;
  iy := y;
  dix := x;
  diy := y;
  radius := radius_;
  irisRadius := irisRadius_;
  irisColor := irisColor_;
  pupilDilation := pupilDilation_;
  blinkProgress := 1;
end;

procedure TEye.Look(const x_, y_: integer);
var
  a, d: double;
begin
	a := Angle(x, y, x_, y_);
	d := Distance(x, y, x_, y_);
	if d > radius then d := radius;

	ix := x + (radius - irisRadius) * Normal(d, 0, radius) * Cos(a);
	iy := y + (radius - irisRadius) * Normal(d, 0, radius) * Sin(a);
end;

procedure TEye.Update(const dt: double);
begin
	dix := dix + (ix - dix) * 16 * dt;
	diy := diy + (iy - diy) * 16 * dt;
end;

(* ========================================================================== *)

end. 
