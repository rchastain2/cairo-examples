
uses
  SysUtils, Cairo;

const
  SURF_W = 400;
  SURF_H = SURF_W;

const
  R1 = 0.37;
  R2 = 0.47;
  R3 = 0.72;
  R4 = 0.90;
  R5 = 0.20;
  R6 = 0.32;
  R7 = 0.22;
  R8 = 0.30;
  A1 = PI + 1.398977;
  A2 = PI + 1.742615;
  X1 = 0.217417;
  Y1 = 0.686389;
  A3 = PI - 0.760164;
  A4 = PI + 0.760164;
  
var 
  ctx: pcairo_t;
  sfc: pcairo_surface_t;
  i: integer;

begin
  sfc := cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SURF_W, SURF_H);
  ctx := cairo_create(sfc);
  
  cairo_scale(ctx, SURF_W div 2, SURF_H div 2);
  cairo_translate(ctx, 1.0, 1.0);
  
  cairo_set_source_rgb(ctx, 1.0, 1.0, 1.0);
  cairo_paint(ctx);
  
  cairo_set_line_width(ctx, 1 / 200); 
  cairo_set_source_rgb(ctx, 0.5, 0.5, 0.5);
  
  cairo_move_to(ctx, -0.9, -0.0);
  cairo_line_to(ctx,  0.9,  0.0);
  cairo_move_to(ctx,  0.0, -0.9);
  cairo_line_to(ctx,  0.0,  0.9);
  
  cairo_move_to(ctx, -0.9, -0.9);
  cairo_line_to(ctx,  0.9,  0.9);
  cairo_move_to(ctx, -0.9,  0.9);
  cairo_line_to(ctx,  0.9, -0.9);
  
  cairo_stroke(ctx);
  
  cairo_arc(ctx, 0.0, 0.0, R1, 0, 2 * PI);
  cairo_arc(ctx, 0.0, 0.0, R2, 0, 2 * PI);
  cairo_arc(ctx, 0.0, 0.0, R3, 0, 2 * PI);
  cairo_arc(ctx, 0.0, 0.0, R4, 0, 2 * PI);
  
  cairo_stroke(ctx);
  
  cairo_rotate(ctx, PI / 4);
  for i := 1 to 4 do
  begin
    cairo_arc(ctx, 0.0, R1, R5, 0, 2 * PI); cairo_stroke(ctx);
    cairo_rotate(ctx, PI / 2);
  end;
  
  for i := 1 to 4 do
  begin
    cairo_arc(ctx, 0.0, R1, R6, A1, A2); cairo_stroke(ctx);
    cairo_rotate(ctx, PI / 2);
  end;
  
  for i := 1 to 4 do
  begin
    cairo_arc(ctx, X1, Y1, R8, A3, A4); cairo_stroke(ctx);
    cairo_arc(ctx, -X1, Y1, R8, PI + A3, PI + A4); cairo_stroke(ctx);
    cairo_rotate(ctx, PI / 2);
  end;
  
  cairo_surface_write_to_png(sfc, pchar('image.png'));
  
  cairo_destroy(ctx);
  cairo_surface_destroy(sfc);
end.
