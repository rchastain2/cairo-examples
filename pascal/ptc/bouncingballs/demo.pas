
program BouncingBalls;

{
  Bouncing balls for PTCPas and Cairo.
  
  Original program:
    https://corpsman.de/index.php?doc=beispiele/pingpong
    https://github.com/PascalCorpsman/mini_projects/tree/main/miniprojects/PingPong
}

{$MODE objfpc}

uses
  SysUtils, Classes, ptc, Cairo, Ball;

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
  result[0].SpeedVektor := Point(Cos((-45) * Pi / 180) * 12, Sin(-45 * Pi / 180) * 12);
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

procedure DrawBalls(surface: IPTCSurface; const balls: array of TBall);
var
  pixels: PUint32;
  sf: pcairo_surface_t;
  cr: pcairo_t;
  width, height: Integer;
  i: integer;
begin
  width := surface.width;
  height := surface.height;

  pixels := surface.lock;
  sf := cairo_image_surface_create_for_data(
    pbyte(pixels),
    CAIRO_FORMAT_ARGB32, width, height,
    cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, width)
  );
  cr := cairo_create(sf);

  cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
  cairo_paint(cr);

  for i := 0 to High(balls) do
    balls[i].Render(cr);
  
  cairo_destroy(cr);
  cairo_surface_destroy(sf);

  surface.unlock;
end;

const
  TITLE = 'Bouncing balls (PTCPas & Cairo example)';
  CONSOLE_W = 800;
  CONSOLE_H = 600;
  DELAY = 30;

{.$DEFINE MODE}

var
  console: IPTCConsole;
  format: IPTCFormat;
  surface: IPTCSurface;
  balls: TBalls;
{$IFDEF MODE}
  modes: TPTCModeList;
  width, height: integer;
{$ENDIF}

begin
  try
    console := TPTCConsoleFactory.CreateNew;
    format := TPTCFormatFactory.CreateNew(32, $00FF0000, $0000FF00, $000000FF);
{$IFDEF MODE}
    modes := console.modes;
    width := 4 * modes[0].width div 5;
    height := 4 * modes[0].height div 5;
    console.open(TITLE, width, height, format);
{$ELSE}
    console.open(TITLE, CONSOLE_W, CONSOLE_H, format);
{$ENDIF}
    surface := TPTCSurfaceFactory.CreateNew(console.width, console.height, format);

    balls := CreateBalls(console.width, console.height);

    while not console.KeyPressed do
    begin
      DrawBalls(surface, balls);
      surface.copy(console);
      console.update;
      MoveBalls(balls, Rect(0, 0, console.width, console.height));
      Sleep(DELAY);
    end;

    FreeBalls(balls);

    if Assigned(console) then
      console.close;

  except
    on error: TPTCError do
      error.report;
  end;
end.
