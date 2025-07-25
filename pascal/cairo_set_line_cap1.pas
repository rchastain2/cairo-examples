
uses
  Cairo;

const
  SURFACE_WIDTH = 100;
  SURFACE_HEIGHT = 100;

var 
  surface: pcairo_surface_t;
  context: pcairo_t;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_set_line_width(context, 0.1);
  
  cairo_move_to(context, 0.2, 0.2);
  cairo_line_to(context, 0.8, 0.2);
  cairo_set_line_cap(context, CAIRO_LINE_CAP_BUTT); { style par défaut }
  cairo_stroke(context);
  
  cairo_move_to(context, 0.2, 0.4);
  cairo_line_to(context, 0.8, 0.4);
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
  cairo_stroke(context);
  
  cairo_move_to(context, 0.2, 0.6);
  cairo_line_to(context, 0.8, 0.6);
  cairo_set_line_cap(context, CAIRO_LINE_CAP_SQUARE);
  cairo_stroke(context);
  
  cairo_destroy(context);
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_surface_destroy(surface);
end.
