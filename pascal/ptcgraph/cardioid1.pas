
program Cardioid1;

{ 
  Animation illustrating a method for drawing a cardioid
  https://mathimages.swarthmore.edu/index.php/Cardioid
}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
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
  cr: pcairo_t;
  a, xx, yy: double;
const
  D = 0.3;
begin
  result := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, AWidth, AHeight);
  cr := cairo_create(result);
  cairo_scale(cr, AWidth, AHeight);
  cairo_translate(cr, 1 / 2, 1 / 2);
  
  a := 0;
  while a < 2 * PI do
  begin
    xx := 2 * R * Cos(a) * (1 + Cos(a)) + X;
    yy := 2 * R * Sin(a) * (1 + Cos(a)) + Y;
    
    if a = 0 then
      cairo_move_to(cr, xx, yy)
    else
      cairo_line_to(cr, xx, yy);
    
    a := a + PI / 49;
  end;
  
  cairo_set_line_width(cr, 1 / 300);
  cairo_set_source_rgb(cr, 1, 0, 0);
  cairo_stroke(cr);
  cairo_destroy(cr);
end;

procedure CairoDraw(var AImage: TImage; const AStaticBackground: pcairo_surface_t; const AAngle: double);
var
  sf: pcairo_surface_t;
  cr: pcairo_t;
  stride: integer;
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
  stride := cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, AImage.Header.Width);
  sf := cairo_image_surface_create_for_data(@AImage.Data[0], CAIRO_FORMAT_ARGB32, AImage.Header.Width, AImage.Header.Height, stride);
  cr := cairo_create(sf);
  
  cairo_set_source_rgb(cr, 1.0, 1.0, 1.0);
  cairo_paint(cr);
  
  cairo_set_source_surface(cr, AStaticBackground, 0, 0);
  cairo_paint(cr);
  
  cairo_scale(cr, AImage.Header.Width, AImage.Header.Height);
  cairo_translate(cr, 0.5, 0.5);
  
  cairo_set_line_width(cr, 1 / 400);
  
  cairo_set_source_rgb(cr, 0, 0, 1);
  cairo_arc(cr, 0, 0, R, 0, 2 * PI);
  cairo_stroke(cr);
  
  cairo_set_source_rgb(cr, 0, 0, 0);
  cairo_arc(cr, X, Y, 1 / 150, 0, 2 * PI);
  cairo_fill(cr);
  
  xx := R * Cos(AAngle);
  yy := R * Sin(AAngle);
  
  dx := xx - X;
  dy := yy - Y;
  
  rr := Sqrt(Sqr(dx) + Sqr(dy));
  
  xx1 := xx - (D / rr) * dx;
  yy1 := yy - (D / rr) * dy;
  xx2 := xx + (D / rr) * dx;
  yy2 := yy + (D / rr) * dy;
  
  cairo_set_source_rgba(cr, 1, 0, 0, 0.5);
  cairo_move_to(cr, xx1, yy1);
  cairo_line_to(cr, xx2, yy2);
  cairo_stroke(cr);
  
  cairo_set_source_rgb(cr, 0, 0, 0);
  cairo_arc(cr, xx, yy, 1 / 150, 0, 2 * PI);
  cairo_arc(cr, xx1, yy1, 1 / 150, 0, 2 * PI);
  cairo_arc(cr, xx2, yy2, 1 / 150, 0, 2 * PI);
  cairo_fill(cr);
  
  cairo_destroy(cr);
  cairo_surface_destroy(sf);
end;

const
  SURFACE_WIDTH = 360;
  SURFACE_HEIGHT = 360;
  
var
  gd, gm, err: smallint;
  image: PImage;
  sf: pcairo_surface_t;
  ang: double;
  
begin
  sf := Cardioid(SURFACE_WIDTH, SURFACE_HEIGHT);
  
  WindowTitle := 'A method for drawing a cardioid';
  gd := VESA;
  gm := m640x480x16m;
  InitGraph(gd, gm, '');
  err := GraphResult;
  
  if err = grOK then
  begin
    SetBkColor($808080);
    ClearDevice;
    
    image := CreateImage(SURFACE_WIDTH, SURFACE_HEIGHT);
    
    ang := 0;
    while not KeyPressed do
    begin
      CairoDraw(image^, sf, ang);
      PutImage(
        (Succ(GetMaxX) - SURFACE_WIDTH) div 2,
        (Succ(GetMaxY) - SURFACE_HEIGHT) div 2,
        image^,
        NormalPut
      );
      Delay(60);
      
      ang := ang + PI / 18;
      if ang > 2 * PI then
        ang := ang - 2 * PI;
    end;
    
    ReadKey;
    CloseGraph;
    FreeImage(image, SURFACE_WIDTH, SURFACE_HEIGHT);
  end;
  
  cairo_surface_destroy(sf);
end.
