
uses
  SysUtils, Cairo;

const
  SURFACE_WIDTH = 256;
  SURFACE_HEIGHT = 256;

var 
  context: pcairo_t;
  surface: pcairo_surface_t;
  matrix: cairo_matrix_t;
begin
  surface := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
  context := cairo_create(surface);
  
  cairo_scale(context, SURFACE_WIDTH, SURFACE_HEIGHT);
  
  cairo_set_line_width(context, 0.04); 
  
  cairo_set_source_rgba(context, 1.000, 0.549, 0.000, 1.0);
  
  cairo_arc(context, 0.5, 0.5, 0.25, PI/2, PI); 
  cairo_stroke(context);
  
{
  void                cairo_matrix_init                   (cairo_matrix_t *matrix,
                                                           double xx,
                                                           double yx,
                                                           double xy,
                                                           double yy,
                                                           double x0,
                                                           double y0);
}

  cairo_matrix_init(@matrix,
    1.0, 0.0,
    0.0, 1.0,
    0.0, 0.0
  );
  
{
  Matrix is used throughout Cairo to convert between different coordinate spaces. A Matrix holds an
  affine transformation, such as a scale, rotation, shear, or a combination of these. The
  transformation of a point (x,y) is given by:

  x_new = xx * x + xy * y + x0
  y_new = yx * x + yy * y + y0

  The current transformation matrix of a Context, represented as a Matrix, defines the
  transformation from user-space coordinates to device-space coordinates.
}
  
  cairo_transform(context, @matrix);
  
  cairo_arc(context, 0.5, 0.5, 0.25, PI, 3*PI/2); 
  cairo_stroke(context);
  
  cairo_surface_write_to_png(surface, pchar('image.png'));
  
  cairo_destroy(context);
  cairo_surface_destroy(surface);
end.
