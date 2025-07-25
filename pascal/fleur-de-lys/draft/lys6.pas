
uses
  SysUtils, Cairo, Data6;

const
  W = 4 * 120;
  H = 4 * 120;

var
  context: pcairo_t;
  surface: pcairo_surface_t;
  i: integer;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, W, H);
  context := cairo_create(surface);
  {
  cairo_set_source_rgb(context, 1.0, 1.0, 1.0);
  cairo_paint(context);
  }
  cairo_set_line_cap(context, CAIRO_LINE_CAP_ROUND);
  cairo_set_line_join(context, CAIRO_LINE_JOIN_ROUND);
  cairo_set_line_width(context, 1.0);
  
  cairo_translate(context, 20, 0);
  
  cairo_move_to(context, A[0], A[1]);
  for i := 0 to 9 do
    cairo_curve_to(context, A[6*i+2], A[6*i+3], A[6*i+4], A[6*i+5], A[6*i+6], A[6*i+7]);
  cairo_close_path(context);
  
  cairo_set_source_rgb(context, 0.8, 0.8, 0.8);
  cairo_fill_preserve(context);
  cairo_set_source_rgb(context, 0.4, 0.4, 0.4);
  cairo_stroke(context);
  
  cairo_surface_write_to_png(surface, pchar(ChangeFileExt({$I %FILE%}, '.png')));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
