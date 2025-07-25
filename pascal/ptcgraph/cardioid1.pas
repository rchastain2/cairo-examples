
program Cardioid1;

{ 
  Animation illustrating a method for drawing a cardioid
  https://mathimages.swarthmore.edu/index.php/Cardioid
}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  //SysUtils,
  ptcCrt,
  ptcGraph,
  Cairo;

const
  COLOR_WIDTH = 4;

type
  THeader = packed record
    Width, Height, Reserved: longint;
  end;
 
  TImage = packed record
    Header: THeader;
    Data: array[0..0] of byte;
  end;
  
  PImage = ^TImage;

function CreateImage(const AWidth, AHeight: integer): PImage;
begin
  result := PImage(GetMem(SizeOf(THeader) + COLOR_WIDTH * AWidth * AHeight));
  result^.Header.Width  := AWidth;
  result^.Header.Height := AHeight;
end;

procedure FreeImage(const AImage: PImage; const AWidth, AHeight: integer);
begin
  FreeMem(AImage, SizeOf(THeader) + COLOR_WIDTH * AWidth * AHeight);
end;
  
function Cardioid(const AWidth, AHeight: integer): pcairo_surface_t;
const
  R = 0.15;
  X = -R;
  Y = 0;
var
  ctx: pcairo_t;
  a, xx, yy: double;
const
  D = 0.3;
begin
  result := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, AWidth, AHeight);
  ctx := cairo_create(result);
  cairo_scale(ctx, AWidth, AHeight);
  cairo_translate(ctx, 1 / 2, 1 / 2);
  
  a := 0;
  while a < 2 * PI do
  begin
    xx := 2 * R * Cos(a) * (1 + Cos(a)) + X;
    yy := 2 * R * Sin(a) * (1 + Cos(a)) + Y;
    
    if a = 0 then
      cairo_move_to(ctx, xx, yy)
    else
      cairo_line_to(ctx, xx, yy);
    
    a := a + PI / 49;
  end;
  
  cairo_set_line_width(ctx, 1 / 300);
  cairo_set_source_rgb(ctx, 1, 0, 0);
  cairo_stroke(ctx);
  cairo_destroy(ctx);
end;

procedure CairoDraw(var AImage: TImage; const ABackground: pcairo_surface_t; const AAngle: double);
var
  sfc: pcairo_surface_t;
  ctx: pcairo_t;
  str: integer;
const
  R = 0.15;
  X = -R;
  Y = 0;
var
  xx, yy, rr: double;
const
  D = 0.3;
var
  dx, dy: double;
  xx1, yy1, xx2, yy2: double;
begin
  str := cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, AImage.Header.Width);
  sfc := cairo_image_surface_create_for_data(@AImage.Data[0], CAIRO_FORMAT_ARGB32, AImage.Header.Width, AImage.Header.Height, str);
  ctx := cairo_create(sfc);
  
  cairo_set_source_rgb(ctx, 1.0, 1.0, 1.0);
  cairo_paint(ctx);
  
  cairo_set_source_surface(ctx, ABackground, 0, 0);
  cairo_paint(ctx);
  
  cairo_scale(ctx, AImage.Header.Width, AImage.Header.Height);
  cairo_translate(ctx, 0.5, 0.5);
  
  cairo_set_line_width(ctx, 1 / 400);
  
  cairo_set_source_rgb(ctx, 0, 0, 1);
  cairo_arc(ctx, 0, 0, R, 0, 2 * PI);
  cairo_stroke(ctx);
  
  cairo_set_source_rgb(ctx, 0, 0, 0);
  cairo_arc(ctx, X, Y, 1 / 150, 0, 2 * PI);
  cairo_fill(ctx);
  
  xx := R * Cos(AAngle);
  yy := R * Sin(AAngle);
  
  dx := xx - X;
  dy := yy - Y;
  
  rr := Sqrt(Sqr(dx) + Sqr(dy));
  
  xx1 := xx - (D / rr) * dx;
  yy1 := yy - (D / rr) * dy;
  xx2 := xx + (D / rr) * dx;
  yy2 := yy + (D / rr) * dy;
  
  cairo_set_source_rgba(ctx, 1, 0, 0, 0.5);
  cairo_move_to(ctx, xx1, yy1);
  cairo_line_to(ctx, xx2, yy2);
  cairo_stroke(ctx);
  
  cairo_set_source_rgb(ctx, 0, 0, 0);
  cairo_arc(ctx, xx, yy, 1 / 150, 0, 2 * PI);
  cairo_arc(ctx, xx1, yy1, 1 / 150, 0, 2 * PI);
  cairo_arc(ctx, xx2, yy2, 1 / 150, 0, 2 * PI);
  cairo_fill(ctx);
  
  cairo_destroy(ctx);
  cairo_surface_destroy(sfc);
end;

const
  SURFACE_WIDTH = 360;
  SURFACE_HEIGHT = 360;
  
var
  gd, gm, err: smallint;
  img: PImage;
  iw, ih, it, il: integer;
  card: pcairo_surface_t;
  ang: double;
  
begin
  card := Cardioid(SURFACE_WIDTH, SURFACE_HEIGHT);
  
  WindowTitle := 'A method for drawing a cardioid';
  gd := VESA;
  gm := m640x480x16m;
  InitGraph(gd, gm, '');
  err := GraphResult;
  
  if err = grOK then
  begin
    SetBkColor($808080);
    ClearDevice;
    
    iw := SURFACE_WIDTH;
    ih := SURFACE_HEIGHT;
    il := (Succ(GetMaxX) - iw) div 2;
    it := (Succ(GetMaxY) - ih) div 2;
    
    img := CreateImage(iw, ih);
    
    ang := 0;
    while not KeyPressed do
    begin
      CairoDraw(img^, card, ang);
      PutImage(il, it, img^, NormalPut);
      
      Delay(60);
      
      ang := ang + PI / 18;
      if ang > 2 * pi then
        ang := ang - 2 * pi;
    end;
    
    ReadKey;
    CloseGraph;
    FreeImage(img, iw, ih);
  end;
  
  cairo_surface_destroy(card);
end.
