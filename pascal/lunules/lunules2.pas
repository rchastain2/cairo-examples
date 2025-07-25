
uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH = 256;
  SURFACE_HEIGHT = 256;
  RACINE2 = 1.414213562373095;

var
  context: pcairo_t;
  surface: pcairo_surface_t;
  i: integer;

begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);

  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  cairo_translate(context, 1 / 2, 1 / 2);
  cairo_set_line_width(context, 1 / SURFACE_WIDTH);
  
  for i := 0 to 3 do
  begin
    cairo_rotate(context, PI / 2);
    cairo_arc(context, 0, -1 / 5, 1 / 5, PI, 2 * PI);
    cairo_set_source_rgb(context, 0.553, 0.616, 0.714);
    cairo_fill_preserve(context);
    cairo_set_source_rgb(context, 0.400, 0.447, 0.573);
    cairo_stroke(context);
  end;
  
  cairo_surface_write_to_png(surface, pchar('image2.png'));
  
  cairo_save(context);
  cairo_arc(context, 0, 0, RACINE2 / 5, 0, 2 * PI);
  cairo_clip(context);
  cairo_set_operator(context, CAIRO_OPERATOR_SOURCE);
  cairo_set_source_rgba(context, 1.00, 1.00, 1.00, 0.00);
  cairo_paint(context);
  cairo_restore(context);
  
  cairo_surface_write_to_png(surface, pchar('image3.png'));
  
  cairo_arc(context, 0, 0, RACINE2 / 5, 0, 2 * PI);
  cairo_stroke(context);
  
  cairo_surface_write_to_png(surface, pchar('image4.png'));
  
  cairo_rectangle(context, -1 / 5, -1 / 5, 2 / 5, 2 / 5);
  cairo_set_source_rgb(context, 0.737, 0.792, 0.839);
  cairo_fill_preserve(context);
  cairo_set_source_rgb(context, 0.400, 0.447, 0.573);
  cairo_stroke(context);

  cairo_surface_write_to_png(surface, pchar('image5.png'));

  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
