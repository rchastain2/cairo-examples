
unit Eye;

interface

uses
{$IFDEF USE_CAIRO}
  Cairo,
{$ENDIF}
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
  
  TMood = (mHappy, mConcerned, mSad);

function Angle(const x1, y1, x2, y2: double): double;
function Distance(const x1, y1, x2, y2: double): double;
function Normal(const val, min, max: double): double;

const
  SURFACE_WIDTH = 800;
  SURFACE_HEIGHT = 600;
  RADIUS = 32;
  SPACE = 50;

const
  rSkin = 232 / 255;
  gSkin = 209 / 255;
  bSkin = 171 / 255;

var
  eyes: array[0..1] of TEye;

{$IFDEF USE_CAIRO}
function StaticSurface(const AWidth, AHeight: integer): pcairo_surface_t;
procedure Draw_(cr: pcairo_t; const AStatic: pcairo_surface_t; const AMouseX, AMouseY: integer; const AMood: TMood; const ABlink: double; const AWidth, AHeight: integer);
{$ENDIF}

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

{$IFDEF USE_CAIRO}
function StaticSurface(const AWidth, AHeight: integer): pcairo_surface_t;
var
  cr: pcairo_t;
  i: integer;
begin
  result := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, AWidth, AHeight);
  cr := cairo_create(result);
  
  cairo_set_source_rgb(cr, 0.2, 0.2, 0.2);
  cairo_paint(cr);
  
  (* Visage *)
  
  cairo_arc(cr, AWidth / 2, AHeight / 2, 4 * RADIUS, 0, 2 * PI);
  cairo_set_source_rgb(cr, rSkin, gSkin, bSkin);
  cairo_fill(cr);
  
  (* Blanc des yeux *)
  
  for i := 0 to 1 do
  begin
    cairo_arc(cr, eyes[i].x, eyes[i].y, eyes[i].radius, 0, 2 * PI);
    cairo_set_source_rgb(cr, 1.0, 1.0, 1.0);
    cairo_fill(cr);
  end;
  
  cairo_destroy(cr);
end;

procedure Draw_(cr: pcairo_t; const AStatic: pcairo_surface_t; const AMouseX, AMouseY: integer; const AMood: TMood; const ABlink: double; const AWidth, AHeight: integer);
var
  i: integer;
begin
  (* Fond *)
  
  cairo_set_source_surface(cr, AStatic, 0, 0);
  cairo_paint(cr);
  
  (* Yeux *)
  
  for i := 0 to 1 do
  begin
    (* Iris *)
    cairo_arc(cr, eyes[i].dix, eyes[i].diy, eyes[i].irisRadius, 0, 2 * PI);
    with eyes[i].irisColor do cairo_set_source_rgb(cr, r, g, b);
    cairo_fill(cr);
    
    (* Pupille *)
    cairo_arc(cr, eyes[i].dix, eyes[i].diy, eyes[i].irisRadius * eyes[i].pupilDilation, 0, 2 * PI);
    cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
    cairo_fill(cr);
  end;
  
  (* Clignement *)
  
  cairo_rectangle(cr, AWidth / 2 - SPACE - RADIUS, AHeight / 2 - RADIUS, (RADIUS + SPACE) * 2, RADIUS * 3 * ABlink);
  cairo_set_source_rgb(cr, rSkin, gSkin, bSkin);
  cairo_fill(cr);
  
  (* Bouche *)
  
  cairo_save(cr);
  
  case AMood of
    mHappy:
      begin
        cairo_translate(cr, AWidth / 2, AHeight * 0.58);
        cairo_scale(cr, RADIUS, RADIUS * 1.5);
        cairo_arc(cr, 0.0, 0.0, 1.0, 0, PI);
      end;
    mConcerned:
      begin
        cairo_translate(cr, AWidth / 2, AHeight * 0.62);
        cairo_scale(cr, RADIUS, RADIUS / 2);
        cairo_arc(cr, 0.0, 0.0, 1.0, 0, 2 * PI);
      end;
    mSad:
      begin
        cairo_translate(cr, AWidth / 2, AHeight * 0.65);
        cairo_scale(cr, RADIUS, RADIUS * 1.5);
        cairo_arc(cr, 0.0, 0.0, 1.0, PI, 2 * PI);
      end;
  end;
  
  cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
  cairo_fill(cr);
  cairo_restore(cr);
  
  (* Objet *)
  
  cairo_set_source_rgb(cr, 1, 0, 0);
  cairo_arc(cr, AMouseX, AMouseY, 5, 0, 2 * PI);
  cairo_fill(cr);
end;
{$ENDIF}

(* ========================================================================== *)

var
  LColor: TColor;

initialization
  LColor := RandomColor;
  eyes[0] := TEye.Create(SURFACE_WIDTH div 2 - SPACE, SURFACE_HEIGHT div 2, RADIUS, RADIUS div 2, LColor, 0.4);
  eyes[1] := TEye.Create(SURFACE_WIDTH div 2 + SPACE, SURFACE_HEIGHT div 2, RADIUS, RADIUS div 2, LColor, 0.4);
  
finalization
  eyes[0].Free;
  eyes[1].Free;
  
end. 
