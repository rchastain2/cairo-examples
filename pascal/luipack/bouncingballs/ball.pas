
unit ball;

interface

uses
  Classes, Graphics, CairoLCL, CairoClasses;

type
  TFPoint = record
    x, y: single;
  end;

  TCairoColor = record
    r, g, b: double;
  end;

  TBall = class
  private
    FVecX, FVecY, FX, FY, FRadius, FMass: single;
    FColor: TCairoColor;
    function GetPos: TFPoint;
    procedure SetPos(APos: TFPoint);
    function GetSpeed: TFPoint;
    procedure SetSpeed(ASpeed: TFPoint);
  public
    property Color: TCairoColor read FColor write FColor;
    property Radius: single read FRadius;
    property Position: TFPoint read GetPos write SetPos;
    property SpeedVektor: TFPoint read GetSpeed write SetSpeed;
    property Mass: single read FMass write FMass;
    constructor Create(Position, SpeedVektor: TFPoint; Radius, Mass: single);
    destructor Destroy; override;
    procedure Render(const APaintBox: TCairoPaintBox);
    procedure CalculateMass;
    procedure BorderCollision(CollisionRect: TRect; InsideCollision: boolean = True);
    procedure Collision(const ABall: TBall);
    procedure Move;
  end;

function Point(x, y: single): TFPoint;
function Rect(ALeft, ATop, ARight, ABottom: integer): TRect;

implementation

uses
  Geometry;

function Point(x, y: single): TFPoint;
begin
  result.x := x;
  result.y := y;
end;

function Rect(ALeft, ATop, ARight, ABottom: integer): TRect;
begin
  with result do
  begin
    Left   := ALeft;
    Right  := ARight;
    Top    := ATop;
    Bottom := ABottom;
  end;
end;

constructor TBall.Create(Position, SpeedVektor: TFPoint; Radius, Mass: single);
begin
  inherited Create;
  FColor.r := (Random(192) + 64) / 255; // Zufällige Farbe für unsere Kugel.
  FColor.g := (Random(192) + 64) / 255;
  FColor.b := (Random(192) + 64) / 255;
  FX := Position.x;
  FY := Position.y;
  FRadius := Radius;
  FMass := Mass;
  FVecX := SpeedVektor.x;
  FVecY := SpeedVektor.y;
end;

destructor TBall.Destroy;
begin
  inherited Destroy;
end;

function TBall.GetPos: TFPoint;
begin
  result.x := FX;
  result.y := FY;
end;

procedure TBall.SetPos(APos: TFPoint);
begin
  FX := APos.x;
  FY := APos.y;
end;

function TBall.GetSpeed: TFPoint;
begin
  result.x := FVecX;
  result.y := FVecY;
end;

procedure TBall.SetSpeed(ASpeed: TFPoint);
begin
  FVecX := ASpeed.x;
  FVecY := ASpeed.y;
end;

procedure TBall.move;
begin
  FX := FX + FVecX;
  FY := FY + FVecY;
end;

procedure Tausche(var i, j: integer);
var
  k: integer;
begin
  k := i;
  i := j;
  j := k;
end;

function EllipseRechteckcollision(e1, r1: TRect): boolean;
type
  TPunkt = record
    x, y: extended;
  end;
var
  sn1, sn2, x, alpha: extended;
  p1, p2: TPoint;
  n1, n2: TPunkt;
  radius1, radius2: integer;
begin
  result := False;
  if e1.Left > e1.Right  then Tausche(e1.Left, e1.Right);
  if e1.Top  > e1.Bottom then Tausche(e1.Top,  e1.Bottom);
  if r1.Left > r1.Right  then Tausche(r1.Left, r1.Right);
  if r1.Top  > r1.Bottom then Tausche(r1.Top,  r1.Bottom);
  p1.x := e1.Left + (e1.Right  - e1.Left) div 2;
  p1.y := e1.Top  + (e1.Bottom - e1.Top)  div 2;
  p2.x := r1.Left + (r1.Right  - r1.Left) div 2;
  p2.y := r1.Top  + (r1.Bottom - r1.Top)  div 2;
  alpha := ArcTangens(p1.x - p2.x, p1.y - p2.y);
  x := Hypot(p1.x - p2.x, p1.y - p2.y);
  radius1 := p1.x - e1.Left;
  radius2 := p1.y - e1.Top;
  n1.x := Cosinus(alpha) * radius1 + p1.x;
  n1.y := Sinus(alpha)   * radius2 + p1.y;
  sn1 := Hypot(p1.x - n1.x, p1.y - n1.y);
  case Round(alpha) of
      0.. 45: begin n2.x := r1.Right;  n2.y := Round(Tangens(alpha)       * ((r1.Bottom - p2.y) / 2)) + p2.y; end;
     46.. 90: begin n2.y := r1.Top;    n2.x := Round(Tangens(alpha - 45)  * ((r1.Right  - p2.x) / 2)) + p2.x; end;
     91..135: begin n2.y := r1.Top;    n2.x := Round(Tangens(alpha - 90)  * ((r1.Right  - p2.x) / 2)) + p2.x; end;
    136..225: begin n2.x := r1.Left;   n2.y := Round(Tangens(alpha)       * ((r1.Bottom - p2.y) / 2)) + p2.y; end;
    226..270: begin n2.y := r1.Bottom; n2.x := Round(Tangens(alpha - 225) * ((r1.Right  - p2.x) / 2)) + p2.x; end;
    271..315: begin n2.y := r1.Bottom; n2.x := Round(Tangens(alpha - 270) * ((r1.Right  - p2.x) / 2)) + p2.x; end;
    316..360: begin n2.x := r1.Right;  n2.y := Round(Tangens(alpha)       * ((r1.Bottom - p2.y) / 2)) + p2.y; end;
  end;
  sn2 := Hypot(p2.x - n2.x, p2.y - n2.y);
  if x <= sn1 + sn2 then
    result := True;
