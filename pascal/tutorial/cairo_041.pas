
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
  
  cairo_set_source_rgb(context, 1, 0, 0);
  cairo_paint(context);
  
  cairo_select_font_face(context, 'Georgia', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(context, 24);
  
  cairo_set_source_rgb(context, 0, 0, 1);
  
  cairo_move_to(context, 0, SURFACE_HEIGHT);
  cairo_show_text(context, 'ABC');
  
  cairo_destroy(context);
  
  cairo_surface_write_to_png(surface, pchar('image.png'));
  
  cairo_surface_destroy(surface);
end.
