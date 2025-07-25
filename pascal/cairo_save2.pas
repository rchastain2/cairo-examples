
uses
  Cairo;

const
  W = 512;
  H = W;

var 
  context: pcairo_t;
  sf: pcairo_surface_t;

procedure DrawBranches(const x1, y1, x2, y2: double; const depth: integer);
procedure DrawBranch(const angle: double);
begin
  cairo_save(context);
  cairo_translate(context, 0, y2 / 2);
  cairo_rotate(context, angle);
  cairo_move_to(context, 0, 0);
  cairo_line_to(context, 0, y2 / 2);
  
  DrawBranches(0, 0, 0, y2 / 2, depth - 1);
  
  cairo_restore(context);
  cairo_stroke(context);
end;
begin
  if depth = 0 then
    exit;
  DrawBranch(-1 * PI / 6);
  DrawBranch(+1 * PI / 6);
end;

begin
  sf := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, W, H);
  context := cairo_create(sf);
  cairo_scale(context, W, H);
  
  cairo_set_source_rgb(context, 1.0, 1.0, 1.0);
  cairo_paint(context);
  
  cairo_translate(context, 1 / 2, 1 / 2);
  cairo_rotate(context, PI);
  
  cairo_set_source_rgba(context, 0.0, 0.0, 0.0, 0.5);
  cairo_set_line_width(context, 1 / 800);
  
  cairo_move_to(context, 0, 0);
  cairo_line_to(context, 0, 1 / 4);
  
  DrawBranches(0, 0, 0, 1 / 2, 4);
  
  cairo_surface_write_to_png(sf, pchar('image.png'));
  
  cairo_destroy(context);
  cairo_surface_destroy(sf);
end.
