
program BouncingBalls;

{
  Bouncing balls for ptcGraph and Cairo.
  
  Original program:
    https://corpsman.de/index.php?doc=beispiele/pingpong
    https://github.com/PascalCorpsman/mini_projects/tree/main/miniprojects/PingPong
}

uses
{$IFDEF unix}
  CThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Cairo, Classes, Image, Ball;

(*
procedure Draw(var AImage: TImage);
var
  sf: pcairo_surface_t;
  cr: pcairo_t;
begin
  with AImage do
    sf := cairo_image_surface_create_for_data(
      @Data[0],
      CAIRO_FORMAT_ARGB32,
      Header.Width,
      Header.Height,
      cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, Header.Width)
    );
  cr := cairo_create(sf);
  
  cairo_set_source_rgb(cr, 0, 0, 1);
  cairo_paint(cr);
  
  cairo_destroy(cr);
  cairo_surface_destroy(sf);
end;
*)

(* -------------------------------------------------------------------------- *)

type
  TBalls = array of TBall;

function CreateBalls(const width, height: integer): TBalls;
var
  i, w, h: integer;
begin
  Initialize(result);
  SetLength(result, 10);
  for i := 0 to High(result) do
  begin
    result[i] := TBall.Create(Point(0, 0), Point(0, 0), 20 + Random(40), 0);
    result[i].CalculateMass;
  end;
  w := width div 5;
  h := height div 4;
  result[0].position := Point(w, h * 2);
  result[1].Position := Point(w * 2, h);
  result[2].Position := Point(w * 3, h);
  result[3].Position := Point(w * 4, h);
  result[4].Position := Point(w * 2, h * 2);
  result[5].Position := Point(w * 3, h * 2);
  result[6].Position := Point(w * 4, h * 2);
  result[7].Position := Point(w * 2, h * 3);
  result[8].Position := Point(w * 3, h * 3);
  result[9].Position := Point(w * 4, h * 3);
  // Die Richtung für unseren StarBall setzen
  result[0].SpeedVektor := Point(Cos(-45 * Pi / 180) * 20, Sin(-45 * Pi / 180) * 20);
end;

procedure FreeBalls(const balls: array of TBall);
var
  i: integer;
begin
  for i := 0 to High(balls) do
    balls[i].Free;
end;

procedure MoveBalls(const balls: array of TBall; const ClientRect: TRect);
var
  i, j: integer;
begin
  for i := 0 to High(balls) do
    balls[i].Move;

  // Kollision der Kugeln untereinander.
  for i := 0 to High(balls) do
    for j := i + 1 to High(balls) do
      balls[i].Collision(balls[j]);

  // Collision mit den Wänden.
  for i := 0 to High(balls) do
    balls[i].BorderCollision(ClientRect);
end;

procedure Draw(var AImage: TImage; const balls: array of TBall);
var
  sf: pcairo_surface_t;
  cr: pcairo_t;
  i: integer;
begin
  with AImage do
    sf := cairo_image_surface_create_for_data(
      @Data[0],
      CAIRO_FORMAT_ARGB32,
      Header.Width,
      Header.Height,
      cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, Header.Width)
    );
  
  cr := cairo_create(sf);

  cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
  cairo_paint(cr);

  for i := 0 to High(balls) do
    balls[i].Render(cr);
  
  cairo_destroy(cr);
  cairo_surface_destroy(sf);
end;

(* -------------------------------------------------------------------------- *)

var
  LDriver, LMode: smallint;
  LImage: PImage;
  LBalls: TBalls;
  
begin
  //FullScreenGraph := TRUE;
  //LDriver := VESA;
  //LMode := m800x600x16m;
  DetectGraph(LDriver, LMode);
  InitGraph(LDriver, LMode, '');
  LImage := CreateImage(Succ(GetMaxX), Succ(GetMaxY));
  LBalls := CreateBalls(Succ(GetMaxX), Succ(GetMaxY));
  while not KeyPressed do
  begin
    //Draw(LImage^);
    Draw(LImage^, LBalls);
    PutImage(0, 0, LImage^, NormalPut);
    MoveBalls(LBalls, Rect(0, 0, Succ(GetMaxX), Succ(GetMaxY)));
    Delay(30);
  end;
  CloseGraph;
  FreeImage(LImage);
  FreeBalls(LBalls);
end.