end;

procedure TBall.BorderCollision(CollisionRect: TRect; InsideCollision: boolean = True);
begin
  if Insidecollision then
  begin // Bedeutet die Kugel befindet sich inherhalt des Rechtecks
    if ((FX - FRadius < CollisionRect.Left)   and (FVecX < 0))
    or ((FX + FRadius > CollisionRect.Right)  and (FVecX > 0)) then
      FVecX := -FVecX;
    if ((FY - FRadius < CollisionRect.Top)    and (FVecY < 0))
    or ((FY + FRadius > CollisionRect.Bottom) and (FVecY > 0)) then
      FVecY := -FVecY;
  end else
  begin // Bedeutet die Kugel befindet sich auserhalb des Rechtecks
    if EllipseRechteckcollision(rect(Round(FX - FRadius), Round(FY - FRadius),
      Round(FX + FRadius), Round(FY + FRadius)), CollisionRect) then
    begin
      if ((FY < CollisionRect.Top)    and (FVecY > 0))
      or ((FY > CollisionRect.Bottom) and (FVecY < 0)) then
        FVecY := -FVecY;
      if ((FX < CollisionRect.Left)   and (FVecX > 0))
      or ((FX > CollisionRect.Right)  and (FVecX < 0)) then
        FVecX := -FVecX;
    end;
  end;
end;

procedure TBall.Collision(const ABall: TBall);
var
  dx, dy, dxs, dys, l, // Die Variablen für den Abstand der beiden Kugeln
  m1, m2, m3, m4, // Die Variablen der Transformationsmatrix
  vp1, vp2, vs1, vs2, mtot, vp3, vp4: single;
  p: TFPoint;
begin
  p := ABall.Position; // Hohlen der position der anderen Kugel
  dx := p.x - FX; // Delta x
  dy := p.y - FY; // Delta y
  dxs := dx * dx; // Da wir ein wenig Zeitoptimiert arbeiten wollen speichern wir und die Quadrate zwischen
  dys := dy * dy; // Da wir ein wenig Zeitoptimiert arbeiten wollen speichern wir und die Quadrate zwischen
  l := FRadius + ABall.Radius; // die Strecke der beiden Radien Addiert
  // da l * l bestimmt schneller ist wie Wurzel ziehen machen wir das so, unter der Annahme das es möglichst selten eine Kollision gibt.
  // Im anderen Fall wäre die Berechnung von l vor dem If und dem Vergleich auf tr schneller.
  if dxs + dys <= l * l then
  begin
    l := Sqrt(dxs + dys); // Abstand
    // Berechnen der Transformationsmatrix
    m1 :=      dx / l;
    m3 := -1 * dy / l;
    m2 :=      dy / l;
    m4 :=      dx / l;
    // Koordinatentransformation teil 1
    p := ABall.SpeedVektor;
    vp1 := FVecX * m1 + FVecY * -1 * m3;
    vp2 := p.x * m1 + p.y * -1 * m3;
    if vp1 - vp2 < 0 then
      Exit; // Bälle gehen bereits auseinander, dann Exit
    // Koordinatentransformation teil 2 , aus Optimierungsgründen hinter dem Exit.
    vs1 := FVecX * -1 * m2 + FVecY * m4;
    vs2 := p.x * -1 * m2 + p.y * m4;
    // das Verwurschteln der Massen
    mtot := FMass + ABall.Mass;
    vp3 := (FMass - ABall.Mass) / mtot * vp1 + 2 * ABall.Mass / mtot * vp2;
    vp4 := (ABall.Mass - FMass) / mtot * vp2 + 2 * FMass / mtot * vp1;
    // Rücktransformation
    FVecX := vp3 * m1 + vs1 * m3;
    FVecY := vp3 * m2 + vs1 * m4;
    p := Point(vp4 * m1 + vs2 * m3, vp4 * m2 + vs2 * m4);
    ABall.SpeedVektor := p;
  end;
end;

procedure TBall.CalculateMass;
begin
  FMass := 4 / 3 * FRadius * FRadius * FRadius * pi;
end;

procedure TBall.Render(const APaintBox: TCairoPaintBox);
begin
  with APaintBox.Context do
  begin
    SetSourceRgb(FColor.r, FColor.g, FColor.b);
    Arc(FX, FY, FRadius, 0, 2 * PI);
    StrokePreserve;
    Fill;
  end;
end;

end.
