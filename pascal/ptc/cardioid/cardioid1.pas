
{ 
  Animation illustrating a method for drawing a cardioid
  https://mathimages.swarthmore.edu/index.php/Cardioid
}

program Cardioid1;

{$MODE objfpc}

uses
  SysUtils, ptc, Cairo;

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
const
  TITLE = 'A method for drawing a cardioid (PTCPas & Cairo example)';
  CONSOLE_W = 512;
  CONSOLE_H = CONSOLE_W;
  DELAY = 30;
var
  console: IPTCConsole;
  format: IPTCFormat;
  surface: IPTCSurface;
  width, height: Integer;
  pixels: PUint32;
  sf: pcairo_surface_t;
  cr: pcairo_t;
  ang: double;
  
begin
  try
    console := TPTCConsoleFactory.CreateNew;
    format := TPTCFormatFactory.CreateNew(32, $00FF0000, $0000FF00, $000000FF);
    console.open(TITLE, CONSOLE_W, CONSOLE_H, format);
    surface := TPTCSurfaceFactory.CreateNew(console.width, console.height, format);
    
    ang := PI / 72;
    
    while not console.KeyPressed do
    begin
      width := surface.width;
      height := surface.height;
      
      pixels := surface.lock;
      sf := cairo_image_surface_create_for_data(pbyte(pixels), CAIRO_FORMAT_ARGB32, width, height, cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, width));
      cr := cairo_create(sf);
      
      cairo_scale(cr, width, height);
      cairo_translate(cr, 1 / 2, 1 / 2);
      cairo_set_line_width(cr, 1 / 400);
      
      cairo_set_source_rgb(cr, 1.0, 1.0, 1.0);
      cairo_paint(cr);
      
      cairo_set_source_rgb(cr, 0, 0, 1);
      cairo_arc(cr, 0, 0, R, 0, 2 * PI);
      cairo_stroke(cr);
      
      cairo_set_source_rgb(cr, 0, 0, 0);
      cairo_arc(cr, X, Y, 1 / 150, 0, 2 * PI);
      cairo_fill(cr);
      
      xx := R * Cos(ang);
      yy := R * Sin(ang);
      
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
      
      surface.unlock;
      surface.copy(console);
      console.update;
      
      ang := ang + PI / 36;
      if ang > 2 * PI then
        ang := ang - 2 * PI;
      
      Sleep(DELAY);
    end;
    
    if Assigned(console) then
      console.close;
    
  except
    on error: TPTCError do
      error.report;
  end;
end.
