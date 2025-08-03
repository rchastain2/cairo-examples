
(* https://forum.lazarus.freepascal.org/index.php/topic,59894.msg450781.html#msg450781 *)

program graphics;

{$MACRO on}
{$DEFINE colour:=}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt,
  ptcGraph,
  Cairo,
  SysUtils,
  Math;

const
  xres = 1024;
  yres = 768;
  bytesPerPixel = 4;

type
  V2 = object
    x, y, dx, dy: single;
    radius: integer;
    colour r, g, b, a: single;
    an: Single; // angular distance
    da: Single; // angular speed
    procedure SetF(xx, yy, ddx, ddy: single; rradius: integer; rr, gg, bb, aa: single);
  end;

type
  aov = array[1..5] of v2;

procedure V2.SetF(xx, yy, ddx, ddy: single; rradius: integer; colour rr, gg, bb, aa: single);
begin
  x := xx;
  y := yy;
  dx := ddx;
  dy := ddy;
  radius := rradius;
  r := rr;
  g := gg;
  b := bb;
  a := aa;
end;

type
  TImage = packed record
    width, height, reserved: longint;
    data: array[0..xres * yres * bytesPerPixel - 1] of byte;
  end;

function HandleBallCollisions(var b: aov): boolean;
var
  L, impulsex, impulsey, dot, impactx, impacty: single;
  ma, mb, f1, f2: single;
  n1, n2: Integer;
  flag: boolean = false;
  at1, at2: single;
begin
  at1 := 0;
  at2 := 0;
  for n1 := low(b) to high(b) - 1 do
  begin
    for n2 := n1 + 1 to high(b) do
    begin
      L := Sqrt((b[n1].x - b[n2].x) * (b[n1].x - b[n2].x) + (b[n1].y - b[n2].y) * (b[n1].y - b[n2].y));
      if L < (b[n1].radius + b[n2].radius) then
      begin
        flag := true;
        impulsex := (b[n1].x - b[n2].x) / L;
        impulsey := (b[n1].y - b[n2].y) / L;
        // in case of large overlap (non analogue motion)
        b[n1].x := b[n2].x + (b[n1].radius + b[n2].radius) * impulsex;
        b[n1].y := b[n2].y + (b[n1].radius + b[n2].radius) * impulsey;

        impactx := b[n1].dx - b[n2].dx;
        impacty := b[n1].dy - b[n2].dy;
        dot := impactx * impulsex + impacty * impulsey;
        ma := b[n1].radius;
        mb := b[n2].radius;
        ma := ma * ma; // weigh by area (radius squared)
        mb := mb * mb;
        f1 := 2 * mb / (ma + mb); // ball weight factors
        f2 := 2 * ma / (ma + mb);
        b[n1].dx := b[n1].dx - dot * impulsex * f1;
        b[n1].dy := b[n1].dy - dot * impulsey * f1;
        b[n2].dx := b[n2].dx + dot * impulsex * f2;
        b[n2].dy := b[n2].dy + dot * impulsey * f2;

        at1 := (Arctan2(b[n1].dy, b[n1].dx));
        at2 := (Arctan2(b[n2].dy, b[n2].dx));
        at1 := Sign(at1) * Ifthen(at1 < 0, pi + at1, pi - at1);
        at2 := Sign(at2) * Ifthen(at2 < 0, pi + at2, pi - at2);
        b[n1].da := at1;
        b[n2].da := at2;
      end;
    end;
  end;
  exit(flag);
end;

procedure HandleEdges(var b: aov);
var
  i, r: integer;
begin

  for i := low(b) to high(b) do
  begin
    r := b[i].radius;
    if (b[i].x < r) then
    begin
      b[i].x := r;
      b[i].dx := -b[i].dx;
      b[i].da := Abs(Arctan2(b[i].dy, b[i].dx)) * Sign(b[i].dy);
    end;

    if (b[i].x > (xres - r)) then
    begin
      b[i].x := xres - r;
      b[i].dx := -b[i].dx;
      b[i].da := -Abs(Arctan2(b[i].dy, b[i].dx)) * Sign(b[i].dy)
    end;

    if (b[i].y < r) then
    begin
      b[i].y := r;
      b[i].dy := -b[i].dy;
      b[i].da := -Abs(Arctan2(b[i].dy, b[i].dx)) * Sign(b[i].dx);
    end;

    if (b[i].y > (yres - r)) then
    begin
      b[i].y := yres - r;
      b[i].dy := -b[i].dy;
      b[i].da := Abs(Arctan2(b[i].dy, b[i].dx)) * Sign(b[i].dx)
    end;
  end;
end;

procedure InitFonts(surf: pcairo_t; fonttype: pchar);
begin
  cairo_select_font_face(surf, fonttype, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
end;

procedure print(surf: pcairo_t; x, y: single; text: pchar; size, colour rd, gr, bl, al: single);
begin
  cairo_set_font_size(surf, size);
  cairo_move_to(surf, x, y);
  cairo_set_source_rgba(surf, colour rd, gr, bl, al);
  cairo_show_text(surf, text);
  cairo_stroke(surf);
end;

procedure line(surf: pcairo_t; x1, y1, x2, y2, thickness, colour r, g, b, a: single; CapOption: boolean);
begin
  cairo_set_line_width(surf, (thickness));
  cairo_set_source_rgba(surf, r, g, b, a);
  cairo_move_to(surf, (x1), (y1));
  cairo_line_to(surf, (x2), (y2));
  if Capoption then
    cairo_set_line_cap(surf, CAIRO_LINE_CAP_ROUND)
  else
    cairo_set_line_cap(surf, CAIRO_LINE_CAP_SQUARE);
  cairo_stroke(surf);
end;

procedure circle(surf: pcairo_t; cx, cy, radius, start, finish, thickness, colour r, g, b, a: single; Capoption:
  boolean);
begin
  cairo_set_line_width(surf, thickness);
  cairo_set_source_rgba(surf, r, g, b, a);
  cairo_arc(surf, (cx), (cy), (radius), (start), (finish));
  if Capoption then
    cairo_set_line_cap(surf, CAIRO_LINE_CAP_ROUND)
  else
    cairo_set_line_cap(surf, CAIRO_LINE_CAP_SQUARE);
  cairo_stroke(surf);
end;

procedure circlefill(surf: pcairo_t; cx, cy, radius, r, g, b, a: single);
begin
  cairo_set_line_width(surf, (1));
  cairo_set_source_rgba(surf, r, g, b, a);
  cairo_arc(surf, (cx), (cy), (radius), (0), (2 * pi));
  cairo_fill(surf);
  cairo_stroke(surf);
end;

procedure rectangle(surf: pcairo_t; x, y, wide, high, thickness, colour r, g, b, a: single);
begin
  cairo_set_line_width(surf, thickness);
  cairo_set_source_rgba(surf, r, g, b, a);
  cairo_move_to(surf, x, y);
  cairo_rectangle(surf, x, y, wide, high);
  cairo_stroke(surf);
end;

procedure rectanglefill(surf: pcairo_t; x, y, wide, high, colour r, g, b, a: single);
begin
  cairo_set_source_rgba(surf, r, g, b, a);
  cairo_move_to(surf, (x), (y));
  cairo_rectangle(surf, (x), (y), (wide), (high));
  cairo_fill(surf);
  cairo_stroke(surf);
end;

procedure SetBackgroundColour(c: pcairo_t; colour r, g, b: single);
begin
  cairo_set_source_rgb(c, r, g, b);
  cairo_paint(c);
  cairo_stroke(c);
end;

procedure texture(c: pcairo_t; xpos, ypos, size, colour r1, g1, b1, a1, colour r2, g2, b2, a2, an: Single; num: integer);
var
  l, tx, ty: single;
  s: ansistring;
begin
  circlefill(c, xpos, ypos, size, r1, g1, b1, a1);
  l := size / 3;
  cairo_save(c);
  tx := xpos - l;
  ty := ypos + l / 1.5;
  cairo_translate(c, xpos, ypos);
  cairo_rotate(c, an);
  cairo_translate(c, -xpos, -ypos);
  str(num, s);
  print(c, tx, ty, pchar(s), size, r2, g2, b2, a2);
  cairo_restore(c);
end;

procedure MoveAndDraw(c: pcairo_t; var b: aov);
var
  i: integer;
begin
  for i := low(b) to high(b) do
  begin
    b[i].x := b[i].x + b[i].dx;
    b[i].y := b[i].y + b[i].dy;
    b[i].an := b[i].an + b[i].da * (1 / b[i].radius);
    texture(c, b[i].x, b[i].y, b[i].radius, b[i].r, b[i].g, b[i].b, b[i].a, 1 - b[i].r, 1 - b[i].g, 1 - b[i].b, 1, b[i].an, i);
  end;
end;

function Regulate(const MyFps: int32; var fps: int32): int32;
const
  timervalue: double = 0;
  _lastsleeptime: double = 0;
  t3: double = 0;
  frames: double = 0;
var
  t, sleeptime: double;
begin
  t := gettickcount64 / 1000;
  frames := frames + 1;
  if (t - t3) >= 1.0 then
  begin
    t3 := t;
    fps := trunc(frames);
    frames := 0;
  end;
  sleeptime := (_lastsleeptime + ((1 / myfps) - (t) + timervalue) * 1000);
  if (sleeptime < 1) then
    sleeptime := 1;
  _lastsleeptime := sleeptime;
  timervalue := t;
  exit(trunc(sleeptime));
end;

var
  gd, gm: SmallInt;
  size: word = 0;
  surface: pcairo_surface_t;
  context: pcairo_t;
  T: timage;
  c: ansistring;
  b: aov;
  fps: int32 = 0;

begin
  T.width := xres;
  T.height := yres;

  {==========  set up graph =========}
  gd := VESA;
  gm := m1024x768x16m;
  InitGraph(gd, gm, '');
  if GraphResult <> grok then
    halt;

  size := cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, xres);
  surface := cairo_image_surface_create_for_data(T.data, CAIRO_FORMAT_ARGB32, xres, yres, size);
  context := cairo_create(surface);
  initfonts(context, 'georgia');
  b[1].x := 0; // to eliminate fpc warning

  b[1].setf(100, 100, 1.75 * 3, 1.75 * 3.5, 35, colour 1, 0.5, 0, 1);
  b[2].setf(300, 300, 0, 0, 35, colour 0, 1, 0, 1);
  b[3].setf(400, 400, 0, 0, 40, colour 0, 0, 1, 1);
  b[4].setf(500, 500, 0, 0, 30, colour 0, 0.5, 1, 1);
  b[5].setf(200, 200, 0, 0, 20, colour 1, 1, 1, 1);

  while not KeyPressed do
  begin
    SetBackgroundColour(context, colour 0.5, 0.5, 0);
    rectangle(context, 20, yres - 33, 200, 30, 2, colour 0, 0, 0, 1);
    c := 'Version  ' + cairo_version_string();
    print(context, 22, yres - 10, pchar(c), 20, colour 0.5, 0, 0, 1);
    HandleEdges(b);
    HandleBallCollisions(b);
    MoveAndDraw(context, b);
    str(fps, c);
    print(context, 50, 30, pchar('Framerate  ' + c), 15, colour 1, 0.5, 1, 1);
    print(context, 50, 100, pchar('Press any key to finish'), 20, colour 0, 0, 1, 0.5);
    PutImage(0, 0, T, NormalPut);
    sleep(regulate(60, fps));
  end;

  closegraph;
end.
