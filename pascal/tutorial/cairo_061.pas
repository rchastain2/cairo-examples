
uses
  Cairo;

const
  SURFACE_WIDTH = 256;
  SURFACE_HEIGHT = 256;

var 
  surface: pcairo_surface_t;

begin
  surface := cairo_pdf_surface_create(
    pchar('image.pdf'), 
    SURFACE_WIDTH,
    SURFACE_HEIGHT
  );
  
  cairo_surface_destroy(surface);
end.
