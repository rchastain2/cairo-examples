
uses
  Cairo;

var 
  context: pcairo_t;
  surface: pcairo_surface_t;
  
procedure draw_branches(const x1, y1, s1: double; const n: integer);
procedure draw_branch(const x2, y2, a, x3, y3, s2: double);
begin
  cairo_save(context);
  
  cairo_translate(context, x2, y2);
  cairo_rotate(context, a);
  
  cairo_rectangle(context, x3, y3, s2, s2);
  cairo_set_source_rgba(context, 0, 0, 1, 0.8);
  cairo_fill_preserve(context);
  cairo_set_source_rgb(context, 0, 0, 1);
  cairo_stroke(context);
  
  draw_branches(x3, y3, s2, n - 1);
  
  cairo_restore(context);
end;
var
  s2: double;  
begin
  if n > 0 then
  begin
    s2 := s1 / sqrt(2);
    draw_branch(x1,      y1, -PI / 4,   0, -s2, s2);
    draw_branch(x1 + s1, y1,  PI / 4, -s2, -s2, s2);
  end;
end;

const
  SURFACE_WIDTH = 600;
  SURFACE_HEIGHT = 2 * SURFACE_WIDTH div 3;
  SQUARE_SIZE = SURFACE_HEIGHT / 4;
  X = (SURFACE_WIDTH - SQUARE_SIZE) / 2;
  Y = SURFACE_HEIGHT - SQUARE_SIZE;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_set_line_width(context, 2);
  
  cairo_rectangle(context, X, Y, SQUARE_SIZE, SQUARE_SIZE);
  cairo_set_source_rgba(context, 0, 0, 1, 0.8);
  cairo_fill_preserve(context);
  cairo_set_source_rgb(context, 0, 0, 1);
  cairo_stroke(context);

  draw_branches(X, Y, SQUARE_SIZE, 4);
  
  cairo_surface_write_to_png(surface, 'image.png');
  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
