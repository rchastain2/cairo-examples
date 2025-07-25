
uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH = 256;
  SURFACE_HEIGHT = 256;

var 
  context: pcairo_t;
  surface: pcairo_surface_t;
  xc: double;
  yc: double;
  radius: double;
  angle1: double;
  angle2: double;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  xc := 0.5; 
  yc := 0.5; 
  radius := 0.4; 
  angle1 := PI / 2; 
  angle2 := PI;
  
  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  
  cairo_set_line_width(context, 0.04); 
  
  cairo_arc(context, xc, yc, radius, angle1, angle2); 
  cairo_stroke(context);
  
  cairo_set_source_rgba(context, 0.906, 0.329, 0.502, 0.5); 
  
  cairo_arc(context, xc, yc, 0.05, 0, 2 * PI); 
  cairo_fill(context);
  
  cairo_set_line_width(context, 0.03);
  
  cairo_arc(context, xc, yc, radius, angle1, angle1);
  cairo_line_to(context, xc, yc);
  
  cairo_arc(context, xc, yc, radius, angle2, angle2);
  cairo_line_to(context, xc, yc);
  
  cairo_stroke(context);  
  
  cairo_surface_write_to_png(surface, pchar('image.png'));
  
  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
