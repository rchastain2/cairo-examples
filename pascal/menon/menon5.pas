
uses
  sysutils,
  cairo;

const
  W = 120;
  H = W;
  
var 
  cr: pcairo_t;
  surface: pcairo_surface_t;
  i: integer;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, W, H);
  cr := cairo_create(surface);
  cairo_scale(cr, W, H);
  
  cairo_set_source_rgba(cr, 1, 1, 1, 1);
  cairo_paint(cr);
  
  cairo_set_source_rgb(cr, 1.000, 0.647, 0.000);
  cairo_set_line_width(cr, 1/200);
  cairo_rectangle(cr, 1/6, 1/6, 4/6, 4/6);
  for i := 1 to 5 do
  begin
    cairo_move_to(cr, 1/6, i/6);
    cairo_line_to(cr, 5/6, i/6);
    cairo_move_to(cr, i/6, 1/6);
    cairo_line_to(cr, i/6, 5/6);
  end;
  cairo_stroke(cr);
  
  cairo_set_source_rgb(cr, 0, 0, 0);
  cairo_set_line_width(cr, 1/100);
  cairo_rectangle(cr, 1/6, 1/6, 2/6, 2/6);
  (*
  cairo_move_to(cr, 1/6, 1/6);
  cairo_line_to(cr, 3/6, 3/6);
  cairo_move_to(cr, 1/6, 3/6);
  cairo_line_to(cr, 3/6, 1/6);
  *)
  cairo_stroke(cr);
  
  cairo_move_to(cr, 3/6, 1/6);
  cairo_line_to(cr, 5/6, 3/6);
  cairo_line_to(cr, 3/6, 5/6);
  cairo_line_to(cr, 1/6, 3/6);
  cairo_line_to(cr, 3/6, 1/6);
  
  cairo_stroke(cr);
  
  cairo_surface_write_to_png(surface, pchar(ChangeFileExt({$I %FILE%}, '.png')));
  
  cairo_destroy(cr);
  cairo_surface_destroy(surface);
end.
