
uses
  Cairo;

const
  SURFACE_WIDTH = 100;
  SURFACE_HEIGHT = 100;

var 
  context: pcairo_t;
  surface: pcairo_surface_t;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  
  cairo_arc(context, 0.5, 0.5, 0.3, 0, 2 * PI);
  cairo_clip(context);

  //cairo_new_path(context);
  cairo_set_source_rgb(context, 0, 0, 1);
  cairo_rectangle(context, 0, 0, 1, 1);
  cairo_fill(context);
  cairo_set_line_width(context, 0.05);
  cairo_set_source_rgb(context, 0, 1, 0);
  cairo_move_to(context, 0, 0);
  cairo_line_to(context, 1, 1);
  cairo_move_to(context, 1, 0);
  cairo_line_to(context, 0, 1);
  cairo_stroke(context);
  
  cairo_destroy(context);
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_surface_destroy(surface);
end.
