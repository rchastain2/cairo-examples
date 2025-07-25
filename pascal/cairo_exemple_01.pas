
uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH  = 200; // largeur de l'image
  SURFACE_HEIGHT = 200; // hauteur

var
  surface: pcairo_surface_t;
  context: pcairo_t;
  
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  cairo_set_source_rgba(context, 0.0, 0.0, 1.0, 0.5); // couleur (rouge, vert, bleu, alpha)
  cairo_paint(context);
  cairo_destroy(context);
  cairo_surface_write_to_png(surface, pchar('image.png'));
  cairo_surface_destroy(surface);
end.
