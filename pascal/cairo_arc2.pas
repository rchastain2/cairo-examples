
uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH = 256;
  SURFACE_HEIGHT = 256;

procedure do_drawing(context: pcairo_t; width, height: integer);
var
  xc: double;
  yc: double;
  radius: double;
  angle1: double;
  angle2: double;
begin
  xc := 0.5;
  yc := 0.5;
  radius := 0.4;
  angle1 := PI / 2;
  angle2 := PI;
  cairo_scale(context, width, height);
  cairo_set_line_width(context, 0.04);
  cairo_arc(context, xc, yc, radius, angle1, angle2);
  cairo_stroke(context);
end;

var
  context: pcairo_t;
  surface: pcairo_surface_t;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  do_drawing(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
