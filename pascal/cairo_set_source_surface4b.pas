
uses
  Cairo;

var 
  source, destination: pcairo_surface_t;
  context1, context: pcairo_t;
  
begin
  source := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 400, 400);
  context1 := cairo_create(source);
  cairo_set_source_rgba(context1, 1.0, 0.0, 0.0, 0.5);
  cairo_paint(context1);
  
  destination := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 400, 400);
  context := cairo_create(destination);
  //cairo_translate(context, 200, 200);
  cairo_scale(context, 400, 400);
  cairo_translate(context, 1 / 2, 1 / 2);
  cairo_set_line_width(context, 1 / 100);
  
  cairo_move_to(context, -0.5, -0.5);
  cairo_line_to(context, 0.5, 0.5);
  cairo_stroke(context);
  
  cairo_set_source_surface(context, source, -0.5, -0.5);
  cairo_paint(context);
  cairo_destroy(context);
  
  cairo_surface_destroy(source);
  
  cairo_surface_write_to_png(destination, pchar('image.png'));
  
  cairo_surface_destroy(destination);
end.
